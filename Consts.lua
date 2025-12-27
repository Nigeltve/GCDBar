---@class Core
local core = select(2, ...)

core.debug = true
core.logLevel = 0

core.logTypes = {
    INFO = "INFO",
    DEBUG = "DEBUG",
    WARNING = "WARNING",
    ERROR = "ERROR"
}


---@enum eventNames
core.eventNames = {
	ADDON_LOADED = "ADDON_LOADED",
    PLAYER_LOGIN = "PLAYER_LOGIN",
	PLAYER_LOGOUT = "PLAYER_LOGOUT",
    PLAYER_ENTERING_WORLD = "PLAYER_ENTERING_WORLD",
	PLAYER_LEAVING_WORLD = "PLAYER_LEAVING_WORLD",
    SPELL_CD_UPDATE = "SPELL_UPDATE_COOLDOWN",
    ACTIONBAR_CD_UPDATE = "ACTIONBAR_UPDATE_COOLDOWN",
    SPELLCAST_SUCCEEDED = "UNIT_SPELLCAST_SUCCEEDED",
    SPELLCAST_START = "UNIT_SPELLCAST_START",
    SPELLCAST_SENT = "UNIT_SPELLCAST_SENT"
}

---@enum Units 
core.units = {
    PLAYER= "player"
}

core.stratas = {
    BACKGROUND = "BACKGROUND",
    LOW = "LOW",
    MEDIUM = "MEDIUM",
    HIGH ="HIGH",
    DIALOG ="DIALOG",
    FULLSCREEN ="FULLSCREEN",
    FULLSCREEN_DIALOG= "FULLSCREEN_DIALOG",
    TOOLTIP = "TOOLTIP"
}

core.cdbCommands = {
	show = "show",
	hide = "hide",
	toggle = "toggle",
	reset = "reset",
	lock = "lock",
	unlock = "unlock",
	help = "help",
	options = "options",
}

core.cdpCommands = {
	list = "list",
	current = "current",
	create = "create",
	delete = "delete",
	switch = "swap"
}

core.barTextures = {
    Default = "Interface\\AddOns\\GCDBar\\Media\\Flat.tga",
	BantoBar = "Interface\\AddOns\\GCDBar\\Media\\BantoBar.tga",
}

core.barTextureChoices = {
    Default = "Default",
    BantoBar = "BantoBar",
}

core.outlinetextures = {
	default = "Interface\\Buttons\\WHITE8X8"
}

core.spellIds = {
	GCD = 61304
}

core.locked = true

core.minBarDim = 10
core.maxBardim = 2000
core.edgeThreshold = 7
core.resizeEdge = nil

---@class Settings
---@field barEnabled boolean
---@field offsetX number
---@field offsetY number
---@field barWidth number
---@field barHeight number
---@field boarderSize number
---@field boarderEnabled boolean
---@field forgroundColor table
---@field backgroundColor table
---@field boarderColor table
---@field forgroundTexture string
---@field backgroundTexture string
---@field statusBarMin number
---@field statusBarmax number 
---@field strata string
---@field fillReverse boolean
---@field endFilled boolean
---@field isVertical boolean
core.defaultSettings = {
	barEnabled = true,
	offsetX = 0,
	offsetY = -80,
	barWidth = 144,
	barHeight = 17,
	boarderSize = 2,
	boarderEnabled = true,
	forgroundColor =  { r = 1, g = 1, b = 1 , a = 1},
	backgroundColor =  { r = 0.3, g = 0.3, b = 0.3 , a = 0.75},
	boarderColor = { r = 0, g = 0, b = 0, a = 1 },
	forgroundTexture = core.barTextureChoices.Default,
	backgroundTexture = core.barTextureChoices.Default,
	statusBarMin = 0,
	statusBarmax = 1,
	strata = core.stratas.LOW,
	fillReverse = false,
	endFilled = true,
	isVertical = false
}

---@class BarFrames
---@field Bar StatusBar

---@class Profile
---@field name string
---@field settings Settings
core.defaultProfile = {
    name = "default",
    settings = core.defaultSettings,
}
