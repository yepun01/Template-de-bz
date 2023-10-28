--[[
    Author: Rask/AfraiEda
    Creation Date: 18/12/2022

    Description:
        No description provided.

    Documentation:
        No documentation provided.
--]]

--= Root =--
local StringsUtils = { }

--= Roblox Services =--


function StringsUtils:Match(String , String2)
    local Match = true

    for i = 1, #String do
        if i > #String2 then return Match end
        if String:sub(i, i) ~= String2:sub(i, i) then
            Match = false
            break
        end
    end
    return Match
end

return StringsUtils