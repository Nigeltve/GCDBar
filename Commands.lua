local addonName, ns = ...



local loginFrame = CreateFrame("Frame", nil, UIParent)
loginFrame:RegisterEvent(ns.eventNames.ADDON_LOADED)
loginFrame:SetScript("OnEvent", ns.HandleDB)

