local _, ns = ...

ns.barDb = nil

local function HandleDB(self, event, args1)
	if event == ns.eventNames.ADDON_LOADED and args1 == "GCDBar" then
        if BarDB == nil or next(BarDB) == nil then
            BarDB = CopyTable(ns.defaults)
        end

        ns.barDb = BarDB
    end
end

local loginFrame = CreateFrame("Frame", nil, UIParent)
loginFrame:RegisterEvent(ns.eventNames.ADDON_LOADED)
loginFrame:SetScript("OnEvent", HandleDB)