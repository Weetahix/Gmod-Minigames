AddCSLuaFile()

SWEP.HoldType 						= "knife"

if CLIENT then
	SWEP.PrintName 					= "Knife"
	
	SWEP.Icon 						= "j"
	
	killicon.AddFont("weapon_knife", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mgbase"

SWEP.Slot 							= 2
SWEP.UseHands						= true
SWEP.ViewModel  					= "models/weapons/cstrike/c_knife_t.mdl"
SWEP.WorldModel 					= "models/weapons/w_knife_t.mdl"

SWEP.Primary.Automatic				= true
SWEP.Primary.ClipSize				= -1
SWEP.Primary.DefaultClip			= -1
SWEP.Primary.Ammo					= "none"
SWEP.Primary.Delay					= 0.5
SWEP.Primary.MaxDistance			= 100
SWEP.Primary.Miss					= ACT_VM_MISSCENTER
SWEP.Primary.Hit					= ACT_VM_PRIMARYATTACK
SWEP.Primary.Damage					= 15
SWEP.Primary.SlashSound				= Sound("Weapon_Knife.Hit")
SWEP.Primary.MissSound				= Sound("Weapon_Knife.Slash")
SWEP.Primary.HitWallSound			= Sound("Weapon_Knife.HitWall")

SWEP.Secondary.Automatic			= true
SWEP.Secondary.Delay				= 0.8
SWEP.Secondary.MaxDistance			= 80
SWEP.Secondary.Miss					= ACT_VM_MISSCENTER
SWEP.Secondary.Hit					= ACT_VM_SECONDARYATTACK
SWEP.Secondary.Damage				= 65
SWEP.Secondary.BackDamage			= 150
SWEP.Secondary.BackSound			= Sound("Weapon_Knife.Stab")
SWEP.Secondary.SlashSound			= Sound("Weapon_Knife.Hit")
SWEP.Secondary.MissSound			= Sound("Weapon_Knife.Slash")
SWEP.Secondary.HitWallSound			= Sound("Weapon_Knife.HitWall")

function SWEP:Slash(tbl)	
	self.Weapon:SetNextPrimaryFire(CurTime() + tbl.Delay)
	self.Weapon:SetNextSecondaryFire(CurTime() + tbl.Delay)
	
	self.Owner:LagCompensation(true)
	
	local spos = self.Owner:GetShootPos()
	local sdest = spos + self.Owner:GetAimVector() * tbl.MaxDistance
	
	local tr = util.TraceLine({
		start = spos,
		endpos = sdest,
		filter = self.Owner,
		mask = MASK_SHOT_HULL
	})
	
	if tr.Fraction == 1 then
		tr = util.TraceHull{
			start = spos,
			endpos = sdest,
			mins = Vector(-10, -10, -10),
			maxs = Vector(10, 10, 10),
			mask = MASK_SHOT_HULL,
			filter = self.Owner
		}
	end
	
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	local ent = tr.Entity
	
	if !IsValid(ent) and !ent:IsWorld() then
		self.Weapon:SendWeaponAnim(tbl.Miss)
		
		if CLIENT then
			self:EmitSound(tbl.MissSound)
		end
		
		self.Owner:LagCompensation(false)
		
		return
	end
	
	local dif = math.AngleDifference(self.Owner:GetAngles().y, ent:GetAngles().y)
	local IsBack = (ent:IsPlayer() or ent:IsNPC()) and dif >= -45 and dif <= 45
	
	if IsValid(ent) and (ent:IsPlayer() or ent:IsNPC() or ent:GetClass() == "prop_ragdoll") then		
		self.Weapon:SendWeaponAnim(tbl.Hit)
		
		local edata = EffectData()
		
		edata:SetStart(spos)
		edata:SetOrigin(tr.HitPos)
		edata:SetNormal(tr.Normal)
		edata:SetEntity(ent)
		
		if SERVER then
			util.Effect("BloodImpact", edata)
			
			self.Owner:EmitSound(IsBack and tbl.BackSound or tbl.SlashSound)
		end
	else
		self.Weapon:SendWeaponAnim(tbl.Hit)
		
		if CLIENT then
			util.Decal("ManhackCut", tr.HitPos + tr.HitNormal, tr.HitPos - tr.HitNormal)
			
			self:EmitSound(tbl.HitWallSound)
		end
		
		if SERVER and IsValid(ent) then
			local phys = ent:GetPhysicsObject()
			
			if IsValid(phys) then
				local vel = self.Owner:GetAimVector()
				local ang = self.Owner:GetAngles()
				
				phys:SetVelocity((vel + ang:Up() * 0.2) * GetConVar("phys_pushscale"):GetInt() * 150 / phys:GetMass())
			end
		end
	end
	
	if SERVER and tr.Hit and tr.HitNonWorld then
		local dmg = DamageInfo()
		
		dmg:SetDamage(IsBack and tbl.BackDamage or tbl.Damage)
		dmg:SetAttacker(self.Owner)
		dmg:SetInflictor(self.Weapon or self)
		dmg:SetDamageForce(self.Owner:GetAimVector() * 5)
		dmg:SetDamagePosition(self.Owner:GetPos())
		dmg:SetDamageType(DMG_SLASH)
		
		ent:DispatchTraceAttack(dmg, spos + self.Owner:GetAimVector() * 3, sdest)
	end

   self.Owner:LagCompensation(false)
end

function SWEP:PrimaryAttack()
	self:Slash(self.Primary)
end

function SWEP:SecondaryAttack()
	self:Slash(self.Secondary)
end

function SWEP:Deploy()
	self:EmitSound("Weapon_Knife.Deploy")
	
	self.BaseClass.Deploy(self)
end

function SWEP:Equip() end

function SWEP:Reload() end