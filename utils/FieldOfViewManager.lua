local workspace = game:GetService("Workspace")
local camera = workspace.Camera

local options = getgenv().Linoria.Options

camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
    if not getgenv().PressureHubLoaded then return end

    local fov = options.Fullbright.Value

    if fov == 90 then return end
    if camera.FieldOfView == fov then return end

    camera.FieldOfView = fov
end)
