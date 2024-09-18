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
getgenv().GrabCurrentRoom = function()
    return repStorage.Events.CurrentRoomNumber:InvokeServer()
end

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

main.Interaction:AddToggle("InstantInteract", {
    Text = "Instant Interact"
})

main.Sound:AddToggle("NoAmbience", {
    Text = "Mute Ambience",
    Callback = function(value)
        if value then
            local part = workspace:FindFirstChild("AmbiencePart")

            if part then
                for _, child in pairs(part:GetChildren()) do
                    child.Volume = 0
                end
            end
        end
    end
})

main.Sound:AddToggle("NoFootsteps", {
    Text = "Mute Footsteps"
})

humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
    if not getgenv().pressurehub_loaded then return end

    local speedBoost = options.SpeedBoost.Value

    if speedBoost == 0 or humanoid.WalkSpeed == 0 then return end
    if humanoid.WalkSpeed == 16 + speedBoost then return end

    humanoid.WalkSpeed = 16 + speedBoost
end)

proximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if not getgenv().pressurehub_loaded then return end

    if not toggles.InstantInteract.Value then return end

    fireproximityprompt(prompt)
end)

workspace.DescendantAdded:Connect(function(descendant)
    if descendant.Parent.Parent ~= workspace then return end
    if not toggles.NoAmbience.Value then return end

    if descendant:IsA("Sound") and descendant.Parent.Name == "AmbiencePart" then
        descendant.Volume = 0
    end
end)

character.LowerTorso.ChildAdded:Connect(function(child)
    if toggles.NoFootsteps.Value and child:IsA("Sound") then
        child.Volume = 0
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

camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
    if not getgenv().pressurehub_loaded then return end

    if not workspace.Characters:FindFirstChild(player.Name) then return end

    local fov = options.FieldOfView.Value

    if fov == 90 then return end
    if camera.FieldOfView == fov then return end

    camera.FieldOfView = fov
end)


------------------------------------------------

local entity = {
    Exploits = tabs.Entity:AddLeftGroupbox("Exploits")
}

entity.Exploits:AddToggle("AntiEyefestation", {
    Text = "Anti Eyefestation"
})

------------------------------------------------


local notifiers = {
    Entity = tabs.Notifiers:AddLeftGroupbox("Entity"),
    Rooms = tabs.Notifiers:AddRightGroupbox("Rooms")
    -- Settings = tabs.Notifiers:AddLeftGroupbox("Settings")
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

notifiers.Rooms:AddToggle("TurretNotifier", {
    Text = "Turret Notifier"
})

notifiers.Rooms:AddToggle("DangerousRoomNotifier", {
    Text = "Dangerous Room Notifier"
})

workspace.ChildAdded:Connect(function(child)
    if not getgenv().pressurehub_loaded then return end

    local roomNumber = repStorage.Events.CurrentRoomNumber:InvokeServer()

    if roomNumber == 100 then return end

    if toggles.NodeMonsterNotifier.Value then
        for _, monster in ipairs(nodeMonsters) do
            if child.Name == monster then
                getgenv().Alert(string.gsub(monster, "Ridge", "") .. " spawned. Hide!")
            end
        end
    end

    if toggles.PandemoniumNotifier.Value and child.Name == "Pandemonium" then
        getgenv().Alert("Pandemonium spawned. Good luck!")
    end
end)

workspace:WaitForChild("Monsters").ChildAdded:Connect(function(monster)
    if not getgenv().pressurehub_loaded then return end

    if toggles.WallDwellerNotifier.Value and monster.Name == "WallDweller" then
        getgenv().Alert("A Wall Dweller has spawned somewhere in the walls. Find it!")
    end
end)

workspace:WaitForChild("Rooms").ChildAdded:Connect(function(room)
    if not getgenv().pressurehub_loaded then return end

    if room:FindFirstChild("DamageParts") then
        getgenv().Alert("The next room is dangerous. Be careful!")
    end

    if toggles.TurretNotifier.Value and string.match(room.Name, "Turret") then
        getgenv().Alert("Turrets will spawn in the next room. Be careful!")
    end

    local interactables = room:WaitForChild("Interactables")

    if toggles.EyefestationNotifier.Value then
        if interactables:WaitForChild("EyefestationSpawn", 5) then
            getgenv().Alert("Eyefestation may spawn in the next room. Careful!")
        end

        interactables.DescendantAdded:Connect(function(child)
            if child.Name == "Eyefestation" then
                getgenv().Alert("Eyefestation has spawned. Don't look at it!")

                if toggles.AntiEyefestation.Value then
                    child:WaitForChild("Active", 5).Value = false
                end
            end
        end)
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

tracers.Items:AddToggle("DocumentsTracers", {
    Text = "Documents"
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

tracers.Entities:AddToggle("PandemoniumTracer", {
    Text = "Pandemonium"
})

tracers.Entities:AddToggle("WallDwellerTracer", {
    Text = "Wall Dwellers"
})

tracers.Entities:AddToggle("EyefestationTracer", {
    Text = "Eyefestation"
})

tracers.Entities:AddToggle("TurretTracer", {
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
    Default = "RightShift",
    Callback = function(keybind) library.ToggleKeybind = keybind end
})

settings.Config:AddButton("Unload", library.Unload)

settings.Credits:AddLabel("xBackpack - Creator & Scripter")

library.ToggleKeybind = options.MenuKeybind

library:OnUnload(function()
    lighting.Ambient = Color3.fromRGB(40, 53, 65)
    getgenv().pressurehub_loaded = nil
    getgenv().Alert("Unloaded!")
    task.wait(1)
end)
