---@class ns
local ns = select(2, ...)

SLASH_GCDBAR1 = '/cdb'

function SlashCmdList.GCDBAR(msg, _)
	local args = {}

	for token in string.gmatch(msg or "", "%S+") do
		table.insert(args, strlower(token))
	end

	local cmd = args[1]

	if cmd == ns.command.show then
		ns.barDb.barEnabled = true
		ns:UpdateBarSettings()

		return
	end

	if cmd == ns.command.hide then
		ns.barDb.barEnabled = false
		ns:UpdateBarSettings()

		return
	end

	if cmd == ns.command.toggle then
		ns.barDb.barEnabled = not ns.barDb.barEnabled
		ns:UpdateBarSettings()

		return
	end

	if cmd == ns.command.reset then
		ns.barDb = CopyTable(ns.defaults)
		ns:UpdateBarSettings()

		return
	end
	
	if cmd == nil or cmd == ns.command.options then
		LibStub("AceConfigDialog-3.0"):Open("GCDBar")
		return
	end

	if cmd == ns.command.help then
		ns:Say("Commands")
		ns:Say("/cdb – Opens the options window")
		ns:Say("/cdb show/hide/toggle – Change bar display mode")
		ns:Say("/cdb help – Display Help Commands")
		return
	end
end
