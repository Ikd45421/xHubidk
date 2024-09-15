local proximityPromptService = game:GetService("ProximityPromptService")

proximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
        if not getgenv().instantInteract.Value then return end

        prompt.HoldDuration = 0
    end
)
