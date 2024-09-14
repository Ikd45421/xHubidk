local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")

local camera = workspace.Camera

function setWalkSpeed(humanoid, newSpeed)
    humanoid.WalkSpeed = newSpeed
end

function setFullbright(enabled)
    if enabled then
        lighting.Brightness = 25
        lighting.Ambient = Color3.fromRGB(255, 255, 255)
    else
        lighting.Brightness = 2
        lighting.Ambient = Color3.fromRGB(70, 70, 70)
    end
end

function setFOV(newFOV)
    camera.FieldOfView = newFOV
end

function reset(lib)
    setWalkSpeed(16)
    setFullbright(false)
    setFieldOfView(70)
    lib:Unload()
end
