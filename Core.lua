local _, ns = ...

local animating = false
local animStart = 0
local animDuration = 0

local bar = CreateFrame("StatusBar", nil, UIParent)
local outline = CreateFrame("StatusBar", nil, bar)
local bg = CreateFrame("StatusBar", nil, bar)

bar:RegisterEvent(ns.eventNames.PLAYER_LOGIN)
bar:RegisterUnitEvent(ns.eventNames.SPELLCAST_START, ns.units.PLAYER)
bar:RegisterUnitEvent(ns.eventNames.SPELLCAST_SUCCEEDED, ns.units.PLAYER)

function ns:UpdateBarSettings(settings)
	if not settings then
		ns.Log("No Settings were passed in", ns.logTypes.ERROR)
		return;
	end

    local outlinePad = 3 * settings.boarderSize
    local fillPad = outlinePad - 2
    local frameLevel = 10

    bar:SetFrameStrata(settings.strata)
    bar:SetFrameLevel(frameLevel)
    bar:SetPoint("CENTER", settings.posX, settings.posY)
    bar:SetSize(settings.width, settings.height)
    bar:SetStatusBarTexture(settings.defaultTexture)
    bar:SetStatusBarColor(settings.barColor.r, settings.barColor.g, settings.barColor.b, settings.barColor.a)
    bar:SetMinMaxValues(settings.statusBarMin, settings.statusBarmax)

	if(not settings.endFilled) then
		bar:SetValue(0)
	end

    bg:SetPoint("CENTER")
    bg:SetFrameStrata(settings.strata)
    bg:SetFrameLevel(bar:GetFrameLevel() - 1)
    bg:SetSize(settings.width + fillPad, settings.height + fillPad)
    bg:SetStatusBarTexture(settings.defaultBG)
    bg:SetStatusBarColor(settings.bgColor.r, settings.bgColor.g, settings.bgColor.b, settings.bgColor.a)
    bg:SetMinMaxValues(settings.statusBarMin, settings.statusBarmax)

    outline:SetPoint("CENTER")
    outline:SetFrameStrata(settings.strata)
    outline:SetFrameLevel(bar:GetFrameLevel() + 1)
    outline:SetSize(settings.width + outlinePad, settings.height + outlinePad)
    outline:SetStatusBarTexture(settings.defaultOutline)
    outline:SetStatusBarColor(settings.outlineColor.r, settings.outlineColor.g, settings.outlineColor.b, settings.outlineColor.a)
    outline:SetMinMaxValues(settings.statusBarMin, settings.statusBarmax)

	if not settings.barEnabled then
		bar:Hide()
	else
		bar:Show()
	end
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
    if event == ns.eventNames.PLAYER_LOGIN then
        if ns.barDb == nil then
            ns:Log("BarDb is empty" ,ns.logTypes.WARNING)
            return;
        end

        ns:UpdateBarSettings(ns.barDb)
    elseif event == ns.eventNames.SPELLCAST_START or event == ns.eventNames.SPELLCAST_SUCCEEDED then
        if ns.barDb == nil then
            ns:Log( "Data Base is null",ns.logTypes.WARNING)
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
