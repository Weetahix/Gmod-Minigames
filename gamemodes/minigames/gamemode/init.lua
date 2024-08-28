AddCSLuaFile("cl_buymenu.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_languages.lua")
AddCSLuaFile("cl_menu.lua")
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_scoreboard.lua")
AddCSLuaFile("cl_rtv.lua")
AddCSLuaFile("cl_editor.lua")
AddCSLuaFile("cl_chat.lua")
AddCSLuaFile("cl_acts.lua")

include("shared.lua")
include("spectate.lua")
include("timer.lua")
include("player.lua")
include("rtv.lua")
include("editor.lua")
include("buymenu.lua")

util.AddNetworkString("SendMessage")


function ThrowWeapon(ply, wep)	
	local class = wep:GetClass()
	local clip = wep.Clip1 and wep:Clip1() or 0
	local ammo = ply:GetAmmoCount(wep:GetPrimaryAmmoType())
	local silencer
	
	if wep.GetSilencer then
		silencer = wep:GetSilencer()
	end
	
	if ply:HasWeapon(class) then
		if wep.PreDrop and wep:PreDrop() == false then
			return
		end

		local ent = ents.Create(class)
		if !IsValid(ent) then return end

		ent:SetPos(ply:GetPos() + Vector(0, 0, 50))
		ent:SetAngles(ply:GetAngles())

		ent.JCanPickup = {player = ply, time = CurTime() + 2}
		ent.ammo = ammo
		
		if ent.SetSilencer then
			ent:SetSilencer(silencer)
		end

		ent:Spawn()

		if ent.SetClip1 then
			ent:SetClip1(clip)
		end

		local phys = ent:GetPhysicsObject()
		if IsValid(phys) then
			phys:Wake()
			phys:SetVelocity(ply:GetVelocity() + ply:GetAimVector() * 300)
		end

		for _, v in pairs(ply:GetWeapons()) do
			if v:GetSlot() == 0 then
				ply:SelectWeapon(v:GetClass())
			end
		end
	end
end

concommand.Add("dropweapon", function(ply)
	local weapon = ply:GetActiveWeapon()
	
	if !IsValid(weapon) then return end
	
	for _, v in pairs(CurrentMapSettings["CantDrop"]) do
		if v == weapon:GetClass() then
			return
		end
	end
	
	ThrowWeapon(ply, weapon)
	
	ply:StripWeapon(weapon:GetClass())	
end)

concommand.Add("spectate", function(ply)
	if config["Restriction"] and !table.HasValue(config["SpectateGroups"], ply:GetUserGroup()) then return end

	if ply.OnlySpectate then
		ply.OnlySpectate = false
	else
		ply.OnlySpectate = true
		
		ply:SetTeam(TEAM_SPECTATORS)
		ply:Spectate(OBS_MODE_ROAMING)
		ply:RemoveAllItems()
	end
end)

local CanCall = {
	phys_pushscale = function(args)
			local argsz = tonumber(args[1])
			if argsz < 1000 then
				argsz = argsz / 2 
			else argsz = argsz / 5
			end			
		game.ConsoleCommand("phys_pushscale " .. argsz .. "\n")
	end,
	phys_timescale = function(args)
		game.ConsoleCommand("phys_timescale " .. args[1] .. "\n")
	end,
	sv_airaccelerate = function(args)
		game.ConsoleCommand("sv_airaccelerate " .. args[1] .. "\n")
	end,
	sv_accelerate = function(args)
	local argsz = tonumber(args[1])
		if argsz == 5 then
			game.ConsoleCommand("sv_accelerate 9\n")
		else game.ConsoleCommand("sv_accelerate " .. argsz .. "\n")
		end
	end,
	sm_slay = function(args)
		for k,v in pairs (player.GetAll()) do 
			v:Kill() 
		end
	end,
	sv_gravity = function(args)
		local argsz = tonumber(args[1])
		if argsz == 800 then
			game.ConsoleCommand("sv_gravity " .. CurrentMapSettings["Gravity"] .. "\n")
		else game.ConsoleCommand("sv_gravity " .. argsz .. "\n")
		end
	end,
	say = function(args)
		if string.StartWith(args[1], "@") then
			args[1] = string.TrimLeft(string.sub(args[1], 2))
		end
		
		local str = table.concat(args, " ")
		
		PrintMessage(HUD_PRINTTALK, str)
	end,
	sm_say = function(args)
		if string.StartWith(args[1], "@") then
			args[1] = string.TrimLeft(string.sub(args[1], 2))
		end
		
		local str = table.concat(args, " ")
		
		PrintMessage(HUD_PRINTTALK, str)
	end
}

function GM:AcceptInput(ent, inp, act, cal, val)
	
	if ent:GetClass() == "point_servercommand" and inp == "Command" then
		local args = string.Explode(" ", val)
		local cmd = args[1]
		table.remove(args, 1)
					
		if CanCall[cmd] then
			CanCall[cmd](args)

		end
	end
end