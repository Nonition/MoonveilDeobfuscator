"""Binary-safe Lua front end. No user-supplied Lua code is executed."""

from __future__ import annotations
import json
import os
import re
import shutil
import subprocess
from pathlib import Path


class Unsupported(Exception):
    """Fail closed on an unsupported or ambiguous input."""


MAX_INPUT = 2 * 1024 * 1024
LONG = re.compile(rb"\[(=*)\[")


def normalize(source: bytes) -> bytes:
    """Normalize Luau binary literals without touching strings/comments/hex numbers."""
    if len(source) > MAX_INPUT:
        raise Unsupported("Input exceeds the 2 MiB limit")
    if source.startswith(b"\xef\xbb\xbf"):
        source = source[3:]
    out = bytearray()
    i = 0
    while i < len(source):
        start = i
        comment = source[i : i + 2] == b"--"
        pos = i + 2 if comment else i
        long = LONG.match(source, pos)
        if long:
            endmark = b"]" + long[1] + b"]"
            end = source.find(endmark, long.end())
            if end < 0:
                raise Unsupported("Unterminated long string/comment")
            i = end + len(endmark)
        elif comment:
            end = source.find(b"\n", i)
            i = len(source) if end < 0 else end + 1
        elif source[i : i + 1] in (b'"', b"'"):
            quote = source[i]
            i += 1
            while i < len(source):
                if source[i] == 92:
                    i += 2
                elif source[i] == quote:
                    i += 1
                    break
                else:
                    i += 1
            else:
                raise Unsupported("Unterminated quoted string")
        else:
            m = re.match(rb"0[bB][01]+", source[i:])
            before = source[i - 1 : i] if i else b""
            if m and not (before and (before.isalnum() or before == b"_")):
                end = i + len(m[0])
                after = source[end : end + 1]
                if after and (after.isalnum() or after == b"_"):
                    raise Unsupported("Invalid binary numeric literal")
                if len(m[0]) > 55:
                    raise Unsupported(
                        "Binary literal exceeds exact double-precision range"
                    )
                out.extend(str(int(m[0][2:], 2)).encode("ascii"))
                i = end
                continue
            i += 1
        out.extend(source[start:i])
    return bytes(out)


def parse(source: bytes, timeout: int = 20) -> dict:
    node = shutil.which(os.environ.get("MOONVEIL_NODE", "node"))
    if not node:
        raise Unsupported("Node.js 18+ is required; install Node or set MOONVEIL_NODE")
    bridge = Path(__file__).with_name("vendor") / "parse.cjs"
    try:
        p = subprocess.run(
            [node, "--max-old-space-size=192", str(bridge)],
            input=source,
            stdout=subprocess.PIPE,
            stderr=subprocess.PIPE,
            timeout=timeout,
            check=False,
        )
    except subprocess.TimeoutExpired as error:
        raise Unsupported("Parser time limit exceeded") from error
    if p.returncode:
        raise Unsupported(
            "Lua parse failed: " + p.stderr.decode("utf-8", "replace")[:2000]
        )
    if len(p.stdout) > 96 * 1024 * 1024:
        raise Unsupported("AST exceeds resource limit")
    try:
        return json.loads(p.stdout)
    except (ValueError, RecursionError) as error:
        raise Unsupported("Invalid or excessively nested AST") from error


def walk(node):
    if isinstance(node, dict):
        yield node
        for key, value in node.items():
            if key not in ("range", "loc", "comments"):
                yield from walk(value)
    elif isinstance(node, list):
        for item in node:
            yield from walk(item)


def lua_bytes(value: str) -> bytes:
    # luaparse x-user-defined maps bytes 0x80..0xff to U+F780..U+F7FF.
    return bytes(
        ord(c) - 0xF700 if 0xF780 <= ord(c) <= 0xF7FF else ord(c) for c in value
    )


def quote(value: bytes) -> str:
    parts = ['"']
    for b in value:
        if b == 34:
            parts.append('\\"')
        elif b == 92:
            parts.append("\\\\")
        elif b == 10:
            parts.append("\\n")
        elif b == 13:
            parts.append("\\r")
        elif b == 9:
            parts.append("\\t")
        elif b < 32 or b > 126:
            parts.append("\\%03d" % b)
        else:
            parts.append(chr(b))
    return "".join(parts) + '"'
