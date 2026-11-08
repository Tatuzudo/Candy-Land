local cakeTitle = "Cake Tile"
local cakeText = "Tasty ground with no special effects."
local groundTitle = ""
local groundText = ""
local milkTitle = "Milk Tile"
local milkText = "Units cannot attack in Milk. Most ground or lactose intolerant enemies die in milk."
local waterTitle = ""
local waterText = ""

local HOOK_tileHighlighted = function(mission, point)
	if modApi:getCurrentTileset() == "tatu_Candy_Tileset" then
		-- save old text
		groundTitle = modApi.modLoaderDictionary["Tile_ground_Title"]
		groundText = modApi.modLoaderDictionary["Tile_ground_Text"]
		waterTitle = modApi.modLoaderDictionary["Tile_water_Title"]
		waterText = modApi.modLoaderDictionary["Tile_water_Text"]
		-- change text
		modApi:runLater(function() -- run it later to prevent other mods from overriding this
			if Board:GetCustomTile(point) == "" then
				if Board:GetTerrain(point) == TERRAIN_ROAD then
					modApi.modLoaderDictionary["Tile_ground_Title"] = cakeTitle
					modApi.modLoaderDictionary["Tile_ground_Text"] = cakeText
				elseif Board:GetTerrain(point) == TERRAIN_WATER then
					modApi.modLoaderDictionary["Tile_water_Title"] = milkTitle
					modApi.modLoaderDictionary["Tile_water_Text"] = milkText
				end
			end
		end)
	end
end

local HOOK_tileUnhighlighted = function(mission, point)
	if modApi:getCurrentTileset() == "tatu_Candy_Tileset" then
		modApi:runLater(function() -- possibly not needed
			if Board:GetCustomTile(point) == "" then
				if Board:GetTerrain(point) == TERRAIN_ROAD then
					modApi.modLoaderDictionary["Tile_ground_Title"] = groundTitle
					modApi.modLoaderDictionary["Tile_ground_Text"] = groundText
				elseif Board:GetTerrain(point) == TERRAIN_WATER then
					modApi.modLoaderDictionary["Tile_water_Title"] = waterTitle
					modApi.modLoaderDictionary["Tile_water_Text"] = waterText
				end
			end
		end)
	end
end

local HOOK_missionEnd = function(mission)
	if modApi:getCurrentTileset() == "tatu_Candy_Tileset" then
		modApi.modLoaderDictionary["Tile_ground_Title"] = groundTitle
		modApi.modLoaderDictionary["Tile_ground_Text"] = groundText
		modApi.modLoaderDictionary["Tile_water_Title"] = waterTitle
		modApi.modLoaderDictionary["Tile_water_Text"] = waterText
	end
end

local function EVENT_onModsLoaded()
	modapiext:addTileHighlightedHook(HOOK_tileHighlighted)
	modapiext:addTileUnhighlightedHook(HOOK_tileUnhighlighted)
	modApi:addMissionEndHook(HOOK_missionEnd)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)