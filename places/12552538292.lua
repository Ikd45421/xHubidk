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
local repStorage = game:GetService("ReplicatedStorage")
local proximityPromptService = game:GetService("ProximityPromptService")

local loaded = repStorage:WaitForChild("Loaded")

local options = getgenv().Linoria.Options
local toggles = getgenv().Linoria.Toggles

local player = players.LocalPlayer
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
    Notifiers = window:AddTab("Notifiers"),
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
    if not getgenv().pressurehub_loaded then return end

    local speedBoost = options.SpeedBoost.Value

    if speedBoost == 0 or humanoid.WalkSpeed == 0 then return end
    if humanoid.WalkSpeed == 16 + speedBoost then return end

    humanoid.WalkSpeed = 16 + speedBoost
end)

main.Interaction:AddToggle("InstantInteract", {
    Text = "Instant Interact"
})

proximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if not getgenv().pressurehub_loaded then return end

    if not toggles.InstantInteract.Value then return end

    fireproximityprompt(prompt)
end)

main.Sound:AddToggle("NoAmbience", {
    Text = "No Ambience"
})

task.spawn(function()
    loaded.Changed:Wait()

    workspace:WaitForChild("AmbiencePart").ChildAdded:Connect(function(sound)
        if toggles.NoAmbience.Value then
            sound.Volume = 0
        end
    end)
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
    if not getgenv().pressurehub_loaded then return end

    if not workspace.Characters:FindFirstChild(player.Name) then return end

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


local notifiers = {
    Entity = tabs.Notifiers:AddLeftGroupbox("Entity"),
    Rooms = tabs.Notifiers:AddRightGroupbox("Rooms"),
    Settings = tabs.Notifiers:AddLeftGroupbox("Settings")
}

notifiers.Entity:AddToggle("NodeMonsterNotifier", {
    Text = "Node Monster Notifier"
})

notifiers.Entity:AddToggle("PandemoniumNotifier", {
    Text = "Pandemonium Notifier"
})

notifiers.Entity:AddToggle("WallDwellerNotifier", {
    Text = "Wall Dweller Notifier"
})

notifiers.Entity:AddToggle("EyefestationNotifier", {
    Text = "Eyefestation Notifier"
})

notifiers.Entity:AddToggle("TurretNotifier", {
    Text = "Turret Notifier"
})

notifiers.Rooms:AddToggle("DangerousRoomNotifier", {
    Text = "Dangerous Room Notifier"
})

notifiers.Settings:AddToggle("NotifySound", {
    Text = "Notify Sound"
})

workspace.ChildAdded:Connect(function(child)
    if not getgenv().pressurehub_loaded then return end

    local roomNumber = repStorage.Events.CurrentRoomNumber:InvokeServer()

    if roomNumber == 100 then return end

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
    if not getgenv().pressurehub_loaded then return end

    if toggles.WallDwellerNotifier.Value and monster.Name == "WallDweller" then
        getgenv():Alert("A Wall Dweller has spawned somewhere in the walls. Find it!", 10)
    end
end)

workspace:WaitForChild("Rooms").ChildAdded:Connect(function(room)
    if not getgenv().pressurehub_loaded then return end

    if toggles.DangerousRoomNotifier.Value and string.match(room.Name, "RoundaboutDestroyed") then
        getgenv():Alert("The next room has a big hole in the middle. Be careful!", 10)
    end

    if toggles.TurretNotifier.Value and string.match(room.Name, "Turret") then
        getgenv():Alert("Turrets will spawn in the next room. Be careful!", 10)
    end

    local interactables = room:WaitForChild("Interactables")

    if (interactables:FindFirstChild("EyefestationSpawn")) then
        getgenv():Alert("Eyefestation will spawn in the next room. Be careful!", 10)
    end
end)


------------------------------------------------


local tracers = {
    Items = tabs.Tracers:AddRightGroupbox("Items"),
    Entities = tabs.Tracers:AddLeftGroupbox("Entities"),
    Other = tabs.Tracers:AddLeftGroupbox("Other")
}

tracers.Items:AddToggle("ItemsTracer", {
    Text = "Items"
})

tracers.Items:AddToggle("KeycardsTracer", {
    Text = "Keycards"
})

tracers.Items:AddToggle("MoneyTracer", {
    Text = "Money"
})
tracers.Entities:AddToggle("PlayersTracer", {
    Text = "Players"
})

tracers.Entities:AddToggle("NodeMonstersTracer", {
    Text = "Node Monsters"
})

tracers.Entities:AddToggle("PandemoniumNotifier", {
    Text = "Pandemonium"
})

tracers.Entities:AddToggle("WallDwellerNotifier", {
    Text = "Wall Dwellers"
})

tracers.Entities:AddToggle("EyefestationNotifier", {
    Text = "Eyefestation"
})

tracers.Entities:AddToggle("TurretNotifier", {
    Text = "Turrets"
})

tracers.Other:AddToggle("GeneratorsTracer", {
    Text = "Generators"
})


------------------------------------------------


local settings = {
    Config = tabs.Settings:AddLeftGroupbox("Config"),
    Credits = tabs.Settings:AddRightGroupbox("Credits")
}

settings.Config:AddToggle("KeybindMenu", {
    Text = "Open Keybind Menu",
    Callback = function(value) library.KeybindFrame.Visible = value end
})

settings.Config:AddToggle("CustomCursor", {
    Text = "Show Custom Cursor",
    Default = true,
    Callback = function(value) library.ShowCustomCursor = value end
})

settings.Config:AddDivider()

settings.Config:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {
    Text = "Menu Keybind",
    NoUI = true,
    Default = "RightShift"
})

settings.Config:AddButton("Unload", library.Unload)

settings.Credits:AddLabel("xBackpack - Creator & Scripter")

library:OnUnload(function()
    lighting.Ambient = Color3.fromRGB(40, 53, 65)
    getgenv().pressurehub_loaded = false
    getgenv().Alert("Unloaded!")
    task.wait(1)
end)
