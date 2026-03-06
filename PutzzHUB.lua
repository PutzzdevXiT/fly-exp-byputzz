--[[ PUTZZHUB STANDALONE (NO EXTERNAL LIBRARY) ]]
local gui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local title = Instance.new("TextLabel")
local btnFly = Instance.new("TextButton")
local btnSpeed = Instance.new("TextButton")

gui.Parent = game.Players.LocalPlayer.PlayerGui
frame.Parent = gui
frame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.1, 0, 0.3, 0)
frame.Active = true
frame.Draggable = true

title.Parent = frame
title.Text = "PutzzHUB"
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
title.TextColor3 = Color3.new(1, 1, 0)

btnFly.Parent = frame
btnFly.Text = "Fly ON"
btnFly.Size = UDim2.new(0.8, 0, 0, 30)
btnFly.Position = UDim2.new(0.1, 0, 0.3, 0)

btnSpeed.Parent = frame
btnSpeed.Text = "Speed ON"
btnSpeed.Size = UDim2.new(0.8, 0, 0, 30)
btnSpeed.Position = UDim2.new(0.1, 0, 0.6, 0)

btnFly.MouseButton1Click:Connect(function()
    -- Logika fly sederhana
    print("Fly clicked")
end)

btnSpeed.MouseButton1Click:Connect(function()
    -- Logika speed
    print("Speed clicked")
end)