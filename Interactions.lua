local pps = game:GetService("ProximityPromptService")

local enabled = false

function SetInstantInteract(value)
  enabled = value
end

pps.PromptButtonHoldBegan:Connect(function(prompt, player)
    if not enabled then return end

    prompt.HoldDuration = 0
  end
)
