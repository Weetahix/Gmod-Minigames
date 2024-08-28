util.AddNetworkString("SendSettings")
util.AddNetworkString("EditSettings")
util.AddNetworkString("RestoreSettings")
util.AddNetworkString("SendConfig")
util.AddNetworkString("EditConfig")
util.AddNetworkString("RestoreConfig")

local DefaultSettings = {
	God = false,
	TeamType = 3,
	PlyInTeam = 0,
	Respawn = false,
	Time = 600,
	PlayerScale = 1,
	RunSpeed = 106,
	WalkSpeed = 235,
	JumpPower = 261,
	AllowFlashlight = true,
	StartWeapon = "",
	InfiniteAmmo = true,
	PlayersNoCollide = true,
	AvoidPlayers = false,
	TeamDamage = false,
	PlayersDamage = true,
	FallDamage = true,
	DropAfterDeath = true,
	WinPoints = 0,
	DrawPoints = 0,
	LossPoints = 0,
	BlueSpawnPoints = "info_player_counterterrorist",
	RedSpawnPoints = "info_player_terrorist",
	Gravity = 600,
	TempGod = 3,
	NumRounds = 15,
	CantDrop = {
		"weapon_knife",
		"weapon_flashbang",
		"weapon_smokegrenade",
		"weapon_hegrenade"
	}
}

local DefaultConfig = {
	NumMaps = 6,
	VoteTime = 20,
	Percent = 50,
	UsePrefixes = true,
	Restriction = true,
	MinVotes = 1,
	PreparationTime = 30,
	EndTime = 5,
	FreezeTime = 2,
	ChatCommands = {
		"rtv",
		"!rtv",
		"/rtv"
	},
	Prefixes = {
		"mg_"
	},
	Exception = {},
	SpectateGroups = {
		"superadmin"
	},
	EditAllow = {
		"superadmin"
	},
	EditorCommand = {
		"!edit"
	},
	Groups = {
		{"user", 0, "User", Color(220, 220, 220)},
		{"superadmin", 1337, "God", Color(255, 221, 0)}
	}
}

net.Receive("RestoreSettings", function(len, ply)
	if ply:IsCanUseEditor() then
		local map = net.ReadString()
		local default = GetDefaultMapSettings()
	
		local count = sql.Query("SELECT COUNT(*) AS cnt FROM MapSettings WHERE map = '" .. map .. "'")
			
		if tonumber(count[1].cnt) > 0 then
			sql.Query("UPDATE MapSettings SET settings = '" .. util.TableToJSON(default) .. "' WHERE map = '" .. map .. "'")
		else
			sql.Query("INSERT INTO MapSettings (map, settings) VALUES('" .. map .. "', '" .. util.TableToJSON(default) .. "')")
		end
		
		if map == game.GetMap() then
			CurrentMapSettings = default
			
			local state = GetRoundState()
			
			if state != ROUND_ENDING and state != ROUND_PREPARING and state != ROUND_WAITING then
				SetRound(ROUND_ENDING)
			end
		end

		net.Start("SendSettings")
			net.WriteTable(CurrentMapSettings)
		net.Send(ply)
	end
end)

net.Receive("SendSettings", function(len, ply)
	if ply:IsCanUseEditor() then
		local tbl = GetMapSettings(net.ReadString())

		net.Start("SendSettings")
			net.WriteTable(tbl)
		net.Send(ply)
	end
end)

net.Receive("EditSettings", function(len, ply)
	if ply:IsCanUseEditor() then
		local tbl = net.ReadTable()
		local map = tbl.map
		tbl.map = nil
		
		local count = sql.Query("SELECT COUNT(*) AS cnt FROM MapSettings WHERE map = '" .. map .. "'")
		
		if tonumber(count[1].cnt) > 0 then
			sql.Query("UPDATE MapSettings SET settings = '" .. util.TableToJSON(tbl) .. "' WHERE map = '" .. map .. "'")
		else
			sql.Query("INSERT INTO MapSettings (map, settings) VALUES('" .. map .. "', '" .. util.TableToJSON(tbl) .. "')")
		end
		
		if map == game.GetMap() then
			CurrentMapSettings = GetMapSettings(map)
			
			local state = GetRoundState()
			
			if state != ROUND_ENDING and state != ROUND_PREPARING and state != ROUND_WAITING then
				SetRound(ROUND_ENDING)
			end
		end
	end
end)

