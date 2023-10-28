--[[
    Author: Rask/AfraiEda
    Creation Date: 11/08/2023

    Description:
        No description provided.

    Documentation:
        No documentation provided.
--]]

local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local Promise = require(ReplicatedStorage.Packages.promise)

--= Root =--
local GradientUtils = { }

function GradientUtils:ReplaceGradient(Frame : Frame, Gradient : UIGradient)
    if not Frame or not Gradient then return end
    if Frame:FindFirstChildOfClass("UIGradient") then
        Frame:FindFirstChildOfClass("UIGradient"):Destroy()
    end
    local gr = Gradient:Clone()
    gr.Parent = Frame
end

function GradientUtils:TweenGradient(Ui : UIBase, Time : number, speed : number)
    return Promise.new(function(resolve)
        local style = Enum.EasingStyle.Quad
        local dir = Enum.EasingDirection.InOut
        Time = Time or 0

        local num = Instance.new("NumberValue")
        num.Value = Ui.Transparency.Keypoints[2].Time
        local tw = TweenService:Create(num, TweenInfo.new(speed, style, dir), {Value = Time})
        tw:Play()

        local con
        con = RunService.Heartbeat:Connect(function()
            GradientUtils:LerpGradient(num.Value, Ui)
        end)

        tw.Completed:Connect(function()
            con:Disconnect()
            num:Destroy()
            resolve(true)
        end)
    end)
end

function lerpColor(startColor, endColor, alpha)
    return startColor:Lerp(endColor, alpha)
end

function GradientUtils:lerpGradientColor(gradient, endColor, duration)
    local startTime = tick()
    local startColor = gradient.Color.Keypoints[1].Value

    local heartbeatConnection
    heartbeatConnection = RunService.Heartbeat:Connect(function()
        local elapsedTime = tick() - startTime
        local alpha = elapsedTime / duration

        if alpha >= 1 then
            alpha = 1
            heartbeatConnection:Disconnect()
        end

        local newColor = lerpColor(startColor, endColor, alpha)
        local colorKeypoints = { ColorSequenceKeypoint.new(0, newColor), ColorSequenceKeypoint.new(1, newColor) }
        local colorSequence = ColorSequence.new(colorKeypoints)

        gradient.Color = colorSequence
    end)
end


function GradientUtils:lerpGradientColors(gradient, endColorSequence, duration)
    local startTime = tick()

    local startKeypoints = gradient.Color.Keypoints
    local endKeypoints = endColorSequence.Keypoints

    assert(#startKeypoints == #endKeypoints, "Both ColorSequences must have the same number of keypoints!")

    local heartbeatConnection
    heartbeatConnection = RunService.Heartbeat:Connect(function()
        local elapsedTime = tick() - startTime
        local alpha = elapsedTime / duration

        if alpha >= 1 then
            alpha = 1
            heartbeatConnection:Disconnect()
        end

        local newKeypoints = {}
        for i = 1, #startKeypoints do
            local startKeypoint = startKeypoints[i]
            local endKeypoint = endKeypoints[i]

            local newColor = lerpColor(startKeypoint.Value, endKeypoint.Value, alpha)
            table.insert(newKeypoints, ColorSequenceKeypoint.new(startKeypoint.Time, newColor))
        end

        gradient.Color = ColorSequence.new(newKeypoints)
    end)
end

function GradientUtils:SetColor(gradient, color3)
    local colorKeypoints = { ColorSequenceKeypoint.new(0, color3), ColorSequenceKeypoint.new(1, color3) }
    local colorSequence = ColorSequence.new(colorKeypoints)

    gradient.Color = colorSequence
end

function GradientUtils:LerpGradient(Time : number, Ui : UIBase)
    local seq = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(math.clamp(Time, 0, 0.998), 0),
        NumberSequenceKeypoint.new(math.clamp(Time + 0.001, 0.001, 0.999), 1),
        NumberSequenceKeypoint.new(1, 1)
    }
    Ui.Transparency = seq
    return seq
end

return GradientUtils