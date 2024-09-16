local library = getgenv().Library

if not getgenv().PressureHubLoaded then
    getgenv().PressureHubLoaded = true
else
    library:Notify("Already Loaded!")
    return
end

-- SERVICES --
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")

-- LIBRARIES --
local repo = "https://raw.githubusercontent.com/xBackpack/PressureHub/main/utils/"

loadstring(game:HttpGet(repo .. "InteractionManager.lua"))()
loadstring(game:HttpGet(repo .. "MovementManager.lua"))()
loadstring(game:HttpGet(repo .. "FieldOfViewManager.lua"))()
loadstring(game:HttpGet(repo .. "NotifyManager.lua"))()
-- loadstring(game:HttpGet(repo .. "ESPManager.lua"))(

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
    Entity = window:AddTab("Entity"),
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

local entity = {
    Notifiers = tabs.Entity:AddLeftGroupbox("Notifiers")
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

local tracers = {
    Items = visual.Tracers:AddToggle("ItemsTracer", {
        Text = "Items"
    }):AddColorPicker("ItemsTracerColorPicker", {
        Default = Color3.fromRGB(0, 255, 0) -- Green
    }),

    Keycards = visual.Tracers:AddToggle("KeycardsTracer", {
        Text = "Keycards"
    }):AddColorPicker("KeycardsTracerColorPicker", {
        Default = Color3.fromRGB(0, 0, 255) -- Aqua
    }),

    Money = visual.Tracers:AddToggle("MoneyTracer", {
        Text = "Money"
    }):AddColorPicker("MoneyTracerColorPicker", {
        Default = Color3.fromRGB(255, 255, 0) -- Yellow
    }),

    Players = visual.Tracers:AddToggle("PlayersTracer", {
        Text = "Players"
    }):AddColorPicker("PlayersTracerColorPicker", {
        Default = Color3.fromRGB(255, 255, 255) -- White
    }),

    Monsters = visual.Tracers:AddToggle("MonstersTracer", {
        Text = "Monsters"
    }):AddColorPicker("MonstersTracerColorPicker", {
        Default = Color3.fromRGB(255, 0, 0) -- Red
    })
}

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

local notifiers = {
    NodeMonsters = entity.Notifiers:AddToggle("NodeMonsterNotifier", {
        Text = "Node Monster Notifier"
    }),

    Pandemonium = entity.Notifiers:AddToggle("PandemoniumNotifier", {
        Text = "Pandemonium Notifier"
    })
}

settings.Config:AddButton("Unload", function()
    lighting.Ambient = Color3.fromRGB(40, 53, 65)
    getgenv().PressureHubLoaded = false
    library:Unload()
end)
