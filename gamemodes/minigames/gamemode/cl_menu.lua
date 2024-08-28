surface.CreateFont("MenuTitle", {
	font = "Tahoma",
	size = 20,
	weight = 600
})

surface.CreateFont("MenuText", {
	font = "Tahoma",
	size = 16,
	weight = 600
})

local PANEL = {}

function PANEL:Init()
	local w = 700
	local h = 500
	
	self:SetSize(w, h)
	self:SetPos(ScrW() / 2 - w / 2, ScrH() / 2 - h / 2)
	
	self.CloseButton = self:Add("DButton")
	self.CloseButton:SetFont('marlett')
	self.CloseButton:SetText('r')
	self.CloseButton.Paint = function() end
	self.CloseButton:SetColor(Color(255, 255, 255))
	self.CloseButton:SetSize(20, 20)
	self.CloseButton:SetPos(w - 25, 5)
	self.CloseButton.DoClick = function()
		self:Hide()
	end
	
	self.RichText = self:Add("RichText")
	self.RichText:SetPos(0, 40)
	self.RichText:SetSize(w, h - 78)
	
	self.RichText.Paint = function(_, w, h)
		surface.SetDrawColor(0, 0, 0, 120)
		surface.DrawRect(0, 0, w, h)
	end
	
	self.RichText:InsertColorChange(200, 200, 200, 255)
	
	for k, v in pairs(GetText("Description")) do
		if k % 2 == 0 then
			self.RichText:InsertClickableTextStart(k / 2)
				self.RichText:AppendText(v)
			self.RichText:InsertClickableTextEnd()
		else
			self.RichText:AppendText(v)
		end
	end
	
	self.RichText.PerformLayout = function()
		self.RichText:SetFontInternal("MenuText")
	end
	
	self.RichText.links = {
		"http://steamcommunity.com/id/spoody_moon/",
		"http://steamcommunity.com/id/MrFisherMan/",
		"http://steamcommunity.com/id/tommygodlike/",
		"http://steamcommunity.com/profiles/76561198049356560/",
		"http://steamcommunity.com/profiles/76561198013004553/",
		"http://steamcommunity.com/id/8Haru/",
		"http://steamcommunity.com/sharedfiles/filedetails/?id=637780897",
		"http://steamcommunity.com/profiles/76561198254251225",
		"http://steamcommunity.com/profiles/76561198254251225",
		"http://steamcommunity.com/profiles/76561198254251225",
		"http://steamcommunity.com/profiles/76561198254251225"
	}
	
	self.RichText.ActionSignal = function(_, name, val)
		if name == "TextClicked" then
			gui.OpenURL(self.RichText.links[tonumber(val)])
		end
	end
	
	self.LanguageChoose = self:Add("DComboBox")
	self.LanguageChoose:SetPos(10, h - 30)
	self.LanguageChoose:SetSize(80, 20)
	self.LanguageChoose:SetTextColor(Color(200, 200, 200))
	
	self.LanguageChoose.Paint = function(_, w, h)
		surface.SetDrawColor(60, 60, 70)
		surface.DrawRect(0, 0, w, h)
		
		surface.SetDrawColor(100, 100, 100)
		surface.DrawOutlinedRect(0, 0, w, h)
	end
	
	for k, v in pairs(LANGUAGES) do
		self.LanguageChoose:AddChoice(v.LangName, k, k == CurLang)
	end
	
	self.LanguageChoose.OnSelect = function(_, index, val, data)
		SetLanguage(data)
	end
	
	function self.LanguageChoose:OpenMenu( pControlOpener )
		if ( pControlOpener ) then
			if ( pControlOpener == self.TextEntry ) then
				return
			end
		end

		if ( #self.Choices == 0 ) then return end
		
		if ( IsValid( self.Menu ) ) then
			self.Menu:Remove()
			self.Menu = nil
		end

		self.Menu = DermaMenu()
		
		self.Menu.Paint = function(_, w, h)
			surface.SetDrawColor(60, 60, 70)
			surface.DrawRect(0, 0, w, h)
		end
		
		function self.Menu:AddOption( strText, funcFunction )
			local pnl = vgui.Create( "DMenuOption", self )
			pnl:SetMenu( self )
			pnl:SetTextColor(Color(200, 200, 200))
			pnl:SetText( strText )
			if ( funcFunction ) then pnl.DoClick = funcFunction end
			
			self:AddPanel( pnl )
			
			return pnl
		end
		
		local sorted = {}
		for k, v in pairs( self.Choices ) do table.insert( sorted, { id = k, data = v } ) end
		for k, v in SortedPairsByMemberValue( sorted, "data" ) do
			self.Menu:AddOption( v.data, function() self:ChooseOption( v.data, v.id ) end )
		end
		
		local x, y = self:LocalToScreen( 0, self:GetTall() )
		
		self.Menu:SetMinimumWidth( self:GetWide() )
		self.Menu:Open( x, y, false, self )
	end
	
	self.DisableVoiceChat = self:Add("DCheckBoxLabel")
	self.DisableVoiceChat:SetValue(tobool(LocalPlayer():GetPData("mg_DisableVoiceChat")))
	self.DisableVoiceChat:SetText(GetText("DisableVoiceChat"))
	self.DisableVoiceChat:SizeToContents()
	self.DisableVoiceChat:SetPos(self.LanguageChoose:GetWide() + 30, h - self.DisableVoiceChat:GetTall() / 2 - 20)
	
	self.DisableVoiceChat.OnChange = function(_, val)
		LocalPlayer():SetPData("mg_DisableVoiceChat", val)
		
		net.Start("DisableVoiceChat")
			net.WriteBool(val)
		net.SendToServer()
	end
	
	
	self.PreventMusic = self:Add("DCheckBoxLabel")
	self.PreventMusic:SetValue(tobool(PreventMusic))
	self.PreventMusic:SetText(GetText("PreventMusic"))
	self.PreventMusic:SizeToContents()
	self.PreventMusic:SetPos(self.LanguageChoose:GetWide() + self.DisableVoiceChat:GetWide() + 70, h - self.PreventMusic:GetTall() / 2 - 20)
	
	self.PreventMusic.OnChange = function(_, val)
		LocalPlayer():SetPData("mg_PreventMusic", val)
		PreventMusic = val
		
		if val then
			RunConsoleCommand("stopsound")
		end
	end
	
	self:MakePopup()
end

function PANEL:Paint(w, h)
	Derma_DrawBackgroundBlur(self)
	
	surface.SetDrawColor(40, 40, 50, 200)
	surface.DrawRect(0, 0, w, h)
	
	surface.SetDrawColor(100, 100, 100)
	surface.DrawRect(0, 39, w, 1)
	surface.DrawRect(0, h - 39, w, 1)
	
	surface.SetFont("MenuTitle")
	surface.SetTextColor(200, 200, 200)
	surface.SetTextPos(10, 10)
	surface.DrawText(GetHostName())
end

vgui.Register("PlyMenu", PANEL)