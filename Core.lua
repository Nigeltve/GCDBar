---@class ns
local ns = select(2, ...)

local animTicker = nil
local animStart = nil
local animDuration = nil


local bar = CreateFrame("StatusBar", nil, UIParent, UIParent)

local border = CreateFrame("Frame", nil, bar, "BackdropTemplate")
local bg = CreateFrame("StatusBar", nil, bar)

bar:RegisterUnitEvent(ns.eventNames.SPELLCAST_START, ns.units.PLAYER)
bar:RegisterUnitEvent(ns.eventNames.SPELLCAST_SUCCEEDED, ns.units.PLAYER)

function ns:UpdateBarSettings()
	if not ns.barDb then
		ns:Log("No Settings are being passed in", ns.logTypes.ERROR)
		return;
	end

    local settings = ns.barDb
    local frameLevel = 10

	if not settings.barEnabled then
		bar:Hide()
        return
	else
		bar:Show()
	end

    if not settings.boarderEnabled or settings.boarderSize <= 0 then
        border:Hide()
    else
        border:SetAllPoints(bar)
        border:SetBackdrop({
            edgeFile = ns.outlinetextures.default,
            edgeSize = ns.barDb.boarderSize,
        })
        border:SetBackdropBorderColor(settings.boarderColor.r, settings.boarderColor.g, settings.boarderColor.b, settings.boarderColor.a)
        border:SetFrameStrata(ns.stratas[ns.barDb.strata])
        border:Show()
    end

    bar:SetPoint("CENTER", settings.offsetX, settings.offsetY)
    bar:SetSize(settings.barWidth, settings.barHeight)
    bar:SetFrameStrata(ns.stratas[ns.barDb.strata])
    bar:SetFrameLevel(frameLevel)
    bar:SetStatusBarTexture(ns.barTextures[settings.forgroundTexture])
    bar:SetStatusBarColor(settings.forgroundColor.r, settings.forgroundColor.g, settings.forgroundColor.b, settings.forgroundColor.a)
    bar:SetMinMaxValues(settings.statusBarMin, settings.statusBarmax)

    if(not settings.endFilled) then
		bar:SetValue(0)
	end

    bg:SetPoint("CENTER")
    bg:SetSize(settings.barWidth, settings.barHeight)
    bg:SetFrameStrata(ns.stratas[ns.barDb.strata])
    bg:SetFrameLevel(bar:GetFrameLevel() - 1)
    bg:SetStatusBarTexture(ns.barTextures[settings.backgroundTexture])
    bg:SetStatusBarColor(settings.backgroundColor.r, settings.backgroundColor.g, settings.backgroundColor.b, settings.backgroundColor.a)
    bg:SetMinMaxValues(settings.statusBarMin, settings.statusBarmax)
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
    if ns.barDb == nil or not ns.barDb.barEnabled then
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
		if ns.barDb.endFilled then
			bar:SetValue(1)
		else
			bar:SetValue(0)
		end
		return;
    end

	if ns.barDb.fillReverse then
		bar:SetValue(1 - progress)
	else
		bar:SetValue(progress)
	end
end

local function HandleGcdAction(self, event, ...)
    if event == ns.eventNames.SPELLCAST_START or event == ns.eventNames.SPELLCAST_SUCCEEDED then
        if ns.barDb == nil then
            ns:Log("Data Base is null",ns.logTypes.WARNING)
            return
        end

		local start, duration, _ = ReadSpellCooldown(ns.spellIds.GCD)

		if not canaccessvalue(duration) then
            StopAnimation()
			ns:Log("Duration is secret" , ns.logTypes.WARNING)
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
