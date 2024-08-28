AddCSLuaFile()

SWEP.HoldType 						= "pistol"

if CLIENT then
	SWEP.PrintName 					= "P228"
	
	SWEP.Icon 						= "y"
	
	killicon.AddFont("weapon_p228", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mgbase"
SWEP.Weight							= 6
SWEP.Primary.Recoil					= 0.5
SWEP.Primary.Damage 				= 40
SWEP.Primary.Delay 					= 0.1
SWEP.Primary.Cone 					= 0.04
SWEP.Primary.ClipSize 				= 13
SWEP.Primary.Automatic 				= false
SWEP.Primary.DefaultClip 			= 13
SWEP.Primary.Ammo 					= "pistol"

SWEP.DamageScale 					= {}
SWEP.DamageScale[HITGROUP_HEAD]		= 3.1
SWEP.DamageScale[HITGROUP_CHEST] 	= 0.8
SWEP.DamageScale[HITGROUP_STOMACH] 	= 1
SWEP.DamageScale[HITGROUP_LEFTARM] 	= 0.6
SWEP.DamageScale[HITGROUP_RIGHTARM] = 0.6
SWEP.DamageScale[HITGROUP_LEFTLEG] 	= 0.6
SWEP.DamageScale[HITGROUP_RIGHTLEG] = 0.6

SWEP.Slot 							= 1
SWEP.UseHands						= true
SWEP.ViewModel  					= "models/weapons/cstrike/c_pist_p228.mdl"
SWEP.WorldModel 					= "models/weapons/w_pist_p228.mdl"

SWEP.Primary.Sound 					= Sound("Weapon_P228.Single")
SWEP.IronSightsPos 					= Vector(-4, -10, 3)
SWEP.IronSightsAng 					= Vector(0, 2, -1)

function SWEP:SecondaryAttack() end