AddCSLuaFile()

SWEP.HoldType 						= "grenade"

if CLIENT then
	SWEP.PrintName 					= "Smoke"
	
	SWEP.Icon 						= "Q"
	
	killicon.AddFont("weapon_smokegrenade", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mg_grenade_base"

SWEP.Slot 							= 3
SWEP.UseHands						= true
SWEP.ViewModel  					= "models/weapons/cstrike/c_eq_smokegrenade.mdl"
SWEP.WorldModel 					= "models/weapons/w_eq_smokegrenade.mdl"

SWEP.EntName						= "ent_smokegrenade"
SWEP.DetonateTime					= 4

SWEP.Primary.Distance				= 1200

SWEP.Secondary.Distance				= 350
