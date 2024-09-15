-- loadstring(game:HttpGet("https://raw.githubusercontent.com/xBackpack/PressureHub/main/main.lua"))()

local validPlaceIds = {12552538292, }
local foundGame = false

local linoriaLib = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
local addons = linoriaLib .. "addons/"

local library = loadstring(game:HttpGet(linoriaLib .. 'Library.lua'))()
local themeManager = loadstring(game:HttpGet(addons .. 'ThemeManager.lua'))()
local saveManager = loadstring(game:HttpGet(addons .. 'SaveManager.lua'))()

local placesRepo = "https://raw.githubusercontent.com/xBackpack/PressureHub/main/places/"

for _, id in ipairs(validPlaceIds) do
  if game.PlaceId == id then
    loadstring(game:HttpGet(placesRepo .. game.PlaceId .. ".lua"))()
    foundGame = true
    break
  end
end

if not foundGame then
  library:Notify("The place you are currently in is not valid. Please look at our github for a list of valid games!")
  library:Unload()
end
