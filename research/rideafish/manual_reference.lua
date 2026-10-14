-- Moonveil_Deobfuscated.lua
-- Readable reconstruction of the supplied RideAFish / MoonVeil 2.0.26 script.
-- Input SHA-256: f235e3843beba872fb69bc2fcc1bc66651ebfeba8a37fd58f366dbb04ed12a4c
-- Original labels, key checks, URLs, game calls, timings and UI values are retained.
-- Identifier names are reconstructed; original pre-obfuscation names are unavailable.
-- Requires the same Roblox client/executor APIs as the input, not standalone Lua.
-- Validation: Lua 5.1 syntax and 74 passing differential scenarios against the input
-- in network-free Roblox API mocks. Live Roblox execution has not been verified.
-- No live Roblox server or external key endpoint was contacted during testing.

local KEY_FILE = "GamingSpirit_KeySystem.txt"
local KEY_URL = "https://pastebin.com/raw/3Yk4R5xS"
local KEY_LINK = "https://lootdest.org/s?LqaMr3vF"
local KEY_LIFETIME = 86400

local EGG_NAMES = {
    "Common Egg",
    "Coral Egg",
    "Reef Egg",
    "Tidal Egg",
    "Deep Egg",
    "Abyss Egg",
    "Trench Egg",
    "Sovereign Egg",
    "Celestial Egg",
    "Eternal Egg",
    "CoralReef Egg",
    "GlacialSpiral Egg",
    "AmethystSpiral Egg",
    "AzureCrown Egg",
    "SolarOrbit Egg",
    "Spikey Egg",
    "Mamba Egg",
    "Inferno Egg",
    "KrakenGlory Egg",
    "Seraph Egg"
}

local function addCorner(parent, radius)
    local corner = Instance.new("UICorner")
    if radius then
        corner.CornerRadius = UDim.new(0, radius)
    end
    corner.Parent = parent
    return corner
end

local function makeDraggable(frame)
    local inputService = game:GetService("UserInputService")
    local dragging, dragStart, frameStart

    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            frameStart = frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    inputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                frameStart.X.Scale, frameStart.X.Offset + delta.X,
                frameStart.Y.Scale, frameStart.Y.Offset + delta.Y
            )
        end
    end)
end

local function fetchKey()
    local success, response = pcall(function()
        return game:HttpGet(KEY_URL)
    end)
    return (success and response and response:gsub("%s+", "")) or "GamingSpiritOnTop"
end

local function showKeySystem(onVerified)
    if isfile and readfile and isfile(KEY_FILE) then
        local savedAt = tonumber(readfile(KEY_FILE))
        if savedAt and os.time() - savedAt < KEY_LIFETIME then
            onVerified()
            return
        end
    end

    local guiParent = game:GetService("CoreGui")
    local canUseCoreGui = pcall(function()
        -- The input leaves this permission-probe ScreenGui in place.
        local probe = Instance.new("ScreenGui")
        probe.Parent = guiParent
    end)
    if not canUseCoreGui then
        guiParent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    end

    local keyGui = Instance.new("ScreenGui", guiParent)
    local frame = Instance.new("Frame", keyGui)
    frame.Size = UDim2.new(0, 200, 0, 160)
    frame.Position = UDim2.new(0.5, -100, 0.5, -80)
    frame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    frame.Active = true
    addCorner(frame)
    makeDraggable(frame)

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, 0, 0, 35)
    title.Text = "Gaming Spirit Key"
    title.TextColor3 = Color3.new(1, 1, 1)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.LuckiestGuy
    title.TextSize = 14

    local input = Instance.new("TextBox", frame)
    input.Size = UDim2.new(0, 180, 0, 35)
    input.Position = UDim2.new(0.5, -90, 0.3, 0)
    input.PlaceholderText = "Enter Key..."
    input.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    input.TextColor3 = Color3.new(1, 1, 1)
    input.Font = Enum.Font.LuckiestGuy
    input.TextSize = 12
    addCorner(input)

    local verifyButton = Instance.new("TextButton", frame)
    verifyButton.Size = UDim2.new(0, 180, 0, 35)
    verifyButton.Position = UDim2.new(0.5, -90, 0.58, 0)
    verifyButton.Text = "Verify"
    verifyButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
    verifyButton.TextColor3 = Color3.new(1, 1, 1)
    verifyButton.Font = Enum.Font.LuckiestGuy
    verifyButton.TextSize = 14
    addCorner(verifyButton)

    local linkButton = Instance.new("TextButton", frame)
    linkButton.Size = UDim2.new(0, 180, 0, 25)
    linkButton.Position = UDim2.new(0.5, -90, 0.83, 0)
    linkButton.Text = "Get Key Link"
    linkButton.BackgroundColor3 = Color3.fromRGB(52, 152, 219)
    linkButton.TextColor3 = Color3.new(1, 1, 1)
    linkButton.Font = Enum.Font.LuckiestGuy
    linkButton.TextSize = 12
    addCorner(linkButton)

    linkButton.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(KEY_LINK)
            linkButton.Text = "Link Copied!"
        else
            linkButton.Text = "Clipboard not supported"
        end
        task.wait(2)
        linkButton.Text = "Get Key Link"
    end)

    verifyButton.MouseButton1Click:Connect(function()
        if input.Text == fetchKey() then
            if writefile then
                writefile(KEY_FILE, tostring(os.time()))
            end
            keyGui:Destroy()
            onVerified()
        else
            input.Text = ""
            input.PlaceholderText = "WRONG KEY!"
        end
    end)
