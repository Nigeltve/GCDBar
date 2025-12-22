---@class ns
local ns = select(2, ...)

---@class BarManager
ns.barManager = {}

---@class BarManage
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
    
    -- Right edge
    bm.EHRight = bar:CreateTexture(nil, "OVERLAY")
    bm.EHRight:SetColorTexture(1, 1, 1, 0.5)
    bm.EHRight:SetWidth(ns.edgeThreshold)
    bm.EHRight:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
    bm.EHRight:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
    
    -- Top edge
    bm.EHTop = bar:CreateTexture(nil, "OVERLAY")
    bm.EHTop:SetColorTexture(1, 1, 1, 0.5)
    bm.EHTop:SetHeight(ns.edgeThreshold)
    bm.EHTop:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
    bm.EHTop:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
    
    -- Bottom edge
    bm.EHBottom = bar:CreateTexture(nil, "OVERLAY")
    bm.EHBottom:SetColorTexture(1, 1, 1, 0.5)
    bm.EHBottom:SetHeight(ns.edgeThreshold)
    bm.EHBottom:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
    bm.EHBottom:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)

    -- bm:HideAllEdgeHighlights()
end

function bm:HideAllEdgeHighlights()
    bm.EHRight:Hide()
    bm.EHLeft:Hide()
    bm.EHTop:Hide()
    bm.EHBottom:Hide()
end

-- function ns:UpdateBarSettings()
-- 	if not ns.currentProfile then
-- 		ns:Log("No Prfile to be found", ns.logTypes.ERROR)
-- 		return;
-- 	end

--     local profileSettings = ns.currentProfile.settings
--     local frameLevel = 10


-- 	if not profileSettings.barEnabled then
-- 		bar:Hide()
--         return
-- 	else
-- 		bar:Show()
-- 	end

--     if not profileSettings.boarderEnabled or profileSettings.boarderSize <= 0 then
--         border:Hide()
--     else
--         border:SetAllPoints(bar)
--         border:SetBackdrop({
--             edgeFile = ns.outlinetextures.default,
--             edgeSize = profileSettings.boarderSize,
--         })
--         border:SetBackdropBorderColor(profileSettings.boarderColor.r, profileSettings.boarderColor.g, profileSettings.boarderColor.b, profileSettings.boarderColor.a)
--         border:SetFrameStrata(ns.stratas[profileSettings.strata])
--         border:Show()
--     end

--     bar:SetPoint("CENTER", profileSettings.offsetX, profileSettings.offsetY)
--     bar:SetSize(profileSettings.barWidth, profileSettings.barHeight)
--     bar:SetFrameStrata(ns.stratas[profileSettings.strata])
--     bar:SetFrameLevel(frameLevel)
--     bar:SetStatusBarTexture(ns.barTextures[profileSettings.forgroundTexture])
--     bar:SetStatusBarColor(profileSettings.forgroundColor.r, profileSettings.forgroundColor.g, profileSettings.forgroundColor.b, profileSettings.forgroundColor.a)
--     bar:SetMinMaxValues(profileSettings.statusBarMin, profileSettings.statusBarmax)

--     if(not profileSettings.endFilled) then
-- 		bar:SetValue(0)
-- 	end

--     bg:SetPoint("CENTER")
--     bg:SetSize(profileSettings.barWidth, profileSettings.barHeight)
--     bg:SetFrameStrata(ns.stratas[profileSettings.strata])
--     bg:SetFrameLevel(bar:GetFrameLevel() - 1)
--     bg:SetStatusBarTexture(ns.barTextures[profileSettings.backgroundTexture])
--     bg:SetStatusBarColor(profileSettings.backgroundColor.r, profileSettings.backgroundColor.g, profileSettings.backgroundColor.b, profileSettings.backgroundColor.a)
--     bg:SetMinMaxValues(profileSettings.statusBarMin, profileSettings.statusBarmax)
-- end

---@param event string
local function HandleBarCreation(self, event, ...)
    if event ~= ns.eventNames.PLAYER_LOGIN then return end
    
    bm:CreateBars()
end

local loginFrame = CreateFrame("Frame", nil, UIParent)
loginFrame:RegisterEvent(ns.eventNames.PLAYER_LOGIN)
loginFrame:SetScript("OnEvent", HandleBarCreation)


-- local edgeHighlights = {}
-- local function CreateEdgeHighlights()
--     -- Left edge
--     edgeHighlights.left = bar:CreateTexture(nil, "OVERLAY")
--     edgeHighlights.left:SetColorTexture(1, 1, 1, 0.5)
--     edgeHighlights.left:SetWidth(ns.edgeThreshold)
--     edgeHighlights.left:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
--     edgeHighlights.left:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
--     edgeHighlights.left:Hide()
    
--     -- Right edge
--     edgeHighlights.right = bar:CreateTexture(nil, "OVERLAY")
--     edgeHighlights.right:SetColorTexture(1, 1, 1, 0.5)
--     edgeHighlights.right:SetWidth(ns.edgeThreshold)
--     edgeHighlights.right:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
--     edgeHighlights.right:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
--     edgeHighlights.right:Hide()
    
--     -- Top edge
--     edgeHighlights.top = bar:CreateTexture(nil, "OVERLAY")
--     edgeHighlights.top:SetColorTexture(1, 1, 1, 0.5)
--     edgeHighlights.top:SetHeight(ns.edgeThreshold)
--     edgeHighlights.top:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
--     edgeHighlights.top:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
--     edgeHighlights.top:Hide()
    
