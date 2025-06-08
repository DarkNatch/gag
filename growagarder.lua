-- Grow a Garden Pet and Seed Spawner UI for Delta executor

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

if playerGui:FindFirstChild("DarkNatchUI") then
    playerGui.DarkNatchUI:Destroy()
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DarkNatchUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 420, 0, 360)
frame.Position = UDim2.new(0.5, -210, 0.5, -180)
frame.BackgroundColor3 = Color3.fromRGB(28, 28, 28)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = frame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "DarkNatch - Grow a Garden"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true
title.Parent = frame

local tabButtons = Instance.new("Frame")
tabButtons.Size = UDim2.new(1, 0, 0, 40)
tabButtons.Position = UDim2.new(0, 0, 0, 50)
tabButtons.BackgroundTransparency = 1
tabButtons.Parent = frame

local layout = Instance.new("UIListLayout")
layout.FillDirection = Enum.FillDirection.Horizontal
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.SortOrder = Enum.SortOrder.LayoutOrder
layout.Padding = UDim.new(0, 12)
layout.Parent = tabButtons

local contentFrames = {}

local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Text = name
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Size = UDim2.new(0, 140, 1, 0)
    btn.AutoButtonColor = true
    btn.Font = Enum.Font.Gotham
    btn.TextScaled = true
    btn.Parent = tabButtons

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -24, 1, -100)
    content.Position = UDim2.new(0, 12, 0, 100)
    content.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
    content.Visible = false
    content.Parent = frame

    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 10)
    contentCorner.Parent = content

    contentFrames[name] = content

    return btn, content
end

local tabNames = {"Pet Spawn", "Seed Spawn", "About"}
local buttons = {}

for _, tabName in ipairs(tabNames) do
    local btn, content = createTab(tabName)
    buttons[tabName] = btn
end

local function showTab(name)
    for tabName, frame in pairs(contentFrames) do
        frame.Visible = (tabName == name)
        buttons[tabName].BackgroundColor3 = (tabName == name) and Color3.fromRGB(80, 80, 80) or Color3.fromRGB(50, 50, 50)
    end
end

showTab("Pet Spawn")

for tabName, btn in pairs(buttons) do
    btn.MouseButton1Click:Connect(function()
        showTab(tabName)
    end)
end

local function createLabeledTextbox(parent, labelText, placeholder, posY)
    local label = Instance.new("TextLabel")
    label.Text = labelText
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextScaled = true
    label.BackgroundTransparency = 1
    label.Size = UDim2.new(1, 0, 0, 28)
    label.Position = UDim2.new(0, 0, 0, posY)
    label.Parent = parent

    local textbox = Instance.new("TextBox")
    textbox.PlaceholderText = placeholder
    textbox.Size = UDim2.new(1, 0, 0, 36)
    textbox.Position = UDim2.new(0, 0, 0, posY + 30)
    textbox.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    textbox.TextColor3 = Color3.new(1, 1, 1)
    textbox.Font = Enum.Font.Gotham
    textbox.TextScaled = true
    textbox.ClearTextOnFocus = false
    textbox.Parent = parent

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = textbox

    return textbox
end

local function createPetModel(petName, weight)
    local petModel = Instance.new("Model")
    petModel.Name = petName

    local petBody = Instance.new("Part")
    petBody.Name = "Body"
    petBody.Size = Vector3.new(2, 2, 1)
    local spawnPos = workspace:FindFirstChild("SpawnLocation") and workspace.SpawnLocation.Position + Vector3.new(0,5,0) or Vector3.new(0,5,0)
    petBody.Position = spawnPos
    petBody.Anchored = false
    petBody.BrickColor = BrickColor.new("Bright red")
    petBody.Parent = petModel

    local weightVal = Instance.new("NumberValue")
    weightVal.Name = "Weight"
    weightVal.Value = weight
    weightVal.Parent = petModel

    petModel.Parent = workspace

    return petModel
end

local function createSeed(seedName, quantity)
    local seedFolder = workspace:FindFirstChild("SpawnedSeeds") or Instance.new("Folder", workspace)
    seedFolder.Name = "SpawnedSeeds"

    local seedPart = Instance.new("Part")
    seedPart.Name = seedName
    seedPart.Size = Vector3.new(1, 1, 1)
    seedPart.Position = Vector3.new(math.random(-20, 20), 5, math.random(-20, 20))
    seedPart.Anchored = false
    seedPart.BrickColor = BrickColor.new("Bright yellow")
    seedPart.Parent = seedFolder

    local quantityVal = Instance.new("IntValue")
    quantityVal.Name = "Quantity"
    quantityVal.Value = quantity
    quantityVal.Parent = seedPart

    return seedPart
end

-- Pet Spawn Tab UI
local petNameInput = nil
local petWeightInput = nil
local petSpawnBtn = nil
local petMsg = nil

