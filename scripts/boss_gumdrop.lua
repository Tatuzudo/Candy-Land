local mod = mod_loader.mods[modApi.currentMod]
local path = mod.resourcePath

-- portraits
modApi:appendAsset("img/portraits/enemy/tatu_gumdrop_strawberry.png", path .."img/portraits/enemy/gumdrop_strawberry.png")
modApi:appendAsset("img/portraits/enemy/tatu_gumdrop_grape.png", path .."img/portraits/enemy/gumdrop_grape.png")
modApi:appendAsset("img/portraits/enemy/tatu_gumdrop_pineapple.png", path .."img/portraits/enemy/gumdrop_pineapple.png")
modApi:appendAsset("img/portraits/enemy/tatu_gumdrop_spearmint.png", path .."img/portraits/enemy/gumdrop_spearmint.png")

-- sprites
modApi:appendAsset("img/effects/tatu_shotup_red.png", path .."img/effects/shotup_red.png")
modApi:appendAsset("img/effects/tatu_shotup_purple.png", path .."img/effects/shotup_purple.png")

modApi:appendAsset("img/units/mission/tatu_gumdrop_B.png", path .."img/units/mission/gumdrop_B.png")
modApi:appendAsset("img/units/mission/tatu_gumdrop_B_a.png", path .."img/units/mission/gumdrop_B_a.png")
modApi:appendAsset("img/units/mission/tatu_gumdrop_Bw.png", path .."img/units/mission/gumdrop_Bw.png")
modApi:appendAsset("img/units/mission/tatu_gumdrop_B2.png", path .."img/units/mission/gumdrop_B2.png")
modApi:appendAsset("img/units/mission/tatu_gumdrop_B2_a.png", path .."img/units/mission/gumdrop_B2_a.png")
modApi:appendAsset("img/units/mission/tatu_gumdrop_B2w.png", path .."img/units/mission/gumdrop_B2w.png")
modApi:appendAsset("img/units/mission/tatu_gumdrop_B3.png", path .."img/units/mission/gumdrop_B3.png")
modApi:appendAsset("img/units/mission/tatu_gumdrop_B3_a.png", path .."img/units/mission/gumdrop_B3_a.png")
modApi:appendAsset("img/units/mission/tatu_gumdrop_B3w.png", path .."img/units/mission/gumdrop_B3w.png")
modApi:appendAsset("img/units/mission/tatu_gumdrop_B3_death.png", path .."img/units/mission/gumdrop_B3_death.png")

local a = ANIMS
a.tatu_gumdrop_B = a.BaseUnit:new{Image = "units/mission/tatu_gumdrop_B.png", PosX = -30, PosY = -19, Height = 4}
a.tatu_gumdrop_Ba = a.tatu_gumdrop_B:new{Image = "units/mission/tatu_gumdrop_B_a.png", NumFrames = 4}
a.tatu_gumdrop_Bw = a.tatu_gumdrop_B:new{Image = "units/mission/tatu_gumdrop_Bw.png", PosX = -26, PosY = 8}
a.tatu_gumdrop_Bd = a.tatu_gumdrop_B:new{Loop = false, Time = 0.35}
a.tatu_gumdrop_B2 = a.tatu_gumdrop_B:new{Image = "units/mission/tatu_gumdrop_B2.png", PosX = -20, PosY = -3}
a.tatu_gumdrop_B2a = a.tatu_gumdrop_B2:new{Image = "units/mission/tatu_gumdrop_B2_a.png", NumFrames = 2, Time = 0.75}
a.tatu_gumdrop_B2w = a.tatu_gumdrop_B2:new{Image = "units/mission/tatu_gumdrop_B2w.png", PosX = -21, PosY = 8}
a.tatu_gumdrop_B2d = a.tatu_gumdrop_B2:new{Loop = false, Time = 0.35}
a.tatu_gumdrop_B3 = a.tatu_gumdrop_B:new{Image = "units/mission/tatu_gumdrop_B3.png", PosX = -15, PosY = 5}
a.tatu_gumdrop_B3a = a.tatu_gumdrop_B3:new{Image = "units/mission/tatu_gumdrop_B3_a.png", NumFrames = 2, Time = 0.5}
a.tatu_gumdrop_B3w = a.tatu_gumdrop_B3:new{Image = "units/mission/tatu_gumdrop_B3w.png", PosX = -17, PosY = 18}
a.tatu_gumdrop_B3d = a.tatu_gumdrop_B3:new{Image = "units/mission/tatu_gumdrop_B3_death.png", PosX = -19, PosY = 5, NumFrames = 7, Loop = false, Time = 0.1}

