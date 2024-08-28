AddCSLuaFile()

SWEP.HoldType 						= "grenade"

if CLIENT then
	SWEP.PrintName 					= "FlashBang"
	
	SWEP.Icon 						= "P"
	
	killicon.AddFont("weapon_flashbang", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mg_grenade_base"

SWEP.Slot 							= 3
SWEP.UseHands						= true
SWEP.ViewModel  					= "models/weapons/cstrike/c_eq_flashbang.mdl"
SWEP.WorldModel 					= "models/weapons/w_eq_flashbang.mdl"

SWEP.EntName						= "ent_flashbang"
SWEP.DetonateTime					= 3

SWEP.Primary.Distance				= 1200

SWEP.Secondary.Distance				= 350

function SWEP:OnExplodeInHands()
	if CLIENT and IsValid(self.Owner) and self.Owner == LocalPlayer() then
		FlashEndTime = CurTime() + 1
		
		FlashbangSoundID = FlashbangSoundID and FlashbangSoundID + 1 or 0
		
		sound.Generate("flashbangsound" .. FlashbangSoundID, 11025, 6.5, function(t)
			return math.sin(t * math.pi * 2 / 11025 * 3500) * (1 - t / (11025 * (6.5))) / 2
		end)
		
		surface.PlaySound("flashbangsound" .. FlashbangSoundID)
	end
end