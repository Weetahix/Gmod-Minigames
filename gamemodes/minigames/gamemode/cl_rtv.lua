surface.CreateFont("RTVFont", {
	font = "Tahoma",
	size = 18,
	weight = 500
})

surface.CreateFont("RTVTitle", {
	font = "Tahoma",
	size = 14,
	weight = 500
})

net.Receive("RTV_Message", function()
	local str = net.ReadString()
	local tbl = net.ReadTable()
	
	if GetText(str) then
		chat.AddText(Color(240, 240, 240), string.format(GetText(str), unpack(tbl)))
	end
end)

local VOTE = {}

function VOTE:Init()
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
end

function VOTE:Paint(w, h)
	surface.SetDrawColor(60, 60, 60)
	surface.DrawRect(0, 0, w, h)
	
	surface.SetFont("RTVTitle")	
	surface.SetTextPos(5, 8)
	surface.SetTextColor(200, 200, 200)
	surface.DrawText(GetText("SelectMap"))
end

function VOTE:AddOption(text)
	local t = self:GetTall()
	
	self:SetTall(t + 50)
	
	local x, y = self:GetPos()
	self:SetPos(x, y - 25)
	
	local button = self:Add("DButton")
	button:SetPos(5, t + 5)
	button:SetSize(290, 40)
	button:SetText("")
	
	button.DoClick = function()
		net.Start("RTV_Voted")
			net.WriteString(text)
		net.SendToServer()
	end
	
	button.Paint = function(_, w, h)
		local prw = 0
		
		local num = GetGlobalInt(text)
		
		if num > 0 then
			prw = math.Round(num * w / #player.GetAll())
		end
		
		if prw > w then prw = w end
		
		surface.SetDrawColor(0, 200, 0)
		surface.DrawRect(0, 0, prw, h)
		
		surface.SetDrawColor(40, 40, 40)
		surface.DrawRect(prw, 0, w - prw, h)
		
		surface.SetFont("RTVFont")
		
		local _, TextH = surface.GetTextSize(text)
		
		surface.SetTextColor(200, 200, 200)
		surface.SetTextPos(5, h / 2 - TextH / 2)
		surface.DrawText(text)
		
		local str = "(" .. num .. "/" .. #player.GetAll() .. ")"
		
		surface.SetTextPos(w - surface.GetTextSize(str) - 5, 20 - TextH / 2)
		surface.DrawText(str)
	end
end

vgui.Register("rtv", VOTE)

net.Receive("RTV_Start", function()
	notification.AddLegacy(GetText("ChooseMap"), 0, 5)

	vote = vgui.Create("rtv")
	
	local maps = net.ReadTable()
	
	for _, v in pairs(maps) do
		vote:AddOption(v)
	end
end)

net.Receive("RTV_End", function()
	local str = string.format(GetText("MapWon"), net.ReadString())
	
	notification.AddLegacy(str, 0, 5)
	chat.AddText(Color(255, 255, 255), str)
	
	if IsValid(vote) then
		vote:Remove()
	end
end)