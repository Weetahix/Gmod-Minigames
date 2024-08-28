AddCSLuaFile()

SWEP.HoldType 						= "ar2"

if CLIENT then
	SWEP.PrintName 					= "SG-550"
	SWEP.DrawCrosshair				= false
	
	SWEP.Icon 						= "o"
	
	killicon.AddFont("weapon_sg550", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mg_sniper_base"
SWEP.Weight							= 7
SWEP.Primary.Recoil					= 0.5
SWEP.Primary.CrosshairRecoil		= 0.3
SWEP.Primary.Damage 				= 60
SWEP.Primary.Delay 					= 0.25
SWEP.Primary.Cone 					= 0.04
SWEP.Primary.CrosshairCone			= 0.002
SWEP.Primary.ClipSize 				= 30
SWEP.Primary.Automatic 				= true
SWEP.Primary.DefaultClip 			= 30
SWEP.Primary.Ammo 					= "357"
SWEP.Primary.MouseSensitivity		= {
	0.3,
	0.2
}
SWEP.ZoomLevels						= {}
SWEP.ZoomLevels[1]					= 40
SWEP.ZoomLevels[2]					= 20

SWEP.DamageScale 					= {}
SWEP.DamageScale[HITGROUP_HEAD]		= 4.3
SWEP.DamageScale[HITGROUP_CHEST] 	= 1.1
SWEP.DamageScale[HITGROUP_STOMACH] 	= 1.3
SWEP.DamageScale[HITGROUP_LEFTARM] 	= 0.8
SWEP.DamageScale[HITGROUP_RIGHTARM] = 0.8
SWEP.DamageScale[HITGROUP_LEFTLEG] 	= 0.8
SWEP.DamageScale[HITGROUP_RIGHTLEG] = 0.8

SWEP.Slot 							= 0
SWEP.UseHands						= true
SWEP.ViewModel  					= "models/weapons/cstrike/c_snip_sg550.mdl"
SWEP.WorldModel 					= "models/weapons/w_snip_sg550.mdl"

SWEP.Primary.Sound 					= Sound("Weapon_SG550.Single")
SWEP.IronSightsPos 					= Vector(-7.5, -12.5, 3.5)
SWEP.IronSightsAng 					= Vector(5, -2, 0)