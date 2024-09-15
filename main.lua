-- loadstring(game:HttpGet("https://raw.githubusercontent.com/xBackpack/PressureHub/main/main.lua"))()

local validPlaceIds = {12552538292, }

local linoriaLib = "https://raw.githubusercontent.com/mstudio45/LinoriaLib/main/"
local addons = linoriaLib .. "addons/"

local library = loadstring(game:HttpGet(linoriaLib .. 'Library.lua'))()
local themeManager = loadstring(game:HttpGet(addons .. 'ThemeManager.lua'))()
local saveManager = loadstring(game:HttpGet(addons .. 'SaveManager.lua'))()

local placesRepo = "https://raw.githubusercontent.com/xBackpack/PressureHub/main/places/"

for _, id in pairs(validPlaceIds) do
  if game.PlaceId == id then
    loadstring(game:HttpGet(placesRepo .. game.PlaceId .. ".lua"))()
    break
  end
end
