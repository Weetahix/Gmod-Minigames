AddCSLuaFile()

ENT.Type			= "anim"
ENT.Base			= "ent_basegrenade"
ENT.Model			= Model("models/weapons/w_eq_fraggrenade.mdl")
ENT.TouchNonPlayer	= Sound("HEGrenade.Bounce")
ENT.ExplodeSound	= Sound("BaseGrenade.Explode")
ENT.Icon			= "O"

if CLIENT then
	killicon.AddFont("ent_smokegrenade", "KillIcons", ENT.Icon, Color(255, 80, 0))
end

function ENT:Explode()
	if SERVER then
		local explode = ents.Create("env_explosion")
		
		explode:SetPos(self:GetPos())
		explode:SetOwner(self.Owner)
		explode:Spawn()
		
		explode:SetKeyValue("iMagnitude", "100")
		explode:Fire("Explode", 0, 0)
		explode:EmitSound(self.ExplodeSound)
		
		self:Remove()
	end
end