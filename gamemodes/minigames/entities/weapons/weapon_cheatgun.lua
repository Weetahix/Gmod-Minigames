AddCSLuaFile()

SWEP.HoldType 						= "pistol"

if CLIENT then
	SWEP.PrintName 					= "Cheatgun"
	
	SWEP.Icon 						= "C"
	
	killicon.AddFont("weapon_cheatgun", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mgbase"
SWEP.Weight							= 6
SWEP.Primary.ClipSize 				= 1
SWEP.Primary.Automatic 				= true
SWEP.Primary.DefaultClip 			= 1
SWEP.Primary.Damage					= 1000
SWEP.Primary.Sound 					= Sound("Weapon_USP.SilencedShot")

SWEP.Slot 							= 1
SWEP.UseHands						= false
SWEP.ViewModel  					= "models/weapons/v_Pistol.mdl"
SWEP.WorldModel 					= "models/weapons/w_Pistol.mdl"

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 0, "Invisible")
end

function SWEP:PrimaryAttack()
	self:EmitSound(self.Primary.Sound)
	self:SendWeaponAnim(ACT_VM_PRIMARYATTACK)
	self.Owner:SetAnimation(PLAYER_ATTACK1)	
	
	local bullet = {}
	bullet.Src		= self.Owner:GetShootPos()
	bullet.Dir		= self.Owner:GetAimVector()
	bullet.Force	= 10
	bullet.Damage	= self.Primary.Damage
	bullet.Callback = function(att, tr, dmg)
		if IsValid(tr.Entity) and tr.Entity.Health then
			dmg:SetDamage(tr.Entity:Health())
		end
	end
	
	self.Owner:FireBullets(bullet)
end

function SWEP:SecondaryAttack()
	self:SetNextSecondaryFire(CurTime() + 0.3)
	
	local IsInvisible = self:GetInvisible()
	
	self.Owner:SetNoDraw(!IsInvisible)
	self:SetNoDraw(!IsInvisible)
	self:SetInvisible(!IsInvisible)
	
	if self.NextMessage and self.NextMessage < CurTime() or !self.NextMessage then
		if CLIENT and GetText then
			self.NextMessage = CurTime() + 0.1
			chat.AddText(Color(255, 255, 255), GetText(IsInvisible and "InvisibleOff" or "InvisibleOn"))
		end
	end
end

function SWEP:Deploy()
	local vm = self.Owner:GetViewModel()
	
	if IsValid(vm) then
		vm:SetModel(self.ViewModel)
	end
	
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
end

function SWEP:Holster()
	self.Owner:SetNoDraw(false)
	self:SetNoDraw(false)
end

function SWEP:Reload() end