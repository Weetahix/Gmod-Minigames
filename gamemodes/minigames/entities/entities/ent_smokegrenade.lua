AddCSLuaFile()

ENT.Type			= "anim"
ENT.Base			= "ent_basegrenade"
ENT.Model			= Model("models/weapons/w_eq_smokegrenade.mdl")
ENT.TouchNonPlayer	= Sound("SmokeGrenade.Bounce")
ENT.ExplodeSound	= Sound("BaseSmokeEffect.Sound")
ENT.Icon			= "Q"

if CLIENT then
	killicon.AddFont("ent_smokegrenade", "KillIcons", ENT.Icon, Color(255, 80, 0))
end

function ENT:Explode()
	if CLIENT then		
		self:EmitSound(self.ExplodeSound)
		
		local particles = {
			Model("particle/particle_smokegrenade"),
			Model("particle/particle_noisesphere")
		}
		
		local pos = self:GetPos()
		
		local em = ParticleEmitter(pos)
		
		for i = 1, 40 do
			local prpos = VectorRand() * 20
			prpos.z = prpos.z + 32
			
			local p = em:Add(table.Random(particles), pos + prpos)
			
			if p then
				local gray = math.random(120, 200)
				
				p:SetColor(gray, gray, gray)
				p:SetStartAlpha(255)
				p:SetEndAlpha(200)
				p:SetVelocity(VectorRand() * math.Rand(900, 1300))
				p:SetLifeTime(0)
				p:SetDieTime(math.Rand(40, 50))
				p:SetStartSize(math.Rand(150, 250))
				p:SetEndSize(math.Rand(1, 50))
				p:SetRoll(math.random(-180, 180))
				p:SetRollDelta(math.Rand(-0.1, 0.1))
				p:SetAirResistance(600)
				p:SetCollide(true)
				p:SetBounce(0.4)
				p:SetLighting(false)
			end
		end
		
		em:Finish()
	else
		self:Remove()
	end
end