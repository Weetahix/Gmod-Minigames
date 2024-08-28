SWEP.Base						= "weapon_mgbase"
SWEP.Secondary.Sound			= Sound("Default.Zoom")
SWEP.Primary.CrosshairCone		= 1
SWEP.Primary.CrosshairRecoil	= 1
SWEP.Primary.MouseSensitivity	= {}

if CLIENT then
	SWEP.Secondary.Scope		= surface.GetTextureID("sprites/scope")
end

SWEP.ZoomLevels					= {}

function SWEP:DoDrawCrosshair()
	if self:GetCrosshair() then return true end
	
	return !self.DrawCrosshair
end

function SWEP:SetupDataTables()
	self:NetworkVar("Bool", 3, "Ironsights")
	self:NetworkVar("Bool", 4, "Silencer")
	self:NetworkVar("Bool", 5, "Crosshair")
	self:NetworkVar("Int", 6, "ZoomLvl")
end

function SWEP:SetZoom(zoom)
	if SERVER then
		self.Owner:SetFOV(zoom, 0.3)
	end
end

function SWEP:GetPrimaryCone()
	if self:GetCrosshair() then
		return self.Primary.CrosshairCone
	else
		return self.Primary.Cone
	end
end

function SWEP:PrimaryAttack()
   self:SetNextSecondaryFire(CurTime() + 0.1)
   
   if self.UseSilencer and self.Owner:KeyDown(IN_USE) then
		self:ToggleSilencer()
	else
		self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
		
		if !self:CanPrimaryAttack() then return end
		
		self:EmitSound(self:GetSilencer() and self.Primary.SilencerSound or self.Primary.Sound)
		
		self:ShootBullet(self.Primary.Damage, self:GetCrosshair() and self.Primary.CrosshairRecoil or self.Primary.Recoil, self.Primary.NumShots, self:GetPrimaryCone())
		
		self:TakePrimaryAmmo(1)
		
		if IsValid(self.Owner) and !self.Owner:IsNPC() then
			self.Owner:ViewPunch(Angle(math.Rand(-0.2, -0.1) * self.Primary.Recoil, math.Rand(-0.1, 0.1) * self.Primary.Recoil, 0))
		end
	end
end

function SWEP:CanSecondaryAttack()
	return self:GetNextSecondaryFire() > CurTime()
end

function SWEP:SecondaryAttack()
	local lvl = self:GetZoomLvl() + 1
	local ShouldHide = lvl > #self.ZoomLevels
	
	if ShouldHide then
		self:SetZoomLvl(0)
	end
	
	self:SetIronsights(!ShouldHide)
	
	timer.Simple(0.05, function()
		if IsValid(self) then			
			if SERVER then
				self:SetCrosshair(!ShouldHide)
				self.Owner:DrawViewModel(ShouldHide)
				
				if ShouldHide then
					self:SetZoom(0)
					return
				end
				
				if !self.ZoomLevels[lvl] then
					self:SetZoomLvl(0)
					lvl = 1
				end
				
				local zoom
				
				zoom = self.ZoomLevels[lvl] or 20
				self:SetZoomLvl(lvl)
				
				self:SetZoom(zoom)
			else				
				self:EmitSound(self.Secondary.Sound)
			end
		end
	end)
	
	self:SetNextSecondaryFire(CurTime())
end

function SWEP:Deploy()
	self:SetIronsights(false)
	self:SetZoom(0)
	self:SetCrosshair(false)
	self:SetZoomLvl(0)
	self.Owner:DrawViewModel(true)
	
	self:SetNextPrimaryFire(CurTime() + 1)
	self:SetNextSecondaryFire(CurTime() + 1)
	
	local vm = self.Owner:GetViewModel()
	
	if IsValid(vm) then
		vm:SetModel(self.ViewModel)
	end
	
	self.Weapon:SendWeaponAnim(self:GetSilencer() and self.SilencerDeployAnim or self.DeployAnim)
