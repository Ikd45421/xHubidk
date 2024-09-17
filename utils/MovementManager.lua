local players = game:GetService("Players")
local player = players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character.Humanoid

local options = getgenv().Linoria.Options

humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
    if not getgenv().PressureHubLoaded then return end

    local speedBoost = options.SpeedBoost.Value

    if speedBoost == 0 or humanoid.WalkSpeed == 0 then return end
    if humanoid.WalkSpeed == 16 + speedBoost then return end

    humanoid.WalkSpeed = 16 + speedBoost
end)
