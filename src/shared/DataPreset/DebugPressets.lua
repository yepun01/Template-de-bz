--[[
    DebugPressets.lua
    Rask/AfraiEda
    Created on 07/05/2022 @ 16:53:28

    Description:
        No description provided.

    Documentation:
        No documentation provided.
--]]

--= Root =--
local DebugPressets = { }
local GamePressets = require(script.Parent.GamePressets)

--= Group Id =--

DebugPressets.DebugList = {
["Version"] = {["Update"] = false, ["Value"] = GamePressets.Version} ,
["FPS"] = {["Update"] = true} ,
["Position"] = {["Update"] = true} ,
["Orientation"] = {["Update"] = true} ,
["Noclip"] = {["Update"] = true, ["Type"] = "Bool"} ,
}

return DebugPressets