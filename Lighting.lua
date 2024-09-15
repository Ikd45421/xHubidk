local lighting = game:GetService("Lighting")

local module = {}

function module:SetFullbright(enabled)
  if enabled then
    lighting.Ambient = Color3.fromRGB(255, 255, 255)
  else
    lighting.Ambient = Color3.fromRGB(40, 53, 65)
  end
end

return module
