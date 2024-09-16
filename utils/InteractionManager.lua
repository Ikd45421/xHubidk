local proximityPromptService = game:GetService("ProximityPromptService")
local toggles = getgenv().Linoria.Toggles

proximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
        if not getgenv().PressureHubLoaded then return end
        
        if not toggles[0].Value then return end

        prompt.HoldDuration = 0
    end
)
