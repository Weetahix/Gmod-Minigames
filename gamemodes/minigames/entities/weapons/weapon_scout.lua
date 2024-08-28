AddCSLuaFile()

SWEP.HoldType 						= "ar2"

if CLIENT then
	SWEP.PrintName 					= "Scout"
	SWEP.DrawCrosshair				= false
	
	SWEP.Icon 						= "n"
	
	killicon.AddFont("weapon_scout", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mg_sniper_base"
SWEP.Weight							= 7
SWEP.Primary.Recoil					= 0.5
SWEP.Primary.CrosshairRecoil		= 1.5
SWEP.Primary.Damage 				= 70
SWEP.Primary.Delay 					= 1
SWEP.Primary.Cone 					= 0.06
SWEP.Primary.CrosshairCone			= 0.002
SWEP.Primary.ClipSize 				= 10
SWEP.Primary.Automatic 				= false
SWEP.Primary.DefaultClip 			= 10
SWEP.Primary.Ammo 					= "357"
SWEP.Primary.MouseSensitivity		= {
	0.3,
	0.2
}

SWEP.ZoomLevels						= {}
SWEP.ZoomLevels[1]					= 40
SWEP.ZoomLevels[2]					= 20

SWEP.DamageScale 					= {}
SWEP.DamageScale[HITGROUP_HEAD]		= 3.9
SWEP.DamageScale[HITGROUP_CHEST] 	= 1
SWEP.DamageScale[HITGROUP_STOMACH] 	= 1.2
SWEP.DamageScale[HITGROUP_LEFTARM] 	= 0.8
SWEP.DamageScale[HITGROUP_RIGHTARM] = 0.8
SWEP.DamageScale[HITGROUP_LEFTLEG] 	= 0.8
SWEP.DamageScale[HITGROUP_RIGHTLEG] = 0.8

SWEP.Slot 							= 0
SWEP.UseHands						= true
SWEP.ViewModel  					= "models/weapons/cstrike/c_snip_scout.mdl"
SWEP.WorldModel 					= "models/weapons/w_snip_scout.mdl"

SWEP.Primary.Sound 					= Sound("Weapon_SCOUT.Single")
SWEP.IronSightsPos 					= Vector(-7, -13, 4.5)
SWEP.IronSightsAng 					= Vector(5, -2, 0)