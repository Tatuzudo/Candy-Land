
-- create island
local island = easyEdit.island:add("tatu_Candy_Island")

island.name = "Candy Land"

-- appends all assets in the path relative to mod's resource path
island:appendAssets("img/island/")

-- see the easyEdit wiki for details on everything below
island.shift = Point(25,13)
island.magic = Point(138,89)

island.regionData = {
	RegionInfo(Point(14,14), Point(-30, -20), 100),
	RegionInfo(Point(39,142), Point(-5, -45), 80),
	RegionInfo(Point(103,34), Point(0, -20), 150),
	RegionInfo(Point(120,147), Point(5, -20), 150),
	RegionInfo(Point(190,61), Point(0, -15), 150),
	RegionInfo(Point(221,147), Point(-5, -75), 150),
	RegionInfo(Point(254,18), Point(10, -30), 100),
	RegionInfo(Point(304,101), Point(-10, -30), 150)
}

island.network = {
	{1,2},
	{0,2,3},
	{0,1,3,4},
	{1,2,4,5},
	{2,3,5,6},
	{3,4,6,7},
	{4,5,7},
	{5,6}
}
