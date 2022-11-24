local PlayerUtils = {}

local Players = game:GetService("Players")

function PlayerUtils:WaitCharacter(player)
    repeat task.wait() until player.Character ~= nil
    return player.Character
end

function PlayerUtils:PlayerExist(userid)
    for _,v in pairs (Players:GetPlayers()) do
        if v.UserId == userid then
            return v
        end
    end
    return nil
end

return PlayerUtils