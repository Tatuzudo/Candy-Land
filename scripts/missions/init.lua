local this = {}
local mod = mod_loader.mods[modApi.currentMod]
local resourcePath = mod.resourcePath
local path = mod.scriptPath.."missions/"

local function file_exists(name)
	local f = io.open(name, "r")
	if f then io.close(f) return true else return false end
end

local HIGH_THREAT = true
local LOW_THREAT = false

local BASE_MISSIONS = {
	{"Survive", LOW_THREAT},
}

local Candy_Missions = {
	{"Cookies",LOW_THREAT},
	{"Milk",LOW_THREAT},
	{"Rainbows",LOW_THREAT},
	{"Gum",LOW_THREAT},
	{"Gumdrop", LOW_THREAT},
	{"Picnic",LOW_THREAT},
	{"Pinatas", HIGH_THREAT},
	{"Unicorn", HIGH_THREAT},
	{"Strawberry", HIGH_THREAT},
	{"Icecream", HIGH_THREAT},
	{"Train", HIGH_THREAT},
	{"Bomb", HIGH_THREAT},
}

function this:init(mod)
	-- create mission list
	local missionList = easyEdit.missionList:add("tatu_Candy_Mission_List")
	missionList.name = "Candy Land"

	for _, table in ipairs(BASE_MISSIONS) do
		local name = "Mission_"..table[1]
		local threat = table[2]
		missionList:addMission(name, threat)
	end

	for _, table in ipairs(Candy_Missions) do
		local name = table[1]
		local mission_name = "Mission_Candy_"..name
		local threat = table[2]
		require(path..string.lower(name))
		missionList:addMission(mission_name, threat)

		--Icons
		local icon = "img/strategy/mission/"..mission_name..".png"
		local small_icon = "img/strategy/mission/small/"..mission_name..".png"

		if file_exists(resourcePath..icon) then --Could convert to appendAssets?
			modApi:appendAsset(icon, resourcePath..icon)
		end
		if file_exists(resourcePath..small_icon) then
			modApi:appendAsset(small_icon, resourcePath..small_icon)
		end
	end
	
	Global_Texts["TipTitle_Env_Candy_Milk"] = "Milk Storm"
	Global_Texts["TipText_Env_Candy_Milk"] = "A milk storm will fall in an increasing number of spaces every turn, turning them into milk."
	merge_table(TILE_TOOLTIPS, {
		TATU_RAINBOW_TILE = {"Rainbow", "Units that stop here will be boosted and launched to the other end of the rainbow."},
		TATU_ICE_TEXT = {"Mint Cookie", "A dangerously refreshing cookie that will freeze you from the inside out."},
		TATU_FIRE_TEXT = {"Pepper Cookie", "Not for the faint of heart, this cookie will leave your mouth burning for hours."},
		TATU_ACID_TEXT = {"Lemon Cookie", "An extremely citric cookie. Avoid if you suffer from gastritis."},
		TATU_SWEETS_TEXT = {"Pinata Entrails", "A mysterious candy mix with boosting and healing properties."},
		TATU_MILK = {"Milk Storm", "It will rain milk here, flooding this tile."},
	})
end

return this
