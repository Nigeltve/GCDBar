---@type Core
local core = select(2, ...)

core.barManager = {
	config = {
		barDimMax = 2000,
		barDimMin = 15,
		barFillMin = 0,
		barFillMax = 1,
		edgeSize = 7
	},
	state = {
		locked = true,
		initialized = false,
		resizeEdge = nil,
		animTicker = nil,
		animStart = nil,
		animDuration = nil,
	},
	visual = {
		fgBar = nil,
		bgBar = nil,
		text = nil,
		border = nil,
		ehRight = nil,
		ehLeft = nil,
		ehTop = nil,
		ehBottom = nil,
	},

	Create = function(self)
		local bar = CreateFrame("StatusBar", nil, UIParent, UIParent)
		bar:SetMinMaxValues(self.config.barFillMin, self.config.barFillMax)
		bar:SetValue(1)

		bar:RegisterEvent(core.enums.events.PLAYER_ENTERING_WORLD)
		bar:RegisterUnitEvent(core.enums.events.SPELLCAST_START, core.enums.units.PLAYER)
		bar:RegisterUnitEvent(core.enums.events.SPELLCAST_SUCCEEDED, core.enums.units.PLAYER)

		local unlockText = bar:CreateFontString(nil, "OVERLAY")
		unlockText:SetFont(core.enums.textures.fonts.default, 12, "OUTLINE")
		unlockText:SetPoint("CENTER", bar, "CENTER", 0, 0)

		local border = CreateFrame("Frame", nil, bar, "BackdropTemplate")

		local backGround = CreateFrame("StatusBar", nil, bar)
		backGround:SetMinMaxValues(self.config.barFillMin, self.config.barFillMax)
		backGround:SetValue(1)

		local EHLeft = bar:CreateTexture(nil, "OVERLAY")
		EHLeft:SetColorTexture(1, 1, 1, 0.5)
		EHLeft:SetWidth(self.config.edgeSize)
		EHLeft:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
		EHLeft:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)

		local EHRight = bar:CreateTexture(nil, "OVERLAY")
		EHRight:SetColorTexture(1, 1, 1, 0.5)
		EHRight:SetWidth(self.config.edgeSize)
		EHRight:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)
		EHRight:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)

		local EHTop = bar:CreateTexture(nil, "OVERLAY")
		EHTop:SetColorTexture(1, 1, 1, 0.5)
		EHTop:SetHeight(self.config.edgeSize)
		EHTop:SetPoint("TOPLEFT", bar, "TOPLEFT", 0, 0)
		EHTop:SetPoint("TOPRIGHT", bar, "TOPRIGHT", 0, 0)

		local EHBottom = bar:CreateTexture(nil, "OVERLAY")
		EHBottom:SetColorTexture(1, 1, 1, 0.5)
		EHBottom:SetHeight(self.config.edgeSize)
		EHBottom:SetPoint("BOTTOMLEFT", bar, "BOTTOMLEFT", 0, 0)
		EHBottom:SetPoint("BOTTOMRIGHT", bar, "BOTTOMRIGHT", 0, 0)

		self.visual.fgBar = bar
		self.visual.text = unlockText
		self.visual.bgBar = backGround
		self.visual.border = border
		self.visual.ehLeft = EHLeft
		self.visual.ehRight = EHRight
		self.visual.ehTop = EHTop
		self.visual.ehBottom = EHBottom
		self.state.initialized = true

		if core.profileManager.currentProfile or next(core.profileManager.currentProfile) == nil then
			core.logger:LogDebug("Initial Update")
			self:UpdateSettings(core.profileManager.currentProfile.settings)
		else
			core.logger:LogWarning("Coult not update bar on initilisation due to profile not existing")
		end

		self:HideHighLightedEdges()

		core.logger:LogDebug("Finished Creating Bars")
	end,

	UpdateSettings = function(self, settings)
		if not settings or settings == nil then
			core.logger:LogError("Settings nil")
			return;
		end

		if not self.state.initialized then
			core.logger:LogError("Is not initialized")
			return
		end

		core.logger:LogDebug("Updating bar")

		local fgBar = self.visual.fgBar
		local bgBar = self.visual.bgBar
		local border = self.visual.border
		local strata = core.enums.strata[settings.strata]
		local fgTexture = core.enums.textures.barTextures[settings.fgTexture]
		local bgTexture = core.enums.textures.barTextures[settings.bgTexture]
		local fgColor = settings.fgBarColor
		local bgColor = settings.bgBarColor
		local borderColor = settings.borderColor
		local frameLevel = 10

		if not settings.barEnabled then
			fgBar:Hide()
			return
		else
			fgBar:Show()
		end

		if not settings.borderEnabled or settings.borderSize <= 0 then
			border:Hide()
		else
			border:SetAllPoints(fgBar)
			border:SetBackdrop({
				edgeFile = core.enums.textures.outlineTextuers.default,
				edgeSize = settings.borderSize,
			})
			border:SetBackdropBorderColor(borderColor.R, borderColor.G, borderColor.B, borderColor.A)
			border:SetFrameStrata(strata)
			border:Show()
		end

		fgBar:ClearAllPoints()
		fgBar:SetPoint("CENTER", UIParent, "CENTER", settings.offSetX, settings.offSetY)
		fgBar:SetSize(settings.barWidth, settings.barHeight)
		fgBar:SetFrameStrata(strata)
		fgBar:SetFrameLevel(frameLevel)
		fgBar:SetStatusBarTexture(fgTexture)
		fgBar:SetStatusBarColor(fgColor.R, fgColor.G, fgColor.B, fgColor.A)

		if settings.fillVertical then
			fgBar:SetOrientation("VERTICAL")
		else
			fgBar:SetOrientation("HORIZONTAL")
		end

		if not settings.endFilled then
			fgBar:SetValue(0)
		end

		bgBar:SetPoint("CENTER")
		bgBar:SetSize(settings.barWidth, settings.barHeight)
		bgBar:SetFrameStrata(strata)
		bgBar:SetFrameLevel(fgBar:GetFrameLevel() - 1)
		bgBar:SetStatusBarTexture(bgTexture)
		bgBar:SetStatusBarColor(bgColor.R, bgColor.G, bgColor.B, bgColor.A)
	end,

	LockBar = function(self)
		if not self.state.initialized then
			core.logger:Say("Bar was not initialised")
			return
		end

		if not core.profileManager.currentProfile.settings.barEnabled then
			core.logger:LogWarning("Bar is Disabled")
			return
		end

		core.logger:LogDebug("Locking Bar")

		local bar = self.visual.fgBar
		local unlockText = self.visual.text

		core.logger:Say("Locked")

		unlockText:SetText("")

		self.state.locked = true

		bar:EnableMouse(false)
		bar:SetResizable(false)
		bar:SetMovable(false)

		bar:SetScript("OnMouseDown", nil)
		bar:SetScript("OnMouseUp", nil)
		bar:SetScript("OnUpdate", nil)
	end,

	UnlockBar = function(self)
		if not self.state.initialized then
			core.logger:Say("Bar was not initialised")
			return
		end

		if not core.profileManager.currentProfile.settings.barEnabled then
			core.logger:LogWarning("Bar is disabled")
			return
		end

		core.logger:LogDebug("Unlocking bar")

		local bar = self.visual.fgBar
		local unlockText = self.visual.text

		core.logger:Say("Unlocked")

		self.state.locked = false
		unlockText:SetText("Unlocked")

		bar:EnableMouse(true)
		bar:SetMovable(true)

		bar:SetResizable(true)
		bar:SetResizeBounds(self.config.barDimMin, self.config.barDimMin, self.config.barDimMax, self.config.barDimMax)
		bar:SetScript("OnMouseDown", function(_, button) self:OnMouseDown(button) end)
		bar:SetScript("OnMouseUp", function() self:OnMouseUp() end)
		bar:SetScript("OnUpdate", function() self:OnUpdate() end)
	end,

	HighlightEdge = function(self, edges)
		if not self.state.initialized then
			core.logger:LogWarning("Is not initialized")
			return
		end

		self:HideHighLightedEdges()
		if edges.middle then return end

		if edges.left then
			self.visual.ehLeft:Show()
		end

		if edges.right then
			self.visual.ehRight:Show()
		end

		if edges.top then
			self.visual.ehTop:Show()
		end

		if edges.bottom then
			self.visual.ehBottom:Show()
		end
	end,

	HideHighLightedEdges = function(self)
		self.visual.ehRight:Hide()
		self.visual.ehLeft:Hide()
		self.visual.ehTop:Hide()
		self.visual.ehBottom:Hide()
	end,

	GetCursorPosition = function(self)
		if not self.state.initialized then
			core.logger:LogWarning("Is not initialized")
			return 0, 0
		end

		local scale = self.visual.fgBar:GetEffectiveScale()
		local x, y = GetCursorPosition()
		x = x / scale
		y = y / scale

		return x, y
	end,

	GetCursorEdgeProximity = function(self)
		if not self.state.initialized then
			core.logger:LogWarning("Is not initialized")
			return { middle = false, right = false, left = false, top = false, bottom = false }
		end

		local x, y = self:GetCursorPosition()

		local bar = self.visual.fgBar
		local left = bar:GetLeft()
		local right = bar:GetRight()
		local top = bar:GetTop()
		local bottom = bar:GetBottom()

		if x < left or x > right or y < bottom or y > top then
			return { middle = false, right = false, left = false, top = false, bottom = false }
		end

		local edgeThreshold = self.config.edgeSize
		local nearLeft = (x - left) < edgeThreshold
		local nearRight = (right - x) < edgeThreshold
		local nearTop = (top - y) < edgeThreshold
		local nearBottom = (y - bottom) < edgeThreshold

		local middle = not nearLeft and not nearRight and not nearTop and not nearBottom
		return { middle = middle, right = nearRight, left = nearLeft, top = nearTop, bottom = nearBottom }
	end,

	OnUpdate = function(self)
		if not self.state.initialized then
			core.logger:LogWarning("Is not initialized")
			return
		end

		local bar = self.visual.fgBar
		local bgBar = self.visual.bgBar

		bgBar:SetSize(bar:GetWidth(), bar:GetHeight())

		local edges = self:GetCursorEdgeProximity()
		self:HighlightEdge(edges)
	end,

	OnMouseUp = function(self)
		if not self.state.initialized then
			core.logger:LogWarning("Is not initialized")
			return
		end

		core.logger:LogDebug("MouseUp")

		local bar = self.visual.fgBar
		local profile = core.profileManager.currentProfile

		if profile == nil then
			core.logger:LogError("No Profile is set")
			return
		end

		bar:StopMovingOrSizing()

		local _, _, _, offsetX, offsetY = bar:GetPoint()
		profile.settings.offSetX = offsetX
		profile.settings.offSetY = offsetY

		core.logger:LogDebug("bar OffSetX: " ..
			tostring(offsetX) .. " profile OffsetX: " .. tostring(profile.settings.offSetX))

		core.logger:LogDebug("bar OffSetY: " ..
			tostring(offsetY) .. " profile OffsetY: " .. tostring(profile.settings.offSetY))

		profile.settings.barWidth = bar:GetWidth()
		profile.settings.barHeight = bar:GetHeight()

		self.state.resizeEdge = nil

		self:UpdateSettings(profile.settings)
		core.utils:UpdateOptions()
	end,

	OnMouseDown = function(self, button)
		if not self.state.initialized then
			core.logger:LogWarning("Is not initialized")
			return
		end

		core.logger:LogDebug("MouseDown: " .. tostring(button))

		local bar = self.visual.fgBar
		if button == "RightButton" then
			bar:StartMoving()
			return
		end

		if button ~= "LeftButton" then return end

		core.logger:LogDebug("Clicked Left")

		local left = bar:GetLeft()
		local right = bar:GetRight()
		local top = bar:GetTop()
		local bottom = bar:GetBottom()

		local edge = self:GetCursorEdgeProximity()

		if edge.middle then
			bar:StartMoving()
			return
		end

		if edge.left or edge.right or edge.top or edge.bottom then
			local resizeEdge = self:GetAnchorPoint(edge)
			if not resizeEdge then return end

			local config = self:GetResizeConfig(resizeEdge, left, right, top, bottom)
			if not config then return end

			self.state.resizeEdge = resizeEdge
			bar:SetResizable(true)
			bar:ClearAllPoints()
			bar:SetPoint(config[1], UIParent, "BOTTOMLEFT", config[2], config[3])
			bar:StartSizing(self.state.resizeEdge)
		end
	end,

	GetAnchorPoint = function(self, edge)
		if not self.state.initialized then
			core.logger:LogWarning("Is not initialized")
			return
		end

		if edge.left and edge.top then
			return "TOPLEFT"
		elseif edge.left and edge.bottom then
			return "BOTTOMLEFT"
		elseif edge.right and edge.top then
			return "TOPRIGHT"
		elseif edge.right and edge.bottom then
			return "BOTTOMRIGHT"
		elseif edge.left then
			return "LEFT"
		elseif edge.right then
			return "RIGHT"
		elseif edge.top then
			return "TOP"
		elseif edge.bottom then
			return "BOTTOM"
		end
		return nil
	end,

	GetResizeConfig = function(self, edge, left, right, top, bottom)
		if not self.state.initialized then
			core.logger:LogWarning("Is not initialized")
			return
		end

		local configs = {
			TOPLEFT = { "BOTTOMRIGHT", right, bottom },
			BOTTOMLEFT = { "TOPRIGHT", right, top },
			TOPRIGHT = { "BOTTOMLEFT", left, bottom },
			BOTTOMRIGHT = { "TOPLEFT", left, top },
			LEFT = { "TOPRIGHT", right, top },
			RIGHT = { "TOPLEFT", left, top },
			TOP = { "BOTTOMLEFT", left, bottom },
			BOTTOM = { "TOPLEFT", left, top }
		}
		return configs[edge]
	end,

	StartAnimation = function(self)
		if not self.state.initialized then
			core.logger:LogWarning("Is not initialized")
			return
		end

		local start, duration, _ = core.utils:ReadSpellCooldown(core.enums.spellIds.GCD)

		if core.utils:IsMidNight() and not canaccessvalue(duration) then
			self:StopAnimation()
			return
		end

		if start and duration then
			self:StopAnimation()

			self.state.animStart = start
			self.state.animDuration = duration
			self.state.animTicker = C_Timer.NewTicker(0.016, function() self:UpdateFill() end)
		end
	end,

	StopAnimation = function(self)
		if not self.state.initialized then
			core.logger:LogWarning("Is not initialized")
			return
		end

		if not self.state.animTicker then
			return
		end

		self.state.animTicker:Cancel()
		self.state.animTicker = nil
		self.state.animStart = nil
		self.state.animDuration = nil
	end,

	UpdateFill = function(self)
		if not self.state.initialized then
			return
		end

		local bar = self.visual.fgBar

		if not self.state.animStart or not self.state.animDuration or self.state.animDuration <= 0 then
			self:StopAnimation()
			return
		end

		local elapsed = GetTime() - self.state.animStart
		local progress = elapsed / self.state.animDuration

		if progress >= 1
		then
			progress = 1
			self:StopAnimation()
			if core.profileManager.currentProfile.settings.endFilled then
				bar:SetValue(1)
			else
				bar:SetValue(0)
			end
			return;
		end

		if core.profileManager.currentProfile.settings.reverseFill then
			bar:SetValue(1 - progress)
		else
			bar:SetValue(progress)
		end
	end
}