end

local function matchesEggName(instanceName, eggName)
    local lowerName = string.lower(instanceName)
    if eggName == "KrakenGlory Egg" then
        return string.find(lowerName, "krakenglory")
    elseif eggName == "Seraph Egg" then
        return string.find(lowerName, "adminabuseseraph")
            or string.find(lowerName, "seraph")
    end
    return string.find(lowerName, string.lower(eggName))
end

local function findEgg(world, eggName)
    local target
    local runtime = world:FindFirstChild("EggRuntime")
    if runtime then
        local wildEggs = runtime:FindFirstChild("WildEggs")
        if wildEggs then
            for _, candidate in ipairs(wildEggs:GetChildren()) do
                if matchesEggName(candidate.Name, eggName) then
                    target = candidate
                    break
                end
            end
        end
    end

    if not target and (eggName == "KrakenGlory Egg" or eggName == "Seraph Egg") then
        for _, candidate in ipairs(world:GetDescendants()) do
            local insideRuntime = false
            local ancestor = candidate.Parent
            while ancestor and ancestor ~= world do
                if ancestor.Name == "EggRuntime" then
                    insideRuntime = true
                    break
                end
                ancestor = ancestor.Parent
            end

            if not insideRuntime and matchesEggName(candidate.Name, eggName) then
                target = candidate
                break
            end
        end
    end
    return target
end

