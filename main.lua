-- loadstring(game:HttpGet("https://raw.githubusercontent.com/xBackpack/PressureHub/main/main.lua"))()

local pressureId = 12552538292

local repo = "https://raw.githubusercontent.com/xBackpack/PressureHub/main/places/"

if game.PlaceId == pressureId then
  loadstring(game:HttpGet(repo .. game.PlaceId .. ".lua"))()
end
