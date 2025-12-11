local addonName, ns = ...

local LOG_LEVEL_INFO = 3
local LOG_LEVEL_DEBUG = 2
local LOG_LEVEL_WARNING = 1
local LOG_LEVEL_ERROR = 0

local function LogInfo(msg)
    if ns.logLevel > LOG_LEVEL_INFO then
        return
    end
    print("INFO: " .. msg)
end

local function LogDebug(msg)
    if ns.logLevel > LOG_LEVEL_DEBUG then
        return
    end
    print("DEBUG: " .. msg)
end

local function LogWarning(msg)
    if ns.logLevel > LOG_LEVEL_WARNING then
        return
    end
    print("WARN: " .. msg)
end

local function LogError(msg)
    if ns.logLevel > LOG_LEVEL_ERROR then
        return
    end
    print("ERR: " .. msg)
end

local function Log(msg, logType)
    if not ns.debug then
        return
    end

    logType = logType or ns.logTypes.INFO

    if logType == ns.logTypes.INFO then
        LogInfo(msg)
    elseif logType == ns.logTypes.DEBUG then
        LogDebug(msg)
    elseif logType == ns.logTypes.WARNING then
        LogWarning(msg)
    elseif logType == ns.logTypes.ERROR then
        LogError(msg)
    end
end

ns.Log = Log

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

ns.AddMissingKeys = AddMissingKeys
ns.RemoveExtraKeys = RemoveExtraKeys


local function HandleDB(self, event, args1)
	if event == ns.eventNames.ADDON_LOADED and args1 == "GCDBar" then
        ns.Log("Settings up DB", ns.logTypes.DEBUG)
		BarDB = BarDB or CopyTable(ns.defaults)
        BarDB = ns.AddMissingKeys(ns.defaults, BarDB)
        BarDB = ns.RemoveExtraKeys(BarDB, ns.defaults)
	end
end

ns.HandleDB = HandleDB