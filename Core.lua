local addonName, ns = ...

local bar = CreateFrame("StatusBar", nil, UIParent)
local outline = CreateFrame("StatusBar", nil, bar)
local bg = CreateFrame("StatusBar", nil, bar)


bar:RegisterUnitEvent(ns.eventNames.SPELLCAST_START, ns.units.PLAYER)
bar:RegisterUnitEvent(ns.eventNames.SPELLCAST_SUCCEEDED, ns.units.PLAYER)


local function UpdateBarSettings(settings)
	if not settings then
		ns.Log("No Settings were passed in", ns.logTypes.WARNING)
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

local function AddMissingKeys(full, missing)
    for k, v in pairs(full) do
        if not (missing[""..k] ~= nil) then
            ns.Log("Table is missing ".. k, ns.logTypes.DEBUG)
            missing[""..k] = v
        end
    end

    return missing
end 

local function RemoveExtraKeys(full, missing)
    for k, v in pairs(full) do
        if missing[""..k] == nil then
            ns.Log("Removing extra key " .. k, ns.logTypes.DEBUG)
            full[""..k] = nil
        end
    end
    return missing
end

local function HandleDB(self, event, args1)
	if event == ns.eventNames.ADDON_LOADED and args1 == "GCDBar" then
        ns.Log("Settings up DB", ns.logTypes.DEBUG)
		BarDB = BarDB or CopyTable(ns.defaults)
        BarDB = AddMissingKeys(ns.defaults, BarDB)
        BarDB = RemoveExtraKeys(BarDB, ns.defaults)
		UpdateBarSettings(BarDB)
	end
end

local loginFrame = CreateFrame("Frame", nil, UIParent)
loginFrame:RegisterEvent(ns.eventNames.ADDON_LOADED)
loginFrame:SetScript("OnEvent", HandleDB)

bar:SetScript("OnEvent", HandleGcdAction)
bar:SetScript("OnUpdate", UpdateFill)
