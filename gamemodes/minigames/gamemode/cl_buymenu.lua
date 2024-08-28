net.Receive("buymenu", function(len, player)
	if CanBuy and !frame then
	local frame = vgui.Create("DFrame")
	frame:SetSize(800,600)
	frame:Center()
	frame:SetVisible(true)
	frame:SetTitle("Buymenu")
	frame:SetDraggable(false)
	frame:MakePopup()
	frame.Paint = function()
		surface.SetDrawColor(0, 0, 0, 220)
		surface.DrawRect(0, 0, frame:GetWide(), frame:GetTall())
		surface.SetDrawColor(0, 0, 0, 0)
		surface.DrawOutlinedRect(0, 0, frame:GetWide(), frame:GetTall())
	end

	local label = vgui.Create ("DLabel", frame)
	label:SetPos(20,30)
	label:SetText("Pistols")
	
	local button = vgui.Create("DButton", frame)
	button:SetText("Glock")
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(40, 60)
	button:SetSize(100, 30)
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250)) 
	end
	button.DoClick = function()
		net.Start("GiveGlock")
		net.SendToServer(len, ply)
	end
	
	local button = vgui.Create("DButton", frame)
	button:SetText("USP")
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(164, 60)
	button:SetSize(100, 30)
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250))
	end
	button.DoClick = function()
		net.Start("GiveUsp")
		net.SendToServer(len, ply)
	end

	local button = vgui.Create("DButton", frame)
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(288,60)
	button:SetSize(100,30)
	button:SetText("P228")
	button.DoClick = function()
		net.Start("GiveP228")
		net.SendToServer(len, ply)
	end
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250)) 
	end

	local button = vgui.Create("DButton", frame)
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(412,60)
	button:SetSize(100,30)
	button:SetText("Dual Elites")
	button.DoClick = function()
		net.Start("GiveDualElites")
		net.SendToServer(len, ply)
	end
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250))
	end

	local button = vgui.Create("DButton", frame)
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(536,60)
	button:SetSize(100,30)
	button:SetText("Five-Seven")
	button.DoClick = function()
		net.Start("GiveFiveSeven")
		net.SendToServer(len, ply)
	end
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250))
	end

	local button = vgui.Create("DButton", frame)
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(660,60)
	button:SetSize(100,30)
	button:SetText("Deagle")
	button.DoClick = function()
		net.Start("GiveDeagle")
		net.SendToServer(len, ply)
	end
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250))
	end
	
	local label = vgui.Create ("DLabel", frame)
	label:SetPos(20,105)
	label:SetText("Heavy")
	
	local button = vgui.Create("DButton", frame)
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(40,135)
	button:SetSize(100,30)
	button:SetText("M3")
	button.DoClick = function()
		net.Start("GiveM3")
		net.SendToServer(len, ply)
	end
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250)) 
	end
	
	local button = vgui.Create("DButton", frame)
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(164,135)
	button:SetSize(100,30)
	button:SetText("XM1014")
	button.DoClick = function()
		net.Start("GiveXM1014")
		net.SendToServer(len, ply)
	end
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250)) 
	end
	
	local button = vgui.Create("DButton", frame)
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(288,135)
	button:SetSize(100,30)
	button:SetText("M249")
	button.DoClick = function()
		net.Start("GiveM249")
		net.SendToServer(len, ply)
	end
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250))
	end
	
	
	local label = vgui.Create ("DLabel", frame)
	label:SetPos(20,180)
	label:SetText("SMG")
	
	local button = vgui.Create("DButton", frame)
	button:SetText("MAC-10")
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(40, 210)
	button:SetSize(100, 30)
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250)) 
	end
	button.DoClick = function()
		net.Start("GiveMAC10")
		net.SendToServer(len, ply)
	end
	
	local button = vgui.Create("DButton", frame)
	button:SetText("TMP")
	button:SetTextColor(Color(255, 255, 255 ))
	button:SetPos(164, 210)
	button:SetSize(100, 30)
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250)) 
	end
	button.DoClick = function()
		net.Start("GiveTMP")
		net.SendToServer(len, ply)
	end
	
	local button = vgui.Create("DButton", frame)
	button:SetText("MP5")
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(288, 210)
	button:SetSize(100, 30)
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250))
	end
	button.DoClick = function()
		net.Start("GiveMP5")
		net.SendToServer(len, ply)
	end
	
	local button = vgui.Create("DButton", frame)
	button:SetText("UMP45")
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(412, 210)
	button:SetSize(100, 30)
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250))
	end
	button.DoClick = function()
		net.Start("GiveUMP45")
		net.SendToServer(len, ply)
	end
	
	local button = vgui.Create("DButton", frame)
	button:SetText("P90")
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(532, 210)
	button:SetSize(100, 30)
	button.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250))
	end
	button.DoClick = function()
		net.Start("GiveP90")
		net.SendToServer(len, ply)
	end
	
	local label = vgui.Create ("DLabel", frame)
	label:SetPos(20,255)
	label:SetText("Rifles")
	
	local button = vgui.Create("DButton", frame)
	button:SetText("Galil")
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(40, 285)
	button:SetSize(100, 30)
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250)) 
	end
	button.DoClick = function()
		net.Start("GiveGalil")
		net.SendToServer(len, ply)
	end
	
	local button = vgui.Create("DButton", frame)
	button:SetText("Famas")
	button:SetTextColor( Color(255, 255, 255))
	button:SetPos(164, 285)
	button:SetSize(100, 30)
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250))
	end
	button.DoClick = function()
		net.Start("GiveFamas")
		net.SendToServer(len, ply)
	end
	
	local button = vgui.Create("DButton", frame)
	button:SetText("Scout")
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(288, 285)
	button:SetSize(100, 30)
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250))
	end
	button.DoClick = function()
		net.Start("GiveScout")
		net.SendToServer(len, ply)
	end
	
	
	local button = vgui.Create("DButton", frame)
	button:SetText("AK-47")
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(412, 285)
	button:SetSize(100, 30)
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250))
	end
	button.DoClick = function()
		net.Start("GiveAk")
		net.SendToServer(len, ply)
	end
	
	local button = vgui.Create("DButton", frame)
	button:SetText("M4A1")
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(536, 285)
	button:SetSize(100, 30)
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250))
	end
	button.DoClick = function()
		net.Start("GiveM4")
		net.SendToServer(len, ply)
	end
	
	local button = vgui.Create("DButton", frame)
	button:SetText("SG-552")
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(660, 285)
	button:SetSize(100, 30)
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250))
	end
	button.DoClick = function()
		net.Start("GiveSG552")
		net.SendToServer(len, ply)
	end
	
	local button = vgui.Create("DButton", frame)
	button:SetText("AUG")
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(40, 335)
	button:SetSize(100, 30)
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250))
	end
	button.DoClick = function()
		net.Start("GiveAUG")
		net.SendToServer(len, ply)
	end
	
	local button = vgui.Create("DButton", frame)
	button:SetText("AWP")
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(164, 335)
	button:SetSize(100, 30)
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250))
	end
	button.DoClick = function()
		net.Start("GiveAWP")
		net.SendToServer(len, ply)
	end
	
	local button = vgui.Create("DButton", frame)
	button:SetText("G3SG1")
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(288, 335)
	button:SetSize(100, 30)
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250)) 
	end
	button.DoClick = function()
		net.Start("GiveG3SG1")
		net.SendToServer(len, ply)
	end
	
	local button = vgui.Create("DButton", frame)
	button:SetText("SG-550")
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(412, 335)
	button:SetSize(100, 30)
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250)) 
	end
	button.DoClick = function()
		net.Start("GiveSG550")
		net.SendToServer(len, ply)
	end
	
	local label = vgui.Create ("DLabel", frame)
	label:SetPos(20,380)
	label:SetText("Equipment")
	
	local button = vgui.Create("DButton", frame)
	button:SetText("Flashbang")
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(40, 410)
	button:SetSize(100, 30)
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250)) 
	end
	button.DoClick = function()
		net.Start("GiveFlash")
		net.SendToServer(len, ply)
	end
	
	local button = vgui.Create("DButton", frame)
	button:SetText("HE Grenade")
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(164, 410)
	button:SetSize(100, 30)
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250 )) 
	end
	button.DoClick = function()
		net.Start("GiveHE")
		net.SendToServer(len, ply)
	end
	
	
	local button = vgui.Create("DButton", frame)
	button:SetText("Smoke Grenade")
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(288, 410)
	button:SetSize(100, 30)
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250)) 
	end
	button.DoClick = function()
		net.Start("GiveSmoke")
		net.SendToServer(len, ply)
	end
	
	
	
	local button = vgui.Create("DButton", frame)
	button:SetText("Armor")
	button:SetTextColor(Color(255, 255, 255))
	button:SetPos(412, 410)
	button:SetSize(100, 30)
	button.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, Color(41, 128, 185, 250))
	end
	button.DoClick = function()
		net.Start("GiveArmor")
		net.SendToServer(len, ply)
	end
	timer.Create("CloseMenu", 0.1, 0, function() if GetRoundState() == ROUND_ENDING and IsValid(frame) then frame:Close() timer.Stop("CloseMenu") end end)
	timer.Create("CloseMenu1", 0.1, 0, function() if GetRoundState() == ROUND_FREEZE and IsValid(frame) then frame:Close() timer.Stop("CloseMenu1") end end)
	end
	end)