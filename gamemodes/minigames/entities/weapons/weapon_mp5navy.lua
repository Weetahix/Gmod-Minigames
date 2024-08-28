AddCSLuaFile()

SWEP.HoldType 						= "smg"

if CLIENT then
	SWEP.PrintName 					= "MP5"
	
	SWEP.Icon 						= "x"
	
	killicon.AddFont("weapon_mp5navy", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mgbase"
SWEP.Weight							= 7
SWEP.Primary.Recoil					= 0.5
SWEP.Primary.Damage 				= 30
SWEP.Primary.Delay 					= 0.09
SWEP.Primary.Cone 					= 0.025
SWEP.Primary.ClipSize 				= 30
SWEP.Primary.Automatic 				= true
SWEP.Primary.DefaultClip 			= 30
SWEP.Primary.Ammo 					= "smg1"

SWEP.DamageScale 					= {}
SWEP.DamageScale[HITGROUP_HEAD]		= 2.9
SWEP.DamageScale[HITGROUP_CHEST] 	= 0.7
SWEP.DamageScale[HITGROUP_STOMACH] 	= 0.9
SWEP.DamageScale[HITGROUP_LEFTARM] 	= 0.5
SWEP.DamageScale[HITGROUP_RIGHTARM] = 0.5
SWEP.DamageScale[HITGROUP_LEFTLEG] 	= 0.5
SWEP.DamageScale[HITGROUP_RIGHTLEG] = 0.5

SWEP.Slot 							= 0
SWEP.UseHands						= true
SWEP.ViewModel  					= "models/weapons/cstrike/c_smg_mp5.mdl"
SWEP.WorldModel 					= "models/weapons/w_smg_mp5.mdl"

SWEP.Primary.Sound 					= Sound("Weapon_MP5Navy.Single")
SWEP.IronSightsPos 					= Vector(-3, -7, 3)
SWEP.IronSightsAng 					= Vector(0.7, 2, -7.5)

function SWEP:SecondaryAttack() end