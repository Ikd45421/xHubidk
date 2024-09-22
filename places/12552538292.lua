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

local function createOutline(part, color)
    local highlight = Instance.new("Highlight")
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Enabled = true
    highlight.FillTransparency = 1
    highlight.OutlineColor = color
    highlight.OutlineTransparency = 0
    highlight.Parent = part
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

main.Movement:AddToggle("Noclip", {
    Text = "Noclip",
    Risky = true
}):AddKeyPicker("NoclipKey", {
    Text = "Noclip",
    Default = "N",
    Mode = "Toggle"
})

main.Movement:AddToggle("Fly", {
    Text = "Fly",
    Risky = true
}):AddKeyPicker("FlyKey", {
    Text = "Fly",
    Default = "F",
    Mode = "Toggle"
})

main.Interaction:AddToggle("InstantInteract", { Text = "Instant Interact" })

main.Interaction:AddToggle("AutoInteract", {
    Text = "Auto Interact",
    Risky = true
}):AddKeyPicker("AutoInteractKey", {
    Text = "Auto Interact",
    Default = "R",
    Mode = "Hold"
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
        for i = 1, 4 do
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
    Risky = true
}):AddKeyPicker("ThirdPersonKey", {
    Text = "Third Person",
    Default = "V",
    Mode = "Toggle"
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
    Risky = true
})

------------------------------------------------

local entity = {
    Exploits = tabs.Entity:AddLeftGroupbox("Exploits")
}

entity.Exploits:AddToggle("AntiEyefestation", { Text = "Anti Eyefestation", Risky = true })

entity.Exploits:AddToggle("AntiImaginaryFriend", { Text = "Anti Imaginary Friend" })

entity.Exploits:AddToggle("AntiSearchlights", { Text = "Anti Searchlights", Risky = true })

entity.Exploits:AddToggle("AntiSquiddles", { Text = "Anti Squiddles", Risky = true })

entity.Exploits:AddToggle("AntiSteam", { Text = "Anti Steam", Risky = true })

entity.Exploits:AddToggle("AntiTurret", { Text = "Anti Turret", Risky = true })

------------------------------------------------

local notifiers = {
    Entity = tabs.Notifiers:AddLeftGroupbox("Entity"),
    Rooms = tabs.Notifiers:AddRightGroupbox("Rooms")
}

notifiers.Entity:AddToggle("NodeMonsterNotifier", { Text = "Node Monster Notifier" })

notifiers.Entity:AddToggle("PandemoniumNotifier", { Text = "Pandemonium Notifier" })

notifiers.Entity:AddToggle("WallDwellerNotifier", { Text = "Wall Dweller Notifier" })

notifiers.Entity:AddToggle("EyefestationNotifier", { Text = "Eyefestation Notifier", Risky = true })

notifiers.Rooms:AddToggle("TurretNotifier", { Text = "Turret Notifier" })

notifiers.Rooms:AddToggle("DangerousNotifier", { Text = "Dangerous Room Notifier" })

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
    if child.Name ~= "Pixel" then return end

    if not child:FindFirstChild("ViewportFrame") then return end

    child.ViewportFrame.ImaginaryFriend.Friend.Transparency = 1
end))

library:GiveSignal(rooms.ChildAdded:Connect(function(room)
    if toggles.TurretNotifier.Value and string.match(room.Name, "Turret") then
        getgenv().Alert("Turrets will spawn in the next room.")
    end

    if toggles.DangerousNotifier.Value and room:WaitForChild("DamageParts") and room.DamageParts:WaitForChild("Pit") then
        getgenv().Alert("The next room is dangerous. Careful as you enter!")
    end

    if toggles.DoorsTracer.Value then
        local entrances = room:WaitForChild("Entrances")
        local door = entrances:WaitForChild("NormalDoor"):WaitForChild("Door"):WaitForChild("Door1")

        createOutline(door, options.DoorsTracerColor.Value)
    end
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

tracers.Other:AddToggle("DoorsTracer", {
    Text = "Doors"
}):AddColorPicker("DoorsTracerColor", {
    Default = Color3.fromRGB(255, 0, 0)
})

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

    if toggles.ThirdPerson.Value and options.ThirdPersonKey:GetState() then
        camera.CFrame = camera.CFrame * CFrame.new(1.5, -0.5, 6.5)
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
