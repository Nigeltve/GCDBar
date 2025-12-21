---@class ns
local ns = select(2, ...)

SLASH_GCDBAR1 = '/cdb'

local optionsOpen = false

function SlashCmdList.GCDBAR(msg, _)
	local args = {}

	for token in string.gmatch(msg or "", "%S+") do
		table.insert(args, strlower(token))
	end

	local cmd = args[1]
	local arg1 = args[2]

	if cmd == ns.cdbCommands.show then
		ns.currentProfile.settings.barEnabled = true
		ns:UpdateBarSettings()

		return
	end

	if cmd == ns.cdbCommands.hide then
		ns.currentProfile.settings.barEnabled = false
		ns:UpdateBarSettings()

		return
	end

	if cmd == ns.cdbCommands.toggle then
		ns.currentProfile.settings.barEnabled = not ns.currentProfile.settings.barEnabled
		ns:UpdateBarSettings()

		return
	end

	if cmd == ns.cdbCommands.lock then
		ns:LockBar()
		return
	end

	if cmd == ns.cdbCommands.unlock then
		ns:UnlockBar()
		return
	end

	if cmd == ns.cdbCommands.reset then
		ns.currentProfile.settings = CopyTable(ns.defaultSettings)
		ns:UpdateBarSettings()
		return
	end

	if cmd == ns.cdbCommands.options then
		if not optionsOpen then
			LibStub("AceConfigDialog-3.0"):Open("GCDBar")
			optionsOpen = true
		else 
			LibStub("AceConfigDialog-3.0"):Close("GCDBar")
			optionsOpen = false
		end
		return
	end

	if cmd == ns.cdpCommands.list then
		ns:Say("Listing all profile names")
		ns.profileManager:ListProfileNames()
		return
	end

	if cmd == ns.cdpCommands.current then
		local profile = ns.profileManager:GetCurrentProfile()
		ns:Say("You are on profile: " .. profile.name)
		return
	end

	if cmd == ns.cdpCommands.create and arg1 ~= nil then
		ns.profileManager:CreateNewProfile(arg1)
		return
	end

	if cmd == ns.cdpCommands.delete and arg1 ~= nil then
		ns.profileManager:DeleteProfile(arg1)
		return
	end

	if cmd == ns.cdpCommands.switch and arg1 ~= nil then
		ns.profileManager:SwapProfileTo(arg1)
		return
	end

	if cmd == nil or cmd == ns.cdbCommands.help then
		ns:Say("CDBar Commands")
		ns:Say("/cdb options – Opens the options window")
		ns:Say("/cdb show/hide/toggle – Change bar display mode")
		ns:Say("/cdb help – Display Help Commands")
		ns:Say("/cdb list – Lists out all profile names")
		ns:Say("/cdb current – Lists out the current profile name")
		ns:Say("/cdb create {name} – creates a new profile and swaped with provided name")
		ns:Say("/cdb delete {name} – deletes profile with provided name")
		ns:Say("/cdb swap {name} – switches to profile with provided name")
		return
	end
end
