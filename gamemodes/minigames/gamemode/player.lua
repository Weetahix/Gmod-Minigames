util.AddNetworkString("DisableVoiceChat")
util.AddNetworkString("SendGroups")
util.AddNetworkString("SendMaps")

net.Receive("DisableVoiceChat", function(len, ply)
	ply.DisableVoiceChat = net.ReadBool()
end)

local meta = FindMetaTable("Player")

function meta:IsCanUseEditor()
	return table.HasValue(config["EditAllow"], self:GetUserGroup()) or #config["EditAllow"] == 0 and self:GetUserGroup() == "superadmin" or self:IsListenServerHost()
end

function GetHoliday(time)
	local month = tonumber(os.date("%m", time))
	local day = tonumber(os.date("%d", time))
	
	if month == 12 and day >= 25 or month == 1 and day <= 7 then
		return "NewYear"
	end
	
	if month == 10 and day == 31 then
		return "Halloween"
	end
	
	return ""
end

timer.Create("CheckHoliday", 3600, 0, function()
	SetGlobalString("holiday", GetHoliday(os.time()))
end)

function GM:Initialize()
	
	if GetConVar("sv_accelerate"):GetInt() != 9 then
		game.ConsoleCommand("sv_accelerate 9\n")
	end
	
	if GetConVar("sv_airaccelerate"):GetInt() != 100 then
		game.ConsoleCommand("sv_airaccelerate 100\n")
	end
	
	if GetConVar("sv_stopspeed"):GetInt() != 35 then
		game.ConsoleCommand("sv_stopspeed 35\n")
	end
	
	if GetConVar("sv_sticktoground"):GetInt() != 0 then
		game.ConsoleCommand("sv_sticktoground 0\n")
	end
	
	if GetConVar("sv_gravity"):GetInt() != CurrentMapSettings["Gravity"] then
		game.ConsoleCommand("sv_gravity " .. CurrentMapSettings["Gravity"] .. "\n")
	end
	
	SetRound(ROUND_PREPARING)
	
	SetGlobalInt("NumRounds", CurrentMapSettings["NumRounds"])
	SetGlobalString("holiday", GetHoliday(os.time()))
end

SpawnPoints = {}

function UpdateSpawnPoints()
	SpawnPoints[1] = ents.FindByClass(CurrentMapSettings["RedSpawnPoints"])
	SpawnPoints[2] = ents.FindByClass(CurrentMapSettings["BlueSpawnPoints"])
end

local function SetPlayerSettings(ply)
	ply:SetRunSpeed(CurrentMapSettings["RunSpeed"])
	ply:SetWalkSpeed(CurrentMapSettings["WalkSpeed"])
	ply:SetJumpPower(CurrentMapSettings["JumpPower"])
	ply:AllowFlashlight(CurrentMapSettings["AllowFlashlight"])
	ply:SetCrouchedWalkSpeed(0.35)
	
	local scale = CurrentMapSettings["PlayerScale"]
	
	ply:SetViewOffset(Vector(0, 0, 64) * scale)
	ply:SetViewOffsetDucked(Vector(0, 0, 28) * scale)
	ply:SetStepSize(18 * scale)
	ply:SetModelScale(scale, 0)
	ply:SetCollisionGroup(CurrentMapSettings["PlayersNoCollide"] and COLLISION_GROUP_PASSABLE_DOOR or COLLISION_GROUP_PLAYER)
	ply:SetAvoidPlayers(CurrentMapSettings["AvoidPlayers"])
	ply:ShouldDropWeapon(false)
	
	if CurrentMapSettings["God"] then
		ply:GodEnable()
	end
	
	if !CurrentMapSettings["God"] and CurrentMapSettings["TempGod"] and CurrentMapSettings["TempGod"] > 0 then
		ply:GodEnable()
		
		timer.Simple(CurrentMapSettings["TempGod"], function()
			if IsValid(ply) then
				ply:GodDisable()
			end
		end)
	end
end

