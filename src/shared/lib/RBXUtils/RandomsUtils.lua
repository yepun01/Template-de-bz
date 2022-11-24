local Randoms = {}
local R = Random.new()

local TableUtils = require(script.Parent.TableUtils)

function Randoms:RandomsArrays(array)
    local random = R:NextNumber(1, #array)

    return array[random]
end

function Randoms:RandomsBigArrays(array)
    local arraylen = TableUtils:len(array)
    local random = R:NextNumber(1, arraylen)

    return TableUtils:valueatpos(array, random)
end

function Randoms:RandomsPercentage(Percentage)
    local totalWeight = 0

    for _, weight in pairs(Percentage) do
        totalWeight += weight
    end
    local choice = R:NextNumber(0, totalWeight)
    for item, weight in pairs(Percentage) do
        choice -= weight
        if choice <= 0 then
            return item
        end
    end
    return nil
end

return Randoms