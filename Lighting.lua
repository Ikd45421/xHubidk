local lighting = game:GetService("Lighting")

function SetFullbright(value)
  if value then
    lighting.Brightness = 25
    lighting.Ambient = Color3.fromRGB(255, 255, 255)
  else
    lighting.Brightness = 3
    lighting.Ambient = Color3.fromRGB(40, 53, 65)
  end
end
