--[[
    Framework.lua
    RobxSoft
    Created on 07/04/2022 @ 18:09:46

    Description:
        No description provided.

    Documentation:
        No documentation provided.
--]]

--= Root =--
local Framework = {
    _systems = {}
}

--= Classes =--

--= Modules & Config =--
local initSystems = require(script.initSystems)
local runSystems = require(script.runSystems)

--= Roblox Services =--
local RunService = game:GetService("RunService")
local Players = game:GetService('Players')
local ContentProvider = game:GetService("ContentProvider")
--= Object References =--

--= Constants =--

--= Variables =--

--= Functions =--


function Framework.init(folders, callbacks)
    --Handling systems
    Framework._systems = initSystems(folders)
    --Handlin users
    local function playerAdded(player)
        if callbacks and callbacks.playerAddedCallback then
            local canAddPlayer = callbacks.playerAddedCallback(player)
            if not canAddPlayer then return end
        end

        runSystems(Framework._systems, 'PlayerAdded', player)
    end

    local function playerRemoving(player)
        if callbacks and callbacks.playerRemoedCallback then
            callbacks.playerRemoedCallback(player)
        end

        runSystems(Framework._systems, 'PlayerRemoving', player)
    end

    Players.PlayerAdded:Connect(playerAdded)
    Players.PlayerRemoving:Connect(playerRemoving)

    for _, player in pairs(Players:GetPlayers()) do
        playerAdded(player)
    end

    if RunService:IsClient() then
        --Preload()
    end

    runSystems(Framework._systems, 'run')
end

--= Return =--
return Framework