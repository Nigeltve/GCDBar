---@class ns
local ns = select(2, ...)

local animating = false
local animStart = 0
local animDuration = 0

local bar = CreateFrame("StatusBar", nil, UIParent)
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
        border:Show()
    end

    bar:SetPoint("CENTER", settings.offsetX, settings.offsetY)
    bar:SetSize(settings.barWidth, settings.barHeight)
    bar:SetFrameStrata(settings.strata)
    bar:SetFrameLevel(frameLevel)
    bar:SetStatusBarTexture(ns.barTextures[settings.forgroundTexture])
    bar:SetStatusBarColor(settings.forgroundColor.r, settings.forgroundColor.g, settings.forgroundColor.b, settings.forgroundColor.a)
    bar:SetMinMaxValues(settings.statusBarMin, settings.statusBarmax)

    if(not settings.endFilled) then
		bar:SetValue(0)
	end

    bg:SetPoint("CENTER")
    bg:SetSize(settings.barWidth, settings.barHeight)
    bg:SetFrameStrata(settings.strata)
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

local function UpdateFill()
    if ns.barDb == nil then
        return
    end
    if not animating then return end

    local elapsed = GetTime() - animStart
    local progress = elapsed / animDuration

    if progress >= 1.05 then
        progress = 1
        animating = false

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

		if(issecurevalue(duration)) then
			ns:Log("Duration is secret" , ns.logTypes.WARNING)
			return
		end

		if start and duration and duration > 0 then
            animStart = start
            animDuration = duration
            animating = true
		end
    end
end

bar:SetScript("OnEvent", HandleGcdAction)
bar:SetScript("OnUpdate", UpdateFill)
