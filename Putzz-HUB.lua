--// PUTZZ HUB V2

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "PutzzHub"

-- OPEN BUTTON
local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0,50,0,50)
openBtn.Position = UDim2.new(0.02,0,0.4,0)
openBtn.Text = "P"
openBtn.TextScaled = true
openBtn.BackgroundColor3 = Color3.fromRGB(0,0,0)
openBtn.TextColor3 = Color3.fromRGB(255,255,0)

-- MAIN FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,220,0,200)
frame.Position = UDim2.new(0.1,0,0.3,0)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Visible = false
frame.Active = true
frame.Draggable = true

-- TITLE
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,30)
title.Text = "PUTZZ HUB"
title.TextColor3 = Color3.fromRGB(255,255,0)
title.BackgroundColor3 = Color3.fromRGB(15,15,15)

-- CLOSE BUTTON
local close = Instance.new("TextButton", frame)
close.Size = UDim2.new(0,25,0,25)
close.Position = UDim2.new(1,-30,0,2)
close.Text = "X"
close.BackgroundColor3 = Color3.fromRGB(120,0,0)
close.TextColor3 = Color3.new(1,1,1)

-- FEATURE FRAME
local featureFrame = Instance.new("Frame", frame)
featureFrame.Size = UDim2.new(1,0,1,-30)
featureFrame.Position = UDim2.new(0,0,0,30)
featureFrame.BackgroundTransparency = 1

-- BUTTON MAKER
function makeButton(text,y)
    local b = Instance.new("TextButton", featureFrame)
    b.Size = UDim2.new(0.8,0,0,30)
    b.Position = UDim2.new(0.1,0,0,y)
    b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(50,50,50)
    b.TextColor3 = Color3.new(1,1,1)
    return b
end

-- BUTTONS
local flyBtn = makeButton("Fly + Speed",0.05)
local expNameBtn = makeButton("EXP Name",0.25)
local expCharBtn = makeButton("EXP Character",0.45)
local holoBtn = makeButton("Hologram Player",0.65)

-- OPEN CLOSE
openBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
end)

close.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- FLY SYSTEM
local flying = false
local speed = 60

flyBtn.MouseButton1Click:Connect(function()

    flying = not flying

    if flying then

        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(9e9,9e9,9e9)
        bv.Parent = root

        while flying do
            local cam = workspace.CurrentCamera
            local dir = hum.MoveDirection

            bv.Velocity =
                (cam.CFrame.LookVector * dir.Z +
                cam.CFrame.RightVector * dir.X) * speed

            game:GetService("RunService").RenderStepped:Wait()
        end

        bv:Destroy()

    end
end)

-- EXP NAME EFFECT
expNameBtn.MouseButton1Click:Connect(function()

    local billboard = Instance.new("BillboardGui", root)
    billboard.Size = UDim2.new(0,200,0,50)
    billboard.StudsOffset = Vector3.new(0,3,0)

    local text = Instance.new("TextLabel", billboard)
    text.Size = UDim2.new(1,0,1,0)
    text.BackgroundTransparency = 1
    text.Text = player.Name.." EXP"
    text.TextColor3 = Color3.fromRGB(0,255,0)
    text.TextScaled = true

end)

-- EXP CHARACTER EFFECT
expCharBtn.MouseButton1Click:Connect(function()

    for i=1,10 do
        local p = Instance.new("Part", workspace)
        p.Size = Vector3.new(0.5,0.5,0.5)
        p.Position = root.Position + Vector3.new(math.random(-3,3),math.random(1,4),math.random(-3,3))
        p.Anchored = true
        p.Material = Enum.Material.Neon
        p.Color = Color3.fromRGB(0,255,100)

        game.Debris:AddItem(p,1)
    end

end)

-- HOLOGRAM PLAYER
holoBtn.MouseButton1Click:Connect(function()

    for _,v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.Material = Enum.Material.ForceField
            v.Color = Color3.fromRGB(0,255,255)
            v.Transparency = 0.3
        end
    end

end)