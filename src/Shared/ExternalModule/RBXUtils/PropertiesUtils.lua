--[[
    Author: Rask/AfraiEda
    Creation Date: 16/08/2023
--]]

--= Root =--
local PropertiesUtils = { }

function PropertiesUtils:getProperties(instance)
    if not instance then return {} end

    local result = {}
    local className = instance.ClassName

    local propertiesToGet = {
        ["Lighting"] = {
            "Ambient", "Brightness", "ClockTime", "ColorShift_Bottom",
            "ColorShift_Top", "EnvironmentDiffuseScale", "EnvironmentSpecularScale",
            "ExposureCompensation", "FogColor", "FogEnd", "FogStart",
            "GeographicLatitude", "GlobalShadows", "OutdoorAmbient",
            "TimeOfDay"
        },
        ["Atmosphere"] = {
            "Density", "Color", "Decay", "Glow", "Haze", "Horizon",
            "Offset", "Power"
        },
        ["BlurEffect"] = {
            "Size"
        },
        ["ColorCorrection"] = {
            "Contrast",
            "Saturation",
            "TintColor",
            "Enabled"
        }
    }

    local props = propertiesToGet[className]
    if props then
        for _, propName in ipairs(props) do
            local success, propValue = pcall(function()
                return instance[propName]
            end)

            if success then
                result[propName] = propValue
            else
                result[propName] = "Error accessing property"
            end
        end
    end

    return result
end

return PropertiesUtils