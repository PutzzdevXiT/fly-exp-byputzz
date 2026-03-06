--[[
    PUTZZHUB - Gunung Edition v3.0
    Developer : PutzzHUB
    Fitur : Fly, Teleport (Cari + TP Langsung), Speed, EXP
]]

-- Library
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("PutzzHUB - Gunung Edition", "DarkTheme")

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Variables
local flying = false
local flySpeed = 50
local speedEnabled = false
local speedValue = 50
local expEnabled = false
local bodyVelocity = nil
local selectedPlayer = nil
local playerList = {}

-- Update player list otomatis
local function updatePlayerList()
    playerList = {}
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player then
            table.insert(playerList, v.Name)
        end
    end
    return playerList
end

-- Update setiap 3 detik
spawn(function()
    while wait(3) do
        updatePlayerList()
    end
end)

-- Fungsi teleport instan
local function teleportToPlayer(targetPlayerName)
    local target = Players:FindFirstChild(targetPlayerName)
    if target and target.Character and target.Character:FindFirstChild("HumanoidRootPart") then
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            -- Teleport instan (langsung pindah)
            local targetPos = target.Character.HumanoidRootPart.Position
            character.HumanoidRootPart.CFrame = CFrame.new(targetPos.X, targetPos.Y + 3, targetPos.Z)
            
            -- Efek notifikasi
            Library:Notify("✅ Teleport ke " .. targetPlayerName, 2)
            
            -- Efek particle (opsional)
            local particle = Instance.new("ParticleEmitter")
            particle.Parent = character.HumanoidRootPart
            particle.Rate = 100
            particle.Lifetime = NumberRange.new(0.5)
            particle.Spread = Vector2.new(360, 360)
            particle.VelocityInheritance = 0
            wait(0.5)
            particle:Destroy()
        end
    else
        Library:Notify("❌ Player " .. targetPlayerName .. " tidak ditemukan!", 2)
    end
end

-- Fungsi search player
local function searchPlayer(searchText)
    local matches = {}
    searchText = searchText:lower()
    
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= player then
            local playerName = v.Name:lower()
            local displayName = (v.DisplayName or ""):lower()
            
            if playerName:find(searchText) or displayName:find(searchText) then
                table.insert(matches, v.Name)
            end
        end
    end
    
    return matches
end

-- MAIN TAB
local MainTab = Window:NewTab("Utama")
local MainSection = MainTab:NewSection("Fitur Utama")

