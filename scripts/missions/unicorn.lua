local mod = mod_loader.mods[modApi.currentMod]
local path = mod.resourcePath

-- sprites --
modApi:appendAsset("img/portraits/enemy/tatu_CandyUnicorn.png",path.."img/portraits/enemy/unicorn.png")
modApi:appendAsset("img/portraits/enemy/tatu_CandyUnicornHurt.png",path.."img/portraits/enemy/unicorn_hurt.png")

modApi:appendAsset("img/units/mission/tatu_unicorn.png", path .."img/units/mission/unicorn.png")
modApi:appendAsset("img/units/mission/tatu_unicorn_a.png", path .."img/units/mission/unicorn_a.png")
modApi:appendAsset("img/units/mission/tatu_unicorn_d.png", path .."img/units/mission/unicorn_d.png")

modApi:appendAsset("img/units/mission/tatu_unicorn_hurt.png", path .."img/units/mission/unicorn_hurt.png")
modApi:appendAsset("img/units/mission/tatu_unicorn_hurt_a.png", path .."img/units/mission/unicorn_hurt_a.png")

local a = ANIMS
a.tatu_unicorn = a.BaseUnit:new{Image = "units/mission/tatu_unicorn.png", PosX = -18, PosY = -7}
a.tatu_unicorna = a.tatu_unicorn:new{Image = "units/mission/tatu_unicorn_a.png", NumFrames = 6 }
a.tatu_unicornd = a.tatu_unicorn:new{Image = "units/mission/tatu_unicorn_hurt.png", PosX = -18, PosY = -7, NumFrames = 1, Loop = false, Time = 1.6}

a.tatu_unicornHurt = a.BaseUnit:new{Image = "units/mission/tatu_unicorn_hurt.png", PosX = -18, PosY = -7}
a.tatu_unicornHurta = a.tatu_unicornHurt:new{Image = "units/mission/tatu_unicorn_hurt_a.png", NumFrames = 4, Time = 0.72 }
a.tatu_unicornHurtd = a.tatu_unicornHurt:new{Image = "units/mission/tatu_unicorn_d.png", PosX = -18, PosY = -7, NumFrames = 6, Loop = false, Time = 0.33}

-- mission --

local objText = "Knockout then protect the unicorn"
local objTextPartial = "Protect the appeased unicorn"
Mission_Candy_Unicorn = Mission_Infinite:new{
	Name = "Unicorn Hunt",
	Objectives = Objective(objText,1,1),
	UseBonus = true,
	UnicornStatus = "free",
}

