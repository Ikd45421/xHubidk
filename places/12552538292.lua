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

-- HUB --
local plr = players.LocalPlayer
local character = plr.Character or plr.CharacterAdded:Wait()
local humanoid = character.Humanoid
local camera = workspace.Camera

local window = library:CreateWindow({
    Title = "Pressure Hub - " .. plr.DisplayName,
    Center = true,
    AutoShow = true
})

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
    Camera = tabs.Visual:AddLeftGroupbox("Camera"),
    Tracers = tabs.Visual:AddLeftGroupbox("Tracers"),
    Lighting = tabs.Visual:AddRightGroupbox("Lighting")
}

local settings = {
    Config = tabs.Settings:AddLeftGroupbox("Config")
}

player.Movement:AddSlider("SpeedBoost", {
    Text = "Speed Boost",
    Default = 0,
    Min = 0,
    Max = 30,
    Rounding = 0,
    Callback = function(value) humanoid.WalkSpeed = 16 + value end
})

player.Interaction:AddToggle("InstantInteract", {
    Text = "Instant Interact"
})

visual.Camera:AddSlider("FieldOfView", {
    Text = "Field Of View",
    Default = 90,
    Min = 30,
    Max = 120,
    Rounding = 0,
    Callback = function(value) camera.FieldOfView = value end
})

visual.Tracers:AddToggle("ItemsTracer", {
    Text = "Items"
}):AddColorPicker("ItemsTracerColorPicker", {
    Default = Color3.fromRGB(255, 0, 0) -- Red
})

visual.Tracers:AddToggle("KeycardsTracer", {
    Text = "Keycards"
}):AddColorPicker("KeycardsTracerColorPicker", {
    Default = Color3.fromRGB(0, 0, 255) -- Aqua
})

visual.Tracers:AddToggle("MoneyTracer", {
    Text = "Money"
}):AddColorPicker("MoneyTracerColorPicker", {
    Default = Color3.fromRGB(255, 255, 0) -- Yellow
})

visual.Tracers:AddToggle("PlayersTracer", {
    Text = "Players"
}):AddColorPicker("PlayersTracerColorPicker", {
    Default = Color3.fromRGB(255, 255, 255) -- White
})

visual.Lighting:AddToggle("Fullbright", {
    Text = "Fullbright",
    Callback = function(value)
        if value then
            lighting.Ambient = Color3.fromRGB(255, 255, 255)
        else
            lighting.Ambient = Color3.fromRGB(40, 53, 65)
        end
    end
})

settings.Config:AddButton("Unload", function()
    lighting.Ambient = Color3.fromRGB(40, 53, 65)

    library:Unload()
end)
