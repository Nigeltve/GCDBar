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
    local bar = CreateFrame("StatusBar", nil, UIParent, UIParent)
    local unlockText = bar:CreateFontString(nil, "OVERLAY")
    unlockText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
    unlockText:SetPoint("CENTER", bar, "CENTER", 0, 0)

    local border = CreateFrame("Frame", nil, bar, "BackdropTemplate")
    local backGround = CreateFrame("StatusBar" , nil, bar)

    bar:RegisterEvent(ns.eventNames.PLAYER_ENTERING_WORLD)
    bar:RegisterUnitEvent(ns.eventNames.SPELLCAST_START, ns.units.PLAYER)
    bar:RegisterUnitEvent(ns.eventNames.SPELLCAST_SUCCEEDED, ns.units.PLAYER)

    bm.bar = bar
    bm.unlockText = unlockText
    bm.border = border
    bm.backGround = backGround

    bm.EHLeft = bar:CreateTexture(nil, "OVERLAY")
    bm.EHLeft:SetColorTexture(1, 1, 1, 0.5)
    bm.EHLeft:SetWidth(ns.edgeThreshold)
    bm.EHLeft:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
    bm.EHLeft:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)

    bm.EHRight = bar:CreateTexture(nil, "OVERLAY")
    bm.EHRight:SetColorTexture(1, 1, 1, 0.5)
    bm.EHRight:SetWidth(ns.edgeThreshold)
    bm.EHRight:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
    bm.EHRight:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)

    bm.EHTop = bar:CreateTexture(nil, "OVERLAY")
    bm.EHTop:SetColorTexture(1, 1, 1, 0.5)
    bm.EHTop:SetHeight(ns.edgeThreshold)
    bm.EHTop:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
    bm.EHTop:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)

    bm.EHBottom = bar:CreateTexture(nil, "OVERLAY")
    bm.EHBottom:SetColorTexture(1, 1, 1, 0.5)
    bm.EHBottom:SetHeight(ns.edgeThreshold)
    bm.EHBottom:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
    bm.EHBottom:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)

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

    if(not profileSettings.endFilled) then
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

function bm:GetCloseToEdgeFromBar(b)
    local scale = bm.bar:GetEffectiveScale()
    local x, y = GetCursorPosition()
    x = x / scale
    y = y / scale

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

local function OnBarMouseDown(self, button)
    if button ~= "LeftButton" then return end

    local left, right, top, bottom = bm:GetSides(bm.bar)
    local nearLeft, nearRight, nearTop, nearBottom = bm:GetCloseToEdgeFromBar(bm.bar) 
    
    if nearLeft or nearRight or nearTop or nearBottom then
        -- Resize mode
        bm.bar:SetResizable(true)
    
        if nearLeft and nearTop then
            ns.resizeEdge = "TOPLEFT"
            bm.bar:ClearAllPoints()
            bm.bar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMLEFT", right, bottom)
        elseif nearLeft and nearBottom then
            ns.resizeEdge = "BOTTOMLEFT"
            bm.bar:ClearAllPoints()
            bm.bar:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", right, top)
        elseif nearRight and nearTop then
            ns.resizeEdge = "TOPRIGHT"
            bm.bar:ClearAllPoints()
            bm.bar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", left, bottom)
        elseif nearRight and nearBottom then
            ns.resizeEdge = "BOTTOMRIGHT"
            bm.bar:ClearAllPoints()
            bm.bar:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
        elseif nearLeft then
            ns.resizeEdge = "LEFT"
            bm.bar:ClearAllPoints()
            bm.bar:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", right, top)
        elseif nearRight then
            ns.resizeEdge = "RIGHT"
            bm.bar:ClearAllPoints()
            bm.bar:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
        elseif nearTop then
            ns.resizeEdge = "TOP"
            bm.bar:ClearAllPoints()
            bm.bar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", left, bottom)
        elseif nearBottom then
            ns.resizeEdge = "BOTTOM"
            bm.bar:ClearAllPoints()
            bm.bar:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
        end
        bm.bar:StartSizing(ns.resizeEdge)
    else
        -- Move mode (center area)
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