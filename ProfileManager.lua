---@class ns
local ns = select(2, ...)

---@class ProfileManager
---@field profile table
ns.profileManager = {
    profiles = {
        default = ns.defaultProfile
    }
}

---@class ProfileManager
local pm = ns.profileManager

function pm:ListProfileNames()
    for k,v in pairs(pm.profiles) do
        ns:Say(v.name)
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
        ns:Say("Cannot create a profile with no name")
        return false
    end

    local regex = "^[a-zA-Z0-9_]+$"

    if not string.match(name, regex) and #name >= 4 then
        ns:Say("New profile name invalid")
        ns:Say("cannot have puncuation apart from _ or spaces")
        return false
    end

    if pm:ProfileExists(name) then
        ns:Say("Profile already exists! either reset with /cdb reset or delete with /cdp delete {name}")
        return false
    end

    local newProfile = CopyTable(ns.defaultProfile)
    newProfile.name = string.lower(name)

    pm.profiles[newProfile.name] = newProfile
    pm:SwapProfileTo(newProfile.name)
    ns:Say("Created profile: ".. newProfile.name)
    return true
end

---@param name string
---@return boolean
function pm:DeleteProfile(name)
    local currentProfile = pm:GetCurrentProfile()

    if currentProfile.name == name then
        ns:Say("Cannot delete current acative profile! Please swap to a different profile")
        return false
    end

    if name ==  pm.profiles.default.name then
        ns:Say("Cannot delete the default profile")
        return false
    end

    pm.profiles[name] = nil
    ns:Say("Deleted profile: ".. name)
    return true
end

---@param name string
---@return boolean
function pm:SwapProfileTo(name)
    local profile = pm:GetCurrentProfile()
    if profile.name == name then
        ns:Say("Profile already active")
        return false
    end

    if not pm:ProfileExists(name) then
        ns:Say("Profile doesnt exist")
        return false
    end
    
    pm:SaveCurrentProfile()
    ns.currentProfile = pm.profiles[name]
    ns:UpdateBarSettings()
    ns:Say("Swapped Profile: ".. name)
    return true
end

---@return boolean
function pm:ProfileExists(name)
    local nextProfile = pm.profiles[name]
    return nextProfile ~= nil and next(nextProfile) ~= nil
end

---@return Profile
function pm:GetCurrentProfile()
    return ns.currentProfile
end

function pm:SaveCurrentProfile()
    for _, profile in pairs(ns.profileManager.profiles) do
        if profile.name == ns.currentProfile.name then
            profile = ns.currentProfile
        end
    end
end
