
Mission_Candy_Gumdrop = Mission_Infinite:new{
	Name = "Gumdrops", 
	UseBonus = true,
	SpawnStartMod = -2,
	SpawnMod = -1,
	GumdropSpawn = 1,
	BonusPool = {BONUS_GRID, BONUS_MECHS, BONUS_KILL_FIVE, BONUS_DEBRIS, BONUS_SELFDAMAGE} --remove pacifist (too hard)
}

function Mission_Candy_Gumdrop:StartMission()
	local options = {}
	for x = 1, 6 do
		for y = 1, 6 do
			p = Point(x,y)
			if not Board:IsBlocked(p, PATH_GROUND) and not Board:IsPod(p) and not Board:IsSpawning(p) then
				options[#options+1] = p
			end
		end
	end
	
	for i = 1, 2 do
		local n = math.min(i,math.random(1,1+GetDifficulty()))
		local units = {"tatu_GumdropSmall","tatu_GumdropMed"}
		local unit = units[n]..math.random(0,3)
		local pawn = PAWN_FACTORY:CreatePawn(unit)
		Board:AddPawn(pawn,random_removal(options))
	end
	
	-- block some psion spawns
	self:GetSpawner():BlockPawns("Jelly_Explode")
	self:GetSpawner():BlockPawns("Jelly_Spider")
	self:GetSpawner():BlockPawns("DNT_Nurse")
	self:GetSpawner():BlockPawns("DNT_Reactive")
end

function Mission_Candy_Gumdrop:UpdateSpawning()
	self:SpawnPawns(self:GetSpawnCount())
	
	local enemies = #extract_table(Board:GetPawns(TEAM_ENEMY))
	if enemies > 2 + GetDifficulty() then return end
	
	if not self:IsFinalTurn() then
		modApi:conditionalHook(
			function()
				return Board and Board:GetBusyState() == 0
			end,
			function()
				self:SpawnGumdrops(self.GumdropSpawn)
			end
		)
	end
end

function Mission_Candy_Gumdrop:SpawnGumdrops(count)
	local options = {}
	for x = 1, 6 do
		for y = 1, 6 do
			p = Point(x,y)
			if not Board:IsBlocked(p, PATH_GROUND) and not Board:IsPod(p) and not Board:IsSpawning(p) then
				options[#options+1] = p
			end
		end
	end
	count = math.min(count,#options)
	
	for i = 1, count do
		local n = math.random(1,2)
		local enemies = #extract_table(Board:GetPawns(TEAM_ENEMY_MAJOR))
		if enemies > 2 + GetDifficulty() then n = 1 end
		local units = {"tatu_GumdropSmall","tatu_GumdropMed"}
		local unit = units[n]..math.random(0,3)
		local pawn = PAWN_FACTORY:CreatePawn(unit)
		Board:AddPawn(pawn,random_removal(options))
		pawn:Fall(0)
	end
end

-- medium
tatu_GumdropMed0 = tatu_GumdropBossMed0:new{
	Name = "Strawberry Gumdrop",
	Massive = false,
	DeathSpawn = "tatu_GumdropSmall0",
	SkillList = { "tatu_GumdropAtkMed0" },
	Tier = TIER_ALPHA
}
AddPawnName("tatu_GumdropMed0")

tatu_GumdropMed1 = tatu_GumdropBossMed1:new{
	Name = "Grape Gumdrop",
	Massive = false,
	DeathSpawn = "tatu_GumdropSmall1",
	SkillList = { "tatu_GumdropAtkMed1" },
	Tier = TIER_ALPHA
}
AddPawnName("tatu_GumdropMed1")

tatu_GumdropMed2 = tatu_GumdropBossMed2:new{
	Name = "Pineapple Gumdrop",
	Massive = false,
	DeathSpawn = "tatu_GumdropSmall2",
	SkillList = { "tatu_GumdropAtkMed2" },
	Tier = TIER_ALPHA
}
AddPawnName("tatu_GumdropMed2")

tatu_GumdropMed3 = tatu_GumdropBossMed3:new{
	Name = "Spearmint Gumdrop",
	Massive = false,
	DeathSpawn = "tatu_GumdropSmall3",
	SkillList = { "tatu_GumdropAtkMed3" },
	Tier = TIER_ALPHA
}
AddPawnName("tatu_GumdropMed3")

-- small
tatu_GumdropSmall0 = tatu_GumdropBossSmall0:new{
	Name = "Strawberry Gumdroplet",
	Massive = false,
	SkillList = { "tatu_GumdropAtkSmall0" },
	Tier = TIER_NORMAL
}
AddPawnName("tatu_GumdropSmall0")

tatu_GumdropSmall1 = tatu_GumdropBossSmall1:new{
	Name = "Grape Gumdroplet",
	Massive = false,
	SkillList = { "tatu_GumdropAtkSmall1" },
	Tier = TIER_NORMAL
}
AddPawnName("tatu_GumdropSmall1")

tatu_GumdropSmall2 = tatu_GumdropBossSmall2:new{
	Name = "Pineapple Gumdroplet",
	Massive = false,
	SkillList = { "tatu_GumdropAtkSmall2" },
	Tier = TIER_NORMAL
}
AddPawnName("tatu_GumdropSmall2")

tatu_GumdropSmall3 = tatu_GumdropBossSmall3:new{
	Name = "Spearmint Gumdroplet",
	Massive = false,
	SkillList = { "tatu_GumdropAtkSmall3" },
	Tier = TIER_NORMAL
}
AddPawnName("tatu_GumdropSmall3")

-- attacks
tatu_GumdropAtkMed0 = tatu_GumdropBossAtk0:new{
	TipImage = {Unit = Point(2,2),Building = Point(2,1),Target = Point(2,1),CustomPawn = "tatu_GumdropMed0",}
}

tatu_GumdropAtkMed1 = tatu_GumdropBossAtk0:new{
	TipImage = {Unit = Point(2,2),Building = Point(2,1),Target = Point(2,1),CustomPawn = "tatu_GumdropMed1",}
}

tatu_GumdropAtkMed2 = tatu_GumdropBossAtk0:new{
	TipImage = {Unit = Point(2,2),Building = Point(2,1),Target = Point(2,1),CustomPawn = "tatu_GumdropMed2",}
}

tatu_GumdropAtkMed3 = tatu_GumdropBossAtk0:new{
	TipImage = {Unit = Point(2,2),Building = Point(2,1),Target = Point(2,1),CustomPawn = "tatu_GumdropMed3",}
}

tatu_GumdropAtkSmall0 = tatu_GumdropBossAtk0:new{
	TipImage = {Unit = Point(2,2),Building = Point(2,1),Target = Point(2,1),CustomPawn = "tatu_GumdropSmall0",}
}

tatu_GumdropAtkSmall1 = tatu_GumdropBossAtk0:new{
	TipImage = {Unit = Point(2,2),Building = Point(2,1),Target = Point(2,1),CustomPawn = "tatu_GumdropSmall1",}
}

tatu_GumdropAtkSmall2 = tatu_GumdropBossAtk0:new{
	TipImage = {Unit = Point(2,2),Building = Point(2,1),Target = Point(2,1),CustomPawn = "tatu_GumdropSmall2",}
}

tatu_GumdropAtkSmall3 = tatu_GumdropBossAtk0:new{
	TipImage = {Unit = Point(2,2),Building = Point(2,1),Target = Point(2,1),CustomPawn = "tatu_GumdropSmall3",}
}