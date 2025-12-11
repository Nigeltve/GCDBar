local addonName, ns = ...

ns.debug = true
ns.logLevel = 0

ns.logTypes = {
    INFO = "INFO",
    DEBUG = "DEBUG",
    WARNING = "WARNING",
    ERROR = "ERROR"
}

ns.eventNames = {
	ADDON_LOADED = "ADDON_LOADED",
    PLAYER_LOGIN = "PLAYER_LOGIN",
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

ns.textures = {
    test = "Interface\\AddOns\\GCDBar\\Media\\smile.png",
    default = "Interface\\AddOns\\GCDBar\\Media\\Flat.tga",
	bantoBar = "Interface\\AddOns\\GCDBar\\Media\\BantoBar.tga",
    outline = "Interface\\AddOns\\GCDBar\\Media\\Outline.tga"
}

ns.spellIds = {
	GCD = 61304
}

ns.defaults ={
    barEnabled = true,
	posX = 0,
	posY = 0,
	width = 144,
	height = 17,
	barColor =  { r = 1, g = 1, b = 1 , a = 1},
	bgColor =  { r = 0.3, g = 0.3, b = 0.3 , a = 0.75},
    outlineColor = { r = 0, g = 0, b = 0, a = 1 },
	defaultTexture = ns.textures.default,
    defaultBG = ns.textures.default,
    defaultOutline =  ns.textures.outline,
	statusBarMin = 0,
	statusBarmax = 1,
	strata = ns.stratas.LOW,
    boarderSize = 2
}