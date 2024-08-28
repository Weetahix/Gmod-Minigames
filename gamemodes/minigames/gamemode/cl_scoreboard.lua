surface.CreateFont("ScoreBoardTitle", {
	font = "Tahoma",
	size = 35,
	weight = 900
})

surface.CreateFont("ScoreBoardSort", {
	font = "Tahoma",
	size = 16,
	weight = 600
})

surface.CreateFont("ScoreBoardPlayerInfo", {
	font = "Tahoma",
	size = 17,
	weight = 600
})

surface.CreateFont("ScoreBoardTeamName", {
	font = "Tahoma",
	size = 18,
	weight = 600
})

surface.CreateFont("ScoreBoardFrameText", {
	font = "Tahoma",
	size = 16,
	weight = 500
})

local function CreateTeamPanel(index, tbl)
	if !ScoreBoard then return end
	
	ScoreBoard.TeamsContainer.Teams[index] = ScoreBoard.TeamsContainer:Add("DIconLayout")
	ScoreBoard.TeamsContainer.Teams[index]:SetWide(math.Clamp(1024, 0, ScrW()))
	ScoreBoard.TeamsContainer.Teams[index]:SetBorder(2)
	ScoreBoard.TeamsContainer.Teams[index]:SetSpaceY(3)
	ScoreBoard.TeamsContainer.Teams[index].Index = index
	
	ScoreBoard.TeamsContainer.Teams[index].Think = function(self)
		if #team.GetPlayers(index) == 0 and self:IsVisible() then
			self:Hide()
		end
		
		if #team.GetPlayers(index) != 0 and !self:IsVisible() then
			self:Show()
		end
	end	
	
	local pnl = ScoreBoard.TeamsContainer.Teams[index]:Add("DPanel")
	surface.SetFont("ScoreBoardTeamName")
	pnl:SetSize(surface.GetTextSize(tbl[1] .. " (" .. #team.GetPlayers(index) .. ")") + 10, 24)
	
	pnl.Paint = function(pnl, w, h)	
		local color = tbl[2]
	
		surface.SetDrawColor(color)
		surface.DrawRect(0, 0, w, h)
		
		surface.SetTextColor(200, 200, 200)
		surface.SetTextPos(5, 2)
		surface.SetFont("ScoreBoardTeamName")
		surface.DrawText(tbl[1] .. " (" .. #team.GetPlayers(index) .. ")")
	end	
end

local function CreateTextPanel(title, text, fnc)
	local frame = vgui.Create("DFrame")
	frame:SetPos(ScrW() / 2 - 200, ScrH() / 2 - 100)
	frame:SetSize(400, 150)
	frame:SetTitle(title)
	
	local label = vgui.Create("DLabel", frame)
	label:SetFont("ScoreBoardFrameText")
	label:SetTextColor(Color(255, 255, 255))
	label:SetText(text)
	label:SizeToContents()
	label:SetPos(frame:GetWide() / 2 - label:GetWide() / 2, 40)
	
	local TextEntry = vgui.Create("DTextEntry", frame)
	TextEntry:SetPos(30, 70)
	TextEntry:SetSize(340, 25)
	
	local close = vgui.Create("DButton", frame)
	close:SetPos(205, 110)
	close:SetSize(50, 22)
	close:SetText("Cancel")
	close.DoClick = function()
		frame:Remove()
	end
	
	local ok = vgui.Create("DButton", frame)
	ok:SetPos(150, 110)
	ok:SetSize(50, 22)
	ok:SetText("OK")
	ok.DoClick = function()
		fnc(TextEntry:GetValue())
		frame:Remove()
	end
	
	frame:MakePopup()	
end

local function CreatePlayerPanel(ply, ParentTeam)
	local pnl = ScoreBoard.TeamsContainer.Teams[ParentTeam]:Add("DButton")
	local width = math.Clamp(1024, 0, ScrW())
	
	pnl:SetPos(0, 0)
	pnl:SetSize(width, 30)
	pnl:SetText("")
	
	pnl.Avatar = pnl:Add("AvatarImage")
	pnl.Avatar:SetSize(24, 24)
	pnl.Avatar:SetPos(width * 0.1 + 10, 3)
	pnl.Avatar:SetPlayer(ply, 24)
	
	if ply:SteamID() == "STEAM_0:1:81066284" then
		pnl:SetTooltip(GetText("GamemodeCreator"))
	end
	
	pnl.DoRightClick = function()
		local lp = LocalPlayer()
	
		local options = DermaMenu()
		options:AddOption(GetText("CopyName"), function()
			local name = ply:Name()
			SetClipboardText(name)
		end)
		
		options:AddOption(GetText("CopySteamID"), function()
			SetClipboardText(ply:SteamID())
		end)
		
		options:AddOption(GetText("ViewProfile"), function()
			ply:ShowProfile()
		end)
		
		if ply != lp then
			if ply:IsMuted() then
				options:AddOption(GetText("Unmute"), function()
					ply:SetMuted(false)
				end)
			else
				options:AddOption(GetText("Mute"), function()
					ply:SetMuted(true)
				end)
			end
		end
		
		if !ULib or !ulx then return end
		
		if ply != lp and ULib.ucl.query(lp, "ulx psay") then
			options:AddOption(GetText("PrivateMessage"), function()
				CreateTextPanel(GetText("PrivateMessage"), GetText("EnterMessage"), function(text)
					RunConsoleCommand("ulx", "psay", ply:Nick(), text)
				end)
			end)
		end
		
		local first = true
		
		if ULib.ucl.query(lp, "ulx kick") then
			if first then
				options:AddSpacer()
				first = false
			end
			
			options:AddOption(GetText("Kick"), function()
				CreateTextPanel(GetText("Kick"), GetText("EnterReason"), function(text)
					RunConsoleCommand("ulx", "kick", ply:Nick(), text)
				end)
			end)
		end
		
		if ULib.ucl.query(lp, "ulx slap") then
			if first then
				options:AddSpacer()
				first = false
			end
			
			options:AddOption(GetText("Slap"), function()
				RunConsoleCommand("ulx", "slap", ply:Nick())
			end)
		end
		
		if ULib.ucl.query(lp, "ulx slay") and ply:Alive() then
			if first then
				options:AddSpacer()
				first = false
			end
			
			options:AddOption(GetText("Slay"), function()
				RunConsoleCommand("ulx", "slay", ply:Nick())
			end)
		end
		
		if ply:Alive() then
			local goto = ply != lp and ULib.ucl.query(lp, "ulx goto") or false
			local bring = ply != lp and ULib.ucl.query(lp, "ulx bring") or false
			local teleport = ULib.ucl.query(lp, "ulx teleport")
			local send = ply != lp and ULib.ucl.query(lp, "ulx send") or false
			
			if goto or bring or teleport or send then
				if first then
					options:AddSpacer()
					first = false
				end
				
				local TpMenu = options:AddSubMenu(GetText("Teleport"))
				
				if goto then
					TpMenu:AddOption(GetText("Goto"), function()
						RunConsoleCommand("ulx", "goto", ply:Nick())
					end)
				end
				
				if bring then
					TpMenu:AddOption(GetText("Bring"), function()
						RunConsoleCommand("ulx", "bring", ply:Nick())
					end)
				end
				
				if teleport then
					TpMenu:AddOption(GetText("Teleport"), function()
						RunConsoleCommand("ulx", "teleport", ply:Nick())
					end)
				end
				
				if send then
					local GotoMenu = TpMenu:AddSubMenu(GetText("Send"))
					
					for _, v in pairs(player.GetAll()) do
						if v:Alive() and v != lp and v != ply then
							GotoMenu:AddOption(v:Nick(), function()
								RunConsoleCommand("ulx", "send", ply:Nick(), v:Nick())
							end)
						end
					end
				end
			end
		end
		
		if ply:GetNWBool("ulx_muted") then
			if ULib.ucl.query(lp, "ulx unmute") then
				if first then
					options:AddSpacer()
					first = false
				end
				
				options:AddOption(GetText("Unmute"), function()
					RunConsoleCommand("ulx", "unmute", ply:Nick())
				end)
			end
		else
			if ULib.ucl.query(lp, "ulx mute") then
				if first then
					options:AddSpacer()
					first = false
				end
				
				options:AddOption(GetText("Mute"), function()
					RunConsoleCommand("ulx", "mute", ply:Nick())
				end)
			end
		end
		
		if ply:GetNWBool("ulx_gagged") then
			if ULib.ucl.query(lp, "ulx ungag") then
				if first then
					options:AddSpacer()
					first = false
				end
				
				options:AddOption(GetText("Ungag"), function()
					RunConsoleCommand("ulx", "ungag", ply:Nick())
				end)
			end
		else
			if ULib.ucl.query(lp, "ulx gag") then
				if first then
					options:AddSpacer()
					first = false
				end
				
				options:AddOption(GetText("Gag"), function()
					RunConsoleCommand("ulx", "gag", ply:Nick())
				end)
			end
		end
		
		options:Open()
	end
	
	pnl.Think = function()
		if !IsValid(ply) or ParentTeam != ply:Team() then
			RefreshScoreBoard()
			return
		end
	end
	
	pnl.Paint = function(self, w, h)
		if !IsValid(ScoreBoard) or !ScoreBoard:IsVisible() then return end
		
		if !IsValid(ply) then return end
		
		if self:IsHovered() and ply:IsMuted() then
			surface.SetDrawColor(100, 0, 100, 190)
		end
		
		if self:IsHovered() and !ply:IsMuted() then
			surface.SetDrawColor(0, 0, 100, 190)
		end
		
		if !self:IsHovered() and ply:IsMuted() then
			surface.SetDrawColor(100, 0, 0, 190)
		end
		
		if !self:IsHovered() and !ply:IsMuted() then
			surface.SetDrawColor(40, 40, 50, 190)
		end
		
		surface.DrawRect(0, 0, w, h)
		
		surface.SetDrawColor(100, 100, 150)
		surface.DrawRect(w * 0.1 + 9, 2, 26, 26)
		
		surface.SetFont("ScoreBoardPlayerInfo")
		surface.SetTextColor(Color(200, 200, 200))
		
		local _, y = surface.GetTextSize("|") 
		y = h / 2 - y / 2
		
		surface.SetTextPos(w * 0.1 / 2 - surface.GetTextSize(ply:UserID()) / 2, y)
		surface.DrawText(ply:UserID())
		
		local margin = w * 0.1
		surface.SetDrawColor(180, 180, 180, 200)
		surface.DrawRect(margin, 0, 2, h)
		
		surface.SetTextPos(margin + 44, y)
		surface.DrawText(ply:Name())
		
		margin = margin + w * 0.4 	
		surface.DrawRect(margin, 0, 2, h)
		
		local PlyGroup
		local UserGroup = ply:GetUserGroup()
		
		local group = {}
		
		for _, v in pairs(groups) do
			if v[1] == UserGroup then
				group = v
				break
			end
		end
		
		if #group > 0 then
			PlyGroup = group
		else
			PlyGroup = {nil, 0, string.upper(UserGroup), Color(255, 0, 0)}
		end
		
		surface.SetTextColor(PlyGroup[4])
		surface.SetTextPos(margin + w * 0.2 / 2 - surface.GetTextSize(PlyGroup[3]) / 2, y)
		surface.DrawText(PlyGroup[3])
		
		if ply:Team() != TEAM_SPECTATORS then
			local str = ply:Alive() and GetText("Alive") or GetText("Dead")
			
			surface.SetTextPos(margin - 10 - surface.GetTextSize(str), y)
			surface.SetTextColor(ply:Alive() and Color(46, 255, 46) or Color(150, 0, 0))
			surface.DrawText(str)
		end
		
		surface.SetTextColor(Color(200, 200, 200))
		
		margin = margin + w * 0.2 
		surface.DrawRect(margin, 0, 2, h)
		
		surface.SetTextPos(margin + w * 0.1 / 2 - surface.GetTextSize(ply:Frags()) / 2, y)
		surface.DrawText(ply:Frags())
		
		margin = margin + w * 0.1 
		surface.DrawRect(margin, 0, 2, h)
		
		surface.SetTextPos(margin + w * 0.1 / 2 - surface.GetTextSize(ply:Deaths()) / 2, y)
		surface.DrawText(ply:Deaths())
		
		margin = margin + w * 0.1 
		surface.DrawRect(margin, 0, 2, h)
		
		local ping = ply:Ping()
		
		surface.SetTextColor(ping * 0.6, 255 - ping * 0.6, 0)
		surface.SetTextPos(margin + (w - margin) / 2 - surface.GetTextSize(ping) / 2, y)
		surface.DrawText(ping)
	end
end

function RefreshScoreBoard()
	if !ScoreBoard then return end
	
	ScoreBoard.TeamsContainer:Clear()
	ScoreBoard.TeamsContainer.Teams = {}
	for k, v in pairs(Teams) do
		CreateTeamPanel(k, v)
		
		local players = GetSortedPlayers(team.GetPlayers(k))
		for _, v1 in pairs(players) do
			if ScoreBoard.TeamsContainer.Teams[k] then
				CreatePlayerPanel(v1, k)
			end	
		end		
	end	
end

local function sort(tbl, sorter)
	for i = 0, #tbl - 1 do
		for j = 1, #tbl - i - 1 do
			if sorter(tbl[j], tbl[j + 1]) then
				tbl[j], tbl[j + 1] = tbl[j + 1], tbl[j]
			end
		end
	end
	
	return tbl
end

function GetSortedPlayers(ply)
	if ScoreBoard and ScoreBoard.ShouldSort then
		local ShouldSort = ScoreBoard.ShouldSort
		local sign = string.sub(ShouldSort, #ShouldSort)
		
		if string.find(ShouldSort, "^id[+-]$") then
			if sign == "+" then
				return sort(ply, function(a, b)
					return a:UserID() > b:UserID()
				end)
			else
				return sort(ply, function(a, b)
					return a:UserID() < b:UserID()
				end)
			end
		end
		
		if string.find(ShouldSort, "^name[+-]$") then
			if sign == "+" then
				return sort(ply, function(a, b)
					local aName = a:Name()
					local bName = b:Name()
					for i = 1, #aName > #bName and #aName or #bName do
						if i > #aName then
							return false
						end
						if i > #bName then
							return true
						end
						if string.byte(aName[i]) > string.byte(bName[i]) then
							return true
						end
						if string.byte(bName[i]) > string.byte(aName[i]) then
							return false
						end
					end
				end)
			else
				return sort(ply, function(a, b)
					local aName = a:Name()
					local bName = b:Name()
					for i = 1, #aName > #bName and #aName or #bName do
						if i > #aName then
							return true
						end
						if i > #bName then
							return false
						end
						if string.byte(aName[i]) < string.byte(bName[i]) then
							return true
						end
						if string.byte(bName[i]) < string.byte(aName[i]) then
							return false
						end
					end
				end)
			end
		end
		
		if string.find(ShouldSort, "^group[+-]$") then
			if sign == "+" then
				return sort(ply, function(a, b)
					local aGroup = a:GetUserGroup()
					local bGroup = b:GetUserGroup()
					
					local aGroupTbl = {}
					local bGroupTbl = {}
		
					for _, v in pairs(groups) do
						if v[1] == aGroup then
							aGroupTbl = v
						end
						
						if v[1] == bGroup then
							bGroupTbl = v
						end
					end
					
					if #aGroupTbl > 0 and #bGroupTbl > 0 then
						return aGroupTbl[2] > bGroupTbl[2]
					end
					
					return false
				end)
			else
				return sort(ply, function(a, b)
					local aGroup = a:GetUserGroup()
					local bGroup = b:GetUserGroup()
					
					
					local aGroupTbl = {}
					local bGroupTbl = {}
		
					for _, v in pairs(groups) do
						if v[1] == aGroup then
							aGroupTbl = v
						end
						
						if v[1] == bGroup then
							bGroupTbl = v
						end
					end
					
					if #aGroupTbl > 0 and #bGroupTbl > 0 then
						return aGroupTbl[2] < bGroupTbl[2]
					end
					
					return false
				end)
			end
		end
		
		if string.find(ShouldSort, "^score[+-]$") then
			if sign == "+" then
				return sort(ply, function(a, b)
					return a:Frags() > b:Frags()
				end)
			else
				return sort(ply, function(a, b)
					return a:Frags() < b:Frags()
				end)
			end
		end
		
		if string.find(ShouldSort, "^death[+-]$") then
			if sign == "+" then
				return sort(ply, function(a, b)
					return a:Deaths() > b:Deaths()
				end)
			else
				return sort(ply, function(a, b)
					return a:Deaths() < b:Deaths()
				end)
			end
		end
		
		if string.find(ShouldSort, "^ping[+-]$") then
			if sign == "+" then
				return sort(ply, function(a, b)
					return a:Ping() > b:Ping()
				end)
			else
				return sort(ply, function(a, b)
					return a:Ping() < b:Ping()
				end)
			end
		end
	end
end

local SCOREBOARD = {}

function SCOREBOARD:Init()
	local width = math.Clamp(1024, 0, ScrW())
	local height = math.Clamp(640, 0, ScrH())
	
	self:SetPos((ScrW() - width) / 2, (ScrH() - height) / 2)
	self:SetSize(width, height)
	self.ShouldSort = "id-"
	
	self.Scroller = self:Add("DScrollPanel")
	self.Scroller:SetSize(width + 15, height - 126)
	self.Scroller:SetPos(0, 126)
	
	self.TeamsContainer = self.Scroller:Add("DIconLayout")
	self.TeamsContainer:SetPos(0, 0)
	self.TeamsContainer:SetSize(width, height - 126)
	self.TeamsContainer:SetSpaceY(10)
	
	local margin = 0
	local function ScoreBoardAddButton(pr, name, text, isLast)
		local FullName = "SortBy" .. name
		local size = isLast and width - margin or math.Round(width * pr)
		
		self[FullName] = self:Add("DButton")
		self[FullName]:SetFont("ScoreBoardSort")
		self[FullName]:SetColor(Color(200, 200, 200))
		self[FullName]:SetPos(margin, 91)
		self[FullName]:SetSize(size, 30)
		self[FullName]:SetTooltip(GetText("SortBy"))
		
		margin = margin + size
		
		self[FullName].Think = function()
			if self.ShouldSort == name .. "+" then
				self[FullName]:SetText(text .. "   ▲")
			elseif self.ShouldSort == name .. "-" then
				self[FullName]:SetText(text .. "   ▼")
			else
				self[FullName]:SetText(text)
			end
		end
		
		self[FullName].Paint = function(pnl, w, h)
			local x, y = self[FullName]:GetPos()
			
			if self[FullName]:IsHovered() then
				surface.SetDrawColor(10, 10, 100, 230)
			else
				surface.SetDrawColor(50, 50, 90, 245)
			end
			
			surface.DrawRect(0, 0, w, h)
			
			surface.SetDrawColor(100, 100, 100, 200)
			surface.DrawRect(0, 0, w, 1)
			surface.DrawRect(0, 0, 1, h)
			surface.DrawRect(0, h - 1, w, 1)
			
			surface.DrawRect(w - 1, 0, 1, h)
		end
		
		self[FullName].DoClick = function()
			if string.find(self.ShouldSort, "^" .. name .. "[+-]$") then
				self.ShouldSort = string.EndsWith(self.ShouldSort, "+") and name .. "-" or name .. "+"
			else
				self.ShouldSort = name .. "-"
			end
			
			RefreshScoreBoard()
		end
	end
	
	ScoreBoardAddButton(0.1, "id", GetText("ID"), false)
	ScoreBoardAddButton(0.4, "name", GetText("Name"), false)
	ScoreBoardAddButton(0.2, "group", GetText("Group"), false)
	ScoreBoardAddButton(0.1, "score", GetText("Score"), false)
	ScoreBoardAddButton(0.1, "death", GetText("Deaths"), false)
	ScoreBoardAddButton(0, "ping", GetText("Ping"), true)
end

function SCOREBOARD:Paint(w, h)
	draw.RoundedBoxEx(16, 0, 0, w, 90, Color(40, 40, 100, 240), true, true)
	draw.RoundedBoxEx(8, 0, 121, w, h - 120, Color(30, 30, 30, 220), false, false, true, true)
	
	surface.SetDrawColor(Color(220, 220, 220))
	surface.DrawRect(0, 90, w, 2)
	
	local name = GetHostName()
	surface.SetTextColor(Color(255, 255, 255))
	surface.SetFont("ScoreBoardTitle")
	surface.SetTextPos(w / 2 - surface.GetTextSize(name) / 2, 20)
	surface.DrawText(name)
	
	local holiday = GetGlobalString("holiday")
	
	if holiday == "Halloween" then
		surface.SetDrawColor(255, 255, 255)
		surface.SetMaterial(Material("holidayimgs/halloween"))
		surface.DrawTexturedRect(w - 230, 10, 210, 70)
	end
end

vgui.Register("ScoreBoard", SCOREBOARD)

function GM:ScoreboardShow()
	if !IsValid(ScoreBoard) then
		ScoreBoard = vgui.Create("ScoreBoard")
	end
	
	if IsValid(ScoreBoard) then
		ScoreBoard:Show()
		RefreshScoreBoard()
		ScoreBoard:MakePopup()
		ScoreBoard:SetKeyboardInputEnabled(false)
	end
end

function GM:ScoreboardHide()
	if IsValid(ScoreBoard) then
		ScoreBoard:Hide()
		CloseDermaMenus()
	end
end

function GM:HUDDrawScoreBoard() end