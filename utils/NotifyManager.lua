local workspace = game:GetService("Workspace")
local monsters = workspace:WaitForChild("Monsters")
local rooms = workspace:WaitForChild("Rooms")

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

local library = getgenv().Library
local toggles = getgenv().Linoria.Toggles

workspace.ChildAdded:Connect(function(child)
    if not getgenv().PressureHubLoaded then return end

    if toggles.NodeMonsterNotifier.Value then
        for _, monster in ipairs(nodeMonsters) do
            if child.Name == monster then
                local str = monster
                if (string.match(monster, "Ridge")) then
                    str = string.sub(monster, 6)
                end
                library:Notify(str .. " spawned. Hide!", 10)
            end
        end
    end

    if toggles.PandemoniumNotifier.Value and child.Name == "Pandemonium" then
        library:Notify("Pandemonium spawned. Good luck!", 10)
    end
end)

monsters.ChildAdded:Connect(function(child)
    if not getgenv().PressureHubLoaded then return end

    if toggles.WallDwellerNotifier.Value and child.Name == "WallDweller" then
        library:Notify("A Wall Dweller will spawn in the next  room!", 10)
    end
end)

rooms.ChildAdded:Connect(function(child)
    if not getgenv().PressureHubLoaded then return end

    if toggles.TurretNotifier.Value and string.match(child.Name, "Turret") then
        library:Notify("Turrets will spawn in the next room. Be Careful!", 10)
    end

    local interactables = child:WaitForChild("Interactables")

    interactables.ChildAdded:Connect(function(interactable)
        if toggles.EyefestationNotifier.Value and interactable.Name == "EyefestationSpawn" then
            library:Notify("Eyefestation spawned. Don't look at it!", 10)
        end
    end)
end)
