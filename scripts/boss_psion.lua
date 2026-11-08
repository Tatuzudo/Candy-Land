local mod = mod_loader.mods[modApi.currentMod]
local path = mod.resourcePath

-- assets
modApi:appendAsset("img/portraits/enemy/tatu_Candy_Psion_Boss.png", path .."img/portraits/enemy/JellyB.png")
modApi:appendAsset("img/units/mission/candy_psion.png", path.."img/units/mission/psion.png")
modApi:appendAsset("img/units/mission/candy_psion_a.png", path.."img/units/mission/psion_a.png")
modApi:appendAsset("img/units/mission/candy_psion_emerge.png", path.."img/units/mission/psion_emerge.png")
modApi:appendAsset("img/units/mission/candy_psion_death.png", path.."img/units/mission/psion_death.png")
modApi:appendAsset("img/units/mission/candy_psion_ns.png", path.."img/units/mission/psion_ns.png")

local a = ANIMS

a.candy_psion = a.BaseUnit:new{Image = "units/mission/candy_psion.png", PosX = -16, PosY = -14}
a.candy_psione = a.BaseEmerge:new{Image = "units/mission/candy_psion_emerge.png", PosX = -23, PosY = -21, Height = 1}
a.candy_psiona = a.candy_psion:new{ Image = "units/mission/candy_psion_a.png", NumFrames = 4 }
a.candy_psiond = a.candy_psion:new{ Image = "units/mission/candy_psion_death.png", PosX = -18, PosY = -14, NumFrames = 8, Time = 0.14, Loop = false }
a.candy_psion_ns = a.candy_psion:new{ Image = "units/mission/candy_psion_ns.png"}

---- mission
Mission_Candy_PsionBoss = Mission_Boss:new{
	Name = "Multiflavored Psion",
	BossPawn = "tatu_Candy_Psion_Boss",
	GlobalSpawnMod = -1,
	BossText = "Destroy the Multiflavored Psion"
}

function Mission_Candy_PsionBoss:StartMission()
	self:StartBoss()
	self:GetSpawner():BlockPawns(
	{"Jelly_Health","Jelly_Explode","Jelly_Regen","Jelly_Armor", "Jelly_Fire", "Jelly_Spider", "Jelly_Boost", -- vanilla
	"DNT_Haste1", "DNT_Nurse1", "DNT_Reactive1", "DNT_Winter1", "DNT_Acid1"}) -- vextra
end

tatu_Candy_Psion_Boss = {
	Name = "Multiflavored Psion",
	Portrait = "enemy/tatu_Candy_Psion_Boss",
	Health = 5,
	Image = "candy_psion",
	ImageOffset = 0,
	MoveSpeed = 3,
	DefaultTeam = TEAM_ENEMY,
	ImpactMaterial = IMPACT_BLOB,
	SoundLocation = "/enemy/jelly/",
	Flying = true,
	Leader = LEADER_BOSS,
	Tooltip = "tatu_Candy_Psion_Boss_Tooltip",
	-- Portrait = "enemy/JellyB",
	Tier = TIER_BOSS,
}

tatu_Candy_Psion_Boss_Tooltip = Jelly_Boss_Tooltip:new{
	Name = "Overfeed",
	Description = "All other Vek gain +1 HP, regeneration, explode on death and become obese.",
	Class = "Passive",
	PathSize = 1,
	TipImage = {
		Unit = Point(2,2),
		Target = Point(2,1),
		CustomPawn = "tatu_Candy_Psion_Boss",
	}
}
	
AddPawn("tatu_Candy_Psion_Boss")


-- status tooltip
local psion_title = "Overfed"
local psion_text = "The Multiflavored Psion is force-feeding all Vek. They gain +1 HP, regeneration, and explode on death. They are also in pain."
local psionboss_title_old = modApi.modLoaderDictionary.Status_psionboss_Title
local psionboss_text_old = modApi.modLoaderDictionary.Status_psionboss_Text

local HOOK_PawnSelected = function(mission, point)
	-- save old text
	psionboss_title_old = modApi.modLoaderDictionary.Status_psionboss_Title
	psionboss_text_old = modApi.modLoaderDictionary.Status_psionboss_Text
	if mission and mission.ID == "Mission_Candy_PsionBoss" then
		-- change text
		modApi.modLoaderDictionary.Status_psionboss_Title = psion_title
		modApi.modLoaderDictionary.Status_psionboss_Text = psion_text
	end
end

local HOOK_PawnDeselected = function(mission, point)
	if mission and mission.ID == "Mission_Candy_PsionBoss" then
		-- load old text
		modApi.modLoaderDictionary.Status_psionboss_Title = psionboss_title_old
		modApi.modLoaderDictionary.Status_psionboss_Text = psionboss_text_old
	end
end

local HOOK_missionEnd = function(mission)
	if mission and mission.ID == "Mission_Candy_PsionBoss" then
		-- load old text
		modApi.modLoaderDictionary.Status_psionboss_Title = psionboss_title_old
		modApi.modLoaderDictionary.Status_psionboss_Text = psionboss_text_old
	end
end

local EVENT_onSquadExited = function(squadid)
	if modApi.modLoaderDictionary.Status_psionboss_Title == psion_title then
		-- load old text
		modApi.modLoaderDictionary.Status_psionboss_Title = psionboss_title_old
		modApi.modLoaderDictionary.Status_psionboss_Text = psionboss_text_old
	end
end

local function EVENT_onModsLoaded()
	modapiext:addPawnSelectedHook(HOOK_PawnSelected)
	modapiext:addPawnDeselectedHook(HOOK_PawnDeselected)
	modApi:addMissionEndHook(HOOK_missionEnd)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)
modApi.events.onSquadExitedGame:subscribe(EVENT_onSquadExited)
