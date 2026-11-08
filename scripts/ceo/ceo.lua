local mod = mod_loader.mods[modApi.currentMod]
local options = mod_loader.currentModContent[mod.id].options
local path = GetParentPath(...)
local dialog = require(path.."dialog")
local dialog_missions = require(path.."dialog_missions")

-- create personality
local personality = CreatePilotPersonality("tatu_Candy_CEO", "Cherry Cake") --Second argument is CEO name, don't change the first
personality:AddDialogTable(dialog)
personality:AddDialogTable(dialog_missions)

-- create ceo
local ceo = easyEdit.ceo:add("tatu_Candy_CEO")
ceo:setPersonality(personality)
ceo:setPortrait("img/ceo/portrait.png")
ceo:setOffice("img/ceo/office.png", "img/ceo/office_small.png")
-- ceo:setFinalMission("Mission_Candy_Final")
