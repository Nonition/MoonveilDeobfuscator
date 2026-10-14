"""Explicit opt-in replay of ONE audited sample inside local API mocks.

This uses a real Lua VM for testing. It is not the static engine, not used by the
Discord worker, and not a secure general-purpose sandbox for arbitrary uploads.
"""

import argparse
import hashlib
import json
import os
from pathlib import Path
import subprocess
import sys
import tempfile

ROOT = Path(__file__).resolve().parents[1]
FIXTURE = ROOT / "research" / "rideafish" / "input.obfuscated.lua"
EXPECTED = "f235e3843beba872fb69bc2fcc1bc66651ebfeba8a37fd58f366dbb04ed12a4c"


def main():
    parser = argparse.ArgumentParser()
    parser.add_argument(
        "--trusted-fixture",
        action="store_true",
        help="acknowledge that this optional test executes mocked Lua",
    )
    parser.add_argument(
        "--subject",
        type=Path,
        default=ROOT / "research" / "rideafish" / "auto_recovered.lua",
    )
    parser.add_argument(
        "-o", "--output", type=Path, default=ROOT / "regression-report.json"
    )
    args = parser.parse_args()
    if not args.trusted_fixture:
        parser.error("Read this script and pass --trusted-fixture to opt in.")
    if hashlib.sha256(FIXTURE.read_bytes()).hexdigest() != EXPECTED:
        parser.error(
            "Reference fixture hash differs from the audited sample; refusing execution."
        )
    import importlib.util

    try:
        has_luajit = importlib.util.find_spec("lupa.luajit21") is not None
    except ModuleNotFoundError:
        has_luajit = False
    if not has_luajit:
        parser.error(
            "Optional tests require a Lupa build with luajit21; install requirements-regression.txt."
        )
    suite = ROOT / "research" / "regression"
    with tempfile.TemporaryDirectory(prefix="moonveil-replay-") as tmp:
        env = os.environ.copy()
        env["MOONVEIL_SUBJECT"] = str(args.subject.resolve())
        env["MOONVEIL_TEST_OUTPUT"] = tmp
        env["PYTHONPATH"] = str(ROOT) + os.pathsep + str(suite)
        for name in ("test_equivalence.py", "test_edge_cases.py"):
            completed = subprocess.run(
                [sys.executable, str(suite / name)],
                cwd=ROOT,
                env=env,
                capture_output=True,
                text=True,
                timeout=60,
            )
            print(completed.stdout, end="")
            if completed.returncode:
                print(completed.stderr, file=sys.stderr)
                raise SystemExit(completed.returncode)
        report = json.loads((Path(tmp) / "test_results_full.json").read_text())
    report.update(
        reference_sha256=EXPECTED,
        subject_sha256=hashlib.sha256(args.subject.read_bytes()).hexdigest(),
        scope="One RideAFish sample; mocked Roblox APIs, not a real game; not proof of universal support.",
    )
    args.output.parent.mkdir(parents=True, exist_ok=True)
    args.output.write_text(json.dumps(report, indent=2) + "\n")
    print("Saved", args.output)


if __name__ == "__main__":
    main()
