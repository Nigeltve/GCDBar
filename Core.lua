---@class ns
local ns = select(2, ...)

local animTicker = nil
local animStart = nil
local animDuration = nil


local bar = CreateFrame("StatusBar", nil, UIParent, UIParent)
local unlockText = bar:CreateFontString(nil, "OVERLAY")
unlockText:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
unlockText:SetPoint("CENTER", bar, "CENTER", 0, 0)

local border = CreateFrame("Frame", nil, bar, "BackdropTemplate")
local bg = CreateFrame("StatusBar" , nil, bar)

bar:RegisterUnitEvent(ns.eventNames.SPELLCAST_START, ns.units.PLAYER)
bar:RegisterUnitEvent(ns.eventNames.SPELLCAST_SUCCEEDED, ns.units.PLAYER)


local function OnBarMouseUp()
    bar:StopMovingOrSizing()
    local _, _, _, offsetX, offsetY = bar:GetPoint()
    ns.currentProfile.settings.offsetX = offsetX
    ns.currentProfile.settings.offsetY = offsetY

    local AceConfigRegistry = LibStub("AceConfigRegistry-3.0")
    AceConfigRegistry:NotifyChange("GCDBar")
end

local function OnBarMouseDown()
    bar:StartMoving()
end

function ns:UnlockBar()
    if not bar then
        ns:Say("Bar was not initialised")
        return
    end

    ns:Say("Unlocked")

    unlockText:SetText("Unlocked")

    bar:SetMovable(true)
    bar:EnableMouse(true)
    bar:SetScript("OnMouseDown", OnBarMouseDown)
    bar:SetScript("OnMouseUp", OnBarMouseUp)
end

function ns:LockBar()
    if not bar then
        ns:Say("Bar was not initialised")
        return
    end

    
    ns:Say("Locked")

    unlockText:SetText("")

    bar:SetMovable(false)
    bar:EnableMouse(false)

    bar:SetScript("OnMouseDown", nil)
    bar:SetScript("OnMouseUp", nil)
end

function ns:UpdateBarSettings()
	if not ns.currentProfile then
		ns:Log("No Prfile to be found", ns.logTypes.ERROR)
		return;
	end

    local profileSettings = ns.currentProfile.settings
    local frameLevel = 10

	if not profileSettings.barEnabled then
		bar:Hide()
        return
	else
		bar:Show()
	end

    if not profileSettings.boarderEnabled or profileSettings.boarderSize <= 0 then
        border:Hide()
    else
        border:SetAllPoints(bar)
        border:SetBackdrop({
            edgeFile = ns.outlinetextures.default,
            edgeSize = profileSettings.boarderSize,
        })
        border:SetBackdropBorderColor(profileSettings.boarderColor.r, profileSettings.boarderColor.g, profileSettings.boarderColor.b, profileSettings.boarderColor.a)
        border:SetFrameStrata(ns.stratas[profileSettings.strata])
        border:Show()
    end

    bar:SetPoint("CENTER", profileSettings.offsetX, profileSettings.offsetY)
    bar:SetSize(profileSettings.barWidth, profileSettings.barHeight)
    bar:SetFrameStrata(ns.stratas[profileSettings.strata])
    bar:SetFrameLevel(frameLevel)
    bar:SetStatusBarTexture(ns.barTextures[profileSettings.forgroundTexture])
    bar:SetStatusBarColor(profileSettings.forgroundColor.r, profileSettings.forgroundColor.g, profileSettings.forgroundColor.b, profileSettings.forgroundColor.a)
    bar:SetMinMaxValues(profileSettings.statusBarMin, profileSettings.statusBarmax)

    if(not profileSettings.endFilled) then
		bar:SetValue(0)
	end

    bg:SetPoint("CENTER")
    bg:SetSize(profileSettings.barWidth, profileSettings.barHeight)
    bg:SetFrameStrata(ns.stratas[profileSettings.strata])
    bg:SetFrameLevel(bar:GetFrameLevel() - 1)
    bg:SetStatusBarTexture(ns.barTextures[profileSettings.backgroundTexture])
    bg:SetStatusBarColor(profileSettings.backgroundColor.r, profileSettings.backgroundColor.g, profileSettings.backgroundColor.b, profileSettings.backgroundColor.a)
    bg:SetMinMaxValues(profileSettings.statusBarMin, profileSettings.statusBarmax)
end

local function ReadSpellCooldown(spellID)
    if C_Spell and C_Spell.GetSpellCooldown then
        local info = C_Spell.GetSpellCooldown(spellID)
			return info.startTime, info.duration, info.modRate
    end
end

local function StopAnimation()
    if not animTicker then
        return
    end

    animTicker:Cancel()
    animTicker = nil
    animStart = nil
    animDuration = nil
    
end

local function UpdateFill()
    if ns.currentProfile == nil or not ns.currentProfile.settings.barEnabled then
        return
    end

    if not animStart or not animDuration or animDuration <= 0 then
        StopAnimation()
        return
    end

    local elapsed = GetTime() - animStart
    local progress = elapsed / animDuration

    if progress >= 1
     then
        progress = 1
        StopAnimation()
		if ns.currentProfile.settings.endFilled then
			bar:SetValue(1)
		else
			bar:SetValue(0)
		end
		return;
    end

	if ns.currentProfile.settings.fillReverse then
		bar:SetValue(1 - progress)
	else
		bar:SetValue(progress)
	end
end

local function HandleGcdAction(self, event, ...)
    if event == ns.eventNames.SPELLCAST_START or event == ns.eventNames.SPELLCAST_SUCCEEDED then
        if ns.currentProfile == nil then
            ns:Log("Profile is null",ns.logTypes.WARNING)
            return
        end

		local start, duration, _ = ReadSpellCooldown(ns.spellIds.GCD)

		if ns.toc and string.find(ns.toc, "12") and not canaccessvalue(duration) then
            StopAnimation()
			return
		end

		if start and duration then
            StopAnimation()

            animStart = start
            animDuration = duration
            animTicker = C_Timer.NewTicker(0.016, UpdateFill)
		end
    end
end

bar:SetScript("OnEvent", HandleGcdAction)

