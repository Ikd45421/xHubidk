local workspace = game:GetService("Workspace")

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
                library:Notify(monster .. " spawned. Hide!")
            end
        end
    end

    if toggles.PandemoniumNotifier.Value then
        if child.Name == "Pandemonium" then
            library:Notify("Pandemonium spawned. Good luck!")
        end
    end
end)
