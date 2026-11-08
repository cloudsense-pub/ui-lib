-- Library.lua
-- ech0.fun 1:1 Luau UI Library (LinoriaLib-compatible API)
-- Repository: https://github.com/cloudsense-pub/ui-lib
-- Raw URL:    https://raw.githubusercontent.com/cloudsense-pub/ui-lib/main/Library.lua

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local GlobalEnv = (type(getgenv) == "function" and getgenv()) or _G
GlobalEnv.Toggles = GlobalEnv.Toggles or {}
GlobalEnv.Options = GlobalEnv.Options or {}

local Toggles = GlobalEnv.Toggles
local Options = GlobalEnv.Options

-- Embedded 384x240 RGBA PNG Sprite Sheet (39 ech0.fun vector icons + X-star logo, 48x48 cells, 4px bleed pad)
local EmbeddedAtlasB64 = "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"

local IconUVs = {
	["logo"] = {340, 196, 40, 40},
	["uf010"] = {4, 4, 40, 40},
	["uf02e"] = {52, 4, 40, 40},
	["uf040"] = {100, 4, 40, 40},
	["uf044"] = {148, 4, 40, 40},
	["uf045"] = {196, 4, 40, 40},
	["uf05f"] = {244, 4, 40, 40},
	["uf078"] = {292, 4, 40, 40},
	["uf07f"] = {340, 4, 40, 40},
	["uf095"] = {4, 52, 40, 40},
	["uf0f0"] = {52, 52, 40, 40},
	["uf0fd"] = {100, 52, 40, 40},
	["uf142"] = {148, 52, 40, 40},
	["uf15e"] = {196, 52, 40, 40},
	["uf182"] = {244, 52, 40, 40},
	["uf18c"] = {292, 52, 40, 40},
	["uf19a"] = {340, 52, 40, 40},
	["uf219"] = {4, 100, 40, 40},
	["uf254"] = {52, 100, 40, 40},
	["uf2cb"] = {100, 100, 40, 40},
	["uf313"] = {148, 100, 40, 40},
	["uf317"] = {196, 100, 40, 40},
	["uf3a5"] = {244, 100, 40, 40},
	["uf3b8"] = {292, 100, 40, 40},
	["uf3dc"] = {340, 100, 40, 40},
	["uf407"] = {4, 148, 40, 40},
	["uf41c"] = {52, 148, 40, 40},
	["uf44f"] = {100, 148, 40, 40},
	["uf450"] = {148, 148, 40, 40},
	["uf457"] = {196, 148, 40, 40},
	["uf4ca"] = {244, 148, 40, 40},
	["uf4fa"] = {292, 148, 40, 40},
	["uf53b"] = {340, 148, 40, 40},
	["uf571"] = {4, 196, 40, 40},
	["uf572"] = {52, 196, 40, 40},
	["uf58e"] = {100, 196, 40, 40},
	["uf5ae"] = {148, 196, 40, 40},
	["uf661"] = {196, 196, 40, 40},
	["uf677"] = {244, 196, 40, 40},
	["uf6d6"] = {292, 196, 40, 40},
}

local IconAliases = {
	["logo"] = "logo",
	["scan_eye"] = "uf010",
	["heart"] = "uf02e",
	["users"] = "uf040",
	["crosshair"] = "uf044",
	["folder"] = "uf045",
	["mouse"] = "uf05f",
	["chevron_sm"] = "uf078",
	["sword"] = "uf07f",
	["code"] = "uf095",
	["dots"] = "uf0f0",
	["globe"] = "uf0fd",
	["car"] = "uf142",
	["eye"] = "uf15e",
	["trash"] = "uf182",
	["edit"] = "uf18c",
	["grid"] = "uf19a",
	["at"] = "uf219",
	["play"] = "uf254",
	["refresh"] = "uf2cb",
	["check"] = "uf313",
	["plus"] = "uf317",
	["book"] = "uf3a5",
	["shield"] = "uf3b8",
	["gear"] = "uf3dc",
	["sliders"] = "uf407",
	["clipboard"] = "uf41c",
	["close"] = "uf44f",
	["keyboard"] = "uf450",
	["folder_open"] = "uf457",
	["tag"] = "uf4ca",
	["chevron"] = "uf4fa",
	["user"] = "uf53b",
	["user_gear"] = "uf571",
	["target"] = "uf572",
	["list"] = "uf58e",
	["search"] = "uf5ae",
	["box"] = "uf661",
	["focus"] = "uf677",
	["server"] = "uf6d6",
}

local FallbackTextGlyphs = {
	["logo"] = "✦",
	["uf010"] = "◎",
	["uf02e"] = "♡",
	["uf040"] = "👥",
	["uf044"] = "⊕",
	["uf045"] = "📁",
	["uf05f"] = "🖱",
	["uf078"] = "▾",
	["uf07f"] = "⚔",
	["uf095"] = "</>",
	["uf0f0"] = "•••",
	["uf0fd"] = "🌐",
	["uf142"] = "🚗",
	["uf15e"] = "👁",
	["uf182"] = "🗑",
	["uf18c"] = "✎",
	["uf19a"] = "⊞",
	["uf219"] = "@",
	["uf254"] = "▷",
	["uf2cb"] = "↻",
	["uf313"] = "✓",
	["uf317"] = "+",
	["uf3a5"] = "📖",
	["uf3b8"] = "🛡",
	["uf3dc"] = "⚙",
	["uf407"] = "☰",
	["uf41c"] = "📋",
	["uf44f"] = "✕",
	["uf450"] = "⌨",
	["uf457"] = "📂",
	["uf4ca"] = "🏷",
	["uf4fa"] = "▾",
	["uf53b"] = "👤",
	["uf571"] = "👤",
	["uf572"] = "◎",
	["uf58e"] = "☰",
	["uf5ae"] = "🔍",
	["uf661"] = "🧰",
	["uf677"] = "⌖",
	["uf6d6"] = "🗄",
}