function Mission_Candy_Unicorn:StartMission()
	local choices = {}
	for x = 0, 7 do
		for y = 0, 7 do
			local p = Point(x,y)
			if Board:IsTerrain(p,TERRAIN_ROAD) then
				choices[#choices+1] = p
			end
		end
	end
	local pawn = PAWN_FACTORY:CreatePawn("tatu_CandyUnicorn")
	Board:AddPawn(pawn,random_removal(choices))
	-- pawn:SetTeam(TEAM_PLAYER)
end

function Mission_Candy_Unicorn:UpdateObjectives()
	if self.UnicornStatus == "hurt" then
		Game:AddObjective(objTextPartial, OBJ_STANDARD, REWARD_REP, 1, 0)
	elseif self.UnicornStatus == "free" then
		Game:AddObjective(objText, OBJ_STANDARD, REWARD_REP, 1, 0)
	elseif self.UnicornStatus == "dead" then
		Game:AddObjective(objText, OBJ_FAILED, REWARD_REP, 1)
	end
end

function Mission_Candy_Unicorn:GetCompletedObjectives()
	if self.UnicornStatus == "hurt" then
		return self.Objectives
	elseif self.UnicornStatus == "free" then
		return Objective(objText.." (The unicorn escaped)",0,1)
	elseif self.UnicornStatus == "dead" then
		return Objective(objText.." (The unicorn is dead)",0,1)
	end
end

function Mission_Candy_Unicorn:GetCompletedStatus()
	if self.UnicornStatus == "hurt" then
		return "Success"
	elseif self.UnicornStatus == "free" then
		return "Escaped"
	elseif self.UnicornStatus == "dead" then
		return "Dead"
	end
end

-- unicorn --

tatu_CandyUnicorn = {
	Name = "Candy Unicorn",
	Health = 1,
	MoveSpeed = 4,
	-- Jumper = true,
	Neutral = true,
	Minor = true,
	DefaultFaction = FACTION_BOTS,
	-- Corporate = true,
	DefaultTeam = TEAM_ENEMY,
	Image = "tatu_unicorn",
	SkillList = { "tatu_UnicornAtk" },
	SoundLocation = "/enemy/moth_1/",
	ImpactMaterial = IMPACT_FLESH,
	IsDeathEffect = true,
	-- IsPortrait = false,
}
AddPawn("tatu_CandyUnicorn") 

tatu_CandyUnicornHurt = {
	Name = "Appeased Unicorn",
	Health = 1,
	MoveSpeed = 0,
	Neutral = true,
	-- Minor = true,
	-- Corporate = true,
	DefaultTeam = TEAM_ENEMY,
	Image = "tatu_unicornHurt",
	SkillList = { },
	SoundLocation = "/enemy/dung_1/",
	ImpactMaterial = IMPACT_FLESH,
	IsDeathEffect = true,
	-- IsPortrait = false,
}
AddPawn("tatu_CandyUnicornHurt") 

tatu_UnicornAtk = Skill:new{
	Name = "Majestic Leap",
	Description = "Leap to the target tile.",
	Class = "Enemy",
	Icon = "weapons/enemy_scarab1.png",
	LaunchSound = "",
	-- SoundBase = "/enemy/leaper_1",
	-- ImpSound = "/impact/generic/general",
	Range = 4,
	TipImage = {
		Unit = Point(2,0),
		Target = Point(2,3),
		Friend = Point(2,1),
		Second_Origin = Point(2,3),
		Second_Target = Point(2,1),
		CustomPawn = "tatu_CandyUnicorn",
	}
}

function tatu_UnicornAtk:GetTargetArea(point)
	local ret = PointList()
	for i = DIR_START, DIR_END do
		for k = 2, self.Range do
			local curr = DIR_VECTORS[i]*k + point
			if Board:IsValid(curr) then
				ret:push_back(curr)
			end
		end
	end
	return ret
end

function tatu_UnicornAtk:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	ret:AddScript("Board:GetPawn("..p1:GetString().."):SetTeam(TEAM_PLAYER)")
	ret:AddQueuedScript("Board:GetPawn("..p1:GetString().."):SetTeam(TEAM_ENEMY)")
	
	if not Board:IsBlocked(p2, PATH_PROJECTILE) then
		local plist = PointList()
		plist:push_back(p1)
		plist:push_back(p2)
		
		ret:AddQueuedScript(string.format([[
			local effect = SkillEffect()
			local plist = PointList()
			plist:push_back(%s)
			plist:push_back(%s)
			effect:AddLeap(plist, NO_DELAY)
			effect:AddSound("enemy/bouncer_1/attack")
			effect:AddDelay(0.8)
			effect:AddSound("/enemy/leaper_1/land")
			Board:AddEffect(effect)
		]], p1:GetString(), p2:GetString()))
		ret:AddQueuedArtillery(SpaceDamage(p2),"",NO_DELAY)
		ret:AddQueuedDelay(0.9)
		ret:AddQueuedMove(plist, NO_DELAY)
	else
		local block_image = SpaceDamage(p2,0)
		block_image.sImageMark = "advanced/combat/icons/icon_throwblocked_glow.png"
		ret:AddQueuedArtillery(block_image,"",NO_DELAY)
		-- ret.q_effect:back().bHidePath = true
		ret:AddQueuedScript("Board:AddAlert(".. p1:GetString() ..", 'LEAP BLOCKED')")
	end
	
	return ret
end

function tatu_UnicornAtk:GetTargetScore(p1, p2)
	local ret = 0
	
	if Board:IsTerrain(p2,TERRAIN_ROAD) and
		not Board:IsBlocked(p2, PATH_GROUND) and
		not Board:IsFire(p2) and
		not Board:IsAcid(p2) and
		not Board:IsItem(p2) and
		not Board:IsDangerous(p2)
	then
		ret = 100
	end
	
    return ret
end

function tatu_CandyUnicorn:GetDeathEffect(point)
	local ret = SkillEffect()
	
	-- ret:AddSound("enemy/dung_1/death")
	if Board:IsTerrain(point,TERRAIN_WATER) or Board:IsTerrain(point,TERRAIN_HOLE) then
		ret:AddScript("GetCurrentMission().UnicornStatus = 'dead'")
	else
		local hurt = SpaceDamage(point)
		hurt.sPawn = "tatu_CandyUnicornHurt"
		ret:AddDamage(hurt)
		ret:AddScript("GetCurrentMission().UnicornStatus = 'hurt'")
		ret:AddDelay(2)
		ret:AddScript("Board:GetPawn("..point:GetString().."):SetTeam(TEAM_PLAYER)")
	end
	
	return ret
end

function tatu_CandyUnicornHurt:GetDeathEffect(point)
	local ret = SkillEffect()
	ret:AddScript("GetCurrentMission().UnicornStatus = 'dead'")
	return ret
end

local HOOK_nextTurn = function(mission)
	if mission and mission.ID == "Mission_Candy_Unicorn" then
		local pawnList = extract_table(Board:GetPawns(TEAM_ANY))
		for i = 1, #pawnList do
			local p = Board:GetPawn(pawnList[i])
			if p:GetType() == "tatu_CandyUnicorn" then
				p:SetTeam(TEAM_ENEMY)
			end
		end
	end
end

local HOOK_missionEnd = function(mission)
	if mission and mission.ID == "Mission_Candy_Unicorn" then
		if Board:GetTurn() == 0 and GetTeamTurn() == TEAM_PLAYER then
			PrepareVoiceEvent("Mission_Candy_NotUnicorn")
		end
		local pawnList = extract_table(Board:GetPawns(TEAM_ANY))
		for i = 1, #pawnList do
			local p = Board:GetPawn(pawnList[i])
			if p:GetType() == "tatu_CandyUnicorn" then
				p:SetTeam(TEAM_PLAYER)
				p:SetFrozen(false)
				modApi:scheduleHook(2500, function()
					p:FlyAway()
				end)
			end
		end
	end
end

-- fix portrait on load
local HOOK_postLoadGameHook = function(mission)
	modApi:conditionalHook(
		function()
			return GetCurrentMission()
		end,
		function()
			local pawnList = extract_table(Board:GetPawns(TEAM_PLAYER))
			for i = 1, #pawnList do
				local currPawn = Board:GetPawn(pawnList[i])
				local currType = currPawn:GetType()
				if currType:find("^tatu_CandyUnicornHurt") ~= nil then
					local pos = currPawn:GetSpace()
					Board:RemovePawn(currPawn)
					
					currPawn = PAWN_FACTORY:CreatePawn(currType)
					currPawn:SetTeam(TEAM_PLAYER)
					Board:AddPawn(currPawn)
					currPawn:SetSpace(pos)
				end
			end
		end
	)
end

local HOOK_pawnKilled = function(mission, pawn)
	if pawn:GetType() == "tatu_CandyUnicorn" then
		Game:TriggerSound("enemy/dung_1/death")
	end
end

local HOOK_pawnTracked = function(mission, pawn)
	if pawn:GetType() == "tatu_CandyUnicornHurt" then
		pawn:SetTeam(TEAM_PLAYER)
	end
end

local function EVENT_onModsLoaded()
	modApi:addNextTurnHook(HOOK_nextTurn)
	modApi:addMissionEndHook(HOOK_missionEnd)
	modApi:addPostLoadGameHook(HOOK_postLoadGameHook)
	-- death sound
	modapiext:addPawnKilledHook(HOOK_pawnKilled)
	-- unicorn hurt team
	modapiext:addPawnTrackedHook(HOOK_pawnTracked)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)
