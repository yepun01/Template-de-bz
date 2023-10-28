--[[
    Author: Rask/AfraiEda
    Creation Date: 16/05/2023

    Description:
        No description provided.

    Documentation:
        No documentation provided.
--]]

--= Roblox Services =--
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--= Modules & Config =--
local Knit = require(ReplicatedStorage.Packages.Knit)
local Component = require(ReplicatedStorage.Packages.Component)

--= Framework =--
warn("---= Framework V-1.0 | Created by Rask#6669 =---")
warn("---= 🛠️ Mounting Up Services 🛠️ =---")
warn("~~")
Knit.AddServicesDeep(game.ServerScriptService.Server.Services)
Knit.Start():andThen(function()
    warn("~~")
	warn('---= ✅ Services Successfully Initialized ✅ =---')
    Component.Auto(game.ServerScriptService.Server.Components)
end):catch(function(error)
    warn("---= ❌ Framework encountered an error during initialization ❌ =---")
    warn("Error details: " .. tostring(error))
end)
