--[[
    Author: Rask/AfraiEda
    Creation Date: 28/10/2023

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
local Enum = require(ReplicatedStorage.Packages.enum)
local test = Knit.CreateService {
    Name = "test",
    Client = {},
}
--= Constants =--

--= Variables =--

--= Job API =--

function test:KnitStart()
    print('la ca marche ou quoiiiii')
end

function test:KnitInit()
    warn('• test Initiated •')
end

--= Methods =--

return test