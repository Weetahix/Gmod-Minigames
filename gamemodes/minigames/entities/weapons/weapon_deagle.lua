AddCSLuaFile()

SWEP.HoldType 						= "pistol"

if CLIENT then
	SWEP.PrintName 					= "Deagle"
	
	SWEP.Icon 						= "f"
	
	killicon.AddFont("weapon_deagle", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mgbase"
SWEP.Weight							= 6
SWEP.Primary.Recoil					= 0.6
SWEP.Primary.Damage 				= 50
SWEP.Primary.Delay 					= 0.2
SWEP.Primary.Cone 					= 0.025
SWEP.Primary.ClipSize 				= 7
SWEP.Primary.Automatic 				= false
SWEP.Primary.DefaultClip 			= 7
SWEP.Primary.Ammo 					= "357"

SWEP.DamageScale 					= {}
SWEP.DamageScale[HITGROUP_HEAD]		= 3.4
SWEP.DamageScale[HITGROUP_CHEST] 	= 0.9
SWEP.DamageScale[HITGROUP_STOMACH] 	= 1.1
SWEP.DamageScale[HITGROUP_LEFTARM] 	= 0.6
SWEP.DamageScale[HITGROUP_RIGHTARM] = 0.6
SWEP.DamageScale[HITGROUP_LEFTLEG] 	= 0.6
SWEP.DamageScale[HITGROUP_RIGHTLEG] = 0.6

SWEP.Slot 							= 1
SWEP.UseHands						= true
SWEP.ViewModel  					= "models/weapons/cstrike/c_pist_deagle.mdl"
SWEP.WorldModel 					= "models/weapons/w_pist_deagle.mdl"

SWEP.Primary.Sound 					= Sound("Weapon_Deagle.Single")
SWEP.IronSightsPos 					= Vector(-4.5, -10, 2.5)
SWEP.IronSightsAng 					= Vector(0, 1, -3)

function SWEP:SecondaryAttack() end