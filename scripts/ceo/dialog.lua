-- Table of responses to various events.
return {
	Welcome_Message = {
		"I'm glad you are here, commander, and not a moment too soon. The Vek just devoured our forces and are heading to the lollipop fields. We must act quickly.",
		"I don't know why you're laughing, commander. Candy Land is being devoured as we speak. Just yesterday, Licorice Frolic fell to the vile beasts.",
		"Welcome, commander. You arrived just in time for my afternoon tea party. Please, take a sit next to Mr. Gummy Bunny and let's discuss business.",
		"My candy kingdom and I are eternally grateful for your help. Now come, brave warriors. Jolly Jellybean Fortress is in need of reinforcements.",
	},
	Island_Perfect = {
		"The citizens of Candy Land will forever remember your valiant deeds. Please, help yourselves to the many treats of our land.",
		"You succeeded in every task and saved the kingdom from certain doom. Allow us to repay your bravery with a gift of our own.",
	},
	Region_Names = [[   
		Mallow Marsh,
		Rainbow Road,
		Gummy Garden,
		Brownie Basin,
		Sprinkled Shore,
		Licorice Lane,
		Tea Terrace,
		Glycemic Grove,
		Vanilla Valley,
		Almond Alley, 
		Jelly Jungle,
		Taffy Town,
		Bubblegum Bay,
		Cream Coast,
		Fudge Forest,
		Honey Haven,
		Chocolate Cove,
		Caramel Canyon,
		Cookie Cliff,
		Yummy Yard,
		Mount Maple,
		Milky Moor,
		Gumball Grotto,
		Soda Springs,
		Gumdrop Gulch
	]], 
	
	-- Game States
	Mission_Candy_PicnicStain = {
		"Is that a stain I see on my blanket? I'm watching you, pilots.",
	},
	
	Mission_Candy_PicnicTear = {
		"Is that a hole on my blanket?!",
	},
	
	Death_Response = { 
		"The Vek will regret this! Our vengeance will be sweetft!",
		"They seek to break our spirits, but we shall not succrumb!",
		"May your soul find its way to the caramel halls, brave warrior.",
	},
	Death_Response_AI = {
		"I'm sure our Oompa Loompas can fix this. Keep fighting!",
		"That mech has been reduced to crumbs. I'll order some bubblegum to mend it at once.",
		"We can bake a new machine for you. Concentrate on the fight ahead!",
	},
	Gameover_Start = {
		"The Vek ate the very foundation of our island. I's all ssiiinnkiiing!",
		"This is the end, isn't it?",
	},
	Gameover_Response = {
		"The bitter taste of defeat...", 
		"I must go down with my kingdom. Farewell, #squad.", 
	},
	
	-- Mid-Battle
	MissionStart = {
		"Remember, #squad. Thousands of innocent gummy bears are counting on you.",
		"Make these abominations regret eating our land, #squad!",
		"Send the Vek crawling back to the abyss they came from. Charge!",
	},
	Mission_ResetTurn = {
		"What was that? I feel dizzy.",
		"I can't help but feel we just did a terrible thing.",
		"What's that, an important message from my future self? Seems to be cookie-related.",
	},
	MissionEnd_Dead = {
		"The creatures are all dead. That's what they get for eating my land.",
		"Sweetly done. No bugs left alive in these lands.",
		"They won't be bugging us anymore, that's for sure.",
	},
	MissionEnd_Retreat = {
		"The Vek are on the run. I hope they don't return for a snack.",
		"Yeah you better run, Vek. And don't come back!",
		"They are going away. It must be past their bedtime.",
	},
	
	PodIncoming = {
		"Is that a shooting star? I hope it lands on a Vek.",
		"A gift from the sky! Grab it before the Vek do.",
	},
	PodResponse = {
		"Imagine all the recipes that could be hidden in there. We have to grab that pod!",
		"Recover that pod, it must be full of invaluable ingredients!",
	},
	--PodCollected_Self = {},
	PodDestroyed_Obs = {
		"I think I heard a scream... No, it must have been my imagination.",
		"Don't worry, I'm sure there was nothing important in there.",
	},
	--Secret_DeviceSeen_Mountain = {},
	--Secret_DeviceSeen_Ice = {},
	--Secret_DeviceUsed = {},
	--Secret_Arriving = {},
	Emerge_Detected = {
		"A Vek is coming up. Keep it underground or it will devour more of our land!",
		"Candy Land is in your hands, #squad. Don't let that Vek reach the surface!",
		"You can't let that Vek emerge, #squad. Stop it before is too late!",
	},
	--Emerge_Success = {},
	--Emerge_FailedMech = {},
	--Emerge_FailedVek = {},

	-- Mech State
	--Mech_LowHealth = {},
	--Mech_Webbed = {},
	--Mech_Shielded = {},
	--Mech_Repaired = {},
	--Pilot_Level_Self = {},
	--Pilot_Level_Obs = {},
	--Mech_ShieldDown = {},

	-- Damage Done
	Vek_Drown = {
		"Who would know the Vek are lactose intolerant?",
		"Looks like that Vek needs some swimming lessons.",
		"That Vek got a little too thirsty for its own good.",
	},
	Vek_Fall = {
		"That's right, Vek. You better stay down this time.",
		"That Vek just pulled a disappearing act.",
		"Nothing could survive this fall, not after eating so much.",
	},
	Vek_Smoke = {
		"Smoked Vek, I'll add it to my book of recipes.",
		"Smoking is not good for your health, Vek.",
		"You shouldn't smoke, Vek. It's not a good example for the spiderlings.",
	},
	Vek_Frozen = {
		"I wonder what a Vek ice cream tastes like.",
		"Sweet. We were getting out of ice cream.",
		"Yes, more Vek ice cream please.",
	},
	--VekKilled_Self = {},
	VekKilled_Obs = {
		"That vile creature didn't stand a chance.",
		"One less Vek to worry about.",
	},
	VekKilled_Vek = {
		"So uncivilized.",
		"The sugar rush is too much for them to handle.",
		"They are competing for candy. Foolish creatures.",
	},
	--DoubleVekKill_Self = {},
	DoubleVekKill_Obs = {
		"Very impressive! Here's a cookie.",
		"You sure are good at murder, aren't you?",
	},
	DoubleVekKill_Vek = {
		"They are so dumb, it's almost adorable.",
		"Which side is that bug on again? We should adopt it.",
	},
	
	--MntDestroyed_Self = {},
	MntDestroyed_Obs = {
		"No! Don't do that to ours strawberries.",
		"What are you doing, #main_second? Leave that strawberry alone.",
		"What did that strawberry do to deserve this?",
	},
	
	MntDestroyed_Vek = {
		"They are eating our strawberries, vile beasts!",
		"You will regret eating that strawberry, Vek!",
		"You monster! That was an innocent strawberry!",
	},
	
	PowerCritical = {
		"The power grid is on the verge of crumbling!",
		"There is almost no power grid left! Don't let it fail.",
		"One more bite and the power grid is gone!",
	},
	--Bldg_Destroyed_Self = {},
	Bldg_Destroyed_Obs = {
		"You were the chosen one! It was said that you would destroy the Vek, not join them!",
		"No, the buildings are not for eating. How many times must I repeat myself?",
		"What was that, #main_second? Go to your room and think about your actions!",
	},
	Bldg_Destroyed_Vek = {
		"We're gonna end you, Vek. You will regret this!",
		"Not even the crumblings survived...",
		"You will regret eating our candy, Vek. I swear it!",
	},
	Bldg_Resisted = {
		"Hardened caramel, as tough as steel.",
		"See that, commander? This is what a well baked building can do.",
		"Our Oompa Loompas did a great job with that building.",
	},
	
	-- Generic Missions
	Mission_Generic_Briefing = {
		"I can't bear the thought of those bugs gnawing my helpless gummy citizens. Do whatever it takes to stop them.", 
		"I wish I could join you in battle, but it's nap time. Good luck, brave warriors!", 
		"Let's show the Vek who is in charge here... Just to be clear, it's me. I'm in charge.", 
		"This region is home to the peaceful gingerbread folk. They don't stand a chance without you to protect them.",
		"We must act quickly, commander. The Vek are eating this place and we have precious little time before I have to be tucked in.",
	},
	Mission_Generic_Success = {
		"This mission was a complete success, #squad. You bake me proud!",
		"Well done, commander. Please accept this lollipop as a token of my gratitude.",
		"The entire kingdom extends their thanks, #squad. Now, who's ready for some celebratory candy corn?",
		"The Vek certainly bitten off more than they could chew. We are getting closer to victory.",
		"Very good, commander. You and your team deserve a snack after this one.",
	},
	Mission_Generic_Failure = {
		"Sorry #squad, but no dessert for you tonight after what happened here.",
		"We can't sugarcoat this one. I'm sorry commander, but you are grounded.",
		"Sorry, I asked too much of your team. I should have seen this was a recipe for disaster.",
		"I know you tried your best, but this failure will affect our cookie production, and this is absolutely unacceptable.",
		"Your strategy was a bit half-baked, but we'll cook up a better plan next time.",
	},
	
	-- Unsure if these should be filled in or not.
	--Mission_Survive_Briefing = {},
	--Mission_Survive_Success = {},
	--Mission_Survive_Failure = {},
	
	-- >=3 grid damage during a mission.
	Mission_ExtremeDamage = {
		"So much destruction, biscuit pieces and crumbs everywhere.", 
		"Manny good gummy citizens were lost today. This is a sour day in Candy Land.", 
		"These buildings were full of defenseless, delicious citizens. This can't happen again.", 
		"I can hear the jolly jelly beans screaming. So much suffering...",
	},
	
	-- dead pilots
	Mission_Mechs_Dead = {
		"I'm deeply sorry for the loss of your pilots. They will be remembered forever as heroes.",
		"This is a sad day in Candy Land. The sacrifice of your team will never be forgotten.",
		"Candy Land stands in sorrow. We honor those who fought and gave everything to protect us.", 
	},
	
	-- Generic Objectives
	-- Lose less than x mech health
	Mission_MechHealth_Briefing = {
		"Be careful with your mechs out there. We are short on bubblegum to glue them if they break.",
		"Our Oompa Loompas are very good with candy structures, but they are not prepared to repair your mechs. Keep them safe.",
		"Do not damage your mechs. We will need all the bubblegum we can get to repair the nearby villages.", 
		"Oompa Loompas are highly skilled workers, but they are not mech engineers. Try to avoid unnecessary damage.", 

	},
	Mission_MechHealth_Success = {
		"Our Oompa Loompas report that your mechs are in perfect conditions. Well done, #squad!", 
		"Excellent. Now we are free to use our bubblegum stocks to glue muffin town back together.",
		
	},
	Mission_MechHealth_Failure = {
		"The bubblegum we use to repair your mechs doesn't grow on trees, you know. I mean, it does, but that's not the point!",
		"We don't have enough bubblegum to repair your mechs AND glue Waffle Village back together!", 
		"We'll have to divert our Oompa Loompa workforce to repair your mechs. Who will bake repairs for our people now?",
	},
	
	-- Lose less than x grid
	Mission_GridHealth_Briefing = {
		"The Power Grid is what keeps our bakeries running smoothly. Protect it or we may not have a breakfast tomorrow.", 
		"Remember, your mechs can't function on a hyperglycemic diet like we do. Protect the power grid at all costs.",  
		"The power grid supplies thousands of gummy citizens in this area. Don't let it be devoured by the Vek.",
	},
	Mission_GridHealth_Success = {
		"Our toffee engineers report no power shortages so far. The mission was a success!",
		"The power grid survived with minimal bites. You have my thanks, #squad.",
	},
	Mission_GridHealth_Failure = {
		"This is no laughing matter, commander. We'll have to shut down half our bakeries just to power your mechs.", 
		"Power is flickering all over the Kingdom. Chaos, mayhem, uncooked dough everywhere.",  
		"This is bad, the grid can't take another bite like that. If things don't change we may not live to eat another day.", 
	},
	
	-- Kill x enemies
	Mission_KillAll_Briefing = {
		"Don't let any bug escape. Our chocolate mines are dangerously close to this region.", 
		"If the Vek survive they will just eat more of our land and come back bigger. Crush as many as you can.", 
		"Our candy weaponry is no match for the Vek, but let's see what your murder machines can do.", 
		"Time for a little payback! Let's make them regret what they did to Muffin Town... They ate it, if there was any doubt.", 
	},
	Mission_KillAll_Success = {
		"It's good to see our land freed from these vile creatures, and we recovered tons of candy from their entrails too.", 
		"Well done, commander. You've burst enough Vek to replenish this land with sugar. We'll have a good lollipop harvest next season.",
	},
	Mission_KillAll_Failure = {
		"Too many bugs escaped, and they will no doubt continue to eat our land unpunished.",
		"A worthy effort, #squad, but we needed more kills to stop the Vek onslaught. I fear the worst is yet to come.",
		"This is bad. I'm already receiving word that the escaping Vek are devouring the neighboring villages.",
	},
	
	-- Block x spawns
	Mission_Block_Briefing = {
		"The endangered Gummy Pandas live in this region. Keep the Vek from surfacing here or they could disrupt their fragile ecosystem.",
	},
	Mission_Block_Success = {
		"I see very few Vek reached the surface and the Gummy Pandas are safe. Well done, my champions.",
		"You have our thanks, #squad. Most of the Vek forces are still napping underground thanks to your actions.",
	},
	Mission_Block_Failure = {
		"I'm sad to inform you that the last Gummy Panda perished in today's battle when it mistook a Vek's leg for bamboo. Candy Land stands in sorrow.",
	},
	
	-- Vek eggs
	Mission_Debris_Briefing = {
		"Vek eggs are edible, but believe me, they taste terrible. Destroy them all, commander.",
	},
	Mission_Debris_Failure = {
		"I understand, eggs are notoriously hard to break. How would you be able to crack them using feeble giant robots? How silly of me.",
	},
	Mission_Debris_Success = {
		"Thanks, commander. The mere sight of those eggs was making me nauseous. I swear I'll never try to make an omelet with them again.",
	},

	-- Vek mites
	Mission_SelfDamage_Briefing = {
		"I knew all those crumbs would attract problems. Get rid of the Vek Mites in your mechs or they could infect our entire cookie supplies.",
	},
	Mission_SelfDamage_Failure = {
		"Despite our best efforts to contain them, the Mites you brought back infected our special cookie stash. There is not a crumb left.",
	},
	Mission_SelfDamage_Success = {
		"Excellent, commander. Your mechs are mite-free and our cookies are safe and crunchy.",
	},

	-- Pacifist
	Mission_Pacifist_Briefing = {
		"I know the Vek are terrible creatures, but the ones attacking this region are kind of cute. Try to keep them alive if you can.",
	},
	Mission_Pacifist_Failure = {
		"I understand killing the Vek was unavoidable... but I even named some of them. Goodbye, Bob. Rest in pieces.",
	},
	Mission_Pacifist_Success = {
		"Thank you, commander. You've shown that killing the Vek is not the only solution. Sometimes crippling or traumatizing them for life is enough.",
	},
	
}