local function DecodeBase64(data)
	local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	data = string.gsub(data, "[^" .. b .. "=]", "")
	local out = table.create(#data * 3 // 4)
	local n = 0
	local pad = 0
	if string.sub(data, -2) == "==" then
		pad = 2
	elseif string.sub(data, -1) == "=" then
		pad = 1
	end
	for i = 1, #data, 4 do
		local c1 = (string.find(b, string.sub(data, i, i), 1, true) or 1) - 1
		local c2 = (string.find(b, string.sub(data, i + 1, i + 1), 1, true) or 1) - 1
		local c3 = (string.find(b, string.sub(data, i + 2, i + 2), 1, true) or 1) - 1
		local c4 = (string.find(b, string.sub(data, i + 3, i + 3), 1, true) or 1) - 1
		local triple = bit32.lshift(c1, 18) + bit32.lshift(c2, 12) + bit32.lshift(c3, 6) + c4
		n += 1
		out[n] = string.char(bit32.band(bit32.rshift(triple, 16), 0xFF))
		if i + 3 <= #data - pad or pad < 2 then
			if not (i + 3 >= #data and pad == 2) then
				n += 1
				out[n] = string.char(bit32.band(bit32.rshift(triple, 8), 0xFF))
			end
		end
		if not (i + 3 >= #data and pad >= 1) then
			n += 1
			out[n] = string.char(bit32.band(triple, 0xFF))
		end
	end
	return table.concat(out)
end

local function ResolveCustomAsset()
	local customAssetFn = (type(getcustomasset) == "function" and getcustomasset)
		or (type(getsynasset) == "function" and getsynasset)
	if not customAssetFn or type(writefile) ~= "function" then
		return nil
	end
	local ok, assetId = pcall(function()
		if type(isfolder) == "function" and type(makefolder) == "function" and not isfolder("ech0fun_assets") then
			makefolder("ech0fun_assets")
		end
		local path = "ech0fun_assets/icon_atlas_v2.png"
		if type(isfile) ~= "function" or not isfile(path) then
			writefile(path, DecodeBase64(EmbeddedAtlasB64))
		end
		return customAssetFn(path)
	end)
	if ok and type(assetId) == "string" and #assetId > 0 then
		return assetId
	end
	return nil
end

local function DisposeInstance(inst)
	if not inst then
		return
	end
	pcall(function()
		inst:ClearAllChildren()
		inst.Parent = nil
	end)
end

local function SmoothStep(t)
	if t <= 0 then
		return 0
	elseif t >= 1 then
		return 1
	end
	return t * t * (3 - 2 * t)
end

local function Lerp(a, b, t)
	return a + (b - a) * t
end

local function LerpColor(c1, c2, t)
	if t <= 0 then
		return c1
	elseif t >= 1 then
		return c2
	end
	return Color3.new(
		c1.R + (c2.R - c1.R) * t,
		c1.G + (c2.G - c1.G) * t,
		c1.B + (c2.B - c1.B) * t
	)
end

local FontBold = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal)
local FontMedium = Font.new("rbxasset://fonts/families/Montserrat.json", Enum.FontWeight.Medium, Enum.FontStyle.Normal)
local FontCode = Font.new("rbxasset://fonts/families/RobotoMono.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

local function CalcTextBounds(text, fontFace, sizePx)
	local ok, bounds = pcall(function()
		local params = Instance.new("GetTextBoundsParams")
		params.Text = tostring(text or "")
		params.Font = fontFace
		params.Size = sizePx
		params.Width = 4000
		return TextService:GetTextBoundsAsync(params)
	end)
	if ok and bounds then
		return bounds
	end
	return Vector2.new(#tostring(text or "") * (sizePx * 0.54), sizePx)
end

local KeyShortNames = {
	[Enum.KeyCode.LeftShift] = "LShift",
	[Enum.KeyCode.RightShift] = "RShift",
	[Enum.KeyCode.LeftControl] = "LCtrl",
	[Enum.KeyCode.RightControl] = "RCtrl",
	[Enum.KeyCode.LeftAlt] = "LAlt",
	[Enum.KeyCode.RightAlt] = "RAlt",
	[Enum.KeyCode.CapsLock] = "Caps",
	[Enum.KeyCode.Backspace] = "Back",
	[Enum.KeyCode.Return] = "Enter",
	[Enum.KeyCode.Insert] = "Ins",
	[Enum.KeyCode.Delete] = "Del",
	[Enum.KeyCode.PageUp] = "PgUp",
	[Enum.KeyCode.PageDown] = "PgDn",
	[Enum.KeyCode.Space] = "Space",
	[Enum.KeyCode.Tab] = "Tab",
}

local function FormatKeyName(key)
	if not key or key == "None" or key == Enum.KeyCode.Unknown then
		return "None"
	end
	if typeof(key) == "EnumItem" then
		if key.EnumType == Enum.UserInputType then
			if key == Enum.UserInputType.MouseButton1 then return "MB1" end
			if key == Enum.UserInputType.MouseButton2 then return "MB2" end
			if key == Enum.UserInputType.MouseButton3 then return "MB3" end
			return key.Name
		end
		return KeyShortNames[key] or key.Name
	end
	local s = tostring(key)
	for code, short in pairs(KeyShortNames) do
		if code.Name == s then
			return short
		end
	end
	if s == "MouseButton1" then return "MB1" end
	if s == "MouseButton2" then return "MB2" end
	if s == "MouseButton3" then return "MB3" end
	return s
end

local function NormalizeIconKey(raw)
	if not raw or raw == "" then
		return nil
	end
	if IconUVs[raw] then
		return raw
	end
	local lower = string.lower(tostring(raw))
	if IconUVs[lower] then
		return lower
	end
	if IconAliases[lower] then
		return IconAliases[lower]
	end
	if utf8 and utf8.codepoint then
		local ok, cp = pcall(utf8.codepoint, tostring(raw), 1)
		if ok and cp and cp >= 0xF000 then
			local key = string.format("u%04x", cp)
			if IconUVs[key] then
				return key
			end
		end
	end
	return nil
end

local Themes = {
	Dark = {
		OuterBorder1 = Color3.fromRGB(45, 45, 45),
		OuterBorder2 = Color3.fromRGB(10, 10, 10),
		Canvas = Color3.fromRGB(6, 6, 6),
		ContentBg = Color3.fromRGB(9, 9, 9),
		ContentStrokeInner = Color3.fromRGB(17, 17, 17),
		ContentStrokeOuter = Color3.fromRGB(5, 5, 5),
		GroupBg = Color3.fromRGB(14, 14, 14),
		GroupStrokeInner = Color3.fromRGB(22, 22, 22),
		GroupStrokeOuter = Color3.fromRGB(5, 5, 5),
		PopupBg = Color3.fromRGB(14, 14, 14),
		PopupStroke = Color3.fromRGB(27, 27, 29),
		BottomPopupBg = Color3.fromRGB(12, 12, 12),
		ControlBg = Color3.fromRGB(24, 24, 24),
		ControlHover = Color3.fromRGB(31, 31, 31),
		ControlStroke = Color3.fromRGB(31, 31, 31),
		ControlOuter = Color3.fromRGB(8, 8, 8),
		TopDivider = Color3.fromRGB(16, 16, 16),
		Divider = Color3.fromRGB(48, 48, 48),
		TextPrimary = Color3.fromRGB(235, 235, 235),
		TextBright = Color3.fromRGB(255, 255, 255),
		TextLabel = Color3.fromRGB(205, 205, 210),
		TextDim = Color3.fromRGB(86, 86, 86),
		TextMuted = Color3.fromRGB(62, 62, 66),
		TextSubtle = Color3.fromRGB(88, 88, 94),
		SwitchOff = Color3.fromRGB(32, 32, 34),
		KnobOff = Color3.fromRGB(86, 86, 86),
		KnobOn = Color3.fromRGB(10, 10, 10),
		SliderKnob = Color3.fromRGB(44, 44, 44),
		TooltipBg = Color3.fromRGB(21, 21, 21),
		TooltipText = Color3.fromRGB(180, 180, 184),
		Accent = Color3.fromRGB(142, 134, 246),
		AccentBright = Color3.fromRGB(148, 140, 246),
		AccentDark = Color3.fromRGB(108, 102, 198),
		AccentGradEnd = Color3.fromRGB(129, 122, 222),
		ButtonText = Color3.fromRGB(0, 0, 0),
	},
	Light = {
		OuterBorder1 = Color3.fromRGB(195, 195, 204),
		OuterBorder2 = Color3.fromRGB(220, 220, 228),
		Canvas = Color3.fromRGB(244, 244, 248),
		ContentBg = Color3.fromRGB(236, 236, 242),
		ContentStrokeInner = Color3.fromRGB(218, 218, 226),
		ContentStrokeOuter = Color3.fromRGB(206, 206, 216),
		GroupBg = Color3.fromRGB(250, 250, 253),
		GroupStrokeInner = Color3.fromRGB(224, 224, 232),
		GroupStrokeOuter = Color3.fromRGB(212, 212, 222),
		PopupBg = Color3.fromRGB(250, 250, 253),
		PopupStroke = Color3.fromRGB(214, 214, 224),
		BottomPopupBg = Color3.fromRGB(246, 246, 250),
		ControlBg = Color3.fromRGB(234, 234, 240),
		ControlHover = Color3.fromRGB(224, 224, 234),
		ControlStroke = Color3.fromRGB(210, 210, 220),
		ControlOuter = Color3.fromRGB(225, 225, 233),
		TopDivider = Color3.fromRGB(214, 214, 224),
		Divider = Color3.fromRGB(208, 208, 218),
		TextPrimary = Color3.fromRGB(24, 24, 30),
		TextBright = Color3.fromRGB(12, 12, 16),
		TextLabel = Color3.fromRGB(40, 40, 48),
		TextDim = Color3.fromRGB(122, 122, 134),
		TextMuted = Color3.fromRGB(130, 130, 142),
		TextSubtle = Color3.fromRGB(112, 112, 124),
		SwitchOff = Color3.fromRGB(210, 210, 220),
		KnobOff = Color3.fromRGB(130, 130, 140),
		KnobOn = Color3.fromRGB(255, 255, 255),
		SliderKnob = Color3.fromRGB(72, 72, 84),
		TooltipBg = Color3.fromRGB(32, 32, 38),
		TooltipText = Color3.fromRGB(235, 235, 240),
		Accent = Color3.fromRGB(118, 108, 238),
		AccentBright = Color3.fromRGB(128, 118, 244),
		AccentDark = Color3.fromRGB(96, 88, 206),
		AccentGradEnd = Color3.fromRGB(108, 98, 224),
		ButtonText = Color3.fromRGB(255, 255, 255),
	},
}

local Library = {
	RepoUrl = "https://raw.githubusercontent.com/cloudsense-pub/ui-lib/main/",
	Toggles = Toggles,
	Options = Options,
	OpenedFrames = {},
	DependencyBoxes = {},
	Signals = {},
	IconPool = {},
	UnloadCallbacks = {},
	ThemeName = "Dark",
	Theme = Themes.Dark,
	AccentColor = Themes.Dark.Accent,
	DPIScale = 1.0,
	TargetDPIScale = 1.0,
	Toggled = true,
	Unloaded = false,
	ToggleKeybind = nil,
	IconAtlasId = ResolveCustomAsset(),
	WatermarkEnabled = false,
	WatermarkText = "ech0.fun | 60 fps | 42 ms",
	KeybindListEnabled = false,
}

function Library:GiveSignal(conn)
	table.insert(self.Signals, conn)
	return conn
end

function Library:SafeCallback(fn, ...)
	if type(fn) ~= "function" then
		return
	end
	local ok, err = pcall(fn, ...)
	if not ok then
		warn("[ech0.fun UI] Callback error:", err)
	end
end

function Library:SetIconAtlas(assetId)
	self.IconAtlasId = assetId
	for _, entry in ipairs(self.IconPool) do
		if entry and entry.UpdateAsset then
			entry.UpdateAsset(assetId)
		end
	end
end

function Library:CreateIcon(parent, iconId, sizePx, color3, zIndex)
	local key = NormalizeIconKey(iconId)
	local uv = key and IconUVs[key] or nil
	local holder = Instance.new("Frame")
	holder.Name = "Icon_" .. tostring(key or "none")
	holder.BackgroundTransparency = 1
	holder.Size = UDim2.fromOffset(sizePx, sizePx)
	holder.ZIndex = zIndex or 2
	holder.Parent = parent

	local img = Instance.new("ImageLabel")
	img.Name = "GlyphImg"
	img.BackgroundTransparency = 1
	img.Size = UDim2.fromScale(1, 1)
	img.ImageColor3 = color3 or self.Theme.TextPrimary
	img.ScaleType = Enum.ScaleType.Stretch
	img.ResampleMode = Enum.ResamplerMode.Default
	img.ZIndex = zIndex or 2
	if uv then
		img.ImageRectOffset = Vector2.new(uv[1], uv[2])
		img.ImageRectSize = Vector2.new(uv[3], uv[4])
	end
	img.Parent = holder

	local fallback = Instance.new("TextLabel")
	fallback.Name = "GlyphFallback"
	fallback.BackgroundTransparency = 1
	fallback.Size = UDim2.fromScale(1, 1)
	fallback.FontFace = FontBold
	fallback.TextSize = math.max(9, math.floor(sizePx * 0.82))
	fallback.TextColor3 = color3 or self.Theme.TextPrimary
	fallback.Text = (key and FallbackTextGlyphs[key]) or "•"
	fallback.ZIndex = zIndex or 2
	fallback.Parent = holder

	local currentColor = color3 or self.Theme.TextPrimary
	local currentAlpha = 0

	local function SyncAsset(asset)
		local useImage = (type(asset) == "string" and #asset > 0 and uv ~= nil)
		img.Visible = useImage
		fallback.Visible = not useImage
		if useImage then
			img.Image = asset
		end
	end

	SyncAsset(self.IconAtlasId)

	local api = {
		Instance = holder,
		Image = img,
		Fallback = fallback,
		SetColor = function(_, c)
			currentColor = c
			img.ImageColor3 = c
			fallback.TextColor3 = c
		end,
		SetTransparency = function(_, t)
			currentAlpha = t
			img.ImageTransparency = t
			fallback.TextTransparency = t
		end,
		SetIcon = function(_, newIcon)
			local nk = NormalizeIconKey(newIcon)
			local nuv = nk and IconUVs[nk] or nil
			key = nk
			uv = nuv
			if nuv then
				img.ImageRectOffset = Vector2.new(nuv[1], nuv[2])
				img.ImageRectSize = Vector2.new(nuv[3], nuv[4])
			end
			fallback.Text = (nk and FallbackTextGlyphs[nk]) or "•"
			SyncAsset(self.IconAtlasId)
		end,
		UpdateAsset = SyncAsset,
	}
	table.insert(self.IconPool, api)
	return api
end

local function CreateDualBorderBox(parent, name, pos, size, fillColor, innerStrokeColor, outerStrokeColor, radius, zIndex)
	local outer = Instance.new("Frame")
	outer.Name = name .. "_Outer"
	outer.Position = UDim2.new(pos.X.Scale, pos.X.Offset - 1, pos.Y.Scale, pos.Y.Offset - 1)
	outer.Size = UDim2.new(size.X.Scale, size.X.Offset + 2, size.Y.Scale, size.Y.Offset + 2)
	outer.BackgroundTransparency = 1
	outer.ZIndex = zIndex or 2
	outer.Parent = parent

	local outerCorner = Instance.new("UICorner")
	outerCorner.CornerRadius = UDim.new(0, (radius or 3) + 1)
	outerCorner.Parent = outer

	local outerStroke = Instance.new("UIStroke")
	outerStroke.Color = outerStrokeColor
	outerStroke.Thickness = 1
	outerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	outerStroke.Parent = outer

	local box = Instance.new("Frame")
	box.Name = name
	box.Position = pos
	box.Size = size
	box.BackgroundColor3 = fillColor
	box.BorderSizePixel = 0
	box.ZIndex = (zIndex or 2) + 1
	box.Parent = parent

	local innerCorner = Instance.new("UICorner")
	innerCorner.CornerRadius = UDim.new(0, radius or 3)
	innerCorner.Parent = box

	local innerStroke = Instance.new("UIStroke")
	innerStroke.Color = innerStrokeColor
	innerStroke.Thickness = 1
	innerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	innerStroke.Parent = box

	return box, innerStroke, outerStroke, outer
end

local function MountScreenGui()
	local gui = Instance.new("ScreenGui")
	gui.Name = "ech0fun_ui"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = true
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.DisplayOrder = 9999

	local mounted = false
	if type(gethui) == "function" then
		mounted = pcall(function()
			gui.Parent = gethui()
		end)
	end
	if not mounted and syn and type(syn.protect_gui) == "function" then
		pcall(syn.protect_gui, gui)
	end
	if not mounted then
		mounted = pcall(function()
			gui.Parent = CoreGui
		end)
	end
	if not mounted then
		local lp = Players.LocalPlayer
		if lp then
			gui.Parent = lp:WaitForChild("PlayerGui")
		end
	end
	return gui
end

local function MakeDraggable(dragHandle, targetFrame, scaleGetter, canDragFn)
	local dragging = false
	local dragStart = Vector2.zero
	local startPos = Vector2.zero

	Library:GiveSignal(dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if canDragFn and not canDragFn(input.Position) then
				return
			end
			dragging = true
			dragStart = Vector2.new(input.Position.X, input.Position.Y)
			startPos = Vector2.new(targetFrame.Position.X.Offset, targetFrame.Position.Y.Offset)
		end
	end))

	Library:GiveSignal(UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
			local cam = workspace.CurrentCamera
			local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
			local sc = scaleGetter and scaleGetter() or 1
			local w = targetFrame.Size.X.Offset * sc
			local h = targetFrame.Size.Y.Offset * sc
			local nx = math.clamp(startPos.X + delta.X, 0, math.max(0, vp.X - w))
			local ny = math.clamp(startPos.Y + delta.Y, 0, math.max(0, vp.Y - h))
			targetFrame.Position = UDim2.fromOffset(math.floor(nx + 0.5), math.floor(ny + 0.5))
		end
	end))

	Library:GiveSignal(UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end))
end

Library.ScreenGui = MountScreenGui()

-- Global Animator Loop (60–240Hz delta-time smoothstep matching main.cpp & sigma.h)
Library.StepHandlers = {}
function Library:BindStep(fn)
	table.insert(self.StepHandlers, fn)
end

Library:GiveSignal(RunService.RenderStepped:Connect(function(dt)
	if Library.Unloaded then
		return
	end
	local clampedDt = math.min(dt, 0.1)
	for i = #Library.StepHandlers, 1, -1 do
		local fn = Library.StepHandlers[i]
		if fn then
			fn(clampedDt)
		end
	end
end))

-- ============================================================================
-- WATERMARK WIDGET (1:1 ech0.fun triple-shell + X-star logo + 1x8 dividers)
-- ============================================================================
do
	local wmOuter1 = Instance.new("Frame")
	wmOuter1.Name = "WatermarkShell"
	wmOuter1.Position = UDim2.fromOffset(18, 18)
	wmOuter1.Size = UDim2.fromOffset(240, 38)
	wmOuter1.BackgroundColor3 = Library.Theme.OuterBorder1
	wmOuter1.BackgroundTransparency = 1
	wmOuter1.Visible = false
	wmOuter1.ZIndex = 500
	wmOuter1.Parent = Library.ScreenGui
	Instance.new("UICorner", wmOuter1).CornerRadius = UDim.new(0, 5)

	local wmOuter2 = Instance.new("Frame")
	wmOuter2.Position = UDim2.fromOffset(1, 1)
	wmOuter2.Size = UDim2.new(1, -2, 1, -2)
	wmOuter2.BackgroundColor3 = Library.Theme.OuterBorder2
	wmOuter2.BackgroundTransparency = 1
	wmOuter2.ZIndex = 501
	wmOuter2.Parent = wmOuter1
	Instance.new("UICorner", wmOuter2).CornerRadius = UDim.new(0, 4)

	local wmCanvas = Instance.new("Frame")
	wmCanvas.Position = UDim2.fromOffset(4, 4)
	wmCanvas.Size = UDim2.new(1, -8, 1, -8)
	wmCanvas.BackgroundColor3 = Library.Theme.Canvas
	wmCanvas.BackgroundTransparency = 1
	wmCanvas.ZIndex = 502
	wmCanvas.Parent = wmOuter1
	Instance.new("UICorner", wmCanvas).CornerRadius = UDim.new(0, 2)

	local wmInnerStroke = Instance.new("UIStroke")
	wmInnerStroke.Color = Library.Theme.GroupStrokeInner
	wmInnerStroke.Thickness = 1
	wmInnerStroke.Transparency = 1
	wmInnerStroke.Parent = wmCanvas

	local wmTopAccent = Instance.new("Frame")
	wmTopAccent.Position = UDim2.fromOffset(8, 0)
	wmTopAccent.Size = UDim2.fromOffset(28, 1)
	wmTopAccent.BackgroundColor3 = Library.Theme.Accent
	wmTopAccent.BackgroundTransparency = 1
	wmTopAccent.BorderSizePixel = 0
	wmTopAccent.ZIndex = 504
	wmTopAccent.Parent = wmCanvas

	local wmLogo = Library:CreateIcon(wmCanvas, "logo", 14, Library.Theme.Accent, 504)
	wmLogo.Instance.Position = UDim2.fromOffset(10, 8)
	wmLogo:SetTransparency(1)

	local wmBrandWhite = Instance.new("TextLabel")
	wmBrandWhite.BackgroundTransparency = 1
	wmBrandWhite.Position = UDim2.fromOffset(30, 0)
	wmBrandWhite.Size = UDim2.fromOffset(38, 30)
	wmBrandWhite.FontFace = FontBold
	wmBrandWhite.TextSize = 13
	wmBrandWhite.TextXAlignment = Enum.TextXAlignment.Left
	wmBrandWhite.TextColor3 = Library.Theme.TextPrimary
	wmBrandWhite.TextTransparency = 1
	wmBrandWhite.Text = "ech0."
	wmBrandWhite.ZIndex = 504
	wmBrandWhite.Parent = wmCanvas

	local wmBrandAccent = Instance.new("TextLabel")
	wmBrandAccent.BackgroundTransparency = 1
	wmBrandAccent.Position = UDim2.fromOffset(67, 0)
	wmBrandAccent.Size = UDim2.fromOffset(26, 30)
	wmBrandAccent.FontFace = FontBold
	wmBrandAccent.TextSize = 13
	wmBrandAccent.TextXAlignment = Enum.TextXAlignment.Left
	wmBrandAccent.TextColor3 = Library.Theme.Accent
	wmBrandAccent.TextTransparency = 1
	wmBrandAccent.Text = "fun"
	wmBrandAccent.ZIndex = 504
	wmBrandAccent.Parent = wmCanvas

	local wmSegmentsFolder = Instance.new("Folder")
	wmSegmentsFolder.Name = "Segments"
	wmSegmentsFolder.Parent = wmCanvas

	MakeDraggable(wmOuter1, wmOuter1, function() return 1 end)

	local wmFade = 0
	local segmentPool = {}

	local function RebuildWatermarkSegments(rawText, alpha)
		local parts = {}
		for part in string.gmatch(tostring(rawText or ""), "([^|]+)") do
			local trimmed = string.gsub(part, "^%s*(.-)%s*$", "%1")
			if trimmed ~= "" and string.lower(trimmed) ~= "ech0.fun" then
				table.insert(parts, trimmed)
			end
		end

		local wWhite = CalcTextBounds("ech0.", FontBold, 13).X
		local wFun = CalcTextBounds("fun", FontBold, 13).X
		wmBrandWhite.Size = UDim2.fromOffset(wWhite + 2, 30)
		wmBrandAccent.Position = UDim2.fromOffset(30 + wWhite, 0)
		wmBrandAccent.Size = UDim2.fromOffset(wFun + 2, 30)

		local cursorX = 30 + wWhite + wFun + 10

		for idx, segText in ipairs(parts) do
			local slot = segmentPool[idx]
			if not slot then
				local div = Instance.new("Frame")
				div.Size = UDim2.fromOffset(1, 8)
				div.BorderSizePixel = 0
				div.ZIndex = 504
				div.Parent = wmSegmentsFolder

				local lbl = Instance.new("TextLabel")
				lbl.BackgroundTransparency = 1
				lbl.FontFace = FontMedium
				lbl.TextSize = 12
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				lbl.ZIndex = 504
				lbl.Parent = wmSegmentsFolder

				slot = { Divider = div, Label = lbl }
				segmentPool[idx] = slot
			end

			slot.Divider.Visible = true
			slot.Divider.Position = UDim2.fromOffset(cursorX, 11)
			slot.Divider.BackgroundColor3 = Library.Theme.TopDivider
			slot.Divider.BackgroundTransparency = 1 - alpha
			cursorX += 10

			local segW = CalcTextBounds(segText, FontMedium, 12).X
			slot.Label.Visible = true
			slot.Label.Text = segText
			slot.Label.Position = UDim2.fromOffset(cursorX, 0)
			slot.Label.Size = UDim2.fromOffset(segW + 4, 30)
			slot.Label.TextColor3 = Library.Theme.TextLabel
			slot.Label.TextTransparency = 1 - alpha
			cursorX += segW + 10
		end

		for i = #parts + 1, #segmentPool do
			segmentPool[i].Divider.Visible = false
			segmentPool[i].Label.Visible = false
		end

		local totalWidth = math.max(116, cursorX + 10)
		wmOuter1.Size = UDim2.fromOffset(math.floor(totalWidth + 0.5), 38)
	end

	Library.WatermarkFrame = wmOuter1

	function Library:SetWatermarkVisibility(visible)
		self.WatermarkEnabled = (visible == true)
	end

	function Library:SetWatermark(text)
		self.WatermarkText = tostring(text or "")
		if wmFade > 0.005 then
			RebuildWatermarkSegments(self.WatermarkText, SmoothStep(wmFade))
		end
	end

	Library:BindStep(function(dt)
		local target = Library.WatermarkEnabled and 1 or 0
		wmFade += (target - wmFade) * math.min(1, dt * 10)
		if math.abs(target - wmFade) < 0.002 then
			wmFade = target
		end
		local a = SmoothStep(wmFade)
		wmOuter1.Visible = a > 0.005
		if not wmOuter1.Visible then
			return
		end
		local th = Library.Theme
		wmOuter1.BackgroundColor3 = th.OuterBorder1
		wmOuter1.BackgroundTransparency = 1 - (0.47 * a)
		wmOuter2.BackgroundColor3 = th.OuterBorder2
		wmOuter2.BackgroundTransparency = 1 - (0.47 * a)
		wmCanvas.BackgroundColor3 = th.Canvas
		wmCanvas.BackgroundTransparency = 1 - a
		wmInnerStroke.Color = th.GroupStrokeInner
		wmInnerStroke.Transparency = 1 - a
		wmTopAccent.BackgroundColor3 = th.Accent
		wmTopAccent.BackgroundTransparency = 1 - a
		wmLogo:SetColor(th.Accent)
		wmLogo:SetTransparency(1 - a)
		wmBrandWhite.TextColor3 = th.TextPrimary
		wmBrandWhite.TextTransparency = 1 - a
		wmBrandAccent.TextColor3 = th.Accent
		wmBrandAccent.TextTransparency = 1 - a
		RebuildWatermarkSegments(Library.WatermarkText, a)
	end)
end

-- ============================================================================
-- KEYBIND LIST WIDGET (1:1 ech0.fun child_header + animated key pills)
-- ============================================================================
do
	local kbOuter1 = Instance.new("Frame")
	kbOuter1.Name = "KeybindListShell"
	kbOuter1.Position = UDim2.fromOffset(18, 66)
	kbOuter1.Size = UDim2.fromOffset(226, 48)
	kbOuter1.BackgroundColor3 = Library.Theme.OuterBorder1
	kbOuter1.BackgroundTransparency = 1
	kbOuter1.Visible = false
	kbOuter1.ZIndex = 490
	kbOuter1.Parent = Library.ScreenGui
	Instance.new("UICorner", kbOuter1).CornerRadius = UDim.new(0, 5)

	local kbOuter2 = Instance.new("Frame")
	kbOuter2.Position = UDim2.fromOffset(1, 1)
	kbOuter2.Size = UDim2.new(1, -2, 1, -2)
	kbOuter2.BackgroundColor3 = Library.Theme.OuterBorder2
	kbOuter2.BackgroundTransparency = 1
	kbOuter2.ZIndex = 491
	kbOuter2.Parent = kbOuter1
	Instance.new("UICorner", kbOuter2).CornerRadius = UDim.new(0, 4)

	local kbCanvas = Instance.new("Frame")
	kbCanvas.Position = UDim2.fromOffset(4, 4)
	kbCanvas.Size = UDim2.new(1, -8, 1, -8)
	kbCanvas.BackgroundColor3 = Library.Theme.GroupBg
	kbCanvas.BackgroundTransparency = 1
	kbCanvas.ClipsDescendants = true
	kbCanvas.ZIndex = 492
	kbCanvas.Parent = kbOuter1
	Instance.new("UICorner", kbCanvas).CornerRadius = UDim.new(0, 3)

	local kbStroke = Instance.new("UIStroke")
	kbStroke.Color = Library.Theme.GroupStrokeInner
	kbStroke.Thickness = 1
	kbStroke.Transparency = 1
	kbStroke.Parent = kbCanvas

	local kbHeaderIcon = Library:CreateIcon(kbCanvas, "keyboard", 14, Library.Theme.Accent, 494)
	kbHeaderIcon.Instance.Position = UDim2.fromOffset(14, 12)
	kbHeaderIcon:SetTransparency(1)

	local kbHeaderTitle = Instance.new("TextLabel")
	kbHeaderTitle.BackgroundTransparency = 1
	kbHeaderTitle.Position = UDim2.fromOffset(36, 0)
	kbHeaderTitle.Size = UDim2.new(1, -46, 0, 38)
	kbHeaderTitle.FontFace = FontBold
	kbHeaderTitle.TextSize = 13
	kbHeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
	kbHeaderTitle.TextColor3 = Library.Theme.TextPrimary
	kbHeaderTitle.TextTransparency = 1
	kbHeaderTitle.Text = "Keybinds"
	kbHeaderTitle.ZIndex = 494
	kbHeaderTitle.Parent = kbCanvas

	local kbHeaderCount = Instance.new("TextLabel")
	kbHeaderCount.BackgroundTransparency = 1
	kbHeaderCount.Position = UDim2.new(1, -44, 0, 0)
	kbHeaderCount.Size = UDim2.fromOffset(32, 38)
	kbHeaderCount.FontFace = FontMedium
	kbHeaderCount.TextSize = 11
	kbHeaderCount.TextXAlignment = Enum.TextXAlignment.Right
	kbHeaderCount.TextColor3 = Library.Theme.TextSubtle
	kbHeaderCount.TextTransparency = 1
	kbHeaderCount.Text = "0"
	kbHeaderCount.ZIndex = 494
	kbHeaderCount.Parent = kbCanvas

	local kbHeaderLine = Instance.new("Frame")
	kbHeaderLine.Position = UDim2.fromOffset(12, 38)
	kbHeaderLine.Size = UDim2.new(1, -12, 0, 1)
	kbHeaderLine.BorderSizePixel = 0
	kbHeaderLine.BackgroundColor3 = Library.Theme.GroupStrokeInner
	kbHeaderLine.BackgroundTransparency = 1
	kbHeaderLine.ZIndex = 494
	kbHeaderLine.Parent = kbCanvas

	local kbRowsContainer = Instance.new("Frame")
	kbRowsContainer.BackgroundTransparency = 1
	kbRowsContainer.Position = UDim2.fromOffset(0, 42)
	kbRowsContainer.Size = UDim2.new(1, 0, 1, -42)
	kbRowsContainer.ZIndex = 494
	kbRowsContainer.Parent = kbCanvas

	MakeDraggable(kbOuter1, kbOuter1, function() return 1 end)

	Library.KeybindFrame = kbOuter1
	Library.KeybindPickers = {}

	function Library:SetKeybindListVisibility(visible)
		self.KeybindListEnabled = (visible == true)
	end

	local kbFade = 0
	local kbHeightCurrent = 48
	local kbRowPool = {}

	Library:BindStep(function(dt)
		local targetVis = Library.KeybindListEnabled and 1 or 0
		kbFade += (targetVis - kbFade) * math.min(1, dt * 10)
		if math.abs(targetVis - kbFade) < 0.002 then
			kbFade = targetVis
		end
		local a = SmoothStep(kbFade)
		kbOuter1.Visible = a > 0.005
		if not kbOuter1.Visible then
			return
		end

		local th = Library.Theme
		local entries = {}
		for _, kp in ipairs(Library.KeybindPickers) do
			if not kp.NoUI and kp.Value and kp.Value ~= "None" and kp.Value ~= "" then
				table.insert(entries, kp)
			end
		end

		local activeTotal = 0
		for idx, kp in ipairs(entries) do
			local isActive = kp:GetState()
			if isActive then
				activeTotal += 1
			end
			local row = kbRowPool[idx]
			if not row then
				local frame = Instance.new("Frame")
				frame.BackgroundTransparency = 1
				frame.Size = UDim2.new(1, 0, 0, 26)
				frame.ZIndex = 495
				frame.Parent = kbRowsContainer

				local dot = Instance.new("Frame")
				dot.Size = UDim2.fromOffset(4, 4)
				dot.Position = UDim2.fromOffset(14, 11)
				dot.BorderSizePixel = 0
				dot.ZIndex = 496
				dot.Parent = frame
				Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

				local nameLbl = Instance.new("TextLabel")
				nameLbl.BackgroundTransparency = 1
				nameLbl.Position = UDim2.fromOffset(24, 0)
				nameLbl.Size = UDim2.new(1, -96, 1, 0)
				nameLbl.FontFace = FontMedium
				nameLbl.TextSize = 12
				nameLbl.TextXAlignment = Enum.TextXAlignment.Left
				nameLbl.TextTruncate = Enum.TextTruncate.AtEnd
				nameLbl.ZIndex = 496
				nameLbl.Parent = frame

				local badge = Instance.new("Frame")
				badge.BorderSizePixel = 0
				badge.ZIndex = 496
				badge.Parent = frame
				Instance.new("UICorner", badge).CornerRadius = UDim.new(0, 3)

				local badgeStroke = Instance.new("UIStroke")
				badgeStroke.Thickness = 1
				badgeStroke.Parent = badge

				local badgeTxt = Instance.new("TextLabel")
				badgeTxt.BackgroundTransparency = 1
				badgeTxt.Size = UDim2.fromScale(1, 1)
				badgeTxt.FontFace = FontBold
				badgeTxt.TextSize = 10
				badgeTxt.ZIndex = 497
				badgeTxt.Parent = badge

				row = {
					Frame = frame,
					Dot = dot,
					Name = nameLbl,
					Badge = badge,
					BadgeStroke = badgeStroke,
					BadgeText = badgeTxt,
					ActiveMix = isActive and 1 or 0,
				}
				kbRowPool[idx] = row
			end

			row.Frame.Visible = true
			row.Frame.Position = UDim2.fromOffset(0, (idx - 1) * 26)
			local tMix = isActive and 1 or 0
			row.ActiveMix += (tMix - row.ActiveMix) * math.min(1, dt * 12)
			local m = SmoothStep(row.ActiveMix)

			row.Dot.BackgroundColor3 = LerpColor(th.TextMuted, th.Accent, m)
			row.Dot.BackgroundTransparency = 1 - a

			row.Name.Text = kp.Text or kp.Index or "Bind"
			row.Name.TextColor3 = LerpColor(th.TextSubtle, th.TextBright, m)
			row.Name.TextTransparency = 1 - a

			local keyDisp = FormatKeyName(kp.Value)
			local bw = math.max(28, CalcTextBounds(keyDisp, FontBold, 10).X + 14)
			row.Badge.Size = UDim2.fromOffset(bw, 18)
			row.Badge.Position = UDim2.new(1, -(bw + 12), 0, 4)
			row.Badge.BackgroundColor3 = LerpColor(th.ControlBg, th.ControlHover, m)
			row.Badge.BackgroundTransparency = 1 - a
			row.BadgeStroke.Color = LerpColor(th.ControlStroke, th.Accent, m * 0.65)
			row.BadgeStroke.Transparency = 1 - a
			row.BadgeText.Text = keyDisp
			row.BadgeText.TextColor3 = LerpColor(th.TextDim, th.Accent, m)
			row.BadgeText.TextTransparency = 1 - a
		end

		for i = #entries + 1, #kbRowPool do
			kbRowPool[i].Frame.Visible = false
		end

		kbHeaderCount.Text = tostring(activeTotal) .. "/" .. tostring(#entries)
		local targetH = 46 + (#entries > 0 and (#entries * 26 + 6) or 28)

		if #entries == 0 then
			if not kbRowsContainer:FindFirstChild("EmptyHint") then
				local empty = Instance.new("TextLabel")
				empty.Name = "EmptyHint"
				empty.BackgroundTransparency = 1
				empty.Size = UDim2.new(1, 0, 0, 24)
				empty.FontFace = FontMedium
				empty.TextSize = 12
				empty.Text = "No active binds"
				empty.ZIndex = 495
				empty.Parent = kbRowsContainer
			end
			local eh = kbRowsContainer:FindFirstChild("EmptyHint")
			eh.Visible = true
			eh.TextColor3 = th.TextMuted
			eh.TextTransparency = 1 - a
		else
			local eh = kbRowsContainer:FindFirstChild("EmptyHint")
			if eh then
				eh.Visible = false
			end
		end

		kbHeightCurrent += (targetH - kbHeightCurrent) * math.min(1, dt * 14)
		kbOuter1.Size = UDim2.fromOffset(226, math.floor(kbHeightCurrent + 0.5))

		kbOuter1.BackgroundColor3 = th.OuterBorder1
		kbOuter1.BackgroundTransparency = 1 - (0.47 * a)
		kbOuter2.BackgroundColor3 = th.OuterBorder2
		kbOuter2.BackgroundTransparency = 1 - (0.47 * a)
		kbCanvas.BackgroundColor3 = th.GroupBg
		kbCanvas.BackgroundTransparency = 1 - a
		kbStroke.Color = th.GroupStrokeInner
		kbStroke.Transparency = 1 - a
		kbHeaderIcon:SetColor(th.Accent)
		kbHeaderIcon:SetTransparency(1 - a)
		kbHeaderTitle.TextColor3 = th.TextPrimary
		kbHeaderTitle.TextTransparency = 1 - a
		kbHeaderCount.TextColor3 = activeTotal > 0 and th.Accent or th.TextSubtle
		kbHeaderCount.TextTransparency = 1 - a
		kbHeaderLine.BackgroundColor3 = th.GroupStrokeInner
		kbHeaderLine.BackgroundTransparency = 1 - a
	end)
end

-- ============================================================================
-- NOTIFICATIONS (ech0.fun toast stack)
-- ============================================================================
do
	local notifHolder = Instance.new("Frame")
	notifHolder.Name = "Notifications"
	notifHolder.AnchorPoint = Vector2.new(1, 1)
	notifHolder.Position = UDim2.new(1, -18, 1, -18)
	notifHolder.Size = UDim2.fromOffset(290, 420)
	notifHolder.BackgroundTransparency = 1
	notifHolder.ZIndex = 800
	notifHolder.Parent = Library.ScreenGui

	local activeToasts = {}

	function Library:Notify(text, duration)
		local life = tonumber(duration) or 3.5
		local msg = tostring(text or "")
		local tw = math.clamp(CalcTextBounds(msg, FontMedium, 12).X + 52, 190, 310)

		local shell = Instance.new("Frame")
		shell.AnchorPoint = Vector2.new(1, 1)
		shell.Size = UDim2.fromOffset(tw, 38)
		shell.Position = UDim2.new(1, 40, 1, 0)
		shell.BackgroundColor3 = self.Theme.GroupBg
		shell.BackgroundTransparency = 1
		shell.BorderSizePixel = 0
		shell.ZIndex = 801
		shell.Parent = notifHolder
		Instance.new("UICorner", shell).CornerRadius = UDim.new(0, 3)

		local stroke = Instance.new("UIStroke")
		stroke.Color = self.Theme.GroupStrokeInner
		stroke.Thickness = 1
		stroke.Transparency = 1
		stroke.Parent = shell

		local icon = self:CreateIcon(shell, "logo", 13, self.Theme.Accent, 803)
		icon.Instance.Position = UDim2.fromOffset(12, 12)
		icon:SetTransparency(1)

		local lbl = Instance.new("TextLabel")
		lbl.BackgroundTransparency = 1
		lbl.Position = UDim2.fromOffset(33, 0)
		lbl.Size = UDim2.new(1, -42, 1, -2)
		lbl.FontFace = FontMedium
		lbl.TextSize = 12
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.TextTruncate = Enum.TextTruncate.AtEnd
		lbl.TextColor3 = self.Theme.TextPrimary
		lbl.TextTransparency = 1
		lbl.Text = msg
		lbl.ZIndex = 803
		lbl.Parent = shell

		local bar = Instance.new("Frame")
		bar.AnchorPoint = Vector2.new(0, 1)
		bar.Position = UDim2.new(0, 0, 1, 0)
		bar.Size = UDim2.new(1, 0, 0, 2)
		bar.BorderSizePixel = 0
		bar.BackgroundColor3 = self.Theme.Accent
		bar.BackgroundTransparency = 1
		bar.ZIndex = 804
		bar.Parent = shell

		local toast = {
			Shell = shell,
			Stroke = stroke,
			Icon = icon,
			Label = lbl,
			Bar = bar,
			Width = tw,
			Elapsed = 0,
			Duration = life,
			Fade = 0,
			TargetY = 0,
			CurrentY = 0,
		}
		table.insert(activeToasts, 1, toast)
	end

	Library:BindStep(function(dt)
		local th = Library.Theme
		for i = #activeToasts, 1, -1 do
			local t = activeToasts[i]
			t.Elapsed += dt
			local closing = t.Elapsed >= t.Duration
			local targetF = closing and 0 or 1
			t.Fade += (targetF - t.Fade) * math.min(1, dt * 11)
			t.TargetY = -((i - 1) * 44)
			t.CurrentY += (t.TargetY - t.CurrentY) * math.min(1, dt * 14)
			local e = SmoothStep(t.Fade)
			local slideX = (1 - e) * 32
			t.Shell.Position = UDim2.new(1, math.floor(slideX), 1, math.floor(t.CurrentY))
			t.Shell.BackgroundColor3 = th.GroupBg
			t.Shell.BackgroundTransparency = 1 - e
			t.Stroke.Color = th.GroupStrokeInner
			t.Stroke.Transparency = 1 - e
			t.Icon:SetColor(th.Accent)
			t.Icon:SetTransparency(1 - e)
			t.Label.TextColor3 = th.TextPrimary
			t.Label.TextTransparency = 1 - e
			t.Bar.BackgroundColor3 = th.Accent
			t.Bar.BackgroundTransparency = 1 - e
			local pct = math.clamp(1 - (t.Elapsed / t.Duration), 0, 1)
			t.Bar.Size = UDim2.fromOffset(math.floor(t.Width * pct), 2)

			if closing and t.Fade <= 0.02 then
				DisposeInstance(t.Shell)
				table.remove(activeToasts, i)
			end
		end
	end)
end

-- ============================================================================
-- GLOBAL KEYBIND & INPUT DISPATCHER
-- ============================================================================
Library.ActiveKeyCapture = nil

local function MatchesKeyInput(val, input)
	if not val or val == "None" then
		return false
	end
	if input.UserInputType == Enum.UserInputType.Keyboard then
		return input.KeyCode.Name == val or KeyShortNames[input.KeyCode] == val
	elseif
		input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.MouseButton2
		or input.UserInputType == Enum.UserInputType.MouseButton3
	then
		local short = FormatKeyName(input.UserInputType)
		return input.UserInputType.Name == val or short == val
	end
	return false
end

Library:GiveSignal(UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if Library.Unloaded then
		return
	end
	if UserInputService:GetFocusedTextBox() then
		return
	end

	-- Active keybind capture (Esc clears to None, matching main.cpp)
	if Library.ActiveKeyCapture then
		local cap = Library.ActiveKeyCapture
		if cap.SkipFrame then
			cap.SkipFrame = false
			return
		end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			Library.ActiveKeyCapture = nil
			if input.KeyCode == Enum.KeyCode.Escape or input.KeyCode == Enum.KeyCode.Backspace then
				cap:SetValue({ "None", cap.Mode })
			elseif input.KeyCode ~= Enum.KeyCode.Unknown then
				cap:SetValue({ input.KeyCode.Name, cap.Mode })
			end
			return
		elseif
			input.UserInputType == Enum.UserInputType.MouseButton2
			or input.UserInputType == Enum.UserInputType.MouseButton3
		then
			Library.ActiveKeyCapture = nil
			cap:SetValue({ input.UserInputType.Name, cap.Mode })
			return
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			Library.ActiveKeyCapture = nil
			cap:SetValue({ "MouseButton1", cap.Mode })
			return
		end
	end

	if gameProcessed then
		return
	end

	-- Menu toggle keybind check
	if Library.ToggleKeybind then
		if MatchesKeyInput(Library.ToggleKeybind.Value, input) then
			Library:Toggle()
			return
		end
	elseif Library.MenuKeyCode and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Library.MenuKeyCode then
		Library:Toggle()
		return
	end

	-- Update all registered KeyPickers
	for _, kp in ipairs(Library.KeybindPickers) do
		if kp ~= Library.ToggleKeybind and MatchesKeyInput(kp.Value, input) then
			if kp.Mode == "Toggle" then
				kp.Toggled = not kp.Toggled
				if kp.SyncToggleState and kp.ParentToggle then
					kp.ParentToggle:SetValue(kp.Toggled)
				end
				Library:SafeCallback(kp.Callback, kp.Toggled)
				for _, cb in ipairs(kp.ChangedCallbacks) do
					Library:SafeCallback(cb, kp.Toggled)
				end
			elseif kp.Mode == "Hold" then
				kp.Holding = true
				if kp.SyncToggleState and kp.ParentToggle then
					kp.ParentToggle:SetValue(true)
				end
				Library:SafeCallback(kp.Callback, true)
			end
		end
	end
end))

Library:GiveSignal(UserInputService.InputEnded:Connect(function(input)
	if Library.Unloaded then
		return
	end
	for _, kp in ipairs(Library.KeybindPickers) do
		if kp.Mode == "Hold" and kp.Holding and MatchesKeyInput(kp.Value, input) then
			kp.Holding = false
			if kp.SyncToggleState and kp.ParentToggle then
				kp.ParentToggle:SetValue(false)
			end
			Library:SafeCallback(kp.Callback, false)
		end
	end
end))

function Library:UpdateDependencyBoxes()
	for _, dep in ipairs(self.DependencyBoxes) do
		if dep and dep.Update then
			dep:Update()
		end
	end
end

-- ============================================================================
-- ELEMENT CONSTRUCTORS (KeyPicker, ColorPicker, GearPopup, Groupbox Widgets)
-- ============================================================================
local ClipboardColor = Color3.fromRGB(142, 134, 246)
local ClipboardTransparency = 0

local function ColorToHex(c)
	return string.format(
		"%02X%02X%02X",
		math.clamp(math.floor(c.R * 255 + 0.5), 0, 255),
		math.clamp(math.floor(c.G * 255 + 0.5), 0, 255),
		math.clamp(math.floor(c.B * 255 + 0.5), 0, 255)
	)
end

local function HexToColor(hex)
	hex = string.gsub(tostring(hex or ""), "^#", "")
	if #hex ~= 6 then
		return nil
	end
	local r = tonumber(string.sub(hex, 1, 2), 16)
	local g = tonumber(string.sub(hex, 3, 4), 16)
	local b = tonumber(string.sub(hex, 5, 6), 16)
	if not r or not g or not b then
		return nil
	end
	return Color3.fromRGB(r, g, b)
end

local function CreateKeyPickerObject(idx, info, parentToggle)
	info = info or {}
	local defaultKey = info.Default or "None"
	if typeof(defaultKey) == "EnumItem" then
		defaultKey = defaultKey.Name
	end
	local kp = {
		Type = "KeyPicker",
		Index = idx,
		Text = info.Text or (parentToggle and parentToggle.Text) or idx,
		Value = tostring(defaultKey),
		Mode = info.Mode or "Toggle",
		Toggled = (info.DefaultToggled == true),
		Holding = false,
		NoUI = (info.NoUI == true),
		SyncToggleState = (info.SyncToggleState == true),
		ParentToggle = parentToggle,
		Callback = info.Callback,
		ChangedCallback = info.ChangedCallback,
		ChangedCallbacks = {},
		RefreshVisuals = {},
	}

	function kp:GetState()
		if self.Mode == "Always" then
			return true
		elseif self.Mode == "Hold" then
			return self.Holding == true
		else
			if self.SyncToggleState and self.ParentToggle then
				return self.ParentToggle.Value == true
			end
			return self.Toggled == true
		end
	end

	function kp:SetValue(data)
		if type(data) == "table" then
			local newKey = data[1] or data.Key or self.Value
			if typeof(newKey) == "EnumItem" then
				newKey = newKey.Name
			end
			self.Value = tostring(newKey)
			if data[2] or data.Mode then
				self.Mode = tostring(data[2] or data.Mode)
			end
		elseif typeof(data) == "EnumItem" then
			self.Value = data.Name
		elseif type(data) == "string" then
			self.Value = data
		end
		for _, fn in ipairs(self.RefreshVisuals) do
			fn()
		end
		Library:SafeCallback(self.ChangedCallback, self.Value)
		for _, cb in ipairs(self.ChangedCallbacks) do
			Library:SafeCallback(cb, self.Value)
		end
	end

	function kp:OnClick(fn)
		self.Callback = fn
		return self
	end

	function kp:OnChanged(fn)
		table.insert(self.ChangedCallbacks, fn)
		return self
	end

	if idx then
		Options[idx] = kp
	end
	table.insert(Library.KeybindPickers, kp)
	return kp
end

local function CreateColorPickerObject(idx, info)
	info = info or {}
	local defaultColor = info.Default or Color3.fromRGB(142, 134, 246)
	local h, s, v = Color3.toHSV(defaultColor)
	local cp = {
		Type = "ColorPicker",
		Index = idx,
		Title = info.Title or idx or "Color",
		Value = defaultColor,
		Transparency = info.Transparency or 0,
		HasAlpha = (info.Transparency ~= nil),
		Hue = h,
		Sat = s,
		Val = v,
		Callback = info.Callback,
		ChangedCallbacks = {},
		RefreshVisuals = {},
	}

	function cp:SetHSVFromRGB(col)
		local nh, ns, nv = Color3.toHSV(col)
		if ns > 0.001 then
			self.Hue = nh
		end
		self.Sat = ns
		self.Val = nv
	end

	function cp:Display()
		for _, fn in ipairs(self.RefreshVisuals) do
			fn()
		end
	end

	function cp:SetValueRGB(col, trans)
		if typeof(col) == "Color3" then
			self.Value = col
			self:SetHSVFromRGB(col)
		end
		if type(trans) == "number" then
			self.Transparency = math.clamp(trans, 0, 1)
		end
		self:Display()
		Library:SafeCallback(self.Callback, self.Value)
		for _, cb in ipairs(self.ChangedCallbacks) do
			Library:SafeCallback(cb, self.Value)
		end
	end

	function cp:SetValue(hsvTable, trans)
		if type(hsvTable) == "table" then
			self.Hue = tonumber(hsvTable[1]) or self.Hue
			self.Sat = tonumber(hsvTable[2]) or self.Sat
			self.Val = tonumber(hsvTable[3]) or self.Val
			self.Value = Color3.fromHSV(self.Hue, self.Sat, self.Val)
		elseif typeof(hsvTable) == "Color3" then
			self:SetValueRGB(hsvTable, trans)
			return
		end
		if type(trans) == "number" then
			self.Transparency = math.clamp(trans, 0, 1)
		end
		self:Display()
		Library:SafeCallback(self.Callback, self.Value)
		for _, cb in ipairs(self.ChangedCallbacks) do
			Library:SafeCallback(cb, self.Value)
		end
	end

	function cp:OnChanged(fn)
		table.insert(self.ChangedCallbacks, fn)
		return self
	end

	if idx then
		Options[idx] = cp
	end
	return cp
end

local function BuildFloatingColorPicker(windowCtx)
	local card = Instance.new("Frame")
	card.Name = "ColorPickerPopup"
	card.Size = UDim2.fromOffset(220, 232)
	card.BackgroundColor3 = Library.Theme.PopupBg
	card.BorderSizePixel = 0
	card.Visible = false
	card.ZIndex = 320
	card.Parent = windowCtx.FloatingLayer
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 3)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Library.Theme.PopupStroke
	stroke.Thickness = 1
	stroke.Parent = card

	local shadow = Instance.new("Frame")
	shadow.Position = UDim2.fromOffset(4, 5)
	shadow.Size = UDim2.fromScale(1, 1)
	shadow.BackgroundColor3 = Color3.new(0, 0, 0)
	shadow.BackgroundTransparency = 0.65
	shadow.BorderSizePixel = 0
	shadow.ZIndex = 319
	shadow.Parent = card
	Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 3)

	local titleLbl = Instance.new("TextLabel")
	titleLbl.BackgroundTransparency = 1
	titleLbl.Position = UDim2.fromOffset(12, 8)
	titleLbl.Size = UDim2.fromOffset(118, 20)
	titleLbl.FontFace = FontBold
	titleLbl.TextSize = 12
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.TextColor3 = Library.Theme.TextPrimary
	titleLbl.Text = "Color"
	titleLbl.ZIndex = 322
	titleLbl.Parent = card

	local hexBox = Instance.new("TextBox")
	hexBox.Position = UDim2.fromOffset(136, 7)
	hexBox.Size = UDim2.fromOffset(72, 22)
	hexBox.BackgroundColor3 = Library.Theme.ControlBg
	hexBox.BorderSizePixel = 0
	hexBox.FontFace = FontMedium
	hexBox.TextSize = 11
	hexBox.TextColor3 = Library.Theme.TextPrimary
	hexBox.PlaceholderText = "#8E86F6"
	hexBox.ClearTextOnFocus = false
	hexBox.Text = "#8E86F6"
	hexBox.ZIndex = 322
	hexBox.Parent = card
	Instance.new("UICorner", hexBox).CornerRadius = UDim.new(0, 2)
	local hexStroke = Instance.new("UIStroke")
	hexStroke.Color = Library.Theme.ControlStroke
	hexStroke.Thickness = 1
	hexStroke.Parent = hexBox

	-- Saturation / Value 2D square
	local svSquare = Instance.new("Frame")
	svSquare.Position = UDim2.fromOffset(12, 35)
	svSquare.Size = UDim2.fromOffset(196, 122)
	svSquare.BackgroundColor3 = Color3.fromHSV(0.7, 1, 1)
	svSquare.BorderSizePixel = 0
	svSquare.ZIndex = 322
	svSquare.Parent = card
	Instance.new("UICorner", svSquare).CornerRadius = UDim.new(0, 2)

	local satLayer = Instance.new("Frame")
	satLayer.Size = UDim2.fromScale(1, 1)
	satLayer.BackgroundColor3 = Color3.new(1, 1, 1)
	satLayer.BorderSizePixel = 0
	satLayer.ZIndex = 323
	satLayer.Parent = svSquare
	Instance.new("UICorner", satLayer).CornerRadius = UDim.new(0, 2)
	local satGrad = Instance.new("UIGradient")
	satGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1),
	})
	satGrad.Parent = satLayer

	local valLayer = Instance.new("Frame")
	valLayer.Size = UDim2.fromScale(1, 1)
	valLayer.BackgroundColor3 = Color3.new(0, 0, 0)
	valLayer.BorderSizePixel = 0
	valLayer.ZIndex = 324
	valLayer.Parent = svSquare
	Instance.new("UICorner", valLayer).CornerRadius = UDim.new(0, 2)
	local valGrad = Instance.new("UIGradient")
	valGrad.Rotation = 90
	valGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(1, 0),
	})
	valGrad.Parent = valLayer

	local svCursor = Instance.new("Frame")
	svCursor.AnchorPoint = Vector2.new(0.5, 0.5)
	svCursor.Size = UDim2.fromOffset(10, 10)
	svCursor.BackgroundTransparency = 1
	svCursor.ZIndex = 325
	svCursor.Parent = svSquare
	Instance.new("UICorner", svCursor).CornerRadius = UDim.new(1, 0)
	local svCursorStroke = Instance.new("UIStroke")
	svCursorStroke.Color = Color3.new(1, 1, 1)
	svCursorStroke.Thickness = 1.5
	svCursorStroke.Parent = svCursor

	-- Hue bar
	local hueBar = Instance.new("Frame")
	hueBar.Position = UDim2.fromOffset(12, 165)
	hueBar.Size = UDim2.fromOffset(196, 10)
	hueBar.BackgroundColor3 = Color3.new(1, 1, 1)
	hueBar.BorderSizePixel = 0
	hueBar.ZIndex = 322
	hueBar.Parent = card
	Instance.new("UICorner", hueBar).CornerRadius = UDim.new(0, 3)

	local hueGrad = Instance.new("UIGradient")
	hueGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)),
		ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
		ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
		ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0)),
	})
	hueGrad.Parent = hueBar

	local hueKnob = Instance.new("Frame")
	hueKnob.AnchorPoint = Vector2.new(0.5, 0.5)
	hueKnob.Position = UDim2.new(0, 0, 0.5, 0)
	hueKnob.Size = UDim2.fromOffset(6, 14)
	hueKnob.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
	hueKnob.BorderSizePixel = 0
	hueKnob.ZIndex = 324
	hueKnob.Parent = hueBar
	Instance.new("UICorner", hueKnob).CornerRadius = UDim.new(0, 2)

	-- Alpha / Transparency bar
	local alphaBar = Instance.new("Frame")
	alphaBar.Position = UDim2.fromOffset(12, 183)
	alphaBar.Size = UDim2.fromOffset(196, 10)
	alphaBar.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
	alphaBar.BorderSizePixel = 0
	alphaBar.ZIndex = 322
	alphaBar.Parent = card
	Instance.new("UICorner", alphaBar).CornerRadius = UDim.new(0, 3)

	local alphaFill = Instance.new("Frame")
	alphaFill.Size = UDim2.fromScale(1, 1)
	alphaFill.BackgroundColor3 = Color3.new(1, 1, 1)
	alphaFill.BorderSizePixel = 0
	alphaFill.ZIndex = 323
	alphaFill.Parent = alphaBar
	Instance.new("UICorner", alphaFill).CornerRadius = UDim.new(0, 3)
	local alphaGrad = Instance.new("UIGradient")
	alphaGrad.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(1, 1),
	})
	alphaGrad.Parent = alphaFill

	local alphaKnob = Instance.new("Frame")
	alphaKnob.AnchorPoint = Vector2.new(0.5, 0.5)
	alphaKnob.Position = UDim2.new(0, 0, 0.5, 0)
	alphaKnob.Size = UDim2.fromOffset(6, 14)
	alphaKnob.BackgroundColor3 = Color3.fromRGB(240, 240, 245)
	alphaKnob.BorderSizePixel = 0
	alphaKnob.ZIndex = 324
	alphaKnob.Parent = alphaBar
	Instance.new("UICorner", alphaKnob).CornerRadius = UDim.new(0, 2)

	-- Copy / Paste action buttons
	local copyBtn = Instance.new("TextButton")
	copyBtn.Position = UDim2.fromOffset(12, 201)
	copyBtn.Size = UDim2.fromOffset(94, 22)
	copyBtn.BackgroundColor3 = Library.Theme.ControlBg
	copyBtn.BorderSizePixel = 0
	copyBtn.FontFace = FontBold
	copyBtn.TextSize = 11
	copyBtn.TextColor3 = Library.Theme.TextLabel
	copyBtn.Text = "Copy"
	copyBtn.AutoButtonColor = false
	copyBtn.ZIndex = 322
	copyBtn.Parent = card
	Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 2)

	local pasteBtn = Instance.new("TextButton")
	pasteBtn.Position = UDim2.fromOffset(114, 201)
	pasteBtn.Size = UDim2.fromOffset(94, 22)
	pasteBtn.BackgroundColor3 = Library.Theme.ControlBg
	pasteBtn.BorderSizePixel = 0
	pasteBtn.FontFace = FontBold
	pasteBtn.TextSize = 11
	pasteBtn.TextColor3 = Library.Theme.TextLabel
	pasteBtn.Text = "Paste"
	pasteBtn.AutoButtonColor = false
	pasteBtn.ZIndex = 322
	pasteBtn.Parent = card
	Instance.new("UICorner", pasteBtn).CornerRadius = UDim.new(0, 2)

	local state = {
		Open = false,
		Fade = 0,
		TargetCP = nil,
		AnchorBtn = nil,
		BasePos = Vector2.zero,
		DragSV = false,
		DragHue = false,
		DragAlpha = false,
	}

	local function RefreshPickerUI()
		local cp = state.TargetCP
		if not cp then
			return
		end
		titleLbl.Text = cp.Title or "Color"
		svSquare.BackgroundColor3 = Color3.fromHSV(cp.Hue, 1, 1)
		svCursor.Position = UDim2.fromScale(cp.Sat, 1 - cp.Val)
		hueKnob.Position = UDim2.new(cp.Hue, 0, 0.5, 0)
		alphaFill.BackgroundColor3 = cp.Value
		alphaKnob.Position = UDim2.new(cp.Transparency, 0, 0.5, 0)
		alphaBar.Visible = cp.HasAlpha
		if cp.HasAlpha then
			copyBtn.Position = UDim2.fromOffset(12, 201)
			pasteBtn.Position = UDim2.fromOffset(114, 201)
			card.Size = UDim2.fromOffset(220, 232)
		else
			copyBtn.Position = UDim2.fromOffset(12, 184)
			pasteBtn.Position = UDim2.fromOffset(114, 184)
			card.Size = UDim2.fromOffset(220, 215)
		end
		if not hexBox:IsFocused() then
			hexBox.Text = "#" .. ColorToHex(cp.Value)
		end
	end

	Library:GiveSignal(hexBox.FocusLost:Connect(function()
		if not state.TargetCP then
			return
		end
		local parsed = HexToColor(hexBox.Text)
		if parsed then
			state.TargetCP:SetValueRGB(parsed, state.TargetCP.Transparency)
		end
		RefreshPickerUI()
	end))

	copyBtn.MouseButton1Click:Connect(function()
		if state.TargetCP then
			ClipboardColor = state.TargetCP.Value
			ClipboardTransparency = state.TargetCP.Transparency
		end
	end)

	pasteBtn.MouseButton1Click:Connect(function()
		if state.TargetCP and ClipboardColor then
			state.TargetCP:SetValueRGB(ClipboardColor, state.TargetCP.HasAlpha and ClipboardTransparency or 0)
			RefreshPickerUI()
		end
	end)

	local function UpdateDragFromMouse(mpos)
		local cp = state.TargetCP
		if not cp then
			return
		end
		if state.DragSV then
			local rel = mpos - svSquare.AbsolutePosition
			local sz = svSquare.AbsoluteSize
			cp.Sat = math.clamp(rel.X / math.max(1, sz.X), 0, 1)
			cp.Val = 1 - math.clamp(rel.Y / math.max(1, sz.Y), 0, 1)
			cp.Value = Color3.fromHSV(cp.Hue, cp.Sat, cp.Val)
			cp:SetValue({ cp.Hue, cp.Sat, cp.Val }, cp.Transparency)
			RefreshPickerUI()
		elseif state.DragHue then
			local relX = mpos.X - hueBar.AbsolutePosition.X
			cp.Hue = math.clamp(relX / math.max(1, hueBar.AbsoluteSize.X), 0, 1)
			cp.Value = Color3.fromHSV(cp.Hue, cp.Sat, cp.Val)
			cp:SetValue({ cp.Hue, cp.Sat, cp.Val }, cp.Transparency)
			RefreshPickerUI()
		elseif state.DragAlpha and cp.HasAlpha then
			local relX = mpos.X - alphaBar.AbsolutePosition.X
			local tr = math.clamp(relX / math.max(1, alphaBar.AbsoluteSize.X), 0, 1)
			cp:SetValue({ cp.Hue, cp.Sat, cp.Val }, tr)
			RefreshPickerUI()
		end
	end

	Library:GiveSignal(svSquare.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 and state.Open then
			state.DragSV = true
			UpdateDragFromMouse(Vector2.new(inp.Position.X, inp.Position.Y))
		end
	end))
	Library:GiveSignal(hueBar.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 and state.Open then
			state.DragHue = true
			UpdateDragFromMouse(Vector2.new(inp.Position.X, inp.Position.Y))
		end
	end))
	Library:GiveSignal(alphaBar.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 and state.Open then
			state.DragAlpha = true
			UpdateDragFromMouse(Vector2.new(inp.Position.X, inp.Position.Y))
		end
	end))
	Library:GiveSignal(UserInputService.InputChanged:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseMovement and (state.DragSV or state.DragHue or state.DragAlpha) then
			UpdateDragFromMouse(Vector2.new(inp.Position.X, inp.Position.Y))
		end
	end))
	Library:GiveSignal(UserInputService.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 then
			state.DragSV = false
			state.DragHue = false
			state.DragAlpha = false
		end
	end))

	function state:ToggleFor(cp, anchorFrame)
		if self.Open and self.TargetCP == cp then
			self.Open = false
			return
		end
		windowCtx:CloseFloatingPopups("color")
		self.TargetCP = cp
		self.AnchorBtn = anchorFrame
		self.Open = true
		RefreshPickerUI()
	end

	function state:Close()
		self.Open = false
		self.DragSV = false
		self.DragHue = false
		self.DragAlpha = false
	end

	function state:Step(dt)
		local target = self.Open and 1 or 0
		self.Fade += (target - self.Fade) * math.min(1, dt * 13)
		if math.abs(target - self.Fade) < 0.002 then
			self.Fade = target
		end
		local e = SmoothStep(self.Fade)
		card.Visible = e > 0.005
		if not card.Visible then
			return
		end
		local th = Library.Theme
		card.BackgroundColor3 = th.PopupBg
		card.BackgroundTransparency = 1 - e
		stroke.Color = th.PopupStroke
		stroke.Transparency = 1 - e
		shadow.BackgroundTransparency = 1 - (0.35 * e)
		titleLbl.TextColor3 = th.TextPrimary
		hexBox.BackgroundColor3 = th.ControlBg
		hexBox.TextColor3 = th.TextPrimary
		hexStroke.Color = th.ControlStroke
		copyBtn.BackgroundColor3 = th.ControlBg
		copyBtn.TextColor3 = th.TextLabel
		pasteBtn.BackgroundColor3 = th.ControlBg
		pasteBtn.TextColor3 = th.TextLabel

		if self.AnchorBtn and self.AnchorBtn.Parent then
			local sc = math.max(0.25, windowCtx.CurrentScale)
			local rel = (self.AnchorBtn.AbsolutePosition - windowCtx.Root.AbsolutePosition) / sc
			local px = rel.X + 22
			local py = math.clamp(rel.Y - 12, 46, 550 - card.Size.Y.Offset)
			local slideY = (1 - e) * -8
			card.Position = UDim2.fromOffset(math.floor(px + 0.5), math.floor(py + slideY + 0.5))
		end
	end

	state.Card = card
	return state
