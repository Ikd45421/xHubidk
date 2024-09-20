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
local runService = game:GetService("RunService")
local proximityPromptService = game:GetService("ProximityPromptService")

local rooms = workspace:WaitForChild("Rooms")
local monsters = workspace:WaitForChild("Monsters")

local themes = getgenv().ThemeManager
local saves = getgenv().SaveManager
local options = getgenv().Linoria.Options
local toggles = getgenv().Linoria.Toggles

local player = players.LocalPlayer
local playerGui = player.PlayerGui
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
getgenv().Utils = {
    GetCurrentRoomNumber = function()
        return repStorage.Events.CurrentRoomNumber:InvokeServer()
    end,

    GetNextRoom = function()
        return repStorage.Events.CheckNextRoom:InvokeServer()
    end
}

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
    Sound = tabs.Main:AddLeftGroupbox("Sound"),
    Interaction = tabs.Main:AddRightGroupbox("Interaction"),
    Exploits = tabs.Main:AddRightGroupbox("Exploits")
}

main.Movement:AddSlider("SpeedBoost", {
    Text = "Speed Boost",
    Default = 0,
    Min = 0,
    Max = 45,
    Rounding = 0,
    Callback = function(value) humanoid.WalkSpeed = 16 + value end
})

main.Interaction:AddToggle("InstantInteract", { Text = "Instant Interact" })

main.AutoInteract:AddToggle("AutoInteract", {
    Text = "Auto Interact",
    Risky = true
}):AddKeyPicker("AutoInteractKey", {
    Text = "Auto Interact",
    Default = "R",
    Mode = "Hold",
    SyncToggleState = library.IsMobile
})

main.Sound:AddToggle("NoAmbience", {
    Text = "Mute Ambience",
    Callback = function(value)
        if value then
            local ambience = workspace:WaitForChild("Ambience"):WaitForChild("FacilityAmbience")

            ambience.Volume = 0
        end
    end
})

main.Sound:AddToggle("NoFootsteps", { Text = "Mute Footsteps" })

main.Sound:AddToggle("NoAnticipationMusic", {
    Text = "Mute Room 1 Music",
    Callback = function(value)
        if value then
            local music = workspace:WaitForChild("AnticipationIntro")
            local loop = music:WaitForChild("AnticipationLoop")
            local fadeout = loop:WaitForChild("AnticipationFadeout")

            music.Volume = 0
            loop.Volume = 0
            fadeout.Volume = 0
        end
    end
})

main.Exploits:AddButton({
    Text = "Play Again",
    DoubleClick = true,
    Func = function()
        repStorage.Events.PlayAgain:FireServer(0)
        library:Notify("Teleporting in 5")
        for i = 1, 5 do
            task.wait(1)
            library:Notify(5 - i)
        end
    end
})

library:GiveSignal(proximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if not toggles.InstantInteract.Value then return end

    fireproximityprompt(prompt)
end))

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

