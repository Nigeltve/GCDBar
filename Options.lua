---@class ns
local ns = select(2, ...)

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

local function SetColor(info, red, green, blue, alpha)
    local argType = info[#info]
    local newColor = {r=red, g=green, b=blue, a=alpha}
    if argType ==  "forgroundColor" then
        ns.barDb.barColor = newColor
        ns:UpdateBarSettings(ns.barDb)
    elseif argType == "backgroundColor" then
        ns.barDb.bgColor = newColor
        ns:UpdateBarSettings(ns.barDb)
    elseif argType == "outlineColor" then
        ns.barDb.outlineColor = newColor
        ns:UpdateBarSettings(ns.barDb)
    end
end

local function GetColor(info)
    local argType = info[#info]
    local color = { r = 1, g = 1, b = 1 , a = 1} -- default color

    if argType ==  "forgroundColor" then
        color = ns.barDb.barColor
    elseif argType == "backgroundColor" then
        color = ns.barDb.bgColor
     elseif argType == "outlineColor" then
        color = ns.barDb.outlineColor
    end

    return color.r, color.g, color.b, color.a
end


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
        generalPad = {
            type  = "description",
            name  = "---------------------------------------------------------",
            order = 2,
        },
        generalWarning = {
            type  = "description",
            name  = "Still under development, things might be broken",
            order = 3,
        },
        generalPad2 = {
            type  = "description",
            name  = "---------------------------------------------------------",
            order = 4,
        },
        appearance = {
            type   = "group",
            name   = "Appearance",
            inline = true,
            order  = 10,
            args   = {
                forgroundTextureKey = {
                    type   = "select",
                    name   = "Forground Texture",
                    values = ns.barTextures,
                    order  = 10,
                    width  = "full",
                },
                forgroundColor = {
                    type   = "color",
                    name   = "Forground Color",
                    hasAlpha = true,
                    set = SetColor,
                    get = GetColor,
                    order  = 11,
                    width  = "full",
                },
                backgroundTextureKey = {
                    type   = "select",
                    name   = "Background Texture",
                    values = ns.barTextures,
                    order  = 12,
                    width  = "full",
                },
                backgroundColor = {
                    type   = "color",
                    name   = "Background Color",
                    hasAlpha = true,
                    set = SetColor,
                    get = GetColor,
                    order  = 13,
                    width  = "full",
                },

                outlineTextureKey = {
                    type   = "select",
                    name   = "Outline Texture",
                    values = ns.outlinetextures,
                    order  = 14,
                    width  = "full",
                },
                outlineColor = {
                    type   = "color",
                    name   = "Outline Color",
                    hasAlpha = true,
                    set = SetColor,
                    get = GetColor,
                    order  = 15,
                    width  = "full",
                },
                offsetX = {
                    type  = "range",
                    name  = "Horizontal Offset",
                    min   = -2000,
                    max   = 2000,
                    step  = 1,
                    order = 16,
                    width = "full",
                },
                offsetY = {
                    type  = "range",
                    name  = "Vertical Offset",
                    min   = -2000,
                    max   = 2000,
                    step  = 1,
                    order = 17,
                    width = "full",
                },
            }
        }
    },
}

local AceConfig       = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

AceConfig:RegisterOptionsTable("GCDBar", options)
local panel = AceConfigDialog:AddToBlizOptions("GCDBar", "GCD Bar")

local function AddSub(name, path)
    return AceConfigDialog:AddToBlizOptions("GCDBar", name, "GCD Bar", path)
end

AddSub("Appearance", "appearance")
