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
local task5 = Knit.CreateService {
    Name = "task5",
    Client = {},
}
--= Constants =--

--= Variables =--

--= Job API =--

function task5:KnitStart()

end

function task5:KnitInit()
    warn('• task5 Initiated •')
end

--= Methods =--

return task5