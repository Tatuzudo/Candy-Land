local GOOD = {"( ^-^ )","( ^o^ )","( °uº ) /","/ ( °uº ) /","/ ( ^-^ ) /", "( ^-^ ) /", "/ ( ^o^ ) /"}
local AMAZING = {"/ ( ^-^ ) /", "( ^o^ ) /", "/ ( ^o^ ) /"}
local BAD = {"( `o´ )","( `-´ )","( °nº )","( ´o` )","( ´~` )","/ ( ´n` ) /","( `o´ ) /","( `-´ ) /", "/ ( `o´ ) /", "( ´o` ) /"}
local SAD = {"( °nº )","( ´o` )","( ´~` )","/ ( ´n` ) /", "( ´o` ) /", "( ´~` ) /"}
local ANGRY ={"( `o´ )","( `-´ )","( `~´ )","( `o´ ) /","( `-´ ) /", "( `~´ ) /", "/ ( `O´ ) /"}
local NEUTRAL = {"( º-° )", "( ºo° )", "( º-° ) /", "( ºo° ) /"}
local SURPRISED = {"/ ( ºO° ) /", "/ ( ºO° ) /", "/ ( ºO° )", "/ ( ºO° )"}

return {
    -- Game States
    Gamestart = NEUTRAL,
    FTL_Found = SURPRISED,
    FTL_Start = SURPRISED,
    Gamestart_PostVictory = AMAZING,
    Death_Revived = SURPRISED,
    Death_Main = {"...BEEE...GOOOOD"},
    Death_Response = BAD,
    Death_Response_AI = BAD,
    TimeTravel_Win = GOOD,
    Gameover_Start = SAD,
    Gameover_Response = SAD,
    
    -- UI Barks
    Upgrade_PowerWeapon = GOOD,
    Upgrade_NoWeapon = ANGRY,
    Upgrade_PowerGeneric = GOOD,
    
    -- Mid-Battle
    MissionStart = NEUTRAL,
    Mission_ResetTurn = SURPRISED,
    MissionEnd_Dead = GOOD,
    MissionEnd_Retreat = GOOD,

    PodIncoming = SURPRISED,
    PodResponse = SURPRISED,
    PodCollected_Self = GOOD,
    PodDestroyed_Obs = BAD,
    Secret_DeviceSeen_Mountain = SURPRISED,
    Secret_DeviceSeen_Ice = SURPRISED,
    Secret_DeviceUsed = SURPRISED,

    Secret_Arriving = SURPRISED,
    Emerge_Detected = NEUTRAL,
    Emerge_Success = NEUTRAL,
    Emerge_FailedMech = GOOD,
    Emerge_FailedVek = GOOD,

    -- Mech State
    Mech_LowHealth = SAD,
    Mech_Webbed = ANGRY,
    Mech_Shielded = GOOD,
    Mech_Repaired = GOOD,
    Pilot_Level_Self = AMAZING,
    Pilot_Level_Obs = GOOD,
    Mech_ShieldDown = ANGRY,

    -- Damage Done
    Vek_Drown = AMAZING,
    Vek_Fall = AMAZING,
    Vek_Smoke = GOOD,
    Vek_Frozen = GOOD,
    VekKilled_Self = AMAZING,
    VekKilled_Obs = GOOD,
    VekKilled_Vek = GOOD,

    DoubleVekKill_Self = AMAZING,
    DoubleVekKill_Obs = AMAZING,
    DoubleVekKill_Vek = AMAZING,

    MntDestroyed_Self = NEUTRAL,
    MntDestroyed_Obs = NEUTRAL,
    MntDestroyed_Vek = NEUTRAL,
	
    PowerCritical = BAD,
    Bldg_Destroyed_Self = NEUTRAL,
    Bldg_Destroyed_Obs = BAD,
    Bldg_Destroyed_Vek = ANGRY,
    Bldg_Resisted = SURPRISED,
	
	-- Shared Mission Events
	Mission_Train_TrainStopped = BAD,
	Mission_Train_TrainDestroyed = SAD,
	Mission_Block_Reminder = NEUTRAL,
	
	-- Archive Mission Events
	Mission_Tanks_Activated = GOOD,
	Mission_Tanks_PartialActivated = GOOD,
	Mission_Satellite_Destroyed = BAD,
	Mission_Satellite_Imminent = NEUTRAL,
	Mission_Satellite_Launch = SURPRISED,
	Mission_Dam_Reminder = NEUTRAL,
	Mission_Dam_Destroyed = SURPRISED,
	Mission_Mines_Vek = GOOD,
	
	-- R.S.T. Mission Events
	Mission_Force_Reminder = NEUTRAL,
	Mission_Lightning_Strike_Vek = GOOD,
	Mission_Terraform_Destroyed = SAD,
	Mission_Terraform_Attacks = SURPRISED,
	Mission_Cataclysm_Falling = SURPRISED,
	Mission_Solar_Destroyed = ANGRY,
	
	-- Pinnacle Mission Events
	Mission_FreezeBots_Freed = NEUTRAL,
	Mission_FreezeBots_Dead = NEUTRAL,
	Mission_Factory_Destroyed = BAD,
	Mission_Factory_Spawning = NEUTRAL,
	Mission_Reactivation_Thawed = SURPRISED,
	Mission_Freeze_Mines_Vek = GOOD,
	Mission_SnowStorm_FrozenVek = AMAZING,
	Mission_SnowStorm_FrozenMech = NEUTRAL,
	
	-- Detritus Mission Events
	Mission_Barrels_Destroyed = GOOD,
	Mission_Disposal_Destroyed = SAD,
	Mission_Disposal_Disposal = SURPRISED,
	Mission_Power_Destroyed = BAD,
	Mission_Belt_Mech = GOOD,
	Mission_Teleporter_Mech = AMAZING,
	
	-- Candy Land Mission Events
	Mission_Candy_SeederDestroyed = SAD,
	Mission_Candy_TruckDestroyed = BAD,
	Mission_Candy_UnicornHurt = GOOD,
	Mission_Candy_UnicornDestroyed = ANGRY,
	Mission_Candy_PinataDestroyed = NEUTRAL,
	Mission_Candy_BombDestroyed = SURPRISED,
	Mission_Candy_PicnicStain = BAD,
	Mission_Candy_PicnicTear = SURPRISED,
	Mission_Candy_RainbowRide = AMAZING,
	Mission_Candy_SuperMilkStorm = NEUTRAL,
	
	-- Meridia Mission Events
	Mission_lmn_Convoy_Destroyed = BAD,
	Mission_lmn_FlashFlood_Flood = SURPRISED,
	Mission_lmn_Geyser_Launch_Mech = AMAZING,
	Mission_lmn_Geyser_Launch_Vek = GOOD,
	Mission_lmn_Volcanic_Vent_Erupt_Vek = SURPRISED,
	Mission_lmn_Wind_Push = SURPRISED,
	Mission_lmn_Runway_Imminent = NEUTRAL,
	Mission_lmn_Runway_Crashed = BAD,
	Mission_lmn_Runway_Takeoff = AMAZING,
	Mission_lmn_Greenhouse_Destroyed = ANGRY,
	Mission_lmn_Geothermal_Plant_Destroyed = BAD,
	Mission_lmn_Hotel_Destroyed = SAD,
	Mission_lmn_Agroforest_Destroyed = SAD,
	
	-- Watchtower Mission Events
	Mission_tosx_Sonic_Destroyed = SAD,
	Mission_tosx_Tanker_Destroyed = BAD,
	Mission_tosx_Rig_Destroyed = BAD,
	Mission_tosx_GuidedKill = AMAZING,
	Mission_tosx_NuclearSpread = SURPRISED,
	Mission_tosx_RaceReminder = NEUTRAL,
	Mission_tosx_MercsPaid = GOOD,
	Mission_tosx_RigUpgraded = GOOD,
	
	-- FarLine Mission Events
	Mission_tosx_Delivery_Destroyed = ANGRY,
	Mission_tosx_Sub_Destroyed = SAD,
	Mission_tosx_Buoy_Destroyed = BAD,
	Mission_tosx_Rigship_Destroyed = BAD,
	Mission_tosx_SpillwayOpen = SURPRISED,
	Mission_tosx_OceanStart = NEUTRAL,
	Mission_tosx_RTrain_Destroyed = GOOD,
	
	-- Nautilus Mission Events
	Mission_Nautilus_CrumblingReaction = SURPRISED,
	Mission_Nautilus_ExcavatorDestroyed = SAD,
	Mission_Nautilus_DrillerDestroyed = BAD,
	Mission_Nautilus_BlastChargeDestroyed = NEUTRAL,
	Mission_Nautilus_BlastChargeExploded = AMAZING,
	Mission_Nautilus_RailLayerDamaged = BAD,
	Mission_Nautilus_RailLayerDestroyed = ANGRY,
}