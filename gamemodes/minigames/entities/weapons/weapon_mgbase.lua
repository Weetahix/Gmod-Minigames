AddCSLuaFile()

if CLIENT then	
	surface.CreateFont("KillIcons", {
		font = "csd", 
		size = ScreenScale(30), 
		additive = true
	})
	
	surface.CreateFont("SelectIcons", {
		font = "csd", 
		size = ScreenScale(60), 
		additive = true
	})
	
	killicon.AddFont("headshot", "KillIcons", "D", Color(255, 80, 0))
	
	SWEP.CSMuzzleFlashes 			= true
	SWEP.Icon 						= ""
end

SWEP.Base 							= "weapon_base"

SWEP.Category           			= "Minigames"
SWEP.Spawnable          			= false
SWEP.Author 						= "СПУДИ МУН"
SWEP.HoldType 						= "pistol"

SWEP.UseSilencer					= false
SWEP.ReloadAnim 					= ACT_VM_RELOAD
SWEP.SilencerReloadAnim				= ACT_VM_RELOAD_SILENCED
SWEP.DeploySpeed 					= 1.4
SWEP.DeployAnim						= ACT_VM_DRAW
SWEP.SilencerDeployAnim				= ACT_VM_DRAW_SILENCED

SWEP.DamageScale 					= {}
SWEP.DamageScale[HITGROUP_HEAD]		= 1
SWEP.DamageScale[HITGROUP_CHEST] 	= 1
SWEP.DamageScale[HITGROUP_STOMACH] 	= 1
SWEP.DamageScale[HITGROUP_LEFTARM] 	= 1
SWEP.DamageScale[HITGROUP_RIGHTARM] = 1
SWEP.DamageScale[HITGROUP_LEFTLEG] 	= 1
SWEP.DamageScale[HITGROUP_RIGHTLEG] = 1

SWEP.Primary.ClipSize       		= 1
SWEP.Primary.DefaultClip    		= 1
SWEP.Primary.Automatic      		= false
SWEP.Primary.Ammo           		= "none"

SWEP.Primary.Anim 					= ACT_VM_PRIMARYATTACK
SWEP.Primary.SilencedAnim			= ACT_VM_PRIMARYATTACK_SILENCED
SWEP.Primary.Sound 					= Sound("Weapon_Pistol.Empty")
SWEP.Primary.SilencerSound			= Sound("Weapon_Pistol.Empty")
SWEP.Primary.Damage					= 1
SWEP.Primary.Recoil					= 1
SWEP.Primary.Cone					= 1
SWEP.Primary.Delay					= 1
SWEP.Primary.NumShots				= 1
SWEP.Primary.Force					= 100

SWEP.Secondary.ClipSize				= -1
SWEP.Secondary.DefaultClip			= -1
SWEP.Secondary.Ammo					= "none"

function SWEP:CanPrimaryAttack()
	if !IsValid(self.Owner) then return false end
	
	if self.Owner:WaterLevel() >= 3 then
		self:EmitSound("Weapon_Pistol.Empty")
		return false
	end

	if self:Clip1() <= 0 then
		self:EmitSound("Weapon_Pistol.Empty")
		
		self:Reload()
		
		return false
	end
	
	return true
end

function SWEP:GetPrimaryCone()
	local cone = self.Primary.Cone
	
	return self:GetIronsights() and (cone * 0.8) or cone
end

local DoublePentrate = {
	MAT_GLASS,
	MAT_PLASTIC,
	MAT_WOOD,
	MAT_FLESH,
	MAT_ALIENFLESH
}

local MapsDontPenetrate = {}

