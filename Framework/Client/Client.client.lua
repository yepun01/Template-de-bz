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
local Players = game:GetService("Players")

--= Modules & Config =--
local Knit = require(ReplicatedStorage.Packages.Knit)
local Component = require(ReplicatedStorage.Packages.Component)

--= Framework =--
warn("---= 🛠️ Mounting Up Controllers 🛠️ =---")
warn("~~")
Knit.AddControllersDeep(game.ReplicatedStorage.Client.Controllers)
Knit.Start():andThen(function()
    warn("~~")
	warn('---= ✅ Controllers Successfully Initialized ✅ =---')
    warn("---= Welcome ".. Players.LocalPlayer.Name .."! =---")
    Component.Auto(game.ReplicatedStorage.Client.Components)
end):catch(function(error)
    warn("---= ❌ Framework encountered an error during initialization ❌ =---")
    warn("Error details: " .. tostring(error))
end)
