local mod = mod_loader.mods[modApi.currentMod]
local path = mod.resourcePath

-- assets
for i = 0, 9 do
	modApi:addMap(path .."maps/candy_strawberry".. i ..".map")
end

modApi:appendAsset("img/weapons/tatu_seed_disperser.png", path .."img/weapons/seed_disperser.png")
modApi:appendAsset("img/combat/icons/icon_tatu_strawberry_glow.png", path.."img/combat/icons/icon_strawberry_glow.png")
	Location["combat/icons/icon_tatu_strawberry_glow.png"] = Point(-14,7)

modApi:appendAsset("img/units/mission/tatu_seeder.png", path .."img/units/mission/seeder.png")
modApi:appendAsset("img/units/mission/tatu_seeder_ns.png", path .."img/units/mission/seeder_ns.png")
modApi:appendAsset("img/units/mission/tatu_seeder_a.png", path .."img/units/mission/seeder_a.png")
modApi:appendAsset("img/units/mission/tatu_seeder_death.png", path .."img/units/mission/seeder_death.png")
modApi:appendAsset("img/units/mission/tatu_seeder_broken.png", path .."img/units/mission/seeder_broken.png")

local a = ANIMS
a.tatu_seeder = 		a.BaseUnit:new{ Image = "units/mission/tatu_seeder.png", PosX = -25, PosY = -8 }
a.tatu_seedera = 		a.BaseUnit:new{ Image = "units/mission/tatu_seeder_a.png", PosX = -26, PosY = -8, NumFrames = 8 }
a.tatu_seederd = 		a.BaseUnit:new{ Image = "units/mission/tatu_seeder_death.png", PosX = -32, PosY = -7, NumFrames = 11, Time = 0.14, Loop = false }
a.tatu_seeder_broken = 	a.tatu_seeder:new{ Image = "units/mission/tatu_seeder_broken.png"}

-- mission
local objText1 = "Protect the Seeder"
local objText2 = "End with at least 2 strawbery tiles"

Mission_Candy_Strawberry = Mission_Infinite:new{
	Name = "Seeder",
	MapTags = { "strawberry" }, --MapTags = { "disposal" },
	Objectives = { Objective(objText1,1), Objective(objText2, 1),  }, 
	BonusPool = {BONUS_GRID, BONUS_MECHS, BONUS_KILL_FIVE, BONUS_BLOCK, BONUS_SELFDAMAGE, BONUS_DEBRIS},--removed pacifist 
	SeederId = -1,
	SpawnStartMod = 1,
	SpawnMod = 1,
	UseBonus = false,
	ObjN = 2,
}

function Mission_Candy_Strawberry:CountMountains()
	return #self:GetTerrainList(TERRAIN_MOUNTAIN)
end

function Mission_Candy_Strawberry:GetCompletedObjectives()
	local ret = copy_table(self.Objectives)
	
	if not Board:IsPawnAlive(self.SeederId) then
		ret[1] = ret[1]:Failed()
	end
	
	if self:CountMountains() < self.ObjN then
		ret[2] = ret[2]:Failed()
	end
	
	return ret
end

function Mission_Candy_Strawberry:UpdateObjectives()
	local alive = Board:IsPawnAlive(self.SeederId) and OBJ_STANDARD or OBJ_FAILED
	local mountains = self:CountMountains() >= self.ObjN and OBJ_COMPLETE or OBJ_STANDARD
	Game:AddObjective(objText1, alive)	
	Game:AddObjective(objText2, mountains)	
end

--used for briefing messages
function Mission_Candy_Strawberry:GetCompletedStatus()
	local mnt_alive = self:CountMountains() < self.ObjN
	local pawn_alive = Board:IsPawnAlive(self.SeederId) 
	if not pawn_alive and mnt_alive then 
		return "Failure"
	elseif  mnt_alive then
		return "Planted"
	elseif not pawn_alive then
		return "Seeder"
	else
		return "Success"
	end
end

function Mission_Candy_Strawberry:StartMission()
	local unit = PAWN_FACTORY:CreatePawn("tatu_Seeder")
	self.SeederId = unit:GetId()
	Board:AddPawn(unit,"strawberry")
end

tatu_Seeder = Pawn:new{
	Name = "Seeder",
	Image = "tatu_seeder",
	Health = 2,
	MoveSpeed = 0,
	SkillList = { "tatu_Seeder_Attack" }, 
	DefaultTeam = TEAM_PLAYER,
	Pushable = false,
	NonGrid = true,
	IgnoreSmoke = true,
	Corporate = true,
	-- Corpse = true,
	SoundLocation = "/support/disposal",
}

tatu_Seeder_Attack = Grenade_Base:new{  
	Name = "Seed Disperser",
	Description = "Create a strawberry or kill a unit on the target and push adjacent tiles to it.",
	Explosion = "",
	Icon = "weapons/tatu_seed_disperser.png",	
	Class = "Unique",
	LaunchSound = "/weapons/boulder_throw",--"/support/disposal/attack",
	ImpactSound = "/impact/dynamic/rock",
	IgnoreSmoke = true,
	TipImage = {
		Unit = Point(2,3),
		Target = Point(1,1),
		Second_Origin = Point(2,3),
		Second_Target = Point(2,1),
		Enemy = Point(2,1),
		Enemy2 = Point(3,1),
		CustomPawn = "tatu_Seeder"
	}
}

function tatu_Seeder_Attack:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dam = SpaceDamage(p2,0)
	if Board:GetPawn(p2) or Board:IsBuilding(p2) then
		dam.sAnimation = "ExploArtCrab2"
		dam.iDamage = DAMAGE_DEATH
	else
		if Board:IsPod(p2) then
			dam.sScript = "Board:DamageSpace("..p2:GetString()..", DAMAGE_DEATH)"
		elseif Board:IsItem(p2) or Board:IsSpawning(p2) then
			dam.sScript = string.format([[
				local point = %s
				Board:RemoveItem(point)
				Board:ClearSpace(point)
			]],p2:GetString())
		end
		dam.iFire = EFFECT_REMOVE
		dam.sAnimation = "ExploRepulse2"
		dam.iTerrain = TERRAIN_MOUNTAIN
		dam.sImageMark = "combat/icons/icon_tatu_strawberry_glow.png"
		dam.sSound = "/support/terraformer/attack_wave" --"/support/disposal/attack_impact"
	end
	ret:AddArtillery(dam, "effects/shotup_acid.png")
	
	for i = DIR_START, DIR_END do
		dam = SpaceDamage(p2 + DIR_VECTORS[i])
		dam.iPush = i
		dam.sAnimation = "airpush_"..i
		ret:AddDamage(dam)
	end
	
	return ret
end

