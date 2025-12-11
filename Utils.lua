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