---- mission
local objText = "Destroy 5 Gumdrops"

Mission_Candy_GumdropBoss = Mission_Boss:new{
	Name = "Gumdrop Leader",
	SpawnStartMod = -1,
	SpawnMod = -1,
	GumDeaths = 5,
	BossText = objText,
	BossPawn = "tatu_GumdropBoss0",
	GumList = nil
}

function Mission_Candy_GumdropBoss:StartMission()
	self.BossPawn = "tatu_GumdropBoss"..math.random(0,3)
	self:StartBoss()
	self:GetSpawner():BlockPawns("Jelly_Explode")
	self:GetSpawner():BlockPawns("Jelly_Spider")
	self:GetSpawner():BlockPawns("DNT_Nurse")
	self:GetSpawner():BlockPawns("DNT_Reactive")
end

function Mission_Candy_GumdropBoss:CountDeadBlobs()
	self.GumList = self.GumList or {}
	
	local dead = 0
	for id, dummy in pairs(self.GumList) do
		dead = dead + bool_int(not Board:IsPawnAlive(id))
	end
	
	return dead
end

function Mission_Candy_GumdropBoss:UpdateMission()
	self.GumList = self.GumList or {}
	
	local pawns = extract_table(Board:GetPawns(TEAM_ENEMY))
	local count = 0
	for i, v in ipairs(pawns) do
		if string.find(Board:GetPawn(v):GetType(), "tatu_GumdropBoss") ~= nil then
			self.GumList[v] = true
		end
	end
end

function Mission_Candy_GumdropBoss:UpdateObjectives()
	local n = self:CountDeadBlobs()
	local status = n >= self.GumDeaths and OBJ_COMPLETE or OBJ_STANDARD
	if status ~= OBJ_COMPLETE then
		Game:AddObjective(objText.." ("..n.." killed so far)", tostring(self:CountDeadBlobs()), "", status)
	else
		Game:AddObjective(objText,status)
	end
end

function Mission_Candy_GumdropBoss:IsBossDead()
	return self:CountDeadBlobs() >= self.GumDeaths
end

tatu_GumdropBoss0 = {
	Name = "Jumbo Strawberry Gumdrop Leader",
	Health = 3,
	MoveSpeed = 3,
	Image = "tatu_gumdrop_B",
	Portrait = "enemy/tatu_gumdrop_strawberry",
	ArtyArt = "effects/tatu_shotup_red.png",	
	SkillList = { "tatu_GumdropBossAtk0" },
	DeathSpawn = "tatu_GumdropBossMed0",
	Massive = true,
	DefaultTeam = TEAM_ENEMY,
	Ranged = 0,
	SoundLocation = "/enemy/goo_boss/",
	ImpactMaterial = IMPACT_BLOB,
	IsDeathEffect = true,
	Tier = TIER_BOSS
}
AddPawn("tatu_GumdropBoss0") 

-- big
tatu_GumdropBoss1 = tatu_GumdropBoss0:new{
	Name = "Jumbo Grape Gumdrop Leader",
	ImageOffset = 1,
	Portrait = "enemy/tatu_gumdrop_grape",
	SkillList = { "tatu_GumdropBossAtk1" },
	DeathSpawn = "tatu_GumdropBossMed1",
	ArtyArt = "effects/tatu_shotup_purple.png",
}
AddPawnName("tatu_GumdropBoss1") 

tatu_GumdropBoss2 = tatu_GumdropBoss0:new{
	Name = "Jumbo Pineapple Gumdrop Leader",
	ImageOffset = 2,
	Portrait = "enemy/tatu_gumdrop_pineapple",
	SkillList = { "tatu_GumdropBossAtk2" },
	DeathSpawn = "tatu_GumdropBossMed2",
	ArtyArt = "effects/shotup_crabB.png",
}
AddPawnName("tatu_GumdropBoss2")

