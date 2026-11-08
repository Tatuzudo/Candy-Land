local mod = mod_loader.mods[modApi.currentMod]
local path = mod.resourcePath

------ Maps ------
for i = 0, 9 do
	modApi:addMap(path .."maps/candy_picnic".. i ..".map")
end

------ Mission ------
local objText = "Do not kill Vek on the picnic blanket"
local objTextStain = "Do not kill another Vek on the picnic blanket"
-- local objTextTear = "Do not kill Vek in the picnic blanket"
Mission_Candy_Picnic = Mission_Infinite:new{
	Name = "Picnic Time",
	Objectives = Objective(objText,2),
	Stains = 0,
	Tears = 0,
	MapTags = {"picnic"},
	UseBonus = false,
}

function Mission_Candy_Picnic:StartMission()
	local zone = extract_table(Board:GetZone("picnic"))
	local p1 = zone[math.random(#zone)]
	local p2 = p1 + Point(1,0)
	local p3 = p1 + Point(0,1)
	local p4 = p1 + Point(1,1)
	local points = {p1,p2,p3,p4}
	for _,p in ipairs(points) do
		Board:SetTerrain(p,TERRAIN_ROAD)
		Board:SetCustomTile(p,'ground_picnic.png')
		Board:BlockSpawn(p,BLOCKED_PERM)
		-- if p.x > 3 then
			-- Board:BlockSpawn(p,BLOCKED_PERM)
		-- end
	end
end

function Mission_Candy_Picnic:UpdateObjectives()
	if self.Stains == 0 then
		Game:AddObjective(objText, OBJ_STANDARD, REWARD_REP, 2)
	elseif self.Stains == 1 then
		Game:AddObjective(objTextStain, OBJ_STANDARD, REWARD_REP, 2, 1)
	else
		Game:AddObjective(objText, OBJ_FAILED, REWARD_REP, 2)
	end
end

function Mission_Candy_Picnic:GetCompletedObjectives()
	if self.Stains == 0 then
		return Objective(objText, 2, 2)
	elseif self.Stains == 1 then
		return Objective(objText, 1, 2)
	else
		return Objective(objText, 0, 2)
	end
end

function Mission_Candy_Picnic:GetCompletedStatus()
	if self.Stains >= 2 then
		if self.Stains > self.Tears then
			return "Failure_Stain"
		end
	elseif self.Stains == 1 then
		return "Stain"
	elseif self.Tears >= 1 then
		return "Tear"
	else
		return "Success"
	end
end

----- Hooks -----
local HOOK_pawnKilled = function(mission, pawn)
	if mission and mission.ID == "Mission_Candy_Picnic" then
		if pawn:GetTeam() == TEAM_ENEMY and not _G[pawn:GetType()].Minor then
			modApi:scheduleHook(1000, function()
				local p = pawn:GetSpace()
				if Board:GetCustomTile(p) == "ground_picnic.png" then
					if mission.Stains == 0 then
						PrepareVoiceEvent("Mission_Candy_PicnicStain", -1)
					end
					mission.Stains = mission.Stains + 1
					Board:SetCustomTile(p, "ground_picnic_stained.png")
				end
			end)
		end
	end
end

local blanketTitle = "Picnic Blanket Tile"
local blanketText = "Do not stain the blanket with Vek blood. Minor enemies won't stain it."
local stainedTitle = "Stained Blanket Tile"
local stainedText = "This part of the blanket is stained, as is your reputation. If only you could hide it."
local groundTitle = ""
local groundText = ""

local HOOK_tileHighlighted = function(mission, point)
	local mission = GetCurrentMission()
	if mission and mission.ID == "Mission_Candy_Picnic" then
		modApi:runLater(function() -- run it later to prevent other mods from overriding this
			-- save old text
			groundTitle = modApi.modLoaderDictionary["Tile_ground_Title"]
			groundText = modApi.modLoaderDictionary["Tile_ground_Text"]
			-- change text
			if Board:GetCustomTile(point) == "ground_picnic.png" then
				modApi.modLoaderDictionary["Tile_ground_Title"] = blanketTitle
				modApi.modLoaderDictionary["Tile_ground_Text"] = blanketText
			elseif Board:GetCustomTile(point) == "ground_picnic_stained.png" then
				modApi.modLoaderDictionary["Tile_ground_Title"] = stainedTitle
				modApi.modLoaderDictionary["Tile_ground_Text"] = stainedText
			end
		end)
	end
end

local HOOK_tileUnhighlighted = function(mission, point)
	local mission = GetCurrentMission()
	if mission and mission.ID == "Mission_Candy_Picnic" then
		if Board:GetCustomTile(point) == "ground_picnic.png" or Board:GetCustomTile(point) == "ground_picnic_stained.png" then
			modApi.modLoaderDictionary["Tile_ground_Title"] = groundTitle
			modApi.modLoaderDictionary["Tile_ground_Text"] = groundText		
		end
	end
end

local HOOK_missionEnd = function(mission)
	if mission and mission.ID == "Mission_Candy_Picnic" then
		modApi.modLoaderDictionary["Tile_ground_Title"] = groundTitle
		modApi.modLoaderDictionary["Tile_ground_Text"] = groundText		
	end
end

-- local HOOK_missionStart = function(mission)
	-- if mission and mission.ID == "Mission_Candy_Picnic" then
		-- for x = 0, 7 do
			-- for y = 0, 7 do
				-- if Board:GetCustomTerrain(Point(x,y)) == "ground_picnic.png" then
					-- Board:BlockSpawn(Point(x,y),0)
				-- end
			-- end
		-- end
	-- end
-- end

local function EVENT_onTerrainChanged(point,terrain)
	local mission = GetCurrentMission()
	if mission and mission.ID == "Mission_Candy_Picnic" then
		-- dialog
		LOG(Board:GetCustomTile(point))
		if Board:GetCustomTile(point) == "ground_picnic_stained.png" then
			PrepareVoiceEvent("Mission_Candy_PicnicTear", -1)
		end
		-- effect
		if Board:GetTerrain(point) ~= TERRAIN_ROAD and Board:GetCustomTile(point) == "ground_picnic.png" then
			Board:SetCustomTile(point,"")
			mission.Tears = mission.Tears + 1
		elseif Board:GetTerrain(point) ~= TERRAIN_ROAD and Board:GetCustomTile(point) == "ground_picnic_stained.png" then
			Board:SetCustomTile(point,"")
			mission.Tears = mission.Tears + 1
			mission.Stains = mission.Stains - 1
		end
	end
end

local function EVENT_onModsLoaded()
	modapiext:addPawnKilledHook(HOOK_pawnKilled)
	modapiext:addTileHighlightedHook(HOOK_tileHighlighted)
	modapiext:addTileUnhighlightedHook(HOOK_tileUnhighlighted)
	modApi:addMissionEndHook(HOOK_missionEnd)
	-- modApi:addMissionStartHook(HOOK_missionStart)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)

BoardEvents.onTerrainChanged:subscribe(EVENT_onTerrainChanged)
