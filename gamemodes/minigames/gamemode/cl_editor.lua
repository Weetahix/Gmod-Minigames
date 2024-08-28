surface.CreateFont("EditorTitle", {
	font = "Tahoma",
	size = 18,
	weight = 600
})

surface.CreateFont("SettingTitle", {
	font = "Tahoma",
	size = 13,
	weight = 550
})

surface.CreateFont("ButtonTitle", {
	font = "Tahoma",
	size = 16,
	weight = 600
})

surface.CreateFont("BottomButtons", {
	font = "Tahoma",
	size = 16,
	weight = 500
})

surface.CreateFont("InputButton", {
	font = "Tahoma",
	size = 14,
	weight = 500
})

local DefaultSettings = {
	{"God", "boolean"},
	{"TeamType", "number"},
	{"PlyInTeam", "number"},
	{"Respawn", "boolean"},
	{"DropAfterDeath", "boolean"},
	{"CantDrop", {"string"}},
	{"Time", "number"},
	{"PlayerScale", "number"},
	{"RunSpeed", "number"},
	{"WalkSpeed", "number"},
	{"JumpPower", "number"},
	{"AllowFlashlight", "boolean"},
	{"StartWeapon", "string"},
	{"InfiniteAmmo", "boolean"},
	{"PlayersNoCollide", "boolean"},
	{"AvoidPlayers", "boolean"},
	{"TeamDamage", "boolean"},
	{"PlayersDamage", "boolean"},
	{"FallDamage", "boolean"},
	{"WinPoints", "number"},
	{"DrawPoints", "number"},
	{"LossPoints", "number"},
	{"BlueSpawnPoints", "string"},
	{"RedSpawnPoints", "string"},
	{"Gravity", "number"},
	{"TempGod", "number"},
	{"NumRounds", "number"}
}

local DefaultConfig = {
	{"NumMaps", "number"},
	{"VoteTime", "number"},
	{"Percent", "number"},
	{"UsePrefixes", "boolean"},
	{"Restriction", "boolean"},
	{"MinVotes", "number"},
	{"PreparationTime", "number"},
	{"EndTime", "number"},
	{"FreezeTime", "number"},
	{"ChatCommands", {"string"}},
	{"Prefixes", {"string"}},
	{"Exception", {"string"}},
	{"SpectateGroups", {"string"}},
	{"EditAllow", {"string"}},
	{"EditorCommand", {"string"}},
	{"Groups", {"string", "number", "string", "color"}}
}

local PANEL = {}