do
    local parent = contentFrames["Pet Spawn"]
    petNameInput = createLabeledTextbox(parent, "Pet Name (ex: Red Fox)", "Type pet name...", 10)
    petWeightInput = createLabeledTextbox(parent, "Weight (number)", "Type pet weight...", 90)

    petSpawnBtn = Instance.new("TextButton")
    petSpawnBtn.Text = "Spawn Pet"
    petSpawnBtn.Size = UDim2.new(0.6, 0, 0, 40)
    petSpawnBtn.Position = UDim2.new(0.2, 0, 0, 150)
    petSpawnBtn.BackgroundColor3 = Color3.fromRGB(85, 160, 210)
    petSpawnBtn.TextColor3 = Color3.new(1, 1, 1)
    petSpawnBtn.Font = Enum.Font.GothamBold
    petSpawnBtn.TextScaled = true
    petSpawnBtn.Parent = parent

    petMsg = Instance.new("TextLabel")
    petMsg.Text = ""
    petMsg.TextColor3 = Color3.fromRGB(0, 255, 0)
    petMsg.Font = Enum.Font.Gotham
    petMsg.TextScaled = true
    petMsg.BackgroundTransparency = 1
    petMsg.Size = UDim2.new(1, 0, 0, 30)
    petMsg.Position = UDim2.new(0, 0, 0, 200)
    petMsg.Parent = parent

    petSpawnBtn.MouseButton1Click:Connect(function()
        local petName = petNameInput.Text:match("%S+") or ""
        local weight = tonumber(petWeightInput.Text)

        if petName == "" then
            petMsg.TextColor3 = Color3.fromRGB(255, 80, 80)
            petMsg.Text = "Please enter a pet name."
            return
        end
        if not weight or weight <= 0 then
            petMsg.TextColor3 = Color3.fromRGB(255, 80, 80)
            petMsg.Text = "Please enter a valid positive weight."
            return
        end

        createPetModel(petName, weight)
        petMsg.TextColor3 = Color3.fromRGB(0, 255, 0)
        petMsg.Text = ("Spawned pet '%s' with weight %d"):format(petName, weight)
    end)
end

-- Seed Spawn Tab UI
local seedNameInput = nil
local seedQuantityInput = nil
local seedSpawnBtn = nil
local seedMsg = nil

do
    local parent = contentFrames["Seed Spawn"]
    seedNameInput = createLabeledTextbox(parent, "Seed Name (ex: Carrot)", "Type seed name...", 10)
    seedQuantityInput = createLabeledTextbox(parent, "Quantity (number)", "Type quantity...", 90)

    seedSpawnBtn = Instance.new("TextButton")
    seedSpawnBtn.Text = "Spawn Seed"
    seedSpawnBtn.Size = UDim2.new(0.6, 0, 0, 40)
    seedSpawnBtn.Position = UDim2.new(0.2, 0, 0, 150)
    seedSpawnBtn.BackgroundColor3 = Color3.fromRGB(85, 160, 210)
    seedSpawnBtn.TextColor3 = Color3.new(1, 1, 1)
    seedSpawnBtn.Font = Enum.Font.GothamBold
    seedSpawnBtn.TextScaled = true
    seedSpawnBtn.Parent = parent

    seedMsg = Instance.new("TextLabel")
    seedMsg.Text = ""
    seedMsg.TextColor3 = Color3.fromRGB(0, 255, 0)
    seedMsg.Font = Enum.Font.Gotham
    seedMsg.TextScaled = true
    seedMsg.BackgroundTransparency = 1
    seedMsg.Size = UDim2.new(1, 0, 0, 30)
    seedMsg.Position = UDim2.new(0, 0, 0, 200)
    seedMsg.Parent = parent

    seedSpawnBtn.MouseButton1Click:Connect(function()
        local seedName = seedNameInput.Text:match("%S+") or ""
        local quantity = tonumber(seedQuantityInput.Text)

        if seedName == "" then
            seedMsg.TextColor3 = Color3.fromRGB(255, 80, 80)
            seedMsg.Text = "Please enter a seed name."
            return
        end
        if not quantity or quantity <= 0 then
            seedMsg.TextColor3 = Color3.fromRGB(255, 80, 80)
            seedMsg.Text = "Please enter a valid positive quantity."
            return
        end

        for i = 1, quantity do
            createSeed(seedName, 1)
        end

        seedMsg.TextColor3 = Color3.fromRGB(0, 255, 0)
        seedMsg.Text = ("Spawned %d of seed '%s'"):format(quantity, seedName)
    end)
end

-- About Tab UI
do
    local parent = contentFrames["About"]

    local aboutText = Instance.new("TextLabel")
    aboutText.Text = "Created by DarkNatch\nDiscord: discord.gg/example\nEnjoy your Grow a Garden script!"
    aboutText.TextColor3 = Color3.new(1, 1, 1)
    aboutText.Font = Enum.Font.Gotham
    aboutText.TextScaled = true
    aboutText.BackgroundTransparency = 1
    aboutText.Size = UDim2.new(1, -20, 1, -20)
    aboutText.Position = UDim2.new(0, 10, 0, 10)
    aboutText.TextWrapped = true
    aboutText.Parent = parent
end
