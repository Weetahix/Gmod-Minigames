AddCSLuaFile()

SWEP.HoldType 						= "smg"

if CLIENT then
	SWEP.PrintName 					= "MAC-10"
	
	SWEP.Icon 						= "l"
	
	killicon.AddFont("weapon_mac10", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mgbase"
SWEP.Weight							= 7
SWEP.Primary.Recoil					= 0.5
SWEP.Primary.Damage 				= 35
SWEP.Primary.Delay 					= 0.09
SWEP.Primary.Cone 					= 0.03
SWEP.Primary.ClipSize 				= 30
SWEP.Primary.Automatic 				= true
SWEP.Primary.DefaultClip 			= 30
SWEP.Primary.Ammo 					= "smg1"

SWEP.DamageScale 					= {}
SWEP.DamageScale[HITGROUP_HEAD]		= 2.6
SWEP.DamageScale[HITGROUP_CHEST] 	= 0.6
SWEP.DamageScale[HITGROUP_STOMACH] 	= 0.8
SWEP.DamageScale[HITGROUP_LEFTARM] 	= 0.4
SWEP.DamageScale[HITGROUP_RIGHTARM] = 0.4
SWEP.DamageScale[HITGROUP_LEFTLEG] 	= 0.4
SWEP.DamageScale[HITGROUP_RIGHTLEG] = 0.4

SWEP.Slot 							= 0
SWEP.UseHands						= true
SWEP.ViewModel  					= "models/weapons/cstrike/c_smg_mac10.mdl"
SWEP.WorldModel 					= "models/weapons/w_smg_mac10.mdl"

SWEP.Primary.Sound 					= Sound("Weapon_MAC10.Single")
SWEP.IronSightsPos 					= Vector(-7, -10, 3)
SWEP.IronSightsAng 					= Vector(0.7, -3, -7.5)

function SWEP:SecondaryAttack() end