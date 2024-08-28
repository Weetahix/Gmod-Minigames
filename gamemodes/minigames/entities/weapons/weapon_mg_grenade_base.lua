AddCSLuaFile()

SWEP.Base 							= "weapon_mgbase"
SWEP.EntName						= ""
SWEP.HoldReady						= "grenade"
SWEP.HoldNormal						= "slam"
SWEP.DetonateTime					= 3
SWEP.Magnitude						= 1
SWEP.Radius							= 1

SWEP.Secondary.MaxDistance			= 1

SWEP.Primary.ClipSize				= -1
SWEP.Primary.DefaultClip			= -1
SWEP.Primary.Automatic				= false
SWEP.Primary.Ammo					= "none"
SWEP.Primary.Delay					= 1
SWEP.Primary.MaxDistance			= 1

SWEP.Secondary.ClipSize				= -1
SWEP.Secondary.DefaultClip			= -1
SWEP.Secondary.Automatic			= false
SWEP.Secondary.Ammo					= "none"
SWEP.Secondary.Delay				= 1
SWEP.Secondary.MaxDistance			= 1

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Pin")
	self:NetworkVar("Int", 0, "ThrowTime")
	self:NetworkVar("Int", 1, "DetonateTime")
	self:NetworkVar("Int", 2, "Distance")
end

function SWEP:CanPrimaryAttack() return true end
function SWEP:CanSecondaryAttack() return true end

function SWEP:PrimaryAttack()
	if !self:CanPrimaryAttack() then return end
	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
	
	self:SetDistance(self.Primary.Distance)
	
	self:PullPin()
end

function SWEP:SecondaryAttack()
	if !self:CanSecondaryAttack() then return end
	
	self:SetNextPrimaryFire(CurTime() + self.Secondary.Delay)
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	
	self:SetDistance(self.Secondary.Distance)
	
	self:PullPin()
end

function SWEP:PullPin()
	if self:GetPin() then return end
	
	self:SendWeaponAnim(ACT_VM_PULLPIN)
	
	if self.SetHoldType then
		self:SetHoldType(self.HoldReady)
	end
	
	self:SetPin(true)
	
	self:SetDetonateTime(CurTime() + self.DetonateTime)
end

function SWEP:OnExplodeInHands() end

function SWEP:Think()
	if !IsValid(self.Owner) then return end
	
	if self:GetPin() then
		if !self.Owner:KeyDown(IN_ATTACK) and !self.Owner:KeyDown(IN_ATTACK2) then
			self:StartThrow()
			
			self:SetPin(false)
			self:SendWeaponAnim(ACT_VM_THROW)
			
			self.Owner:SetAnimation(PLAYER_ATTACK1)
		else
			if self:GetDetonateTime() + 999999 < CurTime() then
				if SERVER then
					local gren = ents.Create(self.EntName)
					
					if !IsValid(gren) then return end
					
					gren:SetPos(self.Owner:GetPos())
					gren:SetOwner(self.Owner)
					
					gren:Spawn()
					gren:SetNoDraw(true)
					
					gren:SetExplodeTime(CurTime())
					gren:SetExplodedInHands(true)
					
					self:Remove()
				end
				
				if !self.exploded then
					self.OnExplodeInHands(self)
				end
				
				self.exploded = true
			end
		end
	elseif self:GetThrowTime() > 0 and self:GetThrowTime() < CurTime() then
		self:Throw()
	end
end

function SWEP:StartThrow()
	self:SetThrowTime(CurTime() + 0.1)
end

function SWEP:Throw()
	self:SetThrowTime(0)
	
	if SERVER then
		local ply = self.Owner
		if !IsValid(ply) then return end
		
		local ang = ply:EyeAngles()
		local src = ply:GetPos() + (ply:Crouching() and ply:GetViewOffsetDucked() or ply:GetViewOffset()) + ang:Forward() * 8 + ang:Right() * 10
		local target = ply:GetEyeTraceNoCursor().HitPos
		local tang = (target - src):Angle()
		
		tang.p = tang.p - 0.1
		
		local vel = self:GetDistance()
		local thr = tang:Forward() * vel + ply:GetVelocity()
		
		self:CreateGrenade(src, thr, Vector(600, math.random(-1200, 1200), 0), ply)
		
		self:Remove()
	end
end

function SWEP:CreateGrenade(src, vel, angimp, ply)
	local gren = ents.Create(self.EntName)
	if !IsValid(gren) then return end
	
	gren:SetPos(src)
	gren:SetOwner(ply)
	
	gren:SetGravity(0)
	
	gren:Spawn()
	
	gren:PhysWake()
	
	local phys = gren:GetPhysicsObject()
	
	if IsValid(phys) then
		phys:SetVelocity(vel)
		phys:AddAngleVelocity(angimp)
	end
	
	gren:SetExplodeTime(CurTime() + 2)
	
	return gren
end

function SWEP:PreDrop()
	if self:GetPin() then
		self:SetDistance(120)
		self:Throw()
		
		return false
	end
end

function SWEP:Deploy()
	if self.SetHoldType then
		self:SetHoldType(self.HoldNormal)
	end
	
	self:SetThrowTime(0)
	self:SetPin(false)
	
	local vm = self.Owner:GetViewModel()
	
	if IsValid(vm) then
		vm:SetModel(self.ViewModel)
	end
	
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:Holster()
	if self:GetPin() then
		return false
	end
	
	self:SetThrowTime(0)
	self:SetPin(false)
	
	return true
end

function SWEP:Initialize()
	if self.SetHoldType then
		self:SetHoldType(self.HoldNormal)
	end
	
	self:SetDeploySpeed(self.DeploySpeed)
	
	self:SetDetonateTime(3)
	self:SetThrowTime(0)
	self:SetPin(false)
end

function SWEP:Reload() end

function SWEP:Equip() end