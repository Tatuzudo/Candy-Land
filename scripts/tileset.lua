-- -- waterfall
-- local customWaterfall = require(mod_loader.mods[modApi.currentMod].scriptPath.."libs/customWaterfall")
-- customWaterfall:addWaterfall("tatu_Candy_Tileset")

-- -- rubble test
-- local mod = mod_loader.mods[modApi.currentMod]
-- local path = mod.resourcePath
-- modApi:appendAsset("img/combat/tiles_grass/mountain_explode.png", path .."img/tileset/ground_picnic.png")

-- create tileset
local tileset = easyEdit.tileset:add("tatu_Candy_Tileset", "sand")

tileset.name = "Candy" -- Name of tileset

-- appends all assets in the path relative to mod's resource path
tileset:appendAssets("img/tileset/")

-- display name of the climate in game, displays on island select screen
tileset:setClimate("Candy")

-- percentage chance of a mission having rain
tileset:setRainChance(10)
tileset:setCrackChance(0)

-- percentage chance that a regular ground tile gets changed to the following
tileset:setEnvironmentChance{
	[TERRAIN_ACID] = 0,
	[TERRAIN_FOREST] = 5,
	[TERRAIN_SAND] = 5,
	[TERRAIN_ICE] = 0,
}

-- set custom tooltip text for various tile types
tileset:setTileTooltip{
	tile = "sand",
	title = "Cocoa Powder Tile",
	text = "If damaged, turns into Smoke. \nUnits in Smoke cannot attack or repair."
}
tileset:setTileTooltip{
	tile = "forest",
	title = "Marshmallow Forest Tile",
	text = "If damaged, lights on Fire."
}
tileset:setTileTooltip{
	tile = "forest_fire",
	title = "Marshmallow Forest Fire",
	text = "Lights units on Fire. This fire was started when a Marshmallow Forest was damaged. What a waste."
}

tileset:setTileTooltip{
	tile = "water",
	title = "Milk Tile",
	text = "Units cannot attack in Milk. Most ground or lactose intolerant enemies die in milk."
}

tileset:setTileTooltip{
	tile = "ice",
	title = "Ice Cream Tile",
	text = "Dissolves into Milk when destroyed. Must be hit twice."
}

tileset:setTileTooltip{
	tile = "damaged_ice",
	title = "Damaged Sugar Tile",
	text = "Dissolves in the Milk when destroyed. One hit will destroy it."
}

tileset:setTileTooltip{
	tile = "acid_water",
	title = "Spoiled Milk Tile",
	text = "Behaves like Milk, but inflicts A.C.I.D. on surviving units and is disgusting."
}

tileset:setTileTooltip{
	tile = "mountain",
	title = "Strawberry Tile",
	text = "As big as a Mountain, blocks movement and projectiles. Damage twice to destroy."
}

tileset:setTileTooltip{
	tile = "damaged_mountain",
	title = "Bitten Strawberry",
	text = "As big as a Mountain, blocks movement and projectiles. One hit will destroy it."
}

tileset:setTileTooltip{
	tile = "mnt_rubble",
	title = "Grated Strawberry",
	text = "Once a Strawberry. No special effect."
}

tileset:setTileTooltip{
	tile = "powered",
	title = "Waffer Building",
	text = "Your Power Grid is reduced when Grid Structures are damaged."
}

tileset:setTileTooltip{
	tile = "ground",
	title = "Cake Tile",
	text = "Tasty ground with no special effects."
}

tileset:setTileTooltip{
	tile = "lava",
	title = "Hot Caramel Tile",
	text = "Behaves like Milk, but inflicts Fire on surviving units."
}

tileset:setTileTooltip{
	tile = "lava_ice",
	title = "Frozen Caramel Tile",
	text = "Turns into a Hot Caramel tile when destroyed, but currently safe to stand on."
}

tileset:setTileTooltip{
	tile = "frozen_acid",
	title = "Spoiled Ice Cream Tile",
	text = "Dissolves into Spoiled Milk when destroyed, but currently safe to stand on.",
}

-- mountain rubble reset
local HOOK_postLoadGame = function()
	modApi:conditionalHook(
		function()
			return Board
		end,
		function()
			if modApi:getCurrentTileset() == "tatu_Candy_Tileset" then
				for x = 0, 7 do
					for y = 0, 7 do
						local pos = Point(x,y)
						if Board:IsTerrain(pos,TERRAIN_RUBBLE) and Board:GetRubbleType(pos) == RUBBLE_MOUNTAIN then
							local stats = {
								Pos = pos,
								Acid = Board:IsAcid(pos),
								Item = Board:GetItem(pos),
							}
							Board:SetAcid(pos,false)
							Board:RemoveItem(pos)
							Board:SetTerrain(pos,TERRAIN_MOUNTAIN)
							Board:SetHealth(pos,1,2)
							local damage = SpaceDamage(pos)
							damage.iCrack = EFFECT_CREATE
							Board:DamageSpace(damage)
							Board:SetAcid(pos,stats.Acid)
							Board:SetItem(pos,stats.Item)
						end
					end
				end
			end
		end
	)
end

local function EVENT_onModsLoaded()
	modApi:addPostLoadGameHook(HOOK_postLoadGame) -- on continue and reset turn
	modapiext:addGameLoadedHook(HOOK_postLoadGame) -- on first continue
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)


