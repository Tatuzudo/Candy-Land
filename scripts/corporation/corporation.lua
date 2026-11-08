
-- create corporation
local corporation = easyEdit.corporation:add("tatu_Candy_Corporation")
corporation.Name = "Candy Land" --Full name of island, displays on CEO intro screen
corporation.Bark_Name = "Candy Land" --Name of island used in most places like pilot barks etc.
corporation.Description = "A delicious land currently being devoured by the Vek despite (read because) all efforts to repel them with tasty candy weapons." -- Description of island, seen on island select screen
corporation.Color = GL_Color(55,43,29)
corporation.Map = { "/music/acid/map" } --Music for island
corporation.Music = {
	"/music/sand/combat_guitar",		--Old War Machines
	"/music/sand/combat_new",			--The Big One (AE)
	"/music/snow/combat_zimmer",		--Blitzkreig
	"/music/general/ominous_master",	--Reprocessing
}

-- reference the pilot id created in pilot.lua
corporation.Pilot = "tatu_candy_pilot"

----------------
-- music list --
----------------

-- OST: https://benprunty.bandcamp.com/album/into-the-breach-soundtrack
-- AE OST: https://benprunty.bandcamp.com/album/into-the-breach-advanced-edition-soundtrack

-- Archive
-- "/music/grass/map"				--Old Earth (Map)
-- "/music/grass/combat_delta"		--Relics
-- "/music/grass/combat_gamma"		--Antiquity Row
-- "/music/sand/combat_guitar"		--Old War Machines
-- "/music/grass/combat_new"		--Kai Miller (AE)

-- R.S.T.
-- "/music/sand/map"				--Red Sand (Map)
-- "/music/sand/combat_western"		--The Blast Garden
-- "/music/sand/combat_eastwood"	--Cataclysm
-- "/music/sand/combat_montage"		--Rusting Hulks
-- "/music/sand/combat_new"			--The Big One (AE)

-- Pinnacle
-- "/music/snow/map"				--Zenith (Map)
-- "/music/snow/combat_ice"			--Pinnacle Robotics
-- "/music/snow/combat_zimmer"		--Blitzkreig
-- "/music/snow/combat_train"		--Rift Riders
-- "/music/snow/combat_new"			--Plasmodia (AE)

-- Detritus
-- "/music/acid/map"				--Detritus (Map)
-- "/music/acid/combat_synth"		--The Wasteland
-- "/music/general/ominous_master"	--Reprocessing
-- "/music/acid/combat_detritus"	--A.C.I.D.
-- "/music/acid/combat_new"			--Mist Eaters(AE)


-- Game:TriggerSound()
