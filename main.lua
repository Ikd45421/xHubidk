-- loadstring(game:HttpGet("https://raw.githubusercontent.com/xBackpack/PressureHub/main/main.lua"))()

local uis = game:GetService("UserInputService")
local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local camera = workspace.Camera

local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character.Humanoid

local repo = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
local addons = repo .. "addons/"

local library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local themeManager = loadstring(game:HttpGet(addons .. 'ThemeManager.lua'))()
local saveManager = loadstring(game:HttpGet(addons .. 'SaveManager.lua'))()

local privateRepo = "https://raw.githubusercontent.com/xBackpack/PressureHub/main/"

local lighting = loadstring(game:HttpGet(privateRepo .. 'Lighting.lua'))()
local interactions = loadstring(game:HttpGet(privateRepo .. 'Interactions.lua'))()

local options = getgenv().Options
local toggles = getgenv().Toggles

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

player.Movement:AddSlider(0, {
		Text = "Speed Boost",
		Default = 0,
		Min = 0,
		Max = 100,
		Rounding = 0,
		Callback = function(value) humanoid.WalkSpeed = 16 + value end
	}
)

player.Interaction:AddToggle(0, {
		Text = "Instant Interact",
		Default = false,
		Risky = false,
		Callback = function(value) interactions:SetInstantInteract(value) end
})

visual.Lighting:AddToggle(1, {
		Text = "Fullbright",
		Default = false,
		Risky = false,
		Callback = function(value) lighting:SetFullbright(value) end
			-- if value then
			-- 	lighting.Brightness = 25
			-- 	lighting.Ambient = Color3.fromRGB(255, 255, 255)
			-- else
			-- 	lighting.Brightness = 3
			-- 	lighting.Ambient = Color3.fromRGB(40, 53, 65)
			-- end
	}
)

visual.Camera:AddSlider(1, {
		Text = "FOV",
		Default = 70,
		Min = 30,
		Max = 120,
		Rounding = 0, 
		Callback = function(value) camera.FieldOfView = value end
	}
)

settings.Config:AddButton("Unload", function()
		Options[0]:SetValue(0)
		Options[1]:SetValue(70)
	
		for _, toggle in next, Toggles do
			toggle:SetValue(false)
		end
		
		Library:Unload()
	end
)