--     -- Bottom edge
--     edgeHighlights.bottom = bar:CreateTexture(nil, "OVERLAY")
--     edgeHighlights.bottom:SetColorTexture(1, 1, 1, 0.5)
--     edgeHighlights.bottom:SetHeight(ns.edgeThreshold)
--     edgeHighlights.bottom:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
--     edgeHighlights.bottom:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)
--     edgeHighlights.bottom:Hide()
-- end

-- CreateEdgeHighlights()



-- local function HighlightEdge(top, left, right, bottom)
--     HideAllEdgeHighlights()
--     if left then
--         edgeHighlights.left:Show()
--     end
--     if right then
--         edgeHighlights.right:Show()
--     end
--     if top then
--         edgeHighlights.top:Show()
--     end
--     if bottom then
--         edgeHighlights.bottom:Show()
--     end
-- end



-- local function OnBarUpdate()
--     bg:SetSize(bar:GetWidth(), bar:GetHeight())
-- end

-- local function OnBarMouseUp()
--     bar:StopMovingOrSizing()
--     bar:SetScript("OnUpdate", nil)

--     local _, _, _, offsetX, offsetY = bar:GetPoint()
--     ns.currentProfile.settings.offsetX = offsetX
--     ns.currentProfile.settings.offsetY = offsetY

--     ns.currentProfile.settings.barWidth = bar:GetWidth()
--     ns.currentProfile.settings.barHeight =  bar:GetHeight()

--     ns.resizeEdge = nil
--     ns.startPoint = nil

--     ns:UpdateBarSettings()
--     local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
--     AceConfigRegistry:NotifyChange("GCDBar")
-- end

-- local function GetSides(b)
--     return b:GetLeft(), b:GetRight(), b:GetTop(), b:GetBottom()
-- end

-- local function GetCloseToEdgeFromBar(b)
--     local scale = bar:GetEffectiveScale()
--     local x, y = GetCursorPosition()
--     x = x / scale
--     y = y / scale
    
--     local left, right, top, bottom = GetSides(b)
    
--     -- Determine if we're near an edge
--     local nearLeft = (x - left) < ns.edgeThreshold
--     local nearRight = (right - x) < ns.edgeThreshold
--     local nearTop = (top - y) < ns.edgeThreshold
--     local nearBottom = (y - bottom) < ns.edgeThreshold
--     return nearLeft, nearRight, nearTop, nearBottom
-- end

-- local function OnBarMouseDown(self, button)
--     if button ~= "LeftButton" then return end

--     local left, right, top, bottom = GetSides(bar)
--     local nearLeft, nearRight, nearTop, nearBottom = GetCloseToEdgeFromBar(bar) 
    
--     if nearLeft or nearRight or nearTop or nearBottom then
--         -- Resize mode
--         bar:SetResizable(true)
    
--         if nearLeft and nearTop then
--             ns.resizeEdge = "TOPLEFT"
--             bar:ClearAllPoints()
--             bar:SetPoint("BOTTOMRIGHT", UIParent, "BOTTOMLEFT", right, bottom)
--         elseif nearLeft and nearBottom then
--             ns.resizeEdge = "BOTTOMLEFT"
--             bar:ClearAllPoints()
--             bar:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", right, top)
--         elseif nearRight and nearTop then
--             ns.resizeEdge = "TOPRIGHT"
--             bar:ClearAllPoints()
--             bar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", left, bottom)
--         elseif nearRight and nearBottom then
--             ns.resizeEdge = "BOTTOMRIGHT"
--             bar:ClearAllPoints()
--             bar:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
--         elseif nearLeft then
--             ns.resizeEdge = "LEFT"
--             bar:ClearAllPoints()
--             bar:SetPoint("TOPRIGHT", UIParent, "BOTTOMLEFT", right, top)
--         elseif nearRight then
--             ns.resizeEdge = "RIGHT"
--             bar:ClearAllPoints()
--             bar:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
--         elseif nearTop then
--             ns.resizeEdge = "TOP"
--             bar:ClearAllPoints()
--             bar:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", left, bottom)
--         elseif nearBottom then
--             ns.resizeEdge = "BOTTOM"
--             bar:ClearAllPoints()
--             bar:SetPoint("TOPLEFT", UIParent, "BOTTOMLEFT", left, top)
--         end
        
--         bar:StartSizing(ns.resizeEdge)
--     else
--         -- Move mode (center area)
--         bar:StartMoving()
--     end


--     bar:SetScript("OnUpdate", OnBarUpdate)
-- end

-- function ns:UnlockBar()
--     if not bar then
--         ns:Say("Bar was not initialised")
--         return
--     end

--     if not ns.currentProfile.settings.barEnabled then
--         return
--     end

--     ns:Say("Unlocked")

--     ns.locked = false

--     unlockText:SetText("Unlocked")

--     bar:EnableMouse(true)
--     bar:SetMovable(true)

--     bar:SetResizable(true)
--     bar:SetResizeBounds(ns.minBarDim, ns.minBarDim, ns.maxBardim, ns.maxBardim)

--     bar:SetScript("OnMouseDown", OnBarMouseDown)
--     bar:SetScript("OnMouseUp", OnBarMouseUp)
-- end

-- function ns:LockBar()
--     if not bar then
--         ns:Say("Bar was not initialised")
--         return
--     end

--     if not ns.currentProfile.settings.barEnabled then
--         return
--     end

--     ns:Say("Locked")

--     unlockText:SetText("")

--     ns.locked = true

--     bar:EnableMouse(false)
--     bar:SetResizable(false)
--     bar:SetMovable(false)

--     bar:SetScript("OnMouseDown", nil)
--     bar:SetScript("OnMouseUp", nil)
-- end
