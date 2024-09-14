local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local lighting = game:GetService("Lighting")

local camera = workspace.Camera

local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character.Humanoid

local repo = "https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/"
local addons = repo .. "addons/"

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(addons .. 'ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(addons .. 'SaveManager.lua'))()

local UI = Library:CreateWindow({
	Title = "Pressure - " .. player.DisplayName,
	Center = true,
	AutoShow = true
})

local Tabs = {
	Player = UI:AddTab("Player"),
	Visual = UI:AddTab("Visual"),
	Settings = UI:AddTab("Settings")
}

local Player = {
	Movement = Tabs.Player:AddLeftGroupbox("Movement")
}

local Visual = {
	Lighting = Tabs.Visual:AddLeftGroupbox("Lighting"),
	Camera = Tabs.Visual:AddRightGroupbox("Camera")
}

local Settings = {
	Config = Tabs.Settings:AddLeftGroupbox("Config")
}

Player.Movement:AddSlider(0, {
	Text = "Walk Speed",
	Default = 16,
	Min = 0,
	Max = 100,
	Rounding = 0,
	Callback = function(value) humanoid.WalkSpeed = value end
})

Visual.Lighting:AddToggle(0, {
	Text = "Fullbright",
	Default = false,
	Risky = false,
	Callback = function(value)
		if value then
			lighting.Brightness = 25
			lighting.Ambient = Color3.fromRGB(255, 255, 255)
		else
			lighting.Brightness = 2
			lighting.Ambient = Color3.fromRGB(70, 70, 70)
		end
	end
})

Visual.Camera:AddSlider(2, {
	Text = "Field of View",
	Default = 70,
	Min = 30,
	Max = 120,
	Rounding = 0,
	Callback = function(value) camera.FieldOfView = value end
})

Settings.Config:AddButton("Unload", function() Library:Unload() end)
