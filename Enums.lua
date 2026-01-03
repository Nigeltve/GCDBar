---@type Core
local core = select(2, ...)

core.enums = core.enums or {}

---@type Events
core.enums.events = {
	ADDON_LOADED = "ADDON_LOADED",
	PLAYER_LOGIN = "PLAYER_LOGIN",
	PLAYER_LOGOUT = "PLAYER_LOGOUT",
	PLAYER_ENTERING_WORLD = "PLAYER_ENTERING_WORLD",
	PLAYER_LEAVING_WORLD = "PLAYER_LEAVING_WORLD",
	SPELLCAST_SUCCEEDED = "UNIT_SPELLCAST_SUCCEEDED",
	SPELLCAST_START = "UNIT_SPELLCAST_START",
}

---@type Units
core.enums.units = {
	PLAYER = "player"
}

---@type Strata
core.enums.strata = {
	BACKGROUND = "BACKGROUND",
	LOW = "LOW",
	MEDIUM = "MEDIUM",
	HIGH = "HIGH",
	DIALOG = "DIALOG",
	FULLSCREEN = "FULLSCREEN",
	FULLSCREEN_DIALOG = "FULLSCREEN_DIALOG",
	TOOLTIP = "TOOLTIP"
}

---@type Commands
core.enums.commands = {
	show = "show",
	hide = "hide",
	toggle = "toggle",
	reset = "reset",
	lock = "lock",
	unlock = "unlock",
	list = "list",
	current = "current",
	create = "create",
	delete = "delete",
	switch = "swap",
	clearAll = "clearall",
	options = "options",
	help = "help",
}

core.enums.textures = core.enums.textures or {}

---@type BarTextures
core.enums.textures.barTextures = {
	default = "Interface\\AddOns\\GCDBar\\Media\\Flat.tga",
	bantoBar = "Interface\\AddOns\\GCDBar\\Media\\BantoBar.tga",
}

---@type BarChoices
core.enums.textures.barChoices = {
	default = "default",
	bantoBar = "bantoBar",
}

---@type OutlineTextuers
core.enums.textures.outlineTextuers = {
	default = "Interface\\Buttons\\WHITE8X8"
}

---@type Fonts
core.enums.textures.fonts = {
	default = "Fonts\\FRIZQT__.TTF"
}

---@type SpellIds
core.enums.spellIds = {
	GCD = 61304
}
