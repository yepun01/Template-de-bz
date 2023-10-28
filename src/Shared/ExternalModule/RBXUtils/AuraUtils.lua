--[[
    Author: StarShadow64/AtheriaRevolution
    Creation Date: 14/10/2023

    Description:
        No description provided.

    Documentation:
        No documentation provided.
--]]

--> Root <--

local AuraUtils = { }

--> Roblox Services <--

--> Modules & Config <--

--> Constants <--

--> Variables <--

--> Functions <--

--> Job API <--

function AuraUtils:AttachAura(Character : Model, Aura : Folder)
    for i, charParts in pairs(Aura:GetChildren()) do
        if Character:FindFirstChild(charParts.Name) then
            local newAuraEffect = charParts:Clone()
            newAuraEffect.CFrame = (Character:FindFirstChild(charParts.Name).CFrame)
            for _, objects in pairs(newAuraEffect:GetChildren()) do
                objects.Parent = Character:FindFirstChild(charParts.Name)
            end
        end
    end
end

return AuraUtils