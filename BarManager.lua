---@class ns
local ns = select(2, ...)

---@class BarManager
---@field isSet boolean
---@field bar StatusBar
---@field unlockText FontString
---@field border table
---@field backGround StatusBar
---@field EHLeft Texture
---@field EHRight Texture
---@field EHTop Texture
---@field EHBottom Texture
ns.barManager = {
    isSet = false
}

---@class BarManager
local bm = ns.barManager

function bm:CreateBars()
    bm.bar = CreateFrame("StatusBar", nil, UIParent, UIParent)
    bm.unlockText = bm.bar:CreateFontString(nil, "OVERLAY")
    bm.unlockText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    bm.unlockText:SetPoint("CENTER", bm.bar, "CENTER", 0, 0)

    bm.border = CreateFrame("Frame", nil, bm.bar, "BackdropTemplate")
    bm.backGround = CreateFrame("StatusBar" , nil, bm.bar)

    bm.bar:RegisterEvent(ns.eventNames.PLAYER_ENTERING_WORLD)
    bm.bar:RegisterUnitEvent(ns.eventNames.SPELLCAST_START, ns.units.PLAYER)
    bm.bar:RegisterUnitEvent(ns.eventNames.SPELLCAST_SUCCEEDED, ns.units.PLAYER)

    bm.EHLeft = bm.bar:CreateTexture(nil, "OVERLAY")
    bm.EHLeft:SetColorTexture(1, 1, 1, 0.5)
    bm.EHLeft:SetWidth(ns.edgeThreshold)
    bm.EHLeft:SetPoint("TOPLEFT", bm.bar, "TOPLEFT", 0, 0)
    bm.EHLeft:SetPoint("BOTTOMLEFT", bm.bar, "BOTTOMLEFT", 0, 0)

    bm.EHRight = bm.bar:CreateTexture(nil, "OVERLAY")
    bm.EHRight:SetColorTexture(1, 1, 1, 0.5)
    bm.EHRight:SetWidth(ns.edgeThreshold)
    bm.EHRight:SetPoint("TOPRIGHT", bm.bar, "TOPRIGHT", 0, 0)
    bm.EHRight:SetPoint("BOTTOMRIGHT", bm.bar, "BOTTOMRIGHT", 0, 0)

    bm.EHTop = bm.bar:CreateTexture(nil, "OVERLAY")
    bm.EHTop:SetColorTexture(1, 1, 1, 0.5)
    bm.EHTop:SetHeight(ns.edgeThreshold)
    bm.EHTop:SetPoint("TOPLEFT", bm.bar, "TOPLEFT", 0, 0)
    bm.EHTop:SetPoint("TOPRIGHT", bm.bar, "TOPRIGHT", 0, 0)

    bm.EHBottom = bm.bar:CreateTexture(nil, "OVERLAY")
    bm.EHBottom:SetColorTexture(1, 1, 1, 0.5)
    bm.EHBottom:SetHeight(ns.edgeThreshold)
    bm.EHBottom:SetPoint("BOTTOMLEFT", bm.bar, "BOTTOMLEFT", 0, 0)
    bm.EHBottom:SetPoint("BOTTOMRIGHT", bm.bar, "BOTTOMRIGHT", 0, 0)

    bm:HideAllEdgeHighlights()
    bm:UpdateBarSettings()

    bm.isSet = true
end

