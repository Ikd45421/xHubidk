local lighting = game:GetService("Lighting")

local Lighting = {}

function Lighting:SetFullbright(enabled)
  if enabled then
    lighting.Brightness = 25
    lighting.Ambient = Color3.fromRGB(255, 255, 255)
  else
    lighting.Brightness = 3
    lighting.Ambient = Color3.fromRGB(40, 53, 65)
  end
end

return Lighting
