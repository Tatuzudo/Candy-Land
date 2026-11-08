local mod = mod_loader.mods[modApi.currentMod]
local path = mod.resourcePath

-- assets
modApi:appendAsset("img/effects/tatu_splash_gum.png", path .."img/effects/splash_gum.png")
ANIMS.tatu_splash_gum = ANIMS.Splash:new{ Image = "effects/tatu_splash_gum.png", NumFrames = 5, }

-- variables --
local gumTitle = "Gum Tile"
local gumText = "Units on this tile have their movement reduced to 1."
local gummedTitle = "On Gum"
local gummedText = "Tile is sticky, reducing the movement of this unit to 1."
local groundTitle = ""
local groundText = ""
local gumChance = 0.1

-- sprites --
modApi:appendAsset("img/combat/icons/icon_tatu_gum.png", path.."img/combat/icons/icon_gum.png")
modApi:appendAsset("img/combat/icons/icon_tatu_gum_glow.png", path.."img/combat/icons/icon_gum_glow.png")

-- set tooltip for our terrain status
local oldGetStatusTooltip = GetStatusTooltip
function GetStatusTooltip(id)
	if id == "tatu_gum" then
		return {
			gummedTitle,
			gummedText
		}
	end
	return oldGetStatusTooltip(id)
end

-- hooks --
local HOOK_MissionUpdate = function(mission)
	-- Set the space description and terrain icon each update	
	for i = 0,7 do
		for j = 0,7 do
			local p = Point(i,j)
			if Board:GetCustomTile(p):find("^tatu_gum") ~= nil then
				if Board:GetTerrain(p) ~= TERRAIN_ROAD or
					Board:IsAcid(p) or
					Board:IsFire(p) or
					Board:IsCracked(p) or
					Board:IsPod(p)
				then
					-- Our custom terrain should be cleared
					Board:SetCustomTile(p,"")
					Board:SetTerrainIcon(p,"")
				else
					-- Don't use Board:MarkSpaceDesc, since environment effects need it
					--Board:MarkSpaceDesc(p, terrainTip)--!!!
					Board:SetTerrainIcon(p,"tatu_gum")
				end
			elseif Board:GetTerrainIcon(p) == "tatu_gum" then
				Board:SetTerrainIcon(p,"")
			end
		end
	end	
end

local HOOK_tileHighlighted = function(mission, point)
	-- save old text
	groundTitle = modApi.modLoaderDictionary["Tile_ground_Title"]
	groundText = modApi.modLoaderDictionary["Tile_ground_Text"]
	-- change text
	modApi:runLater(function() -- run it later to prevent other mods from overriding this
		if Board:GetCustomTile(point):find("^tatu_gum") ~= nil then
			modApi.modLoaderDictionary["Tile_ground_Title"] = gumTitle
			modApi.modLoaderDictionary["Tile_ground_Text"] = gumText
		end
	end)
end

local HOOK_tileUnhighlighted = function(mission, point)
	if Board:GetCustomTile(point):find("^tatu_gum") ~= nil then
		modApi.modLoaderDictionary["Tile_ground_Title"] = groundTitle
		modApi.modLoaderDictionary["Tile_ground_Text"] = groundText		
	end
end

local HOOK_missionEnd = function(mission)
	modApi.modLoaderDictionary["Tile_ground_Title"] = groundTitle
	modApi.modLoaderDictionary["Tile_ground_Text"] = groundText
end

-- add gum tiles to the board
local HOOK_PreMissionAvailable = function(mission)
	if mission and mission.ID ~= "Mission_Final" and mission.ID ~= "Mission_Candy_Final" then
		if modApi:getCurrentTileset() == "tatu_Candy_Tileset" then
			for x = 0, 7 do
				for y = 0, 7 do
					local gumType = math.random(0,2)
					local curr = Point(x,y)
					if Board:IsTerrain(curr,TERRAIN_ROAD) and
						not Board:IsBlocked(curr, PATH_PROJECTILE) and
						not Board:IsCracked(curr) and
						not Board:IsAcid(curr) and
						not Board:IsItem(curr) and
						Board:GetCustomTile(curr) == "" and
						math.random() <= gumChance
					then
						Board:SetCustomTile(curr,"tatu_gum_"..gumType..".png")
					end
				end
			end
		end
	end
