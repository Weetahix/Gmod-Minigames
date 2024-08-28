ENT.Type = "brush"

function ENT:Initialize()
	self:SetTrigger( true )
end

function ENT:Think()
end

function ENT:StartTouch(ent)
	local cur = GetRoundState()
	if ent:IsPlayer() and cur != ROUND_WAITING then
		ent.CanBuy = self
		ent:SendLua("CanBuy="..self:EntIndex())
	end
	if #player.GetAll() == 1 then
		ent.CanBuy = nil
		ent:SendLua("CanBuy=nil")
	end
end

function ENT:EndTouch(ent)
	if ent.CanBuy == self then
		ent.CanBuy = nil
		ent:SendLua("CanBuy=nil")
	end
end

function ENT:Touch(ent)
	local cur = GetRoundState()
	if cur == ROUND_ENDING then
		ent.CanBuy = nil
		ent:SendLua("CanBuy=nil")
	end
end