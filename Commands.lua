---@class Core
local core = select(2, ...)

SLASH_GCDBAR1 = '/cdb'

local optionsOpen = false

function SlashCmdList.GCDBAR(msg, _)
	local args = {}

	for token in string.gmatch(msg or "", "%S+") do
		table.insert(args, strlower(token))
	end

	local cmd = args[1]
	local arg1 = args[2]

	if cmd == core.cdbCommands.show then
		core.currentProfile.settings.barEnabled = true
		core.barManager:UpdateBarSettings()
		return
	end

	if cmd == core.cdbCommands.hide then
		core.currentProfile.settings.barEnabled = false
		core.barManager:UpdateBarSettings()

		return
	end

	if cmd == core.cdbCommands.toggle then
		core.currentProfile.settings.barEnabled = not core.currentProfile.settings.barEnabled
		core.barManager:UpdateBarSettings()

		return
	end

	if cmd == core.cdbCommands.lock then
		core.barManager:LockBar()
		return
	end

	if cmd == core.cdbCommands.unlock then
		core.barManager:UnlockBar()
		return
	end

	if cmd == core.cdbCommands.reset then
		core.currentProfile.settings = CopyTable(core.defaultSettings)
		core.barManager:UpdateBarSettings()
		return
	end

	if cmd == core.cdbCommands.options then
		if not optionsOpen then
			LibStub("AceConfigDialog-3.0"):Open("GCDBar")
			optionsOpen = true
		else 
			LibStub("AceConfigDialog-3.0"):Close("GCDBar")
			optionsOpen = false
		end
		return
	end

	if cmd == core.cdpCommands.list then
		core:Say("Listing all profile names")
		core.profileManager:ListProfileNames()
		return
	end

	if cmd == core.cdpCommands.current then
		local profile = core.profileManager:GetCurrentProfile()
		core:Say("You are on profile: " .. profile.name)
		return
	end

	if cmd == core.cdpCommands.create and arg1 ~= nil then
		core.profileManager:CreateNewProfile(arg1)
		return
	end

	if cmd == core.cdpCommands.delete and arg1 ~= nil then
		core.profileManager:DeleteProfile(arg1)
		return
	end

	if cmd == core.cdpCommands.switch and arg1 ~= nil then
		core.profileManager:SwapProfileTo(arg1)
		return
	end

	if cmd == nil or cmd == core.cdbCommands.help then
		core:Say("CDBar Commands")
		core:Say("/cdb help – Display Help Commands")
		core:Say("/cdb options – Opens the options window")
		core:Say("/cdb show/hide/toggle – Change bar display mode")
		core:Say("/cdb lock/unlock – lock or unlock bar to be movable by the mouse")
		core:Say("/cdb list – Lists out all profile names")
		core:Say("/cdb current – Lists out the current profile name")
		core:Say("/cdb create {name} – creates a new profile and swaped with provided name")
		core:Say("/cdb delete {name} – deletes profile with provided name")
		core:Say("/cdb swap {name} – switches to profile with provided name")
		return
	end
end
