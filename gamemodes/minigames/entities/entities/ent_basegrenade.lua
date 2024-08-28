AddCSLuaFile()

ENT.Type			= "anim"
ENT.Model			= Model("models/weapons/w_eq_flashbang_thrown.mdl")
ENT.HitDamage		= 1
ENT.TouchNonPlayer	= Sound("Flashbang.Bounce")

function ENT:SetupDataTables()
	self:NetworkVar("Float", 0, "ExplodeTime")
	self:NetworkVar("Bool", 0, "ExplodedInHands")
end

function ENT:Initialize()
	self:SetModel(self.Model)
	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_BBOX)
	
	if SERVER then
		self:SetExplodeTime(0)
	end
end

function ENT:Explode()
	if SERVER then
		self:Remove()
	end
end

function ENT:Think()
	local etime = self:GetExplodeTime()
	
	if etime != 0 and etime < CurTime() and !self.exploded then
		self:Explode()
		
		self.exploded = true
	end
end

function ENT:PhysicsCollide(data, obj)
	if data.Speed < 100 then return end
	
	if IsValid(data.HitEntity) and (data.HitEntity:IsPlayer() or data.HitEntity:IsNPC()) then
		self:EmitSound("player/kevlar" .. math.random(1, 5) .. ".wav")
		
		local dmg = DamageInfo()
		
		dmg:SetDamageType(DMG_CRUSH)
		dmg:SetDamage(self.HitDamage)
		dmg:SetAttacker(self.Owner)
		dmg:SetInflictor(self)
		dmg:SetDamageForce(data.OurOldVelocity)
		
		data.HitEntity:TakeDamageInfo(dmg)
		
		return
	end
	
	self:EmitSound(self.TouchNonPlayer)
end