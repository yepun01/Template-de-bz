--[[
    Author: Rask/AfraiEda
    Creation Date: 12/06/2023
--]]

--= Root =--
local EnumUtils = { }

function EnumUtils:FindValue(Enumss : Enum, Value : number) : EnumItem
    for _, enumItem in ipairs(Enumss:GetEnumItems()) do
        if enumItem.Value == Value then
            return enumItem
        end
    end
    return nil
end

return EnumUtils