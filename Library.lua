-- Library.lua
-- ech0.fun 1:1 Luau UI Library (LinoriaLib-compatible API)
-- Repository: https://github.com/cloudsense-pub/ui-lib
-- Raw URL:    https://raw.githubusercontent.com/cloudsense-pub/ui-lib/main/Library.lua

local Players = game:GetService("Players")
local Teams = game:GetService("Teams")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

local GlobalEnv = (type(getgenv) == "function" and getgenv()) or _G
if type(GlobalEnv.Library) == "table" and type(GlobalEnv.Library.Unload) == "function" then
	pcall(function()
		GlobalEnv.Library:Unload()
	end)
end
GlobalEnv.Toggles = GlobalEnv.Toggles or {}
GlobalEnv.Options = GlobalEnv.Options or {}

local Toggles = GlobalEnv.Toggles
local Options = GlobalEnv.Options

-- Embedded 288x180 Pure-White-RGB 2x-Nyquist PNG Sprite Sheet (39 ech0.fun icons + X-star logo, 36x36 cells, 28x28 inner, 4px pad)
local EmbeddedAtlasB64 = "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"

local IconUVs = {
	["logo"] = {256, 148, 28, 28},
	["uf010"] = {4, 4, 28, 28},
	["uf02e"] = {40, 4, 28, 28},
	["uf040"] = {76, 4, 28, 28},
	["uf044"] = {112, 4, 28, 28},
	["uf045"] = {148, 4, 28, 28},
	["uf05f"] = {184, 4, 28, 28},
	["uf078"] = {220, 4, 28, 28},
	["uf07f"] = {256, 4, 28, 28},
	["uf095"] = {4, 40, 28, 28},
	["uf0f0"] = {40, 40, 28, 28},
	["uf0fd"] = {76, 40, 28, 28},
	["uf142"] = {112, 40, 28, 28},
	["uf15e"] = {148, 40, 28, 28},
	["uf182"] = {184, 40, 28, 28},
	["uf18c"] = {220, 40, 28, 28},
	["uf19a"] = {256, 40, 28, 28},
	["uf219"] = {4, 76, 28, 28},
	["uf254"] = {40, 76, 28, 28},
	["uf2cb"] = {76, 76, 28, 28},
	["uf313"] = {112, 76, 28, 28},
	["uf317"] = {148, 76, 28, 28},
	["uf3a5"] = {184, 76, 28, 28},
	["uf3b8"] = {220, 76, 28, 28},
	["uf3dc"] = {256, 76, 28, 28},
	["uf407"] = {4, 112, 28, 28},
	["uf41c"] = {40, 112, 28, 28},
	["uf44f"] = {76, 112, 28, 28},
	["uf450"] = {112, 112, 28, 28},
	["uf457"] = {148, 112, 28, 28},
	["uf4ca"] = {184, 112, 28, 28},
	["uf4fa"] = {220, 112, 28, 28},
	["uf53b"] = {256, 112, 28, 28},
	["uf571"] = {4, 148, 28, 28},
	["uf572"] = {40, 148, 28, 28},
	["uf58e"] = {76, 148, 28, 28},
	["uf5ae"] = {112, 148, 28, 28},
	["uf661"] = {148, 148, 28, 28},
	["uf677"] = {184, 148, 28, 28},
	["uf6d6"] = {220, 148, 28, 28},
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

local EXPECTED_ATLAS_BYTES = 16108
local DEFAULT_RAW_ATLAS_URL = "https://raw.githubusercontent.com/cloudsense-pub/ui-lib/main/assets/icon_atlas.png"

local function DecodeBase64(data)
	local b = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
	data = string.gsub(data, "[^" .. b .. "=]", "")
	local len = #data
	if len == 0 or (len % 4) ~= 0 then
		return ""
	end
	local pad = 0
	if string.sub(data, -2) == "==" then
		pad = 2
	elseif string.sub(data, -1) == "=" then
		pad = 1
	end
	local out = table.create((len // 4) * 3 - pad)
	local n = 0
	for i = 1, len, 4 do
		local c1 = (string.find(b, string.sub(data, i, i), 1, true) or 1) - 1
		local c2 = (string.find(b, string.sub(data, i + 1, i + 1), 1, true) or 1) - 1
		local c3 = (string.find(b, string.sub(data, i + 2, i + 2), 1, true) or 1) - 1
		local c4 = (string.find(b, string.sub(data, i + 3, i + 3), 1, true) or 1) - 1
		local triple = bit32.lshift(c1, 18) + bit32.lshift(c2, 12) + bit32.lshift(c3, 6) + c4
		n += 1
		out[n] = string.char(bit32.band(bit32.rshift(triple, 16), 0xFF))
		if not (i + 3 >= len and pad == 2) then
			n += 1
			out[n] = string.char(bit32.band(bit32.rshift(triple, 8), 0xFF))
		end
		if not (i + 3 >= len and pad >= 1) then
			n += 1
			out[n] = string.char(bit32.band(triple, 0xFF))
		end
	end
	return table.concat(out)
end

local function IsValidPngBytes(bytes)
	return type(bytes) == "string"
		and #bytes == EXPECTED_ATLAS_BYTES
		and string.sub(bytes, 1, 4) == "\137PNG"
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
		local path = "ech0fun_assets/icon_atlas_v4.png"
		local needsWrite = true
		if type(isfile) == "function" and type(readfile) == "function" and isfile(path) then
			local rOk, existing = pcall(readfile, path)
			if rOk and IsValidPngBytes(existing) then
				needsWrite = false
			end
		end
		if needsWrite then
			local decoded = DecodeBase64(EmbeddedAtlasB64)
			if not IsValidPngBytes(decoded) then
				local hOk, remoteBytes = pcall(function()
					return game:HttpGet(DEFAULT_RAW_ATLAS_URL)
				end)
				if hOk and IsValidPngBytes(remoteBytes) then
					decoded = remoteBytes
				end
			end
			if type(decoded) == "string" and #decoded > 64 then
				writefile(path, decoded)
			else
				return nil
			end
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

local function GetPlayersString()
	local out = {}
	for _, plr in ipairs(Players:GetPlayers()) do
		table.insert(out, plr.Name)
	end
	table.sort(out)
	return out
end

local function GetTeamsString()
	local out = {}
	for _, tm in ipairs(Teams:GetTeams()) do
		table.insert(out, tm.Name)
	end
	table.sort(out)
	return out
end

local Library = {
	RepoUrl = "https://raw.githubusercontent.com/cloudsense-pub/ui-lib/main/",
	Toggles = Toggles,
	Options = Options,
	OpenedFrames = {},
	DependencyBoxes = {},
	SpecialDropdowns = {},
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
	MenuKeyCode = Enum.KeyCode.RightShift,
	ToggleKeybind = nil,
	ShowCustomCursor = true,
	CurrentRainbowHue = 0,
	CurrentRainbowColor = Color3.fromHSV(0, 0.78, 1),
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
	if self.AtlasPreloader and type(assetId) == "string" and #assetId > 0 then
		self.AtlasPreloader.Image = assetId
	end
	for _, entry in ipairs(self.IconPool) do
		if entry and entry.UpdateAsset then
			entry.UpdateAsset(assetId)
		end
	end
end

local function PopulateProceduralIcon(vecHolder, key, col, alpha, z, sizePx)
	vecHolder:ClearAllChildren()
	local fills = {}
	local strokes = {}
	local thk = math.max(1.25, math.floor(sizePx * 0.108 * 4 + 0.5) / 4)
	local thkScale = thk / math.max(8, sizePx)

	local function Bar(cx, cy, w, h, rot, radiusScale)
		local f = Instance.new("Frame")
		f.AnchorPoint = Vector2.new(0.5, 0.5)
		f.Position = UDim2.fromScale(cx, cy)
		f.Size = UDim2.fromScale(w, h)
		f.Rotation = rot or 0
		f.BackgroundColor3 = col
		f.BackgroundTransparency = alpha
		f.BorderSizePixel = 0
		f.ZIndex = z
		f.Parent = vecHolder
		Instance.new("UICorner", f).CornerRadius = UDim.new(radiusScale or 1, 0)
		table.insert(fills, f)
		return f
	end

	local function Line(x1, y1, x2, y2, wMult)
		local dx = x2 - x1
		local dy = y2 - y1
		local w = thkScale * (wMult or 1)
		local len = math.sqrt(dx * dx + dy * dy) + w * 0.55
		local deg = math.deg(math.atan2(dy, dx))
		return Bar((x1 + x2) * 0.5, (y1 + y2) * 0.5, len, w, deg, 1)
	end

	local function Ring(cx, cy, w, h, radiusScale, rot, parentInst, customThk)
		local f = Instance.new("Frame")
		f.AnchorPoint = Vector2.new(0.5, 0.5)
		f.Position = UDim2.fromScale(cx, cy)
		f.Size = UDim2.fromScale(w, h)
		f.Rotation = rot or 0
		f.BackgroundTransparency = 1
		f.BorderSizePixel = 0
		f.ZIndex = z
		f.Parent = parentInst or vecHolder
		Instance.new("UICorner", f).CornerRadius = UDim.new(radiusScale or 1, 0)
		local s = Instance.new("UIStroke")
		s.Color = col
		s.Thickness = customThk or thk
		s.Transparency = alpha
		s.Parent = f
		table.insert(strokes, s)
		return f
	end

	local function Arc(cx, cy, w, h, clipX, clipY, clipW, clipH, radiusScale, rot)
		local clip = Instance.new("Frame")
		clip.Position = UDim2.fromScale(clipX, clipY)
		clip.Size = UDim2.fromScale(clipW, clipH)
		clip.BackgroundTransparency = 1
		clip.BorderSizePixel = 0
		clip.ClipsDescendants = true
		clip.ZIndex = z
		clip.Parent = vecHolder
		return Ring(
			(cx - clipX) / clipW,
			(cy - clipY) / clipH,
			w / clipW,
			h / clipH,
			radiusScale or 1,
			rot or 0,
			clip
		)
	end

	if key == "logo" then
		Line(0.14, 0.14, 0.86, 0.86, 1.15)
		Line(0.86, 0.14, 0.14, 0.86, 1.15)
		Ring(0.50, 0.50, 0.28, 0.28, 0.16, 45)
	elseif key == "uf4fa" or key == "uf078" then -- chevron / chevron_sm
		local sp = (key == "uf078") and 0.20 or 0.25
		local yTop = (key == "uf078") and 0.40 or 0.37
		local yBot = (key == "uf078") and 0.62 or 0.65
		Line(0.50 - sp, yTop, 0.50, yBot)
		Line(0.50, yBot, 0.50 + sp, yTop)
	elseif key == "uf313" then -- check
		Line(0.18, 0.54, 0.40, 0.75, 1.05)
		Line(0.40, 0.75, 0.83, 0.27, 1.05)
	elseif key == "uf3dc" then -- gear
		Ring(0.50, 0.50, 0.30, 0.30, 1, 0)
		Ring(0.50, 0.50, 0.58, 0.58, 1, 0)
		for a = 0, 135, 45 do
			local rad = math.rad(a)
			local dx = math.cos(rad) * 0.38
			local dy = math.sin(rad) * 0.38
			Bar(0.50 + dx, 0.50 + dy, 0.15, 0.15, a, 0.3)
			Bar(0.50 - dx, 0.50 - dy, 0.15, 0.15, a, 0.3)
		end
	elseif key == "uf5ae" then -- search
		Ring(0.43, 0.43, 0.54, 0.54, 1, 0)
		Line(0.64, 0.64, 0.86, 0.86, 1.1)
	elseif key == "uf44f" then -- close
		Line(0.22, 0.22, 0.78, 0.78)
		Line(0.78, 0.22, 0.22, 0.78)
	elseif key == "uf317" then -- plus
		Line(0.18, 0.50, 0.82, 0.50)
		Line(0.50, 0.18, 0.50, 0.82)
	elseif key == "uf53b" then -- user
		Ring(0.50, 0.30, 0.34, 0.34, 1, 0)
		Arc(0.50, 0.86, 0.68, 0.56, 0.08, 0.52, 0.84, 0.38, 1, 0)
	elseif key == "uf040" then -- users
		Ring(0.38, 0.30, 0.30, 0.30, 1, 0)
		Arc(0.38, 0.85, 0.56, 0.50, 0.04, 0.54, 0.68, 0.36, 1, 0)
		Ring(0.70, 0.33, 0.25, 0.25, 1, 0)
		Arc(0.70, 0.85, 0.44, 0.44, 0.56, 0.56, 0.40, 0.34, 1, 0)
	elseif key == "uf571" then -- user_gear
		Ring(0.39, 0.29, 0.31, 0.31, 1, 0)
		Arc(0.39, 0.85, 0.56, 0.50, 0.05, 0.54, 0.62, 0.36, 1, 0)
		Ring(0.75, 0.71, 0.24, 0.24, 1, 0)
		Line(0.75, 0.53, 0.75, 0.59, 0.85)
		Line(0.75, 0.83, 0.75, 0.89, 0.85)
		Line(0.57, 0.71, 0.63, 0.71, 0.85)
		Line(0.87, 0.71, 0.93, 0.71, 0.85)
	elseif key == "uf07f" then -- sword
		Line(0.35, 0.65, 0.84, 0.16, 1.15)
		Line(0.72, 0.16, 0.84, 0.16, 0.9)
		Line(0.84, 0.16, 0.84, 0.28, 0.9)
		Line(0.22, 0.52, 0.48, 0.78, 1.05)
		Line(0.16, 0.84, 0.35, 0.65, 1.05)
		Bar(0.14, 0.86, 0.14, 0.14, 45, 0.4)
	elseif key == "uf15e" or key == "uf010" then -- eye / scan_eye
		Arc(0.50, 0.67, 0.84, 0.66, 0.06, 0.24, 0.88, 0.30, 1, 0)
		Arc(0.50, 0.33, 0.84, 0.66, 0.06, 0.46, 0.88, 0.30, 1, 0)
		Ring(0.50, 0.50, 0.24, 0.24, 1, 0)
		if key == "uf010" then
			Line(0.12, 0.12, 0.28, 0.12, 0.9)
			Line(0.12, 0.12, 0.12, 0.28, 0.9)
			Line(0.88, 0.12, 0.72, 0.12, 0.9)
			Line(0.88, 0.12, 0.88, 0.28, 0.9)
			Line(0.12, 0.88, 0.28, 0.88, 0.9)
			Line(0.12, 0.88, 0.12, 0.72, 0.9)
			Line(0.88, 0.88, 0.72, 0.88, 0.9)
			Line(0.88, 0.88, 0.88, 0.72, 0.9)
		end
	elseif key == "uf58e" then -- list
		for i = 0, 2 do
			local y = 0.26 + i * 0.24
			Bar(0.17, y, 0.13, 0.13, 0, 1)
			Line(0.34, y, 0.86, y)
		end
	elseif key == "uf407" then -- sliders
		local kx = { 0.66, 0.34, 0.64 }
		for i = 1, 3 do
			local y = 0.24 + (i - 1) * 0.26
			Line(0.14, y, 0.86, y, 0.9)
			Line(kx[i], y - 0.09, kx[i], y + 0.09, 1.15)
		end
	elseif key == "uf142" then -- car
		Line(0.28, 0.28, 0.60, 0.28, 0.95)
		Line(0.18, 0.48, 0.28, 0.28, 0.95)
		Line(0.60, 0.28, 0.74, 0.48, 0.95)
		Ring(0.50, 0.56, 0.82, 0.22, 0.35, 0)
		Ring(0.29, 0.73, 0.20, 0.20, 1, 0)
		Ring(0.71, 0.73, 0.20, 0.20, 1, 0)
	elseif key == "uf045" or key == "uf457" then -- folder / folder_open
		Line(0.12, 0.22, 0.38, 0.22)
		Line(0.38, 0.22, 0.47, 0.33)
		Line(0.47, 0.33, 0.86, 0.33)
		Line(0.12, 0.22, 0.12, 0.78)
		Line(0.12, 0.78, 0.86, 0.78)
		if key == "uf457" then
			Line(0.86, 0.33, 0.86, 0.48)
			Line(0.22, 0.50, 0.90, 0.50, 0.9)
			Line(0.90, 0.50, 0.84, 0.78, 0.9)
			Line(0.22, 0.50, 0.12, 0.78, 0.9)
		else
			Line(0.86, 0.33, 0.86, 0.78)
		end
	elseif key == "uf450" then -- keyboard
		Ring(0.50, 0.52, 0.84, 0.56, 0.18, 0)
		for i = 0, 3 do
			Bar(0.26 + i * 0.16, 0.40, 0.09, 0.09, 0, 1)
		end
		Line(0.30, 0.63, 0.70, 0.63, 0.95)
	elseif key == "uf02e" then -- heart
		Arc(0.34, 0.39, 0.38, 0.38, 0.10, 0.15, 0.42, 0.30, 1, 0)
		Arc(0.66, 0.39, 0.38, 0.38, 0.48, 0.15, 0.42, 0.30, 1, 0)
		Line(0.15, 0.43, 0.50, 0.83)
		Line(0.85, 0.43, 0.50, 0.83)
		Line(0.32, 0.52, 0.44, 0.52, 0.8)
		Line(0.44, 0.52, 0.50, 0.40, 0.8)
		Line(0.50, 0.40, 0.56, 0.60, 0.8)
		Line(0.56, 0.60, 0.62, 0.52, 0.8)
	elseif key == "uf044" then -- crosshair
		Ring(0.50, 0.50, 0.64, 0.64, 1, 0)
		Line(0.50, 0.08, 0.50, 0.26)
		Line(0.50, 0.74, 0.50, 0.92)
		Line(0.08, 0.50, 0.26, 0.50)
		Line(0.74, 0.50, 0.92, 0.50)
		Bar(0.50, 0.50, 0.14, 0.14, 0, 1)
	elseif key == "uf572" then -- target
		Ring(0.50, 0.50, 0.78, 0.78, 1, 0)
		Ring(0.50, 0.50, 0.46, 0.46, 1, 0)
		Bar(0.50, 0.50, 0.16, 0.16, 0, 1)
	elseif key == "uf677" then -- focus
		Line(0.14, 0.14, 0.32, 0.14)
		Line(0.14, 0.14, 0.14, 0.32)
		Line(0.86, 0.14, 0.68, 0.14)
		Line(0.86, 0.14, 0.86, 0.32)
		Line(0.14, 0.86, 0.32, 0.86)
		Line(0.14, 0.86, 0.14, 0.68)
		Line(0.86, 0.86, 0.68, 0.86)
		Line(0.86, 0.86, 0.86, 0.68)
		Line(0.38, 0.50, 0.62, 0.50, 0.95)
		Line(0.50, 0.38, 0.50, 0.62, 0.95)
	elseif key == "uf19a" then -- grid (3x3 table matching ech0.fun)
		Ring(0.50, 0.50, 0.78, 0.78, 0.14, 0)
		Line(0.37, 0.13, 0.37, 0.87, 0.85)
		Line(0.63, 0.13, 0.63, 0.87, 0.85)
		Line(0.13, 0.37, 0.87, 0.37, 0.85)
		Line(0.13, 0.63, 0.87, 0.63, 0.85)
	elseif key == "uf3b8" then -- shield
		Line(0.20, 0.22, 0.50, 0.13)
		Line(0.50, 0.13, 0.80, 0.22)
		Line(0.20, 0.22, 0.20, 0.52)
		Line(0.80, 0.22, 0.80, 0.52)
		Line(0.20, 0.52, 0.50, 0.86)
		Line(0.80, 0.52, 0.50, 0.86)
	elseif key == "uf0fd" then -- globe
		Ring(0.50, 0.50, 0.78, 0.78, 1, 0)
		Ring(0.50, 0.50, 0.38, 0.76, 1, 0)
		Line(0.13, 0.50, 0.87, 0.50, 0.85)
	elseif key == "uf661" then -- box / toolbox
		Arc(0.50, 0.34, 0.34, 0.28, 0.28, 0.14, 0.44, 0.20, 0.45, 0)
		Ring(0.50, 0.59, 0.78, 0.52, 0.16, 0)
		Line(0.13, 0.56, 0.87, 0.56, 0.85)
		Line(0.36, 0.50, 0.36, 0.63, 0.9)
		Line(0.64, 0.50, 0.64, 0.63, 0.9)
	elseif key == "uf095" then -- code
		Line(0.34, 0.32, 0.14, 0.50)
		Line(0.14, 0.50, 0.34, 0.68)
		Line(0.66, 0.32, 0.86, 0.50)
		Line(0.86, 0.50, 0.66, 0.68)
		Line(0.57, 0.22, 0.43, 0.78, 0.95)
	elseif key == "uf6d6" then -- server / file-search
		Arc(0.46, 0.48, 0.60, 0.72, 0.12, 0.10, 0.56, 0.78, 0.14, 0)
		Ring(0.71, 0.71, 0.28, 0.28, 1, 0)
		Line(0.81, 0.81, 0.91, 0.91, 0.95)
	elseif key == "uf182" then -- trash
		Line(0.18, 0.25, 0.82, 0.25)
		Arc(0.50, 0.25, 0.28, 0.20, 0.30, 0.10, 0.40, 0.16, 0.4, 0)
		Ring(0.50, 0.58, 0.52, 0.58, 0.14, 0)
		Line(0.41, 0.41, 0.41, 0.71, 0.85)
		Line(0.59, 0.41, 0.59, 0.71, 0.85)
	elseif key == "uf18c" then -- edit
		Line(0.30, 0.56, 0.68, 0.18)
		Line(0.44, 0.70, 0.82, 0.32)
		Line(0.68, 0.18, 0.82, 0.32)
		Line(0.30, 0.56, 0.18, 0.82)
		Line(0.44, 0.70, 0.18, 0.82)
	elseif key == "uf254" then -- play
		Line(0.26, 0.18, 0.26, 0.82, 1.05)
		Line(0.26, 0.18, 0.80, 0.50, 1.05)
		Line(0.80, 0.50, 0.26, 0.82, 1.05)
	elseif key == "uf2cb" then -- refresh
		Arc(0.50, 0.50, 0.68, 0.68, 0.10, 0.10, 0.80, 0.34, 1, 0)
		Arc(0.50, 0.50, 0.68, 0.68, 0.10, 0.56, 0.80, 0.34, 1, 0)
		Line(0.18, 0.38, 0.36, 0.38, 0.95)
		Line(0.18, 0.20, 0.18, 0.38, 0.95)
		Line(0.82, 0.62, 0.64, 0.62, 0.95)
		Line(0.82, 0.62, 0.82, 0.80, 0.95)
	elseif key == "uf41c" then -- clipboard
		Ring(0.50, 0.55, 0.64, 0.68, 0.16, 0)
		Ring(0.50, 0.21, 0.32, 0.16, 0.35, 0)
	elseif key == "uf4ca" then -- tag
		Line(0.16, 0.16, 0.50, 0.16)
		Line(0.16, 0.16, 0.16, 0.50)
		Line(0.50, 0.16, 0.84, 0.50)
		Line(0.16, 0.50, 0.50, 0.84)
		Line(0.84, 0.50, 0.50, 0.84)
		Bar(0.32, 0.32, 0.13, 0.13, 0, 1)
	elseif key == "uf0f0" then -- dots
		Bar(0.22, 0.50, 0.16, 0.16, 0, 1)
		Bar(0.50, 0.50, 0.16, 0.16, 0, 1)
		Bar(0.78, 0.50, 0.16, 0.16, 0, 1)
	elseif key == "uf05f" then -- mouse
		Ring(0.50, 0.50, 0.52, 0.78, 1, 0)
		Line(0.50, 0.24, 0.50, 0.40)
	elseif key == "uf3a5" then -- book
		Ring(0.33, 0.50, 0.36, 0.64, 0.14, 0)
		Ring(0.67, 0.50, 0.36, 0.64, 0.14, 0)
	elseif key == "uf219" then -- at
		Arc(0.50, 0.50, 0.78, 0.78, 0.06, 0.06, 0.88, 0.88, 1, 0)
		Ring(0.50, 0.50, 0.34, 0.34, 1, 0)
		Line(0.67, 0.36, 0.67, 0.64, 0.95)
	else
		Ring(0.50, 0.50, 0.40, 0.40, 0.25, 45)
	end

	return fills, strokes
end

function Library:CreateIcon(parent, iconId, sizePx, color3, zIndex)
	local key = NormalizeIconKey(iconId)
	local uv = key and IconUVs[key] or nil
	local initColor = color3 or self.Theme.TextPrimary
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
	img.ImageColor3 = initColor
	img.ScaleType = Enum.ScaleType.Stretch
	img.ResampleMode = Enum.ResamplerMode.Default
	img.ZIndex = zIndex or 2
	if uv then
		img.ImageRectOffset = Vector2.new(uv[1], uv[2])
		img.ImageRectSize = Vector2.new(uv[3], uv[4])
	end
	img.Parent = holder

	local vecHolder = Instance.new("Frame")
	vecHolder.Name = "GlyphVectorFallback"
	vecHolder.BackgroundTransparency = 1
	vecHolder.Size = UDim2.fromScale(1, 1)
	vecHolder.ZIndex = zIndex or 2
	vecHolder.Parent = holder

	local currentColor = initColor
	local currentAlpha = 0
	local vecFills, vecStrokes = PopulateProceduralIcon(vecHolder, key, currentColor, currentAlpha, (zIndex or 2) + 1, sizePx)

	local function SyncAsset(asset)
		local useImage = (type(asset) == "string" and #asset > 0 and uv ~= nil)
		if useImage then
			img.Image = asset
			img.Visible = true
			vecHolder.Visible = not img.IsLoaded
		else
			img.Visible = false
			vecHolder.Visible = true
		end
	end

	img:GetPropertyChangedSignal("IsLoaded"):Connect(function()
		local useImage = (uv ~= nil and type(self.IconAtlasId) == "string" and #self.IconAtlasId > 0)
		if useImage and img.IsLoaded then
			img.Visible = true
			vecHolder.Visible = false
		else
			vecHolder.Visible = true
		end
	end)

	SyncAsset(self.IconAtlasId)

	local api = {
		Instance = holder,
		Image = img,
		Fallback = vecHolder,
		SetColor = function(_, c)
			currentColor = c
			img.ImageColor3 = c
			for _, f in ipairs(vecFills) do
				f.BackgroundColor3 = c
			end
			for _, s in ipairs(vecStrokes) do
				s.Color = c
			end
		end,
		SetTransparency = function(_, t)
			currentAlpha = t
			img.ImageTransparency = t
			for _, f in ipairs(vecFills) do
				f.BackgroundTransparency = t
			end
			for _, s in ipairs(vecStrokes) do
				s.Transparency = t
			end
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
			vecFills, vecStrokes = PopulateProceduralIcon(vecHolder, nk, currentColor, currentAlpha, (zIndex or 2) + 1, sizePx)
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
	local function SweepOldGui(container)
		if not container then
			return
		end
		pcall(function()
			for _, child in ipairs(container:GetChildren()) do
				if child.Name == "ech0fun_ui" then
					DisposeInstance(child)
				end
			end
		end)
	end
	if type(gethui) == "function" then
		pcall(function()
			SweepOldGui(gethui())
		end)
	end
	SweepOldGui(CoreGui)
	if Players.LocalPlayer then
		SweepOldGui(Players.LocalPlayer:FindFirstChild("PlayerGui"))
	end

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

local function MakeDraggable(dragHandle, targetFrame, scaleGetter, canDragFn, posGetter, onPosChanged)
	local dragging = false
	local dragInput = nil
	local dragStart = Vector2.zero
	local startPos = Vector2.zero

	Library:GiveSignal(dragHandle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			if canDragFn and not canDragFn(input.Position) then
				return
			end
			dragging = true
			dragInput = input
			dragStart = Vector2.new(input.Position.X, input.Position.Y)
			if posGetter then
				startPos = posGetter()
			else
				startPos = Vector2.new(targetFrame.Position.X.Offset, targetFrame.Position.Y.Offset)
			end
		end
	end))

	Library:GiveSignal(UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input == dragInput) then
			if canDragFn and not canDragFn(input.Position) then
				dragging = false
				dragInput = nil
				return
			end
			local delta = Vector2.new(input.Position.X, input.Position.Y) - dragStart
			local cam = workspace.CurrentCamera
			local vp = cam and cam.ViewportSize or Vector2.new(1920, 1080)
			local sc = scaleGetter and scaleGetter() or 1
			local w = targetFrame.Size.X.Offset * sc
			local h = targetFrame.Size.Y.Offset * sc
			local nx = math.floor(math.clamp(startPos.X + delta.X, 0, math.max(0, vp.X - w)) + 0.5)
			local ny = math.floor(math.clamp(startPos.Y + delta.Y, 0, math.max(0, vp.Y - h)) + 0.5)
			if onPosChanged then
				onPosChanged(Vector2.new(nx, ny))
			else
				targetFrame.Position = UDim2.fromOffset(nx, ny)
			end
		end
	end))

	Library:GiveSignal(UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch or input == dragInput then
			dragging = false
			dragInput = nil
		end
	end))
end

Library.ScreenGui = MountScreenGui()

-- Keep atlas texture resident in VRAM so hidden tabs/popups render crisp PNG glyphs on frame 1
do
	local preloadImg = Instance.new("ImageLabel")
	preloadImg.Name = "AtlasVRAMPreloader"
	preloadImg.Size = UDim2.fromOffset(1, 1)
	preloadImg.Position = UDim2.fromOffset(-10, -10)
	preloadImg.BackgroundTransparency = 1
	preloadImg.ImageTransparency = 0.999
	preloadImg.Image = Library.IconAtlasId or ""
	preloadImg.Parent = Library.ScreenGui
	Library.AtlasPreloader = preloadImg
	if type(Library.IconAtlasId) == "string" and #Library.IconAtlasId > 0 then
		task.spawn(function()
			pcall(function()
				game:GetService("ContentProvider"):PreloadAsync({ preloadImg })
			end)
		end)
	end
end

-- Global Animator Loop (60–240Hz delta-time smoothstep matching main.cpp & sigma.h)
Library.StepHandlers = {}
Library.PostStepHandlers = {}

function Library:BindStep(fn)
	table.insert(self.StepHandlers, fn)
end

function Library:BindPostStep(fn)
	table.insert(self.PostStepHandlers, fn)
end

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
	table.clear(self.PostStepHandlers)
	DisposeInstance(self.ScreenGui)
end

local function ApplySubtreeAlpha(rootInst, fadeTracker, alpha)
	if not rootInst or not rootInst.Parent then
		return
	end
	if alpha >= 0.998 then
		if fadeTracker.Active then
			fadeTracker.Active = false
			for inst, snap in pairs(fadeTracker.Cache) do
				if inst and inst.Parent then
					if snap.Bg ~= nil then inst.BackgroundTransparency = snap.Bg end
					if snap.Txt ~= nil then inst.TextTransparency = snap.Txt end
					if snap.Img ~= nil then inst.ImageTransparency = snap.Img end
					if snap.Str ~= nil then inst.Transparency = snap.Str end
				end
			end
			table.clear(fadeTracker.Cache)
		end
		return
	end

	if not fadeTracker.Active then
		fadeTracker.Active = true
		table.clear(fadeTracker.Cache)
		for _, d in ipairs(rootInst:GetDescendants()) do
			local snap = {}
			if d:IsA("GuiObject") then
				snap.Bg = d.BackgroundTransparency
				if d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox") then
					snap.Txt = d.TextTransparency
				elseif d:IsA("ImageLabel") or d:IsA("ImageButton") then
					snap.Img = d.ImageTransparency
				end
			elseif d:IsA("UIStroke") then
				snap.Str = d.Transparency
			end
			fadeTracker.Cache[d] = snap
		end
	end

	for inst, snap in pairs(fadeTracker.Cache) do
		if inst and inst.Parent then
			if snap.Bg ~= nil and snap.Bg < 1 then
				inst.BackgroundTransparency = 1 - (1 - snap.Bg) * alpha
			end
			if snap.Txt ~= nil and snap.Txt < 1 then
				inst.TextTransparency = 1 - (1 - snap.Txt) * alpha
			end
			if snap.Img ~= nil and snap.Img < 1 then
				inst.ImageTransparency = 1 - (1 - snap.Img) * alpha
			end
			if snap.Str ~= nil and snap.Str < 1 then
				inst.Transparency = 1 - (1 - snap.Str) * alpha
			end
		end
	end
end

Library:GiveSignal(RunService.RenderStepped:Connect(function(dt)
	if Library.Unloaded then
		return
	end
	local clampedDt = math.min(dt, 0.1)
	Library.CurrentRainbowHue = (tick() * 0.18) % 1
	Library.CurrentRainbowColor = Color3.fromHSV(Library.CurrentRainbowHue, 0.78, 1)
	for i = #Library.StepHandlers, 1, -1 do
		local fn = Library.StepHandlers[i]
		if fn then
			fn(clampedDt)
		end
	end
	for i = #Library.PostStepHandlers, 1, -1 do
		local fn = Library.PostStepHandlers[i]
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

	local wmRow = Instance.new("Frame")
	wmRow.Name = "ContentRow"
	wmRow.BackgroundTransparency = 1
	wmRow.Position = UDim2.fromOffset(10, 0)
	wmRow.Size = UDim2.new(0, 0, 1, 0)
	wmRow.AutomaticSize = Enum.AutomaticSize.X
	wmRow.ZIndex = 504
	wmRow.Parent = wmCanvas

	local wmRowLayout = Instance.new("UIListLayout")
	wmRowLayout.FillDirection = Enum.FillDirection.Horizontal
	wmRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	wmRowLayout.SortOrder = Enum.SortOrder.LayoutOrder
	wmRowLayout.Padding = UDim.new(0, 8)
	wmRowLayout.Parent = wmRow

	local wmLogo = Library:CreateIcon(wmRow, "logo", 14, Library.Theme.Accent, 504)
	wmLogo.Instance.LayoutOrder = 1
	wmLogo:SetTransparency(1)

	local wmBrandRich = Instance.new("TextLabel")
	wmBrandRich.BackgroundTransparency = 1
	wmBrandRich.AutomaticSize = Enum.AutomaticSize.X
	wmBrandRich.Size = UDim2.fromOffset(0, 30)
	wmBrandRich.FontFace = FontBold
	wmBrandRich.TextSize = 13
	wmBrandRich.RichText = true
	wmBrandRich.TextXAlignment = Enum.TextXAlignment.Left
	wmBrandRich.TextColor3 = Library.Theme.TextPrimary
	wmBrandRich.TextTransparency = 1
	wmBrandRich.Text = 'ech0.<font color="#8e86f6">fun</font>'
	wmBrandRich.LayoutOrder = 2
	wmBrandRich.ZIndex = 504
	wmBrandRich.Parent = wmRow

	MakeDraggable(wmOuter1, wmOuter1, function() return 1 end, function() return Library.Toggled end)

	local wmFade = 0
	local segmentPool = {}

	local function RebuildWatermarkSegments(rawText, alpha)
		local th = Library.Theme
		wmBrandRich.Text = string.format('ech0.<font color="#%s">fun</font>', th.Accent:ToHex())

		local parts = {}
		for part in string.gmatch(tostring(rawText or ""), "([^|]+)") do
			local trimmed = string.gsub(part, "^%s*(.-)%s*$", "%1")
			if trimmed ~= "" and string.lower(trimmed) ~= "ech0.fun" then
				table.insert(parts, trimmed)
			end
		end

		for idx, segText in ipairs(parts) do
			local slot = segmentPool[idx]
			if not slot then
				local div = Instance.new("Frame")
				div.Size = UDim2.fromOffset(1, 8)
				div.BorderSizePixel = 0
				div.ZIndex = 504
				div.Parent = wmRow

				local lbl = Instance.new("TextLabel")
				lbl.BackgroundTransparency = 1
				lbl.AutomaticSize = Enum.AutomaticSize.X
				lbl.Size = UDim2.fromOffset(0, 30)
				lbl.FontFace = FontMedium
				lbl.TextSize = 12
				lbl.TextXAlignment = Enum.TextXAlignment.Left
				lbl.ZIndex = 504
				lbl.Parent = wmRow

				slot = { Divider = div, Label = lbl }
				segmentPool[idx] = slot
			end

			slot.Divider.Visible = true
			slot.Divider.LayoutOrder = 2 + (idx - 1) * 2 + 1
			slot.Divider.BackgroundColor3 = th.TopDivider
			slot.Divider.BackgroundTransparency = 1 - alpha

			slot.Label.Visible = true
			slot.Label.LayoutOrder = 2 + (idx - 1) * 2 + 2
			slot.Label.Text = segText
			slot.Label.TextColor3 = th.TextLabel
			slot.Label.TextTransparency = 1 - alpha
		end

		for i = #parts + 1, #segmentPool do
			segmentPool[i].Divider.Visible = false
			segmentPool[i].Label.Visible = false
		end

		local rowW = wmRowLayout.AbsoluteContentSize.X
		local totalWidth = math.max(116, rowW + 28)
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
		wmBrandRich.TextColor3 = th.TextPrimary
		wmBrandRich.TextTransparency = 1 - a
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

	MakeDraggable(kbOuter1, kbOuter1, function() return 1 end, function() return Library.Toggled end)

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

	function Library:Notify(text, duration, iconName)
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

		local icon = self:CreateIcon(shell, iconName or "logo", 13, self.Theme.Accent, 803)
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
-- MODAL MOUSE UNLOCK, CUSTOM CURSOR (UELinoriaLib-style), & GLOBAL TOOLTIPS
-- ============================================================================
do
	-- Invisible Modal button unlocks first-person / ShiftLock mouse while UI is open
	local modalElement = Instance.new("TextButton")
	modalElement.Name = "ModalMouseUnlock"
	modalElement.BackgroundTransparency = 1
	modalElement.Size = UDim2.fromOffset(0, 0)
	modalElement.Position = UDim2.fromOffset(0, 0)
	modalElement.Visible = true
	modalElement.Text = ""
	modalElement.AutoButtonColor = false
	modalElement.Modal = Library.Toggled
	modalElement.ZIndex = 1
	modalElement.Parent = Library.ScreenGui
	Library.ModalElement = modalElement

	-- Custom Mouse Cursor (Drawing.new('Triangle') matching UELinoriaLib + ScreenGui fallback)
	local drawingSupported = false
	local drawFill, drawOutline = nil, nil
	pcall(function()
		if type(Drawing) == "table" and type(Drawing.new) == "function" then
			local tri = Drawing.new("Triangle")
			tri.Thickness = 1
			tri.Filled = true
			tri.Visible = false
			pcall(function() tri.ZIndex = 9999 end)

			local out = Drawing.new("Triangle")
			out.Thickness = 1.5
			out.Filled = false
			out.Color = Color3.fromRGB(0, 0, 0)
			out.Visible = false
			pcall(function() out.ZIndex = 10000 end)

			drawFill = tri
			drawOutline = out
			drawingSupported = true
		end
	end)

	-- Fallback GUI cursor pointer if Drawing API is unavailable
	local guiCursor = Instance.new("Frame")
	guiCursor.Name = "CustomCursorFallback"
	guiCursor.Size = UDim2.fromOffset(18, 18)
	guiCursor.BackgroundTransparency = 1
	guiCursor.Visible = false
	guiCursor.ZIndex = 9999
	guiCursor.Parent = Library.ScreenGui

	local guiCursorTip = Instance.new("Frame")
	guiCursorTip.AnchorPoint = Vector2.new(0.5, 0.5)
	guiCursorTip.Position = UDim2.fromOffset(5, 5)
	guiCursorTip.Size = UDim2.fromOffset(8, 8)
	guiCursorTip.Rotation = 45
	guiCursorTip.BackgroundColor3 = Library.Theme.Accent
	guiCursorTip.BorderSizePixel = 0
	guiCursorTip.ZIndex = 10000
	guiCursorTip.Parent = guiCursor
	local guiCursorStroke = Instance.new("UIStroke")
	guiCursorStroke.Color = Color3.new(0, 0, 0)
	guiCursorStroke.Thickness = 1.2
	guiCursorStroke.Parent = guiCursorTip

	local guiCursorTail = Instance.new("Frame")
	guiCursorTail.AnchorPoint = Vector2.new(0.5, 0.5)
	guiCursorTail.Position = UDim2.fromOffset(9, 9)
	guiCursorTail.Size = UDim2.fromOffset(10, 3)
	guiCursorTail.Rotation = 45
	guiCursorTail.BackgroundColor3 = Library.Theme.Accent
	guiCursorTail.BorderSizePixel = 0
	guiCursorTail.ZIndex = 9999
	guiCursorTail.Parent = guiCursor
	local guiTailStroke = Instance.new("UIStroke")
	guiTailStroke.Color = Color3.new(0, 0, 0)
	guiTailStroke.Thickness = 1
	guiTailStroke.Parent = guiCursorTail

	local cursorOverridingMouse = false
	local savedMouseIconState = true

	local function RestoreSystemCursor()
		if cursorOverridingMouse then
			cursorOverridingMouse = false
			pcall(function()
				UserInputService.MouseIconEnabled = savedMouseIconState
			end)
		end
		if drawFill then
			pcall(function() drawFill.Visible = false end)
		end
		if drawOutline then
			pcall(function() drawOutline.Visible = false end)
		end
		guiCursor.Visible = false
	end

	function Library:SetCustomCursor(enabled)
		self.ShowCustomCursor = (enabled == true)
		if not self.ShowCustomCursor then
			RestoreSystemCursor()
		end
	end

	Library:OnUnload(function()
		RestoreSystemCursor()
		if drawFill then
			pcall(function() drawFill:Remove() end)
			drawFill = nil
		end
		if drawOutline then
			pcall(function() drawOutline:Remove() end)
			drawOutline = nil
		end
	end)

	Library:BindStep(function()
		local winVisAlpha = 1
		if Library.MainWindowCtx then
			winVisAlpha = SmoothStep(Library.MainWindowCtx.WindowFade or (Library.Toggled and 1 or 0))
		else
			winVisAlpha = Library.Toggled and 1 or 0
		end

		modalElement.Modal = Library.Toggled and (winVisAlpha > 0.05)

		local wantCustom = Library.ShowCustomCursor
			and (not UserInputService.TouchEnabled or UserInputService.MouseEnabled)
			and (Library.Toggled or winVisAlpha > 0.04)

		if wantCustom then
			if not cursorOverridingMouse then
				pcall(function()
					savedMouseIconState = UserInputService.MouseIconEnabled
				end)
				cursorOverridingMouse = true
			end
			pcall(function()
				UserInputService.MouseIconEnabled = false
			end)

			local mPos = UserInputService:GetMouseLocation()
			local accentCol = Library.Theme.Accent

			if drawingSupported and drawFill and drawOutline then
				guiCursor.Visible = false
				local pA = Vector2.new(mPos.X, mPos.Y)
				local pB = Vector2.new(mPos.X + 16, mPos.Y + 6)
				local pC = Vector2.new(mPos.X + 6, mPos.Y + 16)
				drawFill.Color = accentCol
				drawFill.PointA = pA
				drawFill.PointB = pB
				drawFill.PointC = pC
				drawFill.Visible = true
				pcall(function() drawFill.Transparency = winVisAlpha end)

				drawOutline.Color = Color3.fromRGB(0, 0, 0)
				drawOutline.PointA = pA
				drawOutline.PointB = pB
				drawOutline.PointC = pC
				drawOutline.Visible = true
				pcall(function() drawOutline.Transparency = winVisAlpha end)
			else
				guiCursor.Position = UDim2.fromOffset(math.floor(mPos.X), math.floor(mPos.Y))
				guiCursorTip.BackgroundColor3 = accentCol
				guiCursorTail.BackgroundColor3 = accentCol
				guiCursorTip.BackgroundTransparency = 1 - winVisAlpha
				guiCursorTail.BackgroundTransparency = 1 - winVisAlpha
				guiCursorStroke.Transparency = 1 - winVisAlpha
				guiTailStroke.Transparency = 1 - winVisAlpha
				guiCursor.Visible = true
			end
		else
			RestoreSystemCursor()
		end
	end)

	-- Global Hover Tooltip (LinoriaLib / UELinoriaLib :AddTooltip compatible, ech0.fun styled)
	local tipCard = Instance.new("Frame")
	tipCard.Name = "GlobalHoverTooltip"
	tipCard.Size = UDim2.fromOffset(120, 26)
	tipCard.BackgroundColor3 = Library.Theme.TooltipBg
	tipCard.BackgroundTransparency = 1
	tipCard.BorderSizePixel = 0
	tipCard.Visible = false
	tipCard.ZIndex = 900
	tipCard.Parent = Library.ScreenGui
	Instance.new("UICorner", tipCard).CornerRadius = UDim.new(0, 3)

	local tipStroke = Instance.new("UIStroke")
	tipStroke.Color = Library.Theme.PopupStroke
	tipStroke.Thickness = 1
	tipStroke.Transparency = 1
	tipStroke.Parent = tipCard

	local tipAccent = Instance.new("Frame")
	tipAccent.Position = UDim2.fromOffset(0, 5)
	tipAccent.Size = UDim2.fromOffset(2, 16)
	tipAccent.BackgroundColor3 = Library.Theme.Accent
	tipAccent.BackgroundTransparency = 1
	tipAccent.BorderSizePixel = 0
	tipAccent.ZIndex = 902
	tipAccent.Parent = tipCard
	Instance.new("UICorner", tipAccent).CornerRadius = UDim.new(1, 0)

	local tipLabel = Instance.new("TextLabel")
	tipLabel.BackgroundTransparency = 1
	tipLabel.Position = UDim2.fromOffset(10, 0)
	tipLabel.Size = UDim2.new(1, -18, 1, 0)
	tipLabel.FontFace = FontMedium
	tipLabel.TextSize = 12
	tipLabel.TextXAlignment = Enum.TextXAlignment.Left
	tipLabel.TextColor3 = Library.Theme.TooltipText
	tipLabel.TextTransparency = 1
	tipLabel.ZIndex = 902
	tipLabel.Parent = tipCard

	local activeTooltipOwner = nil
	local activeTooltipText = ""
	local tipFade = 0

	local function IsInstanceVisibleOnScreen(inst)
		local cur = inst
		while cur and cur ~= Library.ScreenGui do
			if cur:IsA("GuiObject") and not cur.Visible then
				return false
			end
			cur = cur.Parent
		end
		return cur == Library.ScreenGui
	end

	local function SyncTooltipLayout(str)
		local bounds = CalcTextBounds(str, FontMedium, 12)
		local w = math.clamp(bounds.X + 22, 48, 360)
		local h = math.max(26, bounds.Y + 12)
		tipCard.Size = UDim2.fromOffset(w, h)
		tipAccent.Size = UDim2.fromOffset(2, math.max(10, h - 10))
		tipLabel.Text = str
	end

	function Library:AddTooltip(hoverInst, tipStr)
		if not hoverInst or type(tipStr) ~= "string" or tipStr == "" then
			return
		end
		local currentStr = tipStr
		hoverInst.MouseEnter:Connect(function()
			if not Library.Toggled then
				return
			end
			activeTooltipOwner = hoverInst
			activeTooltipText = currentStr
			SyncTooltipLayout(currentStr)
		end)
		hoverInst.MouseLeave:Connect(function()
			if activeTooltipOwner == hoverInst then
				activeTooltipOwner = nil
			end
		end)
		return function(updatedText)
			currentStr = tostring(updatedText or "")
			if activeTooltipOwner == hoverInst then
				activeTooltipText = currentStr
				SyncTooltipLayout(currentStr)
			end
		end
	end

	Library:BindStep(function(dt)
		if activeTooltipOwner and not IsInstanceVisibleOnScreen(activeTooltipOwner) then
			activeTooltipOwner = nil
		end
		local showing = (activeTooltipOwner ~= nil and Library.Toggled and activeTooltipText ~= "")
		tipFade += ((showing and 1 or 0) - tipFade) * math.min(1, dt * 14)
		if math.abs((showing and 1 or 0) - tipFade) < 0.003 then
			tipFade = showing and 1 or 0
		end
		local e = SmoothStep(tipFade)
		tipCard.Visible = e > 0.01
		if not tipCard.Visible then
			return
		end
		local th = Library.Theme
		local mPos = UserInputService:GetMouseLocation()
		local vp = Library.ScreenGui.AbsoluteSize
		local px = mPos.X + 16
		local py = mPos.Y + 16
		if vp.X > 0 and px + tipCard.Size.X.Offset + 8 > vp.X then
			px = mPos.X - tipCard.Size.X.Offset - 10
		end
		if vp.Y > 0 and py + tipCard.Size.Y.Offset + 8 > vp.Y then
			py = mPos.Y - tipCard.Size.Y.Offset - 8
		end
		tipCard.Position = UDim2.fromOffset(math.floor(px + 0.5), math.floor(py + (1 - e) * 4 + 0.5))
		tipCard.BackgroundColor3 = th.TooltipBg
		tipCard.BackgroundTransparency = 1 - e
		tipStroke.Color = th.PopupStroke
		tipStroke.Transparency = 1 - e
		tipAccent.BackgroundColor3 = th.Accent
		tipAccent.BackgroundTransparency = 1 - e
		tipLabel.TextColor3 = th.TooltipText
		tipLabel.TextTransparency = 1 - e
	end)
end

-- ============================================================================
-- GLOBAL KEYBIND & INPUT DISPATCHER
-- ============================================================================
Library.ActiveKeyCapture = nil

local function MatchesKeyInput(val, input)
	if not val or val == "None" or val == "" then
		return false
	end
	if typeof(val) == "EnumItem" then
		if val.EnumType == Enum.KeyCode then
			return input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == val
		elseif val.EnumType == Enum.UserInputType then
			return input.UserInputType == val
		end
		val = val.Name
	end
	local s = tostring(val)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		if input.KeyCode == Enum.KeyCode.Unknown then
			return false
		end
		return input.KeyCode.Name == s
			or KeyShortNames[input.KeyCode] == s
			or string.lower(input.KeyCode.Name) == string.lower(s)
	elseif
		input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.MouseButton2
		or input.UserInputType == Enum.UserInputType.MouseButton3
	then
		local short = FormatKeyName(input.UserInputType)
		return input.UserInputType.Name == s or short == s
	end
	return false
end

local function IsMouseOverOpenMenu(mp)
	local w = Library.MainWindowCtx
	if not w or not w.Root or not w.Root.Visible then
		return false
	end
	local p = w.Root.AbsolutePosition
	local s = w.Root.AbsoluteSize
	if mp.X >= p.X and mp.X <= p.X + s.X and mp.Y >= p.Y and mp.Y <= p.Y + s.Y then
		return true
	end
	if w.DropdownPopup and w.DropdownPopup.Card and w.DropdownPopup.Card.Visible then
		local dp, ds = w.DropdownPopup.Card.AbsolutePosition, w.DropdownPopup.Card.AbsoluteSize
		if mp.X >= dp.X and mp.X <= dp.X + ds.X and mp.Y >= dp.Y and mp.Y <= dp.Y + ds.Y then
			return true
		end
	end
	if w.ColorPickerPopup and w.ColorPickerPopup.Card and w.ColorPickerPopup.Card.Visible then
		local cp, cs = w.ColorPickerPopup.Card.AbsolutePosition, w.ColorPickerPopup.Card.AbsoluteSize
		if mp.X >= cp.X and mp.X <= cp.X + cs.X and mp.Y >= cp.Y and mp.Y <= cp.Y + cs.Y then
			return true
		end
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

	-- Active keybind capture (Esc/Backspace clears to None, matching main.cpp)
	if Library.ActiveKeyCapture then
		local cap = Library.ActiveKeyCapture
		if cap.SkipFrame then
			cap.SkipFrame = false
			return
		end
		if input.UserInputType == Enum.UserInputType.Keyboard then
			Library.ActiveKeyCapture = nil
			cap.LastCaptureTick = tick()
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
			cap.LastCaptureTick = tick()
			cap:SetValue({ input.UserInputType.Name, cap.Mode })
			return
		elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
			Library.ActiveKeyCapture = nil
			cap.LastCaptureTick = tick()
			cap:SetValue({ "MouseButton1", cap.Mode })
			return
		end
	end

	-- Menu toggle keybind check (evaluated BEFORE gameProcessed so ShiftLock / Modal never blocks RightShift / Insert / custom bind!)
	local tk = Library.ToggleKeybind
	if type(tk) == "table" and tk.Value ~= nil then
		if MatchesKeyInput(tk.Value, input) then
			Library:Toggle()
			return
		end
	elseif typeof(tk) == "EnumItem" or type(tk) == "string" then
		if MatchesKeyInput(tk, input) then
			Library:Toggle()
			return
		end
	elseif Library.MenuKeyCode and MatchesKeyInput(Library.MenuKeyCode, input) then
		Library:Toggle()
		return
	end

	local isMouseBtn = (
		input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.MouseButton2
		or input.UserInputType == Enum.UserInputType.MouseButton3
	)
	if isMouseBtn then
		if gameProcessed or IsMouseOverOpenMenu(Vector2.new(input.Position.X, input.Position.Y)) then
			return
		end
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

local function RefreshSpecialDropdowns()
	local pList = GetPlayersString()
	local tList = GetTeamsString()
	for _, dd in ipairs(Library.SpecialDropdowns) do
		if dd and dd.SpecialType == "Player" then
			dd:SetValues(pList)
		elseif dd and dd.SpecialType == "Team" then
			dd:SetValues(tList)
		end
	end
end

Library:GiveSignal(Players.PlayerAdded:Connect(RefreshSpecialDropdowns))
Library:GiveSignal(Players.PlayerRemoving:Connect(RefreshSpecialDropdowns))
Library:GiveSignal(Teams.ChildAdded:Connect(RefreshSpecialDropdowns))
Library:GiveSignal(Teams.ChildRemoved:Connect(RefreshSpecialDropdowns))

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
		Rainbow = (info.Rainbow == true),
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

	function cp:SetRainbow(stateBool)
		self.Rainbow = (stateBool == true)
		self:Display()
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

	Library:BindStep(function()
		if cp.Rainbow then
			cp.Hue = Library.CurrentRainbowHue
			cp.Value = Color3.fromHSV(cp.Hue, math.max(0.25, cp.Sat), math.max(0.35, cp.Val))
			cp:Display()
			Library:SafeCallback(cp.Callback, cp.Value)
			for _, cb in ipairs(cp.ChangedCallbacks) do
				Library:SafeCallback(cb, cp.Value)
			end
		end
	end)

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

	-- Copy / Paste / Rainbow action buttons
	local copyBtn = Instance.new("TextButton")
	copyBtn.Position = UDim2.fromOffset(12, 201)
	copyBtn.Size = UDim2.fromOffset(58, 22)
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
	pasteBtn.Position = UDim2.fromOffset(76, 201)
	pasteBtn.Size = UDim2.fromOffset(58, 22)
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

	local rainbowBtn = Instance.new("TextButton")
	rainbowBtn.Position = UDim2.fromOffset(140, 201)
	rainbowBtn.Size = UDim2.fromOffset(68, 22)
	rainbowBtn.BackgroundColor3 = Library.Theme.ControlBg
	rainbowBtn.BorderSizePixel = 0
	rainbowBtn.FontFace = FontBold
	rainbowBtn.TextSize = 11
	rainbowBtn.TextColor3 = Library.Theme.TextLabel
	rainbowBtn.Text = "Rainbow"
	rainbowBtn.AutoButtonColor = false
	rainbowBtn.ZIndex = 322
	rainbowBtn.Parent = card
	Instance.new("UICorner", rainbowBtn).CornerRadius = UDim.new(0, 2)

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
		local btnY = cp.HasAlpha and 201 or 184
		copyBtn.Position = UDim2.fromOffset(12, btnY)
		pasteBtn.Position = UDim2.fromOffset(76, btnY)
		rainbowBtn.Position = UDim2.fromOffset(140, btnY)
		card.Size = UDim2.fromOffset(220, cp.HasAlpha and 232 or 215)
		rainbowBtn.TextColor3 = cp.Rainbow and Library.Theme.Accent or Library.Theme.TextLabel
		rainbowBtn.BackgroundColor3 = cp.Rainbow and Library.Theme.ControlHover or Library.Theme.ControlBg
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
			state.TargetCP.Rainbow = false
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
			state.TargetCP.Rainbow = false
			state.TargetCP:SetValueRGB(ClipboardColor, state.TargetCP.HasAlpha and ClipboardTransparency or 0)
			RefreshPickerUI()
		end
	end)

	rainbowBtn.MouseButton1Click:Connect(function()
		if state.TargetCP then
			state.TargetCP:SetRainbow(not state.TargetCP.Rainbow)
			RefreshPickerUI()
		end
	end)

	Library:AddTooltip(copyBtn, "Copy color to clipboard")
	Library:AddTooltip(pasteBtn, "Paste copied color")
	Library:AddTooltip(rainbowBtn, "Toggle rainbow color cycle")

	local function UpdateDragFromMouse(mpos)
		local cp = state.TargetCP
		if not cp then
			return
		end
		if state.DragSV then
			cp.Rainbow = false
			local rel = mpos - svSquare.AbsolutePosition
			local sz = svSquare.AbsoluteSize
			cp.Sat = math.clamp(rel.X / math.max(1, sz.X), 0, 1)
			cp.Val = 1 - math.clamp(rel.Y / math.max(1, sz.Y), 0, 1)
			cp.Value = Color3.fromHSV(cp.Hue, cp.Sat, cp.Val)
			cp:SetValue({ cp.Hue, cp.Sat, cp.Val }, cp.Transparency)
			RefreshPickerUI()
		elseif state.DragHue then
			cp.Rainbow = false
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
		if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) and state.Open then
			state.DragSV = true
			UpdateDragFromMouse(Vector2.new(inp.Position.X, inp.Position.Y))
		end
	end))
	Library:GiveSignal(hueBar.InputBegan:Connect(function(inp)
		if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) and state.Open then
			state.DragHue = true
			UpdateDragFromMouse(Vector2.new(inp.Position.X, inp.Position.Y))
		end
	end))
	Library:GiveSignal(alphaBar.InputBegan:Connect(function(inp)
		if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) and state.Open then
			state.DragAlpha = true
			UpdateDragFromMouse(Vector2.new(inp.Position.X, inp.Position.Y))
		end
	end))
	Library:GiveSignal(UserInputService.InputChanged:Connect(function(inp)
		if (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) and (state.DragSV or state.DragHue or state.DragAlpha) then
			UpdateDragFromMouse(Vector2.new(inp.Position.X, inp.Position.Y))
		end
	end))
	Library:GiveSignal(UserInputService.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			state.DragSV = false
			state.DragHue = false
			state.DragAlpha = false
		end
	end))

	local fadeTracker = { Active = false, Cache = {} }

	function state:ToggleFor(cp, anchorFrame, parentPopup)
		if self.Open and self.TargetCP == cp then
			self.Open = false
			return
		end
		windowCtx:CloseFloatingPopups("color", parentPopup)
		self.TargetCP = cp
		self.AnchorBtn = anchorFrame
		self.ParentPopup = parentPopup
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
		local isRb = state.TargetCP and state.TargetCP.Rainbow
		rainbowBtn.BackgroundColor3 = isRb and th.ControlHover or th.ControlBg
		rainbowBtn.TextColor3 = isRb and th.Accent or th.TextLabel
		if isRb then
			RefreshPickerUI()
		end

		if self.AnchorBtn and self.AnchorBtn.Parent then
			local sc = math.max(0.25, windowCtx.CurrentScale)
			local rel = (self.AnchorBtn.AbsolutePosition - windowCtx.Root.AbsolutePosition) / sc
			local px = rel.X + 22
			local vpW = Library.ScreenGui.AbsoluteSize.X
			if vpW > 0 and (windowCtx.Root.AbsolutePosition.X + (px + card.Size.X.Offset + 8) * sc) > vpW then
				px = rel.X - card.Size.X.Offset - 10
			end
			local py = math.clamp(rel.Y - 12, 46, 550 - card.Size.Y.Offset)
			local slideY = (1 - e) * -8
			card.Position = UDim2.fromOffset(math.floor(px + 0.5), math.floor(py + slideY + 0.5))
		end
	end

	Library:BindPostStep(function()
		if card.Visible then
			ApplySubtreeAlpha(card, fadeTracker, SmoothStep(state.Fade))
			card.BackgroundTransparency = 1 - SmoothStep(state.Fade)
			shadow.BackgroundTransparency = 1 - (0.35 * SmoothStep(state.Fade))
		end
	end)

	state.Card = card
	return state
