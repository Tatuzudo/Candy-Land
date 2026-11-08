local mod = mod_loader.mods[modApi.currentMod]
local path = mod.scriptPath

-- create boss list
local bossList = easyEdit.bossList:add("tatu_Candy_Boss_List")
local rst = easyEdit.bossList:get("rst")

bossList.name = "Candy Land"

bossList:copy(rst)

-- replace goo and psion boss
require(path.."boss_gumdrop")
require(path.."boss_psion")
bossList["Bosses"][1] = "Mission_Candy_GumdropBoss"
bossList["Bosses"][7] = "Mission_Candy_PsionBoss"