--[[ 
    PUTZZHUB MOBILE - FLY 3D ANALOG + ESP PRO
    - Satu jari: kontrol horizontal (maju/mundur, kiri/kanan)
    - Dua jari: jari kedua untuk naik/turun
    - ESP box + nama + jarak
]]

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

-- Status
local flying = false
local speedOn = false
local espOn = false
local flySpeed = 70

-- Touch tracking
local touches = {}                  -- tabel berisi touchId -> {posisi awal, posisi terkini, type}
local touchHorizontal = nil         -- touchId untuk kontrol horizontal
local touchVertical = nil           -- touchId untuk kontrol vertikal
local flyDirection = Vector3.new(0,0,0)
local verticalSpeed = 0

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.ResetOnSpawn = false
gui.Name = "PutzzHUB"

-- Main menu frame
local frame = Instance.new("Frame", gui)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Size = UDim2.new(0, 220, 0, 300)
frame.Position = UDim2.new(0.05, 0, 0.2, 0)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.Text = "PutzzHUB 3D ANALOG"
title.TextColor3 = Color3.fromRGB(255,255,0)
title.Font = Enum.Font.GothamBold

-- Toggle button
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.new(0, 60, 0, 30)
toggleBtn.Position = UDim2.new(0, 10, 0.5, -15)
toggleBtn.Text = "CLOSE"
toggleBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggleBtn.MouseButton1Click:Connect(function()
    frame.Visible = not frame.Visible
    toggleBtn.Text = frame.Visible and "CLOSE" or "OPEN"
end)

-- Fly toggle
local flyBtn = Instance.new("TextButton", frame)
flyBtn.Text = "Fly OFF"
flyBtn.Size = UDim2.new(0.8,0,0,35)
flyBtn.Position = UDim2.new(0.1,0,0.1,0)
flyBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)

-- Speed toggle
local speedBtn = Instance.new("TextButton", frame)
speedBtn.Text = "Speed OFF"
speedBtn.Size = UDim2.new(0.8,0,0,35)
speedBtn.Position = UDim2.new(0.1,0,0.25,0)
speedBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)

-- ESP toggle
local espBtn = Instance.new("TextButton", frame)
espBtn.Text = "ESP OFF"
espBtn.Size = UDim2.new(0.8,0,0,35)
espBtn.Position = UDim2.new(0.1,0,0.4,0)
espBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)

-- Speed slider
local speedFrame = Instance.new("Frame", frame)
speedFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
speedFrame.Size = UDim2.new(0.9,0,0,30)
speedFrame.Position = UDim2.new(0.05,0,0.6,0)

local speedLabel = Instance.new("TextLabel", speedFrame)
speedLabel.Size = UDim2.new(0.5,0,1,0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "Speed: "..flySpeed
speedLabel.TextColor3 = Color3.new(1,1,1)
speedLabel.TextXAlignment = Enum.TextXAlignment.Left

local minusBtn = Instance.new("TextButton", speedFrame)
minusBtn.Size = UDim2.new(0.2,0,1,0)
minusBtn.Position = UDim2.new(0.6,0,0,0)
minusBtn.Text = "-"
minusBtn.BackgroundColor3 = Color3.fromRGB(150,0,0)
minusBtn.MouseButton1Click:Connect(function()
    flySpeed = math.max(20, flySpeed - 10)
    speedLabel.Text = "Speed: "..flySpeed
end)

local plusBtn = Instance.new("TextButton", speedFrame)
plusBtn.Size = UDim2.new(0.2,0,1,0)
plusBtn.Position = UDim2.new(0.8,0,0,0)
plusBtn.Text = "+"
plusBtn.BackgroundColor3 = Color3.fromRGB(0,150,0)
plusBtn.MouseButton1Click:Connect(function()
    flySpeed = math.min(200, flySpeed + 10)
    speedLabel.Text = "Speed: "..flySpeed
end)

-- Keterangan cara pakai
local info = Instance.new("TextLabel", frame)
info.Size = UDim2.new(0.9,0,0,40)
info.Position = UDim2.new(0.05,0,0.75,0)
info.BackgroundTransparency = 1
info.Text = "🖐 1 jari: geser arah\n🖐🖐 2 jari: jari ke-2 naik/turun"
info.TextColor3 = Color3.fromRGB(200,200,0)
info.TextWrapped = true
info.TextSize = 12

-- ========== FLY SYSTEM ==========
local bodyVelocity
local bodyGyro

local function stopFly()
    if bodyVelocity then bodyVelocity:Destroy() end
    if bodyGyro then bodyGyro:Destroy() end
    humanoid.PlatformStand = false
    flyDirection = Vector3.new(0,0,0)
    verticalSpeed = 0
    touches = {}
    touchHorizontal = nil
    touchVertical = nil
end

local function startFly()
    stopFly()
    humanoid.PlatformStand = true
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e6,1e6,1e6)
    bodyVelocity.Parent = root
    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e6,1e6,1e6)
    bodyGyro.P = 1e4
    bodyGyro.CFrame = root.CFrame
    bodyGyro.Parent = root
end

flyBtn.MouseButton1Click:Connect(function()
    flying = not flying
    flyBtn.Text = flying and "Fly ON" or "Fly OFF"
    if flying then startFly() else stopFly() end
end)

