AddCSLuaFile()

SWEP.HoldType 						= "ar2"

if CLIENT then
	SWEP.PrintName 					= "Galil"
	
	SWEP.Icon 						= "v"
	
	killicon.AddFont("weapon_galil", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mgbase"
SWEP.Weight							= 7
SWEP.Primary.Recoil					= 0.5
SWEP.Primary.Damage 				= 30
SWEP.Primary.Delay 					= 0.12
SWEP.Primary.Cone 					= 0.018
SWEP.Primary.ClipSize 				= 35
SWEP.Primary.Automatic 				= true
SWEP.Primary.DefaultClip 			= 35
SWEP.Primary.Ammo 					= "smg1"

SWEP.DamageScale 					= {}
SWEP.DamageScale[HITGROUP_HEAD]		= 3.8
SWEP.DamageScale[HITGROUP_CHEST] 	= 0.9
SWEP.DamageScale[HITGROUP_STOMACH] 	= 1.2
SWEP.DamageScale[HITGROUP_LEFTARM] 	= 0.7
SWEP.DamageScale[HITGROUP_RIGHTARM] = 0.7
SWEP.DamageScale[HITGROUP_LEFTLEG] 	= 0.7
SWEP.DamageScale[HITGROUP_RIGHTLEG] = 0.7

SWEP.Slot 							= 0
SWEP.UseHands						= true
SWEP.ViewModel  					= "models/weapons/cstrike/c_rif_galil.mdl"
SWEP.WorldModel 					= "models/weapons/w_rif_galil.mdl"

SWEP.Primary.Sound 					= Sound("Weapon_Galil.Single")
SWEP.IronSightsPos 					= Vector(-3, -5, 3)
SWEP.IronSightsAng 					= Vector(0.7, 1, -1)

function SWEP:SecondaryAttack() end