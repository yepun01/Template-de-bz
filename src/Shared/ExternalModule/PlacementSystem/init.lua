--[[
	Written by Tunicus
	V2 Made 20/10/2017 - tunicus (date format: dd/mm/yy)
	V3 Made 13/11/2021 - glitchifyed
	V3.1.2 Made 24/7/2022 - glitchifyed
	Modified by glitchifyed (V3-V3.1.2)
	V2 Model link: https://www.roblox.com/library/1122124371
	V3.1.2 Model link: https://www.roblox.com/library/7980966840
	V2 Youtube Tutorial: https://www.youtube.com/watch?v=8PKDBTBUTOc (V2 tutorial, some things in the video have slight modifications when being used)
	V3.1.2 Youtube Tutorial: potentially coming soon
	Developer Forum post: https://devforum.roblox.com/t/read-solution-first-tunicus-grid-placement-module-v3-open-source/1547553
	V3+ Github: https://github.com/glitchifyed/Tunicus-Placement-v3
	Giving credit is optional (would be a nice thing to do though. make sure to credit both tunicus and glitchifyed)
--]]

--[[
	CONFIGURATION (GO IN PlacementConfiguration TO CONFIG)
--]]

local PlacementConfiguration = require(game.ReplicatedStorage.Shared.Configuration:FindFirstChild("Placement")) --// MODIFIE SETTINGS IN HERE
local PlacementParameters = PlacementConfiguration.placementParameters

--// PLACEMENT SETTINGS

local INTERPOLATION = PlacementParameters.INTERPOLATION
local WOBBLE_ITEMS = PlacementParameters.WOBBLE_ITEMS
local INTERPOLATION_DAMP = PlacementParameters.INTERPOLATION_DAMP
local ROTATION_SPEED = PlacementParameters.ROTATION_SPEED

local PLACEMENT_COOLDOWN = PlacementParameters.PLACEMENT_COOLDOWN
local HOLD_TO_PLACE = PlacementParameters.HOLD_TO_PLACE

local IGNORE_TAG = PlacementParameters.IGNORE_TAG

--// PLACEMENT COLORS, TRANSPARENCY, FADING

local COLLISION_COLOR3 = PlacementParameters.COLLISION_COLOR3
local COLLISION_OUTLINECOLOR3 = PlacementParameters.COLLISION_OUTLINECOLOR3
local COLLISION_TRANSPARENCY = PlacementParameters.COLLISION_TRANSPARENCY

local NORMAL_COLOR3 = PlacementParameters.NORMAL_COLOR3
local NORMAL_OUTLINECOLOR3 = PlacementParameters.NORMAL_OUTLINECOLOR3
local NORMAL_TRANSPARENCY = PlacementParameters.NORMAL_TRANSPARENCY

local LOAD_COLOR3 = PlacementParameters.LOAD_COLOR3
local LOAD_TRANSPARENCY = PlacementParameters.LOAD_TRANSPARENCY

local HIT_BOX_FADE_TIME = PlacementParameters.HIT_BOX_FADE_TIME

--// SELECTION BOXES
local SELECTION_BOX_TRANSPARENCY = PlacementParameters.SELECTION_BOX_TRANSPARENCY
local SELECTION_BOX_COLOR3 = PlacementParameters.SELECTION_BOX_COLOR3
local SELECTION_BOX_PLACING_THICKNESS = PlacementParameters.SELECTION_BOX_PLACING_THICKNESS
local SELECTION_BOX_OBSTACLE_THICKNESS = PlacementParameters.SELECTION_BOX_OBSTACLE_THICKNESS

--// GRID SETTINGS
local GRID_TEXTURE = PlacementParameters.GRID_TEXTURE
local GRID_COLOR3 = PlacementParameters.GRID_COLOR3
local GRID_TRANSPARENCY = PlacementParameters.GRID_TRANSPARENCY
local GRID_FADE_TIME = PlacementParameters.GRID_FADE_TIME
local TEXTURE_ON_PLATFORMS = PlacementParameters.TEXTURE_ON_PLATFORMS

--// CONTROLS
local OVERRIDE_CONTROLS = PlacementParameters.OVERRIDE_CONTROLS
local INPUT_PRIORITY = PlacementParameters.INPUT_PRIORITY

local PLACE_KEYBINDS = PlacementParameters.PLACE_KEYBINDS
local ROTATE_KEYBINDS = PlacementParameters.ROTATE_KEYBINDS
local HYDRAULIC_UP_KEYBINDS = PlacementParameters.HYDRAULIC_UP_KEYBINDS
local HYDRAULIC_DOWN_KEYBINDS = PlacementParameters.HYDRAULIC_DOWN_KEYBINDS
local CANCEL_KEYBINDS = PlacementParameters.CANCEL_KEYBINDS

--// CORE GUI
local CORE_GUI_DISABLE = PlacementParameters.CORE_GUI_DISABLE


--[[
	DO NOT EDIT PAST THESE LINES UNLESS YOU KNOW WHAT YOU'RE DOING - lol i do though ! Me too hehe ^^
--]]

local module = {}

local player = game.Players.LocalPlayer
local mouse = player:GetMouse()
local runService = game:GetService("RunService")
local tweenService = game:GetService("TweenService")
local contextActionService = game:GetService("ContextActionService")
local userInputService = game:GetService("UserInputService")

local touch = userInputService.TouchEnabled

local currentPlane
local currentBase
local currentPlatforms
local currentPlatform
local currentInput

local lastPlatforms

local coreInputs = {Enum.KeyCode.ButtonR1, Enum.KeyCode.ButtonL1, Enum.KeyCode.DPadUp, Enum.KeyCode.DPadDown, Enum.KeyCode.DPadLeft, Enum.KeyCode.DPadRight}

local newHit

local obstacleAdded
local obstacleRemoved

local renderConnection = nil

local cx, cy, cz, cr = 0, 0, 0, 0
local currentObjects = {}
local currentEvent
local currentTextures
local currentPosition = Vector3.new(0, 0, 0)
local ax, az

