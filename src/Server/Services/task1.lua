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
local task1 = Knit.CreateService {
    Name = "task1",
    Client = {},
}
--= Constants =--

--= Variables =--

--= Job API =--

function task1:KnitStart()
    local part = Instance.new("Part")
    part.Anchored = true
    part.BrickColor = BrickColor.new("Really blue")
    part.Parent = workspace
    print("ta mere la pute")
end

function task1:KnitInit()
    warn('• task1 Initiated •')
end

--= Methods =--

return task1
