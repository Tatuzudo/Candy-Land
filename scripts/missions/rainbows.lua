local mod = mod_loader.mods[modApi.currentMod]
local customAnim = mod.libs.customAnim


---------- Sprites -----------
modApi:appendAsset("img/effects/tatu_rainbow1.png", mod.resourcePath .."img/effects/rainbow1.png")
modApi:appendAsset("img/effects/tatu_rainbow1_fade.png", mod.resourcePath .."img/effects/rainbow1_fade.png")
modApi:appendAsset("img/effects/tatu_rainbow1_item.png", mod.resourcePath .."img/effects/rainbow1_item.png")
Location["effects/tatu_rainbow1_item.png"] = Point(-23,-30)
modApi:appendAsset("img/effects/tatu_rainbow2.png", mod.resourcePath .."img/effects/rainbow2.png")
modApi:appendAsset("img/effects/tatu_rainbow2_fade.png", mod.resourcePath .."img/effects/rainbow2_fade.png")
modApi:appendAsset("img/effects/tatu_rainbow2_item.png", mod.resourcePath .."img/effects/rainbow2_item.png")
Location["effects/tatu_rainbow2_item.png"] = Point(-35,-35)


---------- Animations -----------
ANIMS["rainbow1"] = Animation:new{
	Image = "effects/tatu_rainbow1.png",
	PosX = -23, PosY = -30,
	NumFrames = 8,
	Time = 0.25,
	Loop = true,
	Layer = LAYER_FRONT
}

ANIMS["rainbow1_fade"] = Animation:new{
	Image = "effects/tatu_rainbow1_fade.png",
	PosX = -23, PosY = -30,
	NumFrames = 4,
	Time = 0.1,
	Loop = false,
	Layer = LAYER_FRONT
}

ANIMS["rainbow2"] = Animation:new{
	Image = "effects/tatu_rainbow2.png",
	PosX = -35, PosY = -35,
	NumFrames = 8,
	Time = 0.25,
	Loop = true,
	Layer = LAYER_FRONT
}

ANIMS["rainbow2_fade"] = Animation:new{
	Image = "effects/tatu_rainbow2_fade.png",
	PosX = -35, PosY = -35,
	NumFrames = 4,
	Time = 0.1,
	Loop = false,
	Layer = LAYER_FRONT
}

tatu_Rainbow1 = { Image = "effects/tatu_rainbow1_item.png", Damage = SpaceDamage(1), Tooltip = "", Icon = "", UsedImage = ""}
tatu_Rainbow2 = { Image = "effects/tatu_rainbow2_item.png", Damage = SpaceDamage(1), Tooltip = "", Icon = "", UsedImage = ""}

------------ Mission ------------
Mission_Candy_Rainbows = Mission_Infinite:new{ 
	Name = "Rainbows",
	UseBonus = true,
	BonusPool = { BONUS_KILL_FIVE, BONUS_GRID, BONUS_MECHS, BONUS_PACIFIST, BONUS_SELFDAMAGE },
	RainbowList = {},
	RainbowsN = 2,
}