end

local function BuildFloatingDropdown(windowCtx)
	local outer = Instance.new("Frame")
	outer.Name = "DropdownPopup_Outer"
	outer.BackgroundTransparency = 1
	outer.Visible = false
	outer.ZIndex = 340
	outer.Parent = windowCtx.FloatingLayer
	Instance.new("UICorner", outer).CornerRadius = UDim.new(0, 4)

	local outerStroke = Instance.new("UIStroke")
	outerStroke.Color = Color3.fromRGB(10, 10, 10)
	outerStroke.Thickness = 1
	outerStroke.Parent = outer

	local box = Instance.new("Frame")
	box.Name = "DropdownPopup"
	box.Position = UDim2.fromOffset(1, 1)
	box.Size = UDim2.new(1, -2, 1, -2)
	box.BackgroundColor3 = Library.Theme.ControlBg
	box.BorderSizePixel = 0
	box.ClipsDescendants = true
	box.ZIndex = 341
	box.Parent = outer
	Instance.new("UICorner", box).CornerRadius = UDim.new(0, 3)

	local innerStroke = Instance.new("UIStroke")
	innerStroke.Color = Color3.fromRGB(36, 36, 36)
	innerStroke.Thickness = 1
	innerStroke.Parent = box

	-- Integrated ech0.fun Dropdown Search Bar
	local searchWrap = Instance.new("Frame")
	searchWrap.Name = "SearchWrap"
	searchWrap.Position = UDim2.fromOffset(6, 6)
	searchWrap.Size = UDim2.new(1, -12, 0, 26)
	searchWrap.BackgroundColor3 = Library.Theme.GroupBg
	searchWrap.BorderSizePixel = 0
	searchWrap.ZIndex = 343
	searchWrap.Parent = box
	Instance.new("UICorner", searchWrap).CornerRadius = UDim.new(0, 3)

	local searchStroke = Instance.new("UIStroke")
	searchStroke.Color = Library.Theme.ControlStroke
	searchStroke.Thickness = 1
	searchStroke.Parent = searchWrap

	local searchIcon = Library:CreateIcon(searchWrap, "search", 12, Library.Theme.TextMuted, 344)
	searchIcon.Instance.Position = UDim2.fromOffset(8, 7)

	local searchBox = Instance.new("TextBox")
	searchBox.Name = "SearchInput"
	searchBox.BackgroundTransparency = 1
	searchBox.Position = UDim2.fromOffset(25, 0)
	searchBox.Size = UDim2.new(1, -46, 1, 0)
	searchBox.FontFace = FontMedium
	searchBox.TextSize = 12
	searchBox.TextXAlignment = Enum.TextXAlignment.Left
	searchBox.PlaceholderText = "Search..."
	searchBox.PlaceholderColor3 = Color3.fromRGB(84, 84, 90)
	searchBox.TextColor3 = Library.Theme.TextPrimary
	searchBox.Text = ""
	searchBox.ClearTextOnFocus = false
	searchBox.ZIndex = 344
	searchBox.Parent = searchWrap

	local clearSearchBtn = Instance.new("TextButton")
	clearSearchBtn.AnchorPoint = Vector2.new(1, 0.5)
	clearSearchBtn.Position = UDim2.new(1, -4, 0.5, 0)
	clearSearchBtn.Size = UDim2.fromOffset(18, 18)
	clearSearchBtn.BackgroundTransparency = 1
	clearSearchBtn.AutoButtonColor = false
	clearSearchBtn.Text = ""
	clearSearchBtn.Visible = false
	clearSearchBtn.ZIndex = 345
	clearSearchBtn.Parent = searchWrap

	local clearSearchIcon = Library:CreateIcon(clearSearchBtn, "close", 10, Library.Theme.TextMuted, 345)
	clearSearchIcon.Instance.Position = UDim2.fromOffset(4, 4)

	local searchDivider = Instance.new("Frame")
	searchDivider.Position = UDim2.fromOffset(6, 36)
	searchDivider.Size = UDim2.new(1, -12, 0, 1)
	searchDivider.BorderSizePixel = 0
	searchDivider.BackgroundColor3 = Library.Theme.GroupStrokeInner
	searchDivider.ZIndex = 343
	searchDivider.Parent = box

	local scroll = Instance.new("ScrollingFrame")
	scroll.Position = UDim2.fromOffset(6, 41)
	scroll.Size = UDim2.fromOffset(253, 100)
	scroll.BackgroundTransparency = 1
	scroll.BorderSizePixel = 0
	scroll.ScrollBarThickness = 2
	scroll.ScrollBarImageColor3 = Library.Theme.Accent
	scroll.CanvasSize = UDim2.fromOffset(0, 0)
	scroll.ZIndex = 342
	scroll.Parent = box

	local emptySearchLbl = Instance.new("TextLabel")
	emptySearchLbl.BackgroundTransparency = 1
	emptySearchLbl.Size = UDim2.new(1, 0, 0, 26)
	emptySearchLbl.FontFace = FontMedium
	emptySearchLbl.TextSize = 12
	emptySearchLbl.TextColor3 = Library.Theme.TextMuted
	emptySearchLbl.Text = "No matching options"
	emptySearchLbl.Visible = false
	emptySearchLbl.ZIndex = 344
	emptySearchLbl.Parent = scroll

	local state = {
		Open = false,
		Fade = 0,
		TargetDD = nil,
		AnchorFrame = nil,
		ParentPopup = nil,
		RowPool = {},
		FullHeight = 120,
		AnimatedFullHeight = 120,
		Width = 265,
		OpenUpward = false,
		FirstVisibleIndex = nil,
	}

	local function SelectIndex(curDD, rowIndex)
		if not curDD or not rowIndex then
			return
		end
		local valName = curDD.Values[rowIndex]
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
	end

	local function RebuildRows(animateFromOpen)
		local dd = state.TargetDD
		if not dd then
			return
		end
		local values = dd.Values or {}
		local itemH = dd.ItemHeight or 27
		local useSearch = (dd.Searchable ~= false)
		local query = useSearch and string.lower(string.gsub(searchBox.Text or "", "^%s*(.-)%s*$", "%1")) or ""

		searchWrap.Visible = useSearch
		searchDivider.Visible = useSearch
		clearSearchBtn.Visible = useSearch and (#(searchBox.Text or "") > 0)
		searchBox.PlaceholderText = dd.SearchPlaceholder or "Search..."

		local topOffset = useSearch and 41 or 5
		scroll.Position = UDim2.fromOffset(6, topOffset)

		local visCount = 0
		state.FirstVisibleIndex = nil

		for idx, itemName in ipairs(values) do
			local slot = state.RowPool[idx]
			if not slot then
				local btn = Instance.new("TextButton")
				btn.Size = UDim2.new(1, 0, 0, itemH)
				btn.BorderSizePixel = 0
				btn.AutoButtonColor = false
				btn.Text = ""
				btn.ZIndex = 343
				btn.Parent = scroll
				Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 2)

				local checkIcon = Library:CreateIcon(btn, "check", 12, Library.Theme.Accent, 344)
				checkIcon.Instance.AnchorPoint = Vector2.new(0, 0.5)
				checkIcon.Instance.Position = UDim2.new(0, 9, 0.5, 0)

				local txt = Instance.new("TextLabel")
				txt.BackgroundTransparency = 1
				txt.Position = UDim2.fromOffset(10, 0)
				txt.Size = UDim2.new(1, -16, 1, 0)
				txt.FontFace = FontMedium
				txt.TextSize = 12
				txt.TextXAlignment = Enum.TextXAlignment.Left
				txt.TextTruncate = Enum.TextTruncate.AtEnd
				txt.ZIndex = 344
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
					SelectIndex(state.TargetDD, slot.Index)
				end)
				state.RowPool[idx] = slot
			end

			slot.Index = idx
			local itemStr = tostring(itemName)
			local matches = (query == "" or string.find(string.lower(itemStr), query, 1, true) ~= nil)
			slot.Btn.Visible = matches

			if matches then
				if not state.FirstVisibleIndex then
					state.FirstVisibleIndex = idx
				end
				slot.Btn.Size = UDim2.new(1, 0, 0, itemH)
				slot.Btn.Position = UDim2.fromOffset(0, visCount * itemH)
				slot.Label.TextSize = dd.CompactText and 12 or 13
				slot.Label.Text = itemStr
				local isSelected = dd.Multi and (dd.Value[itemName] == true) or (dd.Value == itemName)
				if animateFromOpen then
					slot.Mix = isSelected and 0.4 or 0
					slot.SlideMix = isSelected and 0.35 or 0
				else
					slot.Mix = (isSelected or slot.Hovered) and 1 or 0
					slot.SlideMix = isSelected and 1 or 0
				end
				visCount += 1
			end
		end

		for i = #values + 1, #state.RowPool do
			state.RowPool[i].Btn.Visible = false
		end

		emptySearchLbl.Visible = (visCount == 0)
		local totalListH = math.max(26, visCount * itemH)
		local maxListH = useSearch and 164 or 178
		local clampedListH = math.clamp(totalListH, 26, maxListH)

		state.Width = dd.BoxWidth or 265
		state.FullHeight = topOffset + clampedListH + 6
		if animateFromOpen then
			state.AnimatedFullHeight = state.FullHeight
		end

		scroll.CanvasSize = UDim2.fromOffset(0, totalListH)
		scroll.Size = UDim2.fromOffset(math.max(24, state.Width - 12), clampedListH)
		scroll.ScrollingEnabled = (totalListH > clampedListH)
	end

	local suppressSearchSignal = false
	searchBox:GetPropertyChangedSignal("Text"):Connect(function()
		if suppressSearchSignal then
			return
		end
		if state.Open and state.TargetDD then
			scroll.CanvasPosition = Vector2.zero
			RebuildRows(false)
		end
	end)

	clearSearchBtn.MouseButton1Click:Connect(function()
		searchBox.Text = ""
		searchBox:CaptureFocus()
	end)

	searchBox.FocusLost:Connect(function(enterPressed)
		if enterPressed and state.Open and state.TargetDD and state.FirstVisibleIndex then
			SelectIndex(state.TargetDD, state.FirstVisibleIndex)
		end
	end)

	function state:ToggleFor(dd, anchorFrame, parentPopup)
		if self.Open and self.TargetDD == dd then
			self.Open = false
			return
		end
		windowCtx:CloseFloatingPopups("dropdown", parentPopup)
		self.TargetDD = dd
		self.AnchorFrame = anchorFrame
		self.ParentPopup = parentPopup
		self.Open = true
		suppressSearchSignal = true
		searchBox.Text = ""
		suppressSearchSignal = false
		scroll.CanvasPosition = Vector2.zero
		RebuildRows(true)
	end

	function state:Close()
		self.Open = false
		if searchBox:IsFocused() then
			searchBox:ReleaseFocus()
		end
	end

	function state:RefreshIfTarget(dd)
		if self.TargetDD == dd and self.Open then
			RebuildRows(false)
		end
	end

	function state:Step(dt)
		local target = self.Open and 1 or 0
		self.Fade += (target - self.Fade) * math.min(1, dt * 11.5)
		if math.abs(target - self.Fade) < 0.002 then
			self.Fade = target
		end
		local e = SmoothStep(self.Fade)
		outer.Visible = e > 0.005
		if not outer.Visible then
			return
		end
		local th = Library.Theme
		self.AnimatedFullHeight += (self.FullHeight - self.AnimatedFullHeight) * math.min(1, dt * 15)
		local visH = math.max(2, math.floor(self.AnimatedFullHeight * e + 0.5))
		outer.Size = UDim2.fromOffset(self.Width + 2, visH + 2)
		box.BackgroundColor3 = th.ControlBg
		box.BackgroundTransparency = 1 - e
		innerStroke.Color = th.ControlStroke
		innerStroke.Transparency = 1 - e
		outerStroke.Color = th.ControlOuter
		outerStroke.Transparency = 1 - e
		scroll.ScrollBarImageColor3 = th.Accent
		scroll.ScrollBarImageTransparency = 1 - e

		if searchWrap.Visible then
			local sFocused = searchBox:IsFocused()
			local hasTxt = #(searchBox.Text or "") > 0
			searchWrap.BackgroundColor3 = th.GroupBg
			searchWrap.BackgroundTransparency = 1 - e
			searchStroke.Color = sFocused and th.Accent or th.ControlStroke
			searchStroke.Transparency = 1 - e
			searchIcon:SetColor((sFocused or hasTxt) and th.Accent or th.TextMuted)
			searchIcon:SetTransparency(1 - e)
			searchBox.TextColor3 = th.TextPrimary
			searchBox.TextTransparency = 1 - e
			clearSearchIcon:SetColor(th.TextLabel)
			clearSearchIcon:SetTransparency(1 - e)
			searchDivider.BackgroundColor3 = th.GroupStrokeInner
			searchDivider.BackgroundTransparency = 1 - e
		end

		if emptySearchLbl.Visible then
			emptySearchLbl.TextColor3 = th.TextMuted
			emptySearchLbl.TextTransparency = 1 - e
		end

		if self.AnchorFrame and self.AnchorFrame.Parent then
			local sc = math.max(0.25, windowCtx.CurrentScale)
			local rel = (self.AnchorFrame.AbsolutePosition - windowCtx.Root.AbsolutePosition) / sc
			local anchorH = self.AnchorFrame.AbsoluteSize.Y / sc
			local preferUp = (self.TargetDD and self.TargetDD.PreferUpward == true)
				or ((rel.Y + anchorH + 6 + self.FullHeight > 552) and (rel.Y - self.FullHeight - 6 >= 44))
			self.OpenUpward = preferUp
			if preferUp then
				local slideY = (1 - e) * 7
				outer.Position = UDim2.fromOffset(
					math.floor(rel.X - 1 + 0.5),
					math.floor(rel.Y - visH - 6 + slideY + 0.5)
				)
			else
				local slideY = (1 - e) * -7
				outer.Position = UDim2.fromOffset(
					math.floor(rel.X - 1 + 0.5),
					math.floor(rel.Y + anchorH + 6 + slideY + 0.5)
				)
			end
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
					slot.Mix += (tMix - slot.Mix) * math.min(1, dt * 13)
					slot.SlideMix += (tSlide - slot.SlideMix) * math.min(1, dt * 15)
					local m = SmoothStep(slot.Mix)
					local sm = SmoothStep(slot.SlideMix)

					if m > 0.01 then
						slot.Btn.BackgroundColor3 = sel and th.ControlHover or LerpColor(th.ControlBg, th.ControlHover, 0.65)
						slot.Btn.BackgroundTransparency = 1 - (e * m)
					else
						slot.Btn.BackgroundTransparency = 1
					end

					slot.Check.Instance.Visible = sm > 0.02
					slot.Check:SetColor(th.Accent)
					slot.Check:SetTransparency(1 - (e * sm))

					local offsetX = math.floor(10 + 20 * sm + 0.5)
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
		IsPopup = true,
		Card = card,
		AnchorBtn = anchorGearBtn,
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
			if tick() - (kp.LastCaptureTick or 0) < 0.18 then
				SyncKeyUI()
				return
			end
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

	local gearFadeTracker = { Active = false, Cache = {} }

	function popupObj:Toggle()
		if self.Open then
			self:Close()
		else
			windowCtx:CloseFloatingPopups("gear", self)
			self.Open = true
		end
	end

	function popupObj:Close()
		self.Open = false
		if windowCtx.DropdownPopup and windowCtx.DropdownPopup.ParentPopup == self then
			windowCtx.DropdownPopup:Close()
		end
		if windowCtx.ColorPickerPopup and windowCtx.ColorPickerPopup.ParentPopup == self then
			windowCtx.ColorPickerPopup:Close()
		end
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
			local vpW = Library.ScreenGui.AbsoluteSize.X
			if vpW > 0 and (windowCtx.Root.AbsolutePosition.X + (px + pWidth + 8) * sc) > vpW then
				px = rel.X - pWidth - 10
			end
			local py = math.clamp(rel.Y - 8, 48, math.max(48, 554 - card.Size.Y.Offset))
			local slideY = (1 - e) * -8
			card.Position = UDim2.fromOffset(math.floor(px + 0.5), math.floor(py + slideY + 0.5))
		end
	end)

	Library:BindPostStep(function()
		if card.Visible then
			local e = SmoothStep(popupObj.Fade)
			ApplySubtreeAlpha(body, gearFadeTracker, e)
		end
	end)

	table.insert(windowCtx.GearPopups, popupObj)
	return popupObj
