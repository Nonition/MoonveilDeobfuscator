from harness import Harness, BASE, HERE, REFERENCE_SOURCE
from pathlib import Path
import json, difflib, os

REBUILT = Path(
    os.environ.get(
        "MOONVEIL_SUBJECT", str(HERE.parent / "rideafish" / "auto_recovered.lua")
    )
).read_text()
ORIGINAL = REFERENCE_SOURCE
passed = []


def compare(label, a, b, logs=True):
    x = {
        "objects": a.snapshot(),
        "spawned": len(a.sim.spawned),
        "files": a.plain(a.sim.files),
    }
    y = {
        "objects": b.snapshot(),
        "spawned": len(b.sim.spawned),
        "files": b.plain(b.sim.files),
    }
    if logs:
        x["log"] = a.log()
        y["log"] = b.log()
    if x != y:
        diff = "\n".join(
            difflib.unified_diff(
                json.dumps(x, indent=2, ensure_ascii=False).splitlines(),
                json.dumps(y, indent=2, ensure_ascii=False).splitlines(),
                fromfile="original",
                tofile="reconstructed",
            )
        )
        (BASE / "last_test_diff.txt").write_text(diff)
        raise AssertionError(label + "\n" + diff[:12000])
    passed.append(label)
    print("PASS", label)


def pair(saved=True, setup=None):
    hs = [Harness(), Harness()]
    for h, src in zip(hs, (ORIGINAL, REBUILT)):
        if setup:
            setup(h)
        h.run(src, saved=saved)
    return hs


def click_by_text(h, text):
    label = h.sim.findText(text)
    if label.ClassName == "TextButton":
        button = label
    else:
        button = next(
            ch
            for _, ch in label.Parent.children.items()
            if ch.ClassName == "TextButton"
        )
    return h.sim.fire(button, "MouseButton1Click")


def run_spawn(h, n):
    result = h.sim.start(h.sim.spawned[n].fn)
    return result[0] if isinstance(result, tuple) else result


def steps(h, co, n):
    for _ in range(n):
        h.reset_budget()
        h.sim.step(co)


if __name__ == "__main__":
    a, b = pair()
    compare("saved key: full initial UI", a, b)
    for text in (
        "-",
        "+",
        "\u25bc",
        "\u25b2",
        "Common Egg",
        "Seraph Egg",
        "Common Egg",
        "COLLECT TOKENS",
        "COLLECT TOKENS",
        "AUTO REBIRTH",
        "SELL ALL",
    ):
        for h in (a, b):
            click_by_text(h, text)
        compare("UI click: " + text, a, b)
    for h in (a, b):
        layout = h.sim.objects[31]
        layout.AbsoluteContentSize = h.sim.vector(100, 456, 0)
        h.sim.fire(layout, "property:AbsoluteContentSize")
    compare("egg list automatic size callback", a, b)

    a, b = pair(saved=False)
    compare("key dialog: initial UI", a, b)
    for h in (a, b):
        h.sim.objects[22].Text = "WRONG"
        click_by_text(h, "Verify")
    compare("key dialog: wrong key", a, b)
    for h in (a, b):
        h.sim.key = " T E S T _ K E Y \n"
        h.sim.objects[22].Text = "TEST_KEY"
        click_by_text(h, "Verify")
    compare("key dialog: correct key and whitespace removal", a, b)

    for no_clipboard in (False, True):
        a, b = pair(
            saved=False,
            setup=(
                (lambda h: setattr(h.sim.env, "setclipboard", None))
                if no_clipboard
                else None
            ),
        )
        for h in (a, b):
            threads = click_by_text(h, "Get Key Link")
            steps(h, threads[1], 1)
        compare("key link callback: clipboard " + str(not no_clipboard), a, b)

    for stored in ("not-a-number", "1999800000", "1999913600", "2000010000"):
        a, b = pair(
            saved=False,
            setup=lambda h, s=stored: h.sim.files.__setitem__(
                "GamingSpirit_KeySystem.txt", s
            ),
        )
        compare("saved key value: " + stored, a, b)

    for http_error, key_value in ((True, "GamingSpiritOnTop"), (False, "")):
        a, b = pair(saved=False)
        for h in (a, b):
            h.sim.httpError = http_error
            h.sim.key = ""
            h.sim.objects[22].Text = key_value
            click_by_text(h, "Verify")
        compare("key endpoint fixture: error=" + str(http_error), a, b)

    for index in (1, 2, 3, 4):
        a, b = pair()
        for h in (a, b):
            co = run_spawn(h, index)
            steps(h, co, 2)
        compare("background task " + str(index) + ": disabled", a, b)

    for text, index, count in (
        ("COLLECT TOKENS", 2, 2),
        ("AUTO REBIRTH", 3, 3),
        ("SELL ALL", 4, 2),
    ):
        a, b = pair()
        for h in (a, b):
            click_by_text(h, text)
            co = run_spawn(h, index)
            steps(h, co, count)
        compare("background task: " + text, a, b)

    print("Passed", len(passed), "differential scenarios")
    (BASE / "test_results.json").write_text(
        json.dumps({"passed": passed, "count": len(passed)}, indent=2)
    )