-- Touch events
UserInputService.TouchStarted:Connect(function(touch, gameProcessed)
    if gameProcessed then return end
    if not flying then return end
    
    local id = touch.UserInputState
    touches[id] = {
        startPos = touch.Position,
        currentPos = touch.Position
    }
    
    -- Assign touch pertama sebagai horizontal, kedua sebagai vertikal
    if not touchHorizontal then
        touchHorizontal = id
    elseif not touchVertical then
        touchVertical = id
    end
end)

UserInputService.TouchMoved:Connect(function(touch, gameProcessed)
    if gameProcessed then return end
    if not flying then return end
    
    local id = touch.UserInputState
    if touches[id] then
        touches[id].currentPos = touch.Position
    end
end)

UserInputService.TouchEnded:Connect(function(touch, gameProcessed)
    if gameProcessed then return end
    if not flying then return end
    
    local id = touch.UserInputState
    touches[id] = nil
    if touchHorizontal == id then
        touchHorizontal = nil
        -- Jika masih ada touch lain, jadikan itu horizontal
        local keys = {}
        for k,_ in pairs(touches) do table.insert(keys, k) end
        if #keys > 0 then
            touchHorizontal = keys[1]
        end
    elseif touchVertical == id then
        touchVertical = nil
    end
end)

-- Update loop
RunService.RenderStepped:Connect(function()
    if not flying then return end
    
    -- Hitung arah horizontal dari touch pertama
    local moveHorizontal = Vector3.new(0,0,0)
    if touchHorizontal and touches[touchHorizontal] then
        local t = touches[touchHorizontal]
        local delta = t.currentPos - t.startPos
        -- sensitivitas: geser 100 pixel = kecepatan maks
        local maxDelta = 100
        local x = math.clamp(delta.X / maxDelta, -1, 1)
        local y = math.clamp(delta.Y / maxDelta, -1, 1)  -- y positif = geser ke bawah (maju)
        
        local cam = workspace.CurrentCamera
        local forward = cam.CFrame.LookVector * Vector3.new(1,0,1).Unit
        local right = cam.CFrame.RightVector * Vector3.new(1,0,1).Unit
        
        moveHorizontal = (forward * -y + right * x).Unit  -- y dibalik agar geser atas = maju
    end
    
    -- Hitung vertikal dari touch kedua
    local moveVertical = 0
    if touchVertical and touches[touchVertical] then
        local t = touches[touchVertical]
        local deltaY = t.currentPos.Y - t.startPos.Y
        moveVertical = math.clamp(deltaY / 100, -1, 1)  -- positif = geser bawah = turun? Kita balik
        moveVertical = -moveVertical  -- agar geser atas = naik
    end
    
    flyDirection = moveHorizontal * flySpeed + Vector3.new(0, moveVertical * flySpeed, 0)
    
    if bodyVelocity then
        bodyVelocity.Velocity = flyDirection
    end
    if bodyGyro and workspace.CurrentCamera then
        bodyGyro.CFrame = workspace.CurrentCamera.CFrame
    end
end)

-- ========== SPEED HACK ==========
speedBtn.MouseButton1Click:Connect(function()
    speedOn = not speedOn
    speedBtn.Text = speedOn and "Speed ON" or "Speed OFF"
    humanoid.WalkSpeed = speedOn and 60 or 16
end)

-- ========== ESP BOX + NAMA ==========
local espFolder = Instance.new("Folder", gui)
espFolder.Name = "ESP"

local function createESP(plr)
    if plr == player then return end
    
    local function onCharacterAdded(char)
        local head = char:WaitForChild("Head")
        local hrp = char:WaitForChild("HumanoidRootPart")
        local hum = char:WaitForChild("Humanoid")
        
        local bill = Instance.new("BillboardGui")
        bill.Adornee = head
        bill.Size = UDim2.new(5,0,6,0)
        bill.AlwaysOnTop = true
        bill.Parent = espFolder
        
        -- Box
        local box = Instance.new("Frame", bill)
        box.Size = UDim2.new(1,0,1,0)
        box.BackgroundTransparency = 1
        box.BorderSizePixel = 2
        box.BorderColor3 = Color3.fromRGB(255,0,0)
        
        -- Nama + jarak
        local nameLabel = Instance.new("TextLabel", bill)
        nameLabel.Size = UDim2.new(1,0,0.2,0)
        nameLabel.Position = UDim2.new(0,0,-0.2,0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextColor3 = Color3.new(1,1,1)
        nameLabel.TextStrokeTransparency = 0.5
        nameLabel.TextScaled = true
        nameLabel.Font = Enum.Font.GothamBold
        
        RunService.RenderStepped:Connect(function()
            if espOn and plr.Parent and char and root then
                local dist = (root.Position - hrp.Position).Magnitude
                nameLabel.Text = string.format("%s [%dm]", plr.Name, math.floor(dist))
            end
        end)
    end
    
    if plr.Character then
        onCharacterAdded(plr.Character)
    end
    plr.CharacterAdded:Connect(onCharacterAdded)
end

espBtn.MouseButton1Click:Connect(function()
    espOn = not espOn
    espBtn.Text = espOn and "ESP ON" or "ESP OFF"
    if espOn then
        espFolder:ClearAllChildren()
        for _, plr in ipairs(Players:GetPlayers()) do
            createESP(plr)
        end
        Players.PlayerAdded:Connect(createESP)
    else
        espFolder:ClearAllChildren()
    end
end)

print("PutzzHUB 3D Analog + ESP loaded")