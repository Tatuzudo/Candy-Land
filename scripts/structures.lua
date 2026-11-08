local mod = mod_loader.mods[modApi.currentMod]

-- create all of our structures.
CreateStructure{
	Id = "tatu_DonutReactor1",
	Name = "Donut Reactor",
	Path = "img/structures/",
	Image = "donut1",
	ImageOffset = Point(-30,-5),
	Reward = REWARD_POWER
}

CreateStructure{
	Id = "tatu_DonutReactor2",
	Name = "Donut Reactor",
	Path = "img/structures/",
	Image = "donut2",
	ImageOffset = Point(-30,-5),
	Reward = REWARD_POWER
}

CreateStructure{
	Id = "tatu_DonutReactor3",
	Name = "Donut Reactor",
	Path = "img/structures/",
	Image = "donut3",
	ImageOffset = Point(-30,-5),
	Reward = REWARD_POWER
}

CreateStructure{
	Id = "tatu_DonutReactor4",
	Name = "Donut Reactor",
	Path = "img/structures/",
	Image = "donut4",
	ImageOffset = Point(-30,-5),
	Reward = REWARD_POWER
}

CreateStructure{
	Id = "tatu_MacaronReactor1",
	Name = "Tokamakaron",
	Path = "img/structures/",
	Image = "macaron1",
	ImageOffset = Point(-30,-5),
	Reward = REWARD_POWER
}

CreateStructure{
	Id = "tatu_MacaronReactor2",
	Name = "Tokamakaron",
	Path = "img/structures/",
	Image = "macaron2",
	ImageOffset = Point(-30,-5),
	Reward = REWARD_POWER
}

CreateStructure{
	Id = "tatu_MacaronReactor3",
	Name = "Tokamakaron",
	Path = "img/structures/",
	Image = "macaron3",
	ImageOffset = Point(-30,-5),
	Reward = REWARD_POWER
}

CreateStructure{
	Id = "tatu_MacaronReactor4",
	Name = "Tokamakaron",
	Path = "img/structures/",
	Image = "macaron4",
	ImageOffset = Point(-30,-5),
	Reward = REWARD_POWER
}

CreateStructure{
	Id = "tatu_ChocolateFactory",
	Name = "Chocolate Factory",
	Path = "img/structures/",
	Image = "chocolate_factory",
	ImageOffset = Point(-29,-8),
	Reward = REWARD_REP
}

CreateStructure{
	Id = "tatu_Muffin",
	Name = "Giant Muffin",
	Path = "img/structures/",
	Image = "muffin",
	ImageOffset = Point(-29,-8),
	Reward = REWARD_REP
}

CreateStructure{
	Id = "tatu_Brownie",
	Name = "Brownie Lab",
	Path = "img/structures/",
	Image = "brownie",
	ImageOffset = Point(-29,-8),
	Reward = REWARD_TECH
}

CreateStructure{
	Id = "tatu_Cheesecake",
	Name = "Cheesecake Lab",
	Path = "img/structures/",
	Image = "cheesecake",
	ImageOffset = Point(-29,-8),
	Reward = REWARD_TECH
}

-- REWARD_TECH
-- REWARD_POWER
-- REWARD_REP

-- create structure list
local structureList = easyEdit.structureList:add("tatu_Candy_Structure_List")

structureList.name = "Candy Land"

-- add our structures to the structure list
structureList:addAssets(
	"tatu_DonutReactor1",
	"tatu_DonutReactor2",
	"tatu_MacaronReactor1",
	"tatu_MacaronReactor2",
	"tatu_Muffin",
	"tatu_ChocolateFactory",
	"tatu_Brownie",
	"tatu_Cheesecake"
)

local function HOOK_PreMissionAvailable(mission)
	_G["tatu_DonutReactor1"].Image = "donut"..math.random(1,2)
	_G["tatu_DonutReactor2"].Image = "donut"..math.random(3,4)
	_G["tatu_MacaronReactor1"].Image = "macaron"..math.random(1,2)
	_G["tatu_MacaronReactor2"].Image = "macaron"..math.random(3,4)
end

local function EVENT_onModsLoaded()
	modApi:addPreMissionAvailableHook(HOOK_PreMissionAvailable)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)