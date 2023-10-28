local PlayerUtils = {}

local Players = game:GetService("Players")
local PartUtils = require(script.Parent.PartUtils)

function PlayerUtils:WaitCharacter(player)
    repeat task.wait() until player.Character ~= nil
    repeat task.wait() until player.Character:FindFirstChild("Humanoid") ~= nil
    return player.Character
end

function PlayerUtils:GetPlayerByUserId(userid)
    for _,v in pairs (Players:GetPlayers()) do
        if v.UserId == userid then
            return v
        end
    end
    return nil
end

function PlayerUtils:PlayerDistance(player, player2)
    return (player.Character.HumanoidRootPart.Position - player2.Character.HumanoidRootPart.Position).Magnitude
end

function PlayerUtils:PlayerExist(userid)
    for _,v in pairs (Players:GetPlayers()) do
        if v.UserId == userid then
            return v
        end
    end
    return nil
end

function PlayerUtils:HidePlayer(Player : Player)
    if not PartUtils:Exist(Player.Character) then return end
    PartUtils:LocalTranspenracyModel(Player.Character, 1)
    for _,v in pairs(Player.Character:GetDescendants()) do
        if v:IsA("BillboardGui") then
            v.Enabled = false
        elseif v:IsA("ParticleEmitter") then
            v.Enabled = false
        end
    end
end

function PlayerUtils:HideBillboard(Player : Player)
    if not PartUtils:Exist(Player.Character) then return end
    for _,v in pairs(Player.Character:GetDescendants()) do
        if v:IsA("BillboardGui") then
            v.Enabled = false
        end
    end
end

function PlayerUtils:ShowBillboard(Player : Player)
    if not PartUtils:Exist(Player.Character) then return end
    for _,v in pairs(Player.Character:GetDescendants()) do
        if v:IsA("BillboardGui") then
            v.Enabled = true
        end
    end
end

function PlayerUtils:ShowPlayer(Player : Player)
    if not PartUtils:Exist(Player.Character) then return end
    PartUtils:LocalTranspenracyModel(Player.Character, 0)
    for _,v in pairs(Player.Character:GetDescendants()) do
        if v:IsA("BillboardGui") then
            v.Enabled = true
        elseif v:IsA("ParticleEmitter") then
            v.Enabled = true
        end
    end
end

function PlayerUtils:HideAllOtherPlayers(player)
    for _,v in pairs (Players:GetPlayers()) do
        if v == player then continue end
        if not PartUtils:Exist(v.Character) then continue end
        PartUtils:LocalTranspenracyModel(v.Character, 1)
        for _,v in pairs(v.Character:GetDescendants()) do
            if v:IsA("BillboardGui") then
                v.Enabled = false
            elseif v:IsA("ParticleEmitter") then
                v.Enabled = false
            end
        end
    end
end

function PlayerUtils:ShowAllOtherPlayers(player)
    for _,v in pairs (Players:GetPlayers()) do
        if v == player then continue end
        if not PartUtils:Exist(v.Character) then continue end
        PartUtils:LocalTranspenracyModel(v.Character, 0)
        for _,v in pairs(v.Character:GetDescendants()) do
            if v:IsA("BillboardGui") then
                v.Enabled = true
            elseif v:IsA("ParticleEmitter") then
                v.Enabled = true
            end
        end
    end
end

function PlayerUtils:HideAllPlayers()
    for _,v in pairs (Players:GetPlayers()) do
        if not PartUtils:Exist(v.Character) then continue end
        PartUtils:LocalTranspenracyModel(v.Character, 1)
    end
end

function PlayerUtils:ShowAllPlayers()
    for _,v in pairs (Players:GetPlayers()) do
        if not PartUtils:Exist(v.Character) then continue end
        PartUtils:LocalTranspenracyModel(v.Character, 0)
    end
end


return PlayerUtils