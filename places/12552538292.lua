local library = getgenv().Library

if not getgenv().pressurehub_loaded then
    getgenv().pressurehub_loaded = true
else
    library:Notify("Already Loaded!")
    return
end

-- SERVICES --
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local players = game:GetService("Players")
local proximityPromptService = game:GetService("ProximityPromptService")

local options = getgenv().Linoria.Options
local toggles = getgenv().Linoria.Toggles

local player = players.LocalPlayer
local playerFolder = player:WaitForChild("PlayerFolder")
local doorsOpened = playerFolder:WaitForChild("DoorsOpened")
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character.Humanoid
local camera = workspace.Camera

local nodeMonsters = {
    "Angler",
    "Froger",
    "Pinkie",
    "Chainsmoker",
    "Blitz",
    "RidgeAngler",
    "RidgeFroger",
    "RidgePinkie",
    "RidgeChainsmoker",
    "RidgeBlitz"
}

-- HUB --
local window = library:CreateWindow({
    Title = "Pressure Hub",
    Center = true,
    AutoShow = true
})

local tabs = {
    Main = window:AddTab("Main"),
    Visual = window:AddTab("Visual"),
    Entity = window:AddTab("Entity"),
    Tracers = window:AddTab("Tracers"),
    Settings = window:AddTab("Settings")
}

local main = {
    Movement = tabs.Main:AddLeftGroupbox("Movement"),
    Interaction = tabs.Main:AddRightGroupbox("Interaction"),
    Sound = tabs.Main:AddLeftGroupbox("Sound")
}

main.Movement:AddSlider("SpeedBoost", {
    Text = "Speed Boost",
    Default = 0,
    Min = 0,
    Max = 45,
    Rounding = 0,
    Callback = function(value) humanoid.WalkSpeed = 16 + value end
})

humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
    if not getgenv().PressureHubLoaded then return end

    local speedBoost = options.SpeedBoost.Value

    if speedBoost == 0 or humanoid.WalkSpeed == 0 then return end
    if humanoid.WalkSpeed == 16 + speedBoost then return end

    humanoid.WalkSpeed = 16 + speedBoost
end)

main.Interaction:AddToggle("InstantInteract", {
    Text = "Instant Interact"
})

proximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if not getgenv().PressureHubLoaded then return end

    if not toggles.InstantInteract.Value then return end

    fireproximityprompt(prompt)
end)

main.Sound:AddToggle("NoAmbience", {
    Text = "No Ambience"
})

workspace:WaitForChild("AmbiencePart").ChildAdded:Connect(function(sound)
    if toggles.NoAmbience.Value then
        sound.Volume = 0
    end
end)


------------------------------------------------


local visual = {
    Camera = tabs.Visual:AddLeftGroupbox("Camera"),
    Lighting = tabs.Visual:AddRightGroupbox("Lighting")
}

visual.Camera:AddSlider("FieldOfView", {
    Text = "Field Of View",
    Default = 90,
    Min = 30,
    Max = 120,
    Rounding = 0,
    Callback = function(value) camera.FieldOfView = value end
})

camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
    if not getgenv().PressureHubLoaded then return end

    local fov = options.FieldOfView.Value

    if fov == 90 then return end
    if camera.FieldOfView == fov then return end

    camera.FieldOfView = fov
end)

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


------------------------------------------------


local entity = {
    Notifiers = tabs.Entity:AddLeftGroupbox("Notifiers")
}

entity.Notifiers:AddToggle("NodeMonsterNotifier", {
    Text = "Node Monster Notifier"
})

entity.Notifiers:AddToggle("PandemoniumNotifier", {
    Text = "Pandemonium Notifier"
})

entity.Notifiers:AddToggle("WallDwellerNotifier", {
    Text = "Wall Dweller Notifier"
})

entity.Notifiers:AddToggle("EyefestationNotifier", {
    Text = "Eyefestation Notifier"
})

entity.Notifiers:AddToggle("TurretNotifier", {
    Text = "Turret Notifier"
})

entity.Notifiers:AddDivider()

entity.Notifiers:AddToggle("NotifySound", {
    Text = "Notify Sound"
})

workspace.ChildAdded:Connect(function(child)
    if not getgenv().PressureHubLoaded then return end

    if doorsOpened.Value == 100 then return end

    if toggles.NodeMonsterNotifier.Value then
        for _, monster in ipairs(nodeMonsters) do
            if child.Name == monster then
                local str = monster
                if (string.match(monster, "Ridge")) then
                    str = string.sub(monster, 6)
                end
                getgenv():Alert(str .. " spawned. Hide!", 10)
            end
        end
    end

    if toggles.PandemoniumNotifier.Value and child.Name == "Pandemonium" then
        getgenv():Alert("Pandemonium spawned. Good luck!", 10)
    end
end)

workspace:WaitForChild("Monsters").ChildAdded:Connect(function(monster)
    if not getgenv().PressureHubLoaded then return end

    if toggles.WallDwellerNotifier.Value and monster.Name == "WallDweller" then
        getgenv():Alert("A Wall Dweller has spawned somewhere in the room's walls. Find it!", 10)
    end
end)

workspace:WaitForChild("Rooms").ChildAdded:Connect(function(room)
    if not getgenv().PressureHubLoaded then return end

    if toggles.TurretNotifier.Value and string.match(room.Name, "Turret") then
        getgenv():Alert("Turrets will spawn in the next room. Be Careful!", 10)
    end

    local interactables = room:WaitForChild("Interactables")

    if (interactables:FindFirstChild("EyefestationSpawn")) then
        getgenv():Alert("Eyefestation will spawn in the next room. Be Careful!")
    end
end)


------------------------------------------------


local tracers = {
    Player = tabs.Tracers:AddLeftGroupbox("Players"),
    NodeMonsters = tabs.Tracers:AddRightGroupbox("Node Monsters"),
}

visual.Tracers:AddToggle("ItemsTracer", {
    Text = "Items"
}):AddColorPicker("ItemsTracerColorPicker", {
    Default = Color3.fromRGB(0, 255, 0) -- Green
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

visual.Tracers:AddToggle("MonstersTracer", {
    Text = "Monsters"
}):AddColorPicker("MonstersTracerColorPicker", {
    Default = Color3.fromRGB(255, 0, 0) -- Red
})

visual.Tracers:AddToggle("GeneratorsTracer", {
    Text = "Generators"
}):AddColorPicker("GeneratorsTracerColorPicker", {
    Default = Color3.fromRGB(255, 127, 0) -- Orange
})


------------------------------------------------


local settings = {
    Config = tabs.Settings:AddLeftGroupbox("Config")
}

settings.Config:AddButton("Unload", library.Unload)

library:OnUnload(function()
    lighting.Ambient = Color3.fromRGB(40, 53, 65)
    getgenv().pressurehub_loaded = false
    getgenv().Alert("Unloaded!")
    task.wait(1)
end)