end

local function BuildFloatingDropdown(windowCtx)
	local outer = Instance.new("Frame")
	outer.Name = "DropdownPopup_Outer"
	outer.BackgroundTransparency = 1
	outer.Visible = false
	outer.ZIndex = 330
	outer.Parent = windowCtx.FloatingLayer
	Instance.new("UICorner", outer).CornerRadius = UDim.new(0, 4)

	local outerStroke = Instance.new("UIStroke")
	outerStroke.Color = Color3.fromRGB(15, 15, 15)
	outerStroke.Thickness = 1
	outerStroke.Parent = outer

	local box = Instance.new("Frame")
	box.Name = "DropdownPopup"
	box.Position = UDim2.fromOffset(1, 1)
	box.Size = UDim2.new(1, -2, 1, -2)
	box.BackgroundColor3 = Library.Theme.ControlBg
	box.BorderSizePixel = 0
	box.ClipsDescendants = true
	box.ZIndex = 331
	box.Parent = outer
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 3)

	local innerStroke = Instance.new("UIStroke")
	innerStroke.Color = Color3.fromRGB(26, 26, 26)
	innerStroke.Thickness = 1
	innerStroke.Parent = box

	local scroll = Instance.new("ScrollingFrame")
	scroll.Position = UDim2.fromOffset(7, 7)
	scroll.Size = UDim2.new(1, -14, 1, -14)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 2
	scroll.ScrollBarImageColor3 = Library.Theme.Accent
	scroll.CanvasSize = UDim2.fromOffset(0, 0)
	scroll.ZIndex = 332
	scroll.Parent = box

	local state = {
		Open = false,
		Fade = 0,
		TargetDD = nil,
		AnchorFrame = nil,
		RowPool = {},
		FullHeight = 120,
		Width = 265,
	}

	local function RebuildRows()
		local dd = state.TargetDD
		if not dd then
			return
		end
		local values = dd.Values or {}
		local itemH = 28
		local totalH = #values * itemH
		scroll.CanvasSize = UDim2.fromOffset(0, totalH)
		state.FullHeight = math.clamp(totalH + 14, 42, 190)
		state.Width = dd.BoxWidth or 265

		for idx, itemName in ipairs(values) do
			local slot = state.RowPool[idx]
			if not slot then
				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(1, 0, 0, itemH)
				btn.BorderSizePixel = 0
				btn.AutoButtonColor = false
				btn.Text = ""
				btn.ZIndex = 333
				btn.Parent = scroll
				Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 2)

				local checkIcon = Library:CreateIcon(btn, "check", 12, Library.Theme.Accent, 334)
				checkIcon.Instance.Position = UDim2.fromOffset(10, 8)

				local txt = Instance.new("TextLabel")
				txt.BackgroundTransparency = 1
				txt.Position = UDim2.fromOffset(11, 0)
				txt.Size = UDim2.new(1, -16, 1, 0)
				txt.FontFace = FontMedium
				txt.TextSize = 13
				txt.TextXAlignment = Enum.TextXAlignment.Left
				txt.TextTruncate = Enum.TextTruncate.AtEnd
				txt.ZIndex = 334
				txt.Parent = btn

				slot = {
					Btn = btn,
					Check = checkIcon,
					Label = txt,
					Hovered = false,
					Mix = 0,
					SlideMix = 0,
					Index = idx,
				}
				btn.MouseEnter:Connect(function()
					slot.Hovered = true
				end)
				btn.MouseLeave:Connect(function()
					slot.Hovered = false
				end)
				btn.MouseButton1Click:Connect(function()
					local curDD = state.TargetDD
					if not curDD then
						return
					end
					local valName = curDD.Values[slot.Index]
					if valName == nil then
						return
					end
					if curDD.Multi then
						curDD.Value[valName] = not curDD.Value[valName]
						curDD:Display()
						curDD:FireChanged()
					else
						if curDD.AllowNull and curDD.Value == valName then
							curDD.Value = nil
						else
							curDD.Value = valName
						end
						curDD:Display()
						curDD:FireChanged()
						state.Open = false
					end
				end)
				state.RowPool[idx] = slot
			end

			slot.Index = idx
			slot.Btn.Visible = true
			slot.Btn.Position = UDim2.fromOffset(0, (idx - 1) * itemH)
			slot.Label.Text = tostring(itemName)
			local isSelected = dd.Multi and (dd.Value[itemName] == true) or (dd.Value == itemName)
			slot.Mix = (isSelected or slot.Hovered) and 1 or 0
			slot.SlideMix = isSelected and 1 or 0
		end

		for i = #values + 1, #state.RowPool do
			state.RowPool[i].Btn.Visible = false
		end
	end

	function state:ToggleFor(dd, anchorFrame)
		if self.Open and self.TargetDD == dd then
			self.Open = false
			return
		end
		windowCtx:CloseFloatingPopups("dropdown")
		self.TargetDD = dd
		self.AnchorFrame = anchorFrame
		self.Open = true
		scroll.CanvasPosition = Vector2.zero
		RebuildRows()
	end

	function state:Close()
		self.Open = false
	end

	function state:RefreshIfTarget(dd)
		if self.TargetDD == dd and self.Open then
			RebuildRows()
		end
	end

	function state:Step(dt)
		local target = self.Open and 1 or 0
		self.Fade += (target - self.Fade) * math.min(1, dt * 6.5)
		if math.abs(target - self.Fade) < 0.002 then
			self.Fade = target
		end
		local e = SmoothStep(self.Fade)
		outer.Visible = e > 0.005
		if not outer.Visible then
			return
		end
		local th = Library.Theme
		local visH = math.max(4, math.floor(self.FullHeight * e + 0.5))
		outer.Size = UDim2.fromOffset(self.Width + 2, visH + 2)
		box.BackgroundColor3 = th.ControlBg
		box.BackgroundTransparency = 1 - e
		innerStroke.Color = th.ControlStroke
		innerStroke.Transparency = 1 - e
		outerStroke.Color = th.ControlOuter
		outerStroke.Transparency = 1 - e
		scroll.ScrollBarImageColor3 = th.Accent

		if self.AnchorFrame and self.AnchorFrame.Parent then
			local sc = math.max(0.25, windowCtx.CurrentScale)
			local rel = (self.AnchorFrame.AbsolutePosition - windowCtx.Root.AbsolutePosition) / sc
			local anchorH = self.AnchorFrame.AbsoluteSize.Y / sc
			local slideY = (1 - e) * -14
			outer.Position = UDim2.fromOffset(
				math.floor(rel.X - 1 + 0.5),
				math.floor(rel.Y + anchorH + 7 + slideY + 0.5)
			)
		end

		local dd = self.TargetDD
		if dd and dd.Values then
			for idx = 1, #dd.Values do
				local slot = self.RowPool[idx]
				if slot and slot.Btn.Visible then
					local valName = dd.Values[idx]
					local sel = dd.Multi and (dd.Value[valName] == true) or (dd.Value == valName)
					local tMix = (sel or slot.Hovered) and 1 or 0
					local tSlide = sel and 1 or 0
					slot.Mix += (tMix - slot.Mix) * math.min(1, dt * 11)
					slot.SlideMix += (tSlide - slot.SlideMix) * math.min(1, dt * 13)
					local m = SmoothStep(slot.Mix)
					local sm = SmoothStep(slot.SlideMix)

					if sel then
						slot.Btn.BackgroundColor3 = th.ControlHover
						slot.Btn.BackgroundTransparency = 1 - e
					elseif slot.Hovered then
						slot.Btn.BackgroundColor3 = LerpColor(th.ControlBg, th.ControlHover, 0.6)
						slot.Btn.BackgroundTransparency = 1 - e
					else
						slot.Btn.BackgroundTransparency = 1
					end

					slot.Check.Instance.Visible = sm > 0.02
					slot.Check:SetColor(th.Accent)
					slot.Check:SetTransparency(1 - (e * sm))

					local offsetX = math.floor(11 + 22 * sm + 0.5)
					slot.Label.Position = UDim2.fromOffset(offsetX, 0)
					slot.Label.Size = UDim2.new(1, -(offsetX + 8), 1, 0)
					slot.Label.TextColor3 = LerpColor(th.TextDim, th.TextPrimary, m)
					slot.Label.TextTransparency = 1 - e
				end
			end
		end
	end

	state.Card = outer
	return state
end

local AttachWidgetFactory

