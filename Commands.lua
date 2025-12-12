local addonName, ns = ...

SLASH_GCDBAR1 = '/cdb'

local function Say(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00GCDBar:|r " .. tostring(msg))
end

function SlashCmdList.GCDBAR(msg, editbox)
	local args = {}

	for token in string.gmatch(msg or "", "%S+") do
		table.insert(args, strlower(token))
	end

	local cmd = args[1]
	local arg2 = args[2]

	if cmd == ns.command.enable then
		BarDB.barEnabled = true
		ns.UpdateBarSettings(BarDB)
	end

	if cmd == ns.command.disable then
		BarDB.barEnabled = false
		ns.UpdateBarSettings(BarDB)
	end

	if cmd == ns.command.toggle then
		BarDB.barEnabled = not BarDB.barEnabled
		ns.UpdateBarSettings(BarDB)
	end

	if cmd == ns.command.reset then
		BarDB = CopyTable(ns.defaults)
		ns.UpdateBarSettings(BarDB)
	end

	if cmd == ns.command.help then
		Say("Commands")
		Say("/cdb show/hide/toggle - Change bar display mode")
		Say("/cdb reset – resets settings to default (character only)")
		Say("/cdb help – Display Help Commands")
		

	end
end
