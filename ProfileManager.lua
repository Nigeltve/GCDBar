---@class Core
local core = select(2, ...)

---@class ProfileManager
---@field profile table
core.profileManager = {
    profiles = {
        default = core.defaultProfile
    }
}

---@class ProfileManager
local pm = core.profileManager

function pm:ListProfileNames()
    for k,v in pairs(pm.profiles) do
        core:Say(v.name)
    end
end

---@return table
function pm:GetListProfileNames()
    local profiles = {}
    for k,v in pairs(pm.profiles) do
        profiles[k] = k
    end
    return profiles
end

---@param name string
---@return boolean
function pm:CreateNewProfile(name)
    if string.len(name) <= 0 then
        core:Say("Cannot create a profile with no name")
        return false
    end

    local regex = "^[a-zA-Z0-9_]+$"

    if not string.match(name, regex) and #name >= 4 then
        core:Say("New profile name invalid")
        core:Say("cannot have puncuation apart from _ or spaces")
        return false
    end

    if pm:ProfileExists(name) then
        core:Say("Profile already exists! either reset with /cdb reset or delete with /cdp delete {name}")
        return false
    end

    local newProfile = CopyTable(core.defaultProfile)
    newProfile.name = string.lower(name)

    pm.profiles[newProfile.name] = newProfile
    pm:SwapProfileTo(newProfile.name)
    core:Say("Created profile: ".. newProfile.name)
    return true
end

---@param name string
---@return boolean
function pm:DeleteProfile(name)
    local currentProfile = pm:GetCurrentProfile()

    if currentProfile.name == name then
        core:Say("Cannot delete current acative profile! Please swap to a different profile")
        return false
    end

    if name ==  pm.profiles.default.name then
        core:Say("Cannot delete the default profile")
        return false
    end

    pm.profiles[name] = nil
    core:Say("Deleted profile: ".. name)
    return true
end

---@param name string
---@return boolean
function pm:SwapProfileTo(name)
    local profile = pm:GetCurrentProfile()
    if profile.name == name then
        core:Say("Profile already active")
        return false
    end

    if not pm:ProfileExists(name) then
        core:Say("Profile doesnt exist")
        return false
    end
    
    pm:SaveCurrentProfile()
    core.currentProfile = pm.profiles[name]
    core.barManager:UpdateBarSettings()
    core:Say("Swapped Profile: ".. name)
    return true
end

---@return boolean
function pm:ProfileExists(name)
    local nextProfile = pm.profiles[name]
    return nextProfile ~= nil and next(nextProfile) ~= nil
end

---@return Profile
function pm:GetCurrentProfile()
    return core.currentProfile
end

function pm:SaveCurrentProfile()
    for _, profile in pairs(core.profileManager.profiles) do
        if profile.name == core.currentProfile.name then
            profile = core.currentProfile
        end
    end
end
