local addonName, ns = ...

local DEBUG = true

local f = CreateFrame("Frame")
f:RegisterEvent("PLAYER_LOGIN")
f:RegisterEvent("PLAYER_ENTERING_WORLD")
f:RegisterEvent("SPELL_UPDATE_COOLDOWN")
f:RegisterEvent("ACTIONBAR_UPDATE_COOLDOWN")
f:RegisterUnitEvent("UNIT_SPELLCAST_SUCCEEDED", "player")

local function DebugLog(msg)
    if(not DEBUG) then
        return
    end
    print(msg)
end

local function HandleEvent(self, event, unit, arg3, spellID)
    if event == "PLAYER_LOGIN" then 
    end
    
    -- CursorRingDB     = CursorRingDB     or CopyTable(ns.defaults)
    -- CursorRingCharDB = CursorRingCharDB or CopyTable(ns.charDefaults)
end

f:SetScript("OnEvent", HandleEvent)


