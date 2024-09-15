-- SERVICES --
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")

-- LIBRARIES --
local repo = "https://raw.githubusercontent.com/xBackpack/PressureHub/main/utils/"

loadstring(game:HttpGet(repo .. "InteractionManager.lua"))()
loadstring(game:HttpGet(repo .. "MovementManager.lua"))()
loadstring(game:HttpGet(repo .. "FieldOfViewManager.lua"))()
loadstring(game:HttpGet(repo .. "ESPManager.lua"))()

local library = getgenv().Library
local options = getgenv().Linoria.Options
local toggles = getgenv().Linoria.Toggles

-- HUB --
local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character.Humanoid
local camera = workspace.Camera

local window = library:CreateWindow({
		Title = "Pressure Hub - " .. player.DisplayName,
		Center = true,
		AutoShow = true
	}
)

local tabs = {
	Player = window:AddTab("Player"),
	Visual = window:AddTab("Visual"),
	Settings = window:AddTab("Settings")
}

local player = {
	Movement = tabs.Player:AddLeftGroupbox("Movement"),
	Interaction = tabs.Player:AddRightGroupbox("Interaction")
}

local visual = {
	Lighting = tabs.Visual:AddLeftGroupbox("Lighting"),
	Camera = tabs.Visual:AddRightGroupbox("Camera"),
	ESP = tabs.Visual:AddLeftGroupbox("ESP")
}

local settings = {
	Config = tabs.Settings:AddLeftGroupbox("Config")
}

player.Movement:AddSlider(0, {
		Text = "Speed Boost",
		Default = 0,
		Min = 0,
		Max = 30,
		Rounding = 0,
		Callback = function(value) humanoid.WalkSpeed = 16 + value end
	}
)

player.Interaction:AddToggle(0, {
		Text = "Instant Interact"
	}
)

visual.Lighting:AddToggle(1, {
		Text = "Fullbright",
		Callback = function(value) lighting.Ambient = if value then Color3.fromRGB(255, 255, 255) else Color3.fromRGB(40, 53, 65) end
	}
)

visual.Camera:AddSlider(1, {
		Text = "Field Of View",
		Default = 90,
		Min = 30,
		Max = 120,
		Rounding = 0, 
		Callback = function(value) camera.FieldOfView = value end
	}
)

local ESPs = {
	Item = visual.ESP:AddToggle(2, {
			Text = "Item ESP",
			Risky = true
		}
	),
	Door = visual.ESP:AddToggle(3, {
			Text = "Door ESP",
			Risky = true
		}
	),
	Currency = visual.ESP:AddToggle(4, {
			Text = "Currency ESP"
		}
	),
	Key = visual.ESP:AddToggle(5, {
			Text = "Key ESP"
		}
	)
}
	
settings.Config:AddButton("Unload", function()
		toggles[0]:SetValue(0)
		toggles[1]:SetValue(70)
		for _, toggle in next, Toggles do toggle:SetValue(false) end
	
		Library:Unload()
	end
)
