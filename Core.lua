local addonName, ns = ...

local loginFrame = CreateFrame("Frame", nil, UIParent)
loginFrame:RegisterEvent(ns.eventNames.PLAYER_LOGIN)

local bar = CreateFrame("StatusBar", nil, UIParent)
bar:RegisterUnitEvent(ns.eventNames.SPELLCAST_START, ns.units.PLAYER)
bar:RegisterUnitEvent(ns.eventNames.SPELLCAST_SUCCEEDED, ns.units.PLAYER)

local bg = CreateFrame("StatusBar", nil, UIParent)

local function UpdateBarSettings(settings)
	if not settings then
		ns.Log("No Settings were passed in", ns.logTypes.WARNING)
		return;
	end

    bar:SetFrameStrata(settings.strata)
    bar:ClearAllPoints()
    bar:SetPoint("CENTER", settings.posX, settings.posY)
    bar:SetSize(settings.width, settings.height)
    bar:SetStatusBarTexture(settings.defaultTexture)
    bar:SetStatusBarColor(settings.barColor.r, settings.barColor.g, settings.barColor.b, settings.barColor.a)
    bar:SetMinMaxValues(settings.statusBarMin, settings.statusBarmax)

    bg:SetFrameStrata(settings.strata)
    bg:ClearAllPoints()
    bg:SetPoint("CENTER", settings.posX, settings.posY)
    bg:SetSize(settings.width, settings.height)
    bg:SetStatusBarTexture(settings.defaultTexture)
    bg:SetStatusBarColor(settings.bgColor.r, settings.bgColor.g, settings.bgColor.b, settings.bgColor.a)
    bg:SetMinMaxValues(settings.statusBarMin, settings.statusBarmax)

	if not settings.barEnabled then
		bar:Hide()
		bg:Hide()
	end
end

local function ReadSpellCooldown(spellID)
    if C_Spell and C_Spell.GetSpellCooldown then
        local info = C_Spell.GetSpellCooldown(spellID)
			return info.startTime, info.duration, info.modRate
    end
end

local animating = false
local animStart = 0
local animDuration = 0

local function UpdateFill()
    if not animating then return end

    local elapsed = GetTime() - animStart
    local progress = elapsed / animDuration

    if progress >= 1 then
        progress = 1
        animating = false
    end

    bar:SetValue(progress)
end

local function HandleGcdAction(self, event, ...)
    if event == ns.eventNames.SPELLCAST_START or event == ns.eventNames.SPELLCAST_SUCCEEDED then
		local start, duration, _ = ReadSpellCooldown(ns.spellIds.GCD)

		if(issecurevalue(duration)) then
				ns.Log("Duration is secret" , ns.logTypes.WARNING)
				return
		end

		if start and duration and duration > 0 then
            animStart = start
            animDuration = duration
            animating = true
		end
    end
end

local function HandleDB(self, event)
	if event == ns.eventNames.PLAYER_LOGIN then
		ns.Log("Addon loaded", ns.logTypes.DEBUG)
		BarDB = BarDB or CopyTable(ns.defaults)
		-- TODO: have it so that all the keys from default are there
		UpdateBarSettings(BarDB)
	end
end


loginFrame:SetScript("OnEvent", HandleDB)
bar:SetScript("OnEvent", HandleGcdAction)
bar:SetScript("OnUpdate", UpdateFill)
