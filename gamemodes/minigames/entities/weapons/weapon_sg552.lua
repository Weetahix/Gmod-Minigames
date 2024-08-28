AddCSLuaFile()

SWEP.HoldType 						= "ar2"

if CLIENT then
	SWEP.PrintName 					= "SG-552"
	
	SWEP.Icon 						= "A"
	
	killicon.AddFont("weapon_aug", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mg_sniper_base"
SWEP.Weight							= 7
SWEP.Primary.Recoil					= 0.45
SWEP.Primary.CrosshairRecoil		= 0.35
SWEP.Primary.Damage 				= 35
SWEP.Primary.Delay 					= 0.1
SWEP.Primary.Cone 					= 0.016
SWEP.Primary.CrosshairCone			= 0.006
SWEP.Primary.ClipSize 				= 30
SWEP.Primary.Automatic 				= true
SWEP.Primary.DefaultClip 			= 30
SWEP.Primary.Ammo 					= "smg1"
SWEP.Primary.MouseSensitivity		= {
	0.4
}

SWEP.ZoomLevels						= {}
SWEP.ZoomLevels[1]					= 30

SWEP.DamageScale 					= {}
SWEP.DamageScale[HITGROUP_HEAD]		= 2.4
SWEP.DamageScale[HITGROUP_CHEST] 	= 0.6
SWEP.DamageScale[HITGROUP_STOMACH] 	= 0.6
SWEP.DamageScale[HITGROUP_LEFTARM] 	= 0.4
SWEP.DamageScale[HITGROUP_RIGHTARM] = 0.4
SWEP.DamageScale[HITGROUP_LEFTLEG] 	= 0.4
SWEP.DamageScale[HITGROUP_RIGHTLEG] = 0.4

SWEP.Slot 							= 0
SWEP.UseHands						= true
SWEP.ViewModel  					= "models/weapons/cstrike/c_rif_sg552.mdl"
SWEP.WorldModel 					= "models/weapons/w_rif_sg552.mdl"

SWEP.Primary.Sound 					= Sound("Weapon_SG552.Single")
SWEP.IronSightsPos 					= Vector(-8.2, -14, 4.6)
SWEP.IronSightsAng 					= Vector(0, -2, 0)

if CLIENT then	
	function SWEP:DrawHUD()
		if self:GetCrosshair() then			
			local w = ScrW()
			local h = ScrH()
			
			local x = w / 2
			local y = h / 2
			
			surface.SetDrawColor(0, 0, 0)
			
			local ls = x - y + 2
			
			surface.DrawRect(0, 0, ls, h)
			surface.DrawRect(x + y - 2, 0, ls, h)
			
			surface.DrawLine(0, 0, w, 0)
			surface.DrawLine(0, h - 1, w, h - 1)
			
			local weight = 2
			local gap = 70
			
			surface.DrawRect(ls + 30, y - weight / 2, y - gap - 30, weight)
			surface.DrawRect(x - weight / 2, y + gap, weight, y - gap - 30)
			surface.DrawRect(x + gap, y - weight / 2, y - gap - 30, weight)
			
			for i = 1, math.Round((y - gap - 30) / 20) + 1 do
				local pos = ls + 30 + (i - 1) * 20
				surface.DrawLine(pos, y - weight / 2 - 10, pos, y - weight / 2 + 10)
			end
			
			for i = 1, math.Round((y - gap - 30) / 20) + 1 do
				local pos = y + gap + (i - 1) * 20
				surface.DrawLine(x - weight / 2 - 10, pos, x - weight / 2 + 10, pos)
			end
			
			for i = 1, math.Round((y - gap - 30) / 20) + 1 do
				local pos = x + gap + (i - 1) * 20
				surface.DrawLine(pos, y - weight / 2 - 10, pos, y - weight / 2 + 10)
			end
			
			draw.NoTexture()
			surface.SetDrawColor(255, 0, 0, 150)
			surface.DrawTexturedRectRotated(x - 5, y + 10, 20, 3, 60)
			surface.DrawTexturedRectRotated(x + 5, y + 10, 20, 3, 120)
			
			surface.SetTexture(self.Secondary.Scope)
			surface.SetDrawColor(255, 255, 255)
			
			surface.DrawTexturedRectRotated(x, y, h, h, 0)
		end
	end
end