---@type Core
local core = select(2, ...)

---@type Profile[]?
ProfileDB = ProfileDB

---@type string?
ProfileName = ProfileName

---@param event string
---@param args1 string
local function HandleEvents(_, event, args1)
	if event == core.enums.events.ADDON_LOADED and args1 == "GCDBar" then
		if ProfileDB == nil or next(ProfileDB) == nil then
			core.profileManager:Setup({})
		else
			core.profileManager:Setup(ProfileDB)
		end

		if ProfileName == nil or ProfileName == "" then
			ProfileName = core.profileManager.defaultProfile.name
		end

		if core.profileManager.profiles[ProfileName] == nil then
			ProfileName = core.profileManager.defaultProfile.name
		end

		core.profileManager.currentProfile = core.profileManager.profiles[ProfileName]
		core.barManager:Create()
	elseif event == core.enums.events.PLAYER_LOGOUT or event == core.enums.events.PLAYER_LEAVING_WORLD then
		core.profileManager:SaveProfile()
		ProfileName = core.profileManager.currentProfile.name
		ProfileDB = core.profileManager.profiles
	elseif event == core.enums.events.SPELLCAST_START or event == core.enums.events.SPELLCAST_SUCCEEDED then
		core.barManager:StartAnimation()
	end
end

local initFrame = CreateFrame("Frame", nil, UIParent)
initFrame:RegisterEvent(core.enums.events.ADDON_LOADED)
initFrame:RegisterEvent(core.enums.events.SPELLCAST_START)
initFrame:RegisterEvent(core.enums.events.SPELLCAST_SUCCEEDED)
initFrame:RegisterEvent(core.enums.events.PLAYER_LOGOUT)
initFrame:RegisterEvent(core.enums.events.PLAYER_LEAVING_WORLD)
initFrame:SetScript("OnEvent", HandleEvents)