function PANEL:Init()
	local w = 800
	local h = 600

	self:SetSize(w, h)
	self:SetPos(math.Round(ScrW() / 2 - self:GetWide() / 2) - 20, math.Round(ScrH() / 2 - self:GetTall() / 2) - 20)
	
	self:MakePopup()
	
	self.CloseButton = self:Add("DButton")
	self.CloseButton:SetFont('marlett')
	self.CloseButton:SetText('r')
	self.CloseButton.Paint = function() end
	self.CloseButton:SetColor(Color(255, 255, 255))
	self.CloseButton:SetSize(20, 20)
	self.CloseButton:SetPos(w - 25, 5)
	self.CloseButton.DoClick = function()
		if IsValid(ColorChooser) then ColorChooser:Remove() end
		
		self:Hide()
	end
	
	self.ScrollBar = self:Add("DScrollPanel")
	self.ScrollBar:SetPos(0, 95)
	self.ScrollBar:SetSize(w + 15, h - 95)
	
	self.ScrollBar.OnMouseWheeled = function(_, dlta)
		if IsValid(self.Map) and IsValid(self.Map.inp) and IsValid(self.Map.inp.Menu) then
			self.Map.inp.Menu:Remove()
		end		
		
		return self.ScrollBar.VBar:OnMouseWheeled(dlta)
	end
	
	self.ScrollBar:GetVBar().Paint = function() return true end
	self.ScrollBar:GetVBar().btnUp.Paint = function() return true end
	self.ScrollBar:GetVBar().btnDown.Paint = function() return true end
	self.ScrollBar:GetVBar().btnGrip.Paint = function() return true end

	function self.ScrollBar:OnScrollbarAppear() return true end
	
	self.Layout = self.ScrollBar:Add("DListLayout")
	self.Layout:SetPos(0, 0)
	self.Layout:SetSize(w + 15, h - 95)
	
	self.MapSetting = self:Add("DButton")
	self.MapSetting:SetPos(0, 70)
	self.MapSetting:SetSize(400, 25)
	self.MapSetting:SetText("")
	self.MapSetting.Paint = function(_, w, h)
		if self.MapSetting:IsHovered() then
			surface.SetDrawColor(200, 200, 200)
		else
			surface.SetDrawColor(220, 220, 220)
		end
		
		surface.DrawRect(0, 0, w, h)
		
		surface.SetDrawColor(200, 200, 200)
		surface.DrawRect(0, 0, w, 1)
		surface.DrawRect(w - 1, 0, 1, h)
		surface.DrawRect(0, h - 1, w, 1)
		surface.DrawRect(0, 0, 1, h)
		
		draw.SimpleText(GetText("OpenSettings"), "ButtonTitle", w / 2, h / 2, Color(100, 100, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	self.MapSetting.DoClick = function()
		self.IsMap = true
		self.IsConfig = false
		
		self:Clear()
		
		if self.Map then
			self.Map:Remove()
		end
		
		self:AddMapInput()
	end
	
	self.MapSetting:DoClick()
	
	self.Config = self:Add("DButton")
	self.Config:SetPos(400, 70)
	self.Config:SetSize(400, 25)
	self.Config:SetText("")
	self.Config.Paint = function(_, w, h)
		if self.Config:IsHovered() then
			surface.SetDrawColor(200, 200, 200)
		else
			surface.SetDrawColor(220, 220, 220)
		end
		
		surface.DrawRect(0, 0, w, h)
		
		surface.SetDrawColor(200, 200, 200)
		surface.DrawOutlinedRect(0, 0, w, h)
		
		draw.SimpleText(GetText("OpenConfig"), "ButtonTitle", w / 2, h / 2, Color(100, 100, 100), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	self.Config.DoClick = function()
		self.IsMap = false
		self.IsConfig = true
		
		self:Clear()
		
		if self.Map then
			self.Map:Remove()
		end
		
		net.Start("SendConfig")
		net.SendToServer()
	end
	
	self.Inputs = {}
end

function PANEL:Paint(w, h)
	surface.SetDrawColor(230, 230, 230)
	surface.DrawRect(0, 70, w, h - 70)

	surface.SetDrawColor(45, 60, 80)
	surface.DrawRect(0, 0, w, 70)
	
	surface.SetTextColor(230, 230, 230)
	surface.SetFont("EditorTitle")
	
	local x, y = surface.GetTextSize(GetText("Editor"))
	
	surface.SetTextPos(w / 2 - x / 2, 35 - y / 2)
	surface.DrawText(GetText("Editor"))
end

local function paint(self, w, h)
	if self:IsHovered() or self:IsChildHovered() then
		surface.SetDrawColor(200, 200, 200)
	else
		surface.SetDrawColor(230, 230, 230)
	end
	
	surface.DrawRect(0, 0, w, h)
end

function PANEL:AddMapInput()	
	self.Map = self.Layout:Add("DPanel")
	self.Map:SetPos(0, 0)
	self.Map:SetSize(self.Layout:GetWide() - 15, 40)
	
	self.Map.inp = self.Map:Add("DTextEntry")
	self.Map.inp:SetSize(150, 20)
	self.Map.inp:SetPos(10, self.Map:GetTall() / 2 - self.Map.inp:GetTall() / 2)
	self.Map.inp:SetText(game.GetMap())
	self.Map.inp.m_bLoseFocusOnClickAway = false
	
	self.Map.Paint = function(_, w, h)
		paint(self.Map, w, h)
	
		surface.SetFont("SettingTitle")
		
		local _, y = surface.GetTextSize(GetText("SelectMap"))
		
		surface.SetTextPos(170, h / 2 - y / 2)
		surface.SetTextColor(100, 100, 100)
		surface.DrawText(GetText("SelectMap"))
	end
	
	self.Map.inp.OnValueChange = function()	
		net.Start("SendSettings")
			net.WriteString(self.Map.inp:GetValue())
		net.SendToServer()
	end
	
	function self.Map.inp:OpenAutoComplete(tab)
		if !tab then return end
		if #tab == 0 then return end
		
		self.Menu = DermaMenu()
		
		for k, v in pairs(tab) do
			self.Menu:AddOption(v, function()
				self:SetText(v)
				self:SetCaretPos(v:len())
				self:RequestFocus()
				
				self:OnValueChange(self:GetValue())
			end)
		end
		
		local x, y = self:LocalToScreen(0, self:GetTall())
		self.Menu:SetMinimumWidth(self:GetWide())
		self.Menu:Open(x, y, true, self)
		self.Menu:SetPos(x, y)
		self.Menu:SetMaxHeight((ScrH() - y) - 10)
	end
	
	self.Map.inp.GetAutoComplete = function(_, val)	
		if !val or val == "" or !ServerMaps then return end
	
		local tbl = {"default"}
		
		for _, v in pairs(ServerMaps) do
			local name = string.gsub(v, ".bsp", "")
			
			if string.find(name, val) then
				table.insert(tbl, name)
			end
		end
		
		return tbl
	end
	
	net.Start("SendSettings")
		net.WriteString(game.GetMap())
	net.SendToServer()
end

local inputs = {}

local function GetType(val)
	if istable(val) then
		if val.r and val.g and val.b then
			return "color"
		else
			return "table"
		end
	end
	
	return val
end

local function CreateSetting(parent, title, def, t, IsChild)
	local func = inputs[GetType(t)]
	
	if func then
		local pnl = func(parent, title, def, t, IsChild)
		pnl.t = t
		
		return pnl
	end
end

inputs["boolean"] = function(parent, title, def, t, IsChild)
	local pnl = parent:Add("DPanel")
	pnl:SetSize(parent:GetWide(), 40)
	
	pnl.Paint = function(_, w, h)
		if !IsChild then
			paint(pnl, w, h)
		end
	end
	
	pnl.inp = pnl:Add("DCheckBox")
	pnl.inp:SetPos(10, pnl:GetTall() / 2 - pnl.inp:GetTall() / 2)
	pnl.inp:SetChecked(def)
	
	local lab = pnl:Add("DLabel")
	lab:SetFont("SettingTitle")
	lab:SetColor(Color(100, 100, 100))
	lab:SetText(title)
	lab:SizeToContents()
	lab:SetPos(pnl.inp:GetWide() + 20, pnl:GetTall() / 2 - lab:GetTall() / 2)
	
	return pnl
end

inputs["number"] = function(parent, title, def, t, IsChild)
	local pnl = parent:Add("DPanel")
	pnl:SetSize(parent:GetWide(), 40)
	
	pnl.Paint = function(_, w, h)
		if !IsChild then
			paint(pnl, w, h)
		end
	end
	
	pnl.inp = pnl:Add("DNumberWang")
	pnl.inp:SetSize(100, 20)
	pnl.inp:SetPos(10, pnl:GetTall() / 2 - pnl.inp:GetTall() / 2)
	pnl.inp.m_numMax = nil
	pnl.inp.m_numMin = nil
	pnl.inp:SetValue(def)
	
	local lab = pnl:Add("DLabel")
	lab:SetFont("SettingTitle")
	lab:SetColor(Color(100, 100, 100))
	lab:SetText(title)
	lab:SizeToContents()
	lab:SetPos(pnl.inp:GetWide() + 20, pnl:GetTall() / 2 - lab:GetTall() / 2)
	
	return pnl
end

inputs["string"] = function(parent, title, def, t, IsChild)
	local pnl = parent:Add("DPanel")
	pnl:SetSize(parent:GetWide(), 40)
	
	pnl.Paint = function(_, w, h)
		if !IsChild then
			paint(pnl, w, h)
		end
	end
	
	pnl.inp = pnl:Add("DTextEntry")
	pnl.inp:SetSize(150, 20)
	pnl.inp:SetPos(10, pnl:GetTall() / 2 - pnl.inp:GetTall() / 2)
	pnl.inp:SetText(def)
	
	local lab = pnl:Add("DLabel")
	lab:SetFont("SettingTitle")
	lab:SetColor(Color(100, 100, 100))
	lab:SetText(title)
	lab:SizeToContents()
	lab:SetPos(pnl.inp:GetWide() + 20, pnl:GetTall() / 2 - lab:GetTall() / 2)
	
	return pnl
end

inputs["color"] = function(parent, title, def, t, IsChild)
	local pnl = parent:Add("DPanel")
	pnl:SetSize(parent:GetWide(), 40)
	
	pnl.Paint = function(_, w, h)
		if !IsChild then
			paint(pnl, w, h)
		end
	end
	
	pnl.colors = {}
	
	pnl.Layout = pnl:Add("DIconLayout")
	pnl.Layout:SetSpaceX(5)
	pnl.Layout:SetWide(0)
	
	local function AddLabel(color, val)
		local sub = pnl.Layout:Add("DLabel")
		sub:SetText(color)
		sub:SetColor(Color(80, 80, 80))
		sub:SetTall(20)
		sub:SizeToContentsX()
		
		pnl.colors[color] = pnl.Layout:Add("DNumberWang")
		pnl.colors[color]:SetMinMax(0, 255)
		pnl.colors[color]:SetValue(val)
		pnl.colors[color]:SetSize(25, 20)
		pnl.colors[color]:HideWang()
		
		pnl.colors[color].OnValueChanged = function(_, val)
			if isstring(val) then val = tonumber(val) end
			
			if val < pnl.colors[color].m_numMin then
				pnl.colors[color]:SetText(pnl.colors[color].m_numMin)
			end
			
			if val > pnl.colors[color].m_numMax then
				pnl.colors[color]:SetText(pnl.colors[color].m_numMax)
			end
		end
		
		pnl.Layout:SetWide(pnl.Layout:GetWide() + sub:GetWide() + pnl.colors[color]:GetWide() + 10)
	end
	
	AddLabel("R", def.r or 0)
	AddLabel("G", def.g or 0)
	AddLabel("B", def.b or 0)
	
	local OpenColorChooser = pnl:Add("DButton")
	OpenColorChooser.Color = def
	OpenColorChooser:SetText("")
	OpenColorChooser:SetSize(32, 32)
	OpenColorChooser:SetPos(pnl.Layout:GetWide() + 20, pnl:GetTall() / 2 - OpenColorChooser:GetTall() / 2)
	OpenColorChooser.Paint = function(_, w, h)
		surface.SetDrawColor(OpenColorChooser.Color)
		surface.DrawRect(0, 0, w, h)
		
		surface.SetDrawColor(0, 0, 0)
		surface.DrawOutlinedRect(0, 0, w, h)
	end
	
	OpenColorChooser.DoClick = function()
		if IsValid(ColorChooser) then ColorChooser:Remove() end
		
		ColorChooser = vgui.Create("DPanel")
		ColorChooser:SetSize(272, 300)
		ColorChooser:SetPos(ScrW() / 2 - ColorChooser:GetWide() /  2, ScrH() / 2 - ColorChooser:GetTall() / 2)
		ColorChooser:MakePopup()
		
		local title = ColorChooser:Add("DLabel")
		title:SetPos(5, 5)
		title:SetText(GetText("SelectColor"))
		title:SizeToContents()
		
		local close = ColorChooser:Add("DButton")
		close:SetFont('marlett')
		close:SetText('r')
		close.Paint = function() end
		close:SetColor(Color(255, 255, 255))
		close:SetSize(20, 20)
		close:SetPos(ColorChooser:GetWide() - 25, 5)
		close.DoClick = function()
			ColorChooser:Remove()
		end
		
		ColorChooser.Paint = function(_, w, h)
			surface.SetDrawColor(150, 150, 150)
			surface.DrawRect(0, 0, w, h)
		end
		
		local ColorMixer = ColorChooser:Add("DColorMixer")
		ColorMixer:SetAlphaBar(false)
		ColorMixer:SetColor(def)
		ColorMixer:SetPos(8, 30)
		
		local done = ColorChooser:Add("DButton")
		done:SetPos(ColorChooser:GetWide() / 2 - done:GetWide() / 2, ColorChooser:GetTall() - done:GetTall() - 8)
		done:SetText(GetText("Done"))
		
		done.DoClick = function()
			local color = ColorMixer:GetColor()
			
			pnl.colors["R"]:SetValue(color.r)
			pnl.colors["G"]:SetValue(color.g)
			pnl.colors["B"]:SetValue(color.b)
			
			OpenColorChooser.Color = color
			
			ColorChooser:Remove()
		end
	end
	
	pnl.Layout:SetPos(10, pnl:GetTall() / 2 - 10)
	
	local lab = pnl:Add("DLabel")
	lab:SetFont("SettingTitle")
	lab:SetColor(Color(100, 100, 100))
	lab:SetText(title)
	lab:SizeToContents()
	lab:SetPos(pnl.Layout:GetWide() + OpenColorChooser:GetWide() + 30, pnl:GetTall() / 2 - lab:GetTall() / 2)
	
	return pnl
end

local function GetEmptySetting(val)
	if GetType(val) == "boolean" then
		return false
	end
	
	if GetType(val) == "number" then
		return 0
	end
	
	if GetType(val) == "string" then
		return ""
	end
	
	if GetType(val) == "color" then
		return Color(255, 255, 255)
	end
end

inputs["table"] = function(parent, title, def, t, IsChild)
	local pnl = parent:Add("DPanel")
	
	pnl.Paint = function(_, w, h)
		if IsChild then
			paint(pnl, w, h)
		end
	end
	
	pnl:SetSize(parent:GetWide(), 0)
	
	pnl.Layout = pnl:Add("DIconLayout")
	pnl.Layout.Paint = function() end
	pnl.Layout:SetSize(parent:GetWide() - 15, 0)
	
	pnl.Inputs = {}
	
	if title and title[1] != "" then
		local wrap = pnl.Layout:Add("DPanel")
		wrap:SetSize(parent:GetWide() - 15, 30)
		wrap.Paint = function() end
		
		local lab = wrap:Add("DLabel")
		lab:SetFont("SettingTitle")
		lab:SetColor(Color(100, 100, 100))
		lab:SetText(GetType(title) == "table" and title[1] or title)
		lab:SizeToContents()
		lab:SetPos(10, wrap:GetTall() / 2 - lab:GetTall() / 2)
		
		pnl:SetTall(pnl:GetTall() + 50)
	end
	
	for k, v in pairs(def) do
		local nt
		local NextTitle = istable(title) and table.Copy(title) or title
		
		if GetType(v) == "table" then
			NextTitle[1] = ""
			nt = t
		else
			NextTitle = type(NextTitle) == "table" and (NextTitle[k + 1] or "") or ""
			nt = t[k] or t[1]
		end
		
		local setting = CreateSetting(pnl.Layout, NextTitle, v, nt, IsChild or GetType(v) == "table")
		
		pnl:SetTall(pnl:GetTall() + setting:GetTall())
		
		table.insert(pnl.Inputs, setting)
	end
	
	return pnl
end

local function OnChildCreated(child, pnl, index)
	local btn = child:Add("DButton")
	btn:SetText("")
	
	surface.SetFont("marlett")
	
	btn:SetSize(surface.GetTextSize("r"))
	btn:SetPos(child:GetWide() - btn:GetWide() - 5, 5)
	
	btn.Paint = function(_, w, h)
		if child:IsHovered() or child:IsChildHovered() then
			surface.SetTextColor(255, 100, 100)
			surface.SetTextPos(0, 0)
			surface.SetFont("marlett")
			surface.DrawText("r")
		end
	end
	
	btn.DoClick = function()
		local t = child:GetTall()
		
		pnl:SetTall(pnl:GetTall() - t)
		
		if pnl.btn then
			local x, y = pnl.btn:GetPos()
			y = y - t
			pnl.btn:SetPos(x, y)
		end
		
		if pnl.Inputs[index] then
			pnl.Inputs[index]:Remove()
			table.remove(pnl.Inputs, index)
		end
	end
end

function PANEL:AddSetting(name, title, def, t)
	local pnl = CreateSetting(self.Layout, title, def, t, false)
	
	if istable(t) then		
		for k, v in pairs(pnl.Inputs) do
			OnChildCreated(v, pnl, k)
		end
		
		surface.SetFont("InputButton")
		
		pnl:SetTall(pnl:GetTall() + 20)
		
		pnl.btn = pnl:Add("DButton")
		pnl.btn:SetSize(math.max(surface.GetTextSize(GetText("AddOption")) + 10, 80), 20)
		pnl.btn:SetPos(10, pnl:GetTall() - pnl.btn:GetTall() - 10)
		pnl.btn:SetText("")
		
		pnl.btn.Paint = function(_, w, h)
			if pnl.btn:IsHovered() then
				surface.SetDrawColor(210, 210, 210)
			else
				surface.SetDrawColor(225, 225, 225)
			end
			
			surface.DrawRect(0, 0, w, h)
		
			surface.SetDrawColor(100, 100, 100)
			surface.DrawOutlinedRect(0, 0, w, h)
			
			draw.SimpleText(GetText("AddOption"), "InputButton", w / 2, h / 2, Color(80, 80, 80), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		end
		
		pnl.btn.DoClick = function()
			if #t > 1 then
				local tbl = {}
				
				for _, v in pairs(t) do
					table.insert(tbl, GetEmptySetting(v))
				end
				
				local NextTitle = table.Copy(title)
				NextTitle[1] = ""
				
				pnl.Inputs[#pnl.Inputs + 1] = CreateSetting(pnl.Layout, NextTitle, tbl, t, true)
			else
				pnl.Inputs[#pnl.Inputs + 1] = CreateSetting(pnl.Layout, "", GetEmptySetting(t[1]), t[1], false)
			end
			
			local tall = pnl.Inputs[#pnl.Inputs]:GetTall()
			
			pnl:SetTall(pnl:GetTall() + tall)
			
			local x, y = pnl.btn:GetPos()
			
			pnl.btn:SetPos(x, y + tall)
			
			OnChildCreated(pnl.Inputs[#pnl.Inputs], pnl, #pnl.Inputs)
		end
	end
	
	local OldPaint = pnl.Paint
	
	pnl.Paint = function(_, w, h)
		OldPaint(pnl, w, h)
		
		surface.SetDrawColor(210, 210, 210)
		surface.DrawRect(0, 0, w, 1)
		surface.DrawRect(0, h - 1, w, 1)
	end
	
	self.Inputs[name] = pnl
end

function PANEL:Clear()
	if self.Inputs then
		for _, v in pairs(self.Inputs) do
			v:Remove()
		end
	end
	
	if self.bottom then
		self.bottom:Remove()
	end
	
	self.bottom = nil
	
	self.Inputs = {}
end

vgui.Register("Editor", PANEL, "EditablePanel")

function GetValues(pnl)
	if !IsValid(pnl) then return end
	
	local tbl = {}
	
	for k, v in pairs(pnl.Inputs) do
		if v.Inputs then
			tbl[k] = GetValues(v)
		else
			if v.t == "color" and v.colors then
				tbl[k] = Color(v.colors.R:GetValue(), v.colors.G:GetValue(), v.colors.B:GetValue())
				
				continue
			end
			
			if v.inp then
				if v.t == "boolean" then
					tbl[k] = v.inp:GetChecked()
					
					continue
				end
				
				tbl[k] = v.inp:GetValue()
			end
		end
	end
	
	return tbl
end

net.Receive("SendSettings", function()
	if !editor then return end
	
	editor:Clear()
	
	local tbl = net.ReadTable()
	
	for _, v in pairs(DefaultSettings) do
		if tbl[v[1]] != nil then
			editor:AddSetting(v[1], GetText(v[1]), tbl[v[1]], v[2])
		end
	end
	
	editor.bottom = editor.Layout:Add("DPanel")
	editor.bottom:SetSize(0, 50)
	editor.bottom.Paint = function() end
	
	editor.bottom.Save = editor.bottom:Add("DButton")
	editor.bottom.Save:SetText("")
	editor.bottom.Save:SetPos(10, 10)
	
	surface.SetFont("BottomButtons")
	local w = surface.GetTextSize(GetText("Save"))
	
	editor.bottom.Save:SetSize(math.max(w, 180), 30)
	
	editor.bottom.Save.DoClick = function()
		if !editor.Map or editor.Map and !editor.Map.inp then return end
	
		local settings = GetValues(editor)
		settings.map = editor.Map.inp:GetValue()
		
		net.Start("EditSettings")
			net.WriteTable(settings)
		net.SendToServer()
	end
	
	editor.bottom.Save.Paint = function(_, w, h)
		if editor.bottom.Save:IsHovered() then
			surface.SetDrawColor(200, 200, 200)
			surface.DrawRect(0, 0, w, h)
		end
		
		surface.SetDrawColor(150, 150, 150)
		surface.DrawOutlinedRect(0, 0, w , h)
		
		draw.SimpleText(GetText("Save"), "BottomButtons", w / 2, h / 2, Color(80, 80, 80), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	editor.bottom.RestoreDefault = editor.bottom:Add("DButton")
	editor.bottom.RestoreDefault:SetText("")
	editor.bottom.RestoreDefault:SetPos(editor.bottom.Save:GetWide() + 20, 10)
	
	surface.SetFont("BottomButtons")
	local w = surface.GetTextSize(GetText("RestoreDefaults"))
	
	editor.bottom.RestoreDefault:SetSize(math.max(w, 180), 30)
	
	editor.bottom.RestoreDefault.DoClick = function()
		if !editor.Map or editor.Map and !editor.Map.inp then return end
	
		net.Start("RestoreSettings")
			net.WriteString(editor.Map.inp:GetValue())
		net.SendToServer()
	end
	
	editor.bottom.RestoreDefault.Paint = function(_, w, h)
		if editor.bottom.RestoreDefault:IsHovered() then
			surface.SetDrawColor(200, 200, 200)
			surface.DrawRect(0, 0, w, h)
		end
		
		surface.SetDrawColor(150, 150, 150)
		surface.DrawOutlinedRect(0, 0, w , h)
		
		draw.SimpleText(GetText("RestoreDefaults"), "BottomButtons", w / 2, h / 2, Color(80, 80, 80), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end)

net.Receive("SendConfig", function()
	if !editor then return end
	
	editor:Clear()
	
	local tbl = net.ReadTable()
	
	for _, v in pairs(DefaultConfig) do
		if tbl[v[1]] != nil then
			editor:AddSetting(v[1], GetText(v[1]) or "", tbl[v[1]], v[2])
		end
	end
	
	editor.bottom = editor.Layout:Add("DPanel")
	editor.bottom:SetSize(0, 50)
	editor.bottom.Paint = function() end
	
	editor.bottom.Save = editor.bottom:Add("DButton")
	editor.bottom.Save:SetText("")
	editor.bottom.Save:SetPos(10, 10)
	
	surface.SetFont("BottomButtons")
	local w = surface.GetTextSize(GetText("Save"))
	
	editor.bottom.Save:SetSize(math.max(w, 180), 30)
	
	editor.bottom.Save.DoClick = function()
		net.Start("EditConfig")
			net.WriteTable(GetValues(editor))
		net.SendToServer()
	end
	
	editor.bottom.Save.Paint = function(_, w, h)
		if editor.bottom.Save:IsHovered() then
			surface.SetDrawColor(200, 200, 200)
			surface.DrawRect(0, 0, w, h)
		end
		
		surface.SetDrawColor(150, 150, 150)
		surface.DrawOutlinedRect(0, 0, w , h)
		
		draw.SimpleText(GetText("Save"), "BottomButtons", w / 2, h / 2, Color(80, 80, 80), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
	
	editor.bottom.RestoreDefault = editor.bottom:Add("DButton")
	editor.bottom.RestoreDefault:SetText("")
	editor.bottom.RestoreDefault:SetPos(editor.bottom.Save:GetWide() + 20, 10)
	
	surface.SetFont("BottomButtons")
	local w = surface.GetTextSize(GetText("RestoreDefaults"))
	
	editor.bottom.RestoreDefault:SetSize(math.max(w, 180), 30)
	
	editor.bottom.RestoreDefault.DoClick = function()
		net.Start("RestoreConfig")
		net.SendToServer()
	end
	
	editor.bottom.RestoreDefault.Paint = function(_, w, h)
		if editor.bottom.RestoreDefault:IsHovered() then
			surface.SetDrawColor(200, 200, 200)
			surface.DrawRect(0, 0, w, h)
		end
		
		surface.SetDrawColor(150, 150, 150)
		surface.DrawOutlinedRect(0, 0, w , h)
		
		draw.SimpleText(GetText("RestoreDefaults"), "BottomButtons", w / 2, h / 2, Color(80, 80, 80), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	end
end)

function OpenEditor()
	if IsValid(editor) then
		if !editor:IsVisible() then
			if editor.IsConfig and editor.Config then
				editor.Config:DoClick()
			end
			
			if editor.IsMap and editor.MapSetting then
				editor.MapSetting:DoClick()
			end
			
			editor:Show()
		end
	else
		editor = vgui.Create("Editor")
	end
end

net.Receive("SendMaps", function()
	ServerMaps = net.ReadTable()
end)