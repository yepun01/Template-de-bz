local Workspace = game:GetService("Workspace")
--[[
    Author: Rask/AfraiEda
    Creation Date: 14/11/2022
--]]

--= Root =--
local ParticleUtility = { }


function ParticleUtility:GetLongestLifeTimeParticle(Particle : Instance)
    local longest = nil

    for _,v in pairs(Particle:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            if longest == nil then
                longest = v.Lifetime.Max
            else
                if v.Lifetime.Max > longest then
                    longest = v.Lifetime.Max
                end
            end
        end
    end
    return longest
end

function ParticleUtility:Emit3DParticle(Particle : Instance, Position : Vector3, Color : Color3)
    coroutine.wrap(function()
        local newEmitter = Particle:Clone()
        newEmitter.Position = Position
        newEmitter.Parent = Workspace

        ParticleUtility:EmitAttachment(newEmitter, {Color = Color})
        task.wait(ParticleUtility:GetLongestLifeTimeParticle(newEmitter))
        newEmitter:Destroy()
    end)()
end

function ParticleUtility:SetZOffset(Particle : Instance, Offset : number)
    for _,v in pairs(Particle:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            v.ZOffset = Offset
        end
    end
end

function ParticleUtility:EnableAttachment(Particle : Instance, opt)
    opt = opt or {}
    opt.Color = opt.Color or nil
    opt.Size = opt.Size or nil
    opt.Emit = opt.Emit or 0
    opt.Lifetime = opt.Lifetime or nil

    for _,v in pairs(Particle:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            if opt.Color ~= nil and not v:GetAttribute("NoColor") then
                v.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, opt.Color), ColorSequenceKeypoint.new(1, opt.Color)})
            end
            v.Enabled = true
        end
    end
end

function ParticleUtility:DisableAttachment(Particle : Instance)
    for _,v in pairs(Particle:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            v.Enabled = false
        end
    end
end

function ParticleUtility:EmitAttachment(att, opt)
    opt = opt or {}
    opt.Color = opt.Color or nil
    opt.Size = opt.Size or nil
    opt.Emit = opt.Emit or 0
    opt.Lifetime = opt.Lifetime or nil

    for _,v in pairs(att:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            if opt.Color ~= nil and not v:GetAttribute("NoColor") then
                v.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, opt.Color), ColorSequenceKeypoint.new(1, opt.Color)})
            end
            if opt.Size ~= nil then
                local Seq = {}
                for _,e in pairs(v.Size.Keypoints) do
                    table.insert(Seq, NumberSequenceKeypoint.new(e.Time, e.Value + opt.Size))
                end
                v.Size = NumberSequence.new(Seq)
            end
            local save = v:GetAttribute("EmitCount")
            if opt.Emit ~= 0 then
                v:SetAttribute("EmitCount", opt.Emit)
            end
            v:Emit(v:GetAttribute("EmitCount"))
            v:SetAttribute("EmitCount", save)
        end
    end
end

return ParticleUtility