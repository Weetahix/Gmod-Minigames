AddCSLuaFile()

SWEP.HoldType 						= "ar2"

if CLIENT then
	SWEP.PrintName 					= "M249"
	
	SWEP.Icon 						= "z"
	
	killicon.AddFont("weapon_m249", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mgbase"
SWEP.Weight							= 7
SWEP.Primary.Recoil					= 0.5
SWEP.Primary.Damage 				= 40
SWEP.Primary.Delay 					= 0.08
SWEP.Primary.Cone 					= 0.03
SWEP.Primary.ClipSize 				= 100
SWEP.Primary.Automatic 				= true
SWEP.Primary.DefaultClip 			= 100
SWEP.Primary.Ammo 					= "smg1"

SWEP.DamageScale 					= {}
SWEP.DamageScale[HITGROUP_HEAD]		= 3.1
SWEP.DamageScale[HITGROUP_CHEST] 	= 0.8
SWEP.DamageScale[HITGROUP_STOMACH] 	= 1
SWEP.DamageScale[HITGROUP_LEFTARM] 	= 0.6
SWEP.DamageScale[HITGROUP_RIGHTARM] = 0.6
SWEP.DamageScale[HITGROUP_LEFTLEG] 	= 0.6
SWEP.DamageScale[HITGROUP_RIGHTLEG] = 0.6

SWEP.Slot 							= 0
SWEP.UseHands						= true
SWEP.ViewModel  					= "models/weapons/cstrike/c_mach_m249para.mdl"
SWEP.WorldModel 					= "models/weapons/w_mach_m249para.mdl"

SWEP.Primary.Sound 					= Sound("Weapon_M249.Single")
SWEP.IronSightsPos 					= Vector(-4, -5, 3.5)
SWEP.IronSightsAng 					= Vector(0.7, 0, -1)

function SWEP:SecondaryAttack() end