--[[
    Author: yepun01
    Creation Date: 21/12/2022

    Description:
        No description provided.

    Documentation:
        No documentation provided.
--]]

--= Root =--
local run = { }

--= Roblox Services =--

--= Modules & Config =--

--= Constants =--

local Players = game:GetService('Players')
local UserInput = game:GetService('UserInputService')

--= Variables =--

--= Functions =--
function BeginSprint(Input, GameProcessed)
    local Player = Players.LocalPlayer
    local SprintSpeed = 100

    if not GameProcessed then
        if Input.UserInputType == Enum.UserInputType.Keyboard then
            local Keycode = Input.KeyCode
            if Keycode == Enum.KeyCode.LeftShift then
                Player.Character.Humanoid.WalkSpeed = SprintSpeed
            end
        end
    end
end

function EndSprint(Input, GameProcessed)
    local Player = Players.LocalPlayer
    local WalkSpeed = 30
    if not GameProcessed then
        if Input.UserInputType == Enum.UserInputType.Keyboard then
            local Keycode = Input.KeyCode
            if Keycode == Enum.KeyCode.LeftShift then
                Player.Character.Humanoid.WalkSpeed = WalkSpeed
            end
        end
    end
end
--= Job API =--

function run:run()
    UserInput.InputBegan:Connect(BeginSprint)
    UserInput.InputEnded:Connect(EndSprint)
end

return run