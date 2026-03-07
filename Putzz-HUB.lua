--// Putzzdev-HUB (Super Kece Edition)
-- Dengan desain modern: rounded, shadow, gradient, animasi

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- GUI Utama
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui
ScreenGui.Name = "PutzzdevHub"
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Fungsi untuk membuat shadow (efek bayangan)
local function createShadow(parent, size, position, color)
    local shadow = Instance.new("ImageLabel")
    shadow.Parent = parent
    shadow.BackgroundTransparency = 1
    shadow.Size = size
    shadow.Position = position
    shadow.Image = "rbxassetid://6015897843" -- Asset shadow
    shadow.ImageColor3 = color or Color3.new(0,0,0)
    shadow.ImageTransparency = 0.8
    shadow.ScaleType = Enum.ScaleType.Slice
    shadow.SliceCenter = Rect.new(10,10,118,118)
    return shadow
end

-- Fungsi untuk membuat frame dengan rounded corners
local function makeRoundedFrame(parent, size, pos, color, radius)
    local frame = Instance.new("Frame")
    frame.Parent = parent
    frame.Size = size
    frame.Position = pos
    frame.BackgroundColor3 = color or Color3.fromRGB(30,30,30)
    frame.BorderSizePixel = 0
    frame.ClipsDescendants = true

    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, radius or 8)

    return frame
end

-- Fungsi untuk membuat gradient
local function addGradient(frame, color1, color2, rotation)
    local gradient = Instance.new("UIGradient")
    gradient.Parent = frame
    gradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, color1), ColorSequenceKeypoint.new(1, color2)})
    gradient.Rotation = rotation or 90
    return gradient
end

-- Fungsi untuk membuat tombol keren
local function makeButton(parent, text, yPos, callback)
    local btnFrame = makeRoundedFrame(parent, UDim2.new(0.9,0,0,45), UDim2.new(0.05,0,0,yPos), Color3.fromRGB(45,45,55), 6)
    addGradient(btnFrame, Color3.fromRGB(55,55,65), Color3.fromRGB(40,40,50), 90)

    local btn = Instance.new("TextButton")
    btn.Parent = btnFrame
    btn.Size = UDim2.new(1,0,1,0)
    btn.BackgroundTransparency = 1
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16

    -- Efek hover
    btn.MouseEnter:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(65,65,75)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btnFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45,45,55)}):Play()
    end)

    btn.MouseButton1Click:Connect(callback)
    return btnFrame
end

-- Fungsi untuk membuat toggle (saklar)
local function makeToggle(parent, text, yPos, default, callback)
    local toggleFrame = makeRoundedFrame(parent, UDim2.new(0.9,0,0,45), UDim2.new(0.05,0,0,yPos), Color3.fromRGB(45,45,55), 6)
    addGradient(toggleFrame, Color3.fromRGB(55,55,65), Color3.fromRGB(40,40,50), 90)

    local label = Instance.new("TextLabel")
    label.Parent = toggleFrame
    label.Size = UDim2.new(0.7,0,1,0)
    label.Position = UDim2.new(0.05,0,0,0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left

    local toggleBtn = Instance.new("Frame")
    toggleBtn.Parent = toggleFrame
    toggleBtn.Size = UDim2.new(0,50,0,25)
    toggleBtn.Position = UDim2.new(0.85, -25, 0.5, -12.5)
    toggleBtn.BackgroundColor3 = default and Color3.fromRGB(0,200,0) or Color3.fromRGB(100,100,100)
    toggleBtn.BorderSizePixel = 0

    local cornerBtn = Instance.new("UICorner")
    cornerBtn.Parent = toggleBtn
    cornerBtn.CornerRadius = UDim.new(0,12)

    local circle = Instance.new("Frame")
    circle.Parent = toggleBtn
    circle.Size = UDim2.new(0,21,0,21)
    circle.Position = default and UDim2.new(0.9, -21, 0.5, -10.5) or UDim2.new(0.1,0,0.5,-10.5)
    circle.BackgroundColor3 = Color3.new(1,1,1)
    circle.BorderSizePixel = 0

    local cornerCircle = Instance.new("UICorner")
    cornerCircle.Parent = circle
    cornerCircle.CornerRadius = UDim.new(1,0)

    local state = default
    local toggleButton = Instance.new("TextButton")
    toggleButton.Parent = toggleFrame
    toggleButton.Size = UDim2.new(1,0,1,0)
    toggleButton.BackgroundTransparency = 1
    toggleButton.Text = ""

    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(toggleBtn, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0,200,0) or Color3.fromRGB(100,100,100)}):Play()
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = state and UDim2.new(0.9, -21, 0.5, -10.5) or UDim2.new(0.1,0,0.5,-10.5)}):Play()
        callback(state)
    end)

    return toggleFrame
