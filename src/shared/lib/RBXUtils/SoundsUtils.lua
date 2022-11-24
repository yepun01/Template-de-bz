--[[
    Author: Rask/AfraiEda
    Creation Date: 15/11/2022
--]]

--= Root =--
local SoundsUtils = { }
local SoundService = game:GetService("SoundService")

function SoundsUtils:PlayLocalSound(sound)
    SoundService:PlayLocalSound(sound)
end

function SoundsUtils:Play3DSound(sound, pos, props)
    local attachemnt = Instance.new("Attachment")
    if typeof(sound) == "Instance" then
        sound = sound:Clone()
    else
        local soundId = sound
        sound = Instance.new("Sound")
        sound.SoundId = soundId
    end
    sound.Parent = attachemnt
    attachemnt.WorldPosition = pos
    attachemnt.Parent = workspace.Terrain

    if props then
        for i,v in pairs(props) do
            sound[i] = v
        end
    end

    sound:Play()
    sound.Ended:Connect(function()
        attachemnt:Destroy()
    end)
end

return SoundsUtils