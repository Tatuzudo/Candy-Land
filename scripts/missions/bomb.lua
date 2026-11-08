local mod = mod_loader.mods[modApi.currentMod]
local path = mod.resourcePath

-- sprites
modApi:appendAsset("img/units/mission/tatu_chocolate_bomb.png", path .."img/units/mission/chocolate_bomb.png")
modApi:appendAsset("img/units/mission/tatu_chocolate_bomb_a.png", path .."img/units/mission/chocolate_bomb_a.png")
modApi:appendAsset("img/units/mission/tatu_chocolate_bomb_death.png", path .."img/units/mission/chocolate_bomb_death.png")
modApi:appendAsset("img/units/mission/tatu_chocolate_bomb_ns.png", path .."img/units/mission/chocolate_bomb_ns.png")

local a = ANIMS
a.tatu_chocolate_bomb = a.BaseUnit:new{Image = "units/mission/tatu_chocolate_bomb.png", PosX = -15, PosY = 2}
a.tatu_chocolate_bomba = a.tatu_chocolate_bomb:new{Image = "units/mission/tatu_chocolate_bomb_a.png", NumFrames = 4}
a.tatu_chocolate_bombd = a.tatu_chocolate_bomb:new{Image = "units/mission/tatu_chocolate_bomb_death.png", PosX = -24, PosY = -4, NumFrames = 11, Time = 0.09, Loop = false}

-- mission
Mission_Candy_Bomb = Mission_Infinite:new{
	Name = "Prototype Chocolate Bomb",
	Count = 1,
	MapTags = {"satellite"},
	Objectives = Objective("Defend the Prototype Chocolate Bomb",1),
	Bomb = -1,
	UseBonus = false,
}

function Mission_Candy_Bomb:AddDefended(unit, zone)
	zone = zone or "satellite"
	local options = extract_table(Board:GetZone(zone))
		
	if #options < self.Count then LOG("DEFEND MISSION: ERROR NO VALID SPACE") return end
	
	local pawn = PAWN_FACTORY:CreatePawn(unit)
	local id = pawn:GetId()
	local choice = random_removal(options)
	Board:SetTerrain(choice, TERRAIN_ROAD)
	Board:AddPawn(pawn,choice)
	
	return id
end

function Mission_Candy_Bomb:StartMission()
	self.Bomb = self:AddDefended("tatu_ChocolateBomb")
end

function Mission_Candy_Bomb:GetCompletedObjectives()
	if self:CountBombs() >= 1 then
		return self.Objectives
	else
		return self.Objectives:Failed()
	end
end

function Mission_Candy_Bomb:CountBombs()
	local count = 0
	if Board:IsPawnAlive(self.Bomb) then count = count + 1 end
	return count
end

function Mission_Candy_Bomb:UpdateObjectives()
	local status = self:CountBombs() >= 1 and OBJ_STANDARD or OBJ_FAILED
	Game:AddObjective("Defend the bomb", status, REWARD_REP, 1, 0)
end

tatu_ChocolateBomb = Pawn:new{
	Name = "Prototype Chocolate Bomb",
	Health = 1,
	Neutral = true,
	Corpse = false,
	IgnoreFire = true,
	MoveSpeed = 0,
	Image = "tatu_chocolate_bomb",
	DefaultTeam = TEAM_PLAYER,
	IsPortrait = false,
	Explodes = true,
}
