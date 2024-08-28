AddCSLuaFile()

SWEP.HoldType 						= "shotgun"

if CLIENT then
	SWEP.PrintName 					= "M3"
	
	SWEP.Icon 						= "k"
	
	killicon.AddFont("weapon_m3", "KillIcons", SWEP.Icon, Color(255, 80, 0))
end

SWEP.Base 							= "weapon_mgbase"
SWEP.Weight							= 7
SWEP.Primary.Recoil					= 1
SWEP.Primary.Damage 				= 15
SWEP.Primary.Delay 					= 1
SWEP.Primary.Cone 					= 0.10
SWEP.Primary.ClipSize 				= 8
SWEP.Primary.Automatic 				= false
SWEP.Primary.DefaultClip 			= 8
SWEP.Primary.Ammo 					= "buckshot"
SWEP.Primary.NumShots				= 9

SWEP.DamageScale 					= {}
SWEP.DamageScale[HITGROUP_HEAD]		= 11
SWEP.DamageScale[HITGROUP_CHEST] 	= 7
SWEP.DamageScale[HITGROUP_STOMACH] 	= 7
SWEP.DamageScale[HITGROUP_LEFTARM] 	= 4
SWEP.DamageScale[HITGROUP_RIGHTARM] = 4
SWEP.DamageScale[HITGROUP_LEFTLEG] 	= 4
SWEP.DamageScale[HITGROUP_RIGHTLEG] = 4

SWEP.Slot 							= 0
SWEP.UseHands						= true
SWEP.ViewModel  					= "models/weapons/cstrike/c_shot_m3super90.mdl"
SWEP.WorldModel 					= "models/weapons/w_shot_m3super90.mdl"

SWEP.Primary.Sound 					= Sound("Weapon_M3.Single")
SWEP.IronSightsPos 					= Vector(-5, -10, 2.7)
SWEP.IronSightsAng 					= Vector(0.7, 0.5, -6)

function SWEP:Reload()
	self:SetIronsights(false)
	
	if self.Weapon:GetNetworkedBool("reloading", false) then return end
	if self.Weapon:GetVar("reloadtimer", 0) > CurTime() then return end
	
	if self.Weapon:Clip1() < self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
		self.Weapon:SetNetworkedBool("reloading", true)
		self.Weapon:SetVar("reloadtimer", CurTime() + 0.5)
		self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_START)
	end
end

function SWEP:Think()
	if self.Weapon:GetNetworkedBool("reloading", false) then		
		if self.Weapon:GetVar("reloadtimer", 0) < CurTime() then
			if self.Weapon:Clip1() >= self.Primary.ClipSize or self.Owner:GetAmmoCount(self.Primary.Ammo) <= 0 then
				self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
				self.Weapon:SetNetworkedBool("reloading", false)
				
				return
			end

			self.Weapon:SetVar("reloadtimer", CurTime() + 0.5)
			
			//I made it for fix bug with animation ACT_VM_RELOAD that does not start
			
			local vm = self.Owner:GetViewModel()
			local seq = vm:SelectWeightedSequence(ACT_SHOTGUN_RELOAD_FINISH)
			vm:SendViewModelMatchingSequence(seq)
			vm:SetPlaybackRate(0)
			
			timer.Simple(0, function()
				if IsValid(self) then
					self.Weapon:SendWeaponAnim(ACT_VM_RELOAD)
					self.Owner:DoReloadEvent()
				end
			end)

			self.Owner:RemoveAmmo(1, self.Primary.Ammo)
			self.Weapon:SetClip1(self.Weapon:Clip1() + 1)
		end
	end
end

function SWEP:PrimaryAttack()
	if self.Weapon:GetNetworkedBool("reloading", false) then
		self.Weapon:SendWeaponAnim(ACT_SHOTGUN_RELOAD_FINISH)
		self.Weapon:SetNetworkedBool("reloading", false)
		self.Weapon:SetVar("reloadtimer", CurTime() + 1.5)
	end
	
	self.BaseClass.PrimaryAttack(self)
end

function SWEP:CanSecondaryAttack()
	if self.Weapon:GetNetworkedBool("reloading", false) then return false end
	
	return true
end

function SWEP:ShootBullet(dmg, recoil, numbul, cone)
	self:SendWeaponAnim(self:GetSilencer() and self.Primary.SilencedAnim or self.Primary.Anim)
	
	self.Owner:SetAnimation(PLAYER_ATTACK1)
   
	if !IsFirstTimePredicted() then return end
	
	local sights = self:GetIronsights()

	local bullet = {}
	bullet.Num    	= numbul
	bullet.Src    	= self.Owner:GetShootPos()
	bullet.Dir    	= self.Owner:GetAimVector()
	bullet.Spread 	= Vector(cone, cone, 0)
	bullet.Damage 	= math.random(dmg * 0.8, dmg * 1.2)
	bullet.Callback = function(att, tr, dmg)
		local dist = math.Round(tr.StartPos:Distance(tr.HitPos) / 500)
		local DmgCount = dmg:GetDamage()
		
		DmgCount = math.max(5, DmgCount - dist)
		
		dmg:SetDamage(DmgCount)
		
		self:PenetrateCallback(att, tr, dmg, 1, {
			MAT_ALIENFLESH,
			MAT_BLOODYFLESH,
			MAT_FLESH,
			MAT_GLASS,
			MAT_SNOW,
			MAT_PLASTIC,
			MAT_SLOSH,
			MAT_WOOD
		})
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