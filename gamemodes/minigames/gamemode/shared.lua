GM.Name = "Minigames"
GM.Author = "СПУДИ МУН"

ROUND_WAITING = 0
ROUND_PREPARING = 1
ROUND_FREEZE = 2
ROUND_ACTIVE = 3
ROUND_ENDING = 4

local meta = FindMetaTable("Player")
meta.alive = meta.alive or meta.Alive

function meta:Alive()
	if self:Team() == TEAM_SPECTATORS then return false	end
	
	return self:alive()
end

function GetRoundState()
	return GetGlobalInt("RoundPhase")
end

function GetRoundTime()
	return math.Round(math.max(GetGlobalInt("RoundTime") - CurTime(), 0 ))
end

function GM:CreateTeams()
	TEAM_SPECTATORS = 1
	TEAM_RED = 2
	TEAM_BLUE = 3

	team.SetUp(TEAM_SPECTATORS, "Spectators", Color(100, 100, 100))
	team.SetUp(TEAM_RED, "Red", Color(200, 0, 0))
	team.SetUp(TEAM_BLUE, "Blue", Color(0, 0, 200))
end

function GM:PlayerUse(ply)
	return ply:Alive()
end