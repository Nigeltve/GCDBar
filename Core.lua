local addonName, ns = ...

local gcdbar = CreateFrame("Frame", nil, UIParent)
gcdbar:SetFrameStrata(ns.STRATA.LOW)
gcdbar:SetPoint("CENTER")
gcdbar:SetSize(64, 64)

gcdbar:RegisterEvent(ns.EVENT_NAMES.PLAYER_LOGIN)
gcdbar:RegisterEvent(ns.EVENT_NAMES.PLAYER_ENTERING_WORLD)
gcdbar:RegisterEvent(ns.EVENT_NAMES.SPELL_CD_UPDATE)
gcdbar:RegisterEvent(ns.EVENT_NAMES.ACTIONBAR_CD_UPDATE)
gcdbar:RegisterEvent(ns.EVENT_NAMES.SPELLCAST_SENT)
gcdbar:RegisterUnitEvent(ns.EVENT_NAMES.SPELLCAST_SUCCEEDED, ns.UNITS.PLAYER)

local tex = gcdbar:CreateTexture(nil, "ARTWORK")
tex:SetAllPoints()
tex:SetTexture(ns.TEXTURES.test)

local function HandleEvent(self, event, unit, arg3, spellID)
    if event == ns.EVENT_NAMES.PLAYER_LOGIN then
        ns.Log("Information")
        ns.Log("Debug" , ns.LOG_TYPES.DEBUG)
        ns.Log("Warning" , ns.LOG_TYPES.WARNING)
        ns.Log("Error", ns.LOG_TYPES.ERROR)
    end

    -- CursorRingDB     = CursorRingDB     or CopyTable(ns.defaults)
    -- CursorRingCharDB = CursorRingCharDB or CopyTable(ns.charDefaults)
end

gcdbar:SetScript("OnEvent", HandleEvent)
