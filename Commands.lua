---@type Core
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

	if cmd == core.enums.commands.show then
		core.profileManager.currentProfile.settings.barEnabled = true
		core.barManager:UpdateSettings(core.profileManager.currentProfile.settings)
		return
	end

	if cmd == core.enums.commands.hide then
		core.profileManager.currentProfile.settings.barEnabled = false
		core.barManager:UpdateSettings(core.profileManager.currentProfile.settings)

		return
	end

	if cmd == core.enums.commands.toggle then
		core.profileManager.currentProfile.settings.barEnabled = not core.profileManager.currentProfile.settings
			.barEnabled
		core.barManager:UpdateSettings(core.profileManager.currentProfile.settings)

		return
	end

	if cmd == core.enums.commands.lock then
		core.barManager:LockBar()

		return
	end

	if cmd == core.enums.commands.unlock then
		core.barManager:UnlockBar()

		return
	end

	if cmd == core.enums.commands.reset then
		core.profileManager:ResetCurrentProfile()
		return
	end

	if cmd == core.enums.commands.options then
		if not optionsOpen then
			LibStub("AceConfigDialog-3.0"):Open("GCDBar")
			optionsOpen = true
		else
			LibStub("AceConfigDialog-3.0"):Close("GCDBar")
			optionsOpen = false
		end
		return
	end

	if cmd == core.enums.commands.list then
		core.logger:Say("Listing all profile names")
		core.profileManager:PrintProfileNames()
		return
	end

	if cmd == core.enums.commands.current then
		local profile = core.profileManager:GetCurrentProfile()
		core.logger:Say("You are on profile: " .. profile.name)
		return
	end

	if cmd == core.enums.commands.create and arg1 ~= nil then
		core.profileManager:CreateProfile(arg1)
		return
	end

	if cmd == core.enums.commands.delete and arg1 ~= nil then
		core.profileManager:DeleteProfile(arg1)
		return
	end

	if cmd == core.enums.commands.switch and arg1 ~= nil then
		core.profileManager:SwapToProfile(arg1)
		return
	end

	if cmd == core.enums.commands.clearAll then
		core.profileManager:ClearAllProfiles()
		return
	end

	if cmd == nil or cmd == core.enums.commands.help then
		core.logger:Say("CDBar Commands")
		core.logger:Say("/cdb help – Display Help Commands")
		core.logger:Say("/cdb options – Opens the options window")
		core.logger:Say("/cdb show/hide/toggle – Change bar display mode")
		core.logger:Say("/cdb lock/unlock – lock or unlock bar to be movable by the mouse")
		core.logger:Say("/cdb list – Lists out all profile names")
		core.logger:Say("/cdb current – Lists out the current profile name")
		core.logger:Say("/cdb create {name} – creates a new profile and swaped with provided name")
		core.logger:Say("/cdb delete {name} – deletes profile with provided name")
		core.logger:Say("/cdb swap {name} – switches to profile with provided name")
		core.logger:Say("/cdb reset – Resets the current profile")
		core.logger:Say("/cdb clearAll – Removed All profiles and resets the default to its default state")
		return
	end
end