end

-- gum movement effect for mechs
local HOOK_targetAreaBuild = function(mission, pawn, weaponId, p1, targetArea)
	if Board:GetCustomTile(p1):find("^tatu_gum") ~= nil and Board:IsTerrain(p1,TERRAIN_ROAD) and weaponId == "Move" then
		while not targetArea:empty() do
		    targetArea:erase(0)
		end
		local path = pawn:GetPathProf()
		for i = DIR_START, DIR_END do
			local curr = DIR_VECTORS[i] + p1
			if Board:IsValid(curr) and not Board:IsBlocked(curr, path) then
				targetArea:push_back(curr)
			end
		end
	end
end

-- gum movement effect for vek
local HOOK_pawnSelected = function(mission, pawn)
	if mission and pawn:GetTeam() == TEAM_ENEMY and Game:GetTeamTurn() == TEAM_PLAYER then
		local p1 = pawn:GetSpace()
		if Board:GetCustomTile(p1):find("^tatu_gum") ~= nil and Board:IsTerrain(p1,TERRAIN_ROAD) then
			if mission.gumVekSpeed then
				mission.gumVekSpeed[pawn:GetId()] = pawn:GetMoveSpeed()
			else
				mission.gumVekSpeed = {}
				mission.gumVekSpeed[pawn:GetId()] = pawn:GetMoveSpeed()
			end
			pawn:SetMoveSpeed(math.min(1,pawn:GetMoveSpeed()))
		else
			if mission.gumVekSpeed and mission.gumVekSpeed[pawn:GetId()] then
				-- pawn:SetMoveSpeed(mission.gumVekSpeed[pawn:GetId()])
				pawn:SetMoveSpeed(_G[pawn:GetType()].MoveSpeed)
			end
		end
	end
end

local HOOK_pawnDeselected = function(mission, pawn)
	if mission and
		Game:GetTeamTurn() == TEAM_PLAYER and
		mission.gumVekSpeed and
		mission.gumVekSpeed[pawn:GetId()] and
		pawn:GetTeam() == TEAM_ENEMY
	then
		-- pawn:SetMoveSpeed(mission.gumVekSpeed[pawn:GetId()])
		pawn:SetMoveSpeed(_G[pawn:GetType()].MoveSpeed)
		mission.gumVekSpeed[pawn:GetId()] = nil
	end
end

local HOOK_nextTurn = function(mission)
	if mission and Game:GetTeamTurn() == TEAM_ENEMY then
		local pawnList = extract_table(Board:GetPawns(TEAM_ENEMY))
		if mission.DNT_Haste1 then
			local makeBusy = SkillEffect()
			makeBusy:AddDelay(1.6)
			Board:AddEffect(makeBusy)
		end
		
		for i = 1, #pawnList do
			local pawn = Board:GetPawn(pawnList[i])
			local p1 = pawn:GetSpace()
			if Board:GetCustomTile(p1):find("^tatu_gum") ~= nil and Board:IsTerrain(p1,TERRAIN_ROAD) then
				if mission.gumVekSpeed then
					if not mission.gumVekSpeed[pawn:GetId()] then
						mission.gumVekSpeed[pawn:GetId()] = pawn:GetMoveSpeed()
					end
				else
					mission.gumVekSpeed = {}
					mission.gumVekSpeed[pawn:GetId()] = pawn:GetMoveSpeed()
				end
				pawn:SetMoveSpeed(math.min(1,pawn:GetMoveSpeed()))
				if mission.DNT_Haste1 and pawn:GetType() ~= 'DNT_Haste1' and not _G[pawn:GetType()].Minor then
					modApi:scheduleHook(50, function()
						pawn:AddMoveBonus(0)
					end)
				end
			elseif mission.gumVekSpeed and mission.gumVekSpeed[pawn:GetId()] then
				-- pawn:SetMoveSpeed(mission.gumVekSpeed[pawn:GetId()])
				pawn:SetMoveSpeed(_G[pawn:GetType()].MoveSpeed)
				mission.gumVekSpeed[pawn:GetId()] = nil
			end
		end
	end
end

