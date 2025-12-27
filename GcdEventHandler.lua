---@class Core
local core = select(2, ...)

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
    if core.currentProfile == nil or not core.currentProfile.settings.barEnabled then
        return
    end

    if core.barManager.bar == nil then
        return
    end

    local bar = core.barManager.bar

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
		if core.currentProfile.settings.endFilled then
			bar:SetValue(1)
		else
			bar:SetValue(0)
		end
		return;
    end

	if core.currentProfile.settings.fillReverse then
		bar:SetValue(1 - progress)
	else
		bar:SetValue(progress)
	end
end

local function HandleGcdAction(_, event)

    if event == core.eventNames.PLAYER_LOGIN then
        if core.currentProfile == nil then
            core:Log("Profile is null",core.logTypes.WARNING)
            return
        end

        if not core.barManager.isSet then
                core:Log("Failed to set up bar",core.logTypes.WARNING)
                return
        end

        core.barManager.bar:SetScript("OnEvent", HandleGcdAction)
    end

    if event ~= core.eventNames.SPELLCAST_START and event ~= core.eventNames.SPELLCAST_SUCCEEDED then
        return
    end
 
    local start, duration, _ = ReadSpellCooldown(core.spellIds.GCD)

    if core.toc and string.find(core.toc, "12") and not canaccessvalue(duration) then
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
initFrame:RegisterEvent(core.eventNames.PLAYER_LOGIN)
initFrame:SetScript("OnEvent", HandleGcdAction)