end

-- ================== MAIN WINDOW ==================
-- Shadow luar
local shadowOuter = createShadow(ScreenGui, UDim2.new(0,400,0,500), UDim2.new(0.5,-200,0.5,-250), Color3.new(0,0,0))

-- Frame utama dengan rounded besar
local mainFrame = makeRoundedFrame(ScreenGui, UDim2.new(0,380,0,480), UDim2.new(0.5,-190,0.5,-240), Color3.fromRGB(25,25,35), 16)
mainFrame.ClipsDescendants = true

-- Gradient background
local gradient = Instance.new("UIGradient")
gradient.Parent = mainFrame
gradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20,20,30)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(35,35,45))
})
gradient.Rotation = 45

-- Shadow dalam (untuk efek kedalaman)
local innerShadow = Instance.new("ImageLabel")
innerShadow.Parent = mainFrame
innerShadow.BackgroundTransparency = 1
innerShadow.Size = UDim2.new(1,20,1,20)
innerShadow.Position = UDim2.new(0,-10,0,-10)
innerShadow.Image = "rbxassetid://6015897843"
innerShadow.ImageColor3 = Color3.new(1,1,1)
innerShadow.ImageTransparency = 0.95
innerShadow.ScaleType = Enum.ScaleType.Slice
innerShadow.SliceCenter = Rect.new(10,10,118,118)

-- Header
local header = Instance.new("Frame")
header.Parent = mainFrame
header.Size = UDim2.new(1,0,0,60)
header.BackgroundTransparency = 1
header.BorderSizePixel = 0

-- Logo atau title
local title = Instance.new("TextLabel")
title.Parent = header
title.Size = UDim2.new(1,0,1,0)
title.BackgroundTransparency = 1
title.Text = "PUTZZDEV-HUB"
title.TextColor3 = Color3.fromRGB(0,200,255)
title.Font = Enum.Font.GothamBlack
title.TextSize = 28
title.TextStrokeTransparency = 0.7
title.TextStrokeColor3 = Color3.new(0,0,0)

-- Garis bawah berwarna
local line = Instance.new("Frame")
line.Parent = header
line.Size = UDim2.new(0.8,0,0,3)
line.Position = UDim2.new(0.1,0,1,-3)
line.BackgroundColor3 = Color3.fromRGB(0,200,255)
line.BorderSizePixel = 0

local cornerLine = Instance.new("UICorner")
cornerLine.Parent = line
cornerLine.CornerRadius = UDim.new(0,2)

-- Tab buttons
local tabFrame = Instance.new("Frame")
tabFrame.Parent = mainFrame
tabFrame.Size = UDim2.new(1,0,0,45)
tabFrame.Position = UDim2.new(0,0,0,60)
tabFrame.BackgroundTransparency = 1

local tabButtons = {}
local tabContents = {}

local function createTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.Parent = tabFrame
    btn.Size = UDim2.new(0.25,0,1,0)
    btn.Position = UDim2.new((#tabButtons)*0.25,0,0,0)
    btn.BackgroundTransparency = 1
    btn.Text = icon .. " " .. name
    btn.TextColor3 = Color3.fromRGB(200,200,200)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200,200,200)}):Play()
    end)

    local content = Instance.new("ScrollingFrame")
    content.Parent = mainFrame
    content.Size = UDim2.new(1,0,1,-105)
    content.Position = UDim2.new(0,0,0,105)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 6
    content.ScrollBarImageColor3 = Color3.fromRGB(100,100,100)
    content.CanvasSize = UDim2.new(0,0,0,0)
    content.Visible = false

    local layout = Instance.new("UIListLayout")
    layout.Parent = content
    layout.Padding = UDim.new(0,8)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    table.insert(tabButtons, btn)
    table.insert(tabContents, content)

    btn.MouseButton1Click:Connect(function()
        for i,b in ipairs(tabButtons) do
            TweenService:Create(b, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(200,200,200)}):Play()
            tabContents[i].Visible = false
        end
        TweenService:Create(btn, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(0,200,255)}):Play()
        content.Visible = true
    end)

    return content
