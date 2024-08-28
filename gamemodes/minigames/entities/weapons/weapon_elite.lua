AddCSLuaFile()

SWEP.HoldType 						= "duel"

if CLIENT then
	SWEP.PrintName 					= "Dual Elites"
	
	SWEP.Icon 						= "s"
	
	killicon.AddFont("weapon_elite", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mgbase"
SWEP.Weight							= 6
SWEP.Primary.Recoil					= 0.6
SWEP.Primary.Damage 				= 35
SWEP.Primary.Delay 					= 0.1
SWEP.Primary.Cone 					= 0.03
SWEP.Primary.ClipSize 				= 30
SWEP.Primary.Automatic 				= false
SWEP.Primary.DefaultClip 			= 30
SWEP.Primary.Ammo 					= "pistol"

SWEP.DamageScale 					= {}
SWEP.DamageScale[HITGROUP_HEAD]		= 3.8
SWEP.DamageScale[HITGROUP_CHEST] 	= 1
SWEP.DamageScale[HITGROUP_STOMACH] 	= 1.2
SWEP.DamageScale[HITGROUP_LEFTARM] 	= 0.6
SWEP.DamageScale[HITGROUP_RIGHTARM] = 0.6
SWEP.DamageScale[HITGROUP_LEFTLEG] 	= 0.6
SWEP.DamageScale[HITGROUP_RIGHTLEG] = 0.6

SWEP.Slot 							= 1
SWEP.UseHands						= true
SWEP.ViewModel  					= "models/weapons/cstrike/c_pist_elite.mdl"
SWEP.WorldModel 					= "models/weapons/w_pist_elite.mdl"

SWEP.Primary.Sound 					= Sound("Weapon_Elite.Single")

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 5, "Secondary")
	
	self.BaseClass.SetupDataTables(self)
end

function SWEP:ShootBullet(dmg, recoil, numbul, cone)
	local IsSecondary = self:GetSecondary()
	
	self:SendWeaponAnim(IsSecondary and ACT_VM_SECONDARYATTACK or ACT_VM_PRIMARYATTACK)
	self:SetSecondary(!IsSecondary)
	
	self.Owner:SetAnimation(PLAYER_ATTACK1)
   
	if !IsFirstTimePredicted() then return end
	
	local sights = self:GetIronsights()

	local bullet = {}
	bullet.Num    = numbul
	bullet.Src    = self.Owner:GetShootPos()
	bullet.Dir    = self.Owner:GetAimVector()
	bullet.Spread = Vector(cone, cone, 0)
	bullet.Force  = 10
	bullet.Damage = math.random(dmg * 0.8, dmg * 1.2)
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

function SWEP:SecondaryAttack() end