--[[
    Author: yepun01
    Creation Date: 10/11/2023

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
local task4 = Knit.CreateService {
    Name = "task4",
    Client = {},
}
--= Constants =--

--= Variables =--

--= Job API =--

function task4:KnitStart()
    -- local part = Instance.new("Part")
    -- part.Shape = Enum.PartType.Ball
    -- part.Position = Vector3.new(0, 10, 0)
    -- part.Color = Color3.new(1, 0, 0)
    -- part.Parent = game.Workspace

    -- local rotationSpeed = 5
    -- while true do
    --     part.CFrame = part.CFrame * CFrame.Angles(0, math.rad(rotationSpeed), 0)
    --     task.wait(0)
    -- end

end

function task4:KnitInit()
    warn('• task4 Initiated •')
end

--= Methods =--

return task4