function bm:UpdateBarSettings()
	if not ns.currentProfile then
		ns:Log("No Prfile to be found", ns.logTypes.ERROR)
		return;
	end

    local profileSettings = ns.currentProfile.settings
    local frameLevel = 10


	if not profileSettings.barEnabled then
		bm.bar:Hide()
        return
	else
		bm.bar:Show()
	end

    if not profileSettings.boarderEnabled or profileSettings.boarderSize <= 0 then
        bm.border:Hide()
    else
        bm.border:SetAllPoints(bm.bar)
        bm.border:SetBackdrop({
            edgeFile = ns.outlinetextures.default,
            edgeSize = profileSettings.boarderSize,
        })
        bm.border:SetBackdropBorderColor(profileSettings.boarderColor.r, profileSettings.boarderColor.g, profileSettings.boarderColor.b, profileSettings.boarderColor.a)
        bm.border:SetFrameStrata(ns.stratas[profileSettings.strata])
        bm.border:Show()
    end

    bm.bar:SetPoint("CENTER", profileSettings.offsetX, profileSettings.offsetY)
    bm.bar:SetSize(profileSettings.barWidth, profileSettings.barHeight)
    bm.bar:SetFrameStrata(ns.stratas[profileSettings.strata])
    bm.bar:SetFrameLevel(frameLevel)
    bm.bar:SetStatusBarTexture(ns.barTextures[profileSettings.forgroundTexture])
    bm.bar:SetStatusBarColor(profileSettings.forgroundColor.r, profileSettings.forgroundColor.g, profileSettings.forgroundColor.b, profileSettings.forgroundColor.a)
    bm.bar:SetMinMaxValues(profileSettings.statusBarMin, profileSettings.statusBarmax)
    
    if profileSettings.isVertical then
        bm.bar:SetOrientation("VERTICAL")
    else
        bm.bar:SetOrientation("HORIZONTAL")
    end

    if not profileSettings.endFilled then
		bm.bar:SetValue(0)
	end

    bm.backGround:SetPoint("CENTER")
    bm.backGround:SetSize(profileSettings.barWidth, profileSettings.barHeight)
    bm.backGround:SetFrameStrata(ns.stratas[profileSettings.strata])
    bm.backGround:SetFrameLevel(bm.bar:GetFrameLevel() - 1)
    bm.backGround:SetStatusBarTexture(ns.barTextures[profileSettings.backgroundTexture])
    bm.backGround:SetStatusBarColor(profileSettings.backgroundColor.r, profileSettings.backgroundColor.g, profileSettings.backgroundColor.b, profileSettings.backgroundColor.a)
    bm.backGround:SetMinMaxValues(profileSettings.statusBarMin, profileSettings.statusBarmax)
end

function bm:HideAllEdgeHighlights()
    bm.EHRight:Hide()
    bm.EHLeft:Hide()
    bm.EHTop:Hide()
    bm.EHBottom:Hide()
end

function bm:HighlightEdge(top, left, right, bottom)
    bm:HideAllEdgeHighlights()
    if left then
        bm.EHLeft:Show()
    end
    if right then
        bm.EHRight:Show()
    end
    if top then
        bm.EHTop:Show()
    end
    if bottom then
        bm.EHBottom:Show()
    end
end

function bm:GetSides(b)
    return b:GetLeft(), b:GetRight(), b:GetTop(), b:GetBottom()
end

function bm:GetCursorPoint()
    local scale = bm.bar:GetEffectiveScale()
    local x, y = GetCursorPosition()
    x = x / scale
    y = y / scale

    return x, y
end

function bm:GetCloseToEdgeFromBar(b)
    local x, y = bm:GetCursorPoint()

    local left, right, top, bottom = bm:GetSides(b)

    if x < left or x > right or y < bottom or y > top then
        return false, false, false, false
    end

    local nearLeft = (x - left) < ns.edgeThreshold
    local nearRight = (right - x) < ns.edgeThreshold
    local nearTop = (top - y) < ns.edgeThreshold
    local nearBottom = (y - bottom) < ns.edgeThreshold

    return nearLeft, nearRight, nearTop, nearBottom
end

local function OnBarUpdate()
    bm.backGround:SetSize(bm.bar:GetWidth(), bm.bar:GetHeight())
    local nearLeft, nearRight, nearTop, nearBottom = bm:GetCloseToEdgeFromBar(bm.bar)
    bm:HighlightEdge(nearTop, nearLeft, nearRight, nearBottom)
end

local function OnBarMouseUp()
    bm.bar:StopMovingOrSizing()

    local _, _, _, offsetX, offsetY = bm.bar:GetPoint()
    ns.currentProfile.settings.offsetX = offsetX
    ns.currentProfile.settings.offsetY = offsetY

    ns.currentProfile.settings.barWidth = bm.bar:GetWidth()
    ns.currentProfile.settings.barHeight =  bm.bar:GetHeight()

    ns.resizeEdge = nil
    ns.startPoint = nil

    bm:UpdateBarSettings()
    local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
    AceConfigRegistry:NotifyChange("GCDBar")
