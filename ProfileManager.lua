---@class ns
local ns = select(2, ...)

---@class ProfileManager
ns.profileManager = {
    profiles = {
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
function pm:CreateNewProfile(name)
    if string.len(name) <= 0 then
        ns:Say("Cannot create a profile with no name")
        return
    end

    if pm:ProfileExists(name) then
        ns:Say("Profile already exists! either reset with /cdb reset or delete with /cdp delete {name}")
        return
    end

    local newProfile = CopyTable(ns.defaultProfile)
    newProfile.name = name

    pm.profiles[name] = newProfile
    pm:SwapProfileTo(name)
end

---@param name string
function pm:DeleteProfile(name)
    local currentProfile = pm:GetCurrentProfile()
    if currentProfile.name == name then
        ns:Say("Cannot delete currently selected profile! Please swap to a different profile")
        return
    end

    if name ==  pm.profiles.default.name then
        ns:Say("Cannot delete the default profile")
        return
    end

    pm.profiles[name] = nil
end

---@param name string
function pm:SwapProfileTo(name)
    local profile = pm:GetCurrentProfile()
    if profile.name == name then
        ns:Say("already on the profile")
        return
    end

    if not pm:ProfileExists(name) then
        ns:Say("Profile doesnt exist")
        return
    end
    
    ns:SaveCurrentProfile()
    ns.currentProfile = pm.profiles[name]
    ns:UpdateBarSettings()
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
