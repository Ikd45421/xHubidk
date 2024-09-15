-- SERVICES --
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")
local proximityPromptService = game:GetService("ProximityPromptService")

-- LIBRARIES --
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
	Camera = tabs.Visual:AddRightGroupbox("Camera")
}

local settings = {
	Config = tabs.Settings:AddLeftGroupbox("Config")
}

-- SPEED --
local speedBoost = player.Movement:AddSlider(0, {
		Text = "Speed Boost",
		Default = 0,
		Min = 0,
		Max = 30,
		Rounding = 0,
		Callback = function(value) humanoid.WalkSpeed = 16 + value end
	}
)

player.Crouching.Changed:Connect(function(newValue)
		if speedBoost.Value == 0 then return end
		
		humanoid.WalkSpeed = 16 + speedBoost.Value
	end
)

-- Interactions --
local instantInteract = player.Interaction:AddToggle(0, {
		Text = "Instant Interact"
	}
)

proximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
		if not instantInteract.Value then return end

		prompt.HoldDuration = 0
	end
)

-- Fullbright --
visual.Lighting:AddToggle(1, {
		Text = "Fullbright",
		Callback = function(value) lighting.Ambient = if value then Color3.fromRGB(255, 255, 255) else Color3.fromRGB(40, 53, 65) end end
	}
)

-- Field of View --
local FOV = visual.Camera:AddSlider(1, {
		Text = "FOV",
		Default = 90,
		Min = 30,
		Max = 120,
		Rounding = 0, 
		Callback = function(value) camera.FieldOfView = value end
	}
)

-- Unload --
settings.Config:AddButton("Unload", function()
		speedBoost:SetValue(0)
		FOV:SetValue(70)
		for _, toggle in next, Toggles do toggle:SetValue(false) end
	
		Library:Unload()
	end
)
