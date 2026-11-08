-- initialize mod
local mod = {
	id = "tatu_candyLand",
	name = "Candy Land",
	description = "Candy Land has a bug problem. Can you help them out?",
	icon = "img/icon.png",
	version = "1.4",
	dependencies = {
		modApiExt = "1.21",
		memedit = "1.1.4",
		easyEdit = "2.0.6",
	},
}

function mod:init()
	self.libs = {}
	self.libs.modApiExt = modapiext
	self.libs.customAnim = require(mod.scriptPath.."libs/customAnim")
	require(mod.scriptPath.."libs/boardEvents")
	require(mod.scriptPath.."libs/queuedBoost")
	require(self.scriptPath.."island")
	require(self.scriptPath.."ceo/ceo")
	require(self.scriptPath.."corporation/pilot")
	require(self.scriptPath.."corporation/corporation")
	require(self.scriptPath.."extra_dialog")
	require(self.scriptPath.."tileset")
	require(self.scriptPath.."gumTiles")
	require(self.scriptPath.."bossList")
	require(self.scriptPath.."enemyList")
	require(self.scriptPath.."structures")
	require(self.scriptPath.."candyCastle")
	require(self.scriptPath.."island_composite")
	require(self.scriptPath.."waterfall")
	require(self.scriptPath.."tosx_compatibility")
	
	self.missions = require(self.scriptPath.."missions/init")
	self.missions:init(self)
	
	require(self.scriptPath.."mission_final")
end

function mod:load(options, version)

end

return mod
