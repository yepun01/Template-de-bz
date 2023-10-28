local UIUtils = {}

function UIUtils:CheckUIScale(Instances : Instance)
    if not Instances then return end
    if Instances:FindFirstChildOfClass("UIScale") then
        return Instances:FindFirstChildOfClass("UIScale")
    else
        local Scale = Instance.new("UIScale")
        Scale.Parent = Instances
        return Scale
    end
end

function UIUtils:CheckUIGradient(Instances : Instance)
    if not Instances then return end
    if Instances:FindFirstChildOfClass("UIGradient") then
        return Instances:FindFirstChildOfClass("UIGradient")
    else
        local Scale = Instance.new("UIGradient")
        Scale.Parent = Instances
        return Scale
    end
end


return UIUtils