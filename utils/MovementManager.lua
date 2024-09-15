local players = game:GetService("Players")
local workspace = game:GetService("Workspace")
local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character.Humanoid
local camera = workspace.Camera

local options = getgenv().Linoria.Options

humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        local speedBoost = options[0].Value

        if speedBoost == 0 then return end
        if humanoid.WalkSpeed == 16 + speedBoost then return end

        humanoid.WalkSpeed = 16 + speedBoost
    end
)

camera:GetPropertyChangedSignal("FieldOfView"):Connect(function()
        local fov = options[1].Value

        if not fov then return end
        if camera.FieldOfView == fov then return end

        camera.FieldOfView = fov
    end
)