local function CreateFloatingGearPopup(windowCtx, anchorGearBtn, popupWidth)
	local pWidth = popupWidth or 236
	local card = Instance.new("Frame")
	card.Name = "GearSettingsPopup"
	card.Size = UDim2.fromOffset(pWidth, 56)
	card.BackgroundColor3 = Library.Theme.PopupBg
	card.BorderSizePixel = 0
	card.Visible = false
	card.ZIndex = 290
	card.Parent = windowCtx.FloatingLayer
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 3)

	local stroke = Instance.new("UIStroke")
	stroke.Color = Library.Theme.PopupStroke
	stroke.Thickness = 1
	stroke.Parent = card

	local shadow = Instance.new("Frame")
	shadow.Position = UDim2.fromOffset(4, 5)
	shadow.Size = UDim2.fromScale(1, 1)
	shadow.BackgroundColor3 = Color3.new(0, 0, 0)
	shadow.BackgroundTransparency = 0.65
	shadow.BorderSizePixel = 0
	shadow.ZIndex = 289
	shadow.Parent = card
	Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 3)

	local body = Instance.new("Frame")
	body.Name = "Body"
	body.Position = UDim2.fromOffset(0, 10)
	body.Size = UDim2.new(1, 0, 0, 36)
	body.BackgroundTransparency = 1
	body.ZIndex = 292
	body.Parent = card

	local list = Instance.new("UIListLayout")
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0, 6)
	list.Parent = body

	local popupObj = {
		Card = card,
		Container = body,
		ListLayout = list,
		Width = pWidth,
		PadX = 12,
		BaseZ = 293,
		Open = false,
		Fade = 0,
		Order = 0,
	}

	local function RecalcPopupHeight()
		local contentH = list.AbsoluteContentSize.Y
		body.Size = UDim2.new(1, 0, 0, contentH)
		card.Size = UDim2.fromOffset(pWidth, math.max(48, contentH + 20))
	end
	Library:GiveSignal(list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(RecalcPopupHeight))

	function popupObj:NextOrder()
		self.Order += 1
		return self.Order
	end

	function popupObj:AddKeyPicker(idx, info)
		local kp = CreateKeyPickerObject(idx, info, self.ParentToggle)
		local innerW = self.Width - self.PadX * 2

		local wrap = Instance.new("Frame")
		wrap.BackgroundTransparency = 1
		wrap.Size = UDim2.new(1, 0, 0, 58)
		wrap.LayoutOrder = self:NextOrder()
		wrap.ZIndex = self.BaseZ
		wrap.Parent = body

		-- ech0.fun keybind button (height 32, keyboard icon left, key text centered)
		local bindBtn = Instance.new("TextButton")
		bindBtn.Position = UDim2.fromOffset(self.PadX, 0)
		bindBtn.Size = UDim2.fromOffset(innerW, 32)
		bindBtn.BackgroundColor3 = Library.Theme.ControlBg
		bindBtn.BorderSizePixel = 0
		bindBtn.AutoButtonColor = false
		bindBtn.Text = ""
		bindBtn.ZIndex = self.BaseZ + 1
		bindBtn.Parent = wrap
		Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0, 3)

		local bindStroke = Instance.new("UIStroke")
		bindStroke.Color = Library.Theme.ControlStroke
		bindStroke.Thickness = 1
		bindStroke.Parent = bindBtn

		local kbIcon = Library:CreateIcon(bindBtn, "keyboard", 14, Library.Theme.Accent, self.BaseZ + 2)
		kbIcon.Instance.Position = UDim2.fromOffset(11, 9)

		local keyTxt = Instance.new("TextLabel")
		keyTxt.BackgroundTransparency = 1
		keyTxt.Position = UDim2.fromOffset(28, 0)
		keyTxt.Size = UDim2.new(1, -36, 1, 0)
		keyTxt.FontFace = FontBold
		keyTxt.TextSize = 12
		keyTxt.TextColor3 = Library.Theme.TextPrimary
		keyTxt.Text = FormatKeyName(kp.Value)
		keyTxt.ZIndex = self.BaseZ + 2
		keyTxt.Parent = bindBtn

		-- Segmented Mode Selector (Hold | Toggle | Always) matching bottom popup switch
		local modeRow = Instance.new("Frame")
		modeRow.Position = UDim2.fromOffset(self.PadX, 36)
		modeRow.Size = UDim2.fromOffset(innerW, 20)
		modeRow.BackgroundColor3 = Library.Theme.ControlBg
		modeRow.BorderSizePixel = 0
		modeRow.ZIndex = self.BaseZ + 1
		modeRow.Parent = wrap
		Instance.new("UICorner", modeRow).CornerRadius = UDim.new(0, 2)

		local modeStroke = Instance.new("UIStroke")
		modeStroke.Color = Library.Theme.ControlStroke
		modeStroke.Thickness = 1
		modeStroke.Parent = modeRow

		local modes = { "Hold", "Toggle", "Always" }
		local segW = math.floor(innerW / 3)
		local modeBtns = {}

		local function SyncKeyUI()
			if Library.ActiveKeyCapture == kp then
				keyTxt.Text = "..."
				keyTxt.TextColor3 = Library.Theme.Accent
			else
				local disp = FormatKeyName(kp.Value)
				keyTxt.Text = disp == "None" and "Bind Key" or disp
				keyTxt.TextColor3 = disp == "None" and Library.Theme.TextDim or Library.Theme.TextPrimary
			end
			for _, mb in ipairs(modeBtns) do
				local active = (kp.Mode == mb.Name)
				mb.Btn.BackgroundTransparency = active and 0 or 1
				mb.Btn.BackgroundColor3 = Library.Theme.ControlHover
				mb.Btn.TextColor3 = active and Library.Theme.Accent or Library.Theme.TextDim
			end
		end

		for mi, mName in ipairs(modes) do
			local mb = Instance.new("TextButton")
			mb.Position = UDim2.fromOffset((mi - 1) * segW + 1, 1)
			mb.Size = UDim2.fromOffset(mi == 3 and (innerW - 2 * segW - 2) or (segW - 1), 18)
			mb.BorderSizePixel = 0
			mb.AutoButtonColor = false
			mb.FontFace = FontBold
			mb.TextSize = 10
			mb.Text = mName
			mb.ZIndex = self.BaseZ + 2
			mb.Parent = modeRow
			Instance.new("UICorner", mb).CornerRadius = UDim.new(0, 2)
			mb.MouseButton1Click:Connect(function()
				kp.Mode = mName
				SyncKeyUI()
			end)
			table.insert(modeBtns, { Name = mName, Btn = mb })
		end

		local hovered = false
		local hoverMix = 0
		bindBtn.MouseEnter:Connect(function() hovered = true end)
		bindBtn.MouseLeave:Connect(function() hovered = false end)
		bindBtn.MouseButton1Click:Connect(function()
			if Library.ActiveKeyCapture == kp then
				Library.ActiveKeyCapture = nil
			else
				kp.SkipFrame = false
				Library.ActiveKeyCapture = kp
			end
			SyncKeyUI()
		end)

		table.insert(kp.RefreshVisuals, SyncKeyUI)
		SyncKeyUI()

		Library:BindStep(function(dt)
			if not card.Visible then
				return
			end
			local th = Library.Theme
			local tH = (hovered or Library.ActiveKeyCapture == kp) and 1 or 0
			hoverMix += (tH - hoverMix) * math.min(1, dt * 12)
			local hm = SmoothStep(hoverMix)
			bindBtn.BackgroundColor3 = LerpColor(th.ControlBg, th.ControlHover, hm)
			bindStroke.Color = LerpColor(th.ControlStroke, th.Accent, Library.ActiveKeyCapture == kp and 0.9 or hm * 0.35)
			kbIcon:SetColor(th.Accent)
			modeRow.BackgroundColor3 = th.ControlBg
			modeStroke.Color = th.ControlStroke
			if Library.ActiveKeyCapture == kp then
				keyTxt.Text = "..."
				keyTxt.TextColor3 = th.Accent
			end
		end)

		RecalcPopupHeight()
		return kp
	end

	AttachWidgetFactory(popupObj, windowCtx)

	function popupObj:Toggle()
		if self.Open then
			self.Open = false
		else
			windowCtx:CloseFloatingPopups("gear", self)
			self.Open = true
		end
	end

	function popupObj:Close()
		self.Open = false
	end

	Library:BindStep(function(dt)
		local target = popupObj.Open and 1 or 0
		popupObj.Fade += (target - popupObj.Fade) * math.min(1, dt * 13)
		if math.abs(target - popupObj.Fade) < 0.002 then
			popupObj.Fade = target
		end
		local e = SmoothStep(popupObj.Fade)
		card.Visible = e > 0.005
		if not card.Visible then
			return
		end
		local th = Library.Theme
		card.BackgroundColor3 = th.PopupBg
		card.BackgroundTransparency = 1 - e
		stroke.Color = th.PopupStroke
		stroke.Transparency = 1 - e
		shadow.BackgroundTransparency = 1 - (0.35 * e)

		if anchorGearBtn and anchorGearBtn.Parent then
			local sc = math.max(0.25, windowCtx.CurrentScale)
			local rel = (anchorGearBtn.AbsolutePosition - windowCtx.Root.AbsolutePosition) / sc
			local px = rel.X + 26
			local py = math.clamp(rel.Y - 8, 48, math.max(48, 554 - card.Size.Y.Offset))
			local slideY = (1 - e) * -8
			card.Position = UDim2.fromOffset(math.floor(px + 0.5), math.floor(py + slideY + 0.5))
		end
	end)

	table.insert(windowCtx.GearPopups, popupObj)
	return popupObj
end

