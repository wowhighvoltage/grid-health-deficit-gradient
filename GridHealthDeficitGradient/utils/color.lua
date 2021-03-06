-- Defines functions to help with color transitions


local CS = CreateFrame("ColorSelect")
local module = {}


function module:RGB2HSV(color)
    -- Converts  a color from RGB to HSV
    CS:SetColorRGB(color.r, color.g, color.b)
    local h, s, v = CS:GetColorHSV()
    return {h=h, s=s, v=v, a=color.a}
end


function module:HSV2RGB(color)
    -- Converts  a color from HSV to RGB
    CS:SetColorHSV(color.h, color.s, color.v)
    local r, g, b = CS:GetColorRGB()
    return {r=r, g=g, b=b, a=color.a}
end

     
function module:CalculateHSVColorAtPosition(color1, color2, position)
    -- Calculate the color on a color gradient between color1 and color2
    -- at a given postion between color1 and color2. Position is between
    -- 0 and 1, with 0 being color1 and 1 being color2. Returns a HSV value
    -- color.
    local colorAtPos = {}

    local colorHSV1 = color1.r and self:RGB2HSV(color1) or color1
    local colorHSV2 = color2.r and self:RGB2HSV(color2) or color2

    local hue1 = colorHSV1.h % 360
    local hue2 = colorHSV2.h % 360

    local direction = hue1 < hue2 and 1 or -1
    local hueDiff = abs(hue1 - hue2)

    if hueDiff > 180 then
        hueDiff = 360 - hueDiff
        direction = -1 * direction
    end

    colorAtPos.h = (hue1 + direction * floor(hueDiff * position)) % 360

    for _, v in pairs({'s', 'v', 'a'}) do
        colorAtPos[v] = colorHSV1[v] - (colorHSV1[v] - colorHSV2[v]) * position
    end

    return colorAtPos
end

     
function module:CalculateRGBColorAtPosition(color1, color2, position)
    -- Same as CalculateHSVColorAtPosition but returns RBG values
    local hsvColorAtPosition = self:CalculateHSVColorAtPosition(color1, color2, position)
    return self:HSV2RGB(hsvColorAtPosition)
end


GridHealthDeficitGradient.utils.color = module