function GM:PlayerSay(ply, text)
	if text == "!acts" then
		ply:SendLua("if OpenActs then OpenActs() end")
		
		return false
	end
	
	if table.HasValue(config["EditorCommand"], text) or #config["EditorCommand"] > 0 and text == "!edit" then
		if ply:IsCanUseEditor() then
			ply:SendLua("if OpenEditor then OpenEditor() end")
			
			return false
		end
	end

	if table.HasValue(config["ChatCommands"], text) then
		if !GetGlobalBool("VoteInProcces") and !NextMap then
			if !ply.Voted then
				local need = math.Round(config["Percent"] * #player.GetAll() / 100)
				votes = votes + 1
				
				if need <= config["MinVotes"] then
					need = config["MinVotes"]
				end
				
				if votes >= need then
					StartVote()
				end
				
				net.Start("RTV_Message")
					net.WriteString("PlyVoted")
					net.WriteTable({ply:Name(), votes, need})
				net.Broadcast()
				
				ply.Voted = true
			else
				net.Start("RTV_Message")
					net.WriteString("AlreadyVoted")
					net.WriteTable({})
				net.Send(ply)
			end
		else
			ply:SendLua('vote:Show()')
		end
	end
	
	return text
end

function GM:PlayerSpawn(ply)	
	local Team = ply:Team()
	
	if GetRoundState() != ROUND_WAITING and Team == TEAM_SPECTATORS then
		ply:Spectate(OBS_MODE_ROAMING) 
		return
	else
		ply:UnSpectate()
		
		local color = team.GetColor(Team)
		
		ply:SetPlayerColor(Vector(color.r / 255, color.g / 255, color.b / 255))
		
		SetPlayerSettings(ply)
		
		local NumSpawnPoints = Team == TEAM_RED and 1 or 2
		local SpawnPointForPlyTeam = SpawnPoints[NumSpawnPoints]
		
		if !SpawnPointForPlyTeam or SpawnPointForPlyTeam and #SpawnPointForPlyTeam == 0 then
			UpdateSpawnPoints()
			SpawnPointForPlyTeam = SpawnPoints[NumSpawnPoints]
		end
		
		if #SpawnPointForPlyTeam > 0 then
			local point = table.Random(SpawnPointForPlyTeam)
			ply:SetPos(point:GetPos())
			ply:SetEyeAngles(point:GetAngles())
			table.RemoveByValue(SpawnPoints[NumSpawnPoints], point)
		end
		
		hook.Call("PlayerLoadout", GAMEMODE, ply)
		hook.Call("PlayerSetModel", GAMEMODE, ply)
	end
	
	ply:SetupHands()
end

function GM:PlayerDeathThink(ply)
	return false
end

function GM:PlayerDeath(ply, inf, att)
	ply:Flashlight(false)
	ply:AllowFlashlight(false)
	
	if CurrentMapSettings["DropAfterDeath"] then
		for _, v in pairs(ply:GetWeapons()) do
			if !table.HasValue(CurrentMapSettings["CantDrop"], v:GetClass()) then
				ThrowWeapon(ply, v)
			end
		end
	end
	
	if CurrentMapSettings["Respawn"] and GetRoundState() != ROUND_WAITING then
		timer.Simple(2, function()
			if IsValid(ply) then
				ply:Spawn()
			end
		end)
	end
	
	ply.NextSpawnTime = CurTime() + 2
	ply.DeathTime = CurTime()
	
	if IsValid(att) and att:IsVehicle() and IsValid(att:GetDriver()) then
		att = att:GetDriver()
	end
	
	if !IsValid(inf) and IsValid(att) then
		inf = att
	end
	
	if IsValid(inf) and inf == att and (inf:IsPlayer() or inf:IsNPC()) then
		inf = inf:GetActiveWeapon()
		
		if !IsValid(inf) then inf = att end
	end
	
	if att == ply then
		net.Start("PlayerKilledSelf")
			net.WriteEntity(ply)
		net.Broadcast()
		
		MsgAll(att:Nick() .. " suicided!\n")
		
		return
	end
	
	if att:IsPlayer() then
		net.Start("PlayerKilledByPlayer")
			net.WriteEntity(ply)
			net.WriteString(inf:GetClass())
			net.WriteEntity(att)
			net.WriteBool(ply:LastHitGroup() == HITGROUP_HEAD)
		net.Broadcast()
		
		MsgAll(att:Nick() .. " killed " .. ply:Nick() .. " using " .. inf:GetClass() .. "\n")
		
		return
	end
	
	net.Start("PlayerKilled")
		net.WriteEntity(ply)
		net.WriteString(inf:GetClass())
		net.WriteString(att:GetClass())
	net.Broadcast()
	
	MsgAll(ply:Nick() .. " was killed by " .. att:GetClass() .. "\n")
end

function GM:PlayerDisconnected(ply)
	if ply.Voted and votes > 0 then
		votes = votes - 1
	end
	
	if GetGlobalBool("VoteInProcces") and ply.Chosen then
		local num = GetGlobalInt(ply.Chosen)
		
		if num > 0 then
			SetGlobalInt(ply.Chosen, num - 1)
		end
	end
end

function GM:PlayerInitialSpawn(ply)
	net.Start("SendGroups")
		net.WriteTable(config["Groups"])
	net.Send(ply)
	
	local maps = file.Find("maps/*.bsp", "GAME")
	
	for _, v in pairs(maps) do
		v = string.gsub(v, ".bsp", "")
	end
	
	net.Start("SendMaps")
		net.WriteTable(maps)
	net.Send(ply)
	
	if ply:IsCanUseEditor() then
		timer.Simple(5, function()
			net.Start("SendMessage")
				net.WriteString(config["EditorCommand"][1])
			net.Send(ply)
		end)
	end
	
	local round = GetRoundState()

	if (round == ROUND_FREEZE or CurrentMapSettings["Respawn"]) and round != ROUND_WAITING and round != ROUND_PREPARING then
		if CurrentMapSettings["TeamType"] == 1 or CurrentMapSettings["TeamType"] == 2 then
			ply:SetTeam(TEAM_RED)
		end
		
		if CurrentMapSettings["TeamType"] == 3 then
			if #team.GetPlayers(TEAM_RED) > #team.GetPlayers(TEAM_BLUE) then
				ply:SetTeam(TEAM_BLUE)
			else
				ply:SetTeam(TEAM_RED)
			end
		end
		
		if CurrentMapSettings["TeamType"] == 4 then
			ply:SetTeam(TEAM_BLUE)
		end
		
		ply:Spawn()
		
		if !CurrentMapSettings["Respawn"] then
			ply:Freeze(true)
		end
	else
		ply:SetTeam(TEAM_SPECTATORS)
		ply:Spectate(OBS_MODE_ROAMING)
	end
	
	timer.Simple(1, function()
		for _, v in pairs(player.GetAll()) do
			v:SendLua("if RefreshScoreBoard then RefreshScoreBoard() end")
		end
	end)
end

function GM:PlayerShouldTakeDamage(ply, att)
	if !IsValid(att) or IsValid(att) and !att:IsPlayer() then return true end
	
	if att:Team() == ply:Team() then
		return CurrentMapSettings["TeamDamage"]
	end
	
	return CurrentMapSettings["PlayersDamage"]
end

function GM:ScalePlayerDamage(ply, hitgroup, dmg)
	local att = dmg:GetAttacker()
	
	if !IsValid(att) then return end
	
	local wep = att.GetActiveWeapon and att:GetActiveWeapon() or nil
	
	local scale = 1
	
	if IsValid(wep) and wep:GetClass() != "weapon_knife" and hitgroup == HITGROUP_HEAD then
		ply:EmitSound("player/headshot" .. math.random(1, 2) .. ".wav", 140)
	end
	
	if IsValid(wep) and wep.DamageScale then
		scale = wep.DamageScale[hitgroup] or 1
	else
		if hitgroup == HITGROUP_HEAD then
			scale = 3
		end
		
		if hitgroup == HITGROUP_LEFTARM or hitgroup == HITGROUP_RIGHTARM or hitgroup == HITGROUP_LEFTLEG or hitgroup == HITGROUP_RIGHTLEG then
			scale = 0.6
		end
	end
	
	dmg:ScaleDamage(scale)
end

function GM:Tick()
	for k, v in pairs(player.GetAll()) do
		if GetRoundState() == ROUND_WAITING and !v:Alive() and !v.OnlySpectate then
			v:SetTeam(TEAM_RED)
			v:Spawn()
		end
		
		local wep = v:GetActiveWeapon()
		
		if IsValid(wep) and wep.GetIronsights and wep:GetIronsights() then
			v:SetRunSpeed(CurrentMapSettings["RunSpeed"] * 0.5)
			v:SetWalkSpeed(CurrentMapSettings["WalkSpeed"] * 0.5)
		else
			v:SetRunSpeed(CurrentMapSettings["RunSpeed"])
			v:SetWalkSpeed(CurrentMapSettings["WalkSpeed"])
		end
		
		if CurrentMapSettings["InfiniteAmmo"] then
			if IsValid(wep) then
				local PrimaryType = wep:GetPrimaryAmmoType()
				local SecondaryType = wep:GetSecondaryAmmoType()
				
				if PrimaryType and PrimaryType != -1 then
					local num = 999
					
					if num != v:GetAmmoCount(PrimaryType) then
						v:SetAmmo(num, PrimaryType)
					end
				end
				
				if SecondaryType and SecondaryType != -1 then
					local num = 999
					
					if num != v:GetAmmoCount(SecondaryType) then
						v:SetAmmo(num, SecondaryType)
					end
				end
			end
		end
	
		if v:Alive() and v:WaterLevel() >= 3 then
			if not v._DrownTime then
				v._DrownTime = RealTime() + 10
				continue
			elseif v._DrownTime <= RealTime() then
				local dmg = DamageInfo()
				dmg:SetDamageType(DMG_DROWN)
				dmg:SetDamage(15)
				dmg:SetAttacker(game.GetWorld())
				dmg:SetInflictor(game.GetWorld())
				dmg:SetDamageForce(Vector(math.random(-5, 5), math.random(-2, 3), math.random(-10, 9)))
				v:TakeDamageInfo(dmg)
				
				v._DrownTime = RealTime() + 3
			end
		else
			v._DrownTime = nil
		end
	end
end

function GM:GetFallDamage(ply, speed)
	if !CurrentMapSettings["FallDamage"] then
		return 0
	end
	
	return (speed - 526.5) * (100 / 396) 
end

function GM:PlayerCanPickupWeapon(ply, wep)
	local Team = ply:Team()
	local weps = ply:GetWeapons()

	if Team != TEAM_BLUE and Team != TEAM_RED then return false end
	
	for _, v in pairs(weps) do
		if v:GetClass() == wep:GetClass() then return false end
	end
	
	local slot = wep:GetSlot()

	if slot >= 0 and slot <= 2 then 
		for _, v in pairs(weps) do
			if v:GetSlot() == slot then return false end
		end
	end
	
	local pickup = wep.JCanPickup

	if pickup and pickup.player == ply then
		if pickup.time and pickup.time >= CurTime() then
			return false
		else
			wep.JCanPickup = nil
		end
	elseif pickup then
		wep.JCanPickup = nil
	end
	
	if wep.ammo then
		ply:SetAmmo(wep.ammo, wep:GetPrimaryAmmoType())
	else
		ply:SetAmmo(wep:GetMaxClip1() * 5, wep:GetPrimaryAmmoType())
	end
	
	return true
end

function GM:PlayerLoadout(ply)
	if CurrentMapSettings["StartWeapon"] != "" then
		ply:Give(CurrentMapSettings["StartWeapon"])
	end
end

function GM:PlayerSetModel(ply)
	local rand = math.random(1, 9)
	ply:SetModel("models/player/group01/male_0" .. rand .. ".mdl")
end

function GM:CanPlayerSuicide(ply)
	return ply:Alive()
end

function GM:PlayerSpray(ply)
	return !ply:Alive()
end

function GM:PlayerCanHearPlayersVoice(pListener, pTalker)
	if isbool(pListener.DisableVoiceChat) then
		return !pListener.DisableVoiceChat, false
	else
		return true, false
	end
end

function GM:AllowPlayerPickup(ply, ent)
	return false
end

function GM:EntityEmitSound(data)
	if string.EndsWith(data.SoundName, ".mp3") then
		BroadcastLua("hook.Call('PreventMusic', GAMEMODE)")
	end
end

function GM:PlayerSetHandsModel(ply, ent)
	local simplemodel = player_manager.TranslateToPlayerModelName(ply:GetModel())
	local info = player_manager.TranslatePlayerHands(simplemodel)
	
	if info then
		ent:SetModel(info.model)
		ent:SetSkin(info.skin)
		ent:SetBodyGroups(info.body)
	end
end
	
		
hook.Add("Move", "AntiSpeed", function(player, playermovedata)
	local max_speed = CurrentMapSettings["WalkSpeed"] + 35
	local speed = player:GetVelocity():Length()
	local fall_speed = 3500
	local bypass = CurrentMapSettings["WalkSpeed"] + 165
	if speed > max_speed and player:IsOnGround() then
		playermovedata:SetVelocity(player:GetVelocity() * (max_speed/speed))
	end
	if speed > bypass then
		playermovedata:SetVelocity(player:GetVelocity() * 1)
	end
	if speed > fall_speed and !player:IsOnGround() then
		playermovedata:SetVelocity(player:GetVelocity() * (fall_speed/speed))
	end
end)



hook.Add("Move", "JumpBoostNerf", function(player)
		if (player:KeyDown(IN_DUCK && IN_JUMP)) then
			player:SetJumpPower(CurrentMapSettings["JumpPower"] - 40)
		elseif (player:KeyDown(IN_DUCK && IN_JUMP && IN_FORWARD)) then
			player:SetJumpPower(CurrentMapSettings["JumpPower"] - 40)
		elseif (player:KeyDown(IN_DUCK && IN_JUMP && IN_FORWARD  && IN_LEFT)) then
			player:SetJumpPower(CurrentMapSettings["JumpPower"] - 40)
		elseif (player:KeyDown(IN_DUCK && IN_JUMP && IN_FORWARD && IN_RIGHT)) then
			player:SetJumpPower(CurrentMapSettings["JumpPower"] - 40)
		else player:SetJumpPower(CurrentMapSettings["JumpPower"])
		end
end)