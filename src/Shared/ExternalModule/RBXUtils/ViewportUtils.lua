--[[
    Author: Rask/AfraiEda
    Creation Date: 07/08/2023
--]]

--= Root =--
local ViewportUtils = { }

function ViewportUtils:CreateViewportCharacter(Player : Model, Viewport : ViewportFrame)
    local characterClone = Player:Clone()

    for _, item in pairs(characterClone:GetDescendants()) do
        if item:IsA("Script") or item:IsA("LocalScript") then
            item:Destroy()
        end
    end
    local Head = characterClone:FindFirstChild("Head")
    local camera = Instance.new("Camera")
    local rootPartPosition = Head.Position
    local lookVector = Head.CFrame:VectorToWorldSpace(Vector3.new(0, 0, -1))

    characterClone.Parent = Viewport
    camera.CFrame = CFrame.new(rootPartPosition - lookVector * -2, rootPartPosition)
    camera.Parent = Viewport
    Viewport.CurrentCamera = camera
end

function ViewportUtils:ClearViewport(Viewport : ViewportFrame)
    for _, item in pairs(Viewport:GetDescendants()) do
        if item:IsA("WorldModel") then continue end
        if item:IsA("Model") or item:IsA("Camera") then
            item:Destroy()
        end
    end
end

return ViewportUtils