function SWEP:PenetrateCallback(att, tr, dmg, frac, CanPenetrate)
	if table.HasValue(MapsDontPenetrate, game.GetMap()) then return end
	
	frac = frac or 0
	if frac > 1 then return end
	
	local MaxPenetration = 20
	
	if CanPenetrate then
		local IsHas = false
		
		for _, v in pairs(CanPenetrate) do
			if tr.MatType == v then
				IsHas = true
			end
		end
		
		if !IsHas then return end
	elseif tr.MatType == MAT_SAND or tr.MatType == MAT_METAL then return end
	
	if table.HasValue(DoublePentrate, tr.MatType) then
		MaxPenetration = MaxPenetration * 2
	end
	
	local trace = util.TraceLine({
		start	= tr.HitPos + tr.Normal * MaxPenetration,
		endpos	= tr.HitPos,
		mask	= MASK_SHOT,
		filter	= self.Owner
	})
	
	if trace.Fraction >= 1 or trace.Fraction <= 0 then return end
	
	frac = frac - trace.Fraction + 1
	
	local multipier
	
	if tr.MatType == MAT_FLESH or tr.MatType == MAT_ALIENFLESH then
		multipier = 0.7
	else
		multipier = 0.5
	end
	
	local bullet = {
		Num 		= 1,
		Src 		= trace.HitPos,
		Dir 		= tr.Normal,	
		Spread 		= Vector(0.01, 0.01, 0.01),
		TracerName 	= "effect_penetration_trace",
		Force		= 10,
		Damage		= dmg:GetDamage() * multipier,
		Callback	= function(att, trace, dmg)
			if IsValid(self) and self.PenetrateCallback then
				if trace.Entity == tr.Entity then
					dmg:SetDamage(0)
				end
				
				self:PenetrateCallback(att, trace, dmg, frac, CanPenetrate)
			end
		end
	}
	
	timer.Simple(0.05, function()
		att:FireBullets(bullet, true)
	end)
end

function SWEP:ShootBullet(dmg, recoil, numbul, cone)
	if !IsFirstTimePredicted() then return end
	
	self:SendWeaponAnim(self:GetSilencer() and self.Primary.SilencedAnim or self.Primary.Anim)
	
	self.Owner:SetAnimation(PLAYER_ATTACK1)
	
	local sights = self:GetIronsights()

	local bullet = {}
	bullet.Num    = numbul
	bullet.Src    = self.Owner:GetShootPos()
	bullet.Dir    = self.Owner:GetAimVector()
	bullet.Spread = Vector(cone, cone, 0)
	bullet.Damage = math.random(dmg * 0.8, dmg * 1.2)
	bullet.Force  = 10
	bullet.Callback = function(att, tr, dmg)
		self:PenetrateCallback(att, tr, dmg)
	end

	self.Owner:FireBullets(bullet)
	
	if !IsValid(self.Owner) or !self.Owner:Alive() or self.Owner:IsNPC() then return end
	
	if CLIENT and IsFirstTimePredicted() then
		recoil = sights and (recoil * 0.6) or recoil
		
		local eyeang = self.Owner:EyeAngles()
		eyeang.pitch = eyeang.pitch - recoil
		self.Owner:SetEyeAngles(eyeang)
	end
end

function SWEP:ToggleSilencer()
	if self.SilencerDelay then return end
	
	self.SilencerDelay = true
	
	if self:GetSilencer() then
		self.Weapon:SendWeaponAnim(ACT_VM_DETACH_SILENCER)
	else
		self.Weapon:SendWeaponAnim(ACT_VM_ATTACH_SILENCER)
	end
	
	local dur = self.Weapon:SequenceDuration()
	
	self:SetNextPrimaryFire(CurTime() + dur + 0.2)
	
	timer.Create("SilencerEquip", math.max(0, dur - 0.1), 1, function()
		if IsValid(self) then
			self.SilencerDelay = false
			self:SetSilencer(!self:GetSilencer())
		end
	end)
end

function SWEP:PrimaryAttack()
	if self.UseSilencer and self.Owner:KeyDown(IN_USE) then
	
	else
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		
		if !self:CanPrimaryAttack() then return end
		
		self:EmitSound(self:GetSilencer() and self.Primary.SilencerSound or self.Primary.Sound)
		
		self:ShootBullet(self.Primary.Damage, self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone())
		
		self:TakePrimaryAmmo(1)
		
		if IsValid(self.Owner) and !self.Owner:IsNPC() then
			self.Owner:ViewPunch(Angle(math.Rand(-0.2, -0.1) * self.Primary.Recoil, math.Rand(-0.1, 0.1) * self.Primary.Recoil, 0))
		end
	end
end

