from test_equivalence import (
    pair,
    compare,
    click_by_text,
    run_spawn,
    steps,
    passed,
    BASE,
    ORIGINAL,
    REBUILT,
)
import json


def fire_count(h, action):
    return sum(
        1
        for entry in h.log()
        if len(entry) > 2
        and entry[0] in ("FireServer", "InvokeServer")
        and entry[2] == action
    )


def egg_fixture(
    h,
    name,
    kind="Model",
    location="wild",
    prompt=True,
    duration=0.6,
    far=False,
    prompt_kind=None,
):
    sim = h.sim
    parent = sim.wildEggs if location == "wild" else sim.services.Workspace
    if location == "excluded":
        parent = sim.newNode("Folder", "OtherRuntimeFolder", sim.eggRuntime)
    target = sim.newNode(kind, name, parent)
    target.CFrame = sim.cframe(20, 10, 30)
    target.Pivot = target.CFrame
    target.Position = target.CFrame.Position
    if prompt:
        prompt_parent = target
        if prompt_kind:
            prompt_parent = sim.newNode(prompt_kind, "PromptHolder", target)
            prompt_parent.Position = sim.vector(1000 if far else 20, 10, 30)
            prompt_parent.Pivot = sim.cframe(prompt_parent.Position)
        elif far:
            prompt_parent = sim.newNode("Part", "FarPromptHolder", target)
            prompt_parent.Position = sim.vector(1000, 10, 30)
            prompt_parent.Pivot = sim.cframe(prompt_parent.Position)
        prompt_node = sim.newNode("ProximityPrompt", "PickupPrompt", prompt_parent)
        prompt_node.HoldDuration = duration
    return target


cases = [
    (
        "normal model",
        "Common Egg",
        "Common Egg #1",
        "Model",
        "wild",
        True,
        0.6,
        False,
        None,
        True,
    ),
    (
        "normal part zero hold",
        "Coral Egg",
        "CORAL EGG PART",
        "Part",
        "wild",
        True,
        0,
        False,
        None,
        True,
    ),
    (
        "prompt model parent",
        "Reef Egg",
        "Reef Egg",
        "Model",
        "wild",
        True,
        2,
        False,
        "Model",
        True,
    ),
    (
        "prompt basepart parent",
        "Tidal Egg",
        "Tidal Egg",
        "Model",
        "wild",
        True,
        0.1,
        False,
        "Part",
        True,
    ),
    ("no prompt", "Deep Egg", "Deep Egg", "Part", "wild", False, 0, False, None, True),
    (
        "far prompt ignored",
        "Abyss Egg",
        "Abyss Egg",
        "Model",
        "wild",
        True,
        0,
        True,
        None,
        True,
    ),
    (
        "nonphysical prompt parent",
        "Trench Egg",
        "Trench Egg",
        "Model",
        "wild",
        True,
        0,
        False,
        "Folder",
        True,
    ),
    (
        "unsupported target class",
        "Common Egg",
        "Common Egg",
        "Folder",
        "wild",
        False,
        0,
        False,
        None,
        False,
    ),
    (
        "Kraken wild alias",
        "KrakenGlory Egg",
        "KrakenGlory_Variant",
        "Model",
        "wild",
        True,
        0,
        False,
        None,
        True,
    ),
    (
        "Seraph wild alias",
        "Seraph Egg",
        "AdminAbuseSeraph_1",
        "Part",
        "wild",
        True,
        0,
        False,
        None,
        True,
    ),
    (
        "Seraph normal alias",
        "Seraph Egg",
        "SpecialSeraph_1",
        "Model",
        "wild",
        True,
        1,
        False,
        None,
        True,
    ),
    (
        "Kraken external fallback",
        "KrakenGlory Egg",
        "KRAKENGLORY_External",
        "Model",
        "external",
        True,
        0,
        False,
        None,
        True,
    ),
    (
        "Seraph external fallback",
        "Seraph Egg",
        "AdminAbuseSeraph_External",
        "Part",
        "external",
        True,
        0,
        False,
        None,
        True,
    ),
    (
        "runtime excluded fallback",
        "Seraph Egg",
        "AdminAbuseSeraph_Hidden",
        "Model",
        "excluded",
        False,
        0,
        False,
        None,
        False,
    ),
    (
        "normal egg no external fallback",
        "Common Egg",
        "Common Egg",
        "Model",
        "external",
        False,
        0,
        False,
        None,
        False,
    ),
    (
        "unmatched wild name",
        "Common Egg",
        "Unrelated object",
        "Model",
        "wild",
        False,
        0,
        False,
        None,
        False,
    ),
]
for (
    label,
    selection,
    name,
    kind,
    location,
    prompt,
    duration,
    far,
    prompt_kind,
    expected,
) in cases:
    a, b = pair()
    for h in (a, b):
        egg_fixture(h, name, kind, location, prompt, duration, far, prompt_kind)
        click_by_text(h, selection)
        co = run_spawn(h, 1)
        steps(h, co, 6)
        assert bool(fire_count(h, "StoreEgg")) == expected, (
            label,
            "unexpected action count",
            h.log(),
        )
    compare("egg: " + label, a, b)

