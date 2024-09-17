local proximityPromptService = game:GetService("ProximityPromptService")

local toggles = getgenv().Linoria.Toggles

proximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
    if not getgenv().PressureHubLoaded then return end

    if not toggles.InstantInteract.Value then return end

    fireproximityprompt(prompt)
end)
