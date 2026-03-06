--[[ 
    PUTZZHUB - Gunung Edition (FULL FITUR)
    Developer : PutzzHUB
    Version : 4.0 (HP READY)
]]

-- GUI Utama
local screenGui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local titleBar = Instance.new("Frame")
local titleLabel = Instance.new("TextLabel")
local closeBtn = Instance.new("TextButton")
local tabButtons = {}
local tabFrames = {}

screenGui.Parent = game.Players.LocalPlayer.PlayerGui
screenGui.Name = "PutzzHUB"
screenGui.ResetOnSpawn = false

-- Frame Utama
mainFrame.Parent = screenGui
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
mainFrame.BorderSizePixel = 0
mainFrame.Position = UDim2.new(0.3, 0, 0.2, 0)
mainFrame.Size = UDim2.new(0, 300, 0, 400)
mainFrame.Active = true
mainFrame.Draggable = true

-- Title Bar
titleBar.Parent = mainFrame
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
titleBar.BorderSizePixel = 0
titleBar.Size = UDim2.new(1, 0, 0, 30)

titleLabel.Parent = titleBar
titleLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Size = UDim2.new(1, -30, 1, 0)
titleLabel.Text = "PutzzHUB - Gunung"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 16

closeBtn.Parent = titleBar
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
closeBtn.BorderSizePixel = 0
closeBtn.Position = UDim2.new(1, -30, 0, 0)
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- Tab Buttons Frame
local tabBar = Instance.new("Frame")
tabBar.Parent = mainFrame
tabBar.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
tabBar.BorderSizePixel = 0
tabBar.Position = UDim2.new(0, 0, 0, 30)
tabBar.Size = UDim2.new(1, 0, 0, 40)

-- Container untuk konten tab
local contentFrame = Instance.new("Frame")
contentFrame.Parent = mainFrame
contentFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
contentFrame.BorderSizePixel = 0
contentFrame.Position = UDim2.new(0, 0, 0, 70)
contentFrame.Size = UDim2.new(1, 0, 1, -70)

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- Variables
local flying = false
local flySpeed = 50
local speedEnabled = false
local speedValue = 50
local expEnabled = false
local bodyVelocity = nil

-- Function untuk notifikasi
local function notify(msg, color)
    local notif = Instance.new("TextLabel")
    notif.Parent = screenGui
    notif.BackgroundColor3 = color or Color3.fromRGB(0, 150, 0)
    notif.Size = UDim2.new(0, 200, 0, 40)
    notif.Position = UDim2.new(0.5, -100, 0.8, 0)
    notif.Text = msg
    notif.TextColor3 = Color3.fromRGB(255, 255, 255)
    notif.Font = Enum.Font.Gotham
    notif.TextSize = 14
    notif.BorderSizePixel = 0
    
    game:GetService("TweenService"):Create(notif, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -100, 0.75, 0)}):Play()
    wait(2)
    notif:Destroy()
end

-- Function untuk get player list
local function getPlayerList()
    local list = {}
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player then
            table.insert(list, v.Name)
        end
    end
    return list
end

