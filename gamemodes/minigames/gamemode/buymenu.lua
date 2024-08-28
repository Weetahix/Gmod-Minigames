	util.AddNetworkString("buymenu")
function GM:ShowSpare2(ply, pl)
	local cur = GetRoundState()
	net.Start("buymenu")
	net.Send(ply, pl, cur)
	end
	
	util.AddNetworkString("GiveGlock")
net.Receive("GiveGlock", function(len, ply)
	ply:Give("weapon_glock")
	end)
	
	util.AddNetworkString("GiveUsp")
net.Receive("GiveUsp", function(len, ply)
	ply:Give("weapon_usp")
	end)
	
	util.AddNetworkString("GiveP228")
net.Receive("GiveP228", function(len, ply)
	ply:Give("weapon_p228")
	end)

	util.AddNetworkString("GiveDualElites")
net.Receive("GiveDualElites", function(len, ply)
	ply:Give("weapon_elite")
	end)
	
	util.AddNetworkString("GiveFiveSeven")
net.Receive("GiveFiveSeven", function(len, ply)
	ply:Give("weapon_fiveseven")
	end)
	
	util.AddNetworkString("GiveDeagle")
net.Receive("GiveDeagle", function(len, ply)
	ply:Give("weapon_deagle")
	end)
	
	util.AddNetworkString("GiveM3")
net.Receive("GiveM3", function(len, ply)
	ply:Give("weapon_m3")
	end)
	
	util.AddNetworkString("GiveXM1014")
net.Receive("GiveXM1014", function(len, ply)
	ply:Give("weapon_xm1014")
	end)
	
	util.AddNetworkString("GiveM249")
net.Receive("GiveM249", function(len, ply)
	ply:Give("weapon_m249")
	end)
	
	util.AddNetworkString("GiveMAC10")
net.Receive("GiveMAC10", function(len, ply)
	ply:Give("weapon_mac10")
	end)
	
	util.AddNetworkString("GiveTMP")
net.Receive("GiveTMP", function(len, ply)
	ply:Give("weapon_tmp")
	end)
	
	util.AddNetworkString("GiveMP5")
net.Receive("GiveMP5", function(len, ply)
	ply:Give("weapon_mp5navy")
	end)
	
	util.AddNetworkString("GiveUMP45")
net.Receive("GiveUMP45", function(len, ply)
	ply:Give("weapon_ump45")
	end)
	
	util.AddNetworkString("GiveP90")
net.Receive("GiveP90", function(len, ply)
	ply:Give("weapon_p90")
	end)
	
	util.AddNetworkString("GiveGalil")
net.Receive("GiveGalil", function(len, ply)
	ply:Give("weapon_galil")
	end)
	
	util.AddNetworkString("GiveFamas")
net.Receive("GiveFamas", function(len, ply)
	ply:Give("weapon_famas")
	end)
	
	util.AddNetworkString("GiveScout")
net.Receive("GiveScout", function(len, ply)
	ply:Give("weapon_scout")
	end)
	
	util.AddNetworkString("GiveAk")
net.Receive("GiveAk", function(len, ply)
	ply:Give("weapon_ak47")
	end)
	
	util.AddNetworkString("GiveM4")
net.Receive("GiveM4", function(len, ply)
	ply:Give("weapon_m4a1")
	end)
	
	util.AddNetworkString("GiveSG552")
net.Receive("GiveSG552", function(len, ply)
	ply:Give("weapon_sg552")
	end)
	
	util.AddNetworkString("GiveAUG")
net.Receive("GiveAUG", function(len, ply)
	ply:Give("weapon_aug")
	end)
	
	
	util.AddNetworkString("GiveAWP")
net.Receive("GiveAWP", function(len, ply)
	ply:Give("weapon_awp")
	end)
	
	util.AddNetworkString("GiveG3SG1")
net.Receive("GiveG3SG1", function(len, ply)
	ply:Give("weapon_g3sg1")
	end)
	
	util.AddNetworkString("GiveSG550")
net.Receive("GiveSG550", function(len, ply)
	ply:Give("weapon_sg550")
	end)
	
	util.AddNetworkString("GiveFlash")
net.Receive("GiveFlash", function(len, ply)
	ply:Give("weapon_flashbang")
	end)
	
	util.AddNetworkString("GiveHE")
net.Receive("GiveHE", function(len, ply)
	ply:Give("weapon_hegrenade")
	end)
	
	util.AddNetworkString("GiveSmoke")
net.Receive("GiveSmoke", function(len, ply)
	ply:Give("weapon_smokegrenade")
	end)
	
	util.AddNetworkString("GiveArmor")
net.Receive("GiveArmor", function(len, ply)
	if ply:Armor() == 0 then
		 ply:SetArmor( 255 )
	end
	end)