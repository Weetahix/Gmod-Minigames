surface.CreateFont("ActsFont", {
	font = "Tahoma",
	size = 18,
	weight = 500
})

local ACTS = {}

ACTS.ActsList = {
	"agree",
	"becon",
	"cheer",
	"dance",
	"disagree",
	"forward",
	"laugh",
	"muscle",
	"pers",
	"robot",
	"salute",
	"wave",
	"zombie"
}

function ACTS:Init()
	self:SetPos(ScrW() / 2 - 125, ScrH() / 2)
	self:SetSize(300, 25)
	
	local CloseButton = self:Add("DButton")
	CloseButton:SetPos(280, 5)
	CloseButton:SetFont('marlett')
	CloseButton:SetText('r')
	CloseButton.Paint = function() end
	CloseButton:SetColor(Color(255, 255, 255))
	CloseButton:SetSize(20, 20)
	CloseButton.DoClick = function()
		self:Hide()
	end
	
	self:MakePopup()
	self:SetKeyboardInputEnabled(false)
	
	for _, v in pairs(self.ActsList) do
		self:AddOption(v)
	end
end

function ACTS:Paint(w, h)
	surface.SetDrawColor(60, 60, 60)
	surface.DrawRect(0, 0, w, h)
end

function ACTS:AddOption(text)
	local t = self:GetTall()
	
	self:SetTall(t + 50)
	
	local x, y = self:GetPos()
	self:SetPos(x, y - 25)
	
	local button = self:Add("DButton")
	button:SetPos(5, t + 5)
	button:SetSize(290, 40)
	button:SetText("")
	
	button.DoClick = function()
		RunConsoleCommand("act", text)
		self:Hide()
	end
	
	button.Paint = function(_, w, h)		
		if button:IsHovered() then
			surface.SetDrawColor(80, 0, 200)
		else
			surface.SetDrawColor(40, 40, 40)
		end
		
		surface.DrawRect(0, 0, w, h)
		
		surface.SetFont("ActsFont")
		
		local str = string.upper(text[1]) .. string.sub(text, 2)
		
		local TextW, TextH = surface.GetTextSize(str)
		
		surface.SetTextColor(200, 200, 200)
		surface.SetTextPos(w / 2 - TextW / 2, h / 2 - TextH / 2)
		surface.DrawText(str)
	end
end

vgui.Register("Acts", ACTS)

function OpenActs()
	if IsValid(acts) then
		if !acts:IsVisible() then
			acts:Show()
		end
	else
		acts = vgui.Create("Acts")
	end
end