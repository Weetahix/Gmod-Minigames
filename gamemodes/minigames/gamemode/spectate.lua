local function GetNextPlayer(ply)
	local plys = {}
	
	for _, v in pairs(player.GetAll()) do
		if v:Alive() then
			table.insert(plys, v)
		end
	end
	
	local NextPly
	
	for k, v in pairs(plys) do
		if v == ply then
			if IsValid(plys[k + 1]) then
				NextPly = plys[k + 1]
			else
				NextPly = plys[1]
			end
			
			return NextPly
		end
	end
	
	return plys[1]
end

local function GetPreviousPlayer(ply)
	local plys = {}
	
	for _, v in pairs(player.GetAll()) do
		if v:Alive() then
			table.insert(plys, v)
		end
	end
	
	local PrevPly
	
	for k, v in pairs(plys) do
		if v == ply then
			if IsValid(plys[k - 1]) then
				PrevPly = plys[k - 1]
			else
				PrevPly = plys[#plys]
			end
			
			return PrevPly
		end
	end
	
	return plys[#plys]
end

function GM:DoPlayerDeath(ply, att, cinfo)
	ply:CreateRagdoll()
	ply:AddDeaths(1)
	
	if IsValid(att) && att:IsPlayer() then
		if att != ply then
			att:AddFrags(1)
		end
	end

	if IsValid(att) and att:IsPlayer() and att != ply then
		ply:Spectate(OBS_MODE_CHASE)
		ply:SpectateEntity(att)
		
		ply:SetupHands(att)
	else
		ply:Spectate(OBS_MODE_ROAMING)
	end
	
	for _, v in pairs(player.GetAll()) do
		if ply == v then continue end
		
		local ob = v:GetObserverTarget()
		
		if IsValid(ob) and ob == ply then
			v:Spectate(OBS_MODE_ROAMING)
			v:SpectateEntity(nil)
		end
	end
end

local KeyPressFunc = {
	[IN_ATTACK] = function(ply)
		local targ = GetPreviousPlayer(ply:GetObserverTarget())

		if IsValid(targ) and targ:IsPlayer() then
			ply:Spectate(ply._smode or OBS_MODE_CHASE)
			ply:SpectateEntity(targ)
			
			ply:SetupHands(targ)
		end
	end,

	[IN_ATTACK2] = function( ply )
		local targ = GetNextPlayer(ply:GetObserverTarget())

		if IsValid(targ) and targ:IsPlayer() then
			ply:Spectate(ply._smode or OBS_MODE_CHASE)
			ply:SpectateEntity(targ)
			
			ply:SetupHands(targ)
		end
	end,

	[IN_RELOAD] = function(ply)
		local targ = ply:GetObserverTarget()
		if !IsValid(targ) or !targ:IsPlayer() then return end

		if !ply._smode or ply._smode == OBS_MODE_CHASE then
			ply._smode = OBS_MODE_IN_EYE
		elseif ply._smode == OBS_MODE_IN_EYE then
			ply._smode = OBS_MODE_CHASE
		end

		ply:Spectate(ply._smode)
		
		ply:SetupHands(targ)
	end,

	[IN_JUMP] = function(ply)
		if ply:GetMoveType() != MOVETYPE_NOCLIP then
			ply:SetMoveType(MOVETYPE_NOCLIP)
		end
	end,

	[IN_DUCK] = function(ply)
		ply:Spectate(OBS_MODE_ROAMING)
		ply:SpectateEntity(nil)
	end
}

function GM:KeyPress(ply, key)
	if key == IN_USE then
		local tr = util.TraceLine({
			start  = ply:GetShootPos(),
			endpos = ply:GetShootPos() + ply:GetAimVector() * 80,
			filter = ply,
			mask   = MASK_SHOT
		});
		
		if IsValid(tr.Entity) then
			if tr.Entity.StartDefuse then
				tr.Entity:StartDefuse(ply)
			end
		end
	end
	
	if !ply:Alive() then
		if KeyPressFunc[key] then
			KeyPressFunc[key](ply)
		end
	end
end