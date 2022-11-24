--[[
    Author: Rask/AfraiEda
    Creation Date: 15/11/2022
--]]

--= Root =--
local TweensUtils = { }
local TweenService = game:GetService("TweenService")

function TweensUtils:InstantTween(Part, info, opt)
    opt = opt or {}
    info = info or {}
    opt.Goal = opt.Goal or {}
    info.Time = info.Time or 1
    info.Style = info.Style or Enum.EasingStyle.Linear
    info.Direction = info.Direction or Enum.EasingDirection.InOut
    info.Repeat = info.Repeat or 0
    info.Delay = info.Delay or 0
    info.Reverse = info.Reverse or false

    local TweenInfos = TweenInfo.new(info.Time,info.Style, info.Direction,  info.Repeat , info.Reverse, info.Delay)
    local Ts = TweenService:Create(Part, TweenInfos, opt.Goal)
    Ts:Play()
    return Ts
end


return TweensUtils