net.Receive("RestoreConfig", function(len, ply)
	if ply:IsCanUseEditor()then
		local count = sql.Query("SELECT COUNT(*) AS cnt FROM config")
			
		if tonumber(count[1].cnt) > 0 then
			sql.Query("UPDATE config SET config = '" .. util.TableToJSON(DefaultConfig) .. "'")
		else
			sql.Query("INSERT INTO config (config) VALUES('" .. util.TableToJSON(DefaultConfig) .. "')")
		end
		
		config = DefaultConfig

		net.Start("SendConfig")
			net.WriteTable(DefaultConfig)
		net.Send(ply)
		
		net.Start("SendGroups")
			net.WriteTable(config["Groups"])
		net.Broadcast()
	end
end)

net.Receive("SendConfig", function(len, ply)
	if ply:IsCanUseEditor() then
		local tbl = GetConfig()

		net.Start("SendConfig")
			net.WriteTable(tbl)
		net.Send(ply)
	end
end)

net.Receive("EditConfig", function(len, ply)
	if ply:IsCanUseEditor() then
		local tbl = net.ReadTable()
		
		local count = sql.Query("SELECT COUNT(*) AS cnt FROM config")
			
		if tonumber(count[1].cnt) > 0 then
			sql.Query("UPDATE config SET config = '" .. util.TableToJSON(tbl) .. "'")
		else
			sql.Query("INSERT INTO config (config) VALUES('" .. util.TableToJSON(tbl) .. "')")
		end
		
		config = GetConfig()
		
		net.Start("SendGroups")
			net.WriteTable(config["Groups"])
		net.Broadcast()
	end
end)

function GetDefaultMapSettings()
	if !sql.TableExists("MapSettings") then
		sql.Query("CREATE TABLE MapSettings (map varchar(50), settings varchar(2000))")
	end
	
	local DefaultMapSettings = sql.Query("SELECT * FROM MapSettings WHERE map = 'default'")
	
	if !DefaultMapSettings then
		DefaultMapSettings = DefaultSettings
	else
		DefaultMapSettings = util.JSONToTable(DefaultMapSettings[1]["settings"])
		
		for k, v in pairs(DefaultSettings) do
			if DefaultMapSettings[k] == nil then
				DefaultMapSettings[k] = v
			end
		end
		
		for k, _ in pairs(DefaultMapSettings) do
			if DefaultSettings[k] == nil then
				DefaultMapSettings[k] = nil
			end
		end
	end
	
	return DefaultMapSettings
end

function GetMapSettings(map)
	local settings = {}
	local default = GetDefaultMapSettings()
	
	if !sql.TableExists("MapSettings") then
		sql.Query("CREATE TABLE MapSettings (map varchar(50), settings varchar(2000))")
	end
	
	local MapSettings = sql.Query("SELECT * FROM MapSettings WHERE map = '" .. map .. "'")
	
	if !MapSettings then
		MapSettings = default
		
		if map == game.GetMap() and !timer.Exists("EditNotification") then
			timer.Create("EditNotification", 600, 0, function()
				local plys = {}
				
				for _, v in pairs(player.GetAll()) do
					if v:IsCanUseEditor() then
						table.insert(plys, v)
					end
				end
				
				net.Start("SendMessage")
					net.WriteString(config["EditorCommand"][1])
				net.Send(plys)
			end)
		end
	else
		MapSettings = util.JSONToTable(MapSettings[1]["settings"])
		
		for k, v in pairs(default) do
			if MapSettings[k] == nil then
				MapSettings[k] = v
			end
		end
		
		for k, _ in pairs(MapSettings) do
			if default[k] == nil then
				MapSettings[k] = nil
			end
		end
	end
	
	return MapSettings
end

function GetConfig()
	if !sql.TableExists("config") then
		sql.Query("CREATE TABLE config (config varchar(1000))")
	end
	
	local config = sql.Query("SELECT * FROM config")
	
	if !config then
		config = DefaultConfig
	else
		config = util.JSONToTable(config[1]["config"])
		
		for k, v in pairs(DefaultConfig) do
			if config[k] == nil then
				config[k] = v
			end
			
			if istable(config[k]) and #config[k] == 0 then
				config[k] = v
			end
		end
		
		for k, _ in pairs(config) do
			if DefaultConfig[k] == nil then
				config[k] = nil
			end
		end
	end
	
	return config
end

CurrentMapSettings = GetMapSettings(game.GetMap())
config = GetConfig()

net.Start("SendGroups")
	net.WriteTable(config["Groups"])
net.Broadcast()