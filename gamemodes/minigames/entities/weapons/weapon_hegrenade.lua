AddCSLuaFile()

SWEP.HoldType 						= "grenade"

if CLIENT then
	SWEP.PrintName 					= "Grenade"
	
	SWEP.Icon 						= "O"
	
	killicon.AddFont("weapon_hegrenade", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mg_grenade_base"

SWEP.Slot 							= 3
SWEP.UseHands						= true
SWEP.ViewModel  					= "models/weapons/cstrike/c_eq_fraggrenade.mdl"
SWEP.WorldModel 					= "models/weapons/w_eq_fraggrenade.mdl"

SWEP.EntName						= "ent_hegrenade"
SWEP.DetonateTime					= 3

SWEP.Primary.Distance				= 1200

SWEP.Secondary.Distance				= 350
