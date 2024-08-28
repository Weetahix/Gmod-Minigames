AddCSLuaFile()

SWEP.HoldType 						= "pistol"

if CLIENT then
	SWEP.PrintName 					= "Five-Seven"
	
	SWEP.Icon 						= "u"
	
	killicon.AddFont("weapon_fiveseven", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mgbase"
SWEP.Weight							= 6
SWEP.Primary.Recoil					= 0.5
SWEP.Primary.Damage 				= 30
SWEP.Primary.Delay 					= 0.1
SWEP.Primary.Cone 					= 0.015
SWEP.Primary.ClipSize 				= 20
SWEP.Primary.Automatic 				= false
SWEP.Primary.DefaultClip 			= 20
SWEP.Primary.Ammo 					= "pistol"

SWEP.DamageScale 					= {}
SWEP.DamageScale[HITGROUP_HEAD]		= 2.9
SWEP.DamageScale[HITGROUP_CHEST] 	= 0.7
SWEP.DamageScale[HITGROUP_STOMACH] 	= 0.9
SWEP.DamageScale[HITGROUP_LEFTARM] 	= 0.5
SWEP.DamageScale[HITGROUP_RIGHTARM] = 0.5
SWEP.DamageScale[HITGROUP_LEFTLEG] 	= 0.5
SWEP.DamageScale[HITGROUP_RIGHTLEG] = 0.5

SWEP.Slot 							= 1
SWEP.UseHands						= true
SWEP.ViewModel  					= "models/weapons/cstrike/c_pist_fiveseven.mdl"
SWEP.WorldModel 					= "models/weapons/w_pist_fiveseven.mdl"

SWEP.Primary.Sound 					= Sound("Weapon_FiveSeven.Single")
SWEP.IronSightsPos 					= Vector(-4, -10, 3)
SWEP.IronSightsAng 					= Vector(0, 2, -3)

function SWEP:SecondaryAttack() end