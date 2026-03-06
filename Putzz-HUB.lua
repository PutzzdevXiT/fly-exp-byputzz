-- PUTZZ HUB

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local UIS = game:GetService("UserInputService")
local RS = game:GetService("RunService")

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "PutzzMod"

local openBtn = Instance.new("TextButton", gui)
openBtn.Size = UDim2.new(0,60,0,60)
openBtn.Position = UDim2.new(0,20,0,200)
openBtn.Text = "PZ"
openBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
openBtn.TextColor3 = Color3.new(1,1,1)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,250,0,300)
frame.Position = UDim2.new(0,100,0,150)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Visible = false

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,40)
title.Text = "PutzzdevHUB"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundTransparency = 1

-- OPEN CLOSE
openBtn.MouseButton1Click:Connect(function()
	frame.Visible = not frame.Visible
end)

-- FLY BUTTON
local flyBtn = Instance.new("TextButton", frame)
flyBtn.Size = UDim2.new(0.8,0,0,40)
flyBtn.Position = UDim2.new(0.1,0,0.2,0)
flyBtn.Text = "FLY"
flyBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)

local flying = false
local speed = 80

flyBtn.MouseButton1Click:Connect(function()
	flying = not flying
	
	local root = char:WaitForChild("HumanoidRootPart")
	local humanoid = char:WaitForChild("Humanoid")
	
	if flying then
		
		humanoid.PlatformStand = true
		
		local bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)
		bv.Parent = root
		
		RS.RenderStepped:Connect(function()
			if flying then
				local cam = workspace.CurrentCamera
				bv.Velocity =
				(cam.CFrame.LookVector * humanoid.MoveDirection.Z +
				cam.CFrame.RightVector * humanoid.MoveDirection.X)
				* speed
			end
		end)
		
	else
		humanoid.PlatformStand = false
	end
end)

-- EXP LASER
local expBtn = Instance.new("TextButton", frame)
expBtn.Size = UDim2.new(0.8,0,0,40)
expBtn.Position = UDim2.new(0.1,0,0.4,0)
expBtn.Text = "EXP LASER"
expBtn.BackgroundColor3 = Color3.fromRGB(255,60,60)

expBtn.MouseButton1Click:Connect(function()

	local root = char:WaitForChild("HumanoidRootPart")

	for i = 1,10 do
		local beam = Instance.new("Part")
		beam.Anchored = true
		beam.CanCollide = false
		beam.Material = Enum.Material.Neon
		beam.Color = Color3.fromRGB(255,0,0)
		beam.Size = Vector3.new(1,1,50)
		beam.CFrame = root.CFrame * CFrame.new(0,0,-25)
		beam.Parent = workspace
		
		game.Debris:AddItem(beam,0.2)
	end
	
end)