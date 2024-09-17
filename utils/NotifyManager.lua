local workspace = game:GetService("Workspace")
local players = game:GetService("Players")
local monsters = workspace:WaitForChild("Monsters")
local rooms = workspace:WaitForChild("Rooms")
local player = players.LocalPlayer

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

local toggles = getgenv().Linoria.Toggles

workspace.ChildAdded:Connect(function(child)
    if not getgenv().PressureHubLoaded then return end

    -- if player:WaitForChild("PlayerData"):WaitForChild("").Value == 100 then return end

    if toggles.NodeMonsterNotifier.Value then
        for _, monster in ipairs(nodeMonsters) do
            if child.Name == monster then
                local str = monster
                if (string.match(monster, "Ridge")) then
                    str = string.sub(monster, 6)
                end
                Alert(str .. " spawned. Hide!", 10)
            end
        end
    end

    if toggles.PandemoniumNotifier.Value and child.Name == "Pandemonium" then
        Alert("Pandemonium spawned. Good luck!", 10)
    end
end)

monsters.ChildAdded:Connect(function(child)
    if not getgenv().PressureHubLoaded then return end

    if toggles.WallDwellerNotifier.Value and child.Name == "WallDweller" then
        Alert("A Wall Dweller has just spawned in your current room. Find it!", 10)
    end
end)

rooms.ChildAdded:Connect(function(child)
    if not getgenv().PressureHubLoaded then return end

    if toggles.TurretNotifier.Value and string.match(child.Name, "Turret") then
        Alert("Turrets will spawn in the next room. Be Careful!", 10)
    end

    local interactables = child:WaitForChild("Interactables")

    interactables.ChildAdded:Connect(function(interactable)
        if toggles.EyefestationNotifier.Value and interactable.Name == "EyefestationSpawn" then
            Alert("Eyefestation will spawn in the next room. Don't look at it!", 10)
        end
    end)
end)
