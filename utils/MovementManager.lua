local players = game:GetService("Players")
local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character.Humanoid

local options = getgenv().Linoria.Options

humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        local speedBoost = options[0].Value

        if speedBoost == 0 then return end
        if humanoid.WalkSpeed == 16 + speedBoost then return end

        humanoid.WalkSpeed = 16 + speedBoost
    end
)
