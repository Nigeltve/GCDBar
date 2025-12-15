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

local function SetDropDown(info, val)
    local argType = info[#info]
    if argType == "forgroundTexture" then
        ns.barDb.forgroundTexture = val
    elseif argType == "backgroundTexture" then
        ns.barDb.backgroundTexture = val
    end

    ns:UpdateBarSettings()
end

local function GetDropDown(info)
    local argType = info[#info]
    if argType == "forgroundTexture" then
        return ns.barDb.forgroundTexture
    elseif argType == "backgroundTexture" then
        return ns.barDb.backgroundTexture
    end
end

-- Toggles --

local function SetToggle(info, val)
    local argType = info[#info]
    if argType == "barEnabled" then
        ns.barDb.barEnabled = val
    elseif argType == "boarderEnabled" then
        ns.barDb.boarderEnabled = val
    end
    
    ns:UpdateBarSettings()
end

local function GetToggle(info)
    local argType = info[#info]

    if argType == "barEnabled" then
        return ns.barDb.barEnabled
    elseif argType == "boarderEnabled" then
        return ns.barDb.boarderEnabled
    end

    return false
end

-- Color --

local function SetColor(info, red, green, blue, alpha)
    local argType = info[#info]
    local newColor = {r=red, g=green, b=blue, a=alpha}
    if argType ==  "forgroundColor" then
        ns.barDb.forgroundColor = newColor
    elseif argType == "backgroundColor" then
        ns.barDb.backgroundColor = newColor
    elseif argType == "boarderColor" then
        ns.barDb.boarderColor = newColor
    end

     ns:UpdateBarSettings()
end

local function GetColor(info)
    local argType = info[#info]
    local color = { r = 1, g = 1, b = 1 , a = 1} -- default color

    if argType ==  "forgroundColor" then
        color = ns.barDb.forgroundColor
    elseif argType == "backgroundColor" then
        color = ns.barDb.backgroundColor
     elseif argType == "boarderColor" then
        color = ns.barDb.boarderColor
    end

    return color.r, color.g, color.b, color.a
end

-- Ranges 

local function SetRange(info, val)
    local argType = info[#info]

    if argType == "barWidth" then
        ns.barDb.barWidth = val
    elseif argType == "barHeight" then
        ns.barDb.barHeight = val
    elseif argType == "boarderSize" then
        ns.barDb.boarderSize = val
    elseif argType == "offsetX" then
        ns.barDb.offsetX = val
    elseif argType == "offsetY" then
        ns.barDb.offsetY = val
    end

    ns:UpdateBarSettings()
end

local function GetRange(info)
    local argType = info[#info]

    if argType == "barWidth" then
        return ns.barDb.barWidth
    elseif argType == "barHeight" then
        return ns.barDb.barHeight
    elseif argType == "boarderSize" then
        return ns.barDb.boarderSize
    elseif argType == "offsetX" then
        return ns.barDb.offsetX
    elseif argType == "offsetY" then
        return ns.barDb.offsetY
    end

    return minBarDim
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
                    set   = SetToggle,
                    get   = GetToggle,
                    order = 10,
                    width = "full",
                },
                offsetX = {
                    type  = "range",
                    name  = "Horizontal Offset",
                    set = SetRange,
                    get = GetRange,
                    min   = -2000,
                    max   = 2000,
                    step  = 1,
                    order = 11,
                    width = "full",
                },
                offsetY = {
                    type  = "range",
                    name  = "Vertical Offset",
                    get = GetRange,
                    set = SetRange,
                    min   = -2000,
                    max   = 2000,
                    step  = 1,
                    order = 12,
                    width = "full",
                },
                forgroundTexture = {
                    type   = "select",
                    name   = "Forground Texture",
                    set = SetDropDown,
                    get = GetDropDown,
                    values = ns.barTextureChoices,
                    order  = 13,
                    width  = "full",
                    style = "dropdown"
                },
                
                backgroundTexture = {
                    type   = "select",
                    name   = "Background Texture",
                    set = SetDropDown,
                    get = GetDropDown,
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
                boarderColor = {
                    type   = "color",
                    name   = "Outline Color",
                    hasAlpha = true,
                    set = SetColor,
                    get = GetColor,
                    order  = 17,
                    width  = 0.8,
                },
                boarderEnabled = {
                    type  = "toggle",
                    name  = "Enable Boarder",
                    desc  = "Set Boarder Visibility",
                    set   = SetToggle,
                    get   = GetToggle,
                    order = 18,
                    width = 0.8,
                },
                boarderSize = {
                    type = "range",
                    name = "Boarder Size",
                    set = SetRange,
                    get = GetRange,
                    min = 0,
                    max = 20,
                    step = 1,
                    order = 19,
                    width = "full"
                },
                barWidth = {
                    type = "range",
                    name = "Bar Width",
                    set = SetRange,
                    get = GetRange,
                    min = minBarDim,
                    max = maxBardim,
                    step = 1,
                    order = 20,
                    width = "full"
                },
                barHeight = {
                    type = "range",
                    name = "Bar Height",
                    set = SetRange,
                    get = GetRange,
                    min = minBarDim,
                    max = maxBardim,
                    step = 1,
                    order = 21,
                    width = "full"
                }
            }
        }
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
