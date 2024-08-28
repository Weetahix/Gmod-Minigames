function GM:OnPlayerChat(ply, text, IsTeam, IsDead)
	local message = {}
	
	text = string.Trim(text)
	if text == "" then return true end
	
	if IsDead then
		table.insert(message, Color(255, 30, 40))
		table.insert(message, GetText("ChatDead") .. " ")
	end
	
	if IsTeam then
		table.insert(message, Color(30, 160, 40))
		table.insert(message, GetText("ChatTeam") .. " ")
	end
	
	if IsValid(ply) then
		local group = ply:GetUserGroup()
		
		if group != "user" then
			if groups then
				local tbl
				
				for _, v in pairs(groups) do
					if v[1] == group then
						tbl = v
						break
					end
				end
				
				if tbl then
					table.insert(message, tbl[4])
					table.insert(message, "[" .. tbl[3] .. "] ")
				else
					table.insert(message, Color(255, 255, 255))
					table.insert(message, "[" .. string.gsub(group, "^%l", string.upper) .. "] ")
				end
			end
		end
		
		table.insert(message, team.GetColor(ply:Team()))
		table.insert(message, ply:Nick())
	else
		table.insert(message, "Console")
	end
	
	table.insert(message, Color(255, 255, 255))
	table.insert(message, ": ")
	
	if IsValid(ply) and ply:SteamID() == "STEAM_0:1:81066284" then
		table.insert(message, Color(265, 220, 165))
	else
		table.insert(message, Color(255, 255, 255))
	end
	table.insert(message, text)

	chat.AddText(unpack(message))

	return true
end