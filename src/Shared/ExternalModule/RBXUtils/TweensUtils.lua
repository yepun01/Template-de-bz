--[[
    Author: Rask/AfraiEda
    Creation Date: 15/11/2022
--]]

--= Root =--
local TweensUtils = { }
local TweenService = game:GetService("TweenService")

local function tweenModel(model, CF, info)
    if (not model) or (not model.PrimaryPart) then return end
    local CFrameValue = Instance.new("CFrameValue")
    if model.PrimaryPart then CFrameValue.Value = model:GetPrimaryPartCFrame() end

    CFrameValue:GetPropertyChangedSignal("Value"):Connect(function()
        if model then model:PivotTo(CFrameValue.Value) end
    end)

    local tween = TweenService:Create(CFrameValue, info, {Value = CF})
    tween:Play()

    tween.Completed:Connect(function()
        CFrameValue:Destroy()
    end)
end

function TweensUtils:InstantModelTween(Model, info, opt)
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
    tweenModel(Model, opt.Goal.CFrame, TweenInfos)
end

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