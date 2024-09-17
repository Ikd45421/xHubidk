local workspace = game:GetService("Workspace")
local rooms = workspace:WaitForChild("Rooms")
local toggles = getgenv().Linoria.Toggles

local activeESPs = {}

local function createOutline(roomName, part)
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 1
    highlight.OutlineColor = Color3.fromRGB(255, 0, 0)
    highlight.Enabled = true
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = part
    highlight.Parent = part

    print("Made an outline!")

    table.insert(activeESPs[roomName], highlight)
end

rooms.ChildAdded:Connect(function(child)
    activeESPs[child.Name] = {}
end)

rooms.ChildRemoved:Connect(function(child)
    activeESPs[child.Name] = nil
end)
