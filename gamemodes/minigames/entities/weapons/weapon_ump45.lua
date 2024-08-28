AddCSLuaFile()

SWEP.HoldType 						= "smg"

if CLIENT then
	SWEP.PrintName 					= "UMP 45"
	
	SWEP.Icon 						= "q"
	
	killicon.AddFont("weapon_ump45", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mgbase"
SWEP.Weight							= 7
SWEP.Primary.Recoil					= 0.5
SWEP.Primary.Damage 				= 30
SWEP.Primary.Delay 					= 0.11
SWEP.Primary.Cone 					= 0.018
SWEP.Primary.ClipSize 				= 25
SWEP.Primary.Automatic 				= true
SWEP.Primary.DefaultClip 			= 25
SWEP.Primary.Ammo 					= "smg1"

SWEP.DamageScale 					= {}
SWEP.DamageScale[HITGROUP_HEAD]		= 2.9
SWEP.DamageScale[HITGROUP_CHEST] 	= 0.8
SWEP.DamageScale[HITGROUP_STOMACH] 	= 1
SWEP.DamageScale[HITGROUP_LEFTARM] 	= 0.6
SWEP.DamageScale[HITGROUP_RIGHTARM] = 0.6
SWEP.DamageScale[HITGROUP_LEFTLEG] 	= 0.6
SWEP.DamageScale[HITGROUP_RIGHTLEG] = 0.6

SWEP.Slot 							= 0
SWEP.UseHands						= true
SWEP.ViewModel  					= "models/weapons/cstrike/c_smg_ump45.mdl"
SWEP.WorldModel 					= "models/weapons/w_smg_ump45.mdl"

SWEP.Primary.Sound 					= Sound("Weapon_UMP45.Single")
SWEP.IronSightsPos 					= Vector(-5, -10, 3.5)
SWEP.IronSightsAng 					= Vector(0.7, 2, -7.5)

function SWEP:SecondaryAttack() end