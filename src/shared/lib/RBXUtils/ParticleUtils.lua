--[[
    Author: Rask/AfraiEda
    Creation Date: 14/11/2022
--]]

--= Root =--
local ParticleUtility = { }

function ParticleUtility:EmitAttachment(att, opt)
    opt = opt or {}
    opt.Color = opt.Color or nil
    opt.Size = opt.Size or nil
    opt.Lifetime = opt.Lifetime or nil

    for _,v in pairs(att:GetDescendants()) do
        if v:IsA("ParticleEmitter") then
            if opt.Color ~= nil then
                v.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, opt.Color), ColorSequenceKeypoint.new(1, opt.Color)})
            end
            if opt.Size ~= nil then
                local Seq = {}
                for _,e in pairs(v.Size.Keypoints) do
                    table.insert(Seq, NumberSequenceKeypoint.new(e.Time, e.Value + opt.Size))
                end
                v.Size = NumberSequence.new(Seq)
            end
            v:Emit(v:GetAttribute("EmitCount") or 1)
        end
    end
end

return ParticleUtility