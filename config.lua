--[[
                           ______                         __  __     _ __    
   ___  __ _________  ___ / __/ /____  _______ ____ ____ / / / /__  (_) /____
  / _ \/ // / __/ _ \(_-<_\ \/ __/ _ \/ __/ _ `/ _ `/ -_) /_/ / _ \/ / __(_-<
 / .__/\_, /_/  \___/___/___/\__/\___/_/  \_,_/\_, /\__/\____/_//_/_/\__/___/
/_/   /___/                                   /___/                          
]]--

Config = {}
Config.Notifications 			 = "pyrosNotifs"	-- Options: "qb" / "ox" / "pyrosNotifs" 	-- Default: "pyrosNotifs"
Config.Inventory	 			 = "qb"				-- Options: "qb" / "ox"						-- Default: "qb"
Config.Target 		 			 = "qb"				-- Options: "qb" / "ox"						-- Default: "qb"

Config.TargetDistance			 = 2.0 				-- Distance to Interact with NPC/Units in Metres
Config.MaxUnitsPerCharacter		 = 2				-- Global Limit Per Character
Config.RentDuration				 = 7*24*60*60		-- 7 Days (e.g. 14*24*60*60 = 14 Days)

Config.Expiry = {
	ReminderTimes = {
		48*60*60,						-- 48 Hours Before
		24*60*60,						-- 24 Hours Before
		1*60*60							-- 1 Hour Before
	},
	DeleteAfter = 3*24*60*60			-- Delete Unit Contents After 3 Days
}

Config.PoliceRaid = {
	Enabled = true,
	Jobs = {
		police = 2,						-- job = grade (e.g. Job: Police - Grade: 2)
		sheriff = 1						-- job = grade (e.g. Job: Sheriff - Grade: 1)
	}
}

Config.Facilities = {
	["strawberry"] = {
		label = "Strawberry Storage",
		npc = {
			-- https://docs.fivem.net/docs/game-references/ped-models
			model = `s_m_y_armymech_01`,
            coords = vector4(-69.1339, -1241.7274, 28.0989, 47.8654)
		},
		units = {
			{ name = "Small Unit", price = 500, maxWeight = 50000 },
			{ name = "Medium Unit", price = 1000, maxWeight = 100000 },
			{ name = "Large Unit", price = 2000, maxWeight = 200000 }
		},
		storageCoords = {
            vector3(-72.1783, -1233.5344, 29.0780),
            vector3(-56.3241, -1210.2572, 28.4846),
            vector3(-71.0066, -1206.1912, 27.8673),
            vector3(-73.5986, -1242.9763, 29.1101),
            vector3(-73.2667, -1197.1354, 27.6572)
		}
	}--,
}

-- https://docs.fivem.net/docs/game-references/blips
Config.FacilityBlip = {
	Sprite = 474,
	Scale = 0.8,
	Colour = 5
}