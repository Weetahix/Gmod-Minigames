AddCSLuaFile()

SWEP.HoldType 						= "pistol"

if CLIENT then
	SWEP.PrintName 					= "USP"
	
	SWEP.Icon 						= "y"
	
	killicon.AddFont("weapon_usp", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mgbase"
SWEP.Weight							= 6
SWEP.Primary.Recoil					= 0.5
SWEP.Primary.Damage 				= 35
SWEP.Primary.Delay 					= 0.15
SWEP.Primary.Cone 					= 0.015
SWEP.Primary.ClipSize 				= 12
SWEP.Primary.Automatic 				= false
SWEP.Primary.DefaultClip 			= 12
SWEP.Primary.Ammo 					= "pistol"

SWEP.DamageScale 					= {}
SWEP.DamageScale[HITGROUP_HEAD]		= 3
SWEP.DamageScale[HITGROUP_CHEST] 	= 0.8
SWEP.DamageScale[HITGROUP_STOMACH] 	= 1
SWEP.DamageScale[HITGROUP_LEFTARM] 	= 0.4
SWEP.DamageScale[HITGROUP_RIGHTARM] = 0.4
SWEP.DamageScale[HITGROUP_LEFTLEG] 	= 0.4
SWEP.DamageScale[HITGROUP_RIGHTLEG] = 0.4

SWEP.Slot 							= 1
SWEP.UseSilencer					= true
SWEP.UseHands						= true
SWEP.ViewModel  					= "models/weapons/cstrike/c_pist_usp.mdl"
SWEP.WorldModel 					= "models/weapons/w_pist_usp.mdl"

SWEP.Primary.Sound 					= Sound("Weapon_USP.Single")
SWEP.Primary.SilencerSound			= Sound("Weapon_USP.SilencedShot")
SWEP.IronSightsPos 					= Vector(-3.5, -10, 3)
SWEP.IronSightsAng 					= Vector(0, 2, -1)

function SWEP:SecondaryAttack() 
	if self.UseSilencer then
		self:ToggleSilencer()
	end
end