end

function SWEP:OnRemove()
	if IsValid(self.Owner) then
		self.Owner:DrawViewModel(true)
		self.Owner:SetFOV(0, 0.3)
	end
end

function SWEP:PreDrop()
	self:SetZoom(0)
	self:SetCrosshair(false)
	self.Owner:DrawViewModel(true)
	
	if IsValid(self.Owner) then
		self.Owner:SetFOV(0, 0.25)
	end
end

function SWEP:Reload()
	self:SetZoom(0)
	self:SetCrosshair(false)
	self.Owner:DrawViewModel(true)
	self:SetZoomLvl(0)
	
	if self:Clip1() != self.Primary.ClipSize and self.Owner:GetAmmoCount(self.Primary.Ammo) > 0 then
		self:DefaultReload(self:GetSilencer() and self.SilencerReloadAnim or self.ReloadAnim)
		self:SetIronsights(false)
		
		if SERVER then
			self.Owner:SetFOV(0, 0.25)
		end
	end
end

function SWEP:Holster()
	if !IsValid(self.Owner) then return end
	
	self:SetZoom(0)
	self:SetCrosshair(false)
	self.Owner:DrawViewModel(true)
	self:SetZoomLvl(0)
	
	if SERVER then
		self.Owner:SetFOV(0, 0.25)
	end
	
	if timer.Exists("SilencerEquip") then
		timer.Remove("SilencerEquip")
		self.SilencerDelay = false
	end
	
	return true
end

function SWEP:Equip(new)
	self:SetIronsights(false)
	self:SetZoomLvl(0)
	self:SetZoom(0)
	self:SetCrosshair(false)
	self.Owner:DrawViewModel(true)
	self.Owner:SetFOV(0, 0.25)
	
	if self.ammo then
		new:SetAmmo(self.ammo, self.Primary.Ammo)
	end
end

if CLIENT then
	function draw.Circle( x, y, radius, seg )
		local cir = {}

		table.insert( cir, { x = x, y = y, u = 0.5, v = 0.5 } )
		for i = 0, seg do
			local a = math.rad( ( i / seg ) * -360 )
			table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )
		end

		local a = math.rad( 0 )
		table.insert( cir, { x = x + math.sin( a ) * radius, y = y + math.cos( a ) * radius, u = math.sin( a ) / 2 + 0.5, v = math.cos( a ) / 2 + 0.5 } )

		surface.DrawPoly( cir )
	end
	
	function SWEP:DrawHUD()
		if self:GetCrosshair() then			
			local w = ScrW()
			local h = ScrH()
			
			local x = w / 2
			local y = h / 2
			
			surface.SetDrawColor(0, 0, 0)
			
			local ls = x - y + 2
			
			surface.DrawRect(0, 0, ls, h)
			surface.DrawRect(x + y - 2, 0, ls, h)
			
			surface.DrawLine(0, 0, w, 0)
			surface.DrawLine(0, h - 1, w, h - 1)
			
			local weight = 5
			local gap = 80
			
			surface.DrawRect(ls, y - weight / 2, y - gap, weight)
			surface.DrawRect(x - weight / 2, y + gap, weight, y - gap)
			surface.DrawRect(x + gap, y - weight / 2, y - gap, weight)
			
			surface.DrawLine(x - gap, y - 1, x + gap, y - 1)
			surface.DrawLine(x - 1, 0, x - 1, y + gap)
			
			surface.SetDrawColor(255, 0, 0)
			draw.Circle(x, y - 1, 2, 48)
			
			surface.SetTexture(self.Secondary.Scope)
			surface.SetDrawColor(255, 255, 255)
			
			surface.DrawTexturedRectRotated(x, y, h, h, 0)
			
			
			end
	end
	
	function SWEP:AdjustMouseSensitivity()
		return self.Primary.MouseSensitivity[self:GetZoomLvl()]
	end
end