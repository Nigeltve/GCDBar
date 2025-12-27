---@class Core
local core = select(2, ...)

local LOG_LEVEL_INFO = 3
local LOG_LEVEL_DEBUG = 2
local LOG_LEVEL_WARNING = 1
local LOG_LEVEL_ERROR = 0

---@param msg string
function core:Say(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00 GCDBar:|r " .. tostring(msg))
end

---@param msg string
function core:logClear(msg)
    print(msg)
end 

---@param msg string
local function LogInfo(msg)
    if core.logLevel > LOG_LEVEL_INFO then
        return
    end
    print("INFO: " .. msg)
end

---@param msg string
local function LogDebug(msg)
    if core.logLevel > LOG_LEVEL_DEBUG then
        return
    end
    print("DEBUG: " .. msg)
end

---@param msg string
local function LogWarning(msg)
    if core.logLevel > LOG_LEVEL_WARNING then
        return
    end
    print("WARN: " .. msg)
end

---@param msg string
local function LogError(msg)
    if core.logLevel > LOG_LEVEL_ERROR then
        return
    end
    print("ERR: " .. msg)
end

---@param msg string
---@param logType string?
function core:Log(msg, logType)
    if not core.debug then
        return
    end

    logType = logType or core.logTypes.INFO

    if logType == core.logTypes.INFO then
        LogInfo(msg)
    elseif logType == core.logTypes.DEBUG then
        LogDebug(msg)
    elseif logType == core.logTypes.WARNING then
        LogWarning(msg)
    elseif logType == core.logTypes.ERROR then
        LogError(msg)
    end
end

---@param level number 
function core:logLevelConvert(level)
	if not type(level) == "number" then
		return
	end 

	if level == 0 then return core.logTypes.ERROR end
	if level == 1 then return core.logTypes.WARNING end
	if level == 2 then return core.logTypes.DEBUG end
	if level == 3 then return core.logTypes.INFO end
end

---@param level string
function core:logTypeConvert(level)
	if not type(level) == "string" then
		return
	end

	if level == core.logTypes.ERROR then return 0  end
	if level == core.logTypes.WARNING then return 1 end
	if level == core.logTypes.DEBUG then return 2 end
	if level == core.logTypes.INFO then return 3 end
end

---@param tbl table
function core:Dump(tbl)
    if tbl == nil then 
        print("Table is nil")
        return
    end
    DevTools_Dump(tbl)
end
