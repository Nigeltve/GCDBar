---@type Core
local core = select(2, ...)

---@type ProfileManager
core.profileManager = {
	profiles            = {},
	currentProfile      = nil,
	defaultProfile      = {
		name = "default",
		settings = {
			barEnabled = true,
			offSetX = 0,
			offSetY = -80,
			barWidth = 144,
			barHeight = 17,
			borderSize = 2,
			borderEnabled = true,
			fgBarColor = { R = 1, G = 1, B = 1, A = 1 },
			bgBarColor = { R = 0.3, G = 0.3, B = 0.3, A = 0.75 },
			borderColor = { R = 0, G = 0, B = 0, A = 1 },
			fgTexture = core.enums.textures.barChoices.default,
			bgTexture = core.enums.textures.barChoices.default,
			strata = core.enums.strata.LOW,
			endFilled = true,
			reverseFill = false,
			fillVertical = false
		}
	},

	Setup               = function(self, profiles)
		if next(self.profiles) == nil then
			self.profiles["default"] = CopyTable(self.defaultProfile)
		end

		for _, p in pairs(profiles) do
			self.profiles[p.name] = CopyTable(p)
		end
	end,

	PrintProfileNames   = function(self)
		for _, v in pairs(self.profiles) do
			core.logger:Say(v.name)
		end
	end,

	GetProfileNames     = function(self)
		local profiles = {}
		for k, v in pairs(self.profiles) do
			profiles[k] = k
		end
		return profiles
	end,

	CreateProfile       = function(self, name)
		if string.len(name) <= 0 then
			core.logger:Say("Cannot create a profile with no name")
			return false
		end

		if not self:ValidateName(name) then
			core.logger:Say("New profile name invalid")
			core.logger:Say("cannot have puncuation apart from _ or spaces")
		end

		if self:ProfileExists(name) then
			core.logger:Say("Profile already exists! either reset with /cdb reset or delete with /cdp delete {name}")
			return false
		end

		local newProfile = CopyTable(self.defaultProfile)
		newProfile.name = string.lower(name)

		self.profiles[newProfile.name] = newProfile
		self:SwapToProfile(newProfile.name)
		core.logger:Say("Created profile: " .. newProfile.name)
		return true
	end,

	DeleteProfile       = function(self, name)
		local currentProfile = self:GetCurrentProfile()

		if currentProfile.name == name then
			core.logger:Say("Cannot delete current acative profile! Please swap to a different profile")
			return false
		end

		if name == self.defaultProfile.name then
			core.logger:Say("Cannot delete the default profile")
			return false
		end

		self.profiles[name] = nil
		core.logger:Say("Deleted profile: " .. name)
		return true
	end,

	SwapToProfile       = function(self, name)
		local profile = self:GetCurrentProfile()
		if profile.name == name then
			core.logger:Say("Profile already active")
			return false
		end

		if not self:ProfileExists(name) then
			core.logger:Say("Profile doesnt exist")
			return false
		end

		self:SaveProfile()
		core.profileManager.currentProfile = self.profiles[name]
		core.barManager:UpdateSettings(core.profileManager.currentProfile.settings)
		core.utils:UpdateOptions()
		core.logger:Say("Swapped Profile: " .. name)

		return true
	end,

	ProfileExists       = function(self, name)
		local nextProfile = self.profiles[name]
		return nextProfile ~= nil and next(nextProfile) ~= nil
	end,

	GetCurrentProfile   = function(self)
		return core.profileManager.currentProfile
	end,

	ValidateName        = function(self, name)
		local regex = "^[a-zA-Z0-9_]+$"
		return string.match(name, regex) and #name >= 4
	end,

	SaveProfile         = function(self)
		for _, profile in pairs(self.profiles) do
			if profile.name == self.currentProfile.name then
				profile = self.currentProfile
				return true
			end
		end

		return false
	end,

	ClearAllProfiles    = function(self)
		for name, _ in pairs(self.profiles) do
			core.logger:LogDebug("Looking at profile: " .. tostring(name))
			if name ~= self.defaultProfile.name then
				core.logger:LogDebug("profile is not " .. tostring(self.defaultProfile.name))
				self.profiles[name] = nil
			end
		end

		local swapStatus = self:SwapToProfile(self.defaultProfile.name)
		local resetStatus = self:ResetCurrentProfile()

		core.logger:LogDebug("SwapStatus: " .. tostring(swapStatus))
		core.logger:LogDebug("resetStatus: " .. tostring(resetStatus))

		ReloadUI()
		core.utils:UpdateOptions()
		return true
	end,

	ResetCurrentProfile = function(self)
		core.profileManager.currentProfile.settings = CopyTable(core.profileManager.defaultProfile.settings)
		core.barManager:UpdateSettings(core.profileManager.currentProfile.settings)
		core.utils:UpdateOptions()
		return true
	end
}
