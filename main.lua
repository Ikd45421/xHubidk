-- loadstring(game:HttpGet("https://raw.githubusercontent.com/xBackpack/PressureHub/main/main.lua"))()

local inGame = game.PlaceId == 12411473842

local places = "https://raw.githubusercontent.com/xBackpack/PressureHub/main/places/"

if inGame then loadstring(game:HttpGet(places .. game.PlaceId .. ".lua"))() end