end

local function GetEdge(nearLeft, nearRight, nearTop, nearBottom)
    if nearLeft and nearTop then return "TOPLEFT"
    elseif nearLeft and nearBottom then return "BOTTOMLEFT"
    elseif nearRight and nearTop then return "TOPRIGHT"
    elseif nearRight and nearBottom then return "BOTTOMRIGHT"
    elseif nearLeft then return "LEFT"
    elseif nearRight then return "RIGHT"
    elseif nearTop then return "TOP"
    elseif nearBottom then return "BOTTOM"
    end
    return nil
end

local function GetResizeConfig(edge, left, right, top, bottom)
    local configs = {
        TOPLEFT = {"BOTTOMRIGHT", right, bottom},
        BOTTOMLEFT = {"TOPRIGHT", right, top},
        TOPRIGHT = {"BOTTOMLEFT", left, bottom},
        BOTTOMRIGHT = {"TOPLEFT", left, top},
        LEFT = {"TOPRIGHT", right, top},
        RIGHT = {"TOPLEFT", left, top},
        TOP = {"BOTTOMLEFT", left, bottom},
        BOTTOM = {"TOPLEFT", left, top}
    }
    return configs[edge]
end

local function OnBarMouseDown(self, button)
    print(button)
     if button == "RightButton" then 
        bm.bar:StartMoving()
        return
    end
   
    if button ~= "LeftButton" then return end
   
    local left, right, top, bottom = bm:GetSides(bm.bar)
    local nearLeft, nearRight, nearTop, nearBottom = bm:GetCloseToEdgeFromBar(bm.bar)
    
    if nearLeft or nearRight or nearTop or nearBottom then
        local edge = GetEdge(nearLeft, nearRight, nearTop, nearBottom)
        if not edge then return end
        
        local config = GetResizeConfig(edge, left, right, top, bottom)
        if not config then return end

        ns.resizeEdge = edge
        bm.bar:SetResizable(true)
        bm.bar:ClearAllPoints()
        bm.bar:SetPoint(config[1], UIParent, "BOTTOMLEFT", config[2], config[3])
        bm.bar:StartSizing(ns.resizeEdge)
    else
        bm.bar:StartMoving()
    end
end

function bm:UnlockBar()
    if not bm.bar then
        ns:Say("Bar was not initialised")
        return
    end

    if not ns.currentProfile.settings.barEnabled then
        return
    end

    local bar = bm.bar
    local unlockText = bm.unlockText

    ns:Say("Unlocked")

    ns.locked = false

    unlockText:SetText("Unlocked")

    bar:EnableMouse(true)
    bar:SetMovable(true)

    bar:SetResizable(true)
    bar:SetResizeBounds(ns.minBarDim, ns.minBarDim, ns.maxBardim, ns.maxBardim)
    bar:SetScript("OnMouseDown", OnBarMouseDown)
    bar:SetScript("OnMouseUp", OnBarMouseUp)
    bar:SetScript("OnUpdate", OnBarUpdate)
end

function bm:LockBar()
    if not bm.bar then
        ns:Say("Bar was not initialised")
        return
    end

    if not ns.currentProfile.settings.barEnabled then
        return
    end

    local bar = bm.bar
    local unlockText = bm.unlockText

    ns:Say("Locked")

    unlockText:SetText("")

    ns.locked = true

    bar:EnableMouse(false)
    bar:SetResizable(false)
    bar:SetMovable(false)

    bar:SetScript("OnMouseDown", nil)
    bar:SetScript("OnMouseUp", nil)
    bar:SetScript("OnUpdate", nil)
end

---@param event string
local function HandleBarCreation(self, event, ...)
    if event ~= ns.eventNames.PLAYER_LOGIN then return end

    ns:Log("Creating Bars", ns.logTypes.DEBUG)
    bm:CreateBars()
end

local initFrame = CreateFrame("Frame", nil, UIParent)
initFrame:RegisterEvent(ns.eventNames.PLAYER_LOGIN)
initFrame:SetScript("OnEvent", HandleBarCreation)