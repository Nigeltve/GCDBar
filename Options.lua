---@type Core
local core = select(2, ...)

--[[ -- Suppress the 12.0 beta SetText(alpha) range error from AceConfig/Settings,
do
	local oldHandler = geterrorhandler()

	seterrorhandler(function(msg)
		if type(msg) == "string" and msg:find("Usage: self:SetText(text [, color, alpha, wrap])", 1, true) then
			-- Swallow only this known harmless error (AceConfig dropdown hover in 12.0)
			return
		end

		-- Everything else goes to the normal error handler
		return oldHandler(msg)
	end)
end

-- ---------------------------------------------------------------------------
-- Patch AceGUI widget SetText to clamp bad alpha values
-- ---------------------------------------------------------------------------
do
	local AceGUI = LibStub and LibStub("AceGUI-3.0", true)
	if AceGUI and AceGUI.WidgetRegistry and not core._aceSetTextPatched then
		for _, widget in pairs(AceGUI.WidgetRegistry) do
			if type(widget) == "table" and type(widget.SetText) == "function" then
				local orig = widget.SetText
				widget.SetText = function(self, text, r, g, b, a, wrap, ...)
					if type(a) ~= "number" or a ~= a or a < -3.402823e+38 or a > 3.402823e+38 then
						a = 1
					end
					return orig(self, text, r, g, b, a, wrap, ...)
				end
			end
		end
		core._aceSetTextPatched = true
	end
end
]]

-- spacer

---@param order number
---@param width number | string
---@return table
local function CreateSpacer(order, width)
	local spacer = {
		type  = "description",
		name  = "",
		order = order,
		width = width,
	}

	return spacer
end

-- general --