function Mission_Candy_Rainbows:StartMission()
	local places = {}
	for y = 1, 6 do
		local x = math.random(1,2)
		if Board:IsBlocked(Point(x,y), PATH_PROJECTILE) then
			x = 3-x
		end
		local p1 = Point(x,y)
		
		local z = math.random(5,6)
		if Board:IsBlocked(Point(x,y), PATH_PROJECTILE) then
			z = 11-z
		end
		
		local p2 = Point(z,y)
		if not Board:IsBlocked(p1, PATH_PROJECTILE) and not Board:IsBlocked(p2, PATH_PROJECTILE) then
			places[#places+1] = {p1,p2}
		end
	end
	
	-- remove rainbows before adding more, it will put more on the board per mission on the map
	for _,i in ipairs(self.RainbowList) do
		Board:RemoveItem(i[1])
		Board:RemoveItem(i[2])
	end
	self.RainbowList = {}
	
	local RainbowsMax = math.random(1,self.RainbowsN)
	if #places > 0 then
		for n = 1, math.min(#places,RainbowsMax) do
			table.insert(self.RainbowList,table.remove(places, math.random(1, #places)))
		end
		
		for _,i in ipairs(self.RainbowList) do
			Board:SetItem(i[1],'tatu_Rainbow1')
			Board:SetItem(i[2],'tatu_Rainbow2')
		end
	end
end

function Mission_Candy_Rainbows:UpdateMission()
	for _,i in ipairs(self.RainbowList) do
		if not i[3] and i[3] ~= -9.99 then
			Board:MarkSpaceDesc(i[1],'TATU_RAINBOW_TILE')
			Board:MarkSpaceDesc(i[2],'TATU_RAINBOW_TILE')
		end
	end
end


----------- Functions -----------
local addRainbow = function(point,anim)
	Board:AddAnimation(point,anim..'_fade',1)
	modApi:scheduleHook(500, function()
		customAnim:add(point,anim)
	end)
end

local remRainbow = function(point,anim)
	customAnim:rem(point,anim)
	Board:AddAnimation(point,anim..'_fade',-1)
end

----------- Hooks -----------
local HOOK_missionStart = function(mission)
	if mission and mission.ID == "Mission_Candy_Rainbows" then
		for _,i in ipairs(mission.RainbowList) do
			Board:RemoveItem(i[1])
			Board:RemoveItem(i[2])
			remRainbow(i[1],'rainbow1')
			remRainbow(i[2],'rainbow2')
			mission.RainbowList = {}
		end
		
		modApi:scheduleHook(1000, function() -- to update mech drop preview
			Board:GetPawn(0):SetSpace(Point(0,0))
			modApi:runLater(function()
				Board:GetPawn(0):SetSpace(Point(-1,-1))
			end)
		end)
	end
end

local HOOK_nextTurn = function(mission)
	if mission and mission.ID == "Mission_Candy_Rainbows" then
		if Game:GetTeamTurn() == TEAM_PLAYER then
			local places = {}
			
			for y = 1, 6 do
				local x = math.random(1,2)
				if Board:IsBlocked(Point(x,y), PATH_PROJECTILE) then
					x = 3-x
				end
				local p1 = Point(x,y)
				
				local z = math.random(5,6)
				if Board:IsBlocked(Point(x,y), PATH_PROJECTILE) then
					z = 11-z
				end
				
				local p2 = Point(z,y)
				if not Board:IsBlocked(p1, PATH_PROJECTILE) and not Board:IsBlocked(p2, PATH_PROJECTILE) then
					places[#places+1] = {p1,p2}
				end
			end
			
			local RainbowsMax = math.random(1,mission.RainbowsN)
			if #places > 0 then
				for n = 1, math.min(#places,RainbowsMax) do
					table.insert(mission.RainbowList,table.remove(places, math.random(1, #places)))
				end
				
				for _,i in ipairs(mission.RainbowList) do
					addRainbow(i[1],'rainbow1')
					addRainbow(i[2],'rainbow2')
				end
				Game:TriggerSound('/ui/battle/select_unit')
				Game:TriggerSound('/ui/map/gain_core')
				Game:TriggerSound('/ui/battle/preplan_place_support')
			end
		else
			for _,i in ipairs(mission.RainbowList) do
				if not i[3] then
					remRainbow(i[1],'rainbow1')
					remRainbow(i[2],'rainbow2')
				end
			end
			mission.RainbowList = {}
		end
	end
end

local HOOK_pawnPositionChanged = function(mission, pawn, oldPosition)
	if mission and mission.ID == "Mission_Candy_Rainbows" and #mission.RainbowList > 0 then
		local pos = pawn:GetSpace()
		local stats = {
			Pos = pos,
			Acid = Board:IsAcid(pos),
			Fire = Board:IsFire(pos),
			Smoke = Board:IsSmoke(pos),
			Terrain = Board:GetTerrain(pos),
			Custom = Board:GetCustomTile(pos),
			Item = Board:GetItem(pos),
		}
		modApi:scheduleHook(500, function()
			if pawn:GetSpace() == pos and (not pawn:IsDead() or pawn:IsMech() or _G[pawn:GetType()].Corpse) then
				for t,i in ipairs(mission.RainbowList) do
					if not i[3] then
						if pos == i[1] then
							remRainbow(i[1],'rainbow1')
							mission.RainbowList[t][3] = -9.99
							if not pawn:IsGuarding() and
								(not Board:GetPawn(i[2]) or (Board:GetPawn(i[2]) and not Board:GetPawn(i[2]):IsGuarding())) and
								not Board:IsBuilding(i[2]) and
								not Board:IsTerrain(i[2],TERRAIN_MOUNTAIN)
							then
								if pawn:IsMovementSpent() then
									mission.RainbowList[t][3] = pawn:GetId()
									mission.RainbowList[t][4] = stats
								end
								local effect = SkillEffect()
								local move = PointList()
								move:push_back(i[1])
								move:push_back(i[2])
								
								effect:AddSound('/ui/battle/select_unit')
								effect:AddSound('/ui/battle/preplan_place_support')
								effect:AddSound('/weapons/shift')
								effect:AddLeap(move,NO_DELAY)
								if Board:GetPawn(i[2]) then
									remRainbow(i[2],'rainbow2')
									move = PointList()
									move:push_back(i[2])
									move:push_back(i[1])
									
									effect:AddSound('/ui/battle/select_unit')
									effect:AddSound('/ui/battle/preplan_place_support')
									effect:AddSound('/weapons/shift')
									effect:AddLeap(move,NO_DELAY)
								end
								effect:AddDelay(0.8)
								if Board:GetPawn(i[2]) then
									effect:AddScript('Board:GetPawn('..Board:GetPawn(i[2]):GetId()..'):SetBoosted(true)')
								else
									modApi:scheduleHook(1200, function()
										remRainbow(i[2],'rainbow2')
										--bark
										if pawn:IsMech() and math.random() > 0.5 then
											PrepareVoiceEvent("Mission_Candy_RainbowRide", pawn:GetId())
										end
									end)
								end
								effect:AddScript('Board:GetPawn('..pawn:GetId()..'):SetBoosted(true)')
								Board:AddEffect(effect)
							end
						elseif pos == i[2] then
							remRainbow(i[2],'rainbow2')
							mission.RainbowList[t][3] = -9.99
							if not pawn:IsGuarding() and
								(not Board:GetPawn(i[1]) or (Board:GetPawn(i[1]) and not Board:GetPawn(i[1]):IsGuarding())) and
								not Board:IsBuilding(i[1]) and
								not Board:IsTerrain(i[1],TERRAIN_MOUNTAIN)
							then
								if pawn:IsMovementSpent() then
									mission.RainbowList[t][3] = pawn:GetId()
									mission.RainbowList[t][4] = stats
								end
								local effect = SkillEffect()
								local move = PointList()
								move:push_back(i[2])
								move:push_back(i[1])
								
								effect:AddSound('/ui/battle/select_unit')
								effect:AddSound('/ui/battle/preplan_place_support')
								effect:AddSound('/weapons/shift')
								effect:AddLeap(move,NO_DELAY)
								effect:AddDelay(0.8)
								effect:AddScript('Board:GetPawn('..pawn:GetId()..'):SetBoosted(true)')
								Board:AddEffect(effect)
								modApi:scheduleHook(1200, function()
									remRainbow(i[1],'rainbow1')
									-- bark
									if pawn:IsMech() and math.random() > 0.5 then
										PrepareVoiceEvent("Mission_Candy_RainbowRide", pawn:GetId())
									end
								end)
							end
						end
					end
				end
			end
		end)
	end
end

local Hook_pawnUndoMove = function(mission, pawn, undonePosition)
	if mission and mission.ID == "Mission_Candy_Rainbows" and #mission.RainbowList > 0 then
		for t,i in ipairs(mission.RainbowList) do
			if i[3] == pawn:GetId() then
				mission.RainbowList[t][3] = nil
				customAnim:add(i[1],'rainbow1')
				customAnim:add(i[2],'rainbow2')
				if i[4] then
					Board:SetAcid(i[4].Pos,i[4].Acid)
					Board:SetFire(i[4].Pos,i[4].Fire)
					Board:SetSmoke(i[4].Pos,i[4].Smoke,true)
					Board:SetTerrain(i[4].Pos,i[4].Terrain)
					Board:SetCustomTile(i[4].Pos,i[4].Custom)
					Board:SetItem(i[4].Pos,i[4].Item)
				end
				mission.RainbowList[t][4] = nil
			end
		end
	end
end

local HOOK_pawnFocused = function(pawnType)
	local mission = GetCurrentMission()
	if mission and mission.ID == "Mission_Candy_Rainbows" and #mission.RainbowList > 0 then
		for _,i in ipairs(mission.RainbowList) do
			if not i[3] and i[3] ~= -9.99 and not customAnim:get(i[1],'rainbow1') then
				customAnim:add(i[1],'rainbow1')
				customAnim:add(i[2],'rainbow2')
			end
		end
	end
end

local HOOK_postLoadGame = function() -- readd rainbows on reset/continue
	modApi:scheduleHook(300, function()
		local mission = GetCurrentMission()
		if mission and mission.ID == "Mission_Candy_Rainbows" and #mission.RainbowList > 0 then
			for _,i in ipairs(mission.RainbowList) do
				if not i[3] and i[3] ~= -9.99 and not customAnim:get(i[1],'rainbow1') then
					customAnim:add(i[1],'rainbow1')
					customAnim:add(i[2],'rainbow2')
				end
			end
		end
	end)
end

local HOOK_skillStartHook = function(mission, pawn, weaponId, p1, p2)
	if mission and mission.ID == "Mission_Candy_Rainbows" and #mission.RainbowList > 0 then
		if weaponId ~= "Move" then
			for _,i in ipairs(mission.RainbowList) do
				if i[3] and i[3] ~= -9.99 then
					i[3] = -9.99
				end
			end
		end
	end
end

local function EVENT_onModsLoaded()
	modApi:addNextTurnHook(HOOK_nextTurn)
	modApi:addPawnFocusedHook(HOOK_pawnFocused)
	modApi:addMissionStartHook(HOOK_missionStart)
	modApi:addPostLoadGameHook(HOOK_postLoadGame)
	modapiext:addPawnPositionChangedHook(HOOK_pawnPositionChanged)
	modapiext:addPawnTrackedHook(HOOK_pawnPositionChanged)
	modapiext:addPawnUndoMoveHook(Hook_pawnUndoMove)
	modapiext:addSkillStartHook(HOOK_skillStartHook)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)