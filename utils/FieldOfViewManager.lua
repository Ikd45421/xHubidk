local workspace = game:GetService("Workspace")
local camera = workspace.Camera

local toggles = getgenv().Linoria.Toggles

camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
    if not getgenv().PressureHubLoaded then return end

    local fov = toggles.Fullbright.Value

    if fov == 90 then return end
    if camera.FieldOfView == fov then return end

    camera.FieldOfView = fov
end)
