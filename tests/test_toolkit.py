"""Synthetic profile/negative tests. These are NOT additional real MoonVeil samples."""

import contextlib
import io
import json
from pathlib import Path
import tempfile
import unittest
from moonveil.front import Unsupported, normalize, parse
from moonveil.staticlua import Evaluator, Returned
from moonveil.pipeline import process
from moonveil.cli import main


def synthetic(seed=0, collision=False, unsupported=False):
    cache = "cache" + str(seed)
    decoder = "decode" + str(seed)
    worker = "worker" + str(seed)
    entry = "entry" + str(seed)
    boot = "boot" + str(seed)
    start = 7 + seed * 20
    yes = start + 2
    no = start + 5
    second = (
        ("self." + cache + "[1] or self:" + decoder + "(99,1,1)")
        if collision
        else "input"
    )
    select = "input" if unsupported else f"flag and {yes} or {no}"
    return f"""-- Synthetic fixture for the supported table-dispatch shape, not vendor output.
return ({{
{cache} = {{}},
{decoder} = function(self,a,b,k) self.{cache}[k]=a-b return self.{cache}[k] end,
{worker} = function(self) return function(input)
 local state, flag
 state=self.{cache}[1] or self:{decoder}({start+10},10,1)
 while true do
  if state < {yes} then
   flag={second}
   state={select}
   flag=not flag
  elseif state < {no} then return flag
  else return self.{cache}[2] or self:{decoder}(52,10,2)
  end
 end
end end,
{entry} = function(self,...) return self:{worker}()(...) end,
{boot} = function(self,names,entry,...) return self[entry](self,...) end
}}):{boot}({{}}, "{entry}", ...)
""".encode()


def run_pure(source, *args):
    evaluator = Evaluator(max_steps=100000, seconds=5)
    evaluator.env.varargs = args
    try:
        evaluator.block(parse(normalize(source))["body"], evaluator.env)
    except Returned as r:
        return r.values
    return ()


class FrontTests(unittest.TestCase):
    def test_binary_boundaries(self):
        text = b'local x=0x1240b0d0; local b=0b101 -- 0b11\nlocal s="0b11"; local l=[=[0b11]=]'
        result = normalize(text)
        self.assertIn(b"0x1240b0d0", result)
        self.assertIn(b"b=5", result)
        self.assertIn(b"-- 0b11", result)
        self.assertIn(b'"0b11"', result)
        self.assertIn(b"[=[0b11]=]", result)
        parse(result)

    def test_long_comment(self):
        self.assertEqual(
            normalize(b"--[==[ 0b10 ]==]\nreturn 0b10"), b"--[==[ 0b10 ]==]\nreturn 2"
        )

    def test_invalid_binary(self):
        with self.assertRaises(Unsupported):
            normalize(b"return 0b11oops")

    def test_unclosed_string(self):
        with self.assertRaises(Unsupported):
            normalize(b'return "hello')

    def test_grouped_multireturn(self):
        self.assertEqual(run_pure(b"return (function() return 1,2 end)()"), (1.0, 2.0))
        self.assertEqual(run_pure(b"return ((function() return 1,2 end)())"), (1.0,))

    def test_zero_truth_and_types(self):
        self.assertEqual(
            run_pure(b"return not 0, 0==false, nil==0, (0 and 7)"),
            (False, False, False, 7.0),
        )

    def test_environment_read_denied(self):
        with self.assertRaises(Unsupported):
            run_pure(b'return getfenv().os.execute("not executed")')

    def test_string_allocation_limit(self):
        with self.assertRaises(Unsupported):
            run_pure(b'return string.rep("A",100000000)')

    def test_instruction_limit(self):
        evaluator = Evaluator(max_steps=1000)
        with self.assertRaises(Unsupported):
            evaluator.block(parse(b"while true do end")["body"], evaluator.env)


class ProfileTests(unittest.TestCase):
    def test_changed_names_and_state_ids(self):
        for seed in range(5):
            with self.subTest(seed=seed):
                original = synthetic(seed)
                result = process(original)
                self.assertEqual(result["report"]["status"], "recovered_unverified")
                self.assertFalse(result["report"]["payload_executed"])
                self.assertFalse(result["report"]["universal_support"])
                for arg in (True, False, None, 0.0, b""):
                    self.assertEqual(
                        run_pure(original, arg), run_pure(result["recovered"], arg)
                    )

    def test_conflicting_cache_refused(self):
        with self.assertRaisesRegex(Unsupported, "Conflicting"):
            process(synthetic(collision=True))

    def test_unknown_dispatcher_not_labeled_complete(self):
        result = process(synthetic(unsupported=True))
        self.assertEqual(result["report"]["status"], "decoded_partial")
        self.assertNotIn("recovered", result)

    def test_non_profile_rejected(self):
        with self.assertRaises(Unsupported):
            process(b'print("ordinary Lua")')


class CLITests(unittest.TestCase):
    def invoke(self, args):
        with contextlib.redirect_stdout(io.StringIO()), contextlib.redirect_stderr(
            io.StringIO()
        ):
            return main(args)

    def test_cli_output_and_report(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            (p / "in.lua").write_bytes(synthetic())
            self.assertEqual(
                self.invoke(
                    ["deobfuscate", str(p / "in.lua"), "-o", str(p / "result.lua")]
                ),
                0,
            )
            self.assertTrue((p / "result.lua").exists())
            report = json.loads((p / "result.lua.report.json").read_text())
            self.assertEqual(report["status"], "recovered_unverified")
            self.assertIn("output_sha256", report)

    def test_strict_unknown_no_final_file(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            (p / "in.lua").write_bytes(synthetic(unsupported=True))
            self.assertEqual(
                self.invoke(
                    ["deobfuscate", str(p / "in.lua"), "-o", str(p / "result.lua")]
                ),
                2,
            )
            self.assertFalse((p / "result.lua").exists())

    def test_require_verified_no_file(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            (p / "in.lua").write_bytes(synthetic())
            self.assertEqual(
                self.invoke(
                    [
                        "deobfuscate",
                        str(p / "in.lua"),
                        "-o",
                        str(p / "result.lua"),
                        "--require-verified",
                    ]
                ),
                3,
            )
            self.assertFalse((p / "result.lua").exists())

    def test_existing_file_preserved(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            (p / "in.lua").write_bytes(synthetic())
            (p / "result.lua").write_text("keep this")
            self.assertEqual(
                self.invoke(
                    ["deobfuscate", str(p / "in.lua"), "-o", str(p / "result.lua")]
                ),
                2,
            )
            self.assertEqual((p / "result.lua").read_text(), "keep this")

    def test_input_never_overwritten(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td) / "source.lua"
            source = synthetic()
            p.write_bytes(source)
            self.assertEqual(
                self.invoke(["deobfuscate", str(p), "-o", str(p), "--force"]), 2
            )
            self.assertEqual(p.read_bytes(), source)

    def test_analysis_package(self):
        with tempfile.TemporaryDirectory() as td:
            p = Path(td)
            (p / "in.lua").write_bytes(synthetic())
            self.assertEqual(
                self.invoke(["analyze", str(p / "in.lua"), "-o", str(p / "analysis")]),
                0,
            )
            self.assertTrue((p / "analysis" / "AI_HANDOFF.txt").is_file())
            self.assertTrue((p / "analysis" / "decoded.partial.lua").is_file())


if __name__ == "__main__":
    unittest.main()
