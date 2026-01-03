---@type Core
local core = select(2, ...)

core.utils = {
	IsMidNight = function()
		local toc = tostring(select(4, GetBuildInfo()))
		return string.find(toc, "12") ~= nil
	end,

	ReadSpellCooldown = function(self, spellId)
		if not (C_Spell and C_Spell.GetSpellCooldown) then return -1, -1, -1 end

		local info = C_Spell.GetSpellCooldown(spellId)
		return info.startTime, info.duration, info.modRate
	end,

	UpdateOptions = function(self)
		local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
		AceConfigRegistry:NotifyChange("GCDBar")
	end
}
