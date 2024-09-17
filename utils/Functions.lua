local library = getgenv().Library
local toggles = getgenv().Linoria.Toggles

local workspace = game:GetService("Workspace")
local alertSound = Instance.new("Sound")
do
    alertSound.SoundId = "rbxassetid://4590662766"
    alertSound.Volume = 2
    alertSound.PlayOnRemove = true
end

function Alert(message, duration)
    library:Notify(message, duration)

    if toggles.NotifySound.Value then
        local sound = alertSound:Clone()

        sound.Parent = workspace
        sound:Destroy()
    end
end
