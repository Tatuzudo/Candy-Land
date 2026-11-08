CreateStructure{
	Id = "tatu_CandyCastle_Str_Tower",
	Name = "Cake Castle",
	Path = "img/structures/",
	Image = "candy_castle",
	-- ImageOffset = Point(-14,-28),
	ImageOffset = Point(-26,-30), -- corporate offset
	Reward = REWARD_REP,
	LargeShield = true,
}

local oldBossInitialize = Mission_Boss.Initialize

function Mission_Boss:Initialize()
	if modApi:getCurrentTileset() == "tatu_Candy_Tileset" then
		self.BonusObjs = {}
		self:AddAsset("tatu_CandyCastle_Str_Tower")
		return
	end
	oldBossInitialize(self)
end

-- just in case
local HOOK_PostMissionAvailable = function(mission)
	if modApi:getCurrentTileset() == "tatu_Candy_Tileset" then
		if mission and mission.BossMission then
			for x = 0, 7 do
				for y = 0, 7 do
					if Board:GetUniqueBuilding(Point(x,y)) == "str_tower1" then
						Board:SetUniqueBuilding(Point(x,y), "candy_castle")
					end
				end
			end
		end
	end
end

local function EVENT_onModsLoaded()
	modApi:addPostMissionAvailableHook(HOOK_PostMissionAvailable)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)