local HOOK_pawnTracked = function(mission, pawn)
	if mission then
		local p1 = pawn:GetSpace()
		if pawn:GetTeam() == TEAM_ENEMY then
			if Board:GetCustomTile(p1):find("^tatu_gum") ~= nil and Board:IsTerrain(p1,TERRAIN_ROAD) then
				if mission.gumVekSpeed then
					if not mission.gumVekSpeed[pawn:GetId()] then
						mission.gumVekSpeed[pawn:GetId()] = pawn:GetMoveSpeed()
					end
				else
					mission.gumVekSpeed = {}
					mission.gumVekSpeed[pawn:GetId()] = pawn:GetMoveSpeed()
				end
				pawn:SetMoveSpeed(math.min(1,pawn:GetMoveSpeed()))
				if mission.DNT_Haste1 and pawn:GetType() ~= 'DNT_Haste1' and not _G[pawn:GetType()].Minor then
					modApi:scheduleHook(1550, function()
						pawn:AddMoveBonus(0)
					end)
				end
			end
		end
		-- animation and sound
		if Board:GetCustomTile(p1):find("^tatu_gum") ~= nil and Board:IsTerrain(p1,TERRAIN_ROAD) then
			Game:TriggerSound("/enemy/spider_boss_1/attack_egg_land")
			Game:TriggerSound("/impact/generic/blob")
			Board:AddAnimation(p1,"tatu_splash_gum",1)
		end
	end
end

-- animation and sound
local HOOK_pawnPositionChanged = function(mission, pawn, oldPosition)
	local pos = pawn:GetSpace()
	local timer = false
	local bonus = pos:Manhattan(oldPosition) > 1 and 700 or 0
	modApi:scheduleHook(200 + bonus, function()
		timer = true
	end)
	
	modApi:conditionalHook(
		function()
			return timer or (Board and Board:GetBusyState() == 0)
		end,
		function()
			if Board:GetCustomTile(pos):find("^tatu_gum") ~= nil and pawn:GetSpace() == pos then
				Game:TriggerSound("/enemy/spider_boss_1/attack_egg_land")
				Game:TriggerSound("/impact/generic/blob")
				Board:AddAnimation(pos,"tatu_splash_gum",1)
			end
		end
	)
end

-- restore gum tile on undoMove
local function HOOK_skillStart(mission, pawn, weaponId, p1, p2)
	if mission then
		if weaponId == 'Move' then
			if not mission.gumUndoTable then mission.gumUndoTable = {} end
			mission.gumUndoTable[pawn:GetId()] = Board:GetCustomTile(p2)
		else
			mission.gumUndoTable = {}
		end
	end
end

local function HOOK_pawnUndoMove(mission, pawn, undonePosition)
	if pawn and mission and mission.gumUndoTable then
		local custom = mission.gumUndoTable[pawn:GetId()]
		if custom then
			if (custom:find("^tatu_gum") ~= nil and Board:GetCustomTile(undonePosition):find("^tatu_gum") == nil )
				or (custom:find("^tatu_gum") == nil and Board:GetCustomTile(undonePosition):find("^tatu_gum") ~= nil)
			then
				Board:SetCustomTile(undonePosition, mission.gumUndoTable[pawn:GetId()])
			end
		end
	end
end

local function EVENT_onModsLoaded()
	modapiext:addPawnTrackedHook(HOOK_pawnTracked)
	modapiext:addPawnSelectedHook(HOOK_pawnSelected)
	modapiext:addPawnDeselectedHook(HOOK_pawnDeselected)
	modapiext:addTargetAreaBuildHook(HOOK_targetAreaBuild)
	modapiext:addTileHighlightedHook(HOOK_tileHighlighted)
	modapiext:addTileUnhighlightedHook(HOOK_tileUnhighlighted)
	modapiext:addPawnPositionChangedHook(HOOK_pawnPositionChanged)
	modapiext:addSkillStartHook(HOOK_skillStart)
	modapiext:addPawnUndoMoveHook(HOOK_pawnUndoMove)
	modApi:addMissionUpdateHook(HOOK_MissionUpdate)
	modApi:addMissionEndHook(HOOK_missionEnd)
	modApi:addPreMissionAvailableHook(HOOK_PreMissionAvailable)
	modApi:addTestMechEnteredHook(HOOK_PreMissionAvailable)
	modApi:addNextTurnHook(HOOK_nextTurn)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)
