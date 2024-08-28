util.AddNetworkString("SendNotification")
util.AddNetworkString("SendPoints")

SetGlobalInt("RoundTime", 0)
SetGlobalInt("RoundPhase", ROUND_PREPARING)

function SetRoundTime(time)
	SetGlobalInt("RoundTime", CurTime() + time)
end

local function GetAlivePlayer()
	local AliveTbl = {}
	for _, v in pairs(player.GetAll()) do
		if v:Alive() then
			table.insert(AliveTbl, v)
		end
	end
	return AliveTbl
end

local function SendNotification(text, ply, ...)
	if !ply then
		net.Start("SendNotification")
			net.WriteString(text)
			net.WriteTable({...})
		net.Broadcast()
		return
	end
	
	if ply then
		net.Start("SendNotification")
			net.WriteString(text)
			net.WriteTable({...})
		net.Send(ply)
	end
end

local function SendPoints(ply, points)
	if IsValid(ply) and PS then
		ply:PS_GivePoints(points)
		
		net.Start("SendPoints")
			net.WriteInt(points, 32)
		net.Send(ply)
	end
end

RoundFunctions = {
	[ROUND_WAITING] = function()
		SetRoundTime(0)
		
		for _, v in pairs(player.GetAll()) do
			v:RemoveAllItems()
			v:SetTeam(TEAM_SPECTATORS)
			v:Spectate(OBS_MODE_ROAMING)
			v:Freeze(false)
		end
	end,

	[ROUND_PREPARING] = function()
		SetRoundTime(config["PreparationTime"])
	end,
	
	[ROUND_FREEZE] = function()
		if NextMap then
			print("Next map is " .. NextMap)
			game.ConsoleCommand("changelevel " .. NextMap ..  "\n")
			
			return
		end
	
		game.CleanUpMap()
		
		
		local players = player.GetAll()
		
		for k, v in pairs(players) do
			if v.OnlySpectate == true then
				table.remove(players, k)
			end
		end

		SetRoundTime(config["FreezeTime"])
		
		UpdateSpawnPoints()
		
		if CurrentMapSettings["TeamType"] == 1 or CurrentMapSettings["TeamType"] == 2 then
			for _, v in pairs(players) do
				v:SetTeam(TEAM_RED)
				v:RemoveAllItems()
				v:Spawn()
				v:Freeze(true)
			end
		else
			local NumTbl = {}
			local NeedPly
			
			if CurrentMapSettings["TeamType"] == 3 then
				NeedPly = math.Round(#players / 2)
			else
				NeedPly = CurrentMapSettings["PlyInTeam"]
				
				if #players <= NeedPly then
					NeedPly = #players - 1
				end
			end
			
			for i = 1, NeedPly do
				local find = true
				local rand
				
				while find do
					find = false
					rand = math.random(1, #players)
					for _, v in pairs(NumTbl) do
						if rand == v then
							find = true
							break
						end
					end
				end
				
				table.insert(NumTbl, rand)
			end
			
			for k, v in pairs(players) do
				v:SetTeam(table.HasValue(NumTbl, k) and TEAM_RED or TEAM_BLUE)
				v:RemoveAllItems()
				v:Spawn()
				v:Freeze(true)
			end
		end
		
		if GetGlobalInt("NumRounds") == 1 then
			StartVote()
		end
	end,

	[ROUND_ACTIVE] = function()
		SetRoundTime(CurrentMapSettings["Time"])
		
	if GetConVar("sv_gravity"):GetInt() == 800 then
		game.ConsoleCommand("sv_gravity " .. CurrentMapSettings["Gravity"] .. "\n")
	end
	
		for _, v in pairs(player.GetAll()) do
			v:Freeze(false)
		end

		SendNotification("RoundStart")
	end,

[ROUND_ENDING] = function(winner)
		SetRoundTime(config["EndTime"])
		SetGlobalInt("NumRounds", GetGlobalInt("NumRounds", 1) - 1)
		
		local players = player.GetAll()

		if !winner then
		
			SendNotification("Draw")
			for k,v in pairs (player.GetAll()) do 
					v:EmitSound("winner.ogg")
				end
			
			if CurrentMapSettings["DrawPoints"] != 0 then
				for _, v in pairs(players) do
					SendPoints(v, CurrentMapSettings["DrawPoints"])
				end
			end
			
			return
		end
		
		if CurrentMapSettings["TeamType"] == 2 and winner:IsPlayer() then
			SendNotification("Winner", nil, winner:Nick())
			winner:AddFrags(1)
				for k,v in pairs (player.GetAll()) do 
					v:EmitSound("winner.ogg")
				end
			
			for _, v in pairs(players) do
				if v == winner and CurrentMapSettings["WinPoints"] != 0 then
					SendPoints(v, CurrentMapSettings["WinPoints"])
				elseif CurrentMapSettings["LossPoints"] != 0 then
					SendPoints(v, CurrentMapSettings["LossPoints"])
				end
			end
			
			return
		end
		
		if CurrentMapSettings["TeamType"] == 3 or CurrentMapSettings["TeamType"] == 4 then
			local str
			
			if winner == TEAM_RED then
				str = "RedWon"
				for k,v in pairs (player.GetAll()) do 
					v:EmitSound("red.ogg")
				end
			elseif winner == TEAM_BLUE then
				str = "BlueWon"
				for k,v in pairs (player.GetAll()) do 
					v:EmitSound("blue.ogg")
				end
			end
			
			if str then
				SendNotification(str)
			end
				
			for _, v in pairs(players) do
				if v:Team() == winner then
					if CurrentMapSettings["WinPoints"] != 0 then
						if v:Alive() then
							SendPoints(v, math.Round(CurrentMapSettings["WinPoints"] * 1.25))
						else
							SendPoints(v, CurrentMapSettings["WinPoints"])
						end
					end
				elseif CurrentMapSettings["LossPoints"] != 0 then
					SendPoints(v, CurrentMapSettings["LossPoints"])
				end
			end
		end
	end
}

function SetRound(round, ...)
	if not RoundFunctions[round] then return end

	local args = {...}

	SetGlobalInt("RoundPhase", round)
	RoundFunctions[round](unpack(args))
	
	hook.Call("OnRoundChanged", GAMEMODE, round)
end

ThinkRoundFunctions = {
	[ROUND_WAITING] = function()
		local plys = player.GetAll()
		
		for k, v in pairs(plys) do
			if v.OnlySpectate == true then
				table.remove(plys, k)
			end
		end
		
		if #plys >= 2 then
			SetRound(ROUND_FREEZE)
		end
	end,

	[ROUND_ACTIVE] = function()
		if CurrentMapSettings["Respawn"] then return end
		
		local TeamType = CurrentMapSettings["TeamType"]
		
		if TeamType == 3 or TeamType == 4 then
		
			local RedAlive = false
			local BlueAlive = false
			
			for _, v in pairs(GetAlivePlayer()) do
					if v:Team() == TEAM_BLUE then BlueAlive = true end
					if v:Team() == TEAM_RED then RedAlive = true end
			end
			
			if !RedAlive and !BlueAlive then
				SetRound(ROUND_ENDING)
				
				return
			end
			
			if !RedAlive then
				SetRound(ROUND_ENDING, TEAM_BLUE)

				return
			end
			
			if !BlueAlive then
				SetRound(ROUND_ENDING, TEAM_RED)

				return
			end
		elseif TeamType == 1 then
			local AlivePlayer = GetAlivePlayer()
			
			for _, v in pairs(AlivePlayer) do
				if v:Team() != TEAM_BLUE and v:Team() != TEAM_RED then
					table.remove(AlivePlayer, k)
				end
			end
			
			if #AlivePlayer == 0 then
				SetRound(ROUND_ENDING)
				
				return
			end
		elseif TeamType == 2 then
			local AlivePlayer = GetAlivePlayer()
			
			for _, v in pairs(AlivePlayer) do
				if v:Team() != TEAM_BLUE and v:Team() != TEAM_RED then
					table.remove(AlivePlayer, k)
				end
			end
			
			if #AlivePlayer == 0 then
				SetRound(ROUND_ENDING)
				
				return
			end
			
			if #AlivePlayer == 1 then
				SetRound(ROUND_ENDING, AlivePlayer[1])
			
			end

		end
	end
	
}

NextPhase = {
	[ROUND_PREPARING] = ROUND_FREEZE,
	[ROUND_FREEZE] = ROUND_ACTIVE,
	[ROUND_ACTIVE] = ROUND_ENDING,
	[ROUND_ENDING] = ROUND_FREEZE
}

function GM:Think()
	local cur = GetRoundState()

	if cur != ROUND_WAITING and cur != ROUND_PREPARING then
		local plys = player.GetAll()
		
		for k, v in pairs(plys) do
			if v.OnlySpectate == true then
				table.remove(plys, k)
			end
		end
	
		if #plys < 2 then
			SendNotification("NotEnough")
		
			SetRound(ROUND_WAITING)
			return
		end
	end

	if ThinkRoundFunctions[cur] then
		ThinkRoundFunctions[cur]()
	end
	
	if GetRoundTime() == 0 and cur != ROUND_WAITING and NextPhase[cur] then
		SetRound(NextPhase[cur])
	end
end