--// PUTZZDEV HUB

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game.CoreGui

-- BUTTON OPEN
local Open = Instance.new("TextButton")
Open.Parent = ScreenGui
Open.Size = UDim2.new(0,50,0,50)
Open.Position = UDim2.new(0,20,0.4,0)
Open.Text = "P"
Open.BackgroundColor3 = Color3.fromRGB(0,170,255)
Open.TextColor3 = Color3.new(1,1,1)
Open.TextScaled = true

-- MAIN MENU
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.Size = UDim2.new(0,220,0,300)
MainFrame.Position = UDim2.new(0,100,0,100)
MainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = true

Open.MouseButton1Click:Connect(function()
	MainFrame.Visible = not MainFrame.Visible
end)

-- TITLE
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.Size = UDim2.new(1,0,0,30)
Title.Text = "Putzzdev-HUB"
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(0,200,255)
Title.TextScaled = true

-- TAB BAR
local TabBar = Instance.new("Frame")
TabBar.Parent = MainFrame
TabBar.Position = UDim2.new(0,0,0,30)
TabBar.Size = UDim2.new(1,0,0,30)
TabBar.BackgroundColor3 = Color3.fromRGB(30,30,30)

local PlayerTab = Instance.new("TextButton")
PlayerTab.Parent = TabBar
PlayerTab.Size = UDim2.new(0.5,0,1,0)
PlayerTab.Text = "PLAYER"
PlayerTab.BackgroundColor3 = Color3.fromRGB(40,40,40)
PlayerTab.TextColor3 = Color3.new(1,1,1)

local ESPTab = Instance.new("TextButton")
ESPTab.Parent = TabBar
ESPTab.Size = UDim2.new(0.5,0,1,0)
ESPTab.Position = UDim2.new(0.5,0,0,0)
ESPTab.Text = "ESP"
ESPTab.BackgroundColor3 = Color3.fromRGB(40,40,40)
ESPTab.TextColor3 = Color3.new(1,1,1)

-- PLAYER FRAME
local PlayerFrame = Instance.new("Frame")
PlayerFrame.Parent = MainFrame
PlayerFrame.Position = UDim2.new(0,0,0,60)
PlayerFrame.Size = UDim2.new(1,0,1,-60)
PlayerFrame.BackgroundTransparency = 1

local PlayerLayout = Instance.new("UIListLayout")
PlayerLayout.Parent = PlayerFrame
PlayerLayout.Padding = UDim.new(0,5)

-- ESP FRAME
local ESPFrame = Instance.new("Frame")
ESPFrame.Parent = MainFrame
ESPFrame.Position = UDim2.new(0,0,0,60)
ESPFrame.Size = UDim2.new(1,0,1,-60)
ESPFrame.BackgroundTransparency = 1
ESPFrame.Visible = false

local ESPLayout = Instance.new("UIListLayout")
ESPLayout.Parent = ESPFrame
ESPLayout.Padding = UDim.new(0,5)

-- TAB SWITCH
PlayerTab.MouseButton1Click:Connect(function()
	PlayerFrame.Visible = true
	ESPFrame.Visible = false
end)

ESPTab.MouseButton1Click:Connect(function()
	PlayerFrame.Visible = false
	ESPFrame.Visible = true
end)

-- BUTTON MAKER
local function makeButton(text,parent)
	local b = Instance.new("TextButton")
	b.Parent = parent
	b.Size = UDim2.new(1,-10,0,40)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	return b
end

-- ESP BUTTONS
local espBtn = makeButton("ESP PLAYER",ESPFrame)
local lineBtn = makeButton("ESP LINE",ESPFrame)

-- PLAYER BUTTONS
local flyBtn = makeButton("FLY",PlayerFrame)
local speedBtn = makeButton("SPEED OFF",PlayerFrame)
local noclipBtn = makeButton("NOCLIP OFF",PlayerFrame)
local invisibleBtn = makeButton("INVISIBLE OFF",PlayerFrame)