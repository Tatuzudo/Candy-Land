local mod = mod_loader.mods[modApi.currentMod]

---------- Sprites -----------
modApi:appendAsset("img/effects/tatu_cookie1.png", mod.resourcePath .."img/effects/cookie1.png")
Location["effects/tatu_cookie1.png"] = Point(-14,-4)
modApi:appendAsset("img/effects/tatu_cookie2.png", mod.resourcePath .."img/effects/cookie2.png")
Location["effects/tatu_cookie2.png"] = Point(-14,-4)
modApi:appendAsset("img/effects/tatu_cookie3.png", mod.resourcePath .."img/effects/cookie3.png")
Location["effects/tatu_cookie3.png"] = Point(-14,-4)
modApi:appendAsset("img/effects/tatu_cookie_crumbs.png", mod.resourcePath .."img/effects/cookie_crumbs.png")
Location["effects/tatu_cookie_crumbs.png"] = Point(-14,-4)

modApi:appendAsset("img/combat/icons/tatu_icon_cookie1.png", mod.resourcePath .."img/combat/icons/icon_cookie1_glow.png")
Location["combat/icons/tatu_icon_cookie1.png"] = Point(-13,13)
modApi:appendAsset("img/combat/icons/tatu_icon_cookie2.png", mod.resourcePath .."img/combat/icons/icon_cookie2_glow.png")
Location["combat/icons/tatu_icon_cookie2.png"] = Point(-13,13)
modApi:appendAsset("img/combat/icons/tatu_icon_cookie3.png", mod.resourcePath .."img/combat/icons/icon_cookie3_glow.png")
Location["combat/icons/tatu_icon_cookie3.png"] = Point(-13,13)

------ Mines ------
local ice_damage = SpaceDamage()
ice_damage.iFrozen = EFFECT_CREATE
ice_damage.sSound = "/props/freezing_mine"
tatu_Cookie_Ice = { Image = "effects/tatu_cookie1.png", Damage = ice_damage, Tooltip = "TATU_ICE_TEXT", Icon = "combat/icons/tatu_icon_cookie1.png", UsedImage = "effects/tatu_cookie_crumbs.png"}

local fire_damage = SpaceDamage()
fire_damage.iFire = EFFECT_CREATE
fire_damage.sSound = "/props/fire_damage"
tatu_Cookie_Fire = { Image = "effects/tatu_cookie2.png", Damage = fire_damage, Tooltip = "TATU_FIRE_TEXT", Icon = "combat/icons/tatu_icon_cookie2.png", UsedImage = "effects/tatu_cookie_crumbs.png"}

local acid_damage = SpaceDamage()
acid_damage.iAcid = EFFECT_CREATE
acid_damage.sSound = "/props/acid_splash"
tatu_Cookie_Acid = { Image = "effects/tatu_cookie3.png", Damage = acid_damage, Tooltip = "TATU_ACID_TEXT", Icon = "combat/icons/tatu_icon_cookie3.png", UsedImage = "effects/tatu_cookie_crumbs.png"}

------ Mission ------
Mission_Candy_Cookies = Mission_Infinite:new{
	Name = "Experimental Cookies",
	MineCount = 8,
	GlobalSpawnMod = 1,
	SpawnStartMod = 0,
	Mines = {"tatu_Cookie_Ice", "tatu_Cookie_Fire", "tatu_Cookie_Acid"},
	BonusPool = {BONUS_GRID, BONUS_MECHS, BONUS_KILL_FIVE, BONUS_PACIFIST, BONUS_BLOCK, BONUS_SELFDAMAGE},--removed pacifist (unreasonably hard) + debris (crowded map as-is)
	MineLocations = {},
}

function Mission_Candy_Cookies:StartMission()
	self.MineLocations = {}
	
	local choices = {}
	local cookies = shallow_copy(self.Mines)
	
	for i = 1, 6 do
		for j = 1, 6 do
			if 	Board:GetTerrain(Point(i,j)) == TERRAIN_ROAD or 
				Board:GetTerrain(Point(i,j)) == TERRAIN_FOREST or
				Board:GetTerrain(Point(i,j)) == TERRAIN_SAND then
			    choices[#choices+1] = Point(i,j)
				cookies[#choices+1] = self.Mines[math.random(1,#self.Mines)]
			end
		end
	end
	
	self.MineCount = math.min(#choices,self.MineCount)
	for i = 1, self.MineCount do
		local point = random_removal(choices)
		self.MineLocations[#self.MineLocations+1] = point
		Board:SetTerrain(point,TERRAIN_ROAD)
		Board:SetItem(point,cookies[i])
	end
end	