tatu_GumdropBoss3 = tatu_GumdropBoss0:new{
	Name = "Jumbo Spearmint Gumdrop Leader",
	ImageOffset = 3,
	Portrait = "enemy/tatu_gumdrop_spearmint",
	SkillList = { "tatu_GumdropBossAtk3" },
	DeathSpawn = "tatu_GumdropBossMed3",
	ArtyArt = "effects/shotup_crab2.png",
}
AddPawnName("tatu_GumdropBoss3")

-- medium
tatu_GumdropBossMed0 = tatu_GumdropBoss0:new{
	Name = "enemy/gumdrop_spearmint",
	Health = 2,
	Image = "tatu_gumdrop_B2",
	DeathSpawn = "tatu_GumdropBossSmall0",
	SkillList = { "tatu_GumdropBossAtkMed0" },
}
AddPawnName("tatu_GumdropBossMed0")

tatu_GumdropBossMed1 = tatu_GumdropBoss1:new{
	Name = "Grape Gumdrop Leader",
	Health = 2,
	Image = "tatu_gumdrop_B2",
	DeathSpawn = "tatu_GumdropBossSmall1",
	SkillList = { "tatu_GumdropBossAtkMed1" },
}
AddPawnName("tatu_GumdropBossMed1")

tatu_GumdropBossMed2 = tatu_GumdropBoss2:new{
	Name = "Pineapple Gumdrop Leader",
	Health = 2,
	Image = "tatu_gumdrop_B2",
	DeathSpawn = "tatu_GumdropBossSmall2",
	SkillList = { "tatu_GumdropBossAtkMed2" },
}
AddPawnName("tatu_GumdropBossMed2")

tatu_GumdropBossMed3 = tatu_GumdropBoss3:new{
Name = "Spearmint Gumdrop Leader",
	Health = 2,
	Image = "tatu_gumdrop_B2",
	DeathSpawn = "tatu_GumdropBossSmall3",
	SkillList = { "tatu_GumdropBossAtkMed3" },
}
AddPawnName("tatu_GumdropBossMed3")

-- small
tatu_GumdropBossSmall0 = tatu_GumdropBoss0:new{
	Name = "Strawberry Gumdroplet Leader",
	Health = 1,
	Image = "tatu_gumdrop_B3",
	DeathSpawn = "",
	SkillList = { "tatu_GumdropBossAtkSmall0" },
}
AddPawnName("tatu_GumdropBossSmall0")

tatu_GumdropBossSmall1 = tatu_GumdropBoss1:new{
	Name = "Grape Gumdroplet Leader",
	Health = 1,
	Image = "tatu_gumdrop_B3",
	DeathSpawn = "",
	SkillList = { "tatu_GumdropBossAtkSmall1" },
}
AddPawnName("tatu_GumdropBossSmall1")

tatu_GumdropBossSmall2 = tatu_GumdropBoss2:new{
	Name = "Pineapple Gumdroplet Leader",
	Health = 1,
	Image = "tatu_gumdrop_B3",
	DeathSpawn = "",
	SkillList = { "tatu_GumdropBossAtkSmall2" },
}
AddPawnName("tatu_GumdropBossSmall2")

tatu_GumdropBossSmall3 = tatu_GumdropBoss3:new{
	Name = "Spearmint Gumdroplet Leader",
	Health = 1,
	Image = "tatu_gumdrop_B3",
	DeathSpawn = "",
	SkillList = { "tatu_GumdropBossAtkSmall3" },
}
AddPawnName("tatu_GumdropBossSmall3")

-- attacks
tatu_GumdropBossAtk0 = Skill:new{
	Name = "Glycemic Trampling",
	Description = "Attempt to squish the adjacent tile.",
	PathSize = 1,
	ScoreNothing = 0,
	Class = "Enemy",
	TipImage = {
		Unit = Point(2,2),
		Building = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "tatu_GumdropBoss0",
	}
}

tatu_GumdropBossAtk1 = tatu_GumdropBossAtk0:new{
	TipImage = {Unit = Point(2,2),Building = Point(2,1),Target = Point(2,1),CustomPawn = "tatu_GumdropBoss1",}
}

tatu_GumdropBossAtk2 = tatu_GumdropBossAtk0:new{
	TipImage = {Unit = Point(2,2),Building = Point(2,1),Target = Point(2,1),CustomPawn = "tatu_GumdropBoss2",}
}

tatu_GumdropBossAtk3 = tatu_GumdropBossAtk0:new{
	TipImage = {Unit = Point(2,2),Building = Point(2,1),Target = Point(2,1),CustomPawn = "tatu_GumdropBoss3",}
}