visual.Camera:AddToggle("ThirdPerson", {
    Text = "Third Person",
    Callback = function(value)
        if value then

        else

        end
    end,
    Risky = true
}):AddKeyPicker("ThirdPersonKey", {
    Text = "Third Person",
    Default = "V",
    Mode = "Toggle",
    SyncToggleState = library.IsMobile
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

visual.Lighting:AddToggle("NoCameraEffects", {
    Text = "No Camera Effects",
    Callback = function(value)
        print("My bad will do this later")
    end,
    Risky = true
})

------------------------------------------------

local entity = {
    Exploits = tabs.Entity:AddLeftGroupbox("Exploits")
}

entity.Exploits:AddToggle("AntiEyefestation", { Text = "Anti Eyefestation", Risky = true })

entity.Exploits:AddToggle("AntiImaginaryFriend", { Text = "Anti Imaginary Friend" })

------------------------------------------------

local notifiers = {
    Entity = tabs.Notifiers:AddLeftGroupbox("Entity"),
    Rooms = tabs.Notifiers:AddRightGroupbox("Rooms")
    -- Settings = tabs.Notifiers:AddLeftGroupbox("Settings")
}

notifiers.Entity:AddToggle("NodeMonsterNotifier", { Text = "Node Monster Notifier" })

notifiers.Entity:AddToggle("PandemoniumNotifier", { Text = "Pandemonium Notifier" })

notifiers.Entity:AddToggle("WallDwellerNotifier", { Text = "Wall Dweller Notifier" })

notifiers.Entity:AddToggle("EyefestationNotifier", { Text = "Eyefestation Notifier", Risky = true })

notifiers.Rooms:AddToggle("TurretNotifier", { Text = "Turret Notifier" })

notifiers.Rooms:AddDropdown("SpecialRoomNotifier", {
    Text = "Special Room Notifier",
    AllowNull = true,
    Multi = true,
    Values = {
        "Dangerous Rooms",
        "Heavy Containment",
        "Searchlights",
        "Trenches",
        "Greenhouse"
    }
})

library:GiveSignal(workspace.ChildAdded:Connect(function(child)
    local roomNumber = getgenv().Utils.GetCurrentRoomNumber()

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
end))

library:GiveSignal(monsters.ChildAdded:Connect(function(monster)
    if toggles.WallDwellerNotifier.Value and monster.Name == "WallDweller" then
        getgenv().Alert("A Wall Dweller has spawned somewhere in the walls. Find it!")
    end
end))

library:GiveSignal(playerGui.ChildAdded:Connect(function(child)
    local friend = child:FindFirstDescendant("Friend")

    if friend then
        friend.Transparency = 1
    end
end))

library:GiveSignal(rooms.ChildAdded:Connect(function(room)
    if toggles.TurretNotifier.Value and string.match(room.Name, "Turret") then
        getgenv().Alert("Turrets will spawn in the next room.")
    end

    local values = options.SpecialRoomNotifier.Value

    if values then
        if values[1] and room:WaitForChild("DamageParts") and room.DamageParts:WaitForChild("Pit") then
            getgenv().Alert("The next room is dangerous. Be careful as you enter!")
        elseif values[2] and room.Name == "HCCheckpointStart" then
            getgenv().Alert("You are about to enter heavy containment!")
        elseif values[3] and string.match(room.Name, "SearchlightsStart") then
            getgenv().Alert("You are about to enter the searchlights encounter. Good luck!")
        elseif values[4] and string.match(room.Name, "Trench") then
            getgenv().Alert("You are about to enter the trenches")
        elseif values[5] and string.match(room.Name, "Grass") then
            getgenv().Alert("You are about to enter the greenhouse")
        end
    end

    local interactables = room:WaitForChild("Interactables")

    interactables.DescendantAdded:Connect(function(descendant)
        if descendant.Name == "Active" and descendant:IsA("BoolValue") then
            descendant.Changed:Once(function()
                descendant.Value = false
            end)
        end
    end)
end))

------------------------------------------------

local tracers = {
    Items = tabs.Tracers:AddRightGroupbox("Items"),
    Entities = tabs.Tracers:AddLeftGroupbox("Entities"),
    Other = tabs.Tracers:AddLeftGroupbox("Other")
}

tracers.Items:AddToggle("ItemsTracer", { Text = "Items", Risky = true })

tracers.Items:AddToggle("DocumentsTracers", { Text = "Documents", Risky = true })

tracers.Items:AddToggle("KeycardsTracer", { Text = "Keycards", Risky = true })

tracers.Items:AddToggle("MoneyTracer", { Text = "Money", Risky = true })

tracers.Entities:AddToggle("PlayersTracer", { Text = "Players", Risky = true })

tracers.Entities:AddToggle("NodeMonstersTracer", { Text = "Node Monsters", Risky = true })

tracers.Entities:AddToggle("PandemoniumTracer", { Text = "Pandemonium", Risky = true })

tracers.Entities:AddToggle("WallDwellerTracer", { Text = "Wall Dwellers", Risky = true })

tracers.Entities:AddToggle("EyefestationTracer", { Text = "Eyefestation", Risky = true })

tracers.Entities:AddToggle("SearchlightsTracer", { Text = "Searchlights", Risky = true })

tracers.Other:AddToggle("GeneratorsTracer", { Text = "Generators", Risky = true })

------------------------------------------------

library:GiveSignal(runService.RenderStepped:Connect(function()
    if toggles.NoAmbience.Value then
        local part = workspace:FindFirstChild("AmbiencePart")

        if part then
            local child = part:FindFirstChildWhichIsA("Sound")

            if child then
                child.Volume = 0
            end
        end
    end

    if toggles.NoFootsteps.Value then
        for _, child in next, character.LowerTorso:GetChildren() do
            if child:IsA("Sound") then
                child.Volume = 0
            end
        end
    end

    if toggles.AntiImaginaryFriend.Value then
        local part = workspace:FindFirstChild("FriendPart")

        if part then
            local child = part:FindFirstChildWhichIsA("Sound")

            if child then
                child.Volume = 0
            end
        end
    end

    local speedBoost = options.SpeedBoost.Value

    if speedBoost ~= 0 then
        humanoid.WalkSpeed = 16 + speedBoost
    end

    local fov = options.FieldOfView.Value

    if fov ~= 70 and character.Parent.Name == "Characters" then
        camera.FieldOfView = fov
    end
end))

------------------------------------------------

local settings = {
    Menu = tabs.Settings:AddLeftGroupbox("Menu"),
    Credits = tabs.Settings:AddRightGroupbox("Credits")
}

settings.Menu:AddToggle("KeybindMenu", {
    Text = "Open Keybind Menu",
    Callback = function(value) library.KeybindFrame.Visible = value end
})

settings.Menu:AddToggle("CustomCursor", {
    Text = "Show Custom Cursor",
    Default = true,
    Callback = function(value) library.ShowCustomCursor = value end
})

settings.Menu:AddDivider()

settings.Menu:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {
    Text = "Menu Keybind",
    NoUI = true,
    Default = "RightShift",
    Callback = function(keybind) library.ToggleKeybind = keybind end
})

settings.Menu:AddButton("Unload", library.Unload)

settings.Credits:AddLabel("xBackpack - Creator & Scripter")

library.ToggleKeybind = options.MenuKeybind

library:OnUnload(function()
    getgenv().Alert("Unloading!")
    lighting.Ambient = Color3.fromRGB(40, 53, 65)
    getgenv().pressurehub_loaded = nil
    getgenv().Utils = nil
    task.wait(1)
end)

themes:SetLibrary(library)
saves:SetLibrary(library)

saves:IgnoreThemeSettings()

saves:SetIgnoreIndexes({ "MenuKeybind" })

themes:SetFolder("PressureHub")
saves:SetFolder("PressureHub/Pressure")

themes:ApplyToTab(tabs.Settings)
saves:BuildConfigSection(tabs.Settings)

saves:LoadAutoloadConfig()
