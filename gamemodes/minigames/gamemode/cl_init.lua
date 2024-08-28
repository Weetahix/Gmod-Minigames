include("cl_buymenu.lua")
include("cl_languages.lua")
include("shared.lua")
include("cl_menu.lua")
include("cl_hud.lua")
include("cl_scoreboard.lua")
include("cl_rtv.lua")
include("cl_editor.lua")
include("cl_chat.lua")
include("cl_acts.lua")


function GetText(key)
	if !LANGUAGES then return "" end
	
	if !CurLang then
		CurLang = "en"
	end
	
	if !LANGUAGES[CurLang] then
		local keys = table.GetKeys(LANGUAGES)
		
		if #keys == 0 then
			return ""
		end
		
		CurLang = table.Random(keys)
	end
	
	if LANGUAGES[CurLang] then
		if LANGUAGES[CurLang] and LANGUAGES[CurLang][key] then
			return LANGUAGES[CurLang][key]
		end
	end
	
	return ""
end





function SetLanguage(lang)
	if !LANGUAGES[lang] then return end
	
	LocalPlayer():SetPData("mg_language", lang)
	CurLang = lang
	
	Teams = {}
	Teams[2] = {GetText("Red"), Color(200, 0, 0)}
	Teams[3] = {GetText("Blue"), Color(0, 0, 200)}
	Teams[1] = {GetText("Spectators"), Color(120, 120, 120)}
	
	if IsValid(ScoreBoard) then
		ScoreBoard:Remove()
	end
	
	if IsValid(editor) then
		editor:Remove()
	end
	
	if IsValid(PlyMenu) then
		local IsVisible = PlyMenu:IsVisible()
		
		PlyMenu:Remove()
		
		if IsVisible then
			PlyMenu = vgui.Create("PlyMenu")
		end
	end
end

function GM:InitPostEntity()
	local lp = LocalPlayer()
	
	SetLanguage(lp:GetPData("mg_language", "en"))
	
	avatar = vgui.Create("AvatarImage")
	avatar:SetPos(30, ScrH() - 120)
	avatar:SetSize(48, 48)
	avatar:SetPlayer(lp, 48)
	
	avatar._player = lp
	
	local holiday = GetGlobalString("holiday")
	
	if holiday == "NewYear" then
		local pnl = vgui.Create("DPanel")
		
		local x, y = avatar:GetPos()
		
		pnl:SetPos(x - 28, y - 40)
		pnl:SetSize(80, 60)
		
		pnl.Paint = function(_, w, h)
			if IsValid(avatar) and avatar:IsVisible() then
				surface.SetDrawColor(255, 255, 255)
				surface.SetMaterial(Material("holidayimgs/cap"))
				surface.DrawTexturedRect(0, 0, w, h)
			end
		end
	end
	
	if tobool(LocalPlayer():GetPData("mg_DisableVoiceChat", false)) then
		net.Start("DisableVoiceChat")
			net.WriteBool(true)
		net.SendToServer()
	end
	
	PreventMusic = tobool(LocalPlayer():GetPData("mg_PreventMusic", nil))
	
	timer.Create("RandomMessages", 600, 0, function()
		local str = table.Random(GetText("RandomMessages") or {})
		chat.AddText(Color(255, 255, 255), str)
	end)
end

function GM:PlayerBindPress(ply, bind, pressed)
	if bind == "+menu" then
		RunConsoleCommand("dropweapon")
	end
	
	if string.find(bind, "gm_showhelp") then
		if !IsValid(PlyMenu) then
			PlyMenu = vgui.Create("PlyMenu")
		end
		
		if !PlyMenu:IsVisible() then
			PlyMenu:Show()
		end
	end
end



function GM:HUDDrawTargetID() end

function GM:ChatText(index, name, text, filter)
	if filter == "joinleave" then
		return true
	end
end

function GM:PreventMusic()
	if PreventMusic then
		RunConsoleCommand("stopsound")
	end
end

function GM:EntityEmitSound(data)
	if string.EndsWith(data.SoundName, ".mp3") then
		return false
	end