local currentExtentsX
local currentExtentsZ
local currentYAxis
local currentXAxis
local currentZAxis
local currentAxis

local ox, oy, oz -- do
local dxx, dxy, dxz
local dzx, dzy, dzz

local min = math.min
local max = math.max
local abs = math.abs

local springVelocity = Vector3.new(0, 0, 0)
local springPosition = Vector3.new(0, 0, 0)
local tweenGoalRotation = 0 -- springs arent worth effort for rotation
local tweenStartRotation = 0
local tweenCurrentRotation = 0
local tweenAlpha = 1

local lastRenderCycle = tick()
local lastPlacement = tick()

local placing

local platformSize = 1

local function createSelectionBox(model, obstacle)
	for _, obj in pairs(model.PrimaryPart:GetChildren()) do
		if obj:IsA("Highlight") then
			obj:Destroy()
		end
	end
	
	if SELECTION_BOX_TRANSPARENCY < 1 then
		local selectionBox = Instance.new("Highlight")
		selectionBox.DepthMode = Enum.HighlightDepthMode.Occluded
		selectionBox.OutlineColor = Color3.new(1,1,1)
		selectionBox.FillColor = SELECTION_BOX_COLOR3

		if HIT_BOX_FADE_TIME > 0 then
			selectionBox.OutlineTransparency = 1
			selectionBox.FillTransparency = 1

			tweenService:Create(selectionBox, TweenInfo.new(HIT_BOX_FADE_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {OutlineTransparency = SELECTION_BOX_TRANSPARENCY, FillTransparency = 0.5 + SELECTION_BOX_TRANSPARENCY}):Play()
		else
			selectionBox.OutlineTransparency = SELECTION_BOX_TRANSPARENCY
			selectionBox.FillTransparency = 0.5 + SELECTION_BOX_TRANSPARENCY
		end

		--selectionBox.LineThickness = obstacle and SELECTION_BOX_OBSTACLE_THICKNESS or SELECTION_BOX_PLACING_THICKNESS

		selectionBox.Adornee = model
		selectionBox.Parent = model.PrimaryPart
	end
end

local function round(n, to)
	return n % to ~= 0 and (n % to) > to/2 and (n + to - (n % to)) or (n - (n % to))	
end

local function project(px, py, pz)
	px, py, pz = px - ox, py - oy, pz - oz

	return px * dxx + py * dxy + pz * dxz, px * dzx + py * dzy + pz * dzz
end

local function translate(px, pz, r)
	if (r == 0) then
		return px, pz
	elseif (r == 1) then
		return -pz, px
	elseif (r == 2) then
		return -px, -pz
	elseif (r == 3) then
		return pz, -px
	end

	--  or for all angles
	--	r = r * math.pi/2
	--	return math.cos(r) * px - math.sin(r) * pz,  math.sin(r) * px + math.cos(r) * pz	
end

local function angleLerp(a, b, d) -- to avoid angle jump
	local x1, y1 = math.cos(a), math.sin(a)
	local x2, y2 = math.cos(b), math.sin(b)

	return math.atan2(y1 + (y2 - y1) * d, x1 + (x2 - x1) * d)
end

local function calculateExtents(part, cf)
	local cf = cf or part.CFrame

	local edgeA = cf * CFrame.new(-part.Size.X/2, 0, 0)
	local edgeB = cf * CFrame.new(part.Size.X/2, 0, 0)
	local edgeC = cf * CFrame.new(0, 0, part.Size.Z/2)
	local edgeD = cf * CFrame.new(0, 0, -part.Size.Z/2)

	local edgeAx, edgeAz = project(edgeA.X, edgeA.Y, edgeA.Z)
	local edgeBx, edgeBz = project(edgeB.X, edgeB.Y, edgeB.Z)
	local edgeCx, edgeCz = project(edgeC.X, edgeC.Y, edgeC.Z)
	local edgeDx, edgeDz = project(edgeD.X, edgeD.Y, edgeD.Z)

	local extentsX = max(edgeAx, edgeBx, edgeCx, edgeDx) - min(edgeAx, edgeBx, edgeCx, edgeDx)
	local extentsZ = max(edgeAz, edgeBz, edgeCz, edgeDz) - min(edgeAz, edgeBz, edgeCz, edgeDz)

	return round(extentsX, currentPlane.grid), round(extentsZ, currentPlane.grid)
end

local states = {
	neutral = 1;
	collision = 2;
	loading = 3;
}

module.states = states

local function setState(object, state, downward)
	if (object.state and (object.state == state or (object.state > state and not downward))) then
		return
	end

	object.state = state
	
	local stateColor, stateTransparency
	local selectionColor, selectionTransparency = SELECTION_BOX_COLOR3, SELECTION_BOX_TRANSPARENCY
	
	if (state == 1) then
		if (NORMAL_COLOR3) then
			stateColor = NORMAL_COLOR3
			selectionColor = NORMAL_OUTLINECOLOR3
		end
		
		if (NORMAL_TRANSPARENCY) then
			stateTransparency = NORMAL_TRANSPARENCY
		end
	elseif (state == 2) then
		if (COLLISION_COLOR3) then
			stateColor = COLLISION_COLOR3
			selectionColor = COLLISION_OUTLINECOLOR3
		end
		
		if (COLLISION_TRANSPARENCY) then
			stateTransparency = COLLISION_TRANSPARENCY
			selectionTransparency = COLLISION_TRANSPARENCY
		end
	elseif (state == 3) then
		if (LOAD_COLOR3) then
			stateColor = LOAD_COLOR3
			selectionColor = LOAD_COLOR3
		end
		
		if (LOAD_TRANSPARENCY) then
			stateTransparency = LOAD_TRANSPARENCY
			selectionTransparency = LOAD_TRANSPARENCY
		end
	end
	
	if stateColor then
		if HIT_BOX_FADE_TIME > 0 then
			tweenService:Create(object.model.PrimaryPart.Highlight, TweenInfo.new(HIT_BOX_FADE_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {FillColor = stateColor}):Play()
			
			if SELECTION_BOX_TRANSPARENCY < 1 then
				tweenService:Create(object.model.PrimaryPart.Highlight, TweenInfo.new(HIT_BOX_FADE_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {OutlineColor = selectionColor}):Play()
			end
		else
			if SELECTION_BOX_TRANSPARENCY < 1 then
				object.model.PrimaryPart.Highlight.FillColor = stateColor
				object.model.PrimaryPart.Highlight.OutlineColor = selectionColor
			end
		end
	end

	currentPlane.stateEvent:Fire(object.model, state)
end

--[[
	status
	model
	px, pz, r
	sx, sz
--]]

local function setObjectY(obj)
	obj.model:SetAttribute("y", (obj.model:GetAttribute("height") or 0) + (obj.platformY or 0))
end

local function floatEqual(a, b)
	return (abs(a - b) < .01)
end

local function floatGreater(a, b)
	return (a - b) > .01
end

local function floatLesser(a, b)
	return (b - a) > .01
end

local function floatLesserOrEqual(a, b)
	return (b - a) > .01 or floatEqual(a, b)
end

local function floatGreaterOrEqual(a, b)
	return (a - b) > .01 or floatEqual(a, b)
end

local function obstacleCollision()
	local px, pz = cx, cz

	local collision = false
	local originObject = currentObjects[1]
	local objectToCheck = originObject.model:Clone()
	objectToCheck:PivotTo(originObject.NewCFrame)


	for i, parts in pairs(objectToCheck:GetDescendants()) do
		if originObject.collision then break end
		if parts:IsA("BasePart") or parts:IsA("MeshPart") then
			if parts.Parent:GetAttribute("Uncolidable") or parts:GetAttribute("Uncolidable") then continue end
			local outerPartsToCheck = game.Workspace:GetPartsInPart(parts)
			for v, outerparts in pairs(outerPartsToCheck) do
				if outerparts.Parent:GetAttribute("Uncolidable") or outerparts:GetAttribute("Uncolidable") then continue end
				if not outerparts:IsDescendantOf(currentPlane.obstacles) then continue end
				if outerparts.Parent:GetAttribute("GroundType") and (not originObject.model:GetAttribute("GroundType")) then continue end
				if (not outerparts:IsDescendantOf(objectToCheck)) and (not outerparts:IsDescendantOf(originObject.model)) then
					collision = true
					originObject.collision = true
					setState(originObject, states.collision)
					break
				end
			end
		end
	end

	objectToCheck:Destroy()

	for i = 1, #currentObjects do
		local object = currentObjects[i]

		if (not object.collision and object.state == states.collision) then
			setState(object, states.neutral, true)
		else
			object.collision = nil
		end
	end

	return not collision
end

local function inputCapture() -- converts user inputs to 3d position, built in mobile compatibility
	local position
	
	local rayOrigin, rayDirection
	
	if (touch) then
		local camera = workspace.CurrentCamera

		rayOrigin, rayDirection = camera.CFrame.Position, camera.CFrame.LookVector
	else
		rayOrigin, rayDirection = mouse.UnitRay.Origin, mouse.UnitRay.Direction
	end
	
	local rayParams = RaycastParams.new()
	rayParams.FilterDescendantsInstances = {currentPlane.base, table.unpack(currentPlatforms)}
	rayParams.FilterType = Enum.RaycastFilterType.Whitelist
	rayParams.IgnoreWater = true
	
	local result = workspace:Raycast(rayOrigin, rayDirection * 999, rayParams)
	
	local hit, p
	
	if result then
		hit, p = result.Instance, result.Position
	end
	
	if not newHit then
		local currentHit = currentPlatform or currentBase

		newHit = hit ~= currentHit and currentHit or nil
	end

	if (hit) then
		local isIgnored = false
		for i, parts in pairs(game.CollectionService:GetTagged(IGNORE_TAG)) do
			if p.X > parts.PrimaryPart.Position.X - parts.PrimaryPart.Size.X/2 and p.X < parts.PrimaryPart.Position.X + parts.PrimaryPart.Size.X/2 then
				if p.Z > parts.PrimaryPart.Position.Z - parts.PrimaryPart.Size.Z/2 and p.Z < parts.PrimaryPart.Position.Z + parts.PrimaryPart.Size.Z/2 then
					isIgnored = true
				end
			end
		end
		
		if isIgnored == false then
			position = p

			if hit ~= currentBase then
				currentPlatform = hit
			else
				currentPlatform = nil
			end
		else
			currentPlatform = nil
		end
	else
		currentPlatform = nil
	end

	return position, cr
end

local resting = false

local function calc(position, rotation, force)
	if (not currentPlane or currentPlane.loading) then
		return
	end

	force = force == true

	local ux, uz

	if (position) then
		ux, uz = project(position.X, position.Y, position.Z)
	else
		ux, uz = ax or 0, az or 0
	end

	local nr = rotation or cr

	local nx = math.floor(ux / currentPlane.grid + 1) * currentPlane.grid --round(ux, currentPlane.grid) still don't know why...
	local nz = math.floor(uz / currentPlane.grid + 1) * currentPlane.grid --round(uz, currentPlane.grid) still don't know why...

	local extentsX, extentsZ = translate(currentExtentsX, currentExtentsZ, nr)
	extentsX = abs(extentsX)
	extentsZ = abs(extentsZ)

	if (floatEqual(extentsX/2 % currentPlane.grid, 0)) then
		nx = nx + currentPlane.grid/2
	end

	if (floatEqual(extentsZ/2 % currentPlane.grid, 0)) then
		nz = nz + currentPlane.grid/2
	end

	nx = nx + currentPlane.offsetX
	nz = nz + currentPlane.offsetZ

	local borderX = currentPlane.size.X/2
	local borderZ = currentPlane.size.Z/2

	ax = ux
	az = uz

	if (nx + extentsX/2 > borderX) then
		nx = nx - (nx + extentsX/2 - borderX)
	elseif (nx - extentsX/2 < -borderX) then
		nx = nx - (nx - extentsX/2 + borderX)
	end

	if (nz + extentsZ/2 > borderZ) then
		nz = nz - (nz + extentsZ/2 - borderZ)
	elseif (nz - extentsZ/2 < -borderZ) then
		nz = nz - (nz - extentsZ/2 + borderZ)
	end

	local unrest = force or nx ~= cx or nz ~= cz or cr ~= nr
	
	local newHitIsntBase = newHit and newHit ~= currentBase
	
	local platformNumber = #currentPlatforms
	
	if not unrest or currentPlatform or newHit or lastPlatforms ~= platformNumber then
		if lastPlatforms ~= platformNumber then
			lastPlatforms = platformNumber
		end
		
		local extentsX1, extentsZ1, x1, z1, px, pz, cr
		
		local currentHit
		
		if currentPlatform or newHitIsntBase then
			currentHit = currentPlatform or newHit
			
			extentsX1, extentsZ1 = calculateExtents(currentHit)
			x1, z1 = project(currentHit.Position.X, currentHit.Position.Y, currentHit.Position.Z)
			px, pz, cr = nx, nz, nr
		end
		
		local yPlatforms = {}
		
		if currentPlatform and currentHit then
			for _, platform in pairs(currentPlatforms) do
				if platform.Position.Y == currentHit.Position.Y then
					table.insert(yPlatforms, platform)
				end
			end
		end
		
		local params = RaycastParams.new()
		params.FilterDescendantsInstances = yPlatforms
		params.FilterType = Enum.RaycastFilterType.Whitelist
		params.IgnoreWater = true
		
		local no_object_on_platforms = true
		
		for _, obj in pairs(currentObjects) do
			if #obj.on_platforms ~= 0 then
				no_object_on_platforms = nil
			end
			
			if not no_object_on_platforms then
				continue
			end
		end
		
		for _, obj in pairs(currentObjects) do
			if not unrest and (INTERPOLATION and Vector3.new(0, obj.yVelocity, 0).magnitude > 0 or (not obj.lastPosition or obj.lastPosition ~= obj.model:GetPivot())) then
				unrest = true
				
				if not INTERPOLATION then
					obj.lastPosition = obj.model:GetPivot()
				end

				break
			end
			
			local platformY = 0

			if currentPlatform and currentHit and no_object_on_platforms then
				local r = (obj.r + cr) % 4			

				local x0, z0 = translate(obj.px, -obj.pz, cr)
				x0 = x0 + px
				z0 = z0 + pz

				local extentsX0, extentsZ0				

				if (r == 1 or r == 3) then
					extentsX0, extentsZ0 = obj.sz, obj.sx
				else
					extentsX0, extentsZ0 = obj.sx, obj.sz
				end
				
				local extentsY0 = obj.sy
				local y0 = obj.model:GetAttribute("y") * currentPlane.grid
				
				local points = {}
				
				for x = x0 - extentsX0 / 2, x0 + extentsX0 / 2 + 0.001, currentPlane.grid / 2 do
					for z = z0 - extentsZ0 / 2, z0 + extentsZ0 / 2 + 0.001, currentPlane.grid / 2 do
						points[Vector3.new(x, 0, z)] = false
					end
				end
				
				local function allPointsInsideAPlatform()
					for point, inside in pairs(points) do
						if not inside then
							return
						end
					end
					
					return true
				end
				
				local pointsInsidePlatform
				
				for _, platform in pairs(yPlatforms) do
					local extentsX2, extentsZ2 = calculateExtents(platform)
					local x2, z2 = project(platform.Position.X, platform.Position.Y, platform.Position.Z)
					
					for point, inside in pairs(points) do
						if not inside then
							if floatLesser(point.X - currentPlane.grid / 2, x2 + extentsX2 / 2) and floatGreater(point.X + currentPlane.grid / 2, x2 - extentsX2 / 2) and floatLesser(point.Z - currentPlane.grid / 2, z2 + extentsZ2 / 2) and floatGreater(point.Z + currentPlane.grid / 2, z2 - extentsZ2 / 2) then
								points[point] = true
							end
						end
						
						pointsInsidePlatform = allPointsInsideAPlatform()
						
						if pointsInsidePlatform then
							break
						end
					end
					
					if pointsInsidePlatform then
						break
					end
				end
				
				if pointsInsidePlatform then
					platformY = (currentHit.Position.Y + platformSize / 2 - currentBase.Position.Y - currentBase.Size.Y / 2) / currentPlane.grid
				end
			end
			
			if newHit then
				newHit = nil
			end
			
			local on_platform_heights = {}
			
			
			for _, platform in pairs(obj.on_platforms) do
				local platform_y_pos = platform:GetAttribute("y") * currentPlane.grid + platform.platform.Size.Y
				
				if not table.find(on_platform_heights, platform_y_pos) then
					table.insert(on_platform_heights, platform_y_pos)
				end
				
				if #on_platform_heights > 1 then
					break
				end
			end
			
			if #on_platform_heights == 1 then
				obj.model:SetAttribute("on_platform_y", on_platform_heights[1] / currentPlane.grid)
			end
			
			obj.platformY = platformY + (obj.model:GetAttribute("on_platform_y") or 0)
		end
	end

	if (unrest) then
		cx, cz, cr = nx, nz, nr
		resting = false
		currentPosition = (Vector3.new(ox, oy, oz) + currentXAxis * nx + currentZAxis * nz)

		local rotationCFrame = currentAxis * CFrame.Angles(0, cr * math.pi/2, 0)
		for i, obj in pairs(currentObjects) do
			obj.NewCFrame = rotationCFrame * CFrame.Angles(0, obj.r * math.pi/2, 0) + rotationCFrame * Vector3.new(obj.px, obj.sy/2, obj.pz) + currentPosition + Vector3.new(0, obj.model:GetAttribute("y") * currentPlane.grid, 0)
		end

		obstacleCollision()
	end
end

local function render()
	if (resting) then
		return
	end
	
	local objects_are_on_platforms

	for _, object in pairs(currentObjects) do
		if not objects_are_on_platforms and #object.on_platforms ~= 0 then
			objects_are_on_platforms = true
		end

		local legs = object.model:FindFirstChild("legs")

		if legs and legs:IsA("Model") then
			for _, part in pairs(legs:GetChildren()) do
				if part:IsA("BasePart") then
					local distance = part:GetAttribute("distance")
					local og_rot = part:GetAttribute("og_rotation")

					if not distance then
						distance = (object.model.PrimaryPart.Position - part.Position) * Vector3.new(1, 0, 1)

						part:SetAttribute("distance", distance)
					end
				end
			end
		end
	end

	local extra_angle = CFrame.Angles(0, 0, 0)

	if objects_are_on_platforms then
		extra_angle = CFrame.Angles(0, math.rad(90), 0)
	end

	local object = currentObjects[1]

	if (INTERPOLATION) and (not object.model:GetAttribute("NoAnimation")) then
		local delta = 1/60

		springVelocity = (springVelocity + (currentPosition - springPosition)) * INTERPOLATION_DAMP * 60 * delta
		springPosition += springVelocity

		local extentsX, extentsZ = translate(currentExtentsX, currentExtentsZ, cr)

		local vx, vz = 9 * springVelocity:Dot(currentXAxis)/abs(extentsX), 9 * springVelocity:Dot(currentZAxis)/abs(extentsZ)
		local r

		if (not floatEqual(tweenGoalRotation, cr * math.pi/2)) then
			tweenStartRotation = tweenCurrentRotation
			tweenGoalRotation = cr * math.pi/2
			tweenAlpha = 0
		end

		if (tweenAlpha < 1) then
			tweenAlpha = min(1, tweenAlpha + delta/ROTATION_SPEED)
			tweenCurrentRotation = angleLerp(tweenStartRotation, tweenGoalRotation, 1 - (1 - tweenAlpha)^2)
			r = tweenCurrentRotation
		else
			r = cr * math.pi/2
		end


		local effectAngle = WOBBLE_ITEMS and CFrame.Angles(math.sqrt(abs(vz/100)) * math.sign(vz), 0, math.sqrt(abs(vx/100)) * math.sign(vx)) or CFrame.Angles(0, 0, 0)

		local rotationCFrame = currentAxis * effectAngle * CFrame.Angles(0, r, 0)
		local centerCFrame = rotationCFrame + springPosition

		local objMagStopped = true
		
		for i = 1, #currentObjects do
			local object = currentObjects[i]

			setObjectY(object)

			local y = object.model:GetAttribute("y") * currentPlane.grid

			object.yVelocity = (object.yVelocity + (y - object.yPosition)) * INTERPOLATION_DAMP * 60 * delta
			object.yPosition += object.yVelocity

			if objMagStopped and Vector3.new(0, object.yVelocity, 0).magnitude >= .01 then
				objMagStopped = nil
			end

			local x, z = object.px, object.pz		

			object.model:PivotTo(centerCFrame * CFrame.Angles(0, object.r * math.pi/2, 0) + rotationCFrame * Vector3.new(x, object.sy/2, z) + Vector3.new(0, object.yPosition, 0))
			
			local legs = object.model:FindFirstChild("legs")
			
			if legs and legs:IsA("Model") then
				local pivot = object.model:GetPivot()

				local height = object.model:GetAttribute("height") or 0
				local cframe_with_height = pivot * CFrame.new(0, -object.sy / 2, 0)
				local cframe_without_height = CFrame.new(pivot.X, currentBase.Position.Y + currentBase.Size.Y / 2 + object.platformY * currentPlane.grid, pivot.Z) * (pivot - pivot.Position)

				for _, obj in pairs(legs:GetChildren()) do
					if obj:IsA("BasePart") then
						if obj.Name == "leg" then
							obj.Size = Vector3.new(obj.Size.X, cframe_without_height:ToObjectSpace(cframe_with_height).Position.Y, obj.Size.Z)
						end

						obj.CFrame = cframe_without_height * CFrame.new(0, obj.Size.Y / 2, 0) * CFrame.new(obj:GetAttribute("distance"))
					end
				end
			end
		end		

		if (springVelocity.magnitude < .01 and objMagStopped and tweenAlpha >= 1) then
			resting = true
		end
	else
		local rotationCFrame = currentAxis * CFrame.Angles(0, cr * math.pi/2, 0)

		for i = 1, #currentObjects do
			local object = currentObjects[i]
			local x, z = object.px, object.pz

			setObjectY(object)

			object.model:PivotTo(rotationCFrame * CFrame.Angles(0, object.r * math.pi/2, 0) + rotationCFrame * Vector3.new(x, object.sy/2, z) + currentPosition + Vector3.new(0, object.model:GetAttribute("y") * currentPlane.grid, 0))
			
			local legs = object.model:FindFirstChild("legs")

			if legs and legs:IsA("Model") then
				local pivot = object.model:GetPivot()
				
				local height = object.model:GetAttribute("height") or 0
				local cframe_with_height = pivot * CFrame.new(0, -object.sy / 2, 0)
				local cframe_without_height = CFrame.new(pivot.X, currentBase.Position.Y + currentBase.Size.Y / 2 + object.platformY * currentPlane.grid, pivot.Z) * (pivot - pivot.Position)

				for _, obj in pairs(legs:GetChildren()) do
					if obj:IsA("BasePart") then
						if obj.Name == "leg" then
							obj.Size = Vector3.new(obj.Size.X, cframe_without_height:ToObjectSpace(cframe_with_height).Position.Y, obj.Size.Z)
						end

						obj.CFrame = cframe_without_height * CFrame.new(0, obj.Size.Y / 2, 0) * CFrame.new(obj:GetAttribute("distance"))
					end
				end
			end
		end

		resting = true
	end
end

local function run(display)
	local position, rotation = inputCapture()

	if (position or rotation) then
		calc(position, rotation)
		if (display) then
			render()
		end
	end
end

local function place()
	if (currentPlane and (obstacleCollision()) and (HOLD_TO_PLACE or (tick() - lastPlacement) >= PLACEMENT_COOLDOWN) and not currentPlane.loading) then
		lastPlacement = tick()

		local modelCFrames = {}
		local modelYPositions = {heights = {}, platforms = {}}

		for i = 1, #currentObjects do
			local object = currentObjects[i]
			modelCFrames[i] = currentAxis * CFrame.Angles(0, (object.r + cr) * math.pi/2, 0) +  (currentAxis * CFrame.Angles(0, cr * math.pi/2, 0)) * Vector3.new(object.px, object.sy/2, object.pz) + currentPosition
			modelYPositions.heights[i] = object.model:GetAttribute("height") or 0
			modelYPositions.platforms[i] = object.platformY or 0
		end

		currentEvent:Fire(modelCFrames, modelYPositions)		
	end
end

local function rotate()
	calc(nil, (cr + 1) % 4)
	render()
end

local function heights(x)
	local change = true

	for i, obj in pairs(currentObjects) do
		local model = obj.model

		local oldHeight = model:GetAttribute("height")		
		local height = oldHeight or x
		
		local min = model:GetAttribute("minHeight") or oldHeight or 0
		local max = model:GetAttribute("maxHeight") or oldHeight or 0
		
		height = math.clamp(height + x, min, max)
		
		if oldHeight ~= height then
			obj.newHeight = height

			resting = false
		else
			change = nil
		end
	end

	if change then
		for _, obj in pairs(currentObjects) do
			local model = obj.model

			model:SetAttribute("height", obj.newHeight)

			obj.newHeight = nil
		end
	end
end

local function inputRotate(_, userInputState, inputObject)
	if (currentPlane and userInputState == Enum.UserInputState.End) then
		rotate()
	end
end

local function inputPlace(_, userInputState, inputObject)
	if (currentPlane) then
		--place()
		
		if currentObjects[1].model:GetAttribute("SupportQuickPlacing") and currentPlane then
			local wasPlacing = placing
			
			placing = userInputState == Enum.UserInputState.Begin or nil
			
			if placing and not wasPlacing then
				local lastPlacement
				
				repeat
					local now = tick()
					
					if not lastPlacement or now >= lastPlacement + PLACEMENT_COOLDOWN then
						lastPlacement = now

						if not currentPlane then placing = nil break end
						
						place()
					end
					
					runService.Heartbeat:Wait()
				until not placing
			end
		elseif userInputState == Enum.UserInputState.End then
			place()
		end
	end
end

local function findInput(input, tableOfInputs)
	return table.find(tableOfInputs, input.KeyCode) or table.find(tableOfInputs, input.UserInputType)
end

local function inputHeights(_, userInputState, inputObject)
	if (currentPlane and userInputState == Enum.UserInputState.End) then
		heights((findInput(inputObject, HYDRAULIC_UP_KEYBINDS)) and 1 or -1)
	end
end

local function inputCancel(_, userInputState, inputObject)
	if (currentPlane and userInputState == Enum.UserInputState.End) then
		currentPlane:disable()
	end
end

local function bindInputs()
	if (not currentInput and not OVERRIDE_CONTROLS) then
		currentInput = {}
		
		table.insert(currentInput, userInputService.InputBegan:Connect(function(input, gp)
			if not gp or findInput(input, coreInputs) then
				local state = Enum.UserInputState.Begin
				
				if findInput(input, PLACE_KEYBINDS) then
					inputPlace(nil, state, input)
				elseif findInput(input, ROTATE_KEYBINDS) then
					inputRotate(nil, state, input)
				elseif findInput(input, HYDRAULIC_UP_KEYBINDS) or findInput(input, HYDRAULIC_DOWN_KEYBINDS) then
					inputHeights(nil, state, input)
				elseif findInput(input, CANCEL_KEYBINDS) then
					inputCancel(nil, state, input)
				end
			end
		end))
		
		table.insert(currentInput, userInputService.InputEnded:Connect(function(input, gp)
			if not gp or findInput(input, coreInputs) then
				local state = Enum.UserInputState.End

				if findInput(input, PLACE_KEYBINDS) then
					inputPlace(nil, state, input)
				elseif findInput(input, ROTATE_KEYBINDS) then
					inputRotate(nil, state, input)
				elseif findInput(input, HYDRAULIC_UP_KEYBINDS) or findInput(input, HYDRAULIC_DOWN_KEYBINDS) then
					inputHeights(nil, state, input)
				elseif findInput(input, CANCEL_KEYBINDS) then
					inputCancel(nil, state, input)
				end
			end
		end))
	end
end

local function unbindInputs()
	if (currentInput and not OVERRIDE_CONTROLS) then
		for _, obj in pairs(currentInput) do
			obj:Disconnect()
		end
		
		currentInput = nil
	end
end

local function enablePlacement(plane, models, previewObject, prealigned)
	if (plane == currentPlane) then
		return
	elseif (currentPlane) then
		currentPlane:disable()
	end

	if (type(models) ~= "table") then
		models = {models}
	end

	lastRenderCycle = tick()

	currentPlane = plane
	currentBase = plane.base
	currentPlatforms = {}
	currentTextures = {}

	for _, obj in pairs(currentPlane.obstacles:GetChildren()) do
		if obj:IsA("Model") and obj.PrimaryPart then
			--if not game.CollectionService:HasTag(obj, IGNORE_TAG) then createSelectionBox(obj, true) end
			
			if obj:FindFirstChild("platform") and obj.platform:IsA("BasePart") then
				table.insert(currentPlatforms, obj.platform)
				
				if (TEXTURE_ON_PLATFORMS) then
					--createTexture(obj.platform)
				end
			end
		end
	end

	obstacleAdded = currentPlane.obstacles.ChildAdded:Connect(function(obj)
		runService.Heartbeat:Wait()

		if obj:IsA("Model") and obj.PrimaryPart then
			--if not game.CollectionService:HasTag(obj, IGNORE_TAG) then createSelectionBox(obj, true) end
			
			if obj:FindFirstChild("platform") and obj.platform:IsA("BasePart") then
				table.insert(currentPlatforms, obj.platform)
				
				if (TEXTURE_ON_PLATFORMS) then
					--createTexture(obj.platform)
				end
			end
		end
	end)

	obstacleRemoved = currentPlane.obstacles.ChildRemoved:Connect(function(obj)
		if obj:IsA("Model") and obj.PrimaryPart then
			if obj:FindFirstChild("platform") and obj.platform:IsA("BasePart") then
				table.remove(currentPlatforms, table.find(obj.platform))
			end
		end
	end)

	local planePosition = currentBase.CFrame * Vector3.new(0, currentBase.Size.Y/2, 0)

	resting = false
	ox, oy, oz = planePosition.X, planePosition.Y, planePosition.Z
	currentXAxis = currentBase.CFrame.rightVector
	currentYAxis = currentBase.CFrame.upVector
	currentZAxis = currentBase.CFrame.lookVector
	currentAxis = CFrame.new(0, 0, 0, currentXAxis.X, currentYAxis.X, -currentZAxis.X, currentXAxis.Y, currentYAxis.Y, -currentZAxis.Y, currentXAxis.Z, currentYAxis.Z, -currentZAxis.Z)
	currentObjects = {}
	dxx, dxy, dxz = currentXAxis.X, currentXAxis.Y, currentXAxis.Z
	dzx, dzy, dzz = currentZAxis.X, currentZAxis.Y, currentZAxis.Z
	cx, cy, cz, cr = 0, 0, 0, 0

	springVelocity = Vector3.new(0, 0, 0)
	springPosition = Vector3.new(0, 0, 0)

	tweenAlpha = 0
	tweenCurrentRotation = 0
	tweenGoalRotation = 0
	tweenStartRotation = 0

	local position, _ = inputCapture()

	if (not position) then
		position = planePosition
	end

	springPosition = position

	do
		local extentsXMin, extentsXMax = 10e10, -10e10
		local extentsZMin, extentsZMax = 10e10, -10e10
		
		local placing_platforms = {}
		
		for _, model in pairs(models) do
			if model:FindFirstChild("platform") and model.platform:IsA("BasePart") then
				table.insert(placing_platforms, model)
			end
		end
		
		for i = 1, #models do
			local model = models[i]
			local object = {}
			object.model = model
			object.yVelocity = 0
			object.yPosition = 0
			object.platformY = 0
			object.on_platforms = {}

			if not model:GetAttribute("y") then
				setObjectY(object)
			end

			local lookVector = object.model.PrimaryPart.CFrame.lookVector
			local theta
			local px, pz
			
			local legs = object.model:FindFirstChild("legs")

			if legs and legs:IsA("Model") then
				local height = object.model:GetAttribute("height") or 0
				local cframe_with_height = object.model:GetPivot() * CFrame.new(0, -model.PrimaryPart.Size.Y / 2, 0)
				local cframe_without_height = cframe_with_height * CFrame.new(0, -height * currentPlane.grid, 0)

				for _, obj in pairs(legs:GetChildren()) do
					if obj:IsA("BasePart") then
						--local distance = (cframe_with_height * CFrame.new(-(obj.CFrame * CFrame.new(0, obj.Size.Y / 2, 0)).Position)).Position
						local distance = cframe_with_height:ToObjectSpace(obj.CFrame * CFrame.new(0, obj.Size.Y / 2, 0)).Position * Vector3.new(1, 0, 1) --(cframe_with_height * CFrame.new(-obj.Position - Vector3.new(0, obj.Size.Y / 2, 0))).Position
						
						obj:SetAttribute("distance", distance)

						obj.CFrame = cframe_without_height * CFrame.new(0, obj.Size.Y / 2, 0)-- * (obj.CFrame - obj.CFrame.Position)
					end
				end
			end

			if (prealigned) then
				local position = object.model.PrimaryPart.CFrame * Vector3.new(0, -object.model.PrimaryPart.Size.Y/2 , 0)		
				px, pz = project(position.X, position.Y, position.Z)

				theta = math.acos(math.clamp(lookVector:Dot(currentZAxis), -1, 1))
				local cross = lookVector:Cross(currentZAxis)

				if (cross:Dot(currentYAxis) > 0) then
					theta = -theta
				end
				
				local height = object.model:GetAttribute("height") or 0
				
				local y_platform_pos = position.Y - height * currentPlane.grid
				
				local points = {}
				
				local x0, z0 = position.X, position.Z
				local extentsX0, extentsZ0 = calculateExtents(object.model.PrimaryPart)
				
				for x = x0 - extentsX0 / 2, x0 + extentsX0 / 2, currentPlane.grid / 2 do
					for z = z0 - extentsZ0 / 2, z0 + extentsZ0 / 2, currentPlane.grid / 2 do
						table.insert(points, Vector3.new(x, 0, z))
					end
				end
				
				for _, platform in pairs(placing_platforms) do
					if platform == model then
						continue
					end
					
					local is_inside
					
					local platform_pos = platform.platform.Position.Y + platform.platform.Size.Y / 2
					
					if math.abs(y_platform_pos - platform_pos) <= 0.1 then
						local x2, z2 = position.X, position.Z
						local extentsX2, extentsZ2 = calculateExtents(object.model.PrimaryPart)
						
						for _, point in pairs(points) do
							if floatLesser(point.X - currentPlane.grid / 2, x2 + extentsX2 / 2) and floatGreater(point.X + currentPlane.grid / 2, x2 - extentsX2 / 2) and floatLesser(point.Z - currentPlane.grid / 2, z2 + extentsZ2 / 2) and floatGreater(point.Z + currentPlane.grid / 2, z2 - extentsZ2 / 2) then
								is_inside = true
								
								continue
							end
						end
					end
					
					object.platformY = (y_platform_pos - currentBase.Position.Y + currentBase.Size.Y / 2 - (platform:GetAttribute("height") or 0) * currentPlane.grid - platform.platform.Size.Y) / currentPlane.grid
					
					if is_inside then
						table.insert(object.on_platforms, platform)
					end
				end
			else
				px, pz = object.model.PrimaryPart.Position.X, object.model.PrimaryPart.Position.Z
				theta = math.atan2(lookVector.X, lookVector.Z)		
			end

			local x, z = model.PrimaryPart.Size.X, model.PrimaryPart.Size.Z

			object.r = round((theta % (2 * math.pi))/(math.pi/2), 1)

			if (object.r == 1 or object.r == 3) then
				x, z = z, x
			end

			local x1, x2 = px + x/2, px - x/2
			local z1, z2 = pz + z/2, pz - z/2	

			if (x2 < extentsXMin) then
				extentsXMin = x2
			end
			if (x1 > extentsXMax) then
				extentsXMax = x1
			end

			if (z2 < extentsZMin) then
				extentsZMin = z2
			end
			if (z1 > extentsZMax) then
				extentsZMax = z1
			end


			--model.PrimaryPart.Transparency = .5
			--model.PrimaryPart.Material = Enum.Material.SmoothPlastic
			
			for _, obj in pairs(model:GetDescendants()) do
				if obj:IsA("BasePart") then
					obj.Anchored = true
					obj.CanCollide = false
					obj.CastShadow = false
				end
			end
			
			createSelectionBox(model)
			
			setState(object, plane.loading and states.loading or states.neutral)
			
			model.Parent = previewObject
			
			currentObjects[i] = object
		end

		currentExtentsX, currentExtentsZ = round(extentsXMax - extentsXMin, currentPlane.grid), round(extentsZMax - extentsZMin, currentPlane.grid)

		for i = 1, #currentObjects do
			local object = currentObjects[i]
			local px, pz

			if (prealigned) then
				local position = object.model.PrimaryPart.CFrame * Vector3.new(0, -object.model.PrimaryPart.Size.Y/2, 0)		
				px, pz = project(position.X, position.Y, position.Z)
			else
				px, pz = object.model.PrimaryPart.Position.X, object.model.PrimaryPart.Position.Z
			end

			object.px = px - (extentsXMin + extentsXMax)/2
			object.pz = (pz - (extentsZMin + extentsZMax)/2) * (prealigned and -1 or 1)

			object.sx, object.sy, object.sz = object.model.PrimaryPart.Size.X, object.model.PrimaryPart.Size.Y, object.model.PrimaryPart.Size.Z

			local height = object.model:GetAttribute("height") or 0
			
			local min = object.model:GetAttribute("minHeight") or height
			local max = object.model:GetAttribute("maxHeight") or height
			
			height = math.clamp(height, min, max)
			
			if object.model:GetAttribute("height") ~= height then
				object.model:SetAttribute("height", height)
			end
		end
	end

	renderConnection = runService.Heartbeat:Connect(run)
	module.currentPlane = currentPlane
	module.currentObjects = currentObjects
	currentEvent = Instance.new("BindableEvent")
	
	--createTexture(currentPlane.base)
	
	for _, gui in pairs(CORE_GUI_DISABLE) do
		game.StarterGui:SetCoreGuiEnabled(gui, false)
	end
	
	bindInputs()

	run(true)

	return currentEvent.Event
end

local function disablePlacement(plane)
	if (currentPlane) then
		renderConnection:disconnect()
		renderConnection = nil
		
		for _, model in pairs(currentPlane.obstacles:GetChildren()) do
			if not game.CollectionService:HasTag(model, IGNORE_TAG) then
				for _, obj in pairs(model.PrimaryPart:GetChildren()) do
					if obj:IsA("Highlight") then
						local selectionTween = tweenService:Create(obj, TweenInfo.new(HIT_BOX_FADE_TIME, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {FillTransparency = 1, OutlineTransparency = 1})
						local connection

						connection = selectionTween.Completed:Connect(function()
							connection:Disconnect()

							obj:Destroy()
						end)

						selectionTween:Play()
					end
				end
			end
		end
		
		currentPlane = nil
		currentPlatforms = nil
		currentPlatform = nil
		module.currentPlane = nil
		module.currentObjects = nil
		currentEvent:Destroy()
		currentEvent = nil	
		
		lastPlatforms = nil
		newHit = nil

		obstacleAdded:Disconnect()
		obstacleAdded = nil
		obstacleRemoved:Disconnect()
		obstacleRemoved = nil
		
		for _, texture in pairs(currentTextures) do
			--removeTexture(texture)
		end
		
		currentTextures = nil

		for i = 1, #currentObjects do
			local object = currentObjects[i]
			object.model:Destroy()
			object.model = nil
			currentObjects[i] = nil
		end

		unbindInputs()

		for _, gui in pairs(CORE_GUI_DISABLE) do
			game.StarterGui:SetCoreGuiEnabled(gui, true)
		end
	end
end

local function setLoading(plane, isLoading)
	if (plane.loading == isLoading) then
		return
	end

	plane.loading = isLoading

	if (plane == currentPlane) then
		if (isLoading) then
			for i = 1, #currentObjects do
				setState(currentObjects[i], states.loading)
			end
		else
			for i = 1, #currentObjects do
				setState(currentObjects[i], states.neutral, true)
			end

			obstacleCollision()
		end
	end
end

module.new = function(base, obstacles, grid)
	local plane = {}
	plane.base = base
	plane.obstacles = obstacles
	plane.position = base.Position
	plane.size = base.Size

	if (math.floor(.5 + plane.size.X/grid) % 2 == 0) then
		plane.offsetX = -grid/2
	else
		plane.offsetX = 0
	end

	if (math.floor(.5 + plane.size.Z/grid) % 2 == 0) then
		plane.offsetZ = -grid/2
	else
		plane.offsetZ = 0
	end


	plane.stateEvent = Instance.new("BindableEvent")
	plane.stateChanged = plane.stateEvent.Event

	plane.grid = grid
	plane.enable = enablePlacement
	plane.disable = disablePlacement
	plane.rotate = rotate
	plane.place = place
	plane.setLoading = setLoading

	return plane
end

module.setLoading = setLoading
module.currentPlane = false
module.currentObjects = false

return module