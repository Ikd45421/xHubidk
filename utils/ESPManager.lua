local workspace = game:GetService("Workspace")
local rooms = workspace:WaitForChild("Rooms")
local toggles = getgenv().Linoria.Toggles

local activeESPs = {}

local function createOutline(key, part)
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.Enabled = true
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = part
    highlight.Parent = part

    table.insert(activeESPs[key], highlight)
end

local function processSpawnLocations(roomName, spawnLocations, word)
    for _, part in ipairs(spawnLocations:GetChildren()) do
        for _, child in ipairs(part:GetChildren()) do
            if string.match(child.Name, word) then
                createOutline(roomName, child)
            end
        end
    end
end

local function setESPs(room, word)
    activeESPs[room.Name] = activeESPs[room.Name] or {}
    for _, container in ipairs(room:GetChildren()) do
        local spawnLocations = container:FindFirstChild("SpawnLocations")
        if spawnLocations then
            processSpawnLocations(room.Name, spawnLocations, word)
        end
    end
end

for _, room in ipairs(rooms:GetChildren()) do
    if toggles[4].Value then
        setESPs(room, "Currency")
    end

    if toggles[5].Value then
        setESPs(room, "NormalKeyCard")
    end
end

rooms.ChildAdded:Connect(function(room)
    if toggles[4].Value then
        setESPs(room, "Currency")
    end

    if toggles[5].Value then
        setESPs(room, "NormalKeyCard")
    end
end)

rooms.ChildRemoved:Connect(function(room)
    local roomESPs = activeESPs[room.Name]
    if roomESPs then
        for _, esp in ipairs(roomESPs) do
            esp:Destroy()
        end
        activeESPs[room.Name] = nil
    end
end)
