local PartUtils = {}

local TweenUtils = require(script.Parent.TweensUtils)

function PartUtils.anchor(model: Model): nil
    for _,part in ipairs(PartUtils.getDescendantsOfClass(model, "BasePart")) do
        part.Anchored = true
    end
end

function PartUtils:SetCanCollide(Model : Model, CanCollide : boolean)
    if Model == nil then return end

    for _,v in pairs(Model:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = CanCollide
        end
    end
end

function PartUtils:SetCollisionGroup(Model : Model, Group : string)
    if Model == nil then return end

    for _,v in pairs(Model:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CollisionGroupId = Group
        end
    end
end

function PartUtils:TweenTransparencyModel(mod, transparency, times)
    if mod == nil then return end

    for _,v in pairs(mod:GetDescendants()) do
        if v.Name == "HumanoidRootPart" then continue end
        if v:IsA("BasePart") or v:IsA("Decal") then
            TweenUtils:InstantTween(v, {Time = times, Style = Enum.EasingStyle.Quad}, {Goal = {Transparency = transparency}})
        end
    end
end

function PartUtils:LocalTranspenracyModel(mod, transparency)
    if mod == nil then return end

    for _,v in pairs(mod:GetDescendants()) do
        if v:IsA("BasePart") or v:IsA("Decal") then
            TweenUtils:InstantTween(v, {Time = 0.2, Style = Enum.EasingStyle.Quad}, {Goal = {LocalTransparencyModifier = transparency}})
        end
    end
end

function PartUtils:findInstanceByNameInChild(parent : Instance, name : string)
    if parent.Name == name then
        return parent
    end
    for _, child in ipairs(parent:GetChildren()) do
        local foundInstance = PartUtils:findInstanceByNameInChild(child, name)
        if foundInstance then
            return foundInstance
        end
    end
    return nil
end

function PartUtils:findInstanceByPath(startInstance, path, retryInterval)
    if not startInstance or not path then
        error("Invalid input parameters to findInstanceByPathWithRetry")
        return nil
    end

    local maxRetries = 3
    retryInterval = retryInterval or 1

    local currentInstance = startInstance

    for attempt = 1, maxRetries do
        local parts = string.split(path, "/")
        currentInstance = startInstance

        for _, part in ipairs(parts) do
            if part == ".." then
                currentInstance = currentInstance.Parent
            elseif part == "." then
                continue
            else
                currentInstance = currentInstance:FindFirstChild(part)
            end

            if not currentInstance then
                task.wait(retryInterval)
                break
            end
        end
        if currentInstance then
            return currentInstance
        end
    end
    return nil
end
function PartUtils:Dist(part, part2)
    if part == nil or part2 == nil then return 0 end

    return (part.Position - part2.Position).Magnitude
end

function PartUtils:SetNetworkModel(model, network)
    if model:IsA("BasePart") then
        if network == "auto" then
            model:SetNetworkOwner()
        else
            model:SetNetworkOwner(network)
        end
    end
    for _,v in pairs(model:GetDescendants()) do
        if v:IsA("BasePart") then
            if network == "auto" then
                v:SetNetworkOwner()
            else
                v:SetNetworkOwner(network)
            end
        end
    end
end

function PartUtils:Exist(model: Model)
    if model == nil then return false end
    if model.PrimaryPart == nil then return false end

    return true
end

function PartUtils:UntilExist(model: Model)
    if model == nil then return false end
    repeat task.wait() until model.PrimaryPart ~= nil

    return true
end

function PartUtils.unanchor(model: Model): nil
    for _,part in ipairs(PartUtils.getDescendantsOfClass(model, "BasePart")) do
        part.Anchored = false
    end
end

function PartUtils.weld(main: BasePart, ...): nil
    local parts = {...}

    for _,part in ipairs(parts) do
        if part ~= main then
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = main
            weld.Part1 = part
            weld.Parent = part
        end
    end
end

function PartUtils.makeMotor6D(part0, part1)
    local motor6D = Instance.new("Motor6D")
    motor6D.Part0 = part0
    motor6D.Part1 = part1
    motor6D.Parent = part0
    return motor6D
end

function PartUtils.getChildrenOfClass(container: Instance, class: string)
    local instances = {}

    for _,instance in ipairs(container:GetChildren()) do
        if instance:IsA(class) then
            table.insert(instances, instance)
        end
    end

    return instances
end

function PartUtils.getDescendantsOfClass(container: Instance, class: string)
    local instances = {}

    for _,instance in ipairs(container:GetDescendants()) do
        if instance:IsA(class) then
            table.insert(instances, instance)
        end
    end

    return instances
end

return PartUtils