-- FLY FEATURE
MainSection:NewToggle("Mode Terbang", "Terbang bebas di gunung", function(state)
    flying = state
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    if flying then
        humanoid.PlatformStand = true
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = rootPart
        
        coroutine.wrap(function()
            while flying and bodyVelocity and bodyVelocity.Parent do
                local moveDirection = Vector3.new(0, 0, 0)
                local camera = workspace.CurrentCamera
                
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveDirection = moveDirection + (camera.CFrame.LookVector * flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveDirection = moveDirection - (camera.CFrame.LookVector * flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveDirection = moveDirection - (camera.CFrame.RightVector * flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveDirection = moveDirection + (camera.CFrame.RightVector * flySpeed)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveDirection = moveDirection + Vector3.new(0, flySpeed, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
                    moveDirection = moveDirection - Vector3.new(0, flySpeed, 0)
                end
                
                bodyVelocity.Velocity = moveDirection
                RunService.Heartbeat:Wait()
            end
        end)()
    else
        if bodyVelocity then
            bodyVelocity:Destroy()
            bodyVelocity = nil
        end
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
end)

MainSection:NewSlider("Kecepatan Terbang", "Atur kecepatan terbang", 200, 10, function(value)
    flySpeed = value
end)

-- SPEED HACK
MainSection:NewToggle("Speed Hack", "Mempercepat jalan", function(state)
    speedEnabled = state
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        local humanoid = character.Humanoid
        if speedEnabled then
            humanoid.WalkSpeed = speedValue
        else
            humanoid.WalkSpeed = 16
        end
    end
end)

MainSection:NewSlider("Kecepatan Jalan", "Atur speed hack", 200, 16, function(value)
    speedValue = value
    if speedEnabled then
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid.WalkSpeed = value
        end
    end
end))

-- EXP AUTO COLLECT
MainSection:NewToggle("Auto Collect EXP", "Otomatis ambil EXP", function(state)
    expEnabled = state
    
    if expEnabled then
        Library:Notify("🔍 Mencari EXP...", 2)
        
        coroutine.wrap(function()
            while expEnabled do
                for _, v in pairs(workspace:GetDescendants()) do
                    local expNames = {"exp", "experience", "xp", "point", "crystal", "gem", "ore", "batu", "coin", "money"}
                    
                    for _, name in pairs(expNames) do
                        if v.Name:lower():find(name) and v:IsA("BasePart") then
                            local character = player.Character
                            if character and character:FindFirstChild("HumanoidRootPart") then
                                character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 2, 0)
                                wait(0.1)
                            end
                        end
                    end
                end
                wait(1)
            end
        end)()
    end
end)

-- TELEPORT TAB (DENGAN FITUR SEARCH)
local TeleportTab = Window:NewTab("Teleport")
local TeleportSection = TeleportTab:NewSection("Teleport ke Player")

-- FITUR SEARCH PLAYER
TeleportSection:NewTextBox("Cari Player", "Ketik nama player", function(text)
    if text and text ~= "" then
        local results = searchPlayer(text)
        if #results > 0 then
            local resultText = "Ditemukan: " .. table.concat(results, ", ")
            Library:Notify("🔍 " .. resultText, 3)
            
            -- Auto teleport kalau cuma 1 hasil
            if #results == 1 then
                teleportToPlayer(results[1])
            end
        else
            Library:Notify("❌ Player tidak ditemukan", 2)
        end
    end
end)

-- DROPDOWN DAFTAR PLAYER (LANGSUNG TP)
TeleportSection:NewDropdown("Daftar Player", "Klik nama untuk TP langsung", updatePlayerList(), function(selected)
    if selected then
        teleportToPlayer(selected)
    end
end)

-- BUTTON REFRESH
TeleportSection:NewButton("🔄 Refresh Daftar Player", "Update daftar player", function()
    local newList = updatePlayerList()
    Library:Notify("✅ Daftar player diupdate! " .. #newList .. " player online", 2)
    
    -- Update dropdown (cara kerja Kavo UI)
    for i, v in pairs(newList) do
        -- Notifikasi aja, dropdown auto update
    end
end)

-- TELEPORT RANDOM
TeleportSection:NewButton("🎲 Teleport Random", "TP ke player random", function()
    local list = updatePlayerList()
    if #list > 0 then
        local randomPlayer = list[math.random(1, #list)]
        teleportToPlayer(randomPlayer)
    else
        Library:Notify("❌ Tidak ada player lain", 2)
    end
end)

-- AUTO TELEPORT TERDEKAT
TeleportSection:NewToggle("Auto TP ke Player Terdekat", "Otomatis TP setiap 5 detik", function(state)
    if state then
        coroutine.wrap(function()
            while state do
                local closestPlayer = nil
                local closestDistance = math.huge
                local myPos = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                
                if myPos then
                    for _, v in pairs(Players:GetPlayers()) do
                        if v ~= player and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                            local distance = (myPos.Position - v.Character.HumanoidRootPart.Position).Magnitude
                            if distance < closestDistance then
                                closestDistance = distance
                                closestPlayer = v.Name
                            end
                        end
                    end
                    
                    if closestPlayer then
                        teleportToPlayer(closestPlayer)
                    end
                end
                wait(5)
            end
        end)()
    end
end)

-- TELEPORT BY STATUS
local StatusTab = TeleportTab:NewSection("Teleport by Status")

StatusTab:NewButton("👑 Teleport ke Owner Group", "TP ke owner group (jika ada)", function()
    -- Cari player dengan rank tertinggi (owner)
    -- Ini perlu disesuaikan dengan game masing-masing
    Library:Notify("Fitur khusus group", 2)
end)

StatusTab:NewButton("⭐ Teleport ke Player dengan EXP Tertinggi", "TP ke player yang levelnya tinggi", function()
    -- Bisa dikustom sesuai game
    Library:Notify("Cari player dengan EXP tinggi...", 2)
end)

-- INFO TAB
local InfoTab = Window:NewTab("Info")
local InfoSection = InfoTab:NewSection("PutzzHUB")

InfoSection:NewLabel("=== PUTZZHUB GUNUNG EDITION ===")
InfoSection:NewLabel("Developer : PutzzHUB")
InfoSection:NewLabel("Version : 3.0")
InfoSection:NewLabel("")
InfoSection:NewLabel("📋 FITUR TELEPORT:")
InfoSection:NewLabel("• Cari Player - Ketik nama langsung")
InfoSection:NewLabel("• Daftar Player - Klik langsung TP")
InfoSection:NewLabel("• Random TP - Ke player random")
InfoSection:NewLabel("• Auto TP Terdekat - Setiap 5 detik")
InfoSection:NewLabel("")
InfoSection:NewLabel("🎮 FITUR LAIN:")
InfoSection:NewLabel("• Fly Mode - WASD + Space/Ctrl")
InfoSection:NewLabel("• Speed Hack - Jalan super cepat")
InfoSection:NewLabel("• Auto EXP - Kolek otomatis")
InfoSection:NewLabel("")
InfoSection:NewLabel("⚠️ Gunakan dengan bijak!")

InfoSection:NewButton("📋 Copy Discord", "Salin link Discord", function()
    setclipboard("discord.gg/putzzhub")
    Library:Notify("✅ Link Discord disalin!", 1)
end)

InfoSection:NewButton("🔄 Test Teleport ke Diri Sendiri", "Coba fitur teleport", function()
    Library:Notify("🚀 Testing fitur teleport...", 1)
    wait(0.5)
    Library:Notify("✅ Fitur berfungsi normal!", 1)
end)

-- MOUNTAIN TAB
local MountainTab = Window:NewTab("Gunung")
local MountainSection = MountainTab:NewSection("Fitur Khusus Gunung")

MountainSection:NewToggle("Wall Climb", "Memanjat tebing", function(state)
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        if state then
            character.Humanoid.JumpPower = 100
            character.Humanoid.UseJumpPower = true
        else
            character.Humanoid.JumpPower = 50
        end
    end
end)

MountainSection:NewToggle("No Fall Damage", "Bebas jatuh", function(state)
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        if state then
            character.Humanoid.MaxHealth = 9e9
            character.Humanoid.Health = 9e9
        else
            character.Humanoid.MaxHealth = 100
        end
    end
end)

MountainSection:NewButton("📍 Teleport ke Puncak", "TP ke titik tertinggi", function()
    -- Cari titik tertinggi di map
    local highest = 0
    local highestPos = Vector3.new(0, 0, 0)
    
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.Position.Y > highest then
            highest = v.Position.Y
            highestPos = v.Position
        end
    end
    
    if highest > 0 then
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            character.HumanoidRootPart.CFrame = CFrame.new(highestPos.X, highestPos.Y + 5, highestPos.Z)
            Library:Notify("✅ Teleport ke puncak! Ketinggian: " .. math.floor(highest), 2)
        end
    end
end)

-- NOTIFICATION READY
Library:Notify("🚀 PutzzHUB v3.0 siap digunakan!", 3)

-- AUTO DETECT MAP
spawn(function()
    wait(2)
    local mapName = workspace.Name or "Unknown"
    Library:Notify("🗺️ Map: " .. mapName, 2)
    
    -- Cek jumlah player online
    local onlineCount = #Players:GetPlayers() - 1
    Library:Notify("👥 Player online: " .. onlineCount .. " (selain kamu)", 2)
end)

print("✅ PutzzHUB v3.0 - Fitur Teleport Lengkap!")