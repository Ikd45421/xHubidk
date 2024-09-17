-- loadstring(game:HttpGet("https://raw.githubusercontent.com/xBackpack/PressureHub/main/main.lua"))()

local validPlaceIds = { 12552538292, }
local foundGame = false

local linoriaLib = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
local addons = linoriaLib .. "addons/"

loadstring(game:HttpGet(linoriaLib .. 'Library.lua'))()
loadstring(game:HttpGet(addons .. 'ThemeManager.lua'))()
loadstring(game:HttpGet(addons .. 'SaveManager.lua'))()

local library = getgenv().Library
local toggles = getgenv().Linoria.Toggles
local workspace = game:GetService("Workspace")

local alertSound = Instance.new("Sound")
alertSound.SoundId = "rbxassetid://4590662766"
alertSound.Volume = 2
alertSound.PlayOnRemove = true

getgenv().Alert = function(message, duration)
    library:Notify(message, duration)

    if toggles.NotifySound.Value then
        local sound = alertSound:Clone()

        sound.Parent = workspace
        sound:Destroy()
    end
end

local placesRepo = "https://raw.githubusercontent.com/xBackpack/PressureHub/main/places/"

for _, id in ipairs(validPlaceIds) do
    if game.PlaceId == id then
        loadstring(game:HttpGet(placesRepo .. game.PlaceId .. ".lua"))()
        foundGame = true
        break
    end
end

if not foundGame then
    getgenv().Alert("The place you are currently in is not valid. Please look at our github for a list of valid games!")
    task.wait(5)
    library:Unload()
end
