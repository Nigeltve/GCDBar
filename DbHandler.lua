---@class Core
local core = select(2, ...)
core.toc  = tostring(select(4, GetBuildInfo()))

---@class Profile
core.currentProfile = nil

---@param event string
---@param args1 string
local function HandleDB(self, event, args1)
    
	if event == core.eventNames.ADDON_LOADED and args1 == "GCDBar" then
        if ProfileDB == nil or next(ProfileDB) == nil then
            core:Say("Setting up defaults")
            core:Dump(core.profileManager)
            ProfileDB = core.profileManager.profiles
        end

        core.profileManager.profiles = ProfileDB
            
        if ProfileName == nil or ProfileName == "" then
            ProfileName = ProfileDB.default.name
        end
        
        if core.profileManager.profiles[ProfileName] == nil then
             ProfileName = ProfileDB.default.name
        end

        core.currentProfile = core.profileManager.profiles[ProfileName]
    elseif event == core.eventNames.PLAYER_LOGOUT or event == core.eventNames.PLAYER_LEAVING_WORLD then
        core.profileManager:SaveCurrentProfile()
        ProfileName = core.currentProfile.name
        ProfileDB = core.profileManager.profiles
    end
end

local initFrame = CreateFrame("Frame", nil, UIParent)
initFrame:RegisterEvent(core.eventNames.ADDON_LOADED)
initFrame:RegisterEvent(core.eventNames.PLAYER_LOGOUT)
initFrame:RegisterEvent(core.eventNames.PLAYER_LEAVING_WORLD)
initFrame:SetScript("OnEvent", HandleDB)