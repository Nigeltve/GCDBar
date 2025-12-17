---@class ns
local ns = select(2, ...)

local minBarDim = 5
local maxBardim = 2000

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

-- Drop Down --

local function Setter (info, val) 
    local argType = info[#info]
    ns.currentProfile.settings[argType] = val
    ns:UpdateBarSettings()
end

local function Getter(info)
    local argType = info[#info]
    return ns.currentProfile.settings[argType]
end

-- Color --
local function SetColor(info, red, green, blue, alpha)
    local argType = info[#info]
    local newColor = {r=red, g=green, b=blue, a=alpha}
    ns.currentProfile.settings[argType] = newColor
    ns:UpdateBarSettings()
end

local function GetColor(info)
    local argType = info[#info]
    local color =  ns.currentProfile.settings[argType] or { r = 1, g = 1, b = 1 , a = 1}
    return color.r, color.g, color.b, color.a
end

local function IsboarderDisabled(info)
    local argType = info[#info]
    if argType == "boarderSize" or argType == "boarderColor" then
        return not ns.currentProfile.settings.boarderEnabled
    end
    return false
end


-- --------------------------------------------------
-- AceConfig options table
-- --------------------------------------------------
local options = {
    type = "group",
    name = "GCD Bar",
    args = {
        -- General --
        header = {
            type  = "header",
            name  = "GCD Bar",
            order = 0,
        },
        desc = {
            type  = "description",
            name  = "Shows GCD in a bar format",
            order = 1,
        },
        generalPad = {
            type  = "description",
            name  = "",
            order = 2,
        },
        generalWarning = {
            type  = "description",
            name  = "Still under development, things might be broken",
            order = 3,
        },
        generalPad2 = {
            type  = "description",
            name  = "",
            order = 4,
        },
        appearance = {
            type   = "group",
            name   = "Appearance",
            inline = true,
            order  = 10,
            args   = {
                barEnabled = {
                    type  = "toggle",
                    name  = "ShowGCDBar",
                    desc  = "Set GCD Bar Visibility",
                    set   = Setter,
                    get   = Getter,
                    order = 10,
                    width = "full",
                },
                offsetX = {
                    type  = "range",
                    name  = "Horizontal Offset",
                    set   = Setter,
                    get   = Getter,
                    min   = -2000,
                    max   = 2000,
                    step  = 1,
                    order = 11,
                    width = "full",
                },
                offsetY = {
                    type  = "range",
                    name  = "Vertical Offset",
                    set   = Setter,
                    get   = Getter,
                    min   = -2000,
                    max   = 2000,
                    step  = 1,
                    order = 12,
                    width = "full",
                },
                forgroundTexture = {
                    type   = "select",
                    name   = "Forground Texture",
                    set   = Setter,
                    get   = Getter,
                    values = ns.barTextureChoices,
                    order  = 13,
                    width  = "full",
                    style = "dropdown"
                },
                backgroundTexture = {
                    type   = "select",
                    name   = "Background Texture",
                    set   = Setter,
                    get   = Getter,
                    values = ns.barTextureChoices,
                    order  = 14,
                    width  = "full",
                    style = "dropdown"
                },
                forgroundColor = {
                    type   = "color",
                    name   = "Forground Color",
                    hasAlpha = true,
                    set = SetColor,
                    get = GetColor,
                    order  = 15,
                    width  = 0.8,
                },
                backgroundColor = {
                    type   = "color",
                    name   = "Background Color",
                    hasAlpha = true,
                    set = SetColor,
                    get = GetColor,
                    order  = 16,
                    width  = 0.8,
                },
                barWidth = {
                    type = "range",
                    name = "Bar Width",
                    set   = Setter,
                    get   = Getter,
                    min = minBarDim,
                    max = maxBardim,
                    step = 1,
                    order = 17,
                    width = "full"
                },
                barHeight = {
                    type = "range",
                    name = "Bar Height",
                    set   = Setter,
                    get   = Getter,
                    min = minBarDim,
                    max = maxBardim,
                    step = 1,
                    order = 18,
                    width = "full"
                },
                boarderEnabled = {
                    type  = "toggle",
                    name  = "Enable Boarder",
                    desc  = "Set Boarder Visibility",
                    set   = Setter,
                    get   = Getter,
                    order = 19,
                    width = 1,
                },
                boarderColor = {
                    type   = "color",
                    name   = "Outline Color",
                    hasAlpha = true,
                    set = SetColor,
                    get = GetColor,
                    disabled = IsboarderDisabled,
                    order  = 20,
                    width  = 1,
                },
                boarderSize = {
                    type = "range",
                    name = "Boarder Size",
                    set   = Setter,
                    get   = Getter,
                    min = 0,
                    max = 20,
                    step = 1,
                    disabled = IsboarderDisabled,
                    order = 21,
                    width = 1
                },
                strata = {
                    type   = "select",
                    name   = "Bar Strata",
                    set   = Setter,
                    get   = Getter,
                    values = ns.stratas,
                    order  = 22,
                    width  = "full",
                    style = "dropdown"
                },
            }
        },

        help = {
            type   = "group",
            name   = "Help",
            inline = true,
            order  = 40,
            args   = {
                helpText = {
                    type  = "description",
                    name  = [[
Slash commands:
/cdb show       - Show GCD Bar
/cdb hide       - Hide GCD Bar
/cdb toggle     - Toggle visibility
/cdb reset      - Reset to defaults
/cdb options    - brings up options]],
                    order = 10,
                },
            },
        },
    }
}


local AceConfig       = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

AceConfig:RegisterOptionsTable("GCDBar", options)
local panel = AceConfigDialog:AddToBlizOptions("GCDBar", "GCD Bar")
local function AddSub(name, path)
    return AceConfigDialog:AddToBlizOptions("GCDBar", name, "GCD Bar", path)
end

AddSub("Appearance", "appearance")
