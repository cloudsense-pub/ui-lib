-- addons/SaveManager.lua
-- LinoriaLib-compatible SaveManager + 1:1 ech0.fun Configurations Card Grid & Modal
-- Repository: https://github.com/cloudsense-pub/ui-lib
-- Raw URL:    https://raw.githubusercontent.com/cloudsense-pub/ui-lib/main/addons/SaveManager.lua

local HttpService = game:GetService("HttpService")

local SaveManager = {}
do
	SaveManager.Folder = "ech0fun_configs"
	SaveManager.SubFolder = ""
	SaveManager.Ignore = {}
	SaveManager.Library = nil
	SaveManager.MemoryFiles = {}

	local function HasFS()
		return type(writefile) == "function"
			and type(readfile) == "function"
			and type(isfile) == "function"
			and type(isfolder) == "function"
			and type(makefolder) == "function"
	end

	local function DisposeNode(inst)
		if not inst then
			return
		end
		pcall(function()
			inst:ClearAllChildren()
			inst.Parent = nil
		end)
	end

	local function FormatTimestamp(unixTime)
		local ok, str = pcall(function()
			local dt = os.date("*t", unixTime or os.time())
			return string.format("%02d/%02d %02d:%02d", dt.month, dt.day, dt.hour, dt.min)
		end)
		return ok and str or "01/01 12:00"
	end

	SaveManager.Parser = {
		Toggle = {
			Save = function(idx, object)
				return { type = "Toggle", idx = idx, value = object.Value == true }
			end,
			Load = function(idx, data)
				local t = SaveManager.Library.Toggles[idx]
				if t then
					t:SetValue(data.value == true)
				end
			end,
		},
		Slider = {
			Save = function(idx, object)
				return { type = "Slider", idx = idx, value = tostring(object.Value) }
			end,
			Load = function(idx, data)
				local o = SaveManager.Library.Options[idx]
				if o then
					o:SetValue(tonumber(data.value) or o.Min)
				end
			end,
		},
		Dropdown = {
			Save = function(idx, object)
				return { type = "Dropdown", idx = idx, value = object.Value, mutli = object.Multi }
			end,
			Load = function(idx, data)
				local o = SaveManager.Library.Options[idx]
				if o then
					o:SetValue(data.value)
				end
			end,
		},
		ColorPicker = {
			Save = function(idx, object)
				return {
					type = "ColorPicker",
					idx = idx,
					value = object.Value:ToHex(),
					transparency = object.Transparency or 0,
					rainbow = object.Rainbow == true,
				}
			end,
			Load = function(idx, data)
				local o = SaveManager.Library.Options[idx]
				if o and type(data.value) == "string" then
					local ok, col = pcall(Color3.fromHex, data.value)
					if ok and col then
						o:SetValueRGB(col, tonumber(data.transparency) or 0)
					end
					if o.SetRainbow then
						o:SetRainbow(data.rainbow == true)
					end
				end
			end,
		},
		KeyPicker = {
			Save = function(idx, object)
				return {
					type = "KeyPicker",
					idx = idx,
					mode = object.Mode,
					key = object.Value,
				}
			end,
			Load = function(idx, data)
				local o = SaveManager.Library.Options[idx]
				if o then
					o:SetValue({ data.key or "None", data.mode or "Toggle" })
				end
			end,
		},
		Input = {
			Save = function(idx, object)
				return { type = "Input", idx = idx, text = tostring(object.Value or "") }
			end,
			Load = function(idx, data)
				local o = SaveManager.Library.Options[idx]
				if o and type(data.text) == "string" then
					o:SetValue(data.text)
				end
			end,
		},
		ListBox = {
			Save = function(idx, object)
				return { type = "ListBox", idx = idx, value = object.Value }
			end,
			Load = function(idx, data)
				local o = SaveManager.Library.Options[idx]
				if o and data.value ~= nil then
					o:SetValue(data.value)
				end
			end,
		},
		Curve = {
			Save = function(idx, object)
				return { type = "Curve", idx = idx, points = object.Value }
			end,
			Load = function(idx, data)
				local o = SaveManager.Library.Options[idx]
				if o and type(data.points) == "table" then
					o:SetValue(data.points)
				end
			end,
		},
	}

	function SaveManager:GetBasePath()
		local base = self.Folder .. "/settings"
		if self.SubFolder and self.SubFolder ~= "" then
			base = base .. "/" .. self.SubFolder
		end
		return base
	end

	function SaveManager:BuildFolderTree()
		if not HasFS() then
			return
		end
		local segments = {}
		for part in string.gmatch(self:GetBasePath(), "([^/]+)") do
			table.insert(segments, part)
		end
		local acc = ""
		for i, seg in ipairs(segments) do
			acc = (i == 1) and seg or (acc .. "/" .. seg)
			pcall(function()
				if not isfolder(acc) then
					makefolder(acc)
				end
			end)
		end
	end

	function SaveManager:WriteRaw(relPath, content)
		self.MemoryFiles[relPath] = content
		if HasFS() then
			self:BuildFolderTree()
			pcall(writefile, relPath, content)
		end
	end

	function SaveManager:ReadRaw(relPath)
		if HasFS() then
			local ok, exists = pcall(isfile, relPath)
			if ok and exists then
				local rok, data = pcall(readfile, relPath)
				if rok and type(data) == "string" then
					return data
				end
			end
		end
		return self.MemoryFiles[relPath]
	end

	function SaveManager:RemoveRaw(relPath)
		self.MemoryFiles[relPath] = nil
		if HasFS() and type(delfile) == "function" then
			pcall(function()
				if isfile(relPath) then
					delfile(relPath)
				end
			end)
		end
	end

	function SaveManager:SetIgnoreIndexes(list)
		for _, key in ipairs(list or {}) do
			self.Ignore[key] = true
		end
	end

	function SaveManager:IgnoreThemeSettings()
		self:SetIgnoreIndexes({
			"BackgroundColor",
			"MainColor",
			"AccentColor",
			"OutlineColor",
			"FontColor",
			"ThemeManager_ThemeList",
			"ThemeManager_CustomThemeList",
			"ThemeManager_CustomThemeName",
		})
	end

	function SaveManager:SetFolder(folder)
		self.Folder = tostring(folder or "ech0fun_configs")
		self:BuildFolderTree()
	end

	function SaveManager:SetSubFolder(subFolder)
		self.SubFolder = tostring(subFolder or "")
		self:BuildFolderTree()
	end

	function SaveManager:CheckSubFolder(createIfMissing)
		if createIfMissing then
			self:BuildFolderTree()
		end
		return self.SubFolder ~= ""
	end

	function SaveManager:SetLibrary(library)
		self.Library = library
	end

	function SaveManager:SerializeCurrentState(metaExtra)
		local data = {
			meta = {
				savedAt = os.time(),
				timestamp = FormatTimestamp(os.time()),
				private = metaExtra and metaExtra.private or false,
				hideUser = metaExtra and metaExtra.hideUser or false,
			},
			objects = {},
		}

		for idx, toggle in pairs(self.Library.Toggles) do
			if not self.Ignore[idx] and toggle.Type and self.Parser[toggle.Type] then
				table.insert(data.objects, self.Parser[toggle.Type].Save(idx, toggle))
			end
		end

		for idx, option in pairs(self.Library.Options) do
			if not self.Ignore[idx] and option.Type and self.Parser[option.Type] then
				table.insert(data.objects, self.Parser[option.Type].Save(idx, option))
			end
		end

		local ok, encoded = pcall(function()
			return HttpService:JSONEncode(data)
		end)
		return ok and encoded or nil
	end

	function SaveManager:Save(name, metaExtra)
		if not name or string.gsub(name, "%s+", "") == "" then
			return false, "no config file is selected"
		end
		local cleanName = string.sub(string.gsub(tostring(name), "[\\/:*?\"<>|]", ""), 1, 24)
		if cleanName == "" then
			return false, "invalid config name"
		end
		local encoded = self:SerializeCurrentState(metaExtra)
		if not encoded then
			return false, "failed to encode data"
		end
		local fullPath = self:GetBasePath() .. "/" .. cleanName .. ".json"
		self:WriteRaw(fullPath, encoded)
		return true, cleanName
	end

	function SaveManager:LoadFromJSON(rawJson)
		local ok, decoded = pcall(function()
			return HttpService:JSONDecode(rawJson)
		end)
		if not ok or type(decoded) ~= "table" or type(decoded.objects) ~= "table" then
			return false, "decode error"
		end
		for _, item in ipairs(decoded.objects) do
			if item and item.type and self.Parser[item.type] and not self.Ignore[item.idx] then
				task.spawn(self.Parser[item.type].Load, item.idx, item)
			end
		end
		return true
	end

	function SaveManager:Load(name)
		if not name or name == "" then
			return false, "no config file is selected"
		end
		local fullPath = self:GetBasePath() .. "/" .. tostring(name) .. ".json"
		local raw = self:ReadRaw(fullPath)
		if not raw then
			return false, "invalid file"
		end
		return self:LoadFromJSON(raw)
	end

	function SaveManager:Delete(name)
		if not name or name == "" then
			return false, "no config file is selected"
		end
		local fullPath = self:GetBasePath() .. "/" .. tostring(name) .. ".json"
		self:RemoveRaw(fullPath)
		return true
	end

	function SaveManager:Rename(oldName, newName)
		if not oldName or not newName or oldName == newName then
			return false
		end
		local cleanNew = string.sub(string.gsub(tostring(newName), "[\\/:*?\"<>|]", ""), 1, 18)
		if cleanNew == "" then
			return false
		end
		local oldPath = self:GetBasePath() .. "/" .. oldName .. ".json"
		local newPath = self:GetBasePath() .. "/" .. cleanNew .. ".json"
		local raw = self:ReadRaw(oldPath)
		if not raw then
			return false
		end
		self:WriteRaw(newPath, raw)
		self:RemoveRaw(oldPath)
		if self:GetAutoloadConfig() == oldName then
			self:SaveAutoloadConfig(cleanNew)
		end
		return true, cleanNew
	end

	function SaveManager:GetConfigMeta(name)
		local raw = self:ReadRaw(self:GetBasePath() .. "/" .. tostring(name) .. ".json")
		if raw then
			local ok, decoded = pcall(function()
				return HttpService:JSONDecode(raw)
			end)
			if ok and type(decoded) == "table" and type(decoded.meta) == "table" then
				return decoded.meta
			end
		end
		return { timestamp = FormatTimestamp(os.time()) }
	end

	function SaveManager:RefreshConfigList()
		local seen = {}
		local out = {}
		local base = self:GetBasePath()

		if HasFS() and type(listfiles) == "function" then
			self:BuildFolderTree()
			local ok, list = pcall(listfiles, base)
			if ok and type(list) == "table" then
				for _, file in ipairs(list) do
					local norm = string.gsub(tostring(file), "\\", "/")
					if string.sub(norm, -5) == ".json" then
						local fname = string.match(norm, "([^/]+)%.json$")
						if fname and fname ~= "" and not seen[fname] then
							seen[fname] = true
							table.insert(out, fname)
						end
					end
				end
			end
		end

		local prefix = base .. "/"
		for path in pairs(self.MemoryFiles) do
			if string.sub(path, 1, #prefix) == prefix and string.sub(path, -5) == ".json" then
				local fname = string.sub(path, #prefix + 1, -6)
				if fname ~= "" and not seen[fname] then
					seen[fname] = true
					table.insert(out, fname)
				end
			end
		end

		table.sort(out)
		return out
	end

	function SaveManager:GetAutoloadPath()
		return self:GetBasePath() .. "/autoload.txt"
	end

	function SaveManager:GetAutoloadConfig()
		local name = self:ReadRaw(self:GetAutoloadPath())
		if type(name) == "string" and name ~= "" then
			return name
		end
		return "none"
	end

	function SaveManager:SaveAutoloadConfig(name)
		if not name or name == "" then
			return false, "no config selected"
		end
		self:WriteRaw(self:GetAutoloadPath(), tostring(name))
		return true
	end

	function SaveManager:DeleteAutoLoadConfig()
		self:RemoveRaw(self:GetAutoloadPath())
		return true
	end

	function SaveManager:LoadAutoloadConfig()
		local name = self:GetAutoloadConfig()
		if name ~= "none" then
			local ok = self:Load(name)
			if ok and self.Library then
				self.Library:Notify(string.format("Auto-loaded config %q", name), 3)
			end
		end
	end

	-- ========================================================================
	-- 1. Standard LinoriaLib Groupbox Config Section (BuildConfigSection)
	-- ========================================================================
	function SaveManager:BuildConfigSection(tab)
		assert(self.Library, "Must set SaveManager.Library first!")
		local section = tab:AddRightGroupbox("Configuration", "folder")

		section:AddInput("SaveManager_ConfigName", {
			Text = "Config name",
			Placeholder = "Enter config name...",
			Icon = "tag",
		})
		section:AddButton("Create config", function()
			local name = self.Library.Options.SaveManager_ConfigName.Value
			local ok, res = self:Save(name)
			if not ok then
				return self.Library:Notify("Failed to create config: " .. tostring(res))
			end
			self.Library:Notify(string.format("Created config %q", res))
			self.Library.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
		end)

		section:AddDivider()

		section:AddDropdown("SaveManager_ConfigList", {
			Text = "Config list",
			Values = self:RefreshConfigList(),
			AllowNull = true,
		})
		section:AddButton("Load config", function()
			local name = self.Library.Options.SaveManager_ConfigList.Value
			local ok, err = self:Load(name)
			if not ok then
				return self.Library:Notify("Failed to load config: " .. tostring(err))
			end
			self.Library:Notify(string.format("Loaded config %q", name))
		end):AddButton("Overwrite config", function()
			local name = self.Library.Options.SaveManager_ConfigList.Value
			local ok, err = self:Save(name)
			if not ok then
				return self.Library:Notify("Failed to overwrite: " .. tostring(err))
			end
			self.Library:Notify(string.format("Overwrote config %q", name))
		end)

		section:AddButton("Delete config", function()
			local name = self.Library.Options.SaveManager_ConfigList.Value
			local ok, err = self:Delete(name)
			if not ok then
				return self.Library:Notify("Failed to delete: " .. tostring(err))
			end
			self.Library:Notify(string.format("Deleted config %q", name))
			self.Library.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
			self.Library.Options.SaveManager_ConfigList:SetValue(nil)
		end):AddButton("Refresh list", function()
			self.Library.Options.SaveManager_ConfigList:SetValues(self:RefreshConfigList())
		end)

		local autoLbl = section:AddLabel("Current autoload: " .. self:GetAutoloadConfig(), true)

		section:AddButton("Set as autoload", function()
			local name = self.Library.Options.SaveManager_ConfigList.Value
			local ok, err = self:SaveAutoloadConfig(name)
			if not ok then
				return self.Library:Notify("Failed to set autoload: " .. tostring(err))
			end
			autoLbl:SetText("Current autoload: " .. tostring(name))
			self.Library:Notify(string.format("Set %q to auto load", name))
		end):AddButton("Reset autoload", function()
			self:DeleteAutoLoadConfig()
			autoLbl:SetText("Current autoload: none")
			self.Library:Notify("Cleared autoload config")
		end)

		self:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_ConfigName" })
	end

	-- ========================================================================
	-- 2. Native 1:1 ech0.fun Configurations Tab (Search + Modal + 3-Col Cards)
	-- ========================================================================
	function SaveManager:BuildConfigTab(tab)
		assert(self.Library, "Must set SaveManager.Library first!")
		local lib = self.Library
		local win = tab.Window or lib.MainWindowCtx
		local canvas, scroll = tab:UseCustomCanvas(490)

		self:SetIgnoreIndexes({
			"EchoConfigModal_Name",
			"EchoConfigModal_Private",
			"EchoConfigModal_HideUser",
		})

		-- Ensure starter "Default" config exists just like main.cpp line 1205
		if #self:RefreshConfigList() == 0 then
			self:Save("Default")
		end

		local fontBold = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold)
		local fontMed = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Medium)

		-- Top Search Box (x = 15, y = 14, size 390x41)
		local searchBox = Instance.new("Frame")
		searchBox.Position = UDim2.fromOffset(15, 14)
		searchBox.Size = UDim2.fromOffset(390, 41)
		searchBox.BackgroundColor3 = lib.Theme.GroupBg
		searchBox.BorderSizePixel = 0
		searchBox.ZIndex = 10
		searchBox.Parent = canvas
		Instance.new("UICorner", searchBox).CornerRadius = UDim.new(0, 3)

		local searchStroke = Instance.new("UIStroke")
		searchStroke.Color = lib.Theme.ControlStroke
		searchStroke.Thickness = 1
		searchStroke.Parent = searchBox

		local sIcon = lib:CreateIcon(searchBox, "search", 14, lib.Theme.TextMuted, 11)
		sIcon.Instance.Position = UDim2.fromOffset(13, 13)

		local searchInput = Instance.new("TextBox")
		searchInput.BackgroundTransparency = 1
		searchInput.Position = UDim2.fromOffset(36, 0)
		searchInput.Size = UDim2.new(1, -44, 1, 0)
		searchInput.FontFace = fontMed
		searchInput.TextSize = 13
		searchInput.TextXAlignment = Enum.TextXAlignment.Left
		searchInput.PlaceholderText = "Search..."
		searchInput.PlaceholderColor3 = Color3.fromRGB(74, 74, 78)
		searchInput.TextColor3 = lib.Theme.TextPrimary
		searchInput.Text = ""
		searchInput.ClearTextOnFocus = false
		searchInput.ZIndex = 11
		searchInput.Parent = searchBox

		-- Refresh & Import Clipboard Action Buttons (41x41 at x=413 and x=460)
		local function MakeTopIconBtn(posX, iconName, tooltipTitle, onClick)
			local b = Instance.new("TextButton")
			b.Position = UDim2.fromOffset(posX, 14)
			b.Size = UDim2.fromOffset(41, 41)
			b.BackgroundColor3 = lib.Theme.GroupBg
			b.BorderSizePixel = 0
			b.AutoButtonColor = false
			b.Text = ""
			b.ZIndex = 10
			b.Parent = canvas
			Instance.new("UICorner", b).CornerRadius = UDim.new(0, 3)

			local st = Instance.new("UIStroke")
			st.Color = lib.Theme.ControlStroke
			st.Thickness = 1
			st.Parent = b

			local ic = lib:CreateIcon(b, iconName, 14, lib.Theme.TextDim, 11)
			ic.Instance.Position = UDim2.fromOffset(13, 13)

			local hov = false
			b.MouseEnter:Connect(function() hov = true end)
			b.MouseLeave:Connect(function() hov = false end)
			b.MouseButton1Click:Connect(onClick)

			lib:BindStep(function()
				if b.Parent then
					b.BackgroundColor3 = hov and lib.Theme.ControlBg or lib.Theme.GroupBg
					st.Color = hov and lib.Theme.Accent or lib.Theme.ControlStroke
					ic:SetColor(hov and lib.Theme.TextBright or lib.Theme.TextDim)
				end
			end)
			return b
		end

		-- Create Button (104x41 at x=509, y=14)
		local createBtn = Instance.new("TextButton")
		createBtn.Position = UDim2.fromOffset(509, 14)
		createBtn.Size = UDim2.fromOffset(104, 41)
		createBtn.BackgroundColor3 = lib.Theme.AccentBright
		createBtn.BorderSizePixel = 0
		createBtn.AutoButtonColor = false
		createBtn.Text = ""
		createBtn.ZIndex = 10
		createBtn.Parent = canvas
		Instance.new("UICorner", createBtn).CornerRadius = UDim.new(0, 3)

		local createIcon = lib:CreateIcon(createBtn, "plus", 13, lib.Theme.ButtonText, 11)
		createIcon.Instance.Position = UDim2.fromOffset(20, 14)

		local createLbl = Instance.new("TextLabel")
		createLbl.BackgroundTransparency = 1
		createLbl.Position = UDim2.fromOffset(40, 0)
		createLbl.Size = UDim2.fromOffset(56, 41)
		createLbl.FontFace = fontBold
		createLbl.TextSize = 13
		createLbl.TextXAlignment = Enum.TextXAlignment.Left
		createLbl.TextColor3 = lib.Theme.ButtonText
		createLbl.Text = "Create"
		createLbl.ZIndex = 11
		createLbl.Parent = createBtn

		-- Cards Holder (3-column grid: 190x108 cards, gap 14 -> 190*3 + 28 = 598px!)
		local cardsFolder = Instance.new("Frame")
		cardsFolder.Position = UDim2.fromOffset(15, 70)
		cardsFolder.Size = UDim2.fromOffset(598, 400)
		cardsFolder.BackgroundTransparency = 1
		cardsFolder.ZIndex = 10
		cardsFolder.Parent = canvas

		local cardEntries = {}
		local RebuildGrid

		-- 1:1 "Create new config" Centered Slide-Up Modal (main.cpp lines 8898-8984)
		local createModal = win:CreateModal({
			Title = "Create new config",
			Icon = "plus",
			Width = 260,
			Height = 236,
		})
		local modalNameInput = createModal:AddInput("EchoConfigModal_Name", {
			Compact = true,
			Icon = "tag",
			Placeholder = "Enter the name...",
		})
		local modalPrivToggle = createModal:AddToggle("EchoConfigModal_Private", {
			Text = "Private Config",
			Default = false,
		})
		local modalHideToggle = createModal:AddToggle("EchoConfigModal_HideUser", {
			Text = "Hide Username",
			Default = false,
		})
		createModal:AddButton({
			Text = "Confirm",
			Icon = "check",
			Func = function()
				local rawName = modalNameInput.Value
				if not rawName or string.gsub(rawName, "%s+", "") == "" then
					rawName = "Config_" .. tostring(#self:RefreshConfigList() + 1)
				end
				local ok, savedName = self:Save(rawName, {
					private = modalPrivToggle.Value,
					hideUser = modalHideToggle.Value,
				})
				if ok then
					modalNameInput:SetValue("")
					createModal:Hide()
					RebuildGrid()
					lib:Notify(string.format("Created config %q", savedName), 3)
				else
					lib:Notify("Could not save config: " .. tostring(savedName), 3)
				end
			end,
		})

		createBtn.MouseButton1Click:Connect(function()
			createModal:Show()
		end)

		MakeTopIconBtn(413, "refresh", "Refresh", function()
			RebuildGrid()
			lib:Notify("Refreshed config list", 2.5)
		end)

		MakeTopIconBtn(461, "clipboard", "Import Clipboard", function()
			if type(getclipboard) == "function" then
				local ok, clip = pcall(getclipboard)
				if ok and type(clip) == "string" and #clip > 2 then
					local lok = self:LoadFromJSON(clip)
					if lok then
						local impName = "Imported_" .. tostring(math.random(10, 99))
						self:Save(impName)
						RebuildGrid()
						lib:Notify("Imported config from clipboard!", 3)
						return
					end
				end
			end
			lib:Notify("Clipboard does not contain valid config JSON", 3)
		end)

		RebuildGrid = function()
			for _, old in ipairs(cardEntries) do
				DisposeNode(old.Card)
			end
			table.clear(cardEntries)

			local filter = string.lower(searchInput.Text or "")
			local allConfigs = self:RefreshConfigList()
			local autoName = self:GetAutoloadConfig()
			local visibleIdx = 0

			for _, cfgName in ipairs(allConfigs) do
				if filter == "" or string.find(string.lower(cfgName), filter, 1, true) ~= nil then
					visibleIdx += 1
					local col = (visibleIdx - 1) % 3
					local row = math.floor((visibleIdx - 1) / 3)
					local cx = col * (190 + 14)
					local cy = row * (108 + 14)
					local meta = self:GetConfigMeta(cfgName)

					local card = Instance.new("Frame")
					card.Position = UDim2.fromOffset(cx, cy)
					card.Size = UDim2.fromOffset(190, 108)
					card.BackgroundColor3 = lib.Theme.GroupBg
					card.BorderSizePixel = 0
					card.ZIndex = 11
					card.Parent = cardsFolder
					Instance.new("UICorner", card).CornerRadius = UDim.new(0, 3)

					local cStroke = Instance.new("UIStroke")
					cStroke.Color = (autoName == cfgName) and lib.Theme.Accent or lib.Theme.GroupStrokeInner
					cStroke.Thickness = 1
					cStroke.Parent = card

					-- Editable Title TextBox
					local nameBox = Instance.new("TextBox")
					nameBox.BackgroundTransparency = 1
					nameBox.Position = UDim2.fromOffset(14, 12)
					nameBox.Size = UDim2.fromOffset(138, 20)
					nameBox.FontFace = fontBold
					nameBox.TextSize = 13
					nameBox.TextXAlignment = Enum.TextXAlignment.Left
					nameBox.TextTruncate = Enum.TextTruncate.AtEnd
					nameBox.TextColor3 = lib.Theme.TextPrimary
					nameBox.Text = cfgName
					nameBox.ClearTextOnFocus = false
					nameBox.ZIndex = 12
					nameBox.Parent = card

					local editIcon = lib:CreateIcon(card, "edit", 11, lib.Theme.TextMuted, 12)
					editIcon.Instance.Position = UDim2.fromOffset(164, 15)

					local underline = Instance.new("Frame")
					underline.Position = UDim2.fromOffset(14, 33)
					underline.Size = UDim2.fromOffset(162, 1)
					underline.BorderSizePixel = 0
					underline.BackgroundColor3 = lib.Theme.GroupStrokeInner
					underline.ZIndex = 12
					underline.Parent = card

					local dateLbl = Instance.new("TextLabel")
					dateLbl.BackgroundTransparency = 1
					dateLbl.Position = UDim2.fromOffset(14, 39)
					dateLbl.Size = UDim2.fromOffset(162, 16)
					dateLbl.FontFace = fontMed
					dateLbl.TextSize = 11
					dateLbl.TextXAlignment = Enum.TextXAlignment.Left
					dateLbl.TextColor3 = lib.Theme.TextSubtle
					local autoTag = (autoName == cfgName) and " • Autoload" or ""
					dateLbl.Text = tostring(meta.timestamp or FormatTimestamp()) .. autoTag
					dateLbl.ZIndex = 12
					dateLbl.Parent = card

					nameBox.FocusLost:Connect(function()
						if nameBox.Text ~= "" and nameBox.Text ~= cfgName then
							local rok, newClean = self:Rename(cfgName, nameBox.Text)
							if rok then
								lib:Notify(string.format("Renamed %q -> %q", cfgName, newClean), 2.5)
								RebuildGrid()
							else
								nameBox.Text = cfgName
							end
						else
							nameBox.Text = cfgName
						end
					end)

					-- Bottom-left small action buttons: Delete (trash), Copy JSON (clipboard), Overwrite (refresh), Autoload (shield)
					local function AddSmallCardIcon(ix, icName, cb)
						local ib = Instance.new("TextButton")
						ib.Position = UDim2.fromOffset(14 + (ix - 1) * 26, 70)
						ib.Size = UDim2.fromOffset(22, 24)
						ib.BackgroundTransparency = 1
						ib.AutoButtonColor = false
						ib.Text = ""
						ib.ZIndex = 13
						ib.Parent = card
						local ic = lib:CreateIcon(ib, icName, 13, lib.Theme.TextDim, 13)
						ic.Instance.Position = UDim2.fromOffset(4, 5)
						ib.MouseEnter:Connect(function()
							ic:SetColor(icName == "trash" and Color3.fromRGB(238, 94, 94) or lib.Theme.Accent)
						end)
						ib.MouseLeave:Connect(function()
							ic:SetColor(lib.Theme.TextDim)
						end)
						ib.MouseButton1Click:Connect(cb)
					end

					AddSmallCardIcon(1, "trash", function()
						self:Delete(cfgName)
						lib:Notify(string.format("Deleted config %q", cfgName), 2.5)
						RebuildGrid()
					end)

					AddSmallCardIcon(2, "clipboard", function()
						local raw = self:ReadRaw(self:GetBasePath() .. "/" .. cfgName .. ".json")
						if raw and type(setclipboard) == "function" then
							pcall(setclipboard, raw)
							lib:Notify(string.format("Copied %q JSON to clipboard", cfgName), 2.5)
						else
							lib:Notify("Exported config to memory buffer", 2.5)
						end
					end)

					AddSmallCardIcon(3, "refresh", function()
						self:Save(cfgName)
						RebuildGrid()
						lib:Notify(string.format("Saved current state to %q", cfgName), 2.5)
					end)

					AddSmallCardIcon(4, "shield", function()
						if self:GetAutoloadConfig() == cfgName then
							self:DeleteAutoLoadConfig()
							lib:Notify("Cleared autoload", 2.5)
						else
							self:SaveAutoloadConfig(cfgName)
							lib:Notify(string.format("Set %q as autoload", cfgName), 2.5)
						end
						RebuildGrid()
					end)

					-- Bottom-right Purple Accent Load Button (\uf254 play icon, 34x26)
					local loadBtn = Instance.new("TextButton")
					loadBtn.Position = UDim2.fromOffset(142, 69)
					loadBtn.Size = UDim2.fromOffset(34, 26)
					loadBtn.BackgroundColor3 = lib.Theme.AccentBright
					loadBtn.BorderSizePixel = 0
					loadBtn.AutoButtonColor = false
					loadBtn.Text = ""
					loadBtn.ZIndex = 13
					loadBtn.Parent = card
					Instance.new("UICorner", loadBtn).CornerRadius = UDim.new(0, 3)

					local loadIc = lib:CreateIcon(loadBtn, "play", 12, lib.Theme.ButtonText, 14)
					loadIc.Instance.Position = UDim2.fromOffset(11, 7)

					loadBtn.MouseButton1Click:Connect(function()
						local lok, err = self:Load(cfgName)
						if lok then
							lib:Notify(string.format("Loaded config %q", cfgName), 3)
						else
							lib:Notify("Load failed: " .. tostring(err), 3)
						end
					end)

					table.insert(cardEntries, {
						Name = cfgName,
						Card = card,
						Stroke = cStroke,
						NameBox = nameBox,
						Underline = underline,
						DateLbl = dateLbl,
						LoadBtn = loadBtn,
						LoadIc = loadIc,
					})
				end
			end

			local totalRows = math.max(1, math.ceil(visibleIdx / 3))
			local gridBottom = 70 + totalRows * 122 + 20
			cardsFolder.Size = UDim2.fromOffset(598, totalRows * 122)
			scroll.CanvasSize = UDim2.fromOffset(0, math.max(490, gridBottom))
		end

		searchInput:GetPropertyChangedSignal("Text"):Connect(RebuildGrid)
		RebuildGrid()

		lib:BindStep(function()
			if not canvas.Parent then
				return
			end
			local th = lib.Theme
			searchBox.BackgroundColor3 = th.GroupBg
			searchStroke.Color = searchInput:IsFocused() and th.Accent or th.ControlStroke
			searchInput.TextColor3 = th.TextPrimary
			createBtn.BackgroundColor3 = th.AccentBright
			createLbl.TextColor3 = th.ButtonText
			createIcon:SetColor(th.ButtonText)
			local curAuto = self:GetAutoloadConfig()
			for _, ce in ipairs(cardEntries) do
				if ce.Card.Parent then
					ce.Card.BackgroundColor3 = th.GroupBg
					ce.Stroke.Color = (curAuto == ce.Name) and th.Accent or th.GroupStrokeInner
					ce.NameBox.TextColor3 = th.TextPrimary
					ce.Underline.BackgroundColor3 = ce.NameBox:IsFocused() and th.Accent or th.GroupStrokeInner
					ce.DateLbl.TextColor3 = th.TextSubtle
					ce.LoadBtn.BackgroundColor3 = th.AccentBright
					ce.LoadIc:SetColor(th.ButtonText)
				end
			end
		end)
	end
end

return SaveManager
