local zoneChangeEvent = game.ReplicatedStorage.Events.ZoneChange

local oldFireServer
oldFireServer = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()

    if method == "FireServer" and self == zoneChangeEvent then
        local args = {...}
        local room = args[1]
        
        print("Room Entered! Room:", room.Name)
    end

    return oldFireServer(self, ...)
end)
