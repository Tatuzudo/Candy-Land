local mod = mod_loader.mods[modApi.currentMod]
local path = mod.resourcePath

-- sprites --
modApi:appendAsset("img/units/mission/tatu_candy_train.png", path .."img/units/mission/train.png")
modApi:appendAsset("img/units/mission/tatu_candy_train_damaged.png", path .."img/units/mission/train_damaged.png")
modApi:appendAsset("img/units/mission/tatu_candy_train_damaged_death.png", path .."img/units/mission/train_damaged_death.png")
modApi:appendAsset("img/units/mission/tatu_candy_train_broken.png", path .."img/units/mission/train_broken.png")

ANIMS.tatu_candy_train = ANIMS.BaseUnit:new{ Image = "units/mission/tatu_candy_train.png", PosX = -51, PosY = 3 }
ANIMS.tatu_candy_train_broken = ANIMS.BaseUnit:new{ Image = "units/mission/tatu_candy_train.png", PosX = -51, PosY = 3 }
ANIMS.tatu_candy_train_damaged = ANIMS.BaseUnit:new{ Image = "units/mission/tatu_candy_train_damaged.png", PosX = -51, PosY = 3 }
ANIMS.tatu_candy_train_damagedd = ANIMS.BaseUnit:new{ Image = "units/mission/tatu_candy_train_damaged_death.png", PosX = -51, PosY = 3, NumFrames = 12, Time = 0.14, Loop = false }
ANIMS.tatu_candy_train_damaged_broken = ANIMS.BaseUnit:new{ Image = "units/mission/tatu_candy_train_broken.png", PosX = -51, PosY = 3 }

-- mission --
Mission_Candy_Train = Mission_Infinite:new{
	Name = "Candy Train",
	Objectives = Objective("Mission_Train_Obj",2),
	ObjectiveId = "Mission_Train_Obj",
	MapTags = {"train"},
	Train = -1,
	TrainLoc = Point(-1,-1),
	TurnLimit = 3,
	TrainStopped = false,
	UseBonus = false,
	TrainPawn = "tatu_Candy_Train_Pawn",
	TrainDamaged = "tatu_Candy_Train_Damaged",
}

function Mission_Candy_Train:StartMission()
	local train = PAWN_FACTORY:CreatePawn(self.TrainPawn)
	self.Train = train:GetId()
	Board:AddPawn(train,Point(4,6))
end

function Mission_Candy_Train:IsTrainAlive()
	return Board:IsPawnAlive(self.Train)
end	

function Mission_Candy_Train:UpdateObjectives()
	local status1 = not self.TrainStopped and OBJ_STANDARD or OBJ_FAILED
	
	if status1 == OBJ_FAILED then
		local status2 = self:IsTrainAlive() and OBJ_STANDARD or OBJ_FAILED
		
		if status2 == OBJ_FAILED then
			Game:AddObjective(self.ObjectiveId, status2, REWARD_REP, 2)
		else
			Game:AddObjective(self.ObjectiveId.."_Damaged", status2, REWARD_REP, 2, 1)
		end
	else
		Game:AddObjective(self.ObjectiveId,status1, REWARD_REP, 2)
	end
end

function Mission_Candy_Train:GetCompletedObjectives()
	if self:IsTrainAlive() then
		if self.TrainStopped then
			return Objective(self.ObjectiveId.."_PostDamaged", 1, 2)
		else
			return self.Objectives
		end
	end
	
	return self.Objectives:Failed()
end

function Mission_Candy_Train:StopTrain()
	local trainPawn = Board:GetPawn(self.Train)
	if trainPawn then Board:RemovePawn(trainPawn) end
	
	local train = PAWN_FACTORY:CreatePawn(self.TrainDamaged)
	self.Train = train:GetId()
	Board:AddPawn(train,self.TrainLoc)
	self.TrainStopped = true
end

function Mission_Candy_Train:UpdateMission()
	local trainPawn = Board:GetPawn(self.Train)
		
	if not self:IsTrainAlive() then
		if not self.TrainStopped then
			self:StopTrain()
			return
		end
	end
	
	if trainPawn == nil then
		return
	end
	
	self.TrainLoc = trainPawn:GetSpace()
	
	if self.TrainStopped then
		trainPawn:SetActive(false)
	end
end

------- UNIT AND SKILLS FOR THE MISSION -------------------

tatu_Candy_Train_Pawn = 
{
	Name = "Sugar Train",
	Health = 1,
	Neutral = true,
	Image = "tatu_candy_train",
	MoveSpeed = 0,
	SkillList = { "tatu_Candy_Train_Move" },
	DefaultTeam = TEAM_PLAYER,
	IgnoreSmoke = true,
	IgnoreFlip = true,
	IgnoreFire = true,
	ExtraSpaces = { Point(0,1) },
	SoundLocation = "/support/train",
	Pushable = false,
	Corporate = true,
	Corpse = true
}
AddPawn("tatu_Candy_Train_Pawn") 

tatu_Candy_Train_Damaged = 
{
	Name = "Damaged Train",
	Health = 1,
	Neutral = true,
	IgnoreFire = true,
	Image = "tatu_candy_train_damaged",
	MoveSpeed = 0,
	SkillList = { },
	DefaultTeam = TEAM_PLAYER,
	Corpse = true,
	SoundLocation = "/support/train",
	ExtraSpaces = { Point(0,1) },
	Pushable = false,
	Corporate = true
}
AddPawn("tatu_Candy_Train_Damaged")

tatu_Candy_Train_Move = Train_Move:new{
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,2),
		CustomPawn = "tatu_Candy_Train_Pawn"
	}
}