local mod = mod_loader.mods[modApi.currentMod]
local path = mod.resourcePath

-- sprites --

modApi:appendAsset("img/units/mission/pinata.png", path .."img/units/mission/pinata.png")
modApi:appendAsset("img/units/mission/pinata_a.png", path .."img/units/mission/pinata_a.png")
modApi:appendAsset("img/units/mission/pinata_d.png", path .."img/units/mission/pinata_d.png")

modApi:appendAsset("img/effects/tatu_sweets.png", path .."img/effects/sweets.png")
	Location["effects/tatu_sweets.png"] = Point(-18,6)
modApi:appendAsset("img/combat/icons/icon_tatu_sweets_glow.png", path.."img/combat/icons/icon_sweets_glow.png")
	Location["combat/icons/icon_tatu_sweets_glow.png"] = Point(-13,13)
-- modApi:copyAsset("img/combat/icons/icon_heal_glow.png", "img/combat/icons/tatu_icon_heal_glow.png")
	-- Location["combat/icons/tatu_icon_heal_glow.png"] = Point(-13,13)

local a = ANIMS
a.tatu_pinata = a.BaseUnit:new{Image = "units/mission/pinata.png", PosX = -18, PosY = -7}
a.tatu_pinataa = a.tatu_pinata:new{Image = "units/mission/pinata_a.png", NumFrames = 2, Time = 0.72 }
a.tatu_pinatad = a.tatu_pinata:new{Image = "units/mission/pinata_d.png", PosX = -18, PosY = -7, NumFrames = 8, Loop = false, Time = 0.12}

-- mission --

local objText = "Destroy the Pinatas"
Mission_Candy_Pinatas = Mission_Infinite:new{
	Name = "Pinata Party",
	PinataCount = 2,
	MapTags = {"satellite"},--let's hijack it
	Objectives = Objective(objText,2,2),
	UseBonus = false
}

function Mission_Candy_Pinatas:CountPinatas()
	local pawns = extract_table(Board:GetPawns(TEAM_ENEMY))
	local count = 0
	for i, v in ipairs(pawns) do
		if string.find(Board:GetPawn(v):GetType(), "tatu_Pinata") ~= nil then
			count = count + 1
		end
	end
	
	return count
end

function Mission_Candy_Pinatas:StartMission()
	local zone = extract_table(Board:GetZone("satellite"))
	
	for i = 1, self.PinataCount do
		local pawn = PAWN_FACTORY:CreatePawn("tatu_Pinata")
		local choice = random_removal(zone)
		Board:ClearSpace(choice)
		Board:AddPawn(pawn, choice)
	end
end

function Mission_Candy_Pinatas:GetCompletedObjectives()
	local pinata_count = self:CountPinatas()
	if pinata_count == 0 then
		return self.Objectives
	elseif pinata_count == 1 then
		return Objective(objText.." (One Remains)",1,2)
	else
		return self.Objectives:Failed()
	end
end

function Mission_Candy_Pinatas:UpdateObjectives()
	local status = self:CountPinatas() == 0 and OBJ_COMPLETE or OBJ_STANDARD
	Game:AddObjective(objText,status, REWARD_REP, 2)
end

-- pinatas --

local damage = SpaceDamage()
damage.iDamage = -1
damage.sSound = "/ui/map/repair_mines"
tatu_Pinata_Entrails = { Image = "effects/tatu_sweets.png", Damage = damage, Tooltip = "TATU_SWEETS_TEXT", Icon = "combat/icons/icon_tatu_sweets_glow.png", UsedImage = ""}

tatu_Pinata = {
	Name = "Pinata",
	Health = 2,
	Neutral = true,
	MoveSpeed = 0,
	Image = "tatu_pinata",
	SoundLocation = "/enemy/dung_1/",
	DefaultTeam = TEAM_ENEMY,
	IsPortrait = false,
	Minor = true,
	Mission = true,
	Tooltip = "Pinata_Death_Tooltip",
	IsDeathEffect = true,
}
AddPawn("tatu_Pinata") 

function tatu_Pinata:GetDeathEffect(point)
	local ret = SkillEffect()
	
	local dam = SpaceDamage(point)
	dam.sAnimation = "ExploRepulse1"--hack
	dam.sSound = "/weapons/science_repulse"
	ret:AddDamage(dam)
	
	for i = DIR_START, DIR_END do
		dam = SpaceDamage(point + DIR_VECTORS[i])
		dam.iPush = i
		dam.sAnimation = "airpush_"..i
		if not Board:IsBlocked(dam.loc, PATH_GROUND) then
			dam.sItem = "tatu_Pinata_Entrails"
		end
		ret:AddDamage(dam)
	end
	
	return ret
end

Pinata_Death_Tooltip = SelfTarget:new{
	Name = "Candy Burst",
	Description = "Pushes adjacent tiles on death, leaving delicious treats on empty tiles.",
	Class = "Death",
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,2),
		Enemy = Point(1,2),
		Friend = Point(2,3),
		CustomPawn = "tatu_Pinata",
	}
}

function Pinata_Death_Tooltip:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local space_damage = SpaceDamage(p2,DAMAGE_DEATH)
	space_damage.bHide = true
	space_damage.sAnimation = "ExploAir2" 
	ret:AddDelay(1)
	ret:AddDamage(space_damage)
	ret:AddDelay(2)
	return ret
end

-- thanks tosx
BoardEvents.onItemRemoved:subscribe(function(loc, removed_item)
    if removed_item == "tatu_Pinata_Entrails" then
        local pawn = Board:GetPawn(loc)
        if pawn then
			local mine_damage = SpaceDamage(loc)
			mine_damage.sScript = "Board:GetPawn("..loc:GetString().."):SetBoosted(true)"
			Board:DamageSpace(mine_damage)
        end
    end
end)
