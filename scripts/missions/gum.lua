Mission_Candy_Gum = Mission_Infinite:new{
	Name = "Sticky Situation",
	GumCount = 16, 
	UseBonus = true,
}

function Mission_Candy_Gum:StartMission()
	local choices = {}
	for i = 0, 7 do
		for j = 0, 7 do
			local gumType = math.random(0,2)
			if Board:GetTerrain(Point(i,j)) == TERRAIN_FOREST or Board:GetTerrain(Point(i,j)) == TERRAIN_SAND then
				Board:SetTerrain(Point(i,j),TERRAIN_ROAD)
				Board:SetCustomTile(Point(i,j),"tatu_gum_"..gumType..".png")
			elseif Board:GetTerrain(Point(i,j)) == TERRAIN_ROAD then
			    choices[#choices+1] = Point(i,j)
			end
		end
	end
	
	self.GumCount = math.min(#choices,self.GumCount)
	for i = 1, self.GumCount do
		local gumType = math.random(0,2)
		local point = random_removal(choices)
		Board:SetCustomTile(point,"tatu_gum_"..gumType..".png")
	end
end