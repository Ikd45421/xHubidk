local workspace = game:GetService("Workspace")
local players = game:GetService("Players")

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
	Text = "Aaaa",
	Default = 16,
	Min = 0,
	Max = 150,
	Rounding = 0,
	Callback = function(value) humanoid.WalkSpeed = value end
})

Settings.Config:AddButton("Unload", function() Library:Unload() end)