-- Function teleport
local function teleportTo(targetName)
    local target = Players:FindFirstChild(targetName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local myChar = player.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            myChar.HumanoidRootPart.CFrame = target.Character.HumanoidRootPart.CFrame * CFrame.new(0, 3, 0)
            notify("✅ Teleport ke " .. targetName)
        end
    end
end

-- Function untuk membuat tab
local function createTab(name)
    -- Tab Button
    local btn = Instance.new("TextButton")
    btn.Parent = tabBar
    btn.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    btn.BorderSizePixel = 0
    btn.Position = UDim2.new((#tabButtons) * 0.25, 0, 0, 0)
    btn.Size = UDim2.new(0.25, 0, 1, 0)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    
    -- Tab Content Frame
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Parent = contentFrame
    tabFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    tabFrame.BorderSizePixel = 0
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    tabFrame.ScrollBarThickness = 5
    tabFrame.Visible = false
    
    table.insert(tabButtons, btn)
    table.insert(tabFrames, tabFrame)
    
    btn.MouseButton1Click:Connect(function()
        for i, b in pairs(tabButtons) do
            b.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
            tabFrames[i].Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(75, 75, 85)
        tabFrame.Visible = true
    end)
    
    return tabFrame
end

-- Helper untuk membuat toggle
local function createToggle(parent, text, yPos, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    frame.Position = UDim2.new(0.05, 0, 0, yPos)
    frame.Size = UDim2.new(0.9, 0, 0, 35)
    frame.BorderSizePixel = 0
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    
    local toggleBtn = Instance.new("TextButton")
    toggleBtn.Parent = frame
    toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    toggleBtn.Position = UDim2.new(0.75, 0, 0.1, 0)
    toggleBtn.Size = UDim2.new(0.2, 0, 0.8, 0)
    toggleBtn.Text = "OFF"
    toggleBtn.TextColor3 = Color3.fromRGB(255, 100, 100)
    toggleBtn.Font = Enum.Font.GothamBold
    toggleBtn.TextSize = 12
    
    local state = false
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        toggleBtn.Text = state and "ON" or "OFF"
        toggleBtn.TextColor3 = state and Color3.fromRGB(100, 255, 100) or Color3.fromRGB(255, 100, 100)
        callback(state)
    end)
    
    return frame
end

-- Helper untuk membuat button
local function createButton(parent, text, yPos, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = parent
    btn.BackgroundColor3 = Color3.fromRGB(60, 60, 150)
    btn.Position = UDim2.new(0.1, 0, 0, yPos)
    btn.Size = UDim2.new(0.8, 0, 0, 35)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Helper untuk membuat textbox
local function createTextBox(parent, placeholder, yPos, callback)
    local box = Instance.new("TextBox")
    box.Parent = parent
    box.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
    box.Position = UDim2.new(0.1, 0, 0, yPos)
    box.Size = UDim2.new(0.8, 0, 0, 35)
    box.PlaceholderText = placeholder
    box.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
    box.TextColor3 = Color3.fromRGB(255, 255, 255)
    box.Font = Enum.Font.Gotham
    box.TextSize = 14
    box.ClearTextOnFocus = false
    
    box.FocusLost:Connect(function()
        if box.Text ~= "" then
            callback(box.Text)
            box.Text = ""
        end
    end)
    
    return box
end

-- Helper untuk membuat dropdown
local function createDropdown(parent, text, yPos, options)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    frame.Position = UDim2.new(0.05, 0, 0, yPos)
    frame.Size = UDim2.new(0.9, 0, 0, 35)
    frame.BorderSizePixel = 0
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.Size = UDim2.new(0.7, 0, 1, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    
    local dropdown = Instance.new("TextButton")
    dropdown.Parent = frame
    dropdown.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    dropdown.Position = UDim2.new(0.75, 0, 0.1, 0)
    dropdown.Size = UDim2.new(0.2, 0, 0.8, 0)
    dropdown.Text = "▼"
    dropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdown.Font = Enum.Font.Gotham
    dropdown.TextSize = 14
    
    -- Dropdown menu sederhana (akan muncul di bawah)
    local menu = Instance.new("Frame")
    menu.Parent = parent
    menu.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    menu.Position = UDim2.new(0.05, 0, 0, yPos + 40)
    menu.Size = UDim2.new(0.9, 0, 0, #options * 30)
    menu.BorderSizePixel = 0
    menu.Visible = false
    menu.ZIndex = 10
    
    for i, opt in ipairs(options) do
        local optBtn = Instance.new("TextButton")
        optBtn.Parent = menu
        optBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
        optBtn.Position = UDim2.new(0, 0, 0, (i-1) * 30)
        optBtn.Size = UDim2.new(1, 0, 0, 30)
        optBtn.Text = opt
        optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        optBtn.Font = Enum.Font.Gotham
        optBtn.TextSize = 14
        optBtn.BorderSizePixel = 0
        optBtn.ZIndex = 11
        
        optBtn.MouseButton1Click:Connect(function()
            teleportTo(opt)
            menu.Visible = false
        end)
    end
    
    dropdown.MouseButton1Click:Connect(function()
        menu.Visible = not menu.Visible
    end)
    
    return frame
end

-- Helper untuk membuat slider
local function createSlider(parent, text, yPos, min, max, default, callback)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    frame.Position = UDim2.new(0.05, 0, 0, yPos)
    frame.Size = UDim2.new(0.9, 0, 0, 45)
    frame.BorderSizePixel = 0
    
    local label = Instance.new("TextLabel")
    label.Parent = frame
    label.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    label.BackgroundTransparency = 1
    label.Position = UDim2.new(0.05, 0, 0, 0)
    label.Size = UDim2.new(0.9, 0, 0.4, 0)
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    
    local slider = Instance.new("Frame")
    slider.Parent = frame
    slider.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
    slider.Position = UDim2.new(0.05, 0, 0.5, 0)
    slider.Size = UDim2.new(0.9, 0, 0.2, 0)
    
    local fill = Instance.new("Frame")
    fill.Parent = slider
    fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    
    local value = default
    local dragging = false
    
    slider.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
        end
    end)
    
    slider.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    
    game:GetService("RunService").RenderStepped:Connect(function()
        if dragging then
            local pos = UserInputService:GetMouseLocation()
            local absPos = slider.AbsolutePosition
            local absSize = slider.AbsoluteSize
            local relativeX = math.clamp((pos.X - absPos.X) / absSize.X, 0, 1)
            fill.Size = UDim2.new(relativeX, 0, 1, 0)
            value = math.floor(min + (max - min) * relativeX)
            label.Text = text .. ": " .. value
            callback(value)
        end
    end)
    
    return frame
end

-- Buat tabs
local tab1 = createTab("Utama")
local tab2 = createTab("Teleport")
local tab3 = createTab("EXP")
local tab4 = createTab("Info")

-- === TAB 1: UTAMA ===
local yPos = 10

-- Fly Toggle
createToggle(tab1, "Mode Terbang", yPos, function(state)
    flying = state
    local char = player.Character
    if not char then return end
    
    local root = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    
    if flying then
        humanoid.PlatformStand = true
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Parent = root
        
        spawn(function()
            while flying do
                local move = Vector3.new(0, 0, 0)
                if _G.up then move = move + Vector3.new(0, flySpeed, 0) end
                if _G.down then move = move - Vector3.new(0, flySpeed, 0) end
                if bodyVelocity and bodyVelocity.Parent then
                    bodyVelocity.Velocity = move
                end
                wait(0.1)
            end
        end)
    else
        if bodyVelocity then bodyVelocity:Destroy() end
        humanoid.PlatformStand = false
    end
end)
yPos = yPos + 45

-- Tombol Naik
createButton(tab1, "🔼 Naik", yPos, function()
    _G.up = true
    wait(0.2)
    _G.up = false
end)
yPos = yPos + 45

-- Tombol Turun
createButton(tab1, "🔽 Turun", yPos, function()
    _G.down = true
    wait(0.2)
    _G.down = false
end)
yPos = yPos + 45

-- Slider Kecepatan
createSlider(tab1, "Kecepatan", yPos, 10, 200, 50, function(value)
    flySpeed = value
end)
yPos = yPos + 55

-- Speed Toggle
createToggle(tab1, "Speed Hack", yPos, function(state)
    speedEnabled = state
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        if state then
            char.Humanoid.WalkSpeed = speedValue
        else
            char.Humanoid.WalkSpeed = 16
        end
    end
end)
yPos = yPos + 45

-- Slider Speed
createSlider(tab1, "Speed Value", yPos, 16, 200, 50, function(value)
    speedValue = value
    if speedEnabled then
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.WalkSpeed = value
        end
    end
end)

tab1.CanvasSize = UDim2.new(0, 0, 0, yPos + 60)

-- === TAB 2: TELEPORT ===
yPos = 10

-- Search Player
createTextBox(tab2, "Cari nama player...", yPos, function(text)
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player and v.Name:lower():find(text:lower()) then
            teleportTo(v.Name)
            break
        end
    end
end)
yPos = yPos + 45

-- Refresh Button
createButton(tab2, "🔄 Refresh Player List", yPos, function()
    local list = getPlayerList()
    local msg = "Player online:\n"
    for i, name in ipairs(list) do
        msg = msg .. i .. ". " .. name .. "\n"
    end
    notify(msg, Color3.fromRGB(50, 50, 150))
end)
yPos = yPos + 45

-- Random TP
createButton(tab2, "🎲 Random Teleport", yPos, function()
    local list = getPlayerList()
    if #list > 0 then
        teleportTo(list[math.random(1, #list)])
    else
        notify("❌ Tidak ada player lain")
    end
end)
yPos = yPos + 45

-- Auto TP Toggle
_G.autoTP = false
createToggle(tab2, "Auto TP Terdekat", yPos, function(state)
    _G.autoTP = state
    if state then
        spawn(function()
            while _G.autoTP do
                local myChar = player.Character
                if myChar and myChar:FindFirstChild("HumanoidRootPart") then
                    local closest = nil
                    local dist = math.huge
                    
                    for _, v in pairs(Players:GetPlayers()) do
                        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            local d = (myChar.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                            if d < dist then
                                dist = d
                                closest = v.Name
                            end
                        end
                    end
                    
                    if closest then
                        teleportTo(closest)
                    end
                end
                wait(5)
            end
        end)
    end
end)

tab2.CanvasSize = UDim2.new(0, 0, 0, yPos + 60)

-- === TAB 3: EXP ===
yPos = 10

_G.autoExp = false
createToggle(tab3, "Auto Collect EXP", yPos, function(state)
    _G.autoExp = state
    if state then
        notify("🔍 Mencari EXP...")
        spawn(function()
            while _G.autoExp do
                for _, v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") then
                        local name = v.Name:lower()
                        if name:find("exp") or name:find("xp") or name:find("crystal") or name:find("point") then
                            local char = player.Character
                            if char and char:FindFirstChild("HumanoidRootPart") then
                                char.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 2, 0)
                                wait(0.1)
                            end
                        end
                    end
                end
                wait(1)
            end
        end)
    end
end)
yPos = yPos + 45

createButton(tab3, "📍 Teleport ke EXP Terdekat", yPos, function()
    local closest = nil
    local dist = math.huge
    local myChar = player.Character
    
    if myChar and myChar:FindFirstChild("HumanoidRootPart") then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") then
                local name = v.Name:lower()
                if name:find("exp") or name:find("xp") then
                    local d = (myChar.HumanoidRootPart.Position - v.Position).Magnitude
                    if d < dist then
                        dist = d
                        closest = v
                    end
                end
            end
        end
        
        if closest then
            myChar.HumanoidRootPart.CFrame = closest.CFrame * CFrame.new(0, 2, 0)
            notify("✅ Teleport ke EXP")
        end
    end
end)

tab3.CanvasSize = UDim2.new(0, 0, 0, yPos + 60)

-- === TAB 4: INFO ===
yPos = 10

local infoLabel = Instance.new("TextLabel")
infoLabel.Parent = tab4
infoLabel.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
infoLabel.Position = UDim2.new(0.1, 0, 0, yPos)
infoLabel.Size = UDim2.new(0.8, 0, 0, 120)
infoLabel.Text = "PUTZZHUB\nGunung Edition\n\nDeveloper : PutzzHUB\nVersion : 4.0 (HP Ready)\n\nFitur:\n• Mode Terbang\n• Speed Hack\n• Teleport Player\n• Auto EXP"
infoLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 14
infoLabel.TextWrapped = true
yPos = yPos + 130

createButton(tab4, "📋 Copy Discord", yPos, function()
    setclipboard("discord.gg/putzzhub")
    notify("✅ Link Discord disalin!")
end)

tab4.CanvasSize = UDim2.new(0, 0, 0, yPos + 60)

-- Notifikasi siap
notify("🚀 PutzzHUB siap digunakan!", Color3.fromRGB(0, 150, 0))

-- Set tab pertama aktif
if tabButtons[1] then
    tabButtons[1].BackgroundColor3 = Color3.fromRGB(75, 75, 85)
    tabFrames[1].Visible = true
end

print("✅ PutzzHUB 4.0 berjalan!")