---@class ns
local ns = select(2, ...)

SLASH_GCDBAR1 = '/cdb'

function SlashCmdList.GCDBAR(msg, _)
	local args = {}

	for token in string.gmatch(msg or "", "%S+") do
		table.insert(args, strlower(token))
	end

	local cmd = args[1]
	local arg1 = args[2]

	if cmd == ns.command.printdb then
		if(arg1 == nil) then
			ns:Log("Printing out barDb", ns.logTypes.DEBUG)
			ns:PrintTable(ns.barDb)

			return
		elseif arg1 == "default" then
			ns:Log("Printing out defaults", ns.logTypes.DEBUG)
			ns:PrintTable(ns.defaults)

			return
		end
	end

	if cmd == ns.command.debug then
		if arg1 == nil or arg1 == ns.command.toggle then
			ns.debug = not ns.debug
			ns:Say("toggling Debug Mode: ".. tostring(ns.debug))
			ns.logLevel = 3

			return
		end
	end

	if cmd == ns.command.loglevel then
		if arg1 == nil then
			ns:Say("log level is set to: " .. ns:logLevelConvert(ns.logLevel))
			return
		end

		if not type(arg1) == "number" then
			ns:Say("invalid arugment")
			return
		end

		ns:Say("log level change arg1: " .. tostring(arg1))

		return
	end

	if cmd == ns.command.show then
		ns.barDb.barEnabled = true
		ns:UpdateBarSettings(ns.barDb)

		return
	end

	if cmd == ns.command.hide then
		ns.barDb.barEnabled = false
		ns:UpdateBarSettings(ns.barDb)

		return
	end

	if cmd == ns.command.toggle then
		ns.barDb.barEnabled = not ns.barDb.barEnabled
		ns:UpdateBarSettings(ns.barDb)

		return
	end

	if cmd == ns.command.reset then
		ns.barDb = CopyTable(ns.defaults)
		ns:UpdateBarSettings(ns.barDb)

		return
	end

	if cmd == ns.command.help then
		ns:Say("Commands")
		ns:Say("/cdb show/hide/toggle - Change bar display mode")
		ns:Say("/cdb help – Display Help Commands")
		return
	end
end
