--[[ PUTZZHUB MOBILE FULL VERSION ]]

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local humanoid = char:WaitForChild("Humanoid")
local root = char:WaitForChild("HumanoidRootPart")

local flying = false
local speedOn = false
local holoOn = false
local flySpeed = 60

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui
gui.ResetOnSpawn = false

local frame = Instance.new("Frame")
frame.Parent = gui
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Size = UDim2.new(0,200,0,200)
frame.Position = UDim2.new(0.1,0,0.3,0)
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1,0,0,30)
title.BackgroundColor3 = Color3.fromRGB(20,20,20)
title.Text = "Putzzdev-HUB"
title.TextColor3 = Color3.fromRGB(255,255,0)

-- OPEN CLOSE BUTTON
local toggleBtn = Instance.new("TextButton")
toggleBtn.Parent = gui
toggleBtn.Size = UDim2.new(0,60,0,30)
toggleBtn.Position = UDim2.new(0,10,0.5,0)
toggleBtn.Text = "CLOSE"
toggleBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
toggleBtn.TextColor3 = Color3.new(1,1,1)

local menuOpen = true
toggleBtn.MouseButton1Click:Connect(function()
	menuOpen = not menuOpen
	frame.Visible = menuOpen
	toggleBtn.Text = menuOpen and "CLOSE" or "OPEN"
end)

-- FLY BUTTON
local btnFly = Instance.new("TextButton")
btnFly.Parent = frame
btnFly.Text = "Fly OFF"
btnFly.Size = UDim2.new(0.8,0,0,30)
btnFly.Position = UDim2.new(0.1,0,0.25,0)

-- SPEED BUTTON
local btnSpeed = Instance.new("TextButton")
btnSpeed.Parent = frame
btnSpeed.Text = "Speed OFF"
btnSpeed.Size = UDim2.new(0.8,0,0,30)
btnSpeed.Position = UDim2.new(0.1,0,0.5,0)

-- HOLOGRAM BUTTON
local btnHolo = Instance.new("TextButton")
btnHolo.Parent = frame
btnHolo.Text = "Hologram Player OFF"
btnHolo.Size = UDim2.new(0.8,0,0,30)
btnHolo.Position = UDim2.new(0.1,0,0.75,0)

-- FLY SYSTEM (Analog)
local bv
local runService = game:GetService("RunService")

btnFly.MouseButton1Click:Connect(function()

	flying = not flying

	if flying then

		btnFly.Text = "Fly ON"

		bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(100000,100000,100000)
		bv.Parent = root

		humanoid.PlatformStand = true

		runService.RenderStepped:Connect(function()

			if flying and bv then
				local moveDir = humanoid.MoveDirection
				bv.Velocity = moveDir * flySpeed
			end

		end)

	else

		btnFly.Text = "Fly OFF"

		if bv then
			bv:Destroy()
		end

		humanoid.PlatformStand = false

	end

end)

-- SPEED SYSTEM
btnSpeed.MouseButton1Click:Connect(function()

	speedOn = not speedOn

	if speedOn then
		btnSpeed.Text = "Speed ON"
		humanoid.WalkSpeed = 60
	else
		btnSpeed.Text = "Speed OFF"
		humanoid.WalkSpeed = 16
	end

end)

-- HOLOGRAM PLAYER SYSTEM
btnHolo.MouseButton1Click:Connect(function()

	holoOn = not holoOn

	if holoOn then

		btnHolo.Text = "Hologram Player ON"

		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr ~= player then

				local c = plr.Character
				if c then

					for _,v in pairs(c:GetDescendants()) do
						if v:IsA("BasePart") then
							v.Material = Enum.Material.Neon
							v.Transparency = 0.5
							v.Color = Color3.fromRGB(0,255,255)
						end
					end

				end

			end
		end

	else

		btnHolo.Text = "Hologram Player OFF"

		for _,plr in pairs(game.Players:GetPlayers()) do
			if plr ~= player then

				local c = plr.Character
				if c then

					for _,v in pairs(c:GetDescendants()) do
						if v:IsA("BasePart") then
							v.Material = Enum.Material.Plastic
							v.Transparency = 0
						end
					end

				end

			end
		end

	end

end)