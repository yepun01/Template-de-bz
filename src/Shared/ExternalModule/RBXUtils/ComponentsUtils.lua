local ComponentsUtils = {}

--//Services
local ReplicatedStorage = game:GetService('ReplicatedStorage')
--//Modules
local Components = require(ReplicatedStorage.Packages.Component)

function ComponentsUtils:GetInstanceByTag(Instances : Instance, Tag : string)
    local Comp = Components.FromTag(Tag)
    if not Comp then return end
    return Comp:GetFromInstance(Instances)
end

function ComponentsUtils:GetInstanceByTagUntil(Instances : Instance, Tag : string)
    repeat task.wait() until Components.FromTag(Tag)
    local Comp = Components.FromTag(Tag)
    if not Comp then return end
    return Comp:GetFromInstance(Instances)
end

return ComponentsUtils