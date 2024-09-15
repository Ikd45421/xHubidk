local players = game:GetService("Players")
local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character.Humanoid

player.Crouching.Changed:Connect(function(newValue)
        if getgenv().speedBoost.Value == 0 then return end

        humanoid.WalkSpeed = 16 + getgenv().speedBoost.Value
    end
)
