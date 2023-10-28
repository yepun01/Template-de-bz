--[[
    Author: Rask/AfraiEda
    Creation Date: 06/07/2023
--]]

--= Root =--
local RanksUtils = { }

local RanksConfig = require(game.ReplicatedStorage.Shared.Configuration.Ranks)
local GroupConfig = require(game.ReplicatedStorage.Shared.Configuration.Group)
local RunService = game:GetService("RunService")

function RanksUtils:GetMaxRanks()
    local MaxRank = 0
    local Name

    for _, Rank in pairs(RanksConfig._mainrank) do
        if Rank.Rank > MaxRank then
            MaxRank = Rank.Rank
            Name = _
        end
    end
    return Name
end

function RanksUtils:GetTextRanks(Player : Player)
    if not Player then return end
    local RanksRole = Player:GetRoleInGroup(GroupConfig._id)

    if RunService:IsStudio() then RanksRole = RanksUtils:GetMaxRanks() end
    if RanksConfig._mainrank[RanksRole] then
        return RanksConfig._mainrank[RanksRole].Tag
    end
    return ""
end

function RanksUtils:GetRankData(Player : Player)
    if not Player then return end
    local RanksRole = Player:GetRoleInGroup(GroupConfig._id)

    if RunService:IsStudio() then RanksRole = RanksUtils:GetMaxRanks() end
    if RanksConfig._mainrank[RanksRole] then
        return RanksConfig._mainrank[RanksRole]
    end
    return nil
end

function RanksUtils:GetColorRanks(Player : Player)
    if not Player then return end
    local RanksRole = Player:GetRoleInGroup(GroupConfig._id)

    if RunService:IsStudio() then RanksRole = RanksUtils:GetMaxRanks() end
    if RanksConfig._mainrank[RanksRole] then
        return RanksConfig._mainrank[RanksRole].Color
    end
    return Color3.fromRGB(255, 255, 255)
end

function RanksUtils:UserHasPerms(Player : Player)
    local RanksRole = Player:GetRoleInGroup(GroupConfig._id)

    if RunService:IsStudio() then RanksRole = RanksUtils:GetMaxRanks() end
    if RanksConfig._mainrank[RanksRole] then
        return true
    end
    return false
end

function RanksUtils:UserHasCommandsPerms(CommandsPerms : table, Perms : string)
    if table.find(CommandsPerms, Perms) then
        return true
    end
    return false
end

return RanksUtils