AttachWidgetFactory = function(target, windowCtx)
	local padX = target.PadX or 13
	local baseZ = target.BaseZ or 10

	local function InnerWidth()
		return (target.Width or 293) - padX * 2 - 2
	end

	local function NextOrder()
		if target.NextOrder then
			return target:NextOrder()
		end
		target.Order = (target.Order or 0) + 1
		return target.Order
	end

	-- ------------------------------------------------------------------------
	-- 1. TOGGLE (sigma::checkbox + GearPopup + ColorPicker + KeyPicker)
	-- ------------------------------------------------------------------------
	function target:AddToggle(idx, info)
		info = info or {}
		local row = Instance.new("Frame")
		row.Name = "Toggle_" .. tostring(idx)
		row.BackgroundTransparency = 1
		row.Size = UDim2.new(1, 0, 0, 29)
		row.LayoutOrder = NextOrder()
		row.ZIndex = baseZ
		row.Parent = target.Container

		local hitBtn = Instance.new("TextButton")
		hitBtn.BackgroundTransparency = 1
		hitBtn.Position = UDim2.fromOffset(padX, 0)
		hitBtn.Size = UDim2.new(1, -(padX * 2), 1, 0)
		hitBtn.Text = ""
		hitBtn.AutoButtonColor = false
		hitBtn.ZIndex = baseZ + 1
		hitBtn.Parent = row

		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.Position = UDim2.fromOffset(padX, 0)
		label.Size = UDim2.new(1, -(padX + 60), 1, 0)
		label.FontFace = FontMedium
		label.TextSize = 13
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextTruncate = Enum.TextTruncate.AtEnd
		label.Text = info.Text or idx or "Toggle"
		label.TextColor3 = Library.Theme.TextMuted
		label.ZIndex = baseZ + 2
		label.Parent = row

		-- Pill track (25x15, radius 7.5)
		local track = Instance.new("Frame")
		track.AnchorPoint = Vector2.new(1, 0.5)
		track.Position = UDim2.new(1, -(padX + 2), 0.5, 0)
		track.Size = UDim2.fromOffset(25, 15)
		track.BackgroundColor3 = Library.Theme.SwitchOff
		track.BorderSizePixel = 0
		track.ZIndex = baseZ + 2
		track.Parent = row
		Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

		local knob = Instance.new("Frame")
		knob.AnchorPoint = Vector2.new(0.5, 0.5)
		knob.Position = UDim2.fromOffset(7.5, 7.5)
		knob.Size = UDim2.fromOffset(11, 11)
		knob.BackgroundColor3 = Library.Theme.KnobOff
		knob.BorderSizePixel = 0
		knob.ZIndex = baseZ + 3
		knob.Parent = track
		Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

		local rightAccessoryX = padX + 34
		local swatches = {}
		local gearBtn = nil
		local gearIcon = nil
		local gearHover = false
		local gearMix = 0

		local function RepositionAccessories()
			local curRight = padX + 34
			if gearBtn then
				gearBtn.Position = UDim2.new(1, -curRight, 0.5, 0)
				curRight += 22
			end
			for _, sw in ipairs(swatches) do
				sw.Position = UDim2.new(1, -curRight, 0.5, 0)
				curRight += 20
			end
			rightAccessoryX = curRight
			label.Size = UDim2.new(1, -(padX + rightAccessoryX + 4), 1, 0)
			hitBtn.Size = UDim2.new(1, -(padX + (curRight - 34)), 1, 0)
		end

		local toggleObj = {
			Type = "Toggle",
			Index = idx,
			Text = info.Text or idx,
			Value = (info.Default == true),
			Callback = info.Callback,
			ChangedCallbacks = {},
			Addons = {},
			GearPopup = nil,
		}

		local animT = toggleObj.Value and 1 or 0
		local hoverT = 0
		local rowHovered = false

		hitBtn.MouseEnter:Connect(function() rowHovered = true end)
		hitBtn.MouseLeave:Connect(function() rowHovered = false end)
		track.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 then
				toggleObj:SetValue(not toggleObj.Value)
			end
		end)
		hitBtn.MouseButton1Click:Connect(function()
			toggleObj:SetValue(not toggleObj.Value)
		end)

		function toggleObj:SetValue(val)
			local b = (val == true)
			self.Value = b
			for _, kp in ipairs(self.Addons) do
				if kp.Type == "KeyPicker" and kp.SyncToggleState then
					kp.Toggled = b
				end
			end
			Library:UpdateDependencyBoxes()
			Library:SafeCallback(self.Callback, b)
			for _, cb in ipairs(self.ChangedCallbacks) do
				Library:SafeCallback(cb, b)
			end
		end

		function toggleObj:OnChanged(fn)
			table.insert(self.ChangedCallbacks, fn)
			return self
		end

		function toggleObj:AddGearPopup(customWidth)
			if self.GearPopup then
				return self.GearPopup
			end
			gearBtn = Instance.new("TextButton")
			gearBtn.Name = "GearBtn"
			gearBtn.AnchorPoint = Vector2.new(1, 0.5)
			gearBtn.Size = UDim2.fromOffset(18, 18)
			gearBtn.BackgroundTransparency = 1
			gearBtn.Text = ""
			gearBtn.AutoButtonColor = false
			gearBtn.ZIndex = baseZ + 4
			gearBtn.Parent = row

			gearIcon = Library:CreateIcon(gearBtn, "gear", 14, Color3.fromRGB(118, 118, 124), baseZ + 4)
			gearIcon.Instance.Position = UDim2.fromOffset(2, 2)

			local popup = CreateFloatingGearPopup(windowCtx, gearBtn, customWidth or 236)
			popup.ParentToggle = self
			self.GearPopup = popup

			gearBtn.MouseEnter:Connect(function() gearHover = true end)
			gearBtn.MouseLeave:Connect(function() gearHover = false end)
			gearBtn.MouseButton1Click:Connect(function()
				popup:Toggle()
			end)

			RepositionAccessories()
			return popup
		end

		function toggleObj:AddKeyPicker(kpIdx, kpInfo)
			local popup = self:AddGearPopup()
			local kp = popup:AddKeyPicker(kpIdx, kpInfo)
			table.insert(self.Addons, kp)
			return self
		end

		function toggleObj:AddColorPicker(cpIdx, cpInfo)
			local cp = CreateColorPickerObject(cpIdx, cpInfo)
			local swBtn = Instance.new("TextButton")
			swBtn.AnchorPoint = Vector2.new(1, 0.5)
			swBtn.Size = UDim2.fromOffset(16, 16)
			swBtn.BackgroundTransparency = 1
			swBtn.Text = ""
			swBtn.AutoButtonColor = false
			swBtn.ZIndex = baseZ + 4
			swBtn.Parent = row

			local ring = Instance.new("Frame")
			ring.AnchorPoint = Vector2.new(0.5, 0.5)
			ring.Position = UDim2.fromScale(0.5, 0.5)
			ring.Size = UDim2.fromOffset(14, 14)
			ring.BackgroundTransparency = 1
			ring.ZIndex = baseZ + 4
			ring.Parent = swBtn
			Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
			local ringStroke = Instance.new("UIStroke")
			ringStroke.Color = Color3.fromRGB(58, 58, 64)
			ringStroke.Thickness = 1
			ringStroke.Parent = ring

			local dot = Instance.new("Frame")
			dot.AnchorPoint = Vector2.new(0.5, 0.5)
			dot.Position = UDim2.fromScale(0.5, 0.5)
			dot.Size = UDim2.fromOffset(8, 8)
			dot.BackgroundColor3 = cp.Value
			dot.BorderSizePixel = 0
			dot.ZIndex = baseZ + 5
			dot.Parent = ring
			Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

			table.insert(cp.RefreshVisuals, function()
				dot.BackgroundColor3 = cp.Value
			end)

			swBtn.MouseButton1Click:Connect(function()
				windowCtx.ColorPickerPopup:ToggleFor(cp, swBtn)
			end)

			table.insert(swatches, swBtn)
			table.insert(self.Addons, cp)
			RepositionAccessories()
			return self
		end

		Library:BindStep(function(dt)
			if not row.Parent then
				return
			end
			local th = Library.Theme
			local tVal = toggleObj.Value and 1 or 0
			animT += (tVal - animT) * math.min(1, dt * 10)
			local tHov = rowHovered and 1 or 0
			hoverT += (tHov - hoverT) * math.min(1, dt * 14)

			local e = SmoothStep(animT)
			local h = SmoothStep(hoverT)

			local baseCol = LerpColor(th.TextMuted, th.TextBright, e)
			if h > 0.01 and e < 0.99 then
				baseCol = LerpColor(baseCol, th.TextLabel, h * 0.38)
			end
			label.TextColor3 = baseCol
			track.BackgroundColor3 = LerpColor(th.SwitchOff, th.AccentBright, e)
			knob.BackgroundColor3 = LerpColor(th.KnobOff, th.KnobOn, e)

			local knobDiam = Lerp(11, 9.2, h)
			knob.Size = UDim2.fromOffset(knobDiam, knobDiam)
			knob.Position = UDim2.fromOffset(Lerp(7.5, 17.5, e), 7.5)

			if gearIcon then
				local gActive = (gearHover or (toggleObj.GearPopup and toggleObj.GearPopup.Open)) and 1 or 0
				gearMix += (gActive - gearMix) * math.min(1, dt * 12)
				gearIcon:SetColor(LerpColor(Color3.fromRGB(118, 118, 124), th.TextBright, SmoothStep(gearMix)))
			end
		end)

		if idx then
			Toggles[idx] = toggleObj
		end
		return toggleObj
	end

	-- ------------------------------------------------------------------------
	-- 2. SLIDER (sigma::slider 1:1 with smooth lerped fill & gradient)
	-- ------------------------------------------------------------------------
	function target:AddSlider(idx, info)
		info = info or {}
		local minVal = tonumber(info.Min) or 0
		local maxVal = tonumber(info.Max) or 100
		local rounding = tonumber(info.Rounding) or 0
		local suffix = tostring(info.Suffix or "")
		local compact = (info.Compact == true)

		local function RoundVal(v)
			v = math.clamp(v, minVal, maxVal)
			if rounding <= 0 then
				return math.floor(v + 0.5)
			end
			local mult = 10 ^ rounding
			return math.floor(v * mult + 0.5) / mult
		end

		local function FormatVal(v)
			if rounding <= 0 then
				return string.format("%d%s", math.floor(v + 0.5), suffix)
			end
			return string.format("%." .. tostring(rounding) .. "f%s", v, suffix)
		end

		local startVal = RoundVal(tonumber(info.Default) or minVal)

		local row = Instance.new("Frame")
		row.Name = "Slider_" .. tostring(idx)
		row.BackgroundTransparency = 1
		row.Size = UDim2.new(1, 0, 0, compact and 26 or 44)
		row.LayoutOrder = NextOrder()
		row.ZIndex = baseZ
		row.Parent = target.Container

		local label = Instance.new("TextLabel")
		label.BackgroundTransparency = 1
		label.Position = UDim2.fromOffset(padX, 2)
		label.Size = UDim2.new(1, -(padX * 2 + 64), 0, 18)
		label.FontFace = FontBold
		label.TextSize = 13
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.TextTruncate = Enum.TextTruncate.AtEnd
		label.TextColor3 = Library.Theme.TextLabel
		label.Text = info.Text or idx or "Slider"
		label.Visible = not compact
		label.ZIndex = baseZ + 1
		label.Parent = row

		local valLbl = Instance.new("TextLabel")
		valLbl.BackgroundTransparency = 1
		valLbl.Position = UDim2.new(1, -(padX + 82), 0, 2)
		valLbl.Size = UDim2.fromOffset(80, 18)
		valLbl.FontFace = FontBold
		valLbl.TextSize = 13
		valLbl.TextXAlignment = Enum.TextXAlignment.Right
		valLbl.TextColor3 = Library.Theme.TextSubtle
		valLbl.Text = FormatVal(startVal)
		valLbl.ZIndex = baseZ + 1
		valLbl.Parent = row

		local trackY = compact and 11 or 28
		local track = Instance.new("Frame")
		track.Position = UDim2.fromOffset(padX, trackY)
		track.Size = UDim2.new(1, -(padX * 2 + 2), 0, 5)
		track.BackgroundColor3 = Library.Theme.ControlBg
		track.BorderSizePixel = 0
		track.ZIndex = baseZ + 1
		track.Parent = row
		Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

		local fill = Instance.new("Frame")
		fill.Size = UDim2.fromScale(0, 1)
		fill.BackgroundColor3 = Color3.new(1, 1, 1)
		fill.BorderSizePixel = 0
		fill.ZIndex = baseZ + 2
		fill.Parent = track
		Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

		local fillGrad = Instance.new("UIGradient")
		fillGrad.Color = ColorSequence.new(Library.Theme.AccentBright, Library.Theme.AccentGradEnd)
		fillGrad.Parent = fill

		local knob = Instance.new("Frame")
		knob.AnchorPoint = Vector2.new(0.5, 0.5)
		knob.Position = UDim2.new(0, 0, 0.5, 0)
		knob.Size = UDim2.fromOffset(14, 14)
		knob.BackgroundColor3 = Library.Theme.SliderKnob
		knob.BorderSizePixel = 0
		knob.ZIndex = baseZ + 3
		knob.Parent = track
		Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

		local hitArea = Instance.new("TextButton")
		hitArea.BackgroundTransparency = 1
		hitArea.Position = UDim2.fromOffset(padX - 4, trackY - 8)
		hitArea.Size = UDim2.new(1, -(padX * 2 - 6), 0, 21)
		hitArea.Text = ""
		hitArea.AutoButtonColor = false
		hitArea.ZIndex = baseZ + 4
		hitArea.Parent = row

		local sliderObj = {
			Type = "Slider",
			Index = idx,
			Value = startVal,
			Min = minVal,
			Max = maxVal,
			Rounding = rounding,
			Callback = info.Callback,
			ChangedCallbacks = {},
		}

		local displayRatio = (maxVal > minVal) and ((startVal - minVal) / (maxVal - minVal)) or 0
		local dragging = false

		function sliderObj:SetValue(v)
			local nv = RoundVal(tonumber(v) or self.Min)
			self.Value = nv
			valLbl.Text = FormatVal(nv)
			Library:SafeCallback(self.Callback, nv)
			for _, cb in ipairs(self.ChangedCallbacks) do
				Library:SafeCallback(cb, nv)
			end
		end

		function sliderObj:OnChanged(fn)
			table.insert(self.ChangedCallbacks, fn)
			return self
		end

		local function UpdateFromMouseX(mx)
			local absX = track.AbsolutePosition.X
			local absW = math.max(1, track.AbsoluteSize.X)
			local ratio = math.clamp((mx - absX) / absW, 0, 1)
			local raw = minVal + (maxVal - minVal) * ratio
			local rounded = RoundVal(raw)
			if rounded ~= sliderObj.Value then
				sliderObj:SetValue(rounded)
			end
		end

		hitArea.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				UpdateFromMouseX(inp.Position.X)
			end
		end)
		Library:GiveSignal(UserInputService.InputChanged:Connect(function(inp)
			if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
				UpdateFromMouseX(inp.Position.X)
			end
		end))
		Library:GiveSignal(UserInputService.InputEnded:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
			end
		end))

		Library:BindStep(function(dt)
			if not row.Parent then
				return
			end
			local th = Library.Theme
			local targetR = (maxVal > minVal) and math.clamp((sliderObj.Value - minVal) / (maxVal - minVal), 0, 1) or 0
			displayRatio += (targetR - displayRatio) * math.min(1, dt * 18)
			fill.Size = UDim2.new(displayRatio, 0, 1, 0)
			knob.Position = UDim2.new(displayRatio, 0, 0.5, 0)
			label.TextColor3 = th.TextLabel
			valLbl.TextColor3 = th.TextSubtle
			track.BackgroundColor3 = th.ControlBg
			knob.BackgroundColor3 = th.SliderKnob
			fillGrad.Color = ColorSequence.new(th.AccentBright, th.AccentGradEnd)
		end)

		if idx then
			Options[idx] = sliderObj
		end
		return sliderObj
	end

	-- ------------------------------------------------------------------------
	-- 3. BUTTON (sigma::button 1:1 accent button + :AddButton split chaining)
	-- ------------------------------------------------------------------------
	function target:AddButton(infoOrText, callbackFn)
		local info = type(infoOrText) == "table" and infoOrText or {
			Text = tostring(infoOrText or "Button"),
			Func = callbackFn,
		}
		local func = info.Func or info.Callback or callbackFn

		local row = Instance.new("Frame")
		row.Name = "ButtonRow"
		row.BackgroundTransparency = 1
		row.Size = UDim2.new(1, 0, 0, 41)
		row.LayoutOrder = NextOrder()
		row.ZIndex = baseZ
		row.Parent = target.Container

		local function MakeSingleBtn(btnText, btnIcon, cb)
			local b = Instance.new("TextButton")
			b.Position = UDim2.fromOffset(padX, 4)
			b.Size = UDim2.fromOffset(InnerWidth(), 33)
			b.BackgroundColor3 = Library.Theme.AccentBright
			b.BorderSizePixel = 0
			b.AutoButtonColor = false
			b.Text = ""
			b.ZIndex = baseZ + 1
			b.Parent = row
			Instance.new("UICorner", b).CornerRadius = UDim.new(0, 2)

			local contentWrap = Instance.new("Frame")
			contentWrap.BackgroundTransparency = 1
			contentWrap.AnchorPoint = Vector2.new(0.5, 0.5)
			contentWrap.Position = UDim2.fromScale(0.5, 0.5)
			contentWrap.Size = UDim2.fromScale(1, 1)
			contentWrap.ZIndex = baseZ + 2
			contentWrap.Parent = b

			local iconApi = nil
			local txtW = CalcTextBounds(btnText, FontBold, 12).X
			if btnIcon then
				iconApi = Library:CreateIcon(contentWrap, btnIcon, 13, Library.Theme.ButtonText, baseZ + 3)
				local totalW = 13 + 7 + txtW
				iconApi.Instance.Position = UDim2.new(0.5, -math.floor(totalW * 0.5), 0.5, -6)
			end

			local lbl = Instance.new("TextLabel")
			lbl.BackgroundTransparency = 1
			if iconApi then
				local totalW = 13 + 7 + txtW
				lbl.Position = UDim2.new(0.5, -math.floor(totalW * 0.5) + 20, 0, 0)
				lbl.Size = UDim2.fromOffset(txtW + 6, 33)
				lbl.TextXAlignment = Enum.TextXAlignment.Left
			else
				lbl.Size = UDim2.fromScale(1, 1)
				lbl.TextXAlignment = Enum.TextXAlignment.Center
			end
			lbl.FontFace = FontBold
			lbl.TextSize = 12
			lbl.TextColor3 = Library.Theme.ButtonText
			lbl.Text = btnText
			lbl.ZIndex = baseZ + 3
			lbl.Parent = contentWrap

			local hov = false
			local hMix = 0
			b.MouseEnter:Connect(function() hov = true end)
			b.MouseLeave:Connect(function() hov = false end)
			b.MouseButton1Click:Connect(function()
				Library:SafeCallback(cb)
			end)

			Library:BindStep(function(dt)
				if not b.Parent then
					return
				end
				local th = Library.Theme
				hMix += ((hov and 1 or 0) - hMix) * math.min(1, dt * 8)
				b.BackgroundColor3 = LerpColor(th.AccentBright, th.AccentDark, SmoothStep(hMix))
				lbl.TextColor3 = th.ButtonText
				if iconApi then
					iconApi:SetColor(th.ButtonText)
				end
			end)

			return b, lbl
		end

		local mainBtn, mainLbl = MakeSingleBtn(info.Text or "Button", info.Icon, func)
		local btnObj = {
			Button = mainBtn,
			Label = mainLbl,
			Func = func,
		}

		function btnObj:AddButton(subInfoOrText, subCb)
			local sInfo = type(subInfoOrText) == "table" and subInfoOrText or {
				Text = tostring(subInfoOrText or "Button"),
				Func = subCb,
			}
			local sFunc = sInfo.Func or sInfo.Callback or subCb
			local totalW = InnerWidth()
			local halfW = math.floor((totalW - 8) * 0.5)
			mainBtn.Size = UDim2.fromOffset(halfW, 33)
			local subBtn = MakeSingleBtn(sInfo.Text or "Button", sInfo.Icon, sFunc)
			subBtn.Position = UDim2.fromOffset(padX + halfW + 8, 4)
			subBtn.Size = UDim2.fromOffset(totalW - halfW - 8, 33)
			return self
		end

		return btnObj
	end

	-- ------------------------------------------------------------------------
	-- 4. DROPDOWN / MULTI-DROPDOWN (sigma::combobox + floating list)
	-- ------------------------------------------------------------------------
	function target:AddDropdown(idx, info)
		info = info or {}
		local values = info.Values or {}
		local isMulti = (info.Multi == true)
		local hasTitle = (info.Text ~= nil and info.Text ~= "" and not info.Compact)
		local rowH = hasTitle and 56 or 35
		local boxW = InnerWidth()

		local row = Instance.new("Frame")
		row.Name = "Dropdown_" .. tostring(idx)
		row.BackgroundTransparency = 1
		row.Size = UDim2.new(1, 0, 0, rowH)
		row.LayoutOrder = NextOrder()
		row.ZIndex = baseZ
		row.Parent = target.Container

		local titleLbl = nil
		if hasTitle then
			titleLbl = Instance.new("TextLabel")
			titleLbl.BackgroundTransparency = 1
			titleLbl.Position = UDim2.fromOffset(padX, 2)
			titleLbl.Size = UDim2.fromOffset(boxW, 18)
			titleLbl.FontFace = FontBold
			titleLbl.TextSize = 13
			titleLbl.TextXAlignment = Enum.TextXAlignment.Left
			titleLbl.TextColor3 = Library.Theme.TextPrimary
			titleLbl.Text = tostring(info.Text)
			titleLbl.ZIndex = baseZ + 1
			titleLbl.Parent = row
		end

		local comboY = hasTitle and 23 or 3
		local comboBox, innerStroke, outerStroke = CreateDualBorderBox(
			row,
			"ComboBox",
			UDim2.fromOffset(padX, comboY),
			UDim2.fromOffset(boxW, 29),
			Library.Theme.ControlBg,
			Library.Theme.ControlStroke,
			Library.Theme.ControlOuter,
			3,
			baseZ + 1
		)

		local valText = Instance.new("TextLabel")
		valText.BackgroundTransparency = 1
		valText.Position = UDim2.fromOffset(10, 0)
		valText.Size = UDim2.new(1, -32, 1, 0)
		valText.FontFace = FontMedium
		valText.TextSize = 13
		valText.TextXAlignment = Enum.TextXAlignment.Left
		valText.TextTruncate = Enum.TextTruncate.AtEnd
		valText.TextColor3 = Color3.fromRGB(165, 165, 170)
		valText.ZIndex = baseZ + 3
		valText.Parent = comboBox

		local chev = Library:CreateIcon(comboBox, "chevron", 11, Color3.fromRGB(142, 142, 148), baseZ + 3)
		chev.Instance.Position = UDim2.new(1, -21, 0.5, -5)

		local hit = Instance.new("TextButton")
		hit.BackgroundTransparency = 1
		hit.Size = UDim2.fromScale(1, 1)
		hit.Text = ""
		hit.AutoButtonColor = false
		hit.ZIndex = baseZ + 4
		hit.Parent = comboBox

		local initVal
		if isMulti then
			initVal = {}
			if type(info.Default) == "table" then
				for k, v in pairs(info.Default) do
					if type(k) == "number" and type(v) == "string" then
						initVal[v] = true
					elseif v == true then
						initVal[k] = true
					end
				end
			elseif type(info.Default) == "number" and values[info.Default] then
				initVal[values[info.Default]] = true
			elseif type(info.Default) == "string" and info.Default ~= "" then
				initVal[info.Default] = true
			end
		else
			if type(info.Default) == "number" then
				initVal = values[info.Default]
			elseif info.Default ~= nil then
				initVal = info.Default
			elseif not info.AllowNull then
				initVal = values[1]
			end
		end

		local ddObj = {
			Type = "Dropdown",
			Index = idx,
			Values = values,
			Multi = isMulti,
			AllowNull = (info.AllowNull == true),
			Value = initVal,
			BoxWidth = boxW,
			Callback = info.Callback,
			ChangedCallbacks = {},
		}

		function ddObj:Display()
			if self.Multi then
				local list = {}
				for _, item in ipairs(self.Values) do
					if self.Value[item] then
						table.insert(list, tostring(item))
					end
				end
				if #list == 0 then
					valText.Text = "None"
				else
					local joined = table.concat(list, ", ")
					if #joined > 26 then
						joined = string.sub(joined, 1, 24) .. "..."
					end
					valText.Text = joined
				end
			else
				valText.Text = (self.Value ~= nil and tostring(self.Value) ~= "") and tostring(self.Value) or "None"
			end
		end

		function ddObj:FireChanged()
			Library:SafeCallback(self.Callback, self.Value)
			for _, cb in ipairs(self.ChangedCallbacks) do
				Library:SafeCallback(cb, self.Value)
			end
		end

		function ddObj:SetValues(newValues)
			self.Values = newValues or {}
			if not self.Multi and self.Value ~= nil and not table.find(self.Values, self.Value) then
				self.Value = self.AllowNull and nil or self.Values[1]
			end
			self:Display()
			windowCtx.DropdownPopup:RefreshIfTarget(self)
		end

		function ddObj:SetValue(val)
			if self.Multi then
				self.Value = {}
				if type(val) == "table" then
					for k, v in pairs(val) do
						if type(k) == "number" and type(v) == "string" then
							self.Value[v] = true
						elseif v == true then
							self.Value[k] = true
						end
					end
				end
			else
				self.Value = val
			end
			self:Display()
			self:FireChanged()
			windowCtx.DropdownPopup:RefreshIfTarget(self)
		end

		function ddObj:OnChanged(fn)
			table.insert(self.ChangedCallbacks, fn)
			return self
		end

		hit.MouseButton1Click:Connect(function()
			ddObj.BoxWidth = math.floor(comboBox.AbsoluteSize.X / math.max(0.25, windowCtx.CurrentScale) + 0.5)
			windowCtx.DropdownPopup:ToggleFor(ddObj, comboBox)
		end)

		ddObj:Display()

		Library:BindStep(function()
			if not row.Parent then
				return
			end
			local th = Library.Theme
			if titleLbl then
				titleLbl.TextColor3 = th.TextPrimary
			end
			comboBox.BackgroundColor3 = th.ControlBg
			innerStroke.Color = th.ControlStroke
			outerStroke.Color = th.ControlOuter
			valText.TextColor3 = th.TextLabel
		end)

		if idx then
			Options[idx] = ddObj
		end
		return ddObj
	end

	-- ------------------------------------------------------------------------
	-- 5. INPUT / SEARCH BOX (sigma::search_box_input 1:1)
	-- ------------------------------------------------------------------------
	function target:AddInput(idx, info)
		info = info or {}
		local hasTitle = (info.Text ~= nil and info.Text ~= "" and not info.Compact)
		local rowH = hasTitle and 60 or 39
		local boxW = InnerWidth()

		local row = Instance.new("Frame")
		row.Name = "Input_" .. tostring(idx)
		row.BackgroundTransparency = 1
		row.Size = UDim2.new(1, 0, 0, rowH)
		row.LayoutOrder = NextOrder()
		row.ZIndex = baseZ
		row.Parent = target.Container

		local titleLbl = nil
		if hasTitle then
			titleLbl = Instance.new("TextLabel")
			titleLbl.BackgroundTransparency = 1
			titleLbl.Position = UDim2.fromOffset(padX, 2)
			titleLbl.Size = UDim2.fromOffset(boxW, 18)
			titleLbl.FontFace = FontBold
			titleLbl.TextSize = 13
			titleLbl.TextXAlignment = Enum.TextXAlignment.Left
			titleLbl.TextColor3 = Library.Theme.TextPrimary
			titleLbl.Text = tostring(info.Text)
			titleLbl.ZIndex = baseZ + 1
			titleLbl.Parent = row
		end

		local boxY = hasTitle and 23 or 3
		local inputFrame, innerStroke, outerStroke = CreateDualBorderBox(
			row,
			"InputBox",
			UDim2.fromOffset(padX, boxY),
			UDim2.fromOffset(boxW, 32),
			Library.Theme.GroupBg,
			Library.Theme.ControlStroke,
			Library.Theme.ControlOuter,
			3,
			baseZ + 1
		)

		local iconKey = info.Icon
		local iconApi = nil
		local textLeft = 11
		if iconKey then
			iconApi = Library:CreateIcon(inputFrame, iconKey, 13, Library.Theme.TextMuted, baseZ + 3)
			iconApi.Instance.Position = UDim2.fromOffset(10, 9)
			textLeft = 30
		end

		local tb = Instance.new("TextBox")
		tb.BackgroundTransparency = 1
		tb.Position = UDim2.fromOffset(textLeft, 0)
		tb.Size = UDim2.new(1, -(textLeft + 8), 1, 0)
		tb.FontFace = FontMedium
		tb.TextSize = 13
		tb.TextXAlignment = Enum.TextXAlignment.Left
		tb.PlaceholderText = tostring(info.Placeholder or "Enter text...")
		tb.PlaceholderColor3 = Color3.fromRGB(74, 74, 78)
		tb.TextColor3 = Library.Theme.TextPrimary
		tb.Text = tostring(info.Default or "")
		tb.ClearTextOnFocus = (info.ClearTextOnFocus == true)
		tb.ZIndex = baseZ + 3
		tb.Parent = inputFrame

		local inpObj = {
			Type = "Input",
			Index = idx,
			Value = tb.Text,
			Numeric = (info.Numeric == true),
			Finished = (info.Finished == true),
			Callback = info.Callback,
			ChangedCallbacks = {},
		}

		function inpObj:SetValue(val)
			local s = tostring(val or "")
			if self.Numeric then
				s = string.gsub(s, "[^%d%.%-]", "")
			end
			self.Value = s
			if tb.Text ~= s then
				tb.Text = s
			end
			Library:SafeCallback(self.Callback, s)
			for _, cb in ipairs(self.ChangedCallbacks) do
				Library:SafeCallback(cb, s)
			end
		end

		function inpObj:OnChanged(fn)
			table.insert(self.ChangedCallbacks, fn)
			return self
		end

		tb:GetPropertyChangedSignal("Text"):Connect(function()
			if inpObj.Numeric then
				local clean = string.gsub(tb.Text, "[^%d%.%-]", "")
				if clean ~= tb.Text then
					tb.Text = clean
					return
				end
			end
			inpObj.Value = tb.Text
			if not inpObj.Finished then
				Library:SafeCallback(inpObj.Callback, inpObj.Value)
				for _, cb in ipairs(inpObj.ChangedCallbacks) do
					Library:SafeCallback(cb, inpObj.Value)
				end
			end
		end)

		tb.FocusLost:Connect(function()
			inpObj.Value = tb.Text
			if inpObj.Finished then
				Library:SafeCallback(inpObj.Callback, inpObj.Value)
				for _, cb in ipairs(inpObj.ChangedCallbacks) do
					Library:SafeCallback(cb, inpObj.Value)
				end
			end
		end)

		Library:BindStep(function()
			if not row.Parent then
				return
			end
			local th = Library.Theme
			if titleLbl then
				titleLbl.TextColor3 = th.TextPrimary
			end
			inputFrame.BackgroundColor3 = th.GroupBg
			innerStroke.Color = tb:IsFocused() and th.Accent or th.ControlStroke
			outerStroke.Color = th.ControlOuter
			tb.TextColor3 = th.TextPrimary
			if iconApi then
				iconApi:SetColor(tb:IsFocused() and th.Accent or th.TextMuted)
			end
		end)

		if idx then
			Options[idx] = inpObj
		end
		return inpObj
	end

	-- ------------------------------------------------------------------------
	-- 6. LABEL (+ inline :AddKeyPicker pill & :AddColorPicker swatch)
	-- ------------------------------------------------------------------------
	function target:AddLabel(text, doesWrap)
		local row = Instance.new("Frame")
		row.Name = "LabelRow"
		row.BackgroundTransparency = 1
		row.Size = UDim2.new(1, 0, 0, 26)
		row.LayoutOrder = NextOrder()
		row.ZIndex = baseZ
		row.Parent = target.Container

		local lbl = Instance.new("TextLabel")
		lbl.BackgroundTransparency = 1
		lbl.Position = UDim2.fromOffset(padX, 0)
		lbl.Size = UDim2.new(1, -(padX * 2), 1, 0)
		lbl.FontFace = FontMedium
		lbl.TextSize = 13
		lbl.TextXAlignment = Enum.TextXAlignment.Left
		lbl.TextWrapped = (doesWrap == true)
		lbl.TextColor3 = Library.Theme.TextLabel
		lbl.Text = tostring(text or "")
		lbl.ZIndex = baseZ + 1
		lbl.Parent = row

		local function RecomputeWrap()
			if doesWrap then
				local h = CalcTextBounds(lbl.Text, FontMedium, 13).Y
				row.Size = UDim2.new(1, 0, 0, math.max(24, h + 8))
			end
		end
		RecomputeWrap()

		local rightOffset = padX + 2
		local labelObj = {
			Label = lbl,
			Addons = {},
		}

		function labelObj:SetText(newText)
			lbl.Text = tostring(newText or "")
			RecomputeWrap()
		end

		-- Inline Keybind Pill (exact match to Settings -> Menu Key / Unload Key in main.cpp!)
		function labelObj:AddKeyPicker(kpIdx, kpInfo)
			local kp = CreateKeyPickerObject(kpIdx, kpInfo, nil)
			local pill = Instance.new("TextButton")
			pill.AnchorPoint = Vector2.new(1, 0.5)
			pill.Position = UDim2.new(1, -rightOffset, 0.5, 0)
			pill.Size = UDim2.fromOffset(48, 22)
			pill.BackgroundColor3 = Library.Theme.ControlBg
			pill.BorderSizePixel = 0
			pill.AutoButtonColor = false
			pill.FontFace = FontBold
			pill.TextSize = 11
			pill.TextColor3 = Library.Theme.TextPrimary
			pill.ZIndex = baseZ + 2
			pill.Parent = row
			Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 3)

			local pStroke = Instance.new("UIStroke")
			pStroke.Color = Library.Theme.ControlStroke
			pStroke.Thickness = 1
			pStroke.Parent = pill

			local function RefreshPill()
				local txt = (Library.ActiveKeyCapture == kp) and "..." or FormatKeyName(kp.Value)
				pill.Text = txt
				local w = math.max(42, CalcTextBounds(txt, FontBold, 11).X + 18)
				pill.Size = UDim2.fromOffset(w, 22)
				lbl.Size = UDim2.new(1, -(padX + rightOffset + w + 8), 1, 0)
			end

			pill.MouseButton1Click:Connect(function()
				if Library.ActiveKeyCapture == kp then
					Library.ActiveKeyCapture = nil
				else
					Library.ActiveKeyCapture = kp
				end
				RefreshPill()
			end)

			table.insert(kp.RefreshVisuals, RefreshPill)
			RefreshPill()
			rightOffset += pill.Size.X.Offset + 6

			Library:BindStep(function()
				if not pill.Parent then
					return
				end
				local th = Library.Theme
				local cap = (Library.ActiveKeyCapture == kp)
				pill.BackgroundColor3 = cap and th.ControlHover or th.ControlBg
				pStroke.Color = cap and th.Accent or th.ControlStroke
				pill.TextColor3 = cap and th.Accent or th.TextPrimary
				if cap and pill.Text ~= "..." then
					RefreshPill()
				end
			end)

			table.insert(self.Addons, kp)
			return self
		end

		function labelObj:AddColorPicker(cpIdx, cpInfo)
			local cp = CreateColorPickerObject(cpIdx, cpInfo)
			local swBtn = Instance.new("TextButton")
			swBtn.AnchorPoint = Vector2.new(1, 0.5)
			swBtn.Position = UDim2.new(1, -rightOffset, 0.5, 0)
			swBtn.Size = UDim2.fromOffset(16, 16)
			swBtn.BackgroundTransparency = 1
			swBtn.Text = ""
			swBtn.AutoButtonColor = false
			swBtn.ZIndex = baseZ + 2
			swBtn.Parent = row

			local ring = Instance.new("Frame")
			ring.AnchorPoint = Vector2.new(0.5, 0.5)
			ring.Position = UDim2.fromScale(0.5, 0.5)
			ring.Size = UDim2.fromOffset(14, 14)
			ring.BackgroundTransparency = 1
			ring.ZIndex = baseZ + 3
			ring.Parent = swBtn
			Instance.new("UICorner", ring).CornerRadius = UDim.new(1, 0)
			local rStroke = Instance.new("UIStroke")
			rStroke.Color = Color3.fromRGB(58, 58, 64)
			rStroke.Thickness = 1
			rStroke.Parent = ring

			local dot = Instance.new("Frame")
			dot.AnchorPoint = Vector2.new(0.5, 0.5)
			dot.Position = UDim2.fromScale(0.5, 0.5)
			dot.Size = UDim2.fromOffset(8, 8)
			dot.BackgroundColor3 = cp.Value
			dot.BorderSizePixel = 0
			dot.ZIndex = baseZ + 4
			dot.Parent = ring
			Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

			table.insert(cp.RefreshVisuals, function()
				dot.BackgroundColor3 = cp.Value
			end)

			swBtn.MouseButton1Click:Connect(function()
				windowCtx.ColorPickerPopup:ToggleFor(cp, swBtn)
			end)

			rightOffset += 22
			table.insert(self.Addons, cp)
			return self
		end

		Library:BindStep(function()
			if row.Parent then
				lbl.TextColor3 = Library.Theme.TextLabel
			end
		end)

		return labelObj
	end

	-- ------------------------------------------------------------------------
	-- 7. DIVIDER (1px RGB(48,48,48) line matching Health Options)
	-- ------------------------------------------------------------------------
	function target:AddDivider()
		local wrap = Instance.new("Frame")
		wrap.BackgroundTransparency = 1
		wrap.Size = UDim2.new(1, 0, 0, 13)
		wrap.LayoutOrder = NextOrder()
		wrap.ZIndex = baseZ
		wrap.Parent = target.Container

		local line = Instance.new("Frame")
		line.Position = UDim2.fromOffset(padX, 6)
		line.Size = UDim2.new(1, -(padX * 2 + 2), 0, 1)
		line.BorderSizePixel = 0
		line.BackgroundColor3 = Library.Theme.Divider
		line.ZIndex = baseZ + 1
		line.Parent = wrap

		Library:BindStep(function()
			if line.Parent then
				line.BackgroundColor3 = Library.Theme.Divider
			end
		end)
		return wrap
	end

	-- ------------------------------------------------------------------------
	-- 8. DEPENDENCY BOX (1:1 Auto Heal / Auto Armor smooth height reveal!)
	-- ------------------------------------------------------------------------
	function target:AddDependencyBox()
		local clipWrap = Instance.new("Frame")
		clipWrap.Name = "DependencyBox"
		clipWrap.BackgroundTransparency = 1
		clipWrap.Size = UDim2.new(1, 0, 0, 0)
		clipWrap.ClipsDescendants = true
		clipWrap.Visible = false
		clipWrap.LayoutOrder = NextOrder()
		clipWrap.ZIndex = baseZ
		clipWrap.Parent = target.Container

		local inner = Instance.new("Frame")
		inner.BackgroundTransparency = 1
		inner.Size = UDim2.new(1, 0, 0, 0)
		inner.ZIndex = baseZ
		inner.Parent = clipWrap

		local list = Instance.new("UIListLayout")
		list.SortOrder = Enum.SortOrder.LayoutOrder
		list.Padding = UDim.new(0, 2)
		list.Parent = inner

		local depBox = {
			Container = inner,
			Width = target.Width or 293,
			PadX = padX,
			BaseZ = baseZ,
			Order = 0,
			Dependencies = {},
			Showing = false,
			Fade = 0,
		}

		AttachWidgetFactory(depBox, windowCtx)

		function depBox:SetupDependencies(deps)
			self.Dependencies = deps or {}
			self:Update()
		end

		function depBox:Update()
			local pass = true
			for _, pair in ipairs(self.Dependencies) do
				local ctrl = pair[1]
				local expected = pair[2]
				if ctrl and ctrl.Value ~= expected then
					pass = false
					break
				end
			end
			self.Showing = pass
		end

		Library:BindStep(function(dt)
			if not clipWrap.Parent then
				return
			end
			local t = depBox.Showing and 1 or 0
			depBox.Fade += (t - depBox.Fade) * math.min(1, dt * 8.5)
			if math.abs(t - depBox.Fade) < 0.002 then
				depBox.Fade = t
			end
			local e = SmoothStep(depBox.Fade)
			local fullH = list.AbsoluteContentSize.Y + 4
			inner.Size = UDim2.new(1, 0, 0, fullH)
			inner.Position = UDim2.fromOffset(0, math.floor((1 - e) * -12 + 0.5))
			local curH = math.floor(fullH * e + 0.5)
			clipWrap.Visible = curH > 0
			clipWrap.Size = UDim2.new(1, 0, 0, curH)
		end)

		table.insert(Library.DependencyBoxes, depBox)
		return depBox
	end

	-- ------------------------------------------------------------------------
	-- 9. LISTBOX (1:1 ech0.fun Vehicle Spawner / Resource List with slide bar)
	-- ------------------------------------------------------------------------
	function target:AddListBox(idx, info)
		info = info or {}
		local values = info.Values or {}
		local listH = tonumber(info.Height) or 184
		local showSearch = (info.Search ~= false)
		local boxW = InnerWidth()

		local wrap = Instance.new("Frame")
		wrap.Name = "ListBox_" .. tostring(idx)
		wrap.BackgroundTransparency = 1
		wrap.Size = UDim2.new(1, 0, 0, listH + (showSearch and 40 or 6))
		wrap.LayoutOrder = NextOrder()
		wrap.ZIndex = baseZ
		wrap.Parent = target.Container

		local query = ""
		if showSearch then
			local sFrame, sInner, sOuter = CreateDualBorderBox(
				wrap,
				"ListSearch",
				UDim2.fromOffset(padX, 2),
				UDim2.fromOffset(boxW, 31),
				Library.Theme.GroupBg,
				Library.Theme.ControlStroke,
				Library.Theme.ControlOuter,
				3,
				baseZ + 1
			)
			local sIcon = Library:CreateIcon(sFrame, "search", 13, Library.Theme.TextMuted, baseZ + 3)
			sIcon.Instance.Position = UDim2.fromOffset(10, 9)

			local sBox = Instance.new("TextBox")
			sBox.BackgroundTransparency = 1
			sBox.Position = UDim2.fromOffset(29, 0)
			sBox.Size = UDim2.new(1, -36, 1, 0)
			sBox.FontFace = FontMedium
			sBox.TextSize = 12
			sBox.TextXAlignment = Enum.TextXAlignment.Left
			sBox.PlaceholderText = info.SearchPlaceholder or "Search..."
			sBox.PlaceholderColor3 = Color3.fromRGB(74, 74, 78)
			sBox.TextColor3 = Library.Theme.TextPrimary
			sBox.Text = ""
			sBox.ClearTextOnFocus = false
			sBox.ZIndex = baseZ + 3
			sBox.Parent = sFrame

			sBox:GetPropertyChangedSignal("Text"):Connect(function()
				query = string.lower(sBox.Text)
			end)
			Library:BindStep(function()
				if sFrame.Parent then
					sFrame.BackgroundColor3 = Library.Theme.GroupBg
					sInner.Color = sBox:IsFocused() and Library.Theme.Accent or Library.Theme.ControlStroke
					sOuter.Color = Library.Theme.ControlOuter
					sBox.TextColor3 = Library.Theme.TextPrimary
				end
			end)
		end

		local listBoxFrame, lInner, lOuter = CreateDualBorderBox(
			wrap,
			"ListContainer",
			UDim2.fromOffset(padX, showSearch and 39 or 3),
			UDim2.fromOffset(boxW, listH),
			Library.Theme.ContentBg,
			Library.Theme.GroupStrokeInner,
			Library.Theme.ControlOuter,
			3,
			baseZ + 1
		)

		local scroll = Instance.new("ScrollingFrame")
		scroll.Position = UDim2.fromOffset(4, 4)
		scroll.Size = UDim2.new(1, -8, 1, -8)
		scroll.BackgroundTransparency = 1
		scroll.BorderSizePixel = 0
		scroll.ScrollBarThickness = 2
		scroll.ScrollBarImageColor3 = Library.Theme.Accent
		scroll.ZIndex = baseZ + 3
		scroll.Parent = listBoxFrame

		local selHighlight = Instance.new("Frame")
		selHighlight.Size = UDim2.new(1, -4, 0, 32)
		selHighlight.Position = UDim2.fromOffset(2, 0)
		selHighlight.BackgroundColor3 = Color3.fromRGB(22, 22, 25)
		selHighlight.BackgroundTransparency = 1
		selHighlight.BorderSizePixel = 0
		selHighlight.ZIndex = baseZ + 3
		selHighlight.Parent = scroll
		Instance.new("UICorner", selHighlight).CornerRadius = UDim.new(0, 3)

		local selAccent = Instance.new("Frame")
		selAccent.Position = UDim2.fromOffset(0, 8)
		selAccent.Size = UDim2.fromOffset(2, 16)
		selAccent.BackgroundColor3 = Library.Theme.Accent
		selAccent.BorderSizePixel = 0
		selAccent.ZIndex = baseZ + 4
		selAccent.Parent = selHighlight
		Instance.new("UICorner", selAccent).CornerRadius = UDim.new(1, 0)

		local lbObj = {
			Type = "ListBox",
			Index = idx,
			Values = values,
			Statuses = info.Statuses or {},
			Value = info.Default or values[1],
			Callback = info.Callback,
			ChangedCallbacks = {},
		}

		local rowSlots = {}
		local selTargetY = 0
		local selCurrentY = 0
		local selAlpha = 0

		local function SyncListRows()
			local visIdx = 0
			local foundSel = false
			for i, item in ipairs(lbObj.Values) do
				local nameStr = tostring(item)
				local matches = (query == "" or string.find(string.lower(nameStr), query, 1, true) ~= nil)
				local slot = rowSlots[i]
				if not slot then
					local btn = Instance.new("TextButton")
					btn.Size = UDim2.new(1, -4, 0, 32)
					btn.BackgroundTransparency = 1
					btn.AutoButtonColor = false
					btn.Text = ""
					btn.ZIndex = baseZ + 4
					btn.Parent = scroll

					local lbl = Instance.new("TextLabel")
					lbl.BackgroundTransparency = 1
					lbl.Position = UDim2.fromOffset(12, 0)
					lbl.Size = UDim2.new(1, -80, 1, 0)
					lbl.FontFace = FontMedium
					lbl.TextSize = 13
					lbl.TextXAlignment = Enum.TextXAlignment.Left
					lbl.TextTruncate = Enum.TextTruncate.AtEnd
					lbl.ZIndex = baseZ + 5
					lbl.Parent = btn

					local statusLbl = Instance.new("TextLabel")
					statusLbl.BackgroundTransparency = 1
					statusLbl.Position = UDim2.new(1, -72, 0, 0)
					statusLbl.Size = UDim2.fromOffset(64, 32)
					statusLbl.FontFace = FontBold
					statusLbl.TextSize = 11
					statusLbl.TextXAlignment = Enum.TextXAlignment.Right
					statusLbl.ZIndex = baseZ + 5
					statusLbl.Parent = btn

					slot = { Btn = btn, Label = lbl, Status = statusLbl, Hover = false, Item = item }
					btn.MouseEnter:Connect(function() slot.Hover = true end)
					btn.MouseLeave:Connect(function() slot.Hover = false end)
					btn.MouseButton1Click:Connect(function()
						lbObj:SetValue(slot.Item)
					end)
					rowSlots[i] = slot
				end

				slot.Item = item
				slot.Btn.Visible = matches
				if matches then
					local yPos = visIdx * 34
					slot.Btn.Position = UDim2.fromOffset(2, yPos)
					slot.Label.Text = nameStr
					local st = lbObj.Statuses[nameStr]
					slot.Status.Text = st or ""
					if st == "started" or st == "online" then
						slot.Status.TextColor3 = Color3.fromRGB(108, 224, 146)
					elseif st == "stopped" then
						slot.Status.TextColor3 = Color3.fromRGB(232, 98, 98)
					else
						slot.Status.TextColor3 = Library.Theme.TextSubtle
					end
					if lbObj.Value == item then
						selTargetY = yPos
						foundSel = true
					end
					visIdx += 1
				end
			end

			for i = #lbObj.Values + 1, #rowSlots do
				rowSlots[i].Btn.Visible = false
			end
			scroll.CanvasSize = UDim2.fromOffset(0, visIdx * 34)
			return foundSel
		end

		function lbObj:SetValues(newVals, newStatuses)
			self.Values = newVals or {}
			if newStatuses then
				self.Statuses = newStatuses
			end
			SyncListRows()
		end

		function lbObj:SetStatus(itemName, statusText)
			self.Statuses[itemName] = statusText
			SyncListRows()
		end

		function lbObj:SetValue(val)
			self.Value = val
			SyncListRows()
			Library:SafeCallback(self.Callback, val)
			for _, cb in ipairs(self.ChangedCallbacks) do
				Library:SafeCallback(cb, val)
			end
		end

		function lbObj:OnChanged(fn)
			table.insert(self.ChangedCallbacks, fn)
			return self
		end

		SyncListRows()
		selCurrentY = selTargetY

		Library:BindStep(function(dt)
			if not wrap.Parent then
				return
			end
			local th = Library.Theme
			listBoxFrame.BackgroundColor3 = th.ContentBg
			lInner.Color = th.GroupStrokeInner
			lOuter.Color = th.ControlOuter
			local hasSel = SyncListRows()
			selAlpha += ((hasSel and 1 or 0) - selAlpha) * math.min(1, dt * 12)
			selCurrentY += (selTargetY - selCurrentY) * math.min(1, dt * 15)
			selHighlight.Position = UDim2.fromOffset(2, math.floor(selCurrentY + 0.5))
			selHighlight.BackgroundColor3 = th.ControlBg
			selHighlight.BackgroundTransparency = 1 - SmoothStep(selAlpha)
			selAccent.BackgroundColor3 = th.Accent
			selAccent.BackgroundTransparency = 1 - SmoothStep(selAlpha)

			for i = 1, #lbObj.Values do
				local slot = rowSlots[i]
				if slot and slot.Btn.Visible then
					local isSel = (lbObj.Value == slot.Item)
					slot.Label.TextColor3 = isSel and th.TextBright or (slot.Hover and th.TextLabel or th.TextDim)
				end
			end
		end)

		if idx then
			Options[idx] = lbObj
		end
		return lbObj
	end

	-- ------------------------------------------------------------------------
	-- 10. CURVE EDITOR (1:1 ech0.fun 5-point draggable yellow curve editor)
	-- ------------------------------------------------------------------------
	function target:AddCurve(idx, info)
		info = info or {}
		local boxW = InnerWidth()
		local graphH = tonumber(info.Height) or 126
		local pts = {}
		local def = info.Default or { 0.67, 0.72, 0.50, 0.25, 0.00 }
		for i = 1, 5 do
			pts[i] = math.clamp(tonumber(def[i]) or 0.5, 0, 1)
		end

		local wrap = Instance.new("Frame")
		wrap.Name = "Curve_" .. tostring(idx)
		wrap.BackgroundTransparency = 1
		wrap.Size = UDim2.new(1, 0, 0, graphH + 28)
		wrap.LayoutOrder = NextOrder()
		wrap.ZIndex = baseZ
		wrap.Parent = target.Container

		local titleLbl = Instance.new("TextLabel")
		titleLbl.BackgroundTransparency = 1
		titleLbl.Position = UDim2.fromOffset(padX, 0)
		titleLbl.Size = UDim2.fromOffset(boxW, 18)
		titleLbl.FontFace = FontBold
		titleLbl.TextSize = 12
		titleLbl.TextXAlignment = Enum.TextXAlignment.Left
		titleLbl.TextColor3 = Library.Theme.TextLabel
		titleLbl.Text = info.Text or "Acceleration Curve"
		titleLbl.ZIndex = baseZ + 1
		titleLbl.Parent = wrap

		local canvas, cInner, cOuter = CreateDualBorderBox(
			wrap,
			"CurveCanvas",
			UDim2.fromOffset(padX, 22),
			UDim2.fromOffset(boxW, graphH),
			Library.Theme.ContentBg,
			Library.Theme.GroupStrokeInner,
			Library.Theme.ControlOuter,
			3,
			baseZ + 1
		)

		-- Subtle 4x4 grid lines
		for g = 1, 3 do
			local hLine = Instance.new("Frame")
			hLine.Position = UDim2.new(0, 10, g / 4, 0)
			hLine.Size = UDim2.new(1, -20, 0, 1)
			hLine.BorderSizePixel = 0
			hLine.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
			hLine.ZIndex = baseZ + 2
			hLine.Parent = canvas

			local vLine = Instance.new("Frame")
			vLine.Position = UDim2.new(g / 4, 0, 0, 10)
			vLine.Size = UDim2.new(0, 1, 1, -20)
			vLine.BorderSizePixel = 0
			vLine.BackgroundColor3 = Color3.fromRGB(20, 20, 22)
			vLine.ZIndex = baseZ + 2
			vLine.Parent = canvas
		end

		local segments = {}
		for i = 1, 4 do
			local seg = Instance.new("Frame")
			seg.AnchorPoint = Vector2.new(0.5, 0.5)
			seg.BackgroundColor3 = Color3.fromRGB(235, 204, 104)
			seg.BorderSizePixel = 0
			seg.ZIndex = baseZ + 3
			seg.Parent = canvas
			segments[i] = seg
		end

		local nodes = {}
		local dragNodeIdx = nil

		local curveObj = {
			Type = "Curve",
			Index = idx,
			Value = pts,
			Callback = info.Callback,
			ChangedCallbacks = {},
		}

		local function RedrawCurve()
			local padIn = 14
			local w = boxW - padIn * 2
			local h = graphH - padIn * 2
			local coords = {}
			for i = 1, 5 do
				local nx = padIn + ((i - 1) / 4) * w
				local ny = padIn + (1 - curveObj.Value[i]) * h
				coords[i] = Vector2.new(nx, ny)
				if nodes[i] then
					nodes[i].Position = UDim2.fromOffset(nx, ny)
				end
			end
			for i = 1, 4 do
				local a = coords[i]
				local b = coords[i + 1]
				local mid = (a + b) * 0.5
				local d = b - a
				local len = d.Magnitude
				local ang = math.deg(math.atan2(d.Y, d.X))
				segments[i].Position = UDim2.fromOffset(mid.X, mid.Y)
				segments[i].Size = UDim2.fromOffset(math.ceil(len), 2)
				segments[i].Rotation = ang
			end
		end

		for i = 1, 5 do
			local nd = Instance.new("TextButton")
			nd.AnchorPoint = Vector2.new(0.5, 0.5)
			nd.Size = UDim2.fromOffset(10, 10)
			nd.BackgroundColor3 = Color3.fromRGB(244, 217, 132)
			nd.BorderSizePixel = 0
			nd.AutoButtonColor = false
			nd.Text = ""
			nd.ZIndex = baseZ + 4
			nd.Parent = canvas
			Instance.new("UICorner", nd).CornerRadius = UDim.new(1, 0)
			local nStroke = Instance.new("UIStroke")
			nStroke.Color = Color3.fromRGB(25, 25, 25)
			nStroke.Thickness = 1.5
			nStroke.Parent = nd

			nd.InputBegan:Connect(function(inp)
				if inp.UserInputType == Enum.UserInputType.MouseButton1 then
					dragNodeIdx = i
				end
			end)
			nodes[i] = nd
		end

		Library:GiveSignal(UserInputService.InputChanged:Connect(function(inp)
			if dragNodeIdx and inp.UserInputType == Enum.UserInputType.MouseMovement then
				local relY = inp.Position.Y - canvas.AbsolutePosition.Y
				local absH = math.max(1, canvas.AbsoluteSize.Y)
				local padScaled = 14 * math.max(0.25, windowCtx.CurrentScale)
				local norm = 1 - math.clamp((relY - padScaled) / math.max(1, absH - padScaled * 2), 0, 1)
				curveObj.Value[dragNodeIdx] = math.floor(norm * 100 + 0.5) / 100
				RedrawCurve()
				Library:SafeCallback(curveObj.Callback, curveObj.Value)
				for _, cb in ipairs(curveObj.ChangedCallbacks) do
					Library:SafeCallback(cb, curveObj.Value)
				end
			end
		end))
		Library:GiveSignal(UserInputService.InputEnded:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 then
				dragNodeIdx = nil
			end
		end))

		function curveObj:SetValue(arr)
			if type(arr) == "table" then
				for i = 1, 5 do
					if arr[i] ~= nil then
						self.Value[i] = math.clamp(tonumber(arr[i]) or 0, 0, 1)
					end
				end
				RedrawCurve()
			end
		end

		function curveObj:OnChanged(fn)
			table.insert(self.ChangedCallbacks, fn)
			return self
		end

		RedrawCurve()

		Library:BindStep(function()
			if wrap.Parent then
				titleLbl.TextColor3 = Library.Theme.TextLabel
				canvas.BackgroundColor3 = Library.Theme.ContentBg
				cInner.Color = Library.Theme.GroupStrokeInner
				cOuter.Color = Library.Theme.ControlOuter
			end
		end)

		if idx then
			Options[idx] = curveObj
		end
		return curveObj
	end

	-- ------------------------------------------------------------------------
	-- 11. CODE EDITOR (1:1 ech0.fun Server -> Lua script editor with gutter)
	-- ------------------------------------------------------------------------
	function target:AddCodeEditor(idx, info)
		info = info or {}
		local edH = tonumber(info.Height) or 310
		local boxW = InnerWidth()

		local wrap = Instance.new("Frame")
		wrap.Name = "CodeEditor_" .. tostring(idx)
		wrap.BackgroundTransparency = 1
		wrap.Size = UDim2.new(1, 0, 0, edH + 8)
		wrap.LayoutOrder = NextOrder()
		wrap.ZIndex = baseZ
		wrap.Parent = target.Container

		local shell, sInner, sOuter = CreateDualBorderBox(
			wrap,
			"EditorShell",
			UDim2.fromOffset(padX, 4),
			UDim2.fromOffset(boxW, edH),
			Library.Theme.ContentBg,
			Library.Theme.GroupStrokeInner,
			Library.Theme.ControlOuter,
			3,
			baseZ + 1
		)

		local gutter = Instance.new("Frame")
		gutter.Size = UDim2.new(0, 34, 1, 0)
		gutter.BackgroundColor3 = Library.Theme.GroupBg
		gutter.BorderSizePixel = 0
		gutter.ZIndex = baseZ + 2
		gutter.Parent = shell
		Instance.new("UICorner", gutter).CornerRadius = UDim.new(0, 3)

		local gutterLine = Instance.new("Frame")
		gutterLine.Position = UDim2.new(1, -1, 0, 0)
		gutterLine.Size = UDim2.new(0, 1, 1, 0)
		gutterLine.BorderSizePixel = 0
		gutterLine.BackgroundColor3 = Library.Theme.GroupStrokeInner
		gutterLine.ZIndex = baseZ + 3
		gutterLine.Parent = gutter

		local scroll = Instance.new("ScrollingFrame")
		scroll.Position = UDim2.fromOffset(0, 6)
		scroll.Size = UDim2.new(1, -4, 1, -12)
		scroll.BackgroundTransparency = 1
		scroll.BorderSizePixel = 0
		scroll.ScrollBarThickness = 2
		scroll.ScrollBarImageColor3 = Library.Theme.Accent
		scroll.ZIndex = baseZ + 4
		scroll.Parent = shell

		local lineNums = Instance.new("TextLabel")
		lineNums.BackgroundTransparency = 1
		lineNums.Position = UDim2.fromOffset(0, 0)
		lineNums.Size = UDim2.fromOffset(28, 200)
		lineNums.FontFace = FontCode
		lineNums.TextSize = 12
		lineNums.TextXAlignment = Enum.TextXAlignment.Right
		lineNums.TextYAlignment = Enum.TextYAlignment.Top
		lineNums.TextColor3 = Library.Theme.TextSubtle
		lineNums.Text = "1"
		lineNums.ZIndex = baseZ + 5
		lineNums.Parent = scroll

		local codeBox = Instance.new("TextBox")
		codeBox.BackgroundTransparency = 1
		codeBox.Position = UDim2.fromOffset(42, 0)
		codeBox.Size = UDim2.new(1, -48, 0, 200)
		codeBox.FontFace = FontCode
		codeBox.TextSize = 12
		codeBox.TextXAlignment = Enum.TextXAlignment.Left
		codeBox.TextYAlignment = Enum.TextYAlignment.Top
		codeBox.MultiLine = true
		codeBox.ClearTextOnFocus = false
		codeBox.TextColor3 = Library.Theme.TextPrimary
		codeBox.Text = tostring(info.Default or '-- ech0.fun luau console\nprint("Hello World!")')
		codeBox.ZIndex = baseZ + 5
		codeBox.Parent = scroll

		local edObj = {
			Type = "Input",
			Index = idx,
			Value = codeBox.Text,
			Callback = info.Callback,
			ChangedCallbacks = {},
		}

		local function UpdateLineCount()
			local _, nl = string.gsub(codeBox.Text, "\n", "\n")
			local count = nl + 1
			local nums = table.create(count)
			for i = 1, count do
				nums[i] = tostring(i)
			end
			lineNums.Text = table.concat(nums, "\n")
			local ch = math.max(edH - 16, count * 16 + 24)
			lineNums.Size = UDim2.fromOffset(28, ch)
			codeBox.Size = UDim2.new(1, -48, 0, ch)
			scroll.CanvasSize = UDim2.fromOffset(0, ch)
		end

		codeBox:GetPropertyChangedSignal("Text"):Connect(function()
			edObj.Value = codeBox.Text
			UpdateLineCount()
			Library:SafeCallback(edObj.Callback, edObj.Value)
			for _, cb in ipairs(edObj.ChangedCallbacks) do
				Library:SafeCallback(cb, edObj.Value)
			end
		end)

		function edObj:GetText()
			return codeBox.Text
		end

		function edObj:SetValue(txt)
			codeBox.Text = tostring(txt or "")
		end

		function edObj:OnChanged(fn)
			table.insert(self.ChangedCallbacks, fn)
			return self
		end

		UpdateLineCount()

		Library:BindStep(function()
			if wrap.Parent then
				shell.BackgroundColor3 = Library.Theme.ContentBg
				sInner.Color = Library.Theme.GroupStrokeInner
				sOuter.Color = Library.Theme.ControlOuter
				gutter.BackgroundColor3 = Library.Theme.GroupBg
				gutterLine.BackgroundColor3 = Library.Theme.GroupStrokeInner
				lineNums.TextColor3 = Library.Theme.TextSubtle
				codeBox.TextColor3 = Library.Theme.TextPrimary
			end
		end)

		if idx then
			Options[idx] = edObj
		end
		return edObj
	end
