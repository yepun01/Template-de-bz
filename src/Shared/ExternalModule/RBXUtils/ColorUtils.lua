local ColorUtils = {}

-- ExtraContent/LuaPackages/AppTempCommon
function ColorUtils.rgbFromHex(hexColor)
	assert(hexColor >= 0 and hexColor <= 0xffffff, "RgbFromHex: Out of range")

	local b = hexColor % 256
	hexColor = (hexColor - b) / 256
	local g = hexColor % 256
	hexColor = (hexColor - g) / 256
	local r = hexColor

	return r, g, b
end

function ColorUtils:makeDarker(color, percentage)
    local newR = color.r * (1 - percentage)
    local newG = color.g * (1 - percentage)
    local newB = color.b * (1 - percentage)
    return Color3.new(newR, newG, newB)
end

-- To make a color lighter
function ColorUtils:makeLighter(color, percentage)
    local newR = math.min(color.r * (1 + percentage), 1)
    local newG = math.min(color.g * (1 + percentage), 1)
    local newB = math.min(color.b * (1 + percentage), 1)
    return Color3.new(newR, newG, newB)
end

function ColorUtils:toInteger(color)
	return math.floor(color.r*255)*256^2+math.floor(color.g*255)*256+math.floor(color.b*255)
end

function ColorUtils:toHex(color)
	local int = ColorUtils:toInteger(color)

	local current = int
	local final = ""

	local hexChar = {
		"A", "B", "C", "D", "E", "F"
	}

	repeat local remainder = current % 16
		local char = tostring(remainder)

		if remainder >= 10 then
			char = hexChar[1 + remainder - 10]
		end

		current = math.floor(current/16)
		final = final..char
	until current <= 0

	return "#"..string.reverse(final)
end


function ColorUtils.color3FromHex(hexColor)
	return Color3.fromRGB(ColorUtils.rgbFromHex(hexColor))
end

function ColorUtils.RandomRGB()
	return Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
end

function ColorUtils.color3ToHex(color)
    return math.floor(color.R * 255) *256^2 + math.floor(color.G * 255) * 256 + math.floor(color.B * 255)
end

function ColorUtils.add(color0, color1)
    if type(color1) == "number" then
        color1 = Color3.new(color1, color1, color1)
    end

    return Color3.new(
        math.min(color0.R + color1.R, 1),
        math.min(color0.G + color1.G, 1),
        math.min(color0.B + color1.B, 1)
    )
end

function ColorUtils.multiply(color0, color1)
    if type(color1) == "number" then
        color1 = Color3.new(color1, color1, color1)
    end

    return Color3.new(
        math.min(color0.R * color1.R, 1),
        math.min(color0.G * color1.G, 1),
        math.min(color0.B * color1.B, 1)
    )
end

function ColorUtils.pow(color0, color1)
    if type(color1) == "number" then
        color1 = Color3.new(color1, color1, color1)
    end

    return Color3.new(
        math.min(color0.R ^ color1.R, 1),
        math.min(color0.G ^ color1.G, 1),
        math.min(color0.B ^ color1.B, 1)
    )
end

return ColorUtils