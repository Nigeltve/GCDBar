---@class ns
local ns = select(2, ...)

ns.debug = true
ns.logLevel = 0

ns.logTypes = {
    INFO = "INFO",
    DEBUG = "DEBUG",
    WARNING = "WARNING",
    ERROR = "ERROR"
}

function ns:logLevelConvert(level)
	if not type(level) == "number" then
		return
	end 

	if level == 0 then return ns.logTypes.ERROR end
	if level == 1 then return ns.logTypes.WARNING end
	if level == 2 then return ns.logTypes.DEBUG end
	if level == 3 then return ns.logTypes.INFO end
end

function ns:logTypeConvert(level)
	if not type(level) == "string" then
		return
	end

	if level == ns.logTypes.ERROR then return 0  end
	if level == ns.logTypes.WARNING then return 1 end
	if level == ns.logTypes.DEBUG then return 2 end
	if level == ns.logTypes.INFO then return 3 end
end

ns.eventNames = {
	ADDON_LOADED = "ADDON_LOADED",
    PLAYER_LOGIN = "PLAYER_LOGIN",
	PLAYER_LOGOUT = "PLAYER_LOGOUT",
    PLAYER_ENTERING_WORLD = "PLAYER_ENTERING_WORLD",
    SPELL_CD_UPDATE = "SPELL_UPDATE_COOLDOWN",
    ACTIONBAR_CD_UPDATE = "ACTIONBAR_UPDATE_COOLDOWN",
    SPELLCAST_SUCCEEDED = "UNIT_SPELLCAST_SUCCEEDED",
    SPELLCAST_START = "UNIT_SPELLCAST_START",
    SPELLCAST_SENT = "UNIT_SPELLCAST_SENT"
}

ns.units = {
    PLAYER= "player"
}

ns.stratas = {
    BACKGROUND = "BACKGROUND",
    LOW = "LOW",
    MEDIUM = "MEDIUM",
    HIGH ="HIGH",
    DIALOG ="DIALOG",
    FULLSCREEN ="FULLSCREEN",
    FULLSCREEN_DIALOG= "FULLSCREEN_DIALOG",
    TOOLTIP = "TOOLTIP"
}

ns.barTextures = {
    default = "Interface\\AddOns\\GCDBar\\Media\\Flat.tga",
	bantoBar = "Interface\\AddOns\\GCDBar\\Media\\BantoBar.tga",
}

ns.outlinetextures = {
	outline = "Interface\\AddOns\\GCDBar\\Media\\Outline.tga"
}

ns.spellIds = {
	GCD = 61304
}

---@class defaults
ns.defaults = {
	barEnabled = true,
	posX = 0,
	posY = 0,
	width = 144,
	height = 17,
	barColor =  { r = 1, g = 1, b = 1 , a = 1},
	bgColor =  { r = 0.3, g = 0.3, b = 0.3 , a = 0.75},
	outlineColor = { r = 0, g = 0, b = 0, a = 1 },
	defaultTexture = ns.barTextures.default,
	defaultBG = ns.barTextures.default,
	defaultOutline =  ns.outlinetextures.outline,
	statusBarMin = 0,
	statusBarmax = 1,
	strata = ns.stratas.LOW,
	boarderSize = 2,
	fillReverse = false,
	endFilled = true
}

ns.command = {
	debug = "debug",
	loglevel = "loglevel",
	printdb = "printdb",
	show = "show",
	hide = "hide",
	toggle = "toggle",
	reset = "reset",
	help = "help"
}
