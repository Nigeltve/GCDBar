---@class ns
local ns = select(2, ...)

local LOG_LEVEL_INFO = 3
local LOG_LEVEL_DEBUG = 2
local LOG_LEVEL_WARNING = 1
local LOG_LEVEL_ERROR = 0

---@param msg string
function ns:Say(msg)
    DEFAULT_CHAT_FRAME:AddMessage("|cff00ff00 GCDBar:|r " .. tostring(msg))
end

---@param msg string
function ns:logClear(msg)
    print(msg)
end 

---@param msg string
local function LogInfo(msg)
    if ns.logLevel > LOG_LEVEL_INFO then
        return
    end
    print("INFO: " .. msg)
end

---@param msg string
local function LogDebug(msg)
    if ns.logLevel > LOG_LEVEL_DEBUG then
        return
    end
    print("DEBUG: " .. msg)
end

---@param msg string
local function LogWarning(msg)
    if ns.logLevel > LOG_LEVEL_WARNING then
        return
    end
    print("WARN: " .. msg)
end

---@param msg string
local function LogError(msg)
    if ns.logLevel > LOG_LEVEL_ERROR then
        return
    end
    print("ERR: " .. msg)
end

---@param msg string
---@param logType string?
function ns:Log(msg, logType)
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

---@param level number 
function ns:logLevelConvert(level)
	if not type(level) == "number" then
		return
	end 

	if level == 0 then return ns.logTypes.ERROR end
	if level == 1 then return ns.logTypes.WARNING end
	if level == 2 then return ns.logTypes.DEBUG end
	if level == 3 then return ns.logTypes.INFO end
end

---@param level string
function ns:logTypeConvert(level)
	if not type(level) == "string" then
		return
	end

	if level == ns.logTypes.ERROR then return 0  end
	if level == ns.logTypes.WARNING then return 1 end
	if level == ns.logTypes.DEBUG then return 2 end
	if level == ns.logTypes.INFO then return 3 end
end

function ns:SaveCurrentProfile()
    for _, profile in pairs(ns.profileManager.profiles) do
        if profile.name == ns.currentProfile.name then
            profile = ns.currentProfile
            print("Saved "..profile.name)
        end
    end
end

---@param tbl table
---@param indent number | nil
---@param seen table | nil
-- Function to print nested tables in WoW
function ns:PrintTable(tbl, indent, seen)
    if tbl == nil then 
        print("Table is nil")
        return
    end

    indent = indent or 0
    seen = seen or {}
    
    -- Prevent infinite recursion for circular references
    if seen[tbl] then
        print(string.rep("  ", indent) .. "(circular reference)")
        return
    end
    seen[tbl] = true
    
    -- Handle non-table types
    if type(tbl) ~= "table" then
        print(string.rep("  ", indent) .. tostring(tbl))
        return
    end
    
    -- Print table contents
    for k, v in pairs(tbl) do
        local formatting = string.rep("  ", indent) .. tostring(k) .. ": "
        
        if type(v) == "table" then
            print(formatting .. "{")
            ns:PrintTable(v, indent + 1, seen)
            print(string.rep("  ", indent) .. "}")
        elseif type(v) == "function" then
            print(formatting .. "<function>")
        elseif type(v) == "string" then
            print(formatting .. '"' .. v .. '"')
        else
            print(formatting .. tostring(v))
        end
    end
end
