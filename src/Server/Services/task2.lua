--[[
    Author: yepun01
    Creation Date: 09/11/2023

    Description:
        No description provided.

    Documentation:
        No documentation provided.
--]]

--= Roblox Services =--
local ReplicatedStorage = game:GetService('ReplicatedStorage')

--= Modules & Config =--

--= Framework =--
local Knit = require(ReplicatedStorage.Packages.Knit)
local task2 = Knit.CreateService {
    Name = "task2",
    Client = {},
}
--= Constants =--

--= Variables =--

--= Job API =--

function task2:KnitStart()
    local TweenService = game:GetService("TweenService")
    local part = Instance.new("Part")
    part.Position = Vector3.new(0, 10, 0)
    part.Color = Color3.new(1, 0, 0)
    part.Anchored = true
    part.Parent = game.Workspace

    local goal = {}
    goal.Position = Vector3.new(10, 10, 0)
    goal.Color = Color3.new(0, 1, 0)

    local tweenInfo = TweenInfo.new(5)

    local tween = TweenService:Create(part, tweenInfo, goal)
    tween:Play()
end

function task2:KnitInit()
    warn('• task2 Initiated •')
end

--= Methods =--

return task2