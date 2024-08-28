AddCSLuaFile()

SWEP.HoldType 						= "ar2"

if CLIENT then
	SWEP.PrintName 					= "G3/SG-1"
	SWEP.DrawCrosshair				= false
	
	SWEP.Icon 						= "i"
	
	killicon.AddFont("weapon_g3sg1", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mg_sniper_base"
SWEP.Weight							= 7
SWEP.Primary.Recoil					= 0.5
SWEP.Primary.CrosshairRecoil		= 0.3
SWEP.Primary.Damage 				= 70
SWEP.Primary.Delay 					= 0.25
SWEP.Primary.Cone 					= 0.05
SWEP.Primary.CrosshairCone			= 0.003
SWEP.Primary.ClipSize 				= 20
SWEP.Primary.Automatic 				= true
SWEP.Primary.DefaultClip 			= 20
SWEP.Primary.Ammo 					= "357"
SWEP.Primary.MouseSensitivity		= {
	0.3,
	0.2
}

SWEP.ZoomLevels						= {}
SWEP.ZoomLevels[1]					= 40
SWEP.ZoomLevels[2]					= 20

SWEP.DamageScale 					= {}
SWEP.DamageScale[HITGROUP_HEAD]		= 4.2
SWEP.DamageScale[HITGROUP_CHEST] 	= 1
SWEP.DamageScale[HITGROUP_STOMACH] 	= 1.3
SWEP.DamageScale[HITGROUP_LEFTARM] 	= 0.7
SWEP.DamageScale[HITGROUP_RIGHTARM] = 0.7
SWEP.DamageScale[HITGROUP_LEFTLEG] 	= 0.7
SWEP.DamageScale[HITGROUP_RIGHTLEG] = 0.7

SWEP.Slot 							= 0
SWEP.UseHands						= true
SWEP.ViewModel  					= "models/weapons/cstrike/c_snip_g3sg1.mdl"
SWEP.WorldModel 					= "models/weapons/w_snip_g3sg1.mdl"

SWEP.Primary.Sound 					= Sound("Weapon_G3SG1.Single")
SWEP.IronSightsPos 					= Vector(-6.2, -9, 3.5)
SWEP.IronSightsAng 					= Vector(5, 0, 0)