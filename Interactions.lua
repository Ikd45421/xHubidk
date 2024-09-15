local pps = game:GetService("ProximityPromptService")

local module = {
  enabled = false
}

function module:SetInstantInteract(value)
  module.enabled = value
end

pps.PromptButtonHoldBegan:Connect(function(prompt, player)
    if not mndule.enabled then return end

    prompt.HoldDuration = 0
  end
)
