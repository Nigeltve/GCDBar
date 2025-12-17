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
            ProfileDB = {
                default = ns.defaultProfile
            }
        end

        ns.profileManager.profiles = ProfileDB
            
        if ProfileName == nil or ProfileName == "" then
            ProfileName = ProfileDB.default.name
        end
        
        ns.currentProfile = ns.profileManager.profiles[ProfileName]
        ns:UpdateBarSettings()
    elseif event == ns.eventNames.PLAYER_LOGOUT or event == ns.eventNames.PLAYER_LEAVING_WORLD then
        ProfileName = ns.currentProfile.name
        ns:SaveCurrentProfile()
        ProfileDB = ns.profileManager.profiles
    end
end

local loginFrame = CreateFrame("Frame", nil, UIParent)
loginFrame:RegisterEvent(ns.eventNames.ADDON_LOADED)
loginFrame:RegisterEvent(ns.eventNames.PLAYER_LOGOUT)
loginFrame:RegisterEvent(ns.eventNames.PLAYER_LEAVING_WORLD)
loginFrame:SetScript("OnEvent", HandleDB)