-- TILE_TOOLTIPS = {
	-- fire = {"Fire Tile", "Lights units on Fire."},
	-- forest = {"Forest Tile", "If damaged, lights on Fire."},
	-- forest_fire = {"Forest Fire", "Lights units on Fire. This fire was started when a Forest Tile was damaged."},
	-- smoke = {"Smoke Tile", "Units in Smoke cannot attack or repair."},
	-- electric_smoke = {"Electric Smoke", "Units in Smoke cannot attack or repair. \nElectricity damages enemy units."},
	-- emerging = { "Vek Emerging", "Enemy emerging next turn. Can be blocked."},
	-- critical = { "Critical", "This building is important to mission objectives." },
	-- pylon = { "Power Pylon", "Remote Power Pylons connect your Mechs to the Grid even underground. Not populated."},
	-- supervolcano = { "Super Volcano", "Indestructible volcano that blocks movement and projectiles."},
	-- powered = { "Civilian Building", "Your Power Grid is reduced when Grid Structures are damaged." },
	-- evacuated = { "Evacuated Building", "No effect when damaged." },
	-- building_rubble = { "Building Rubble", "No special effect." },
	-- mnt_rubble = {"Mountain Rubble", "No special effect." },
	-- ice = {"Ice Tile", "Turns into Water when destroyed. Must be hit twice."},
	-- acid_ice = {"A.C.I.D. Ice", "Turns into an A.C.I.D. tile when destroyed, but currently safe to stand on."},
	-- lava_ice = {"Frozen Lava", "Turns into a Lava tile when destroyed, but currently safe to stand on."},
	-- damaged_ice = {"Damaged Ice Tile", "Turns into a Water tile when destroyed. One hit will destroy it."},
	-- chasm = {"Chasm Tile", "Ground units pushed in will be \ndestroyed."},
	-- ground = { "Ground Tile", "No special effect."},
	-- sand = { "Sand Tile", "If damaged, turns into Smoke. \nUnits in Smoke cannot attack or repair." },
	-- mountain = { "Mountain Tile", "Blocks movement and projectiles. Damage twice to destroy." },
	-- damaged_mountain = { "Damaged Mountain", "Blocks movement and projectiles. One hit will destroy it." },
	-- water = { "Water Tile", "Units cannot attack in Water. Most non-flying enemies die in Water."},
	-- acid_water = { "A.C.I.D. Tile", "Behaves like Water, but inflicts A.C.I.D. on surviving units."},
	-- lava = {"Lava Tile", "Behaves like Water, but inflicts Fire on surviving units."},
	-- acid = { "A.C.I.D. Pool", "Inflicts A.C.I.D. on the 1st unit that steps on this space."},
	-- frozen_acid = { "Frozen A.C.I.D.", "Low temperatures have rendered the A.C.I.D. on this tile inert."},
	-- pod = {"Time Pod", "Destroyed if damaged or trampled by the enemy. Collect with a Mech, or defend until Vek retreat."},
	-- ftl_pod = {"Strange Pod", "Destroyed if damaged or trampled by the enemy. Collect with a Mech, or defend until Vek retreat."},
	-- ftl_button = {"Strange Object", "You're not sure what this could be."},
	-- ftl_button_destroyed = {"Destroyed Object", "You're not sure what this was, but it's gone now."},
	-- frozen_powered = { "Frozen Building", "Invincible while Frozen. Any damage will destroy the ice." },
	-- spawning = {"Emerging", "Vek will emerge here next turn. Any unit blocking this space will take one damage."},
	-- high_tide = {"High Tide","This tile will become Water at the start of the enemy turn."},
	-- air_strike = {"Air Strike", "Bombs will be dropped here, instantly killing any unit."},
	-- old_earth_mine = {"Old Earth Mine", "Any unit that stops on this space will trigger the mine and be killed."},
	-- freeze_mine = {"Freeze Mine", "Any unit that stops on this space will be Frozen."},
	-- evacuation = {"Evacuating", "This building will be evacuated \nnext turn."},
	-- seismic = {"Seismic Activity", "This tile will become a Chasm at the start of the enemy turn."},
	-- lightning = {"Lightning Strike", "Lightning will strike here, killing any unit."},
	-- falling_rock = {"Falling Rock", "A rock will fall here, killing any unit."},
	-- tentacle_lava = {"Tentacles", "The unit here will die and the tile will turn into Lava."},
	-- volcano_lava = {"Lava Flow", "The tile here will turn into Lava."},
	-- flying_rock = {"Volcanic Projectile", "A fireball will strike here, destroying anything present."},
	-- ice_storm = {"Ice Storm", "The storm causes anything present to become Frozen."},
	-- grassland = {"Grassland", "Your bonus objective is to terraform Grassland tiles into Sand."},
	-- terraformed = {"Terraformed", "This tile was terraformed as part of your bonus objective."},
	-- stasis = {"Stasis Bot", "This bot will power up and enter the fight if its Shield is damaged."},
	
	-- belt = {"Conveyor Belt", "This tile will push any unit in the direction marked on the belt."},
	
	-- tele = {"Teleporter Pad", "End movement here to warp to the matching pad. Swap with any present unit."},
	
	-- supply_drop = { "Supply Drop", "Collect this with a Mech to heal ALL friendly units and restore ALL limited use weapons." },	
-- }