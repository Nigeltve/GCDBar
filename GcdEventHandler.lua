---@class ns
local ns = select(2, ...)

local animTicker = nil
local animStart = nil
local animDuration = nil

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

    if ns.barManager.bar == nil then
        return
    end

    local bar = ns.barManager.bar

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

local function HandleGcdAction(_, event)

    if event == ns.eventNames.PLAYER_LOGIN then
        if ns.currentProfile == nil then
            ns:Log("Profile is null",ns.logTypes.WARNING)
            return
        end

        if not ns.barManager.isSet then
                ns:Log("Failed to set up bar",ns.logTypes.WARNING)
                return
        end

        ns.barManager.bar:SetScript("OnEvent", HandleGcdAction)
    end

    if event ~= ns.eventNames.SPELLCAST_START and event ~= ns.eventNames.SPELLCAST_SUCCEEDED then
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

local initFrame = CreateFrame("Frame", nil, UIParent)
initFrame:RegisterEvent(ns.eventNames.PLAYER_LOGIN)
initFrame:SetScript("OnEvent", HandleGcdAction)