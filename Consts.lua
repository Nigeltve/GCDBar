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
    test = "Interface\\AddOns\\TestAddon\\media\\smile.png",
	bantoBar = "Interface\\AddOns\\TestAddon\\media\\BantoBar.tga",
	default = "Interface\\AddOns\\TestAddon\\media\\Flat.tga"
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
	defaultTexture = ns.textures.default,
	statusBarMin = 0,
	statusBarmax = 1,
	strata = ns.stratas.LOW
}