function SWEP:Deploy()
	self:SetIronsights(false)
	self.SilencerDelay = false
	
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)
	
	local vm = self.Owner:GetViewModel()
	
	if IsValid(vm) then
		vm:SetModel(self.ViewModel)
	end
	
	self.Weapon:SendWeaponAnim(self:GetSilencer() and self.SilencerDeployAnim or self.DeployAnim)
	
	return true
end

function SWEP:Holster()
	if !IsValid(self.Owner) then return end

	if SERVER then
		self.Owner:SetFOV(0, 0.25)
	end
	
	if timer.Exists("SilencerEquip") then
		timer.Remove("SilencerEquip")
		self.SilencerDelay = false
	end
	
	return true
end

function SWEP:Reload()
	if self:Clip1() != self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
		self:DefaultReload(self:GetSilencer() and self.SilencerReloadAnim or self.ReloadAnim)
		self:SetIronsights(false)
		
		if SERVER then
			self.Owner:SetFOV(0, 0.25)
		end
	end
end

function SWEP:PreDrop()
	if IsValid(self.Owner) then
		self.Owner:SetFOV(0, 0.25)
	end
end

function SWEP:GetIronsights() return false end
function SWEP:SetIronsights() end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 3, "Ironsights")
	self:NetworkVar("Bool", 4, "Silencer")
end

function SWEP:Initialize()
	if !self.ammo then
		self.ammo = self.Primary.ClipSize * 5
	end
	
	if SERVER then
		self:SetIronsights(false)
	end

	self:SetDeploySpeed(self.DeploySpeed)
	
	self:SetHoldType(self.HoldType)
end

function SWEP:CanSecondaryAttack() return true end

function SWEP:SecondaryAttack()
	if !self:CanSecondaryAttack() then return end
	
	local ironsights = self:GetIronsights()
	
	self:SetIronsights(!ironsights)
	
	if SERVER then
		if ironsights then
			self.Owner:SetFOV(0, 0.25)
		else
			self.Owner:SetFOV(65, 0.25)
		end
	end
	
	self:SetNextSecondaryFire(CurTime() + 0.5)
end

function SWEP:DrawWeaponSelection(x, y, wide, tall, alpha)
	draw.SimpleText(self.Icon, "SelectIcons", x + wide / 2, y + tall * 0.2, Color(255, 210, 0, alpha), TEXT_ALIGN_CENTER)
end

local IRONSIGHT_TIME = 0.25

function SWEP:GetViewModelPosition(pos, ang)	
	if !self.IronSightsPos then return pos, ang end
	
	local bIron = self:GetIronsights()
	
	if bIron != self.bLastIron then
		self.bLastIron = bIron
		self.fIronTime = CurTime()
		
		if bIron then
			self.SwayScale = 0.3
			self.BobScale = 0.1
		else
			self.SwayScale = 1.0
			self.BobScale = 1.0
		end
	end
	
	local fIronTime = self.fIronTime or 0
	if !bIron and fIronTime < CurTime() - IRONSIGHT_TIME then
		return pos, ang
	end
	
	local mul = 1.0
	
	if fIronTime > CurTime() - IRONSIGHT_TIME then
		mul = math.Clamp((CurTime() - fIronTime) / IRONSIGHT_TIME, 0, 1)
		
		if !bIron then mul = 1 - mul end
	end
	
	local offset = self.IronSightsPos + Vector(0, 0, -2)
	
	if self.IronSightsAng then
		ang = ang * 1
		ang:RotateAroundAxis(ang:Right(),    self.IronSightsAng.x * mul)
		ang:RotateAroundAxis(ang:Up(),       self.IronSightsAng.y * mul)
		ang:RotateAroundAxis(ang:Forward(),  self.IronSightsAng.z * mul)
	end
	
	pos = pos + offset.x * ang:Right() * mul
	pos = pos + offset.y * ang:Forward() * mul
	pos = pos + offset.z * ang:Up() * mul
	
	return pos, ang
end

function SWEP:Equip(new)
	self:SetIronsights(false)
	self.Owner:SetFOV(0, 0.25)
	
	if self.ammo then
		new:SetAmmo(self.ammo, self.Primary.Ammo)
	end
end