--[[
    GamePressets.lua
    Rask/AfraiEda
    Created on 07/05/2022 @ 16:53:28

    Description:
        No description provided.

    Documentation:
        No documentation provided.
--]]

--= Root =--
local GamePressets = { }
local SettingsPressets = require(script.Parent.SettingsPresets)
--= Group Id =--


GamePressets.Datastore = {
    ["Cash"] = 0;
    ["TimeShard"] = 0;
    ["Level"] = 0;
    ["Stat"] = {["Strength"] = {["Value"] = 0, ["Multiplicator"] = 1},
                ["Agility"] =  {["Value"] = 0, ["Multiplicator"] = 1},
                ["Endurance"] = {["Value"] = 0, ["Multiplicator"] = 1},
                ["Control"] =  {["Value"] = 0, ["Multiplicator"] = 1}};
    ["Pets"] = {};
    ["JoinDate"] = nil,
    ["Ban"] = false,
    ["BanReason"] = "",
    ["BanDuration"] = 0,
    ["BanPerma"] = false,
    ["BanDate"] = 0;
    ["Settings"] = SettingsPressets:ConvertData()
};
GamePressets.State = {
    ["Location"] = "";
    ["NoClip"] = false;
    ["LastTrained"] = tick();
}
GamePressets.Datastorekey = "CTSV26"
GamePressets.Version = "Alpha 01"
GamePressets.GroupId = 14527925
GamePressets.DevModeRequirement = 230
GamePressets.BanMessage = "You have been %s banned !<>Reason: %s<>Time left until unban: %s"

return GamePressets