local workspace = game:GetService("Workspace")
local monsters = workspace:WaitForChild("Monsters")
local rooms = workspace:WaitForChild("Rooms")

local nodeMonsters = {
    "Angler",
    "Froger",
    "Pinkie",
    "Chainsmoker",
    "Blitz"
}

local library = getgenv().Library
local toggles = getgenv().Linoria.Toggles

workspace.ChildAdded:Connect(function(child)
    if not getgenv().PressureHubLoaded then return end

    if toggles.NodeMonsterNotifier.Value then
        for _, monster in ipairs(nodeMonsters) do
            if child.Name == monster then
                library:Notify(monster .. " spawned. Hide!", 10)
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
        library:Notify("Wall Dweller spawned. Remember to look behind you!", 10)
    end
end)

rooms.ChildAdded:Connect(function(child)
    if not getgenv().PressureHubLoaded then return end

    local interactables = child:FindFirstChild("Interactables")

    if not interactables then return end

    if toggles.EyefestationNotifier.Value and interactables:FindFirstChild("EyefestationSpawn") then
        library:Notify("Eyefestation spawned. Don't look at it!", 10)
    end

    if toggles.TurretNotifier.Value and interactables:FindFirstChild("TurretSpawn") then
        library:Notify("Turret spawned. Be careful!", 10)
    end
end)
