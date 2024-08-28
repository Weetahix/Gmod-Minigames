AddCSLuaFile()

ENT.Type			= "anim"
ENT.Base			= "ent_basegrenade"
ENT.Model			= Model("models/weapons/w_eq_flashbang_thrown.mdl")
ENT.TouchNonPlayer	= Sound("Flashbang.Bounce")
ENT.ExplodeSound	= Sound("Flashbang.Explode")
ENT.Icon			= "P"

if CLIENT then
	killicon.AddFont("ent_flashbang", "KillIcons", ENT.Icon, Color(255, 80, 0))
end

function ENT:Explode()
	if CLIENT then
		if self:GetOwner() == LocalPlayer() and !self:GetExplodedInHands() or self:GetOwner() != LocalPlayer() then
			self:EmitSound(self.ExplodeSound)
			
			local pos = self:GetPos()
			local lp = LocalPlayer()
			
			if lp:IsLineOfSightClear(pos) then
				local dist = lp:GetPos():Distance(pos)
				local FlashTime = 10 - dist / 300
				
				if FlashTime < 2 then
					FlashTime = 2
				end
				
				if dist > 50 and !pos:ToScreen().visible then
					FlashTime = FlashTime * 0.2
				end
				
				local time = CurTime() + FlashTime
				
				if FlashEndTime and FlashEndTime < time or !FlashEndTime then
					FlashEndTime = time
				else
					return
				end
				
				if FlashTime > 3 then
					FlashbangSoundID = FlashbangSoundID and FlashbangSoundID + 1 or 0
					
					sound.Generate("flashbangsound" .. FlashbangSoundID, 11025, FlashTime - 0.5, function(t)
						return math.sin(t * math.pi * 2 / 11025 * 3500) * (1 - t / (11025 * (FlashTime - 0.5))) / 2
					end)
					
					surface.PlaySound("flashbangsound" .. FlashbangSoundID)
				end
			end
		end
	else
		self:Remove()
	end
end