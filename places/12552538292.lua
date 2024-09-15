-- SERVICES --
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")

-- LIBRARIES --
local repo = "https://raw.githubusercontent.com/xBackpack/PressureHub/main/utils/"

loadstring(game:HttpGet(repo .. "InteractionManager.lua"))()
loadstring(game:HttpGet(repo .. "MovementManager.lua"))()
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

getgenv().speedBoost = player.Movement:AddSlider(0, {
		Text = "Speed Boost",
		Default = 0,
		Min = 0,
		Max = 30,
		Rounding = 0,
		Callback = function(value) humanoid.WalkSpeed = 16 + value end
	}
)

getgenv().instantInteract = player.Interaction:AddToggle(0, {
		Text = "Instant Interact"
	}
)

getgenv().fullbright = visual.Lighting:AddToggle(1, {
		Text = "Fullbright",
		Callback = function(value) lighting.Ambient = if value then Color3.fromRGB(255, 255, 255) else Color3.fromRGB(40, 53, 65) end
	}
)

getgenv().fieldOfView = visual.Camera:AddSlider(1, {
		Text = "Field Of View",
		Default = 90,
		Min = 30,
		Max = 120,
		Rounding = 0, 
		Callback = function(value) camera.FieldOfView = value end
	}
)

getgenv().ESPs = {
	Item = visual.ESP:AddToggle(2, {
			Text = "Item ESP"
		}
	),
	Door = visual.ESP:AddToggle(3, {
			Text = "Door ESP"
		}
	)
}
	
getgenv().unload = settings.Config:AddButton("Unload", function()
		getgenv().speedBoost:SetValue(0)
		getgenv().fieldOfView:SetValue(70)
		for _, toggle in next, Toggles do toggle:SetValue(false) end
	
		Library:Unload()
	end
)
