"""Async adapter: local files only, no shell, bounded jobs, no source evaluation."""

from __future__ import annotations
import asyncio
from dataclasses import dataclass
import io
import json
import os
from pathlib import Path
import signal
import subprocess
import sys
import tempfile
import zipfile

ROOT = Path(__file__).resolve().parents[1]
MAX_UPLOAD = 512 * 1024
MAX_RESULT = 8 * 1024 * 1024


@dataclass
class Result:
    report: dict
    filename: str | None = None
    payload: bytes | None = None


async def stop_tree(proc):
    if proc.returncode is not None:
        return
    if os.name == "posix":
        try:
            os.killpg(proc.pid, signal.SIGKILL)
        except ProcessLookupError:
            pass
    else:
        taskkill = (
            Path(os.environ.get("SystemRoot", r"C:\Windows"))
            / "System32"
            / "taskkill.exe"
        )
        try:
            killer = await asyncio.create_subprocess_exec(
                str(taskkill),
                "/PID",
                str(proc.pid),
                "/T",
                "/F",
                stdout=asyncio.subprocess.DEVNULL,
                stderr=asyncio.subprocess.DEVNULL,
            )
            await killer.wait()
        except OSError:
            proc.kill()
    await proc.wait()


async def run_job(contents: bytes, mode="deobfuscate") -> Result:
    if mode not in ("deobfuscate", "analyze"):
        raise ValueError("Unknown mode")
    if not contents or len(contents) > MAX_UPLOAD:
        return Result({"status": "unsupported", "reason": "Upload must be 1..512 KiB"})
    with tempfile.TemporaryDirectory(prefix="moonveil-job-") as folder:
        job = Path(folder)
        (job / "input.lua").write_bytes(contents)
        output = job / (
            "Moonveil_Deobfuscated.lua" if mode == "deobfuscate" else "analysis"
        )
        report = job / "report.json"
        image = os.environ.get("MOONVEIL_WORKER_IMAGE")
        if image:
            args = [
                "docker",
                "run",
                "--rm",
                "--cidfile",
                str(job / "container.id"),
                "--network",
                "none",
                "--read-only",
                "--cap-drop",
                "ALL",
                "--security-opt",
                "no-new-privileges",
                "--memory",
                "512m",
                "--cpus",
                "1",
                "--pids-limit",
                "48",
                "--tmpfs",
                "/tmp:rw,noexec,nosuid,size=64m",
            ]
            if os.name == "posix":
                args += ["--user", f"{os.getuid()}:{os.getgid()}"]
            args += [
                "-v",
                f"{job.resolve()}:/work:rw",
                image,
                mode,
                "/work/input.lua",
                "-o",
                "/work/" + output.name,
                "--report",
                "/work/report.json",
                "--seconds",
                "45",
                "--max-steps",
                "30000000",
            ]
        else:
            args = [
                sys.executable,
                "-m",
                "moonveil",
                mode,
                str(job / "input.lua"),
                "-o",
                str(output),
                "--report",
                str(report),
                "--seconds",
                "45",
                "--max-steps",
                "30000000",
            ]
        # Do not pass Discord/GitHub/API secrets or NODE_OPTIONS into the worker.
        allowed = (
            "PATH",
            "SystemRoot",
            "SYSTEMROOT",
            "WINDIR",
            "COMSPEC",
            "HOME",
            "USERPROFILE",
            "TEMP",
            "TMP",
            "LANG",
            "LC_ALL",
            "DOCKER_HOST",
            "DOCKER_CONTEXT",
            "DOCKER_CONFIG",
        )
        env = {k: os.environ[k] for k in allowed if k in os.environ}
        env["PYTHONPATH"] = str(ROOT)
        options = (
            {"start_new_session": True}
            if os.name == "posix"
            else {"creationflags": subprocess.CREATE_NEW_PROCESS_GROUP}
        )
        try:
            proc = await asyncio.create_subprocess_exec(
                *args,
                cwd=str(ROOT),
                env=env,
                stdout=asyncio.subprocess.PIPE,
                stderr=asyncio.subprocess.PIPE,
                **options,
            )
            try:
                stdout, stderr = await asyncio.wait_for(proc.communicate(), timeout=110)
            except (asyncio.TimeoutError, asyncio.CancelledError):
                await stop_tree(proc)
                if image and (job / "container.id").exists():
                    cid = (job / "container.id").read_text().strip()
                    if len(cid) == 64 and all(c in "0123456789abcdef" for c in cid):
                        cleanup = await asyncio.create_subprocess_exec(
                            "docker",
                            "rm",
                            "-f",
                            cid,
                            stdout=asyncio.subprocess.DEVNULL,
                            stderr=asyncio.subprocess.DEVNULL,
                        )
                        await cleanup.wait()
                raise
        except asyncio.TimeoutError:
            return Result(
                {"status": "unsupported", "reason": "Worker time limit exceeded"}
            )
        except OSError as e:
            return Result({"status": "internal_error", "reason": str(e)[:500]})
        info = (
            json.loads(report.read_text())
            if report.exists()
            else {
                "status": "internal_error",
                "reason": stderr.decode("utf-8", "replace")[-1500:]
                or "Worker produced no report",
            }
        )
        if proc.returncode != 0:
            return Result(info)
        if mode == "deobfuscate":
            if info.get("status") != "recovered_unverified" or not output.is_file():
                return Result(info)
            if output.stat().st_size > MAX_RESULT:
                return Result({"status": "unsupported", "reason": "Result too large"})
            return Result(info, output.name, output.read_bytes())
        buffer = io.BytesIO()
        total = 0
        with zipfile.ZipFile(buffer, "w", zipfile.ZIP_DEFLATED) as archive:
            for file in sorted(output.rglob("*")):
                if file.is_file() and not file.is_symlink():
                    total += file.stat().st_size
                    if total > MAX_RESULT:
                        return Result(
                            {
                                "status": "unsupported",
                                "reason": "Analysis bundle too large",
                            }
                        )
                    archive.write(file, str(file.relative_to(output)))
        return Result(info, "Moonveil_Analysis.zip", buffer.getvalue())
