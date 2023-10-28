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

function Randoms:RandomFolder(Folder)
    local array = Folder:GetChildren()
    local random = R:NextNumber(1, #array)

    return array[random]
end

function Randoms:RandomFolderDiff(Folder, OldInstance)
    local array = Folder:GetChildren()
    local num = Randoms:RandomNumber(1, #array)

    if array[num] == OldInstance then
        return Randoms:RandomFolderDiff(Folder, OldInstance)
    end
    return array[num]
end

function Randoms:RandomPosInPart(Part : Part)
    local x = Part.Size.X/2
    local y = Part.Size.Y/2
    local z = Part.Size.Z/2
    return Vector3.new(Part.Position.X + R:NextNumber(-x, x), Part.Position.Y + R:NextNumber(-y, y), Part.Position.Z + R:NextNumber(-z, z))
end

function Randoms:getRandomElement(array)
    local index = math.random(1, #array)

    return array[index]
end

function Randoms:RandomNumber(min, max)
    return R:NextInteger(min, max)
end

function Randoms:RandomNumberDiff(min, max, oldnum)
    local num = R:NextInteger(min, max)

    if num == oldnum then
        return Randoms:RandomNumberDiff(min, max, oldnum)
    end
    return num
end


function Randoms:RandomDecimals(min, max)
    return R:NextNumber(min, max)
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