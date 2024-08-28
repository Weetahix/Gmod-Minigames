AddCSLuaFile()

SWEP.HoldType 						= "ar2"

if CLIENT then
	SWEP.PrintName 					= "AK-47"
	
	SWEP.Icon 						= "b"
	
	killicon.AddFont("weapon_ak47", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mgbase"
SWEP.Weight							= 7
SWEP.Primary.Recoil					= 0.5
SWEP.Primary.Damage 				= 40
SWEP.Primary.Delay 					= 0.1
SWEP.Primary.Cone 					= 0.022
SWEP.Primary.ClipSize 				= 30
SWEP.Primary.Automatic 				= true
SWEP.Primary.DefaultClip 			= 30
SWEP.Primary.Ammo 					= "smg1"

SWEP.DamageScale 					= {}
SWEP.DamageScale[HITGROUP_HEAD]		= 3.5
SWEP.DamageScale[HITGROUP_CHEST] 	= 0.9
SWEP.DamageScale[HITGROUP_STOMACH] 	= 1.1
SWEP.DamageScale[HITGROUP_LEFTARM] 	= 0.6
SWEP.DamageScale[HITGROUP_RIGHTARM] = 0.6
SWEP.DamageScale[HITGROUP_LEFTLEG] 	= 0.6
SWEP.DamageScale[HITGROUP_RIGHTLEG] = 0.6

SWEP.Slot 							= 0
SWEP.UseHands						= true
SWEP.ViewModel  					= "models/weapons/cstrike/c_rif_ak47.mdl"
SWEP.WorldModel 					= "models/weapons/w_rif_ak47.mdl"

SWEP.Primary.Sound 					= Sound("Weapon_AK47.Single")
SWEP.IronSightsPos 					= Vector(-5, -10, 4)
SWEP.IronSightsAng 					= Vector(0.7, 0, -1)

function SWEP:SecondaryAttack() end