local function stealEgg(player, requests, world, eggName)
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart", 3)
    if not root then
        return
    end

    local target = findEgg(world, eggName)
    if not target then
        return
    end

    local targetCFrame
    pcall(function()
        if target:IsA("Model") then
            targetCFrame = target:GetPivot()
        elseif target:IsA("BasePart") then
            targetCFrame = target.CFrame
        end
    end)
    if not targetCFrame then
        return
    end

    character:PivotTo(targetCFrame + Vector3.new(0, 5, 0))
    task.wait(0.5)

    for _, prompt in ipairs(world:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            local parent = prompt.Parent
            if parent and (parent:IsA("BasePart") or parent:IsA("Model")) then
                local position = parent:IsA("BasePart") and parent.Position or parent:GetPivot().Position
                if (root.Position - position).Magnitude <= 15 then
                    pcall(function()
                        prompt:InputHoldBegin()
                        local duration = prompt.HoldDuration > 0 and prompt.HoldDuration or 1.5
                        task.wait(duration + 0.2)
                        prompt:InputHoldEnd()
                    end)
                    break
                end
            end
        end
    end

    task.wait(0.3)
    character:PivotTo(CFrame.new(-150, 4, 222))
    task.wait(1)
    requests:FireServer("StoreEgg")
end

local function collectToken(player, world)
    local character = player.Character or player.CharacterAdded:Wait()
    local root = character:WaitForChild("HumanoidRootPart", 3)
    local tokenFolder = world:FindFirstChild("ActiveTokens")
    if root and tokenFolder then
        local tokens = tokenFolder:GetChildren()
        if #tokens > 0 then
            local token = tokens[math.random(1, #tokens)]
            local position
            if token:IsA("Model") then
                position = token.PrimaryPart and token.PrimaryPart.Position or token:GetPivot().Position
            elseif token:IsA("BasePart") then
                position = token.Position
            end
            if position then
                root.CFrame = CFrame.new(position + Vector3.new(0, 3, 0))
            end
        end
    end
end

local function sellAllFish(request)
    local success, quote = pcall(function()
        return request:InvokeServer("QuoteAll", nil)
    end)
    if success and type(quote) == "table" and quote.ok
        and quote.count and quote.count > 0 and quote.token then
        request:InvokeServer("SellAll", quote.token)
    end
end

local function createToggleRow(container, labelText, order)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, -6, 0, 28)
    row.BackgroundTransparency = 1
    row.LayoutOrder = order
    row.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(0, 145, 1, 0)
    label.Position = UDim2.new(0, 4, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextSize = 13
    label.Font = Enum.Font.LuckiestGuy
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = row

    local button = Instance.new("TextButton")
    button.Size = UDim2.new(0, 32, 0, 24)
    button.Position = UDim2.new(1, -36, 0, 2)
    button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    button.BorderSizePixel = 0
    button.Text = ""
    button.Parent = row
    addCorner(button, 4)

    local enabled = false
    button.MouseButton1Click:Connect(function()
        enabled = not enabled
        button.BackgroundColor3 = enabled and Color3.fromRGB(50, 200, 50)
            or Color3.fromRGB(200, 50, 50)
    end)
    return row, function()
        return enabled
    end
end

local function startHub()
    local coreGui = game:GetService("CoreGui")
    local players = game:GetService("Players")
    local world = game:GetService("Workspace")
    local replicatedStorage = game:GetService("ReplicatedStorage")
    local player = players.LocalPlayer

    if coreGui:FindFirstChild("GamingSpiritScriptHub") then
        coreGui.GamingSpiritScriptHub:Destroy()
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GamingSpiritScriptHub"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = coreGui

    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 200, 0, 220)
    mainFrame.Position = UDim2.new(0.5, -100, 0.4, -110)
    mainFrame.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    mainFrame.BorderSizePixel = 0
    mainFrame.Active = true
    mainFrame.Draggable = true
    mainFrame.Parent = screenGui
    addCorner(mainFrame, 6)

    local title = Instance.new("TextLabel")
    title.Name = "TitleLabel"
    title.Size = UDim2.new(0, 160, 0, 18)
    title.Position = UDim2.new(0, 8, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = "RIDE A FISH"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.TextSize = 13
    title.Font = Enum.Font.LuckiestGuy
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = mainFrame

    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeBtn"
    minimizeButton.Size = UDim2.new(0, 24, 0, 24)
    minimizeButton.Position = UDim2.new(1, -28, 0, 6)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Text = "-"
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.TextSize = 14
    minimizeButton.Font = Enum.Font.LuckiestGuy
    minimizeButton.Parent = mainFrame
    addCorner(minimizeButton, 4)

    local scrollContainer = Instance.new("ScrollingFrame")
    scrollContainer.Name = "ScrollContainer"
    scrollContainer.Size = UDim2.new(1, -10, 0, 172)
    scrollContainer.Position = UDim2.new(0, 5, 0, 34)
    scrollContainer.BackgroundTransparency = 1
    scrollContainer.BorderSizePixel = 0
    scrollContainer.ScrollBarThickness = 4
    scrollContainer.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollContainer.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scrollContainer.Parent = mainFrame

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 6)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scrollContainer

    local footer = Instance.new("TextLabel")
    footer.Name = "FooterLabel"
    footer.Size = UDim2.new(1, 0, 0, 24)
    footer.Position = UDim2.new(0, 0, 1, -26)
    footer.BackgroundTransparency = 1
    footer.Text = "YOUTUBE: SPIRITUAL GAMING"
    footer.TextColor3 = Color3.fromRGB(255, 255, 255)
    footer.TextSize = 11
    footer.Font = Enum.Font.LuckiestGuy
    footer.Parent = mainFrame

    local minimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        scrollContainer.Visible = not minimized
        footer.Visible = not minimized
        mainFrame.Size = minimized and UDim2.new(0, 200, 0, 36) or UDim2.new(0, 200, 0, 220)
        minimizeButton.Text = minimized and "+" or "-"
    end)

    local autoStealRow = Instance.new("Frame")
    autoStealRow.Size = UDim2.new(1, -6, 0, 28)
    autoStealRow.BackgroundTransparency = 1
    autoStealRow.LayoutOrder = 1
    autoStealRow.Parent = scrollContainer

    local autoStealLabel = Instance.new("TextLabel")
    autoStealLabel.Size = UDim2.new(0, 145, 1, 0)
    autoStealLabel.Position = UDim2.new(0, 4, 0, 0)
    autoStealLabel.BackgroundTransparency = 1
    autoStealLabel.Text = "AUTO STEAL"
    autoStealLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    autoStealLabel.TextSize = 13
    autoStealLabel.Font = Enum.Font.LuckiestGuy
    autoStealLabel.TextXAlignment = Enum.TextXAlignment.Left
    autoStealLabel.Parent = autoStealRow

    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Size = UDim2.new(0, 32, 0, 24)
    dropdownButton.Position = UDim2.new(1, -36, 0, 2)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    dropdownButton.BorderSizePixel = 0
    dropdownButton.Text = "\226\150\188"
    dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownButton.TextSize = 12
    dropdownButton.Font = Enum.Font.LuckiestGuy
    dropdownButton.Parent = autoStealRow
    addCorner(dropdownButton, 4)

    local eggContainer = Instance.new("Frame")
    eggContainer.Size = UDim2.new(1, 0, 0, 0)
    eggContainer.BackgroundTransparency = 1
    eggContainer.Visible = false
    eggContainer.LayoutOrder = 2
    eggContainer.Parent = scrollContainer

    local eggLayout = Instance.new("UIListLayout")
    eggLayout.Parent = eggContainer
    eggLayout.SortOrder = Enum.SortOrder.LayoutOrder
    eggLayout.Padding = UDim.new(0, 4)
    eggLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        eggContainer.Size = UDim2.new(1, 0, 0, eggLayout.AbsoluteContentSize.Y)
    end)

    local selectedEggs = {}
    for order, eggName in ipairs(EGG_NAMES) do
        selectedEggs[eggName] = false

        local row = Instance.new("Frame")
        row.Size = UDim2.new(1, -6, 0, 22)
        row.BackgroundTransparency = 1
        row.LayoutOrder = order
        row.Parent = eggContainer

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 130, 1, 0)
        label.Position = UDim2.new(0, 10, 0, 0)
        label.BackgroundTransparency = 1
        label.Text = eggName
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 11
        label.Font = Enum.Font.LuckiestGuy
        label.TextXAlignment = Enum.TextXAlignment.Left
        label.Parent = row

        local button = Instance.new("TextButton")
        button.Size = UDim2.new(0, 24, 0, 22)
        button.Position = UDim2.new(1, -32, 0, 0)
        button.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        button.BorderSizePixel = 0
        button.Text = ""
        button.Parent = row
        addCorner(button, 4)

        button.MouseButton1Click:Connect(function()
            selectedEggs[eggName] = not selectedEggs[eggName]
            button.BackgroundColor3 = selectedEggs[eggName] and Color3.fromRGB(50, 200, 50)
                or Color3.fromRGB(200, 50, 50)
        end)
    end

    local expanded = false
    local function toggleEggList()
        expanded = not expanded
        eggContainer.Visible = expanded
        dropdownButton.Text = expanded and "\226\150\178" or "\226\150\188"
    end
    dropdownButton.MouseButton1Click:Connect(toggleEggList)

    local labelHitbox = Instance.new("TextButton")
    labelHitbox.Size = UDim2.new(0, 145, 1, 0)
    labelHitbox.Position = UDim2.new(0, 0, 0, 0)
    labelHitbox.BackgroundTransparency = 1
    labelHitbox.Text = ""
    labelHitbox.Parent = autoStealRow
    labelHitbox.MouseButton1Click:Connect(toggleEggList)

    task.spawn(function()
        local requests = replicatedStorage:WaitForChild("EggGame"):WaitForChild("Requests")
        while true do
            local anySelected = false
            for _, enabled in pairs(selectedEggs) do
                if enabled then
                    anySelected = true
                    break
                end
            end
            if anySelected then
                for eggName, enabled in pairs(selectedEggs) do
                    if enabled then
                        pcall(function()
                            stealEgg(player, requests, world, eggName)
                        end)
                        task.wait(0.2)
                    end
                end
            end
            task.wait(1)
        end
    end)

    local _, tokensEnabled = createToggleRow(scrollContainer, "COLLECT TOKENS", 3)
    task.spawn(function()
        while true do
            if tokensEnabled() then
                pcall(function()
                    collectToken(player, world)
                end)
            end
            task.wait(0.5)
        end
    end)

    local _, rebirthEnabled = createToggleRow(scrollContainer, "AUTO REBIRTH", 4)
    task.spawn(function()
        local requests = replicatedStorage:WaitForChild("EggGame"):WaitForChild("Requests")
        while true do
            if rebirthEnabled() then
                pcall(function()
                    requests:FireServer("RebirthState")
                    task.wait(0.3)
                    requests:FireServer("Rebirth")
                end)
                task.wait(1)
            else
                task.wait(0.5)
            end
        end
    end)

    local _, sellEnabled = createToggleRow(scrollContainer, "SELL ALL", 5)
    task.spawn(function()
        local request = replicatedStorage:WaitForChild("FishSellRemotes"):WaitForChild("Request")
        while true do
            if sellEnabled() then
                pcall(function()
                    sellAllFish(request)
                end)
                task.wait(5)
            else
                task.wait(0.5)
            end
        end
    end)
end

showKeySystem(startHub)