end

local function CreateGroupboxObject(parentColumn, windowCtx, titleText, iconName, boxWidth)
	local gWidth = boxWidth or 293

	local outerWrap = Instance.new("Frame")
	outerWrap.Name = "Group_" .. tostring(titleText)
	outerWrap.BackgroundTransparency = 1
	outerWrap.Size = UDim2.fromOffset(gWidth, 72)
	outerWrap.ZIndex = 8
	outerWrap.Parent = parentColumn

	local box, innerStroke, outerStroke, outerBorder = CreateDualBorderBox(
		outerWrap,
		"Card",
		UDim2.fromOffset(0, 0),
		UDim2.fromScale(1, 1),
		Library.Theme.GroupBg,
		Library.Theme.GroupStrokeInner,
		Library.Theme.GroupStrokeOuter,
		3,
		8
	)

	local hasIcon = (iconName ~= nil and iconName ~= "")
	local headerIcon = nil
	if hasIcon then
		headerIcon = Library:CreateIcon(box, iconName, 13, Library.Theme.Accent, 11)
		headerIcon.Instance.Position = UDim2.fromOffset(21, 15)
	end

	local titleX = hasIcon and 46 or 15
	local headerTitle = Instance.new("TextLabel")
	headerTitle.BackgroundTransparency = 1
	headerTitle.Position = UDim2.fromOffset(titleX, 0)
	headerTitle.Size = UDim2.new(1, -(titleX + 12), 0, 43)
	headerTitle.FontFace = FontBold
	headerTitle.TextSize = 13
	headerTitle.TextXAlignment = Enum.TextXAlignment.Left
	headerTitle.TextColor3 = Library.Theme.TextPrimary
	headerTitle.Text = tostring(titleText or "Group")
	headerTitle.ZIndex = 11
	headerTitle.Parent = box

	local headerLine = Instance.new("Frame")
	headerLine.Position = UDim2.fromOffset(15, 43)
	headerLine.Size = UDim2.new(1, -15, 0, 1)
	headerLine.BorderSizePixel = 0
	headerLine.BackgroundColor3 = Library.Theme.GroupStrokeInner
	headerLine.ZIndex = 11
	headerLine.Parent = box

	local container = Instance.new("Frame")
	container.Name = "Items"
	container.Position = UDim2.fromOffset(0, 50)
	container.Size = UDim2.new(1, 0, 0, 10)
	container.BackgroundTransparency = 1
	container.ZIndex = 10
	container.Parent = box

	local list = Instance.new("UIListLayout")
	list.SortOrder = Enum.SortOrder.LayoutOrder
	list.Padding = UDim.new(0, 2)
	list.Parent = container

	local function UpdateBoxHeight()
		local ch = list.AbsoluteContentSize.Y
		container.Size = UDim2.new(1, 0, 0, ch)
		outerWrap.Size = UDim2.fromOffset(gWidth, math.max(64, 50 + ch + 12))
	end
	Library:GiveSignal(list:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateBoxHeight))

	Library:BindStep(function()
		if not outerWrap.Parent then
			return
		end
		local th = Library.Theme
		box.BackgroundColor3 = th.GroupBg
		innerStroke.Color = th.GroupStrokeInner
		outerStroke.Color = th.GroupStrokeOuter
		headerTitle.TextColor3 = th.TextPrimary
		headerLine.BackgroundColor3 = th.GroupStrokeInner
		if headerIcon then
			headerIcon:SetColor(th.Accent)
		end
	end)

	local groupObj = {
		Wrapper = outerWrap,
		Card = box,
		Container = container,
		ListLayout = list,
		Width = gWidth,
		PadX = 13,
		BaseZ = 11,
		Order = 0,
	}

	AttachWidgetFactory(groupObj, windowCtx)
	UpdateBoxHeight()
	return groupObj
end

local function CreatePageView(parentContentFrame, windowCtx)
	local scroll = Instance.new("ScrollingFrame")
	scroll.Name = "PageScroll"
	scroll.Position = UDim2.fromOffset(0, 0)
	scroll.Size = UDim2.fromScale(1, 1)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 2
	scroll.ScrollBarImageColor3 = Library.Theme.Accent
	scroll.Visible = false
	scroll.CanvasSize = UDim2.fromOffset(0, 0)
	scroll.ZIndex = 6
	scroll.Parent = parentContentFrame

	-- Full-width top stack (for AddFullGroupbox, e.g. CodeEditor)
	local fullCol = Instance.new("Frame")
	fullCol.Name = "FullColumn"
	fullCol.Position = UDim2.fromOffset(15, 14)
	fullCol.Size = UDim2.fromOffset(598, 0)
	fullCol.BackgroundTransparency = 1
	fullCol.ZIndex = 7
	fullCol.Parent = scroll

	local fullList = Instance.new("UIListLayout")
	fullList.SortOrder = Enum.SortOrder.LayoutOrder
	fullList.Padding = UDim.new(0, 16)
	fullList.Parent = fullCol

	-- Left column (x = 15 inside 628px content = x=81 window coords, width 293px)
	local leftCol = Instance.new("Frame")
	leftCol.Name = "LeftColumn"
	leftCol.Position = UDim2.fromOffset(15, 14)
	leftCol.Size = UDim2.fromOffset(293, 0)
	leftCol.BackgroundTransparency = 1
	leftCol.ZIndex = 7
	leftCol.Parent = scroll

	local leftList = Instance.new("UIListLayout")
	leftList.SortOrder = Enum.SortOrder.LayoutOrder
	leftList.Padding = UDim.new(0, 16)
	leftList.Parent = leftCol

	-- Right column (x = 326 inside 628px content = x=392 window coords, width 293px)
	local rightCol = Instance.new("Frame")
	rightCol.Name = "RightColumn"
	rightCol.Position = UDim2.fromOffset(326, 14)
	rightCol.Size = UDim2.fromOffset(293, 0)
	rightCol.BackgroundTransparency = 1
	rightCol.ZIndex = 7
	rightCol.Parent = scroll

	local rightList = Instance.new("UIListLayout")
	rightList.SortOrder = Enum.SortOrder.LayoutOrder
	rightList.Padding = UDim.new(0, 16)
	rightList.Parent = rightCol

	-- Custom canvas (for Configurations 3-column card grid, etc.)
	local customCanvas = Instance.new("Frame")
	customCanvas.Name = "CustomCanvas"
	customCanvas.Position = UDim2.fromOffset(0, 0)
	customCanvas.Size = UDim2.fromScale(1, 1)
	customCanvas.BackgroundTransparency = 1
	customCanvas.Visible = false
	customCanvas.ZIndex = 7
	customCanvas.Parent = scroll

	local function RecalcCanvas()
		local fh = fullList.AbsoluteContentSize.Y
		local topOffset = fh > 0 and (14 + fh + 16) or 14
		fullCol.Size = UDim2.fromOffset(598, fh)
		leftCol.Position = UDim2.fromOffset(15, topOffset)
		rightCol.Position = UDim2.fromOffset(326, topOffset)
		local lh = leftList.AbsoluteContentSize.Y
		local rh = rightList.AbsoluteContentSize.Y
		leftCol.Size = UDim2.fromOffset(293, lh)
		rightCol.Size = UDim2.fromOffset(293, rh)
		local maxBottom = topOffset + math.max(lh, rh) + 18
		if not customCanvas.Visible then
			scroll.CanvasSize = UDim2.fromOffset(0, math.max(0, maxBottom))
		end
	end

	Library:GiveSignal(fullList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(RecalcCanvas))
	Library:GiveSignal(leftList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(RecalcCanvas))
	Library:GiveSignal(rightList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(RecalcCanvas))

	Library:BindStep(function()
		if scroll.Parent then
			scroll.ScrollBarImageColor3 = Library.Theme.Accent
		end
	end)

	local page = {
		Scroll = scroll,
		FullColumn = fullCol,
		LeftColumn = leftCol,
		RightColumn = rightCol,
		CustomCanvas = customCanvas,
		Window = windowCtx,
	}

	function page:AddLeftGroupbox(title, icon)
		return CreateGroupboxObject(leftCol, windowCtx, title, icon, 293)
	end

	function page:AddRightGroupbox(title, icon)
		return CreateGroupboxObject(rightCol, windowCtx, title, icon, 293)
	end

	function page:AddFullGroupbox(title, icon)
		return CreateGroupboxObject(fullCol, windowCtx, title, icon, 598)
	end

	function page:AddLeftTabbox(title)
		return self:AddTabbox(leftCol, title)
	end

	function page:AddRightTabbox(title)
		return self:AddTabbox(rightCol, title)
	end

	function page:AddTabbox(colParent, _)
		local gWidth = 293
		local outerWrap = Instance.new("Frame")
		outerWrap.BackgroundTransparency = 1
		outerWrap.Size = UDim2.fromOffset(gWidth, 80)
		outerWrap.ZIndex = 8
		outerWrap.Parent = colParent

		local box, innerStroke, outerStroke = CreateDualBorderBox(
			outerWrap,
			"TabboxCard",
			UDim2.fromOffset(0, 0),
			UDim2.fromScale(1, 1),
			Library.Theme.GroupBg,
			Library.Theme.GroupStrokeInner,
			Library.Theme.GroupStrokeOuter,
			3,
			8
		)

		local tabHeader = Instance.new("Frame")
		tabHeader.Position = UDim2.fromOffset(12, 0)
		tabHeader.Size = UDim2.new(1, -24, 0, 40)
		tabHeader.BackgroundTransparency = 1
		tabHeader.ZIndex = 11
		tabHeader.Parent = box

		local tabHeaderLayout = Instance.new("UIListLayout")
		tabHeaderLayout.FillDirection = Enum.FillDirection.Horizontal
		tabHeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
		tabHeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		tabHeaderLayout.Padding = UDim.new(0, 8)
		tabHeaderLayout.Parent = tabHeader

		local headerLine = Instance.new("Frame")
		headerLine.Position = UDim2.fromOffset(15, 40)
		headerLine.Size = UDim2.new(1, -15, 0, 1)
		headerLine.BorderSizePixel = 0
		headerLine.BackgroundColor3 = Library.Theme.GroupStrokeInner
		headerLine.ZIndex = 11
		headerLine.Parent = box

		local tabboxObj = {
			Tabs = {},
			ActiveTab = nil,
		}

		local function SyncHeight()
			if tabboxObj.ActiveTab then
				local ch = tabboxObj.ActiveTab.ListLayout.AbsoluteContentSize.Y
				tabboxObj.ActiveTab.Container.Size = UDim2.new(1, 0, 0, ch)
				outerWrap.Size = UDim2.fromOffset(gWidth, math.max(64, 48 + ch + 12))
			end
		end

		function tabboxObj:AddTab(tabName)
			local tBtn = Instance.new("TextButton")
			local tw = CalcTextBounds(tabName, FontBold, 12).X + 16
			tBtn.Size = UDim2.fromOffset(tw, 24)
			tBtn.BackgroundColor3 = Library.Theme.ControlBg
			tBtn.BorderSizePixel = 0
			tBtn.AutoButtonColor = false
			tBtn.FontFace = FontBold
			tBtn.TextSize = 12
			tBtn.Text = tabName
			tBtn.ZIndex = 12
			tBtn.Parent = tabHeader
			Instance.new("UICorner", tBtn).CornerRadius = UDim.new(0, 3)

			local cont = Instance.new("Frame")
			cont.Position = UDim2.fromOffset(0, 46)
			cont.Size = UDim2.new(1, 0, 0, 10)
			cont.BackgroundTransparency = 1
			cont.Visible = false
			cont.ZIndex = 10
			cont.Parent = box

			local tList = Instance.new("UIListLayout")
			tList.SortOrder = Enum.SortOrder.LayoutOrder
			tList.Padding = UDim.new(0, 2)
			tList.Parent = cont

			local subTab = {
				Name = tabName,
				Button = tBtn,
				Container = cont,
				ListLayout = tList,
				Width = gWidth,
				PadX = 13,
				BaseZ = 11,
				Order = 0,
			}
			AttachWidgetFactory(subTab, windowCtx)
			Library:GiveSignal(tList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(SyncHeight))

			local function Activate()
				tabboxObj.ActiveTab = subTab
				for _, st in ipairs(tabboxObj.Tabs) do
					local act = (st == subTab)
					st.Container.Visible = act
					st.Button.BackgroundTransparency = act and 0 or 1
					st.Button.TextColor3 = act and Library.Theme.Accent or Library.Theme.TextDim
				end
				SyncHeight()
			end

			tBtn.MouseButton1Click:Connect(Activate)
			table.insert(tabboxObj.Tabs, subTab)
			if #tabboxObj.Tabs == 1 then
				Activate()
			else
				tBtn.BackgroundTransparency = 1
				tBtn.TextColor3 = Library.Theme.TextDim
			end
			return subTab
		end

		Library:BindStep(function()
			if outerWrap.Parent then
				box.BackgroundColor3 = Library.Theme.GroupBg
				innerStroke.Color = Library.Theme.GroupStrokeInner
				outerStroke.Color = Library.Theme.GroupStrokeOuter
				headerLine.BackgroundColor3 = Library.Theme.GroupStrokeInner
			end
		end)

		return tabboxObj
	end

	function page:UseCustomCanvas(canvasHeight)
		leftCol.Visible = false
		rightCol.Visible = false
		fullCol.Visible = false
		customCanvas.Visible = true
		scroll.CanvasSize = UDim2.fromOffset(0, canvasHeight or 0)
		return customCanvas, scroll
	end

	return page
