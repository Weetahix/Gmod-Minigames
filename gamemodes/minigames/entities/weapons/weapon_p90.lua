AddCSLuaFile()

SWEP.HoldType 						= "smg"

if CLIENT then
	SWEP.PrintName 					= "P90"
	
	SWEP.Icon 						= "m"
	
	killicon.AddFont("weapon_p90", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mgbase"
SWEP.Weight							= 7
SWEP.Primary.Recoil					= 0.5
SWEP.Primary.Damage 				= 35
SWEP.Primary.Delay 					= 0.08
SWEP.Primary.Cone 					= 0.015
SWEP.Primary.ClipSize 				= 50
SWEP.Primary.Automatic 				= true
SWEP.Primary.DefaultClip 			= 50
SWEP.Primary.Ammo 					= "smg1"

SWEP.DamageScale 					= {}
SWEP.DamageScale[HITGROUP_HEAD]		= 2.4
SWEP.DamageScale[HITGROUP_CHEST] 	= 0.6
SWEP.DamageScale[HITGROUP_STOMACH] 	= 0.8
SWEP.DamageScale[HITGROUP_LEFTARM] 	= 0.4
SWEP.DamageScale[HITGROUP_RIGHTARM] = 0.4
SWEP.DamageScale[HITGROUP_LEFTLEG] 	= 0.4
SWEP.DamageScale[HITGROUP_RIGHTLEG] = 0.4

SWEP.Slot 							= 0
SWEP.UseHands						= true
SWEP.ViewModel  					= "models/weapons/cstrike/c_smg_p90.mdl"
SWEP.WorldModel 					= "models/weapons/w_smg_p90.mdl"

SWEP.Primary.Sound 					= Sound("Weapon_P90.Single")
SWEP.IronSightsPos 					= Vector(-2.5, -5, 3)
SWEP.IronSightsAng 					= Vector(0.7, 4, -1)

function SWEP:SecondaryAttack() end