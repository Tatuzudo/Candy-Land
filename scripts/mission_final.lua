local bomb = "tatu_Candy_BigBomb"

local oldUpdateObjectives = Mission_Final_Cave.UpdateObjectives
function Mission_Final_Cave:UpdateObjectives()
	if easyEdit.world[2].ceo == "tatu_Candy_CEO" then
		Game:AddObjective("Defend the Chocolate Bomb until it maybe explodes",OBJ_STANDARD,REWARD_REP,0)
	else
		oldUpdateObjectives(self)
	end
end

local oldUpdateMission = Mission_Final_Cave.UpdateMission
function Mission_Final_Cave:UpdateMission()
	if easyEdit.world[2].ceo == "tatu_Candy_CEO" then
		if GetCurrentMission() then
			if Board:IsBusy() then return end
			
			local hasBomb = false
			local pawnList = extract_table(Board:GetPawns(TEAM_PLAYER))
			for i = 1, #pawnList do
				local currPawn = Board:GetPawn(pawnList[i])
				if currPawn:GetType() == bomb then
					hasBomb = true
				end
			end
			
			if not hasBomb then
				local effect = SkillEffect()
				self:AddBomb(effect)
				self.TurnLimit = self.TurnLimit + 2
				Board:AddEffect(effect)
			end
		end
	else
		oldUpdateMission(self)
	end
end

local oldAddBomb = Mission_Final_Cave.AddBomb
function Mission_Final_Cave:AddBomb(effect, bomb_loc)
	if easyEdit.world[2].ceo == "tatu_Candy_CEO" then
		if bomb_loc == nil then
			local choices = {}
			
			for i = 0,7 do
				for j = 0,7 do
					local curr = Point(i,j)
					if Board:GetPawnTeam(curr) ~= TEAM_PLAYER and 
						not Board:IsBuilding(curr) and 
						not Board:IsEnvironmentDanger(curr) then
						choices[#choices+1] = curr
					end
				end
			end
			
			if #choices == 0 then
				LOG("This can't happen. There aren't enough player units or buildings")
				bomb_loc = Point(4,4)
			else
				local choice = random_removal(choices)
				
				while #choices > 0 and (choice.x <= 1 or choice.x >= 6 or choice.y <= 1 or choice.y >= 6) do
					choice = random_removal(choices)
				end
				
				bomb_loc = choice
			end
		end
		
		local add_bomb = SpaceDamage(bomb_loc,0)
		add_bomb.sPawn = bomb
		add_bomb.sSound = "/props/bomb_impact"
		add_bomb.iTerrain = TERRAIN_ROAD
		effect:AddDropper(add_bomb,"units/mission/tatu_chocolate_bomb_ns.png")
	else
		oldAddBomb(self, effect, bomb_loc)
	end
end

-- chage IsBomb to include candy bomb
local oldIsBomb = IsBomb
function IsBomb(p)
	local ret = oldIsBomb(p)
	if p and Board:GetPawn(p) and Board:GetPawn(p):GetType() == bomb then
		ret = true
	end
	return ret
end

-- local function isUnitType(point, team, unitType)
    -- if point ~= nil then
        -- return Board:IsPawnSpace(point) and Board:GetPawn(point):GetType() == unitType
    -- else
        -- local pawns = extract_table(Board:GetPawns(team))
        -- local unit = false
        -- for i, v in ipairs(pawns) do
            -- if Board:GetPawn(v):GetType() == unitType then
                -- unit = true
            -- end
        -- end

        -- return unit
    -- end
-- end

-- local oldIsBomb = IsBomb
-- function IsBomb(p)
    -- return oldIsBomb(p) or isUnitType(p, TEAM_PLAYER, bomb)
-- end

-- pawn
tatu_Candy_BigBomb = {
	Name = "Chocolate Bomb",
	Health = 4,
	Neutral = true,
	Corpse = false,
	IgnoreFire = true,
	MoveSpeed = 0,
	Image = "tatu_chocolate_bomb",
	DefaultTeam = TEAM_PLAYER,
	IsPortrait = false
}
AddPawn("tatu_Candy_BigBomb") 

-- replace bomb on mission end (the endind needs a renfield bomb)
local function HOOK_missionEnd(mission)
	if easyEdit.world[2].ceo == "tatu_Candy_CEO" then
		if mission and mission.ID == "Mission_Final_Cave" then
			local currPawn = -1
			local p = Point(-1,-1)
			local pawnList = extract_table(Board:GetPawns(TEAM_PLAYER))
			for i = 1, #pawnList do
				currPawn = Board:GetPawn(pawnList[i])
				if currPawn:GetType() == bomb then
					p = currPawn:GetSpace()
				end
			end
			currPawn:SetSpace(Point(-1,-1))
			
			local oldImage = _G["BigBomb"].Image
			_G["BigBomb"].Image = "tatu_chocolate_bomb"
			
			local pawn = PAWN_FACTORY:CreatePawn("BigBomb")
			Board:AddPawn(pawn, p)
			
			_G["BigBomb"].Image = oldImage
		end
	end
end

local function EVENT_onModsLoaded()
	modApi:addMissionEndHook(HOOK_missionEnd)
end

modApi.events.onModsLoaded:subscribe(EVENT_onModsLoaded)