end

-- ============================================================================
-- WINDOW SHELL, TOPBAR, SIDEBAR, MODALS, BOTTOM POPUP (1:1 main.cpp 708x564)
-- ============================================================================
function Library:SetTheme(themeName)
	local nextTheme = Themes[themeName]
	if not nextTheme then
		return
	end
	self.ThemeName = themeName
	self.Theme = nextTheme
	self.AccentColor = nextTheme.Accent
end

function Library:Toggle()
	self.Toggled = not self.Toggled
	if self.MainWindowCtx then
		self.MainWindowCtx.TargetVisible = self.Toggled
		if not self.Toggled then
			self.MainWindowCtx:CloseFloatingPopups("all")
		end
	end
end

function Library:OnUnload(fn)
	table.insert(self.UnloadCallbacks, fn)
end

function Library:Unload()
	if self.Unloaded then
		return
	end
	self.Unloaded = true
	for _, fn in ipairs(self.UnloadCallbacks) do
		self:SafeCallback(fn)
	end
	for _, conn in ipairs(self.Signals) do
		pcall(function()
			conn:Disconnect()
		end)
	end
	table.clear(self.Signals)
	table.clear(self.StepHandlers)
	DisposeInstance(self.ScreenGui)
end

function Library:CreateWindow(config)
	config = config or {}
	if config.IconAtlas then
		self:SetIconAtlas(config.IconAtlas)
	end
	if config.MenuKeybind then
		self.MenuKeyCode = config.MenuKeybind
	end

	local titleWhiteStr = config.TitleWhite or "ech0."
	local titleAccentStr = config.TitleAccent or "fun"
	if config.Title and not config.TitleWhite and not config.TitleAccent then
		local dotPos = string.find(config.Title, "%.")
		if dotPos then
			titleWhiteStr = string.sub(config.Title, 1, dotPos)
			titleAccentStr = string.sub(config.Title, dotPos + 1)
		else
			titleWhiteStr = config.Title
			titleAccentStr = ""
		end
	end

	local cam = workspace.CurrentCamera
	local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
	local startX = config.Center ~= false and math.floor((vp.X - 708) * 0.5) or (config.Position and config.Position.X.Offset or 160)
	local startY = config.Center ~= false and math.floor((vp.Y - 564) * 0.5) or (config.Position and config.Position.Y.Offset or 120)

	-- Outer border 1: 708x564, RGB(45,45,45) alpha 120/255, corner 5px
	local root = Instance.new("Frame")
	root.Name = "WindowShell_708x564"
	root.Position = UDim2.fromOffset(math.max(8, startX), math.max(8, startY))
	root.Size = UDim2.fromOffset(708, 564)
	root.BackgroundColor3 = self.Theme.OuterBorder1
	root.BackgroundTransparency = 0.53
	root.BorderSizePixel = 0
	root.Visible = (config.AutoShow ~= false)
	root.ZIndex = 1
	root.Parent = self.ScreenGui
	Instance.new("UICorner", root).CornerRadius = UDim.new(0, 5)

	local uiScale = Instance.new("UIScale")
	uiScale.Scale = 1
	uiScale.Parent = root

	-- Outer border 2: inset 1px, RGB(10,10,10) alpha 120/255, corner 4px
	local border2 = Instance.new("Frame")
	border2.Position = UDim2.fromOffset(1, 1)
	border2.Size = UDim2.new(1, -2, 1, -2)
	border2.BackgroundColor3 = self.Theme.OuterBorder2
	border2.BackgroundTransparency = 0.53
	border2.BorderSizePixel = 0
	border2.ZIndex = 2
	border2.Parent = root
	Instance.new("UICorner", border2).CornerRadius = UDim.new(0, 4)

	-- Main canvas: inset 4px (700x556), RGB(6,6,6) opaque, corner 2px
	local canvas = Instance.new("Frame")
	canvas.Name = "MainCanvas"
	canvas.Position = UDim2.fromOffset(4, 4)
	canvas.Size = UDim2.fromOffset(700, 556)
	canvas.BackgroundColor3 = self.Theme.Canvas
	canvas.BorderSizePixel = 0
	canvas.ZIndex = 3
	canvas.Parent = root
	Instance.new("UICorner", canvas).CornerRadius = UDim.new(0, 2)

	-- Content Panel: (66, 56) in root coords -> (62, 52) in canvas coords, size 628x494
	local contentPanel, contentInnerStroke, contentOuterStroke = CreateDualBorderBox(
		canvas,
		"ContentPanel",
		UDim2.fromOffset(62, 52),
		UDim2.fromOffset(628, 494),
		self.Theme.ContentBg,
		self.Theme.ContentStrokeInner,
		self.Theme.ContentStrokeOuter,
		3,
		4
	)
	contentPanel.ClipsDescendants = true

	-- Fade veil over content panel to reproduce exact topbar_alpha * subtab_content_alpha transitions!
	local contentFadeVeil = Instance.new("Frame")
	contentFadeVeil.Name = "TransitionVeil"
	contentFadeVeil.Size = UDim2.fromScale(1, 1)
	contentFadeVeil.BackgroundColor3 = self.Theme.ContentBg
	contentFadeVeil.BackgroundTransparency = 1
	contentFadeVeil.BorderSizePixel = 0
	contentFadeVeil.ZIndex = 50
	contentFadeVeil.Parent = contentPanel

	-- Unclipped Floating Layer for Dropdowns, Gear Popups, ColorPicker, Bottom Popup
	local floatingLayer = Instance.new("Frame")
	floatingLayer.Name = "FloatingLayer"
	floatingLayer.Size = UDim2.fromScale(1, 1)
	floatingLayer.BackgroundTransparency = 1
	floatingLayer.ClipsDescendants = false
	floatingLayer.ZIndex = 200
	floatingLayer.Parent = root

	-- Modal Overlay Layer (4,4 to 704,560)
	local modalLayer = Instance.new("Frame")
	modalLayer.Name = "ModalLayer"
	modalLayer.Position = UDim2.fromOffset(4, 4)
	modalLayer.Size = UDim2.fromOffset(700, 556)
	modalLayer.BackgroundTransparency = 1
	modalLayer.ClipsDescendants = true
	modalLayer.Visible = false
	modalLayer.ZIndex = 400
	modalLayer.Parent = root

	-- Brand Logo + "ech0." + "fun" + First Divider Bar (x = 117, y = 28 in root -> 113, 24 in canvas)
	local firstBar = Instance.new("Frame")
	firstBar.Position = UDim2.fromOffset(113, 24)
	firstBar.Size = UDim2.fromOffset(1, 8)
	firstBar.BorderSizePixel = 0
	firstBar.BackgroundColor3 = self.Theme.TopDivider
	firstBar.ZIndex = 5
	firstBar.Parent = canvas

	local wWhite = CalcTextBounds(titleWhiteStr, FontBold, 14).X
	local wAccent = CalcTextBounds(titleAccentStr, FontBold, 14).X
	local titlePosX = math.max(30, 113 - 8 - wWhite - wAccent)

	local brandLogo = self:CreateIcon(canvas, "logo", 16, self.Theme.Accent, 5)
	brandLogo.Instance.Position = UDim2.fromOffset(titlePosX - 24, 18)

	local brandWhite = Instance.new("TextLabel")
	brandWhite.BackgroundTransparency = 1
	brandWhite.Position = UDim2.fromOffset(titlePosX, 18)
	brandWhite.Size = UDim2.fromOffset(wWhite + 2, 16)
	brandWhite.FontFace = FontBold
	brandWhite.TextSize = 14
	brandWhite.TextXAlignment = Enum.TextXAlignment.Left
	brandWhite.TextColor3 = self.Theme.TextPrimary
	brandWhite.Text = titleWhiteStr
	brandWhite.ZIndex = 5
	brandWhite.Parent = canvas

	local brandAccent = Instance.new("TextLabel")
	brandAccent.BackgroundTransparency = 1
	brandAccent.Position = UDim2.fromOffset(titlePosX + wWhite, 18)
	brandAccent.Size = UDim2.fromOffset(wAccent + 4, 16)
	brandAccent.FontFace = FontBold
	brandAccent.TextSize = 14
	brandAccent.TextXAlignment = Enum.TextXAlignment.Left
	brandAccent.TextColor3 = self.Theme.Accent
	brandAccent.Text = titleAccentStr
	brandAccent.ZIndex = 5
	brandAccent.Parent = canvas

	-- Active Main Tab Topbar Indicator (x = 134, y = 22 in root -> 130, 18 in canvas)
	local topTabIcon = self:CreateIcon(canvas, "user", 16, self.Theme.Accent, 5)
	topTabIcon.Instance.Position = UDim2.fromOffset(130, 18)

	local topTabTitle = Instance.new("TextLabel")
	topTabTitle.BackgroundTransparency = 1
	topTabTitle.Position = UDim2.fromOffset(150, 18)
	topTabTitle.Size = UDim2.fromOffset(90, 16)
	topTabTitle.FontFace = FontBold
	topTabTitle.TextSize = 14
	topTabTitle.TextXAlignment = Enum.TextXAlignment.Left
	topTabTitle.TextColor3 = self.Theme.TextPrimary
	topTabTitle.Text = ""
	topTabTitle.ZIndex = 5
	topTabTitle.Parent = canvas

	local secondBar = Instance.new("Frame")
	secondBar.Position = UDim2.fromOffset(200, 24)
	secondBar.Size = UDim2.fromOffset(1, 8)
	secondBar.BorderSizePixel = 0
	secondBar.BackgroundColor3 = self.Theme.TopDivider
	secondBar.ZIndex = 5
	secondBar.Parent = canvas

	local subtabBarHolder = Instance.new("Frame")
	subtabBarHolder.BackgroundTransparency = 1
	subtabBarHolder.Position = UDim2.fromOffset(224, 12)
	subtabBarHolder.Size = UDim2.fromOffset(466, 30)
	subtabBarHolder.ZIndex = 5
	subtabBarHolder.Parent = canvas

	-- Left Sidebar Container (icons + tooltips)
	local sidebarHolder = Instance.new("Frame")
	sidebarHolder.Name = "Sidebar"
	sidebarHolder.Position = UDim2.fromOffset(0, 0)
	sidebarHolder.Size = UDim2.fromOffset(62, 556)
	sidebarHolder.BackgroundTransparency = 1
	sidebarHolder.ZIndex = 6
	sidebarHolder.Parent = canvas

	-- Player Roblox Avatar at (23, 476) in root -> (19, 472) in canvas, 24x24 rounded circle!
	local pfpFrame = Instance.new("ImageLabel")
	pfpFrame.Name = "PlayerAvatar"
	pfpFrame.Position = UDim2.fromOffset(19, 472)
	pfpFrame.Size = UDim2.fromOffset(24, 24)
	pfpFrame.BackgroundColor3 = self.Theme.ControlBg
	pfpFrame.BorderSizePixel = 0
	pfpFrame.ZIndex = 7
	pfpFrame.Parent = sidebarHolder
	Instance.new("UICorner", pfpFrame).CornerRadius = UDim.new(1, 0)

	local pfpStroke = Instance.new("UIStroke")
	pfpStroke.Color = self.Theme.GroupStrokeInner
	pfpStroke.Thickness = 1
	pfpStroke.Parent = pfpFrame

	local lp = Players.LocalPlayer
	local uid = (lp and lp.UserId and lp.UserId > 0) and lp.UserId or 1
	pfpFrame.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=48&h=48", uid)
	task.spawn(function()
		local ok, content = pcall(function()
			return Players:GetUserThumbnailAsync(uid, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
		end)
		if ok and type(content) == "string" and #content > 0 and pfpFrame.Parent then
			pfpFrame.Image = content
		end
	end)

	-- Bottom Settings Gear Button at center (35, 522) in root -> (31, 518) in canvas
	local bottomGearBtn = Instance.new("TextButton")
	bottomGearBtn.Name = "BottomSettingsGear"
	bottomGearBtn.AnchorPoint = Vector2.new(0.5, 0.5)
	bottomGearBtn.Position = UDim2.fromOffset(31, 518)
	bottomGearBtn.Size = UDim2.fromOffset(36, 36)
	bottomGearBtn.BackgroundTransparency = 1
	bottomGearBtn.Text = ""
	bottomGearBtn.AutoButtonColor = false
	bottomGearBtn.ZIndex = 8
	bottomGearBtn.Parent = sidebarHolder

	local bottomGearIcon = self:CreateIcon(bottomGearBtn, "gear", 16, self.Theme.TextDim, 8)
	bottomGearIcon.Instance.Position = UDim2.fromOffset(10, 10)

	local windowCtx = {
		Root = root,
		Canvas = canvas,
		ContentPanel = contentPanel,
		FloatingLayer = floatingLayer,
		ModalLayer = modalLayer,
		UIScale = uiScale,
		CurrentScale = 1.0,
		TargetScale = 1.0,
		TargetVisible = (config.AutoShow ~= false),
		WindowFade = (config.AutoShow ~= false) and 1 or 0,
		Tabs = {},
		ActiveTabIndex = 1,
		DisplayedTabIndex = 1,
		TopbarVis = 1.0,
		SubtabBarVis = 1.0,
		SubtabContentVis = 1.0,
		GearPopups = {},
		Modals = {},
		BottomPopupOpen = false,
	}
	self.MainWindowCtx = windowCtx
	self.Toggled = windowCtx.TargetVisible

	windowCtx.ColorPickerPopup = BuildFloatingColorPicker(windowCtx)
	windowCtx.DropdownPopup = BuildFloatingDropdown(windowCtx)

	function windowCtx:CloseFloatingPopups(exceptKind, exceptRef)
		if exceptKind ~= "color" then
			self.ColorPickerPopup:Close()
		end
		if exceptKind ~= "dropdown" then
			self.DropdownPopup:Close()
		end
		if exceptKind ~= "bottom" then
			self.BottomPopupOpen = false
		end
		for _, gp in ipairs(self.GearPopups) do
			if gp ~= exceptRef then
				gp:Close()
			end
		end
	end

	-- ------------------------------------------------------------------------
	-- Bottom Settings Popup (208x222: DPI Scale, Dark/Light, Language, Display)
	-- ------------------------------------------------------------------------
	do
		local bpCard = Instance.new("Frame")
		bpCard.Name = "BottomSettingsPopup"
		bpCard.Size = UDim2.fromOffset(208, 222)
		bpCard.Position = UDim2.fromOffset(58, 332)
		bpCard.BackgroundColor3 = self.Theme.BottomPopupBg
		bpCard.BorderSizePixel = 0
		bpCard.Visible = false
		bpCard.ZIndex = 310
		bpCard.Parent = floatingLayer
		Instance.new("UICorner", bpCard).CornerRadius = UDim.new(0, 3)

		local bpStroke = Instance.new("UIStroke")
		bpStroke.Color = self.Theme.PopupStroke
		bpStroke.Thickness = 1
		bpStroke.Parent = bpCard

		local dpiScales = { 0.5, 1.0, 1.5, 2.0 }
		local dpiIndex = 2
		local dpiDragging = false
		local dpiHover = false
		local dpiHoverFade = 0

		local dpiLbl = Instance.new("TextLabel")
		dpiLbl.BackgroundTransparency = 1
		dpiLbl.Position = UDim2.fromOffset(24, 18)
		dpiLbl.Size = UDim2.fromOffset(90, 16)
		dpiLbl.FontFace = FontBold
		dpiLbl.TextSize = 13
		dpiLbl.TextXAlignment = Enum.TextXAlignment.Left
		dpiLbl.TextColor3 = self.Theme.TextLabel
		dpiLbl.Text = "DPI Scale"
		dpiLbl.ZIndex = 312
		dpiLbl.Parent = bpCard

		local dpiValLbl = Instance.new("TextLabel")
		dpiValLbl.BackgroundTransparency = 1
		dpiValLbl.Position = UDim2.fromOffset(118, 18)
		dpiValLbl.Size = UDim2.fromOffset(66, 16)
		dpiValLbl.FontFace = FontBold
		dpiValLbl.TextSize = 13
		dpiValLbl.TextXAlignment = Enum.TextXAlignment.Right
		dpiValLbl.TextColor3 = Color3.fromRGB(142, 142, 148)
		dpiValLbl.Text = "100%"
		dpiValLbl.ZIndex = 312
		dpiValLbl.Parent = bpCard

		local dpiTrack = Instance.new("Frame")
		dpiTrack.Position = UDim2.fromOffset(24, 49)
		dpiTrack.Size = UDim2.fromOffset(160, 5)
		dpiTrack.BackgroundColor3 = self.Theme.ControlHover
		dpiTrack.BorderSizePixel = 0
		dpiTrack.ZIndex = 312
		dpiTrack.Parent = bpCard
		Instance.new("UICorner", dpiTrack).CornerRadius = UDim.new(0, 2)

		local dpiFill = Instance.new("Frame")
		dpiFill.Size = UDim2.new(1 / 3, 0, 1, 0)
		dpiFill.BackgroundColor3 = self.Theme.Accent
		dpiFill.BorderSizePixel = 0
		dpiFill.ZIndex = 313
		dpiFill.Parent = dpiTrack
		Instance.new("UICorner", dpiFill).CornerRadius = UDim.new(0, 2)

		local dpiTicks = {}
		for ti = 1, 4 do
			local tick = Instance.new("Frame")
			tick.AnchorPoint = Vector2.new(0.5, 0.5)
			tick.Position = UDim2.new((ti - 1) / 3, 0, 0.5, 0)
			tick.Size = UDim2.fromOffset(4, 4)
			tick.BackgroundColor3 = Color3.fromRGB(205, 205, 210)
			tick.BorderSizePixel = 0
			tick.ZIndex = 314
			tick.Parent = dpiTrack
			Instance.new("UICorner", tick).CornerRadius = UDim.new(1, 0)
			dpiTicks[ti] = tick
		end

		local dpiKnob = Instance.new("Frame")
		dpiKnob.AnchorPoint = Vector2.new(0.5, 0.5)
		dpiKnob.Position = UDim2.new(1 / 3, 0, 0.5, 0)
		dpiKnob.Size = UDim2.fromOffset(14, 14)
		dpiKnob.BackgroundColor3 = Color3.fromRGB(56, 56, 60)
		dpiKnob.BorderSizePixel = 0
		dpiKnob.ZIndex = 315
		dpiKnob.Parent = dpiTrack
		Instance.new("UICorner", dpiKnob).CornerRadius = UDim.new(1, 0)
		local dpiKnobStroke = Instance.new("UIStroke")
		dpiKnobStroke.Color = Color3.fromRGB(72, 72, 78)
		dpiKnobStroke.Thickness = 1
		dpiKnobStroke.Parent = dpiKnob

		local dpiHit = Instance.new("TextButton")
		dpiHit.Position = UDim2.fromOffset(18, 40)
		dpiHit.Size = UDim2.fromOffset(172, 22)
		dpiHit.BackgroundTransparency = 1
		dpiHit.Text = ""
		dpiHit.ZIndex = 316
		dpiHit.Parent = bpCard

		local function SnapDPIFromMouse(mx)
			local norm = math.clamp((mx - dpiTrack.AbsolutePosition.X) / math.max(1, dpiTrack.AbsoluteSize.X), 0, 1)
			dpiIndex = math.clamp(math.floor(norm * 3 + 0.5) + 1, 1, 4)
			dpiValLbl.Text = string.format("%d%%", math.floor(dpiScales[dpiIndex] * 100 + 0.5))
		end

		dpiHit.MouseEnter:Connect(function() dpiHover = true end)
		dpiHit.MouseLeave:Connect(function() dpiHover = false end)
		dpiHit.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 and windowCtx.BottomPopupOpen then
				dpiDragging = true
				SnapDPIFromMouse(inp.Position.X)
			end
		end)
		Library:GiveSignal(UserInputService.InputChanged:Connect(function(inp)
			if dpiDragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
				SnapDPIFromMouse(inp.Position.X)
			end
		end))
		Library:GiveSignal(UserInputService.InputEnded:Connect(function(inp)
			if dpiDragging and inp.UserInputType == Enum.UserInputType.MouseButton1 then
				dpiDragging = false
				windowCtx.TargetScale = dpiScales[dpiIndex]
				Library.TargetDPIScale = dpiScales[dpiIndex]
			end
		end))

		-- Dark / Light Segmented Switch (178x35 at (15, 78))
		local themeSwitch = Instance.new("Frame")
		themeSwitch.Position = UDim2.fromOffset(15, 78)
		themeSwitch.Size = UDim2.fromOffset(178, 35)
		themeSwitch.BackgroundColor3 = self.Theme.ControlBg
		themeSwitch.BorderSizePixel = 0
		themeSwitch.ZIndex = 312
		themeSwitch.Parent = bpCard
		Instance.new("UICorner", themeSwitch).CornerRadius = UDim.new(0, 2)
		local tsStroke = Instance.new("UIStroke")
		tsStroke.Color = Color3.fromRGB(38, 38, 38)
		tsStroke.Thickness = 1
		tsStroke.Parent = themeSwitch

		local tsPill = Instance.new("Frame")
		tsPill.Position = UDim2.fromOffset(2, 2)
		tsPill.Size = UDim2.fromOffset(85, 31)
		tsPill.BackgroundColor3 = self.Theme.ControlHover
		tsPill.BorderSizePixel = 0
		tsPill.ZIndex = 313
		tsPill.Parent = themeSwitch
		Instance.new("UICorner", tsPill).CornerRadius = UDim.new(0, 2)

		local tsMidLine = Instance.new("Frame")
		tsMidLine.Position = UDim2.fromOffset(89, 4)
		tsMidLine.Size = UDim2.fromOffset(1, 27)
		tsMidLine.BorderSizePixel = 0
		tsMidLine.BackgroundColor3 = self.Theme.TopDivider
		tsMidLine.ZIndex = 314
		tsMidLine.Parent = themeSwitch

		local darkBtn = Instance.new("TextButton")
		darkBtn.Size = UDim2.fromOffset(89, 35)
		darkBtn.BackgroundTransparency = 1
		darkBtn.FontFace = FontBold
		darkBtn.TextSize = 13
		darkBtn.Text = "Dark"
		darkBtn.ZIndex = 315
		darkBtn.Parent = themeSwitch

		local lightBtn = Instance.new("TextButton")
		lightBtn.Position = UDim2.fromOffset(89, 0)
		lightBtn.Size = UDim2.fromOffset(89, 35)
		lightBtn.BackgroundTransparency = 1
		lightBtn.FontFace = FontBold
		lightBtn.TextSize = 13
		lightBtn.Text = "Light"
		lightBtn.ZIndex = 315
		lightBtn.Parent = themeSwitch

		local themeSwitchT = 0
		darkBtn.MouseButton1Click:Connect(function()
			Library:SetTheme("Dark")
		end)
		lightBtn.MouseButton1Click:Connect(function()
			Library:SetTheme("Light")
		end)

		-- Language & Display Mini-Comboboxes (178x30 at y=126 & y=164)
		local miniCombos = {
			{ Items = { "English", "Polish" }, Selected = 1 },
			{ Items = { "Primary Display", "Default" }, Selected = 1 },
		}

		for ci = 1, 2 do
			local mc = miniCombos[ci]
			local cBox, cIn, cOut = CreateDualBorderBox(
				bpCard,
				"MiniCombo_" .. ci,
				UDim2.fromOffset(15, 126 + (ci - 1) * 38),
				UDim2.fromOffset(178, 30),
				self.Theme.ControlBg,
				self.Theme.ControlStroke,
				self.Theme.ControlOuter,
				2,
				312
			)
			local cTxt = Instance.new("TextLabel")
			cTxt.BackgroundTransparency = 1
			cTxt.Position = UDim2.fromOffset(10, 0)
			cTxt.Size = UDim2.new(1, -28, 1, 0)
			cTxt.FontFace = FontMedium
			cTxt.TextSize = 12
			cTxt.TextXAlignment = Enum.TextXAlignment.Left
			cTxt.TextColor3 = self.Theme.TextLabel
			cTxt.Text = mc.Items[1]
			cTxt.ZIndex = 314
			cTxt.Parent = cBox

			local cChev = self:CreateIcon(cBox, "chevron_sm", 11, self.Theme.Accent, 314)
			cChev.Instance.Position = UDim2.new(1, -20, 0.5, -5)

			local cHit = Instance.new("TextButton")
			cHit.BackgroundTransparency = 1
			cHit.Size = UDim2.fromScale(1, 1)
			cHit.Text = ""
			cHit.ZIndex = 315
			cHit.Parent = cBox

			cHit.MouseButton1Click:Connect(function()
				mc.Selected = (mc.Selected % #mc.Items) + 1
				cTxt.Text = mc.Items[mc.Selected]
			end)
			mc.Box = cBox
			mc.In = cIn
			mc.Out = cOut
			mc.Txt = cTxt
			mc.Chev = cChev
		end

		local bpFade = 0
		local gearHover = false
		local gearHoverFade = 0
		bottomGearBtn.MouseEnter:Connect(function() gearHover = true end)
		bottomGearBtn.MouseLeave:Connect(function() gearHover = false end)
		bottomGearBtn.MouseButton1Click:Connect(function()
			if windowCtx.BottomPopupOpen then
				windowCtx.BottomPopupOpen = false
			else
				windowCtx:CloseFloatingPopups("bottom")
				windowCtx.BottomPopupOpen = true
			end
		end)

		Library:BindStep(function(dt)
			local gTarget = (gearHover or windowCtx.BottomPopupOpen) and 1 or 0
			gearHoverFade += (gTarget - gearHoverFade) * math.min(1, dt * 10)
			bottomGearIcon:SetColor(LerpColor(Library.Theme.TextDim, Library.Theme.TextBright, SmoothStep(gearHoverFade)))

			local pTarget = windowCtx.BottomPopupOpen and 1 or 0
			bpFade += (pTarget - bpFade) * math.min(1, dt * 10)
			if math.abs(pTarget - bpFade) < 0.002 then
				bpFade = pTarget
			end
			local e = SmoothStep(bpFade)
			bpCard.Visible = e > 0.005
			if not bpCard.Visible then
				return
			end
			local th = Library.Theme
			bpCard.BackgroundColor3 = th.BottomPopupBg
			bpCard.BackgroundTransparency = 1 - e
			bpStroke.Color = th.PopupStroke
			bpStroke.Transparency = 1 - e

			local slideY = (1 - e) * 10
			bpCard.Position = UDim2.fromOffset(58, math.floor(332 + slideY + 0.5))

			dpiHoverFade += (((dpiHover or dpiDragging) and 1 or 0) - dpiHoverFade) * math.min(1, dt * 10)
			local dh = SmoothStep(dpiHoverFade)
			local fillFrac = (dpiIndex - 1) / 3
			dpiFill.Size = UDim2.new(fillFrac, 0, 1, 0)
			dpiFill.BackgroundColor3 = th.Accent
			dpiKnob.Position = UDim2.new(fillFrac, 0, 0.5, 0)
			local kd = 14 + 4 * dh
			dpiKnob.Size = UDim2.fromOffset(kd, kd)
			dpiLbl.TextColor3 = th.TextLabel
			dpiTrack.BackgroundColor3 = th.ControlHover

			local tIdx = (Library.ThemeName == "Light") and 1 or 0
			themeSwitchT += (tIdx - themeSwitchT) * math.min(1, dt * 10)
			tsPill.Position = UDim2.fromOffset(math.floor(2 + 89 * themeSwitchT + 0.5), 2)
			themeSwitch.BackgroundColor3 = th.ControlBg
			tsPill.BackgroundColor3 = th.ControlHover
			darkBtn.TextColor3 = (tIdx == 0) and th.TextBright or th.TextDim
			lightBtn.TextColor3 = (tIdx == 1) and th.TextBright or th.TextDim

			for ci = 1, 2 do
				local mc = miniCombos[ci]
				mc.Box.BackgroundColor3 = th.ControlBg
				mc.In.Color = th.ControlStroke
				mc.Out.Color = th.ControlOuter
				mc.Txt.TextColor3 = th.TextLabel
				mc.Chev:SetColor(th.Accent)
			end
		end)
	end

	-- Outside click handler to close floating popups cleanly
	Library:GiveSignal(UserInputService.InputBegan:Connect(function(inp)
		if inp.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end
		local mp = Vector2.new(inp.Position.X, inp.Position.Y)
		local function Inside(guiObj)
			if not guiObj or not guiObj.Visible then
				return false
			end
			local p = guiObj.AbsolutePosition
			local s = guiObj.AbsoluteSize
			return mp.X >= p.X and mp.X <= p.X + s.X and mp.Y >= p.Y and mp.Y <= p.Y + s.Y
		end

		if windowCtx.ColorPickerPopup.Open and not Inside(windowCtx.ColorPickerPopup.Card) then
			windowCtx.ColorPickerPopup:Close()
		end
		if windowCtx.DropdownPopup.Open and not Inside(windowCtx.DropdownPopup.Card) then
			if not (windowCtx.DropdownPopup.AnchorFrame and Inside(windowCtx.DropdownPopup.AnchorFrame)) then
				windowCtx.DropdownPopup:Close()
			end
		end
		for _, gp in ipairs(windowCtx.GearPopups) do
			if gp.Open and not Inside(gp.Card) then
				gp:Close()
			end
		end
	end))

	-- Window Dragging (outside contentPanel 66..694, 56..550 and outside modal)
	MakeDraggable(root, root, function()
		return windowCtx.CurrentScale
	end, function(mousePos3)
		for _, m in ipairs(windowCtx.Modals) do
			if m.Open or m.Fade > 0.02 then
				return false
			end
		end
		local mp = Vector2.new(mousePos3.X, mousePos3.Y)
		local cpPos = contentPanel.AbsolutePosition
		local cpSize = contentPanel.AbsoluteSize
		if mp.X >= cpPos.X and mp.X <= cpPos.X + cpSize.X and mp.Y >= cpPos.Y and mp.Y <= cpPos.Y + cpSize.Y then
			return false
		end
		return true
	end)

	-- ------------------------------------------------------------------------
	-- Centered Slide-Up Modal Factory (1:1 sigma::modal_overlay + slide 390px)
	-- ------------------------------------------------------------------------
	function windowCtx:CreateModal(mInfo)
		mInfo = mInfo or {}
		local backdrop = Instance.new("TextButton")
		backdrop.Size = UDim2.fromScale(1, 1)
		backdrop.BackgroundColor3 = Color3.fromRGB(4, 4, 4)
		backdrop.BackgroundTransparency = 1
		backdrop.BorderSizePixel = 0
		backdrop.AutoButtonColor = false
		backdrop.Text = ""
		backdrop.Visible = false
		backdrop.ZIndex = 405
		backdrop.Parent = modalLayer

		-- Top-right close X button at (675, 25) in modalLayer
		local closeBtn = Instance.new("TextButton")
		closeBtn.AnchorPoint = Vector2.new(0.5, 0.5)
		closeBtn.Position = UDim2.fromOffset(675, 25)
		closeBtn.Size = UDim2.fromOffset(26, 26)
		closeBtn.BackgroundTransparency = 1
		closeBtn.AutoButtonColor = false
		closeBtn.Text = ""
		closeBtn.ZIndex = 415
		closeBtn.Parent = backdrop

		local closeIcon = Library:CreateIcon(closeBtn, "close", 14, Color3.fromRGB(118, 118, 124), 416)
		closeIcon.Instance.Position = UDim2.fromOffset(6, 6)

		local groupH = tonumber(mInfo.Height) or 224
		local groupW = tonumber(mInfo.Width) or 260
		local group = Instance.new("Frame")
		group.AnchorPoint = Vector2.new(0.5, 0)
		group.Position = UDim2.new(0.5, 0, 0, math.floor((556 - groupH) * 0.5))
		group.Size = UDim2.fromOffset(groupW, groupH)
		group.BackgroundTransparency = 1
		group.ZIndex = 410
		group.Parent = backdrop

		-- Centered Modal Header (icon + title)
		local tStr = tostring(mInfo.Title or "Modal")
		local tw = CalcTextBounds(tStr, FontBold, 18).X
		local totalHeadW = 20 + 10 + tw
		local headStartX = math.floor((groupW - totalHeadW) * 0.5)

		local mHeadIcon = Library:CreateIcon(group, mInfo.Icon or "plus", 18, Library.Theme.Accent, 412)
		mHeadIcon.Instance.Position = UDim2.fromOffset(headStartX, 2)

		local mHeadTitle = Instance.new("TextLabel")
		mHeadTitle.BackgroundTransparency = 1
		mHeadTitle.Position = UDim2.fromOffset(headStartX + 28, 0)
		mHeadTitle.Size = UDim2.fromOffset(tw + 10, 22)
		mHeadTitle.FontFace = FontBold
		mHeadTitle.TextSize = 18
		mHeadTitle.TextXAlignment = Enum.TextXAlignment.Left
		mHeadTitle.TextColor3 = Library.Theme.TextPrimary
		mHeadTitle.Text = tStr
		mHeadTitle.ZIndex = 412
		mHeadTitle.Parent = group

		local body = Instance.new("Frame")
		body.Position = UDim2.fromOffset(0, 36)
		body.Size = UDim2.new(1, 0, 1, -36)
		body.BackgroundTransparency = 1
		body.ZIndex = 411
		body.Parent = group

		local list = Instance.new("UIListLayout")
		list.SortOrder = Enum.SortOrder.LayoutOrder
		list.Padding = UDim.new(0, 8)
		list.Parent = body

		local modalObj = {
			Backdrop = backdrop,
			Group = group,
			Container = body,
			Width = groupW,
			PadX = 6,
			BaseZ = 412,
			Order = 0,
			Open = false,
			Fade = 0,
		}
		AttachWidgetFactory(modalObj, windowCtx)

		local closeHov = false
		local closeMix = 0
		closeBtn.MouseEnter:Connect(function() closeHov = true end)
		closeBtn.MouseLeave:Connect(function() closeHov = false end)
		closeBtn.MouseButton1Click:Connect(function()
			modalObj.Open = false
		end)

		function modalObj:Show()
			windowCtx:CloseFloatingPopups("all")
			self.Open = true
		end

		function modalObj:Hide()
			self.Open = false
		end

		Library:BindStep(function(dt)
			local t = modalObj.Open and 1 or 0
			modalObj.Fade += (t - modalObj.Fade) * math.min(1, dt * 7.5)
			if math.abs(t - modalObj.Fade) < 0.002 then
				modalObj.Fade = t
			end
			local e = SmoothStep(modalObj.Fade)
			backdrop.Visible = e > 0.005

			local anyModalVisible = false
			for _, m in ipairs(windowCtx.Modals) do
				if m.Fade > 0.005 or m.Open then
					anyModalVisible = true
					break
				end
			end
			modalLayer.Visible = anyModalVisible

			if not backdrop.Visible then
				return
			end
			backdrop.BackgroundTransparency = 1 - (0.88 * e)
			local targetTop = (556 - groupH) * 0.5
			local slideOffset = 390 * (1 - e)
			group.Position = UDim2.new(0.5, 0, 0, math.floor(targetTop + slideOffset + 0.5))
			mHeadIcon:SetColor(Library.Theme.Accent)
			mHeadTitle.TextColor3 = Library.Theme.TextPrimary

			closeMix += ((closeHov and 1 or 0) - closeMix) * math.min(1, dt * 12)
			closeIcon:SetColor(LerpColor(Color3.fromRGB(118, 118, 124), Color3.fromRGB(238, 94, 94), SmoothStep(closeMix)))
		end)

		table.insert(windowCtx.Modals, modalObj)
		return modalObj
	end

	-- ------------------------------------------------------------------------
	-- AddTab & AddSubTab (1:1 Sidebar Icons + Tooltips + Topbar Subtab Bar)
	-- ------------------------------------------------------------------------
	local function RebuildTopbarForDisplayedTab()
		local tab = windowCtx.Tabs[windowCtx.DisplayedTabIndex]
		if not tab then
			return
		end
		topTabIcon:SetIcon(tab.Icon)
		topTabTitle.Text = tab.Name
		local nameW = CalcTextBounds(tab.Name, FontBold, 14).X
		topTabTitle.Size = UDim2.fromOffset(nameW + 6, 16)

		local secBarX = 150 + nameW + 12
		secondBar.Position = UDim2.fromOffset(math.floor(secBarX + 0.5), 24)
		secondBar.Visible = (#tab.SubTabs > 0)

		subtabBarHolder.Position = UDim2.fromOffset(math.floor(secBarX + 24 + 0.5), 12)

		-- Show subtab buttons belonging to displayed tab
		for _, t in ipairs(windowCtx.Tabs) do
			for _, st in ipairs(t.SubTabs) do
				st.TopBtn.Visible = (t == tab)
			end
		end

		-- Show page content belonging to displayed tab & subtab
		for _, t in ipairs(windowCtx.Tabs) do
			if #t.SubTabs > 0 then
				if t.DirectPage then
					t.DirectPage.Scroll.Visible = false
				end
				for si, st in ipairs(t.SubTabs) do
					st.Page.Scroll.Visible = (t == tab and si == t.DisplayedSubIndex)
				end
			else
				if t.DirectPage then
					t.DirectPage.Scroll.Visible = (t == tab)
				end
			end
		end
	end

	function windowCtx:AddTab(nameOrInfo, iconArg)
		local tabName = type(nameOrInfo) == "table" and (nameOrInfo.Name or nameOrInfo.Title) or tostring(nameOrInfo or "Tab")
		local tabIcon = type(nameOrInfo) == "table" and (nameOrInfo.Icon or iconArg) or (iconArg or "folder")
		local tabIdx = #self.Tabs + 1

		-- Sidebar hitbox: (12, 72 + (i-1)*38 - 15) in root -> (8, 53 + (i-1)*38) in canvas, 48x30
		local centerY = 68 + (tabIdx - 1) * 38
		local hitBtn = Instance.new("TextButton")
		hitBtn.Name = "SideTab_" .. tabName
		hitBtn.Position = UDim2.fromOffset(8, centerY - 15)
		hitBtn.Size = UDim2.fromOffset(48, 30)
		hitBtn.BackgroundTransparency = 1
		hitBtn.AutoButtonColor = false
		hitBtn.Text = ""
		hitBtn.ZIndex = 7
		hitBtn.Parent = sidebarHolder

		-- Left 2x12 accent bar at (18, 74 + (i-1)*38) in root -> (14, centerY - 6) in canvas
		local accentBar = Instance.new("Frame")
		accentBar.Position = UDim2.fromOffset(14, centerY - 6)
		accentBar.Size = UDim2.fromOffset(2, 12)
		accentBar.BackgroundColor3 = Library.Theme.Accent
		accentBar.BackgroundTransparency = (tabIdx == 1) and 0 or 1
		accentBar.BorderSizePixel = 0
		accentBar.ZIndex = 8
		accentBar.Parent = sidebarHolder
		Instance.new("UICorner", accentBar).CornerRadius = UDim.new(0, 1)

		local sIcon = Library:CreateIcon(sidebarHolder, tabIcon, 16, (tabIdx == 1) and Library.Theme.TextPrimary or Library.Theme.TextDim, 8)
		sIcon.Instance.Position = UDim2.fromOffset(23, centerY - 8)

		-- Floating Hover Tooltip at (58, centerY - 12), height 25
		local tipW = math.max(55, CalcTextBounds(tabName, FontMedium, 13).X + 18)
		local tooltip = Instance.new("Frame")
		tooltip.Position = UDim2.fromOffset(58, centerY - 8)
		tooltip.Size = UDim2.fromOffset(tipW, 25)
		tooltip.BackgroundColor3 = Library.Theme.TooltipBg
		tooltip.BackgroundTransparency = 1
		tooltip.BorderSizePixel = 0
		tooltip.Visible = false
		tooltip.ZIndex = 350
		tooltip.Parent = floatingLayer
		Instance.new("UICorner", tooltip).CornerRadius = UDim.new(0, 3)

		local tipLbl = Instance.new("TextLabel")
		tipLbl.BackgroundTransparency = 1
		tipLbl.Size = UDim2.fromScale(1, 1)
		tipLbl.FontFace = FontMedium
		tipLbl.TextSize = 13
		tipLbl.TextColor3 = Library.Theme.TooltipText
		tipLbl.TextTransparency = 1
		tipLbl.Text = tabName
		tipLbl.ZIndex = 351
		tipLbl.Parent = tooltip

		local tabObj = {
			Name = tabName,
			Icon = tabIcon,
			Index = tabIdx,
			SubTabs = {},
			ActiveSubIndex = 1,
			DisplayedSubIndex = 1,
			DirectPage = nil,
			SidebarIcon = sIcon,
			AccentBar = accentBar,
			Tooltip = tooltip,
			TooltipLabel = tipLbl,
			Hovered = false,
			IconFade = (tabIdx == 1) and 1 or 0,
			BarFade = (tabIdx == 1) and 1 or 0,
			TipFade = 0,
		}

		hitBtn.MouseEnter:Connect(function() tabObj.Hovered = true end)
		hitBtn.MouseLeave:Connect(function() tabObj.Hovered = false end)
		hitBtn.MouseButton1Click:Connect(function()
			if windowCtx.ActiveTabIndex ~= tabIdx then
				windowCtx:CloseFloatingPopups("all")
				windowCtx.ActiveTabIndex = tabIdx
			end
		end)

		local function EnsureDirectPage()
			if not tabObj.DirectPage then
				tabObj.DirectPage = CreatePageView(contentPanel, windowCtx)
				RebuildTopbarForDisplayedTab()
			end
			return tabObj.DirectPage
		end

		function tabObj:AddSubTab(subNameOrInfo, subIconArg)
			local sName = type(subNameOrInfo) == "table" and (subNameOrInfo.Name or subNameOrInfo.Title) or tostring(subNameOrInfo or "SubTab")
			local sIcon = type(subNameOrInfo) == "table" and (subNameOrInfo.Icon or subIconArg) or (subIconArg or "sliders")
			local sIdx = #self.SubTabs + 1

			-- Calculate horizontal X offset in subtabBarHolder
			local xCursor = 0
			for _, prev in ipairs(self.SubTabs) do
				xCursor += prev.Width + 8
			end

			local txtW = CalcTextBounds(sName, FontBold, 14).X
			local btnW = 16 + 8 + txtW + 14

			local topBtn = Instance.new("TextButton")
			topBtn.Name = "SubTab_" .. sName
			topBtn.Position = UDim2.fromOffset(xCursor, 0)
			topBtn.Size = UDim2.fromOffset(btnW, 30)
			topBtn.BackgroundTransparency = 1
			topBtn.AutoButtonColor = false
			topBtn.Text = ""
			topBtn.Visible = (windowCtx.DisplayedTabIndex == self.Index)
			topBtn.ZIndex = 7
			topBtn.Parent = subtabBarHolder

			local stIcon = Library:CreateIcon(topBtn, sIcon, 15, (sIdx == 1) and Library.Theme.Accent or Library.Theme.TextDim, 8)
			stIcon.Instance.Position = UDim2.fromOffset(4, 6)

			local stLbl = Instance.new("TextLabel")
			stLbl.BackgroundTransparency = 1
			stLbl.Position = UDim2.fromOffset(27, 6)
			stLbl.Size = UDim2.fromOffset(txtW + 6, 16)
			stLbl.FontFace = FontBold
			stLbl.TextSize = 14
			stLbl.TextXAlignment = Enum.TextXAlignment.Left
			stLbl.TextColor3 = (sIdx == 1) and Library.Theme.TextPrimary or Library.Theme.TextDim
			stLbl.Text = sName
			stLbl.ZIndex = 8
			stLbl.Parent = topBtn

			local page = CreatePageView(contentPanel, windowCtx)

			local subObj = {
				Name = sName,
				Icon = sIcon,
				Index = sIdx,
				Width = btnW,
				TopBtn = topBtn,
				IconApi = stIcon,
				Label = stLbl,
				Page = page,
				Hovered = false,
				ActiveFade = (sIdx == 1) and 1 or 0,
				HoverFade = 0,
			}

			topBtn.MouseEnter:Connect(function() subObj.Hovered = true end)
			topBtn.MouseLeave:Connect(function() subObj.Hovered = false end)
			topBtn.MouseButton1Click:Connect(function()
				if tabObj.ActiveSubIndex ~= sIdx then
					windowCtx:CloseFloatingPopups("all")
					tabObj.ActiveSubIndex = sIdx
				end
			end)

			function subObj:AddLeftGroupbox(t, ic)
				return page:AddLeftGroupbox(t, ic)
			end
			function subObj:AddRightGroupbox(t, ic)
				return page:AddRightGroupbox(t, ic)
			end
			function subObj:AddFullGroupbox(t, ic)
				return page:AddFullGroupbox(t, ic)
			end
			function subObj:AddLeftTabbox(t)
				return page:AddLeftTabbox(t)
			end
			function subObj:AddRightTabbox(t)
				return page:AddRightTabbox(t)
			end
			function subObj:UseCustomCanvas(h)
				return page:UseCustomCanvas(h)
			end

			table.insert(self.SubTabs, subObj)
			RebuildTopbarForDisplayedTab()
			return subObj
		end

		-- LinoriaLib direct groupbox methods on Tab (used when Tab has 0 subtabs!)
		function tabObj:AddLeftGroupbox(t, ic)
			return EnsureDirectPage():AddLeftGroupbox(t, ic)
		end
		function tabObj:AddRightGroupbox(t, ic)
			return EnsureDirectPage():AddRightGroupbox(t, ic)
		end
		function tabObj:AddFullGroupbox(t, ic)
			return EnsureDirectPage():AddFullGroupbox(t, ic)
		end
		function tabObj:AddLeftTabbox(t)
			return EnsureDirectPage():AddLeftTabbox(t)
		end
		function tabObj:AddRightTabbox(t)
			return EnsureDirectPage():AddRightTabbox(t)
		end
		function tabObj:UseCustomCanvas(h)
			return EnsureDirectPage():UseCustomCanvas(h)
		end

		table.insert(self.Tabs, tabObj)
		if tabIdx == 1 then
			RebuildTopbarForDisplayedTab()
		end
		return tabObj
	end

	-- Master Window Animation Step (1:1 main.cpp lines 1219-1266 + theme sync)
	Library:BindStep(function(dt)
		-- Smooth DPI scale
		windowCtx.CurrentScale += (windowCtx.TargetScale - windowCtx.CurrentScale) * math.min(1, dt * 10)
		if math.abs(windowCtx.TargetScale - windowCtx.CurrentScale) < 0.002 then
			windowCtx.CurrentScale = windowCtx.TargetScale
		end
		uiScale.Scale = windowCtx.CurrentScale

		-- Window visibility toggle
		local visTarget = windowCtx.TargetVisible and 1 or 0
		windowCtx.WindowFade += (visTarget - windowCtx.WindowFade) * math.min(1, dt * 14)
		if math.abs(visTarget - windowCtx.WindowFade) < 0.003 then
			windowCtx.WindowFade = visTarget
		end
		root.Visible = windowCtx.WindowFade > 0.01
		if not root.Visible then
			return
		end

		local th = Library.Theme
		root.BackgroundColor3 = th.OuterBorder1
		border2.BackgroundColor3 = th.OuterBorder2
		canvas.BackgroundColor3 = th.Canvas
		contentPanel.BackgroundColor3 = th.ContentBg
		contentInnerStroke.Color = th.ContentStrokeInner
		contentOuterStroke.Color = th.ContentStrokeOuter
		firstBar.BackgroundColor3 = th.TopDivider
		secondBar.BackgroundColor3 = th.TopDivider
		brandLogo:SetColor(th.Accent)
		brandWhite.TextColor3 = th.TextPrimary
		brandAccent.TextColor3 = th.Accent
		pfpStroke.Color = th.GroupStrokeInner

		-- Tab & Subtab Smoothstep Cross-Fade State Machine (exact main.cpp speeds: 9.0, 6.8, 8.0)
		local topStep = math.min(1, dt * 9.0)
		local subBarStep = math.min(1, dt * 6.8)
		local subContStep = math.min(1, dt * 8.0)

		if windowCtx.ActiveTabIndex ~= windowCtx.DisplayedTabIndex then
			windowCtx.TopbarVis += (0 - windowCtx.TopbarVis) * topStep
			windowCtx.SubtabBarVis += (0 - windowCtx.SubtabBarVis) * subBarStep
			if windowCtx.TopbarVis <= 0.45 then
				windowCtx.DisplayedTabIndex = windowCtx.ActiveTabIndex
				windowCtx.TopbarVis = 0
				windowCtx.SubtabBarVis = 0
				local dTab = windowCtx.Tabs[windowCtx.DisplayedTabIndex]
				if dTab then
					dTab.DisplayedSubIndex = dTab.ActiveSubIndex
				end
				windowCtx.SubtabContentVis = 0
				RebuildTopbarForDisplayedTab()
			end
		else
			windowCtx.TopbarVis += (1 - windowCtx.TopbarVis) * topStep
			windowCtx.SubtabBarVis += (1 - windowCtx.SubtabBarVis) * subBarStep
			local dTab = windowCtx.Tabs[windowCtx.DisplayedTabIndex]
			if dTab and #dTab.SubTabs > 0 and dTab.ActiveSubIndex ~= dTab.DisplayedSubIndex then
				windowCtx.SubtabContentVis += (0 - windowCtx.SubtabContentVis) * subContStep
				if windowCtx.SubtabContentVis <= 0.45 then
					dTab.DisplayedSubIndex = dTab.ActiveSubIndex
					windowCtx.SubtabContentVis = 0
					RebuildTopbarForDisplayedTab()
				end
			else
				windowCtx.SubtabContentVis += (1 - windowCtx.SubtabContentVis) * subContStep
			end
		end

		local topAlpha = SmoothStep(windowCtx.TopbarVis)
		local subBarAlpha = SmoothStep(windowCtx.SubtabBarVis)
		local dTab = windowCtx.Tabs[windowCtx.DisplayedTabIndex]
		local subContAlpha = (dTab and #dTab.SubTabs > 0) and SmoothStep(windowCtx.SubtabContentVis) or 1
		local contentAlpha = topAlpha * subContAlpha

		topTabIcon:SetColor(th.Accent)
		topTabIcon:SetTransparency(1 - topAlpha)
		topTabTitle.TextColor3 = th.TextPrimary
		topTabTitle.TextTransparency = 1 - topAlpha
		secondBar.BackgroundTransparency = 1 - subBarAlpha

		contentFadeVeil.BackgroundColor3 = th.ContentBg
		contentFadeVeil.BackgroundTransparency = contentAlpha
		contentFadeVeil.Visible = contentAlpha < 0.992

		-- Animate Sidebar Icons, Accent Bars, and Hover Tooltips
		for idx, t in ipairs(windowCtx.Tabs) do
			local isAct = (idx == windowCtx.ActiveTabIndex)
			t.IconFade += (((isAct or t.Hovered) and 1 or 0) - t.IconFade) * math.min(1, dt * 8.0)
			t.BarFade += ((isAct and 1 or 0) - t.BarFade) * math.min(1, dt * 4.6)
			t.TipFade += (((t.Hovered and not isAct) and 1 or 0) - t.TipFade) * math.min(1, dt * 7.0)

			local icMix = SmoothStep(t.IconFade)
			local barMix = SmoothStep(t.BarFade)
			local tipMix = SmoothStep(t.TipFade)

			t.SidebarIcon:SetColor(LerpColor(th.TextDim, th.TextBright, isAct and icMix or icMix * 0.65))
			t.AccentBar.BackgroundColor3 = th.Accent
			t.AccentBar.BackgroundTransparency = 1 - barMix

			t.Tooltip.Visible = tipMix > 0.01
			if t.Tooltip.Visible then
				t.Tooltip.BackgroundColor3 = th.TooltipBg
				t.Tooltip.BackgroundTransparency = 1 - tipMix
				t.TooltipLabel.TextColor3 = th.TooltipText
				t.TooltipLabel.TextTransparency = 1 - tipMix
			end
		end

		-- Animate Subtab Buttons on displayed tab
		if dTab then
			for si, st in ipairs(dTab.SubTabs) do
				local sAct = (si == dTab.ActiveSubIndex)
				st.ActiveFade += ((sAct and 1 or 0) - st.ActiveFade) * math.min(1, dt * 9.0)
				st.HoverFade += (((st.Hovered and not sAct) and 1 or 0) - st.HoverFade) * math.min(1, dt * 10.0)
				local am = SmoothStep(st.ActiveFade)
				local hm = SmoothStep(st.HoverFade)

				local idleCol = LerpColor(th.TextDim, Color3.fromRGB(130, 130, 138), hm)
				st.IconApi:SetColor(LerpColor(idleCol, th.Accent, am))
				st.IconApi:SetTransparency(1 - subBarAlpha)
				st.Label.TextColor3 = LerpColor(idleCol, th.TextPrimary, am)
				st.Label.TextTransparency = 1 - subBarAlpha
			end
		end

		-- Step Floating Popups
		windowCtx.ColorPickerPopup:Step(dt)
		windowCtx.DropdownPopup:Step(dt)
	end)

	return windowCtx
end

GlobalEnv.Library = Library
return Library
