---@class ns
local ns = select(2, ...)
ns.toc  = tostring(select(4, GetBuildInfo()))

---@class Profile
ns.currentProfile = nil

---@param event string
---@param args1 string
local function HandleDB(self, event, args1)
    
	if event == ns.eventNames.ADDON_LOADED and args1 == "GCDBar" then
        if ProfileDB == nil or next(ProfileDB) == nil then
            ns:Say("Setting up defaults")
            ns:Dump(ns.profileManager)
            ProfileDB = ns.profileManager.profiles
        end

        ns.profileManager.profiles = ProfileDB
            
        if ProfileName == nil or ProfileName == "" then
            ProfileName = ProfileDB.default.name
        end
        
        if ns.profileManager.profiles[ProfileName] == nil then
             ProfileName = ProfileDB.default.name
        end

        ns.currentProfile = ns.profileManager.profiles[ProfileName]
    elseif event == ns.eventNames.PLAYER_LOGOUT or event == ns.eventNames.PLAYER_LEAVING_WORLD then
        ns.profileManager:SaveCurrentProfile()
        ProfileName = ns.currentProfile.name
        ProfileDB = ns.profileManager.profiles
    end
end

local loginFrame = CreateFrame("Frame", nil, UIParent)
loginFrame:RegisterEvent(ns.eventNames.ADDON_LOADED)
loginFrame:RegisterEvent(ns.eventNames.PLAYER_LOGOUT)
loginFrame:RegisterEvent(ns.eventNames.PLAYER_LEAVING_WORLD)
loginFrame:SetScript("OnEvent", HandleDB)