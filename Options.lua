-- Cursor Ring - Options
local addonName, ns = ...

-- Suppress the 12.0 beta SetText(alpha) range error from AceConfig/Settings,
do
    local oldHandler = geterrorhandler()

    seterrorhandler(function(msg)
        if type(msg) == "string" and msg:find("Usage: self:SetText(text [, color, alpha, wrap])", 1, true) then
            -- Swallow only this known harmless error (AceConfig dropdown hover in 12.0)
            return
        end

        -- Everything else goes to the normal error handler
        return oldHandler(msg)
    end)
end

-- ---------------------------------------------------------------------------
-- Patch AceGUI widget SetText to clamp bad alpha values
-- ---------------------------------------------------------------------------
do
    local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
    if AceGUI and AceGUI.WidgetRegistry and not ns._aceSetTextPatched then
        for _, widget in pairs(AceGUI.WidgetRegistry) do
            if type(widget) == "table" and type(widget.SetText) == "function" then
                local orig = widget.SetText
                widget.SetText = function(self, text, r, g, b, a, wrap, ...)
                    if type(a) ~= "number" or a ~= a or a < -3.402823e+38 or a > 3.402823e+38 then
                        a = 1
                    end
                    return orig(self, text, r, g, b, a, wrap, ...)
                end
            end
        end
        ns._aceSetTextPatched = true
    end
end

-- ---------------------------------------------------------------------------
-- Libs
-- ---------------------------------------------------------------------------
local AceConfig       = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

-- --------------------------------------------------
-- AceConfig options table
-- --------------------------------------------------
local options = {
    type = "group",
    name = "GCD Bar",
    args = {
        header = {
            type  = "header",
            name  = "GCD Bar",
            order = 0,
        },
        desc = {
            type  = "description",
            name  = "Shows GCD using Blizzard's Cooldown widget.",
            order = 1,
        },       
    },
}

AceConfig:RegisterOptionsTable("GCDBar", options)
local panel = AceConfigDialog:AddToBlizOptions("GCDBar", "GCD Bar")