end

AttachWidgetFactory = function(target, windowCtx)
	local padX = target.PadX or 13
	local baseZ = target.BaseZ or 10
	local parentPopup = target.IsPopup and target or nil

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
			Library:AddTooltip(gearBtn, "Open sub-settings")

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
				windowCtx.ColorPickerPopup:ToggleFor(cp, swBtn, parentPopup)
			end)
			Library:AddTooltip(swBtn, (cpInfo and cpInfo.Title) and ("Color: " .. tostring(cpInfo.Title)) or "Edit color")

			table.insert(swatches, swBtn)
			table.insert(self.Addons, cp)
			RepositionAccessories()
			return self
		end

		function toggleObj:AddTooltip(tipStr)
			Library:AddTooltip(hitBtn, tipStr)
			return self
		end
		if type(info.Tooltip) == "string" and info.Tooltip ~= "" then
			toggleObj:AddTooltip(info.Tooltip)
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
				local gm = SmoothStep(gearMix)
				gearIcon:SetColor(LerpColor(Color3.fromRGB(118, 118, 124), th.TextBright, gm))
				gearIcon.Instance.Rotation = 90 * gm
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

		local valLbl = Instance.new("TextButton")
		valLbl.BackgroundTransparency = 1
		valLbl.Position = UDim2.new(1, -(padX + 82), 0, 2)
		valLbl.Size = UDim2.fromOffset(80, 18)
		valLbl.FontFace = FontBold
		valLbl.TextSize = 13
		valLbl.TextXAlignment = Enum.TextXAlignment.Right
		valLbl.TextColor3 = Library.Theme.TextSubtle
		valLbl.Text = FormatVal(startVal)
		valLbl.AutoButtonColor = false
		valLbl.Visible = not compact
		valLbl.ZIndex = baseZ + 2
		valLbl.Parent = row

		local valEdit = Instance.new("TextBox")
		valEdit.Position = UDim2.new(1, -(padX + 60), 0, 1)
		valEdit.Size = UDim2.fromOffset(58, 19)
		valEdit.BackgroundColor3 = Library.Theme.ControlBg
		valEdit.BorderSizePixel = 0
		valEdit.FontFace = FontBold
		valEdit.TextSize = 12
		valEdit.TextXAlignment = Enum.TextXAlignment.Right
		valEdit.TextColor3 = Library.Theme.TextBright
		valEdit.ClearTextOnFocus = true
		valEdit.Visible = false
		valEdit.ZIndex = baseZ + 6
		valEdit.Parent = row
		Instance.new("UICorner", valEdit).CornerRadius = UDim.new(0, 2)
		local valEditStroke = Instance.new("UIStroke")
		valEditStroke.Color = Library.Theme.Accent
		valEditStroke.Thickness = 1
		valEditStroke.Parent = valEdit

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
		local sliderHovered = false
		local hoverMix = 0
		local lastClickTick = 0

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

		function sliderObj:AddTooltip(tipStr)
			Library:AddTooltip(hitArea, tipStr)
			return self
		end
		if type(info.Tooltip) == "string" and info.Tooltip ~= "" then
			sliderObj:AddTooltip(info.Tooltip)
		end

		valLbl.MouseButton1Click:Connect(function()
			valEdit.Text = tostring(sliderObj.Value)
			valLbl.Visible = false
			valEdit.Visible = true
			valEdit:CaptureFocus()
		end)
		valEdit.FocusLost:Connect(function()
			local num = tonumber((string.gsub(valEdit.Text or "", "[^%d%.%-]", "")))
			valEdit.Visible = false
			valLbl.Visible = not compact
			if num ~= nil then
				sliderObj:SetValue(num)
			end
		end)

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

		hitArea.MouseEnter:Connect(function() sliderHovered = true end)
		hitArea.MouseLeave:Connect(function() sliderHovered = false end)
		hitArea.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
				local now = tick()
				if now - lastClickTick < 0.26 then
					lastClickTick = 0
					dragging = false
					sliderObj:SetValue(startVal)
					return
				end
				lastClickTick = now
				dragging = true
				UpdateFromMouseX(inp.Position.X)
			end
		end)
		Library:GiveSignal(UserInputService.InputChanged:Connect(function(inp)
			if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
				UpdateFromMouseX(inp.Position.X)
			end
		end))
		Library:GiveSignal(UserInputService.InputEnded:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
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
			hoverMix += (((sliderHovered or dragging) and 1 or 0) - hoverMix) * math.min(1, dt * 14)
			local hm = SmoothStep(hoverMix)
			local kd = Lerp(13, 15.5, hm)
			fill.Size = UDim2.new(displayRatio, 0, 1, 0)
			knob.Position = UDim2.new(displayRatio, 0, 0.5, 0)
			knob.Size = UDim2.fromOffset(kd, kd)
			label.TextColor3 = th.TextLabel
			valLbl.TextColor3 = LerpColor(th.TextSubtle, th.TextPrimary, hm)
			track.BackgroundColor3 = th.ControlBg
			knob.BackgroundColor3 = LerpColor(th.SliderKnob, Color3.fromRGB(68, 68, 74), hm)
			fillGrad.Color = ColorSequence.new(th.AccentBright, th.AccentGradEnd)
			valEdit.BackgroundColor3 = th.ControlBg
			valEdit.TextColor3 = th.TextBright
			valEditStroke.Color = th.Accent
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
		local lastTargetBtn = mainBtn
		local btnObj = {
			Button = mainBtn,
			Label = mainLbl,
			Func = func,
		}

		function btnObj:AddTooltip(tipStr)
			Library:AddTooltip(lastTargetBtn or mainBtn, tipStr)
			return self
		end
		if type(info.Tooltip) == "string" and info.Tooltip ~= "" then
			Library:AddTooltip(mainBtn, info.Tooltip)
		end

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
			lastTargetBtn = subBtn
			if type(sInfo.Tooltip) == "string" and sInfo.Tooltip ~= "" then
				Library:AddTooltip(subBtn, sInfo.Tooltip)
			end
			return self
		end

		return btnObj
	end

	-- ------------------------------------------------------------------------
	-- 4. DROPDOWN / MULTI-DROPDOWN (sigma::combobox + searchable floating list)
	-- ------------------------------------------------------------------------
	function target:AddDropdown(idx, info)
		info = info or {}
		local values = info.Values or {}
		if info.SpecialType == "Player" then
			values = GetPlayersString()
			info.AllowNull = true
		elseif info.SpecialType == "Team" then
			values = GetTeamsString()
			info.AllowNull = true
		end
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
			SpecialType = info.SpecialType,
			Searchable = (info.Searchable ~= false),
			SearchPlaceholder = info.SearchPlaceholder,
			Value = initVal,
			BoxWidth = boxW,
			Callback = info.Callback,
			ChangedCallbacks = {},
		}

		if info.SpecialType == "Player" or info.SpecialType == "Team" then
			table.insert(Library.SpecialDropdowns, ddObj)
		end

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

		function ddObj:AddTooltip(tipStr)
			Library:AddTooltip(hit, tipStr)
			return self
		end
		if type(info.Tooltip) == "string" and info.Tooltip ~= "" then
			ddObj:AddTooltip(info.Tooltip)
		end

		local comboHover = false
		local hovMix = 0
		local openMix = 0
		hit.MouseEnter:Connect(function() comboHover = true end)
		hit.MouseLeave:Connect(function() comboHover = false end)

		hit.MouseButton1Click:Connect(function()
			ddObj.BoxWidth = math.floor(comboBox.AbsoluteSize.X / math.max(0.25, windowCtx.CurrentScale) + 0.5)
			windowCtx.DropdownPopup:ToggleFor(ddObj, comboBox, parentPopup)
		end)

		ddObj:Display()

		Library:BindStep(function(dt)
			if not row.Parent then
				return
			end
			local th = Library.Theme
			if titleLbl then
				titleLbl.TextColor3 = th.TextPrimary
			end
			local isOpen = (windowCtx.DropdownPopup.Open and windowCtx.DropdownPopup.TargetDD == ddObj)
			hovMix += (((comboHover or isOpen) and 1 or 0) - hovMix) * math.min(1, dt * 12)
			openMix += ((isOpen and 1 or 0) - openMix) * math.min(1, dt * 13)
			local hm = SmoothStep(hovMix)
			local om = SmoothStep(openMix)

			comboBox.BackgroundColor3 = LerpColor(th.ControlBg, th.ControlHover, hm * 0.65)
			innerStroke.Color = LerpColor(th.ControlStroke, th.Accent, om * 0.85)
			outerStroke.Color = th.ControlOuter
			valText.TextColor3 = LerpColor(th.TextLabel, th.TextBright, om)
			chev.Instance.Rotation = 180 * om
			chev:SetColor(LerpColor(Color3.fromRGB(142, 142, 148), th.Accent, om))
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

		function inpObj:AddTooltip(tipStr)
			Library:AddTooltip(inputFrame, tipStr)
			return self
		end
		if type(info.Tooltip) == "string" and info.Tooltip ~= "" then
			inpObj:AddTooltip(info.Tooltip)
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

		function labelObj:AddTooltip(tipStr)
			Library:AddTooltip(row, tipStr)
			return self
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
				if tick() - (kp.LastCaptureTick or 0) < 0.18 then
					RefreshPill()
					return
				end
				if Library.ActiveKeyCapture == kp then
					Library.ActiveKeyCapture = nil
				else
					kp.SkipFrame = false
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
				windowCtx.ColorPickerPopup:ToggleFor(cp, swBtn, parentPopup)
			end)
			Library:AddTooltip(swBtn, (cpInfo and cpInfo.Title) and ("Color: " .. tostring(cpInfo.Title)) or "Edit color")

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
	-- 8. DEPENDENCY BOX (1:1 Auto Heal / Auto Armor smooth height + alpha reveal!)
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

		local depFadeTracker = { Active = false, Cache = {} }

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
			depBox.Fade += (t - depBox.Fade) * math.min(1, dt * 11.5)
			if math.abs(t - depBox.Fade) < 0.002 then
				depBox.Fade = t
			end
			local e = SmoothStep(depBox.Fade)
			local fullH = list.AbsoluteContentSize.Y + 4
			inner.Size = UDim2.new(1, 0, 0, fullH)
			inner.Position = UDim2.fromOffset(0, math.floor((1 - e) * -10 + 0.5))
			local curH = math.floor(fullH * e + 0.5)
			if curH <= 0 and depFadeTracker.Active then
				ApplySubtreeAlpha(inner, depFadeTracker, 1)
			end
			clipWrap.Visible = curH > 0
			clipWrap.Size = UDim2.new(1, 0, 0, curH)
		end)

		Library:BindPostStep(function()
			if clipWrap.Visible then
				ApplySubtreeAlpha(inner, depFadeTracker, SmoothStep(depBox.Fade))
			end
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
local function EscapeRichText(str)
	local s = tostring(str or "")
	s = string.gsub(s, "&", "&amp;")
	s = string.gsub(s, "<", "&lt;")
	s = string.gsub(s, ">", "&gt;")
	return s
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
	local initBasePos = Vector2.new(math.max(8, startX), math.max(8, startY))

	-- Outer border 1: 708x564, RGB(45,45,45) alpha 120/255, corner 5px
	local root = Instance.new("Frame")
	root.Name = "WindowShell_708x564"
	root.Position = UDim2.fromOffset(initBasePos.X, initBasePos.Y)
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

	local approxBrandW = CalcTextBounds(titleWhiteStr .. titleAccentStr, FontBold, 14).X
	local brandRich = Instance.new("TextLabel")
	brandRich.Name = "BrandTitle"
	brandRich.BackgroundTransparency = 1
	brandRich.AnchorPoint = Vector2.new(1, 0)
	brandRich.Position = UDim2.fromOffset(105, 18)
	brandRich.AutomaticSize = Enum.AutomaticSize.X
	brandRich.Size = UDim2.fromOffset(0, 16)
	brandRich.FontFace = FontBold
	brandRich.TextSize = 14
	brandRich.RichText = true
	brandRich.TextXAlignment = Enum.TextXAlignment.Right
	brandRich.TextColor3 = self.Theme.TextPrimary
	brandRich.Text = string.format(
		'%s<font color="#%s">%s</font>',
		EscapeRichText(titleWhiteStr),
		self.Theme.Accent:ToHex(),
		EscapeRichText(titleAccentStr)
	)
	brandRich.ZIndex = 5
	brandRich.Parent = canvas

	local brandLogo = self:CreateIcon(canvas, "logo", 16, self.Theme.Accent, 5)
	brandLogo.Instance.Position = UDim2.fromOffset(math.max(12, 105 - approxBrandW - 22), 18)

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
	pfpFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 34)
	pfpFrame.BorderSizePixel = 0
	pfpFrame.ZIndex = 7
	pfpFrame.Parent = sidebarHolder
	Instance.new("UICorner", pfpFrame).CornerRadius = UDim.new(1, 0)

	local pfpStroke = Instance.new("UIStroke")
	pfpStroke.Color = Color3.fromRGB(48, 48, 56)
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
		BasePos = initBasePos,
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
		BottomPopupCard = nil,
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
		if exceptKind ~= "bottom" and exceptRef ~= "bottom" then
			if self.BottomPopupOpen and self.DropdownPopup.ParentPopup == "bottom" then
				self.DropdownPopup:Close()
			end
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
		windowCtx.BottomPopupCard = bpCard

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
			if (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) and windowCtx.BottomPopupOpen then
				dpiDragging = true
				SnapDPIFromMouse(inp.Position.X)
			end
		end)
		Library:GiveSignal(UserInputService.InputChanged:Connect(function(inp)
			if dpiDragging and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
				SnapDPIFromMouse(inp.Position.X)
			end
		end))
		Library:GiveSignal(UserInputService.InputEnded:Connect(function(inp)
			if dpiDragging and (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
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

		-- Language & Display Mini-Comboboxes (178x30 at y=126 & y=164, wired to animated DropdownPopup)
		local miniCombos = {
			{ Items = { "English", "Polish" } },
			{ Items = { "Primary Display", "Default" } },
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
			cHit.AutoButtonColor = false
			cHit.ZIndex = 315
			cHit.Parent = cBox

			local mcDD = {
				Values = mc.Items,
				Multi = false,
				AllowNull = false,
				Searchable = false,
				PreferUpward = (ci == 2),
				ItemHeight = 25,
				CompactText = true,
				BoxWidth = 178,
				Value = mc.Items[1],
				Display = function(ddSelf)
					cTxt.Text = tostring(ddSelf.Value or mc.Items[1])
				end,
				FireChanged = function() end,
			}

			cHit.MouseButton1Click:Connect(function()
				windowCtx.DropdownPopup:ToggleFor(mcDD, cBox, "bottom")
			end)

			mc.Box = cBox
			mc.In = cIn
			mc.Out = cOut
			mc.Txt = cTxt
			mc.Chev = cChev
			mc.DD = mcDD
			mc.OpenMix = 0
		end

		local bpFade = 0
		local bpFadeTracker = { Active = false, Cache = {} }
		local gearHover = false
		local gearHoverFade = 0
		bottomGearBtn.MouseEnter:Connect(function() gearHover = true end)
		bottomGearBtn.MouseLeave:Connect(function() gearHover = false end)
		Library:AddTooltip(bottomGearBtn, "Interface Settings (Theme, Language, Scale)")
		bottomGearBtn.MouseButton1Click:Connect(function()
			if windowCtx.BottomPopupOpen then
				if windowCtx.DropdownPopup.ParentPopup == "bottom" then
					windowCtx.DropdownPopup:Close()
				end
				windowCtx.BottomPopupOpen = false
			else
				windowCtx:CloseFloatingPopups("bottom", "bottom")
				windowCtx.BottomPopupOpen = true
			end
		end)

		Library:BindStep(function(dt)
			local gTarget = (gearHover or windowCtx.BottomPopupOpen) and 1 or 0
			gearHoverFade += (gTarget - gearHoverFade) * math.min(1, dt * 11)
			local gm = SmoothStep(gearHoverFade)
			bottomGearIcon:SetColor(LerpColor(Library.Theme.TextDim, Library.Theme.TextBright, gm))
			bottomGearIcon.Instance.Rotation = 90 * gm

			local pTarget = windowCtx.BottomPopupOpen and 1 or 0
			bpFade += (pTarget - bpFade) * math.min(1, dt * 11.5)
			if math.abs(pTarget - bpFade) < 0.002 then
				bpFade = pTarget
			end
			local e = SmoothStep(bpFade)
			if e <= 0.005 and bpFadeTracker.Active then
				ApplySubtreeAlpha(bpCard, bpFadeTracker, 1)
			end
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
				local isOpen = (windowCtx.DropdownPopup.Open and windowCtx.DropdownPopup.TargetDD == mc.DD)
				mc.OpenMix += ((isOpen and 1 or 0) - mc.OpenMix) * math.min(1, dt * 13)
				local om = SmoothStep(mc.OpenMix)
				mc.Box.BackgroundColor3 = LerpColor(th.ControlBg, th.ControlHover, om * 0.6)
				mc.In.Color = LerpColor(th.ControlStroke, th.Accent, om * 0.85)
				mc.Out.Color = th.ControlOuter
				mc.Txt.TextColor3 = LerpColor(th.TextLabel, th.TextBright, om)
				mc.Chev:SetColor(th.Accent)
				mc.Chev.Instance.Rotation = 180 * om
			end
		end)

		Library:BindPostStep(function()
			if bpCard.Visible then
				ApplySubtreeAlpha(bpCard, bpFadeTracker, SmoothStep(bpFade))
			end
		end)
	end

	-- Outside click handler to close floating popups cleanly (while preserving parent popups on child dropdown/color interactions)
	Library:GiveSignal(UserInputService.InputBegan:Connect(function(inp)
		if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then
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

		local insideDropdown = windowCtx.DropdownPopup.Open and (
			Inside(windowCtx.DropdownPopup.Card)
			or (windowCtx.DropdownPopup.AnchorFrame and Inside(windowCtx.DropdownPopup.AnchorFrame))
		)
		local insideColorPicker = windowCtx.ColorPickerPopup.Open and (
			Inside(windowCtx.ColorPickerPopup.Card)
			or (windowCtx.ColorPickerPopup.AnchorBtn and Inside(windowCtx.ColorPickerPopup.AnchorBtn))
		)

		if windowCtx.ColorPickerPopup.Open and not insideColorPicker then
			windowCtx.ColorPickerPopup:Close()
		end
		if windowCtx.DropdownPopup.Open and not insideDropdown then
			windowCtx.DropdownPopup:Close()
		end
		if windowCtx.BottomPopupOpen then
			local insideBottomChild = insideDropdown and (windowCtx.DropdownPopup.ParentPopup == "bottom")
			if not Inside(windowCtx.BottomPopupCard) and not Inside(bottomGearBtn) and not insideBottomChild then
				windowCtx.BottomPopupOpen = false
			end
		end
		for _, gp in ipairs(windowCtx.GearPopups) do
			if gp.Open then
				local insideGearChild = (insideDropdown and windowCtx.DropdownPopup.ParentPopup == gp)
					or (insideColorPicker and windowCtx.ColorPickerPopup.ParentPopup == gp)
				if not Inside(gp.Card) and not Inside(gp.AnchorBtn) and not insideGearChild then
					gp:Close()
				end
			end
		end
	end))

	-- Window Dragging (outside contentPanel 66..694, 56..550 and outside modal; synced with BasePos)
	MakeDraggable(
		root,
		root,
		function()
			return windowCtx.CurrentScale
		end,
		function(mousePos3)
			if not windowCtx.TargetVisible or not Library.Toggled then
				return false
			end
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
		end,
		function()
			return windowCtx.BasePos
		end,
		function(newPos)
			windowCtx.BasePos = newPos
		end
	)

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
		Library:AddTooltip(closeBtn, "Close dialog")

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

		local modalFadeTracker = { Active = false, Cache = {} }

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
			modalObj.Fade += (t - modalObj.Fade) * math.min(1, dt * 8.5)
			if math.abs(t - modalObj.Fade) < 0.002 then
				modalObj.Fade = t
			end
			local e = SmoothStep(modalObj.Fade)
			if e <= 0.005 and modalFadeTracker.Active then
				ApplySubtreeAlpha(group, modalFadeTracker, 1)
			end
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

		Library:BindPostStep(function()
			if backdrop.Visible then
				ApplySubtreeAlpha(group, modalFadeTracker, SmoothStep(modalObj.Fade))
			end
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

	local windowFadeTracker = { Active = false, Cache = {} }
	local lastBrandAccentHex = ""

	-- Optional Mobile Floating Toggle Pill (for touch-only executors without hardware keyboard)
	if (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled) or config.ShowMobileToggle == true then
		local mobShell = Instance.new("Frame")
		mobShell.Name = "MobileTogglePill"
		mobShell.Position = UDim2.fromOffset(18, math.max(120, math.floor(vp.Y * 0.45)))
		mobShell.Size = UDim2.fromOffset(104, 34)
		mobShell.BackgroundColor3 = self.Theme.OuterBorder1
		mobShell.BackgroundTransparency = 0.45
		mobShell.BorderSizePixel = 0
		mobShell.ZIndex = 700
		mobShell.Parent = self.ScreenGui
		Instance.new("UICorner", mobShell).CornerRadius = UDim.new(1, 0)

		local mobInner = Instance.new("TextButton")
		mobInner.Position = UDim2.fromOffset(2, 2)
		mobInner.Size = UDim2.new(1, -4, 1, -4)
		mobInner.BackgroundColor3 = self.Theme.Canvas
		mobInner.BorderSizePixel = 0
		mobInner.AutoButtonColor = false
		mobInner.Text = ""
		mobInner.ZIndex = 701
		mobInner.Parent = mobShell
		Instance.new("UICorner", mobInner).CornerRadius = UDim.new(1, 0)

		local mobStroke = Instance.new("UIStroke")
		mobStroke.Color = self.Theme.Accent
		mobStroke.Thickness = 1
		mobStroke.Transparency = 0.35
		mobStroke.Parent = mobInner

		local mobIcon = self:CreateIcon(mobInner, "logo", 14, self.Theme.Accent, 702)
		mobIcon.Instance.Position = UDim2.fromOffset(12, 8)

		local mobTxt = Instance.new("TextLabel")
		mobTxt.BackgroundTransparency = 1
		mobTxt.Position = UDim2.fromOffset(31, 0)
		mobTxt.Size = UDim2.new(1, -38, 1, 0)
		mobTxt.FontFace = FontBold
		mobTxt.TextSize = 12
		mobTxt.RichText = true
		mobTxt.TextXAlignment = Enum.TextXAlignment.Left
		mobTxt.TextColor3 = self.Theme.TextPrimary
		mobTxt.Text = string.format('ech0.<font color="#%s">fun</font>', self.Theme.Accent:ToHex())
		mobTxt.ZIndex = 702
		mobTxt.Parent = mobInner

		local pressPos = Vector2.zero
		mobInner.InputBegan:Connect(function(inp)
			if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
				pressPos = Vector2.new(inp.Position.X, inp.Position.Y)
			end
		end)
		mobInner.MouseButton1Click:Connect(function()
			local cur = UserInputService:GetMouseLocation()
			if (cur - pressPos).Magnitude < 10 then
				Library:Toggle()
			end
		end)
		MakeDraggable(mobInner, mobShell, function() return 1 end, function() return Library.Toggled end)

		Library:BindStep(function()
			if mobShell.Parent then
				local th = Library.Theme
				mobShell.BackgroundColor3 = th.OuterBorder1
				mobInner.BackgroundColor3 = th.Canvas
				mobStroke.Color = Library.Toggled and th.Accent or th.GroupStrokeInner
				mobIcon:SetColor(th.Accent)
				mobTxt.TextColor3 = th.TextPrimary
			end
		end)
	end

	-- Master Window Animation Step (1:1 main.cpp lines 1219-1266 + smooth open/close zoom+glide+fade)
	Library:BindStep(function(dt)
		-- Smooth DPI scale
		windowCtx.CurrentScale += (windowCtx.TargetScale - windowCtx.CurrentScale) * math.min(1, dt * 10)
		if math.abs(windowCtx.TargetScale - windowCtx.CurrentScale) < 0.002 then
			windowCtx.CurrentScale = windowCtx.TargetScale
		end

		-- Smooth Window Open / Close Animation (RightShift / ToggleKeybind)
		local visTarget = windowCtx.TargetVisible and 1 or 0
		windowCtx.WindowFade += (visTarget - windowCtx.WindowFade) * math.min(1, dt * 11.5)
		if math.abs(visTarget - windowCtx.WindowFade) < 0.002 then
			windowCtx.WindowFade = visTarget
		end

		local winAlpha = SmoothStep(windowCtx.WindowFade)
		if winAlpha <= 0.004 then
			if windowFadeTracker.Active then
				ApplySubtreeAlpha(canvas, windowFadeTracker, 1)
			end
			root.Visible = false
			return
		end
		root.Visible = true

		-- Center-compensated zoom (0.945 -> 1.0) + 10px vertical glide
		local zoom = Lerp(0.945, 1.0, winAlpha)
		uiScale.Scale = windowCtx.CurrentScale * zoom
		local dx = (1 - zoom) * 354 * windowCtx.CurrentScale
		local dy = (1 - zoom) * 282 * windowCtx.CurrentScale + (1 - winAlpha) * 10
		root.Position = UDim2.fromOffset(
			math.floor(windowCtx.BasePos.X + dx + 0.5),
			math.floor(windowCtx.BasePos.Y + dy + 0.5)
		)

		local th = Library.Theme
		root.BackgroundColor3 = th.OuterBorder1
		root.BackgroundTransparency = 1 - (0.47 * winAlpha)
		border2.BackgroundColor3 = th.OuterBorder2
		border2.BackgroundTransparency = 1 - (0.47 * winAlpha)
		canvas.BackgroundColor3 = th.Canvas
		canvas.BackgroundTransparency = 1 - winAlpha
		contentPanel.BackgroundColor3 = th.ContentBg
		contentInnerStroke.Color = th.ContentStrokeInner
		contentOuterStroke.Color = th.ContentStrokeOuter
		firstBar.BackgroundColor3 = th.TopDivider
		secondBar.BackgroundColor3 = th.TopDivider
		brandLogo:SetColor(th.Accent)
		brandRich.TextColor3 = th.TextPrimary

		local curAccentHex = th.Accent:ToHex()
		if curAccentHex ~= lastBrandAccentHex then
			lastBrandAccentHex = curAccentHex
			brandRich.Text = string.format(
				'%s<font color="#%s">%s</font>',
				EscapeRichText(titleWhiteStr),
				curAccentHex,
				EscapeRichText(titleAccentStr)
			)
		end
		local liveBrandW = brandRich.AbsoluteSize.X > 4 and (brandRich.AbsoluteSize.X / math.max(0.25, uiScale.Scale)) or approxBrandW
		brandLogo.Instance.Position = UDim2.fromOffset(math.max(12, math.floor(105 - liveBrandW - 22 + 0.5)), 18)

		pfpFrame.BackgroundColor3 = (Library.ThemeName == "Light") and Color3.fromRGB(222, 222, 228) or Color3.fromRGB(28, 28, 34)
		pfpStroke.Color = (Library.ThemeName == "Light") and th.GroupStrokeInner or Color3.fromRGB(48, 48, 56)

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

		-- Subtle 6px vertical page glide synchronized with tab/subtab cross-fade
		if dTab then
			local pageGlideY = math.floor((1 - contentAlpha) * 6 + 0.5)
			if #dTab.SubTabs > 0 then
				local dispSub = dTab.SubTabs[dTab.DisplayedSubIndex]
				if dispSub and dispSub.Page and dispSub.Page.Scroll then
					dispSub.Page.Scroll.Position = UDim2.fromOffset(0, pageGlideY)
				end
			elseif dTab.DirectPage and dTab.DirectPage.Scroll then
				dTab.DirectPage.Scroll.Position = UDim2.fromOffset(0, pageGlideY)
			end
		end

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

	Library:BindPostStep(function()
		if root.Visible then
			ApplySubtreeAlpha(canvas, windowFadeTracker, SmoothStep(windowCtx.WindowFade))
		end
	end)

	return windowCtx
end

GlobalEnv.Library = Library
return Library
