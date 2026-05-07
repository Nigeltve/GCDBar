---@class BarManager: table
---@field config BarConfig
---@field state BarState
---@field visual BarVisuals
---@field UpdateSettings fun(self: BarManager, settings: Settings)
---@field LockBar fun(self: BarManager)
---@field UnlockBar fun(self: BarManager)
---@field Create fun(self: BarManager)
---@field HighlightEdge fun(self: BarManager, edge: Edge)
---@field HideHighLightedEdges fun(self: BarManager)
---@field GetCursorPosition fun(self: BarManager): (x: number, y: number)
---@field GetCursorEdgeProximity fun(self: BarManager): edges: Edge
---@field OnUpdate fun(self: BarManager)
---@field OnMouseUp fun(self: BarManager)
---@field OnMouseDown fun(self: BarManager, Button: string)
---@field GetAnchorPoint fun(self: BarManager, edge: Edge): anchor: string?
---@field GetResizeConfig fun(self:BarManager, resizeEdge: string, left: number, right: number, top: number, bottom: number) : config: table?
---@field StartAnimation fun(self: BarManager)
---@field StopAnimation fun(self: BarManager)
---@field UpdateFill fun(self: BarManager)

---@class BarState: table
---@field locked boolean
---@field initialized boolean
---@field resizeEdge string
---@field animStart number
---@field animDuration number
---@field animGroup AnimationGroup
---@field animDummy Animation

---@class BarConfig: table
---@field barDimMax number
---@field barDimMin number
---@field barFillMin number
---@field barFillMax number
---@field edgeSize number

---@class BarVisuals: table
---@field fgBar StatusBar
---@field bgBar StatusBar
---@field text FontString
---@field border BackdropTemplate | Frame
---@field ehRight Texture
---@field ehLeft Texture
---@field ehTop Texture
---@field ehBottom Texture
---@field animFrame Frame

---@class Edge: table
---@field middle boolean
---@field right boolean
---@field left boolean
---@field top boolean
---@field bottom boolean

---@class ProfileManager: table
---@field profiles Profile[]
---@field currentProfile Profile?	
---@field defaultProfile Profile
---@field Setup fun(self: ProfileManager, Profiles: Profile[])
---@field PrintProfileNames fun(self: ProfileManager)
---@field GetProfileNames fun(self: ProfileManager):  names: string[]
---@field CreateProfile fun (self: ProfileManager, name: string): created: boolean
---@field SwapToProfile fun(self: ProfileManager, name: string): swapped: boolean
---@field DeleteProfile fun(self: ProfileManager, name: string): deleted: boolean
---@field SaveProfile fun(self: ProfileManager): saved: boolean
---@field ClearAllProfiles fun(self: ProfileManager): cleared: boolean
---@field ResetCurrentProfile fun(self: ProfileManager): reset: boolean
---@field GetCurrentProfile fun(self: ProfileManager): currentProfile: Profile
---@field ProfileExists fun(self: ProfileManager, name: string): exists: boolean
---@field ValidateName fun(self: ProfileManager, name: string): isValid: boolean

---@class Profile: table
---@field name string
---@field settings Settings

---@class Color : table
---@field R number
---@field G number
---@field B number
---@field A number

---@class Settings : table
---@field barEnabled boolean
---@field reverseFill boolean
---@field endFilled boolean
---@field fillVertical boolean
---@field anchorPoint FramePoint
---@field offSetX number
---@field offSetY number
---@field barWidth number
---@field barHeight number
---@field borderEnabled boolean
---@field borderSize number
---@field fgBarColor Color
---@field bgBarColor Color
---@field borderColor Color
---@field fgTexture string
---@field bgTexture string
---@field strata string

---@class Utils: table
---@field IsMidNight fun(self: Utils): isMidNight: boolean
---@field ReadSpellCooldown fun(self: Utils, spellId: number): startTime: number, duration: number, modRate: number
---@field UpdateOptions fun(self: Utils)

---@class Logger: table
---@field canDebug boolean
---@field logLevel number
---@field Say fun(self: Logger, msg: string)
---@field LogInfo fun(self: Logger, msg: string)
---@field LogDebug fun(self: Logger, msg: string)
---@field LogWarning fun(self: Logger, msg: string)
---@field LogError fun(self: Logger, msg: string)
---@field Dump fun(self: Utils, tbl: table)

---@class Enums: table
---@field units Units
---@field strata Strata
---@field events Events
---@field textures Texture
---@field commands Commands
---@field spellIds SpellIds

---@class Units: table
---@field PLAYER string

---@class Strata: table
---@field BACKGROUND string
---@field LOW string
---@field MEDIUM string
---@field HIGH string
---@field DIALOG string
---@field FULLSCREEN string
---@field FULLSCREEN_DIALOG string
---@field TOOLTIP string

---@class Events: table
---@field ADDON_LOADED string
---@field PLAYER_LOGIN string
---@field PLAYER_LOGOUT string
---@field PLAYER_ENTERING_WORLD string
---@field PLAYER_LEAVING_WORLD string
---@field SPELLCAST_SUCCEEDED string
---@field SPELLCAST_START string

---@class Texture: table
---@field barTextures BarTextures
---@field barChoices BarChoices
---@field outlineTextuers OutlineTextuers
---@field fonts Fonts

---@class BarTextures: table
---@field default string
---@field bantoBar string

---@class BarChoices: table
---@field default string
---@field bantoBar string

---@class OutlineTextuers: table
---@field default string

---@class Fonts: table
---@field default string

---@class Commands: table
---@field show string
---@field hide string
---@field toggle string
---@field reset string
---@field lock string
---@field unlock string
---@field list string
---@field current string
---@field create string
---@field delete string
---@field switch string
---@field clearAll string
---@field options string
---@field help string

---@class SpellIds: table
---@field GCD number

---@class Core: table
---@field logger Logger
---@field utils Utils
---@field barManager BarManager
---@field profileManager ProfileManager
---@field enums Enums