end

local Deaths = {}

function GM:AddDeathNotice(Attacker, team1, Inflictor, Victim, team2, IsHead)
	local Death = {}
	
	Death.time		= CurTime()

	Death.left		= Attacker
	Death.right		= Victim
	Death.icon		= Inflictor
	Death.IsHead	= IsHead

	if team1 == -1 then
		Death.color1 = Color(250, 50, 50)
	else
		Death.color1 = team.GetColor(team1)
	end
	
	if team2 == -1 then
		Death.color2 = Color(250, 50, 50)
	else
		Death.color2 = team.GetColor(team2)
	end
	
	if Death.left == Death.right then
		Death.left = nil
		Death.icon = "suicide"
	end
	
	table.insert(Deaths, Death)
end

local function DrawDeath(x, y, death, hud_deathnotice_time)
	local w, h = killicon.GetSize(death.icon)
	
	if !w or !h then return end
	
	local fadeout = death.time + hud_deathnotice_time - CurTime()
	
	local alpha = math.Clamp(fadeout * 255, 0, 255)
	death.color1.a = alpha
	death.color2.a = alpha
	
	killicon.Draw(x, y, death.icon, alpha)
	
	local hw = 0
	
	if death.IsHead then
		hw = killicon.GetSize("headshot")
		
		killicon.Draw(x + hw + 8, y, "headshot", alpha)
	end
	
	if death.left then
		draw.SimpleText(death.left, "ChatFont", x - w / 2 - 16, y, death.color1, TEXT_ALIGN_RIGHT)
	end
	
	draw.SimpleText(death.right, "ChatFont", x + w / 2 + hw + 16, y, death.color2, TEXT_ALIGN_LEFT)
	
	return y + h * 0.70
end

function GM:DrawDeathNotice(x, y)
	if GetConVarNumber("cl_drawhud") == 0 then return end

	local hud_deathnotice_time = 6

	x = x * ScrW()
	y = y * ScrH()
	
	for k, Death in pairs(Deaths) do
		if Death.time + hud_deathnotice_time > CurTime() then
			if Death.lerp then
				x = x * 0.3 + Death.lerp.x * 0.7
				y = y * 0.3 + Death.lerp.y * 0.7
			end
			
			Death.lerp = Death.lerp or {}
			Death.lerp.x = x
			Death.lerp.y = y
			
			y = DrawDeath(x, y, Death, hud_deathnotice_time)
		end
	end
	
	for k, Death in pairs(Deaths) do
		if Death.time + hud_deathnotice_time > CurTime() then
			return
		end
	end
	
	Deaths = {}
end

function GM:RenderScreenspaceEffects()
	if FlashEndTime then
		if FlashEndTime > CurTime() then
			local alpha = (FlashEndTime - CurTime()) / 4
			
			DrawMotionBlur(0.2, alpha, 0.05);
		elseif FlashEndTime + 0.3 > CurTime() then
			DrawMotionBlur(0.2, 0.1, 0.05);
		end
	end
end

net.Receive("SendNotification", function()
	local str = net.ReadString()
	local args = net.ReadTable()
	
	if LANGUAGES and CurLang then
		notification.AddLegacy(string.format(GetText(str), unpack(args)), 0, 5)
	end
end)

net.Receive("SendGroups", function()
	groups = net.ReadTable()
end)

net.Receive("PlayerKilledByPlayer", function()
	local victim	= net.ReadEntity()
	local inflictor	= net.ReadString()
	local attacker	= net.ReadEntity()
	local IsHead	= net.ReadBool()

	if !IsValid(attacker) then return end
	if !IsValid(victim) then return end
	
	GAMEMODE:AddDeathNotice(attacker:Name(), attacker:Team(), inflictor, victim:Name(), victim:Team(), IsHead)
end)

net.Receive("SendMessage", function()
	local str = net.ReadString()
	
	if LANGUAGES and CurLang then
		chat.AddText(Color(255, 0, 0), string.format(GetText("EditNotification"), str))
	end
end)