end

-- Buat tab-tab
local tabMain = createTab("Main", "🏠")
local tabESP = createTab("ESP", "👁️")
local tabMove = createTab("Movement", "🏃")
local tabMisc = createTab("Misc", "⚙️")

-- Isi tab Main
local yPos = 10
makeButton(tabMain, "Test Button", yPos, function() print("Clicked") end); yPos = yPos + 55
makeToggle(tabMain, "Test Toggle", yPos, false, function(s) print("Toggle:", s) end); yPos = yPos + 55

tabMain.CanvasSize = UDim2.new(0,0,0,yPos+20)

-- Isi tab ESP
yPos = 10
makeToggle(tabESP, "ESP Player", yPos, false, function(s)
    -- Panggil fungsi ESP kamu di sini
    print("ESP Player:", s)
end); yPos = yPos + 55

makeToggle(tabESP, "ESP Line", yPos, false, function(s)
    print("ESP Line:", s)
end); yPos = yPos + 55

makeToggle(tabESP, "Health Bar", yPos, false, function(s)
    print("Health Bar:", s)
end); yPos = yPos + 55

tabESP.CanvasSize = UDim2.new(0,0,0,yPos+20)

-- Isi tab Movement
yPos = 10
makeToggle(tabMove, "Fly", yPos, false, function(s)
    print("Fly:", s)
end); yPos = yPos + 55

makeToggle(tabMove, "Speed", yPos, false, function(s)
    print("Speed:", s)
end); yPos = yPos + 55

makeToggle(tabMove, "NoClip", yPos, false, function(s)
    print("NoClip:", s)
end); yPos = yPos + 55

tabMove.CanvasSize = UDim2.new(0,0,0,yPos+20)

-- Isi tab Misc
yPos = 10
makeButton(tabMisc, "Refresh", yPos, function()
    print("Refresh clicked")
end); yPos = yPos + 55

makeButton(tabMisc, "Settings", yPos, function()
    print("Settings clicked")
end); yPos = yPos + 55

tabMisc.CanvasSize = UDim2.new(0,0,0,yPos+20)

-- Aktifkan tab pertama
tabButtons[1].TextColor3 = Color3.fromRGB(0,200,255)
tabContents[1].Visible = true

-- Close button (X)
local closeBtn = Instance.new("TextButton")
closeBtn.Parent = header
closeBtn.Size = UDim2.new(0,40,0,40)
closeBtn.Position = UDim2.new(1,-40,0,10)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255,100,100)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 24
closeBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Animasi muncul
mainFrame.Position = UDim2.new(0.5,-190,0.6,-240)
TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back), {Position = UDim2.new(0.5,-190,0.5,-240)}):Play()

-- Notifikasi keren
local function notify(msg, duration)
    local notif = makeRoundedFrame(ScreenGui, UDim2.new(0,300,0,50), UDim2.new(0.5,-150,0.9,0), Color3.fromRGB(45,45,55), 8)
    notif.BackgroundColor3 = Color3.fromRGB(30,30,40)
    addGradient(notif, Color3.fromRGB(50,50,60), Color3.fromRGB(30,30,40), 90)

    local label = Instance.new("TextLabel")
    label.Parent = notif
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = msg
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 16

    TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0.5,-150,0.8,0)}):Play()
    wait(duration or 3)
    TweenService:Create(notif, TweenInfo.new(0.3), {Position = UDim2.new(0.5,-150,0.9,0)}):Play()
    wait(0.3)
    notif:Destroy()
end

notify("Putzzdev-HUB", 2)

print("GUI")