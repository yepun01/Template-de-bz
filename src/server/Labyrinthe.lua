--[[
    Author: yepun01
    Creation Date: 04/12/2022

    Description:
        No description provided.

    Documentation:
        No documentation provided.
--]]

--= Root =--
local Labyrinthe = { }

--= Roblox Services =--
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--= Modules & Config =--

--= Constants =--
local Assets = ReplicatedStorage.Assets
--= Functions =--

function Labyrinthe:CreateGrid(Lenght, Width, GridPosition)
    for CountLenght = 0, Lenght - 1 do
        for CountWidth = 0, Width - 1 do
            local CaseGrid = Assets.Labyrinthe.CaseGrid:Clone()
            CaseGrid.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
            CaseGrid.Material = Enum.Material.SmoothPlastic
            CaseGrid.Anchored = true
            CaseGrid.Position = Vector3.new(CaseGrid.Size.X * CountLenght, CaseGrid.Size.Y, CaseGrid.Size.Z * CountWidth)
            GridPosition[string.format("%i.%i", CountLenght, CountWidth)] = {Visited = false, Position = CaseGrid.Position}
            --CaseGrid.Parent = game.Workspace
        end
    end
end

function Labyrinthe:FindPath(LePetitPoucet, GridPosition)
    local DirectionPos = {}

    if GridPosition[string.format("%i.%i", LePetitPoucet[#LePetitPoucet].X + 1, LePetitPoucet[#LePetitPoucet].Y)] ~= nil and
        GridPosition[string.format("%i.%i", LePetitPoucet[#LePetitPoucet].X + 1, LePetitPoucet[#LePetitPoucet].Y)].Visited == false then table.insert(DirectionPos, "right") end

    if GridPosition[string.format("%i.%i", LePetitPoucet[#LePetitPoucet].X - 1, LePetitPoucet[#LePetitPoucet].Y)] ~= nil and
        GridPosition[string.format("%i.%i", LePetitPoucet[#LePetitPoucet].X - 1, LePetitPoucet[#LePetitPoucet].Y)].Visited == false then table.insert(DirectionPos, "left") end

    if GridPosition[string.format("%i.%i", LePetitPoucet[#LePetitPoucet].X, LePetitPoucet[#LePetitPoucet].Y + 1)] ~= nil and
        GridPosition[string.format("%i.%i", LePetitPoucet[#LePetitPoucet].X, LePetitPoucet[#LePetitPoucet].Y + 1)].Visited == false then table.insert(DirectionPos, "up") end

    if GridPosition[string.format("%i.%i", LePetitPoucet[#LePetitPoucet].X, LePetitPoucet[#LePetitPoucet].Y - 1)] ~= nil and
        GridPosition[string.format("%i.%i", LePetitPoucet[#LePetitPoucet].X, LePetitPoucet[#LePetitPoucet].Y - 1)].Visited == false then table.insert(DirectionPos, "down") end

    if #DirectionPos == 0 then return "none" end
    return DirectionPos[math.random(1, #DirectionPos)]
end

function Labyrinthe:CreateTheMur(GridPosition, LePetitPoucet, a, b)
    local MurLab = Assets.Labyrinthe.MurLabyrinthe:Clone()
    --MurLab.Color = Color3.fromRGB(math.random(0, 255), math.random(0, 255), math.random(0, 255))
    MurLab:SetPrimaryPartCFrame(CFrame.new(GridPosition[string.format("%i.%i", LePetitPoucet[#LePetitPoucet].X + a, LePetitPoucet[#LePetitPoucet].Y + b)].Position))
    MurLab.Parent = game.Workspace
    MurLab.Name = string.format("%i.%i", LePetitPoucet[#LePetitPoucet].X + a, LePetitPoucet[#LePetitPoucet].Y + b)
    return MurLab
end

function Labyrinthe:CreatePath(GridPosition, Path, LePetitPoucet)
    if Path == "right" then
        local MurLab = Labyrinthe:CreateTheMur(GridPosition, LePetitPoucet, 1, 0)
        MurLab.left:Destroy()
        game.Workspace:FindFirstChild(string.format("%i.%i", LePetitPoucet[#LePetitPoucet].X, LePetitPoucet[#LePetitPoucet].Y)).right:Destroy()
        GridPosition[string.format("%i.%i", LePetitPoucet[#LePetitPoucet].X + 1, LePetitPoucet[#LePetitPoucet].Y)].Visited = true
        LePetitPoucet[#LePetitPoucet + 1] = Vector2.new(LePetitPoucet[#LePetitPoucet].X + 1, LePetitPoucet[#LePetitPoucet].Y)
    end
    if Path == "left" then
        local MurLab = Labyrinthe:CreateTheMur(GridPosition, LePetitPoucet, -1, 0)
        MurLab.right:Destroy()
        game.Workspace:FindFirstChild(string.format("%i.%i", LePetitPoucet[#LePetitPoucet].X, LePetitPoucet[#LePetitPoucet].Y)).left:Destroy()
        GridPosition[string.format("%i.%i", LePetitPoucet[#LePetitPoucet].X - 1, LePetitPoucet[#LePetitPoucet].Y)].Visited = true
        LePetitPoucet[#LePetitPoucet + 1] = Vector2.new(LePetitPoucet[#LePetitPoucet].X - 1, LePetitPoucet[#LePetitPoucet].Y)
    end
    if Path == "up" then
        local MurLab = Labyrinthe:CreateTheMur(GridPosition, LePetitPoucet, 0, 1)
        MurLab.up:Destroy()
        game.Workspace:FindFirstChild(string.format("%i.%i", LePetitPoucet[#LePetitPoucet].X, LePetitPoucet[#LePetitPoucet].Y)).down:Destroy()
        GridPosition[string.format("%i.%i", LePetitPoucet[#LePetitPoucet].X, LePetitPoucet[#LePetitPoucet].Y + 1)].Visited = true
        LePetitPoucet[#LePetitPoucet + 1] = Vector2.new(LePetitPoucet[#LePetitPoucet].X, LePetitPoucet[#LePetitPoucet].Y + 1)
    end
    if Path == "down" then
        local MurLab = Labyrinthe:CreateTheMur(GridPosition, LePetitPoucet, 0, -1)
        MurLab.down:Destroy()
        game.Workspace:FindFirstChild(string.format("%i.%i", LePetitPoucet[#LePetitPoucet].X, LePetitPoucet[#LePetitPoucet].Y)).up:Destroy()
        GridPosition[string.format("%i.%i", LePetitPoucet[#LePetitPoucet].X, LePetitPoucet[#LePetitPoucet].Y - 1)].Visited = true
        LePetitPoucet[#LePetitPoucet + 1] = Vector2.new(LePetitPoucet[#LePetitPoucet].X, LePetitPoucet[#LePetitPoucet].Y - 1)
    end
end

function Labyrinthe:Create(GridPosition)
    local LePetitPoucet = {Vector2.new(0, 0)}
    local Path
    local nbtour = 0

    Labyrinthe:CreateTheMur(GridPosition, LePetitPoucet, 0, 0)
    GridPosition["0.0"].Visited = true
    while true do
        Path = Labyrinthe:FindPath(LePetitPoucet, GridPosition)
        if Path == "none" and LePetitPoucet[#LePetitPoucet]== Vector2.new(0, 0) then
            break
        elseif Path =="none" then
            table.remove(LePetitPoucet, #LePetitPoucet)
        else
            Labyrinthe:CreatePath(GridPosition, Path, LePetitPoucet)
        end
        nbtour += 1
        task.wait()
    end
end

--= Job API =--

function Labyrinthe:run()
    --local Lenght = 30
    --local Width = 30
    --local GridPosition = {}
    --local Grid = Labyrinthe:CreateGrid(Lenght, Width, GridPosition)
    --Labyrinthe:Create(GridPosition)

end

return Labyrinthe