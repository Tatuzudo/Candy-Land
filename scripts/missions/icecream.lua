local mod = mod_loader.mods[modApi.currentMod]
local path = mod.resourcePath

-- sprites
-- modApi:appendAsset("img/effects/tatu_shotup_red.png", path .."img/effects/shotup_red.png")
modApi:appendAsset("img/weapons/tatu_icecream_launcher.png", path .."img/weapons/icecream_launcher.png")

modApi:appendAsset("img/units/mission/tatu_icecream_truck.png", path .."img/units/mission/icecream_truck.png")
modApi:appendAsset("img/units/mission/tatu_icecream_truck_a.png", path .."img/units/mission/icecream_truck_a.png")
modApi:appendAsset("img/units/mission/tatu_icecream_truck_ns.png", path .."img/units/mission/icecream_truck_ns.png")
modApi:appendAsset("img/units/mission/tatu_icecream_truck_death.png", path .."img/units/mission/icecream_truck_death.png")

local a = ANIMS
a.tatu_icecream_truck = a.BaseUnit:new{Image = "units/mission/tatu_icecream_truck.png", PosX = -13, PosY = 4}
a.tatu_icecream_trucka = a.tatu_icecream_truck:new{Image = "units/mission/tatu_icecream_truck_a.png", NumFrames = 4}
a.tatu_icecream_truckns = a.tatu_icecream_truck:new{Image = "units/mission/tatu_icecream_truck_ns.png", PosX = -13, PosY = 4}
a.tatu_icecream_truckd = a.tatu_icecream_truck:new{Image = "units/mission/tatu_icecream_truck_death.png", PosX = -16, PosY = -2, NumFrames = 11, Time = 0.14, Loop = false }

-- mission
local objText1 = "Protect the Ice Cream Truck"
local objText2 = "Finish with at least 3 frozen Vek"

Mission_Candy_Icecream = Mission_Infinite:new{ 
	Name = "Ice Cream",
	TruckId = -1,
	SpawnMod = 1,
	IceObjN = 3,
	-- Objectives = { Objective(objText1,1), Objective(objText2, 1),  },
	Objectives = Objective(objText2, 1, 1),
	UseBonus = false,
	MapVetoes = {"anyAE2"},
}

function Mission_Candy_Icecream:StartMission()
	local truck = PAWN_FACTORY:CreatePawn("tatu_IceCreamTruck")
	self.TruckId = truck:GetId()
	Board:AddPawn(truck)
end

function Mission_Candy_Icecream:CountIce()
	local ret = 0
	local enemyList = extract_table(Board:GetPawns(TEAM_ENEMY))
	
	for i = 1, #enemyList do
		local currPawn = Board:GetPawn(enemyList[i])
		if currPawn:IsFrozen() then
			ret = ret + 1
		end
	end
	
	return ret
end

function Mission_Candy_Icecream:UpdateObjectives()
	-- local truck = Board:IsPawnAlive(self.TruckId) and OBJ_STANDARD or OBJ_FAILED
	-- Game:AddObjective(objText1,truck)
	local ice = self:CountIce() >= self.IceObjN and OBJ_COMPLETE or OBJ_STANDARD
	Game:AddObjective(objText2,ice)
end

function Mission_Candy_Icecream:GetCompletedObjectives()
	-- local ret = copy_table(self.Objectives)
	local ret = self.Objectives
	
	-- if not Board:IsPawnAlive(self.TruckId) then
		-- ret[1] = ret[1]:Failed()
	-- end
	
	if self:CountIce() < self.IceObjN then
		ret = ret:Failed()
	end
	
	return ret
end

--used for briefing messages
function Mission_Candy_Icecream:GetCompletedStatus()
	local less_ice = self:CountIce() < self.IceObjN
	local pawn_alive = Board:IsPawnAlive(self.TruckId) 
	-- if not pawn_alive and less_ice then 
		-- return "Failure"
	if less_ice then
		return "Failure"
		-- return "Noice"
	-- elseif not pawn_alive then
		-- return "Truck"
	else
		return "Success"
	end
end

tatu_IceCreamTruck = 
{
	Name = "Ice Cream Truck",
	Health = 1,
	MoveSpeed = 2,
	SkillList = { "tatu_IceCreamCannon" },
	Image = "tatu_icecream_truck",
	Massive = false,
	SoundLocation = "/support/civilian_truck/",
	DefaultTeam = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	Corpse = false,
	Corporate = true
}
AddPawn("tatu_IceCreamTruck")

tatu_IceCreamCannon = Skill:new{
	Name = "Ice Cream Launcher",
	Description = "Launches a ball of ice cream on the target, instantly freezing it (and making it delicious).",
	Range = 3,
	Icon = "weapons/tatu_icecream_launcher.png",
	UpShot = "effects/shotup_crabB.png",--shotup_ice.png",
	LaunchSound = "/weapons/ice_throw",
	ImpactSound = "/impact/generic/ice",
	Class = "Unique",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(1,1),
		Target = Point(1,1),
		CustomPawn = "tatu_IceCreamTruck",
	}	
}

function tatu_IceCreamCannon:GetTargetArea(point)
	local ret = PointList()
	local size = self.Range
	
	local corner = point - Point(size, size)
	
	local p = Point(corner)
	
	for i = 0, ((size*2+1)*(size*2+1)) do
		local diff = point - p
		local dist = math.abs(diff.x) + math.abs(diff.y)
		if Board:IsValid(p) and dist <= size and dist > 1 then
			ret:push_back(p)
		end
		p = p + VEC_RIGHT
		if math.abs(p.x - corner.x) == (size*2+1) then
			p.x = p.x - (size*2+1)
			p = p + VEC_DOWN
		end
	end
	
	return ret
	
end

function tatu_IceCreamCannon:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dam = SpaceDamage(p2)
	dam.iFrozen = EFFECT_CREATE
	ret:AddArtillery(dam,self.UpShot,NO_DELAY)
	return ret
end