local function Setter(info, val)
	local argType = info[#info]
	core.profileManager.currentProfile.settings[argType] = val
	core.barManager:UpdateSettings(core.profileManager.currentProfile.settings)
end

local function Getter(info)
	local argType = info[#info]
	return core.profileManager.currentProfile.settings[argType]
end

-- Color --
local function SetColor(info, red, green, blue, alpha)
	local argType = info[#info]
	local newColor = { R = red, G = green, B = blue, A = alpha }
	core.profileManager.currentProfile.settings[argType] = newColor
	core.barManager:UpdateSettings(core.profileManager.currentProfile.settings)
end

local function GetColor(info)
	local argType = info[#info]
	local color = core.profileManager.currentProfile.settings[argType] or { R = 1, G = 1, B = 1, A = 1 }
	return color.R, color.G, color.B, color.A
end

local function IsboarderDisabled(info)
	local argType = info[#info]
	if argType == "boarderSize" or argType == "boarderColor" then
		return not core.profileManager.currentProfile.settings.borderEnabled
	end
	return false
end

-- profiles --

local profileToEdit = nil
local newProfileName = ""

local function ProfileSetter(info, val)
	local argType = info[#info]
	if argType == "profileNames" then
		profileToEdit = val
		return profileToEdit
	end
end

local function ProfileGetter(info)
	local argType = info[#info]
	if argType == "profileNames" then
		if not profileToEdit then
			profileToEdit = core.profileManager:GetCurrentProfile().name
		end
		return profileToEdit
	end
end

-- --------------------------------------------------
-- AceConfig options table
-- --------------------------------------------------
local options = {
	type = "group",
	name = "GCD Bar",
	args = {
		-- General --
		header = {
			type  = "header",
			name  = "GCD Bar",
			order = 0,
		},
		desc = {
			type  = "description",
			name  = "Shows GCD in a bar format",
			order = 1,
		},
		generalPad = {
			type  = "description",
			name  = "",
			order = 2,
		},
		generalWarning = {
			type  = "description",
			name  = "Still under development, things might be broken",
			order = 3,
		},
		generalPad2 = {
			type  = "description",
			name  = "",
			order = 4,
		},
		appearance = {
			type   = "group",
			name   = "Appearance",
			inline = true,
			order  = 10,
			args   = {
				barEnabled = {
					type  = "toggle",
					name  = "ShowGCDBar",
					desc  = "Set GCD Bar Visibility",
					set   = Setter,
					get   = Getter,
					order = 10,
				},
				LockToggle = {
					type = "execute",
					name = "Move Bar",
					func = function()
						if core.barManager.state.locked then
							core.barManager:UnlockBar()
						else
							core.barManager:LockBar()
						end
					end,
					order = 10.5,
					width = 0.7,
					disabled = function()
						return not core.profileManager.currentProfile.settings.barEnabled
					end

				},
				spacer3 = CreateSpacer(10.6, 0.1),
				fillVertical = {
					type  = "toggle",
					name  = "Fill Vertical",
					desc  = "Sets the bar fill directions",
					set   = Setter,
					get   = Getter,
					order = 10.7
				},
				offSetX = {
					type  = "range",
					name  = "Horizontal Offset",
					set   = Setter,
					get   = Getter,
					min   = -2000,
					max   = 2000,
					step  = 1,
					order = 11,
					width = "full",
				},
				offSetY = {
					type  = "range",
					name  = "Vertical Offset",
					set   = Setter,
					get   = Getter,
					min   = -2000,
					max   = 2000,
					step  = 1,
					order = 12,
					width = "full",
				},
				fgTexture = {
					type   = "select",
					name   = "Forground Texture",
					set    = Setter,
					get    = Getter,
					values = core.enums.textures.barChoices,
					order  = 13,
					width  = "full",
					style  = "dropdown"
				},
				bgTexture = {
					type   = "select",
					name   = "Background Texture",
					set    = Setter,
					get    = Getter,
					values = core.enums.textures.barChoices,
					order  = 14,
					width  = "full",
					style  = "dropdown"
				},
				fgBarColor = {
					type     = "color",
					name     = "Forground Color",
					hasAlpha = true,
					set      = SetColor,
					get      = GetColor,
					order    = 15,
					width    = 0.8,
				},
				bgBarColor = {
					type     = "color",
					name     = "Background Color",
					hasAlpha = true,
					set      = SetColor,
					get      = GetColor,
					order    = 16,
					width    = 0.8,
				},
				barWidth = {
					type  = "range",
					name  = "Bar Width",
					set   = Setter,
					get   = Getter,
					min   = core.barManager.config.barDimMin,
					max   = core.barManager.config.barDimMax,
					step  = 1,
					order = 17,
					width = "full"
				},
				barHeight = {
					type  = "range",
					name  = "Bar Height",
					set   = Setter,
					get   = Getter,
					min   = core.barManager.config.barDimMin,
					max   = core.barManager.config.barDimMax,
					step  = 1,
					order = 18,
					width = "full"
				},
				borderEnabled = {
					type  = "toggle",
					name  = "Enable Boarder",
					desc  = "Set Boarder Visibility",
					set   = Setter,
					get   = Getter,
					order = 19,
					width = 1,
				},
				borderColor = {
					type     = "color",
					name     = "Outline Color",
					hasAlpha = true,
					set      = SetColor,
					get      = GetColor,
					disabled = IsboarderDisabled,
					order    = 20,
					width    = 1,
				},
				borderSize = {
					type     = "range",
					name     = "Boarder Size",
					set      = Setter,
					get      = Getter,
					min      = 0,
					max      = 20,
					step     = 1,
					disabled = IsboarderDisabled,
					order    = 21,
					width    = 1
				},
				strata = {
					type   = "select",
					name   = "Bar Strata",
					set    = Setter,
					get    = Getter,
					values = core.enums.strata,
					order  = 22,
					width  = "full",
					style  = "dropdown"
				}
			}
		},

		profiles = {
			type   = "group",
			name   = "Profiles",
			inline = true,
			order  = 30,
			args   = {
				profileNames = {
					type   = "select",
					name   = "Profile",
					set    = ProfileSetter,
					get    = ProfileGetter,
					values = function()
						return core.profileManager:GetProfileNames()
					end,
					order  = 31,
					style  = "dropdown",
					width  = "full",
				},
				SwapProfile = {
					type = "execute",
					name = "Swap to",
					desc = "Tries to swap sthe profile with the name in the dropdown",
					func = function()
						if profileToEdit == nil then
							return
						end

						core.profileManager:SwapToProfile(profileToEdit)
					end,
					order = 32,
					width = 0.7
				},
				spacer1 = CreateSpacer(32.5, 0.05),
				deleteProfile = {
					type = "execute",
					name = "Delete Profile",
					desc = "Tries to delete the profile with the name in the dropdown",
					func = function()
						if profileToEdit == nil then
							return
						end

						if core.profileManager:DeleteProfile(profileToEdit) then
							profileToEdit = core.profileManager:GetCurrentProfile().name
						end
					end,
					order = 33,
					width = 0.7
				},
				spacer2 = CreateSpacer(33.5, 0.1),
				profileNameInput = {
					type = "input",
					name = "New Profile Name",
					set = function(_, val)
						newProfileName = val
					end,
					get = function()
						return newProfileName
					end,
					order = 34
				},
				spacer3 = CreateSpacer(34.5, 0.1),
				createProfile = {
					type = "execute",
					name = "Create",
					func = function()
						if newProfileName == "" then
							return
						end

						local success = core.profileManager:CreateProfile(newProfileName)
						if not success then
							newProfileName = ""
							return
						end
						profileToEdit = newProfileName
						newProfileName = ""
					end,
					order = 35,
					width = 0.7
				},
				currentProfileName = {
					type = "description",
					name = "Current Profile: " .. tostring(ProfileName),
					order = 36,
					width = "full"
				}
			}
		},

		help = {
			type   = "group",
			name   = "Help",
			inline = true,
			order  = 40,
			args   = {
				helpText = {
					type  = "description",
					name  = [[
Slash commands:
/cdb show           – Show GCD Bar
/cdb hide           – Hide GCD Bar
/cdb toggle         – Toggle visibility
/cdb reset          – Reset to defaults
/cdb options        – brings up options
/cdb list           – Lists out all profile names
/cdb current        – Lists out the current profile name
/cdb create {name}  – creates a new profile and swaped with provided name
/cdb delete {name}  – deletes profile with provided name
/cdb swap {name}    – switches to profile with provided name]],
					order = 10,
				},
			},
		},
	}
}


local AceConfig       = LibStub("AceConfig-3.0")
local AceConfigDialog = LibStub("AceConfigDialog-3.0")

AceConfig:RegisterOptionsTable("GCDBar", options)
local panel = AceConfigDialog:AddToBlizOptions("GCDBar", "GCD Bar")
local function AddSub(name, path)
	return AceConfigDialog:AddToBlizOptions("GCDBar", name, "GCD Bar", path)
end

AddSub("Appearance", "appearance")
AddSub("Profiles", "profiles")
AddSub("Help", "help")
