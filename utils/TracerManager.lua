local function createOutline(roomName, part, color)
    local highlight = Instance.new("Highlight")
    highlight.FillTransparency = 1
    highlight.OutlineColor = color
    highlight.Enabled = true
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = part
    highlight.Parent = part
end
