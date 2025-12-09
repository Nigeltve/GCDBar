local addonName, ns = ...

local LOG_LEVEL_INFO = 3
local LOG_LEVEL_DEBUG = 2
local LOG_LEVEL_WARNING = 1
local LOG_LEVEL_ERROR = 0

local function LogInfo(msg)
    if ns.LOG_LEVEL > LOG_LEVEL_INFO then
        return
    end
    print("INFO: " .. msg)
end

local function LogDebug(msg)
    if ns.LOG_LEVEL > LOG_LEVEL_DEBUG then
        return
    end
    print("DEBUG: " .. msg)
end

local function LogWarning(msg)
    if ns.LOG_LEVEL > LOG_LEVEL_WARNING then
        return
    end
    print("WARN: " .. msg)
end

local function LogError(msg)
    if ns.LOG_LEVEL > LOG_LEVEL_ERROR then
        return
    end
    print("ERR: " .. msg)
end

local function Log(msg, logType)
    if not ns.DEBUG then
        return
    end

    logType = logType or ns.LOG_TYPES.INFO

    if logType == ns.LOG_TYPES.INFO then
        LogInfo(msg)
    elseif logType == ns.LOG_TYPES.DEBUG then
        LogDebug(msg)
    elseif logType == ns.LOG_TYPES.WARNING then
        LogWarning(msg)
    elseif logType == ns.LOG_TYPES.ERROR then
        LogError(msg)
    end
end

ns.Log = Log