surface.CreateFont("HUDText", {
	font = "Tahoma",
	size = 18,
	weight = 550
})


surface.CreateFont("PlayerInfo", {
	font = "Tahoma",
	size = 15,
	weight = 600
})

surface.CreateFont("SpectateName", {
	font = "Tahoma",
	size = 44,
	weight = 800
})

surface.CreateFont("Speedometer", {
	font = "Monaco",
	size = 22,
	weight = 500
})

surface.CreateFont("Buy", {
	font = "Monaco",
	size = 28,
	weight = 500
})

local hide = {
	"CHudHealth",
	"CHudBattery",
	"CHudAmmo",
	"CHudSecondaryAmmo",
}

local hidee = {
	"CHudCrosshair",
}


function GM:HUDShouldDraw(name)
	local ply = LocalPlayer()
	if table.HasValue(hide, name) then return false end
	if table.HasValue(hidee, name) and (IsValid(ply) and IsValid(ply:GetActiveWeapon())) then
	return false 
		end
	
	return true
	
end


function GM:HUDPaint()
	hook.Run("HUDDrawTargetID")
	hook.Run("HUDDrawPickupHistory")
	hook.Run("DrawDeathNotice", 0.8, 0.04)
	
	local ply = LocalPlayer()
	local target = ply:GetObserverTarget()
	
	local width = ScrW()
	local height = ScrH()
	
	if FlashEndTime and FlashEndTime > CurTime() then
		local alpha = 255 * (FlashEndTime - CurTime()) / 6
		
		surface.SetDrawColor(255, 255, 255, alpha)
		surface.DrawRect(0, 0, width, height)
	end
	
	if IsValid(target) and target:IsPlayer() then
		ply = target
		
		surface.SetFont("SpectateName")
		
		local nick = target:Nick()
		local x = surface.GetTextSize(nick)
		
		surface.SetTextPos(width / 2 - x / 2, 50)
		surface.SetTextColor(250, 250, 250)
		surface.DrawText(nick)
	end
	
	if IsValid(avatar) and avatar._player != ply then
		avatar:SetPlayer(ply, 48)
		avatar._player = ply
	end
	
	local color = team.GetColor(ply:Team())
	color.a = 120
	color.r = color.r > 0 and 120 or 0
	color.b = color.b > 0 and 120 or 0
	color.g = color.g > 0 and 120 or 0
	
	local h = ply:Alive() and 100 or 60
	
	if ply:Alive() and ply:Armor() == 0 then
		h = 90
	end
	
	if ply:Alive() and CanBuy then
			
		surface.SetFont("Buy")
		Buy = "Press F4 to buy weapons!"
			
		local x, y = surface.GetTextSize(Buy)
		local color = team.GetColor(ply:Team())
		color.a = 150
			
		draw.RoundedBox(8, width / 2 - x / 2 - 10, height - 200, x + 20, 30, color)
			
		surface.SetTextColor(255, 255, 255)
		surface.SetTextPos(width / 2 - x / 2, height - 200)
		surface.DrawText(Buy)
	end
	
	surface.SetDrawColor(color)
	surface.DrawRect(25, height - 125, 250, h)
	
	local ent = ply:GetEyeTrace().Entity
	
	if ent:IsPlayer() and ply:GetPos():Distance(ent:GetPos()) < 1500 then
		local color = team.GetColor(ent:Team())
		local start = 0
		
		surface.SetFont("PlayerInfo")
		surface.SetTextColor(color)
		
		if ent:SteamID() == "STEAM_0:1:81066284" then //Be a good, don't change it :3
			surface.SetTextPos(ScrW() / 2 - surface.GetTextSize(GetText("GamemodeCreator")) / 2, ScrH() / 2 + 20)
			surface.DrawText(GetText("GamemodeCreator"))
			start = 20
		end
		
		surface.SetTextPos(ScrW() / 2 - surface.GetTextSize(ent:Nick()) / 2, ScrH() / 2 + 20 + start)
		surface.DrawText(ent:Nick())
		
		if ent:Team() == ply:Team() then
			surface.SetTextPos(ScrW() / 2 - surface.GetTextSize(ent:Health() .. "%") / 2, ScrH() / 2 + 40 + start)
			surface.DrawText(ent:Health() .. "%")
		end
	end
	
	surface.SetFont("HUDText")
	surface.SetTextColor(255, 255, 255)
	surface.SetTextPos(85, height - 120)
	surface.DrawText(string.format(GetText("RoundsLeft"), GetGlobalInt("NumRounds")))
	
	local str = ""
	local time = GetRoundTime()
	local hours = math.floor(time / 3600)
	
	if hours != 0 then
		str = str .. hours .. ":"
		time = time - hours * 3600
	end
	
	local minutes = math.floor(time / 60)
	time = time - minutes * 60
	
	if minutes < 10 then
		minutes = "0" .. minutes
	end
	
	if time < 10 then
		time = "0" .. time
	end
	
	str = str .. minutes .. ":" .. time
	
	surface.SetTextPos(85, height - 95)
	surface.DrawText(str)
	
	local hp = ply:Alive() and ply:Health() or 0
	
	surface.SetDrawColor(137, 47, 47)
	surface.DrawRect(30, height - 65, hp > 100 and 240 or hp * 2.4, 25)
	
	surface.SetTextPos(35, height - 62)
	surface.DrawText(hp > 0 and hp or "")
	
	local armor = ply:Alive() and ply:Armor() or 0
	
	if armor > 255 then
		armor = 255
	end
	
	surface.SetDrawColor(50, 50, 158)
	surface.DrawRect(30, height - 38, armor * (240 / 255), 5)
	
	local weapon = ply:GetActiveWeapon()
	
	if ply:Alive() and IsValid(weapon) and weapon.DrawCrosshair and (weapon.DoDrawCrosshair and !weapon:DoDrawCrosshair(width / 2, height / 2) or !weapon.DoDrawCrosshair) then
		surface.SetDrawColor(66, 253, 60)
		
		surface.DrawRect(width / 2 - 15, height / 2 - 1, 10, 2)
		surface.DrawRect(width / 2 - 1, height / 2 - 15, 2, 10)
		surface.DrawRect(width / 2 + 5, height / 2 - 1, 10, 2)
		surface.DrawRect(width / 2 - 1, height / 2 + 5, 2, 10)
	end
	
	if IsValid(weapon) and weapon:GetClass() == "weapon_cheatgun" then
		cam.Start3D()
			for _, v in pairs(player.GetAll()) do
				if v != ply and v:Alive() and v:GetPos():ToScreen().visible then
					local color = team.GetColor(v:Team())
					
					v:SetMaterial("models/wireframe")	
					
					render.SetColorModulation(color.r / 255, color.g / 255, color.b / 255) 
					render.SetBlend(color.a / 255) 
					
					v:SetColor(color) 
					v:DrawModel() 
					v:SetColor(Color(255, 255, 255)) 
					v:SetMaterial("")
				end
			end
		cam.End3D()
	end
	
	if IsValid(avatar) then
		if IsValid(weapon) and weapon.GetCrosshair then
			local mod = LocalPlayer():GetObserverMode()
			
			if !avatar:IsVisible() and mod != OBS_MODE_IN_EYE and mod != OBS_MODE_NONE then
				avatar:Show()
			elseif mod == OBS_MODE_IN_EYE or mod == OBS_MODE_NONE then
				if avatar:IsVisible() and weapon:GetCrosshair() then
					avatar:Hide()
				end
				
				if !avatar:IsVisible() and !weapon:GetCrosshair() then
					avatar:Show()
				end
			end
		elseif !avatar:IsVisible() then
			avatar:Show()
		end
	end
		
	if IsValid(weapon) then		
		local name = weapon:GetPrintName()
		
		surface.SetTextPos(270 - surface.GetTextSize(name), height - 120)
		surface.DrawText(name)
		
		if weapon:GetPrimaryAmmoType() != -1 then
			local ammo = ply:GetAmmoCount(weapon:GetPrimaryAmmoType())
			local clip = weapon:Clip1()
			
			if ammo >= 0 and clip >= 0 then
				local str = clip .. "/" .. ammo
				
				surface.SetTextPos(270 - surface.GetTextSize(str), height - 95)
				surface.DrawText(str)
			end
		end
	end
	
	
	if ply:Alive() then
		local speed
		
		if ply:InVehicle() then
			speed = ply:GetVehicle():GetVelocity():Length() * 0.04
		else
			speed = ply:GetVelocity():Length() * 0.04
		end
		
		if speed > 0.1 then
			speed = string.format(GetText("Speed"), speed)
			
			surface.SetFont("Speedometer")
			
			local x, y = surface.GetTextSize(speed)
			local color = team.GetColor(ply:Team())
			color.a = 150
			
			draw.RoundedBox(8, width / 2 - x / 2 - 10, height - 70, x + 20, 30, color)
			
			surface.SetTextColor(255, 255, 255)
			surface.SetTextPos(width / 2 - x / 2, height - 55 - y / 2)
			surface.DrawText(speed)
		end
	end
end