--[[
    Author: yepun01
    Creation Date: 09/11/2023

    Description:
        No description provided.

    Documentation:
        No documentation provided.
--]]

--= Roblox Services =--
local LocalizationService = game:GetService('LocalizationService')
local ReplicatedStorage = game:GetService('ReplicatedStorage')

--= Modules & Config =--

--= Framework =--
local Knit = require(ReplicatedStorage.Packages.Knit)
local task3 = Knit.CreateService {
    Name = "task3",
    Client = {},
}
--= Constants =--

--= Variables =--

--= Job API =--

local function upVisual(part)
    if part.Anchored then
        part.BrickColor = BrickColor.new("Bright red")
		part.Material = Enum.Material.DiamondPlate
    else
        part.BrickColor = BrickColor.new("Bright yellow")
		part.Material = Enum.Material.Wood
    end
end

local function onToggle(part)
    part.Anchored = not part.Anchored
    upVisual(part)
end


function task3:KnitStart()
    -- local part = Instance.new("Part")
    -- part.Position = Vector3.new(5, 10, 0)
    -- part.Size = Vector3.new(2, 2, 2)
    -- part.Anchored = true
    -- part.Parent = workspace

    -- local cd = Instance.new("ClickDetector", part)

    -- upVisual(part)
    -- cd.MouseClick:Connect(function()
    --     onToggle(part)
    -- end)
end

function task3:KnitInit()
    warn('• task3 Initiated •')
end

--= Methods =--

return task3