util.AddNetworkString("RTV_Voted")
util.AddNetworkString("RTV_Start")
util.AddNetworkString("RTV_End")
util.AddNetworkString("RTV_Message")

votes = 0

net.Receive("RTV_Voted", function(len, ply)
	local vote = net.ReadString()	
	
	if ply.Chosen then
		local num = GetGlobalInt(ply.Chosen)
		
		if num > 0 then
			SetGlobalInt(ply.Chosen, num - 1)
		end
	end
	
	SetGlobalInt(vote, GetGlobalInt(vote) + 1)
	
	ply.Chosen = vote
end)

local function GetMaps()
	local AllMaps = file.Find("maps/*.bsp", "GAME")
	local CurMap = game.GetMap()
	local maps = {}
	local num = 0
	
	for _, v in RandomPairs(AllMaps) do		
		if num >= config["NumMaps"] then
			return maps
		end
	
		local name = string.gsub(v, ".bsp", "")
		local suitable = true
		
		if name == CurMap then continue end
		
		for _, ex in pairs(config["Exception"]) do
			if ex == name then
				suitable = false
				continue
			end
		end
		
		local usepr = false
		
		if config["UsePrefixes"] then
			for _, pr in pairs(config["Prefixes"]) do
			
				if string.StartWith(name, pr) then
					usepr = true
					break
				end
			end	
		end
		
		if !usepr then
			suitable = false
		end
		
		if suitable then
			num = num + 1
			table.insert(maps, name)
		end
	end
	
	return maps
end

function StartVote()	
	RTV_Maps = GetMaps()
	
	SetGlobalBool("VoteInProcces", true)
	
	for _, v in pairs(RTV_Maps) do
		SetGlobalInt(v, 0)
	end
	
	net.Start("RTV_Start")
		net.WriteTable(RTV_Maps)
	net.Broadcast()
	
	timer.Simple(config["VoteTime"], function()
		local max = 0
		local winners = {}
		
		for _, v in pairs(RTV_Maps) do
			local vote = GetGlobalInt(v)
			
			if vote > max then
				max = vote
			end
		end
		
		for _, v in pairs(RTV_Maps) do
			if GetGlobalInt(v) >= max then
				table.insert(winners, v)
			end
			
			SetGlobalInt(v, 0)
		end
		
		local winner = table.Random(winners)
		
		SetGlobalBool("VoteInProcces", false)
		
		local cur = GetRoundState()
		
		if cur == ROUND_FREEZE or cur == ROUND_ACTIVE or cur == ROUND_ENDING then 
			NextMap = winner
		else
			game.ConsoleCommand("changelevel " .. winner ..  "\n")
		end
		
		net.Start("RTV_End")
			net.WriteString(winner)
		net.Broadcast()
	end)
end