for missing in ("root", "character", "runtime", "wild folder"):
    a, b = pair()
    for h in (a, b):
        egg_fixture(h, "Common Egg")
        if missing == "root":
            h.sim.root.Parent = None
        elif missing == "character":
            h.sim.player.Character = None
        elif missing == "runtime":
            h.sim.eggRuntime.Parent = None
        else:
            h.sim.wildEggs.Parent = None
        click_by_text(h, "Common Egg")
        co = run_spawn(h, 1)
        steps(h, co, 6)
    compare("egg fixture missing: " + missing, a, b)

for variant in (
    "part",
    "model primary",
    "model pivot",
    "other",
    "no root",
    "no folder",
    "respawn",
):
    a, b = pair()
    for h in (a, b):
        kind = (
            "Part"
            if variant == "part"
            else (
                "Model"
                if variant.startswith("model")
                else "Folder" if variant == "other" else "Part"
            )
        )
        token = h.sim.newNode(kind, "TokenFixture", h.sim.tokens)
        token.Position = h.sim.vector(5, 7, 9)
        token.Pivot = h.sim.cframe(5, 7, 9)
        if variant == "model primary":
            p = h.sim.newNode("Part", "Primary", token)
            p.Position = h.sim.vector(5, 7, 9)
            token.PrimaryPart = p
        elif variant == "no root":
            h.sim.root.Parent = None
        elif variant == "no folder":
            h.sim.tokens.Parent = None
        elif variant == "respawn":
            h.sim.player.Character = None
        click_by_text(h, "COLLECT TOKENS")
        co = run_spawn(h, 2)
        steps(h, co, 1)
        if variant not in ("other", "no root", "no folder"):
            assert h.sim.root.CFrame.Position.Y == 10
    compare("token: " + variant, a, b)

for quote in (
    None,
    False,
    "invalid",
    {"ok": False, "count": 2, "token": "t"},
    {"ok": True, "count": 0, "token": "t"},
    {"ok": True, "count": 2},
    {"ok": True, "token": "t"},
    {"ok": True, "count": 2, "token": ""},
):
    a, b = pair()
    for h in (a, b):
        h.sim.fishRequest.Response = (
            h.lua.table_from(quote) if isinstance(quote, dict) else quote
        )
        click_by_text(h, "SELL ALL")
        co = run_spawn(h, 4)
        steps(h, co, 1)
    compare("sell quote: " + repr(quote), a, b)
a, b = pair()
for h in (a, b):
    h.sim.fishRequest.InvokeError = "mock server failure"
    click_by_text(h, "SELL ALL")
    co = run_spawn(h, 4)
    steps(h, co, 1)
compare("sell quote: server error", a, b)

for api in ("isfile", "readfile", "writefile"):
    a, b = pair(saved=False, setup=lambda h, k=api: h.sim.env.__setitem__(k, None))
    for h in (a, b):
        h.sim.objects[22].Text = "TEST_KEY"
        click_by_text(h, "Verify")
    compare("optional API missing: " + api, a, b)

for device in ("MouseButton1", "Touch", "Keyboard"):
    a, b = pair(saved=False)
    for h in (a, b):
        sim = h.sim
        begin = sim.newNode("InputObject", "InputFixture")
        begin.Position = sim.vector(10, 20, 0)
        begin.UserInputType = sim.env.Enum.UserInputType[device]
        begin.UserInputState = sim.env.Enum.UserInputState.Begin
        sim.fire(sim.objects[19], "InputBegan", begin)
        motion = sim.newNode("InputObject", "MotionFixture")
        motion.Position = sim.vector(45, 65, 0)
        motion.UserInputType = (
            sim.env.Enum.UserInputType.Touch
            if device == "Touch"
            else sim.env.Enum.UserInputType.MouseMovement
        )
        sim.fire(sim.services.UserInputService, "InputChanged", motion)
        if device != "Keyboard":
            assert sim.objects[19].Position.X.Offset == -65
            begin.UserInputState = sim.env.Enum.UserInputState.End
            sim.fire(begin, "Changed")
            motion.Position = sim.vector(100, 100, 0)
            sim.fire(sim.services.UserInputService, "InputChanged", motion)
            assert sim.objects[19].Position.X.Offset == -65
    compare("drag callback: " + device, a, b)

a, b = pair()
for h, src in ((a, ORIGINAL), (b, REBUILT)):
    h.run(src)
compare("second execution replaces existing hub", a, b)

previous = json.loads((BASE / "test_results.json").read_text())
all_tests = previous["passed"] + passed
(BASE / "test_results_full.json").write_text(
    json.dumps(
        {"passed": all_tests, "count": len(all_tests), "live_roblox_tested": False},
        indent=2,
    )
)
print("TOTAL", len(all_tests), "passing differential scenarios")
