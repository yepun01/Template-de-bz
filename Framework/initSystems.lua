local noYield = require(script.Parent.noYield)

local RunService = game:GetService("RunService")

return function (folders)
    local systems = {}

    for _, folder in pairs(folders) do

        local function recursiveSystems(content)
            for _, instance in pairs(content) do
                if instance:IsA('ModuleScript') then
                    local initInstance = noYield(instance)
                    if initInstance then
                        if type(initInstance) ~= 'function' and initInstance.init and type(initInstance.init) == 'function' then
                            initInstance.init()
                        end

                        table.insert(systems, initInstance)
                    end
                elseif instance:IsA('Folder') then
                    recursiveSystems(instance:GetChildren())
                end
            end
        end

        recursiveSystems(folder:GetChildren())
    end

    return systems
end