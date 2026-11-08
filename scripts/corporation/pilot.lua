
local path = GetParentPath(...)
local pilot_dialog = require(path.."pilot_dialog")

local mod = modApi:getCurrentMod()
local resourcePath = mod.resourcePath

-- add pilot images
modApi:appendAsset("img/portraits/npcs/tatu_candy_pilot.png", resourcePath.."img/corp/pilot.png")
modApi:appendAsset("img/portraits/npcs/tatu_candy_pilot_2.png", resourcePath.."img/corp/pilot_2.png")
modApi:appendAsset("img/portraits/npcs/tatu_candy_pilot_blink.png", resourcePath.."img/corp/pilot_blink.png")

-- create personality
local personality = CreatePilotPersonality("tatu_candy_pilot")
personality:AddDialogTable(pilot_dialog)

-- add our personality to the global personality table
Personality["tatu_candy_pilot"] = personality

-- create pilot
-- reference the personality we created
-- reference the pilot images we added
local names = {
	"Mongo",
	"Biscuit",
	"Gingys Crumb",
	"Snickerdoodle",
	"Crispy",
	"Yummy",
	"Sprinkles",
	"Maple Syrup",
	"Ginger Joe",
	"Ginger George",
	"Ginger Ginny",
	"Butterscotch",
	"Chip",
	"Cleopastry",
	"Peanut Butter",
	"Raspudin",
	"Count Coconut",
	"Lady Licorice",
	"Crumbly",
	"Cookie Cook",
	"Crunchy",
	"Juan Alfajor",
	"Custard Cream",
	"Jammie Dodger",
	"Melomakarona",
	"Tim Tam",
	"Honey Cake",
	"Shortbread",
	"Amaretti",
	"Cracker"
}

CreatePilot{
	Id = "tatu_candy_pilot",
	Name = names[math.random(1,#names)],
	Personality = "tatu_candy_pilot",
	Rarity = 0,
	Cost = 1,
	Sex = 99,--"Candy",
	Portrait = "npcs/tatu_candy_pilot",
	Voice = "/voice/acid",
}

modApi:addPilotDrop{id = "tatu_candy_pilot", recruit = true }

local function HOOK_PreMissionAvailable(mission)
	_G["tatu_candy_pilot"].Name = names[math.random(1,#names)]
end

local function EVENT_onModsLoaded()
	modApi:addPreMissionAvailableHook(HOOK_PreMissionAvailable)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)
