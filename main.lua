-- loadstring(game:HttpGet("https://raw.githubusercontent.com/xBackpack/PressureHub/main/main.lua"))()

local inGame = game.PlaceId == 12411473842

local pressure = "https://raw.githubusercontent.com/xBackpack/PressureHub/main/places/12411473842.lua"

if inGame then
  loadstring(game:HttpGet(pressure))()
end