tatu_GumdropBossAtkMed0 = tatu_GumdropBossAtk0:new{
	TipImage = {Unit = Point(2,2),Building = Point(2,1),Target = Point(2,1),CustomPawn = "tatu_GumdropBossMed0",}
}

tatu_GumdropBossAtkMed1 = tatu_GumdropBossAtk0:new{
	TipImage = {Unit = Point(2,2),Building = Point(2,1),Target = Point(2,1),CustomPawn = "tatu_GumdropBossMed1",}
}

tatu_GumdropBossAtkMed2 = tatu_GumdropBossAtk0:new{
	TipImage = {Unit = Point(2,2),Building = Point(2,1),Target = Point(2,1),CustomPawn = "tatu_GumdropBossMed2",}
}

tatu_GumdropBossAtkMed3 = tatu_GumdropBossAtk0:new{
	TipImage = {Unit = Point(2,2),Building = Point(2,1),Target = Point(2,1),CustomPawn = "tatu_GumdropBossMed3",}
}

tatu_GumdropBossAtkSmall0 = tatu_GumdropBossAtk0:new{
	TipImage = {Unit = Point(2,2),Building = Point(2,1),Target = Point(2,1),CustomPawn = "tatu_GumdropBossSmall0",}
}

tatu_GumdropBossAtkSmall1 = tatu_GumdropBossAtk0:new{
	TipImage = {Unit = Point(2,2),Building = Point(2,1),Target = Point(2,1),CustomPawn = "tatu_GumdropBossSmall1",}
}

tatu_GumdropBossAtkSmall2 = tatu_GumdropBossAtk0:new{
	TipImage = {Unit = Point(2,2),Building = Point(2,1),Target = Point(2,1),CustomPawn = "tatu_GumdropBossSmall2",}
}

tatu_GumdropBossAtkSmall3 = tatu_GumdropBossAtk0:new{
	TipImage = {Unit = Point(2,2),Building = Point(2,1),Target = Point(2,1),CustomPawn = "tatu_GumdropBossSmall3",}
}

function tatu_GumdropBossAtk0:GetTargetArea(p1)
	local ret = PointList()
	--it can attack / destroy anything it moves over so it just has to check immovable things
	for dir = DIR_START, DIR_END do
		local curr = p1 + DIR_VECTORS[dir]
		
		if 	Board:IsValid(curr) then
			ret:push_back(curr)
		end
	end
	
	return ret
end

function tatu_GumdropBossAtk0:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	
	ret:AddQueuedDamage(SpaceDamage(p2,4))
	
	if Board:GetTerrain(p2) == TERRAIN_MOUNTAIN then
		ret:AddQueuedDamage(SpaceDamage(p2,4))
	end
	
	local pawn = Board:GetPawn(p2)
	
	if pawn == nil or not pawn:IsMech() then
		ret:AddQueuedMove(Board:GetSimplePath(p1, p2), FULL_DELAY)
	end
		
	return ret
end	

-- death
function tatu_GumdropBoss0:GetDeathEffect(point)
	local ret = SkillEffect()
	
	if self.DeathSpawn == "" then return ret end
	
	ret:AddSound("/enemy/goo_boss/split")
	
	local vicinity = extract_table(general_DiamondTarget(point,4))
	local spawnPoints = {}
	local backup = {}
	for i,v in ipairs(vicinity) do
		if not Board:IsBlocked(v,PATH_GROUND) and
				v ~= point	then
			
			if point:Manhattan(v) > 2 then
				backup[#backup + 1] = v
			else
				spawnPoints[#spawnPoints + 1] = v
			end
			
		end
	end
	
	local spawn_amount = 2
	
	for i = 1, spawn_amount do
	
		local damage = SpaceDamage(0)
		if #spawnPoints ~= 0 then
			damage.loc = random_removal(spawnPoints)
		elseif #backup ~= 0 then
			damage.loc = random_removal(backup)
		else
			ret:AddScript("Board:AddAlert("..point:GetString()..",\"Alert_BlobSpawn\")")
			break
		end
		
		damage.sPawn = self.DeathSpawn
		damage.sSound = '/impact/generic/blob'
		
		ret:AddArtillery(damage,self.ArtyArt,NO_DELAY)
		
	end
	
	return ret
end
