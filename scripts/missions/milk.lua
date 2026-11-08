local mod = mod_loader.mods[modApi.currentMod]

-- icon
modApi:appendAsset("img/combat/tile_icon/icon_tatu_milk.png", mod.resourcePath .."img/combat/tile_icon/icon_milk.png")
	Location["combat/tile_icon/icon_tatu_milk.png"] = Point(-27,2)

-- animation
CANDY_MILK_EMITTER_1 = Emitter:new{
	-- image = "combat/tiles_grass/particle.png",
	image = "combat/tiles_snow/dust.png",
	x = 10,
	y = -40,
	variance = 10,
	min_alpha = 0.1,
	max_alpha = 0.7,
	angle = 100,
	angle_variance = 0,
	rot_speed = 0,
	random_rot = false,
	lifespan = 0.2,
	burst_count = 15,
	speed = 15,
	birth_rate = 0.15,
	gravity = true,
	layer = LAYER_FRONT,
	timer = 1,
	max_particles = 150
}

CANDY_MILK_EMITTER_2 = Emitter:new{
	-- image = "combat/tiles_grass/particle.png",
	image = "combat/tiles_snow/dust.png",
	x = 10,
	y = -40,
	variance = 20,
	min_alpha = 0.1,
	max_alpha = 0.7,
	angle = 100,
	angle_variance = 0,
	rot_speed = 0,
	random_rot = true,
	lifespan = 0.2,
	burst_count = 15,
	speed = 15,
	birth_rate = 0.15,
	gravity = true,
	layer = LAYER_FRONT,
	timer = 1,
	max_particles = 150
}

-- mission
Mission_Candy_Milk = Mission_Infinite:new{ 
	Name = "Milk Storm",
	Environment = "Env_Candy_Milk",
	UseBonus = true,
	BonusPool = {BONUS_GRID, BONUS_MECHS, BONUS_KILL_FIVE, BONUS_BLOCK, BONUS_SELFDAMAGE, BONUS_DEBRIS},--removed pacifist
	MilkNumber = 3,
}

function Mission_Candy_Milk:StartMission()
	Board:StopWeather()
end

Env_Candy_Milk = Env_Attack:new{
	Image = "env_lightning",
	Name = "Milk Storm",
	Text = "A milk storm will fall in an increasing number of spaces every turn, turning them into milk.",
	StratText = "MILK STORM",
	CombatIcon = "combat/tile_icon/icon_tatu_milk.png",
	CombatName = "MILK STORM",
	Instant = true,
}

function Env_Candy_Milk:MarkSpace(space, active)
	Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255,226,88,0.75))
	Board:MarkSpaceDesc(space,"TATU_MILK")
	
	if active then
		Board:MarkSpaceImage(space,self.CombatIcon, GL_Color(255,150,150,0.75))
	end
end

local firstWait = 1
function Env_Candy_Milk:ApplyStart() --Runs once before the effect
	firstWait = 1
	local effect = SkillEffect()
	if Board:GetTurn() > 3 then
		PrepareVoiceEvent("Mission_Candy_SuperMilkStorm", -1)
		effect:AddBoardShake(1)
		effect:AddDelay(1)
	end
	effect:AddSound("/props/lightning_strike")
	effect:AddSound("/enemy/dung_1/death")
	effect:AddBoardShake(2) --Time
	effect:AddScript("Board:SetWeather(1,"..RAIN_NORMAL..",Point(0,0),Point(7,7),3)")
	Board:AddEffect(effect)
end

function Env_Candy_Milk:GetAttackEffect(location,effect)
	local mission = GetCurrentMission()
	if mission and mission.MilkNumber then
		effect:AddDelay(firstWait)
		firstWait = 0
		effect:AddDelay(math.random()*4/mission.MilkNumber)
		if math.random() < 0.8/mission.MilkNumber then
			effect:AddSound("/enemy/dung_1/hurt")
		elseif math.random() < 0.4/mission.MilkNumber then
			effect:AddSound("/enemy/dung_1/death")
		end
	end
	
	effect:AddEmitter(location,"CANDY_MILK_EMITTER_1")
	effect:AddEmitter(location,"CANDY_MILK_EMITTER_2")
	
	local damage = SpaceDamage(location)
	damage.sAnimation = "Splash"
	damage.iTerrain = TERRAIN_WATER
	effect:AddSound("/props/water_splash")
	effect:AddDamage(damage)
	
	return effect
end

function Env_Candy_Milk:SelectSpaces()
	local ret = {}
	
	local mission = GetCurrentMission()
	if mission and mission.MilkDelay then
		mission.MilkDelay = 1
	end
	
	local choices = {}
	
	for x = 0, 7 do
		for y = 0, 7 do
			point = Point(x,y)
			if not Board:IsBuilding(point) and not Board:IsTerrain(point,TERRAIN_WATER) then
				choices[#choices+1] = point
			end
		end
	end
	
	if mission and mission.MilkNumber then
		local n = math.min(mission.MilkNumber, #choices)
		for i = 1, n do
			ret[#ret+1] = random_removal(choices)
		end
		mission.MilkNumber = math.min(mission.MilkNumber+3,12)
	end
	
	return ret
end
