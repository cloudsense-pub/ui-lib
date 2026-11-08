-- Example.lua
-- ech0.fun 1:1 Luau UI Library — Complete Showcase + Watermark + Keybind List + SaveManager
-- Repository: https://github.com/cloudsense-pub/ui-lib
-- Quick Run:  loadstring(game:HttpGet("https://raw.githubusercontent.com/cloudsense-pub/ui-lib/main/Example.lua"))()

--[[
	Usage Boilerplate (LinoriaLib-compatible):
	local repo = "https://raw.githubusercontent.com/cloudsense-pub/ui-lib/main/"
	local Library = loadstring(game:HttpGet(repo .. "Library.lua"))()
	local SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()

	Optional: If your environment lacks getcustomasset(), upload `assets/icon_atlas.png`
	as a Roblox Image and pass `IconAtlas = "rbxassetid://YOUR_IMAGE_ID"` to CreateWindow.
]]

local repo = "https://raw.githubusercontent.com/cloudsense-pub/ui-lib/main/"

local function LoadModule(relPath)
	local ok, remoteSrc = pcall(function()
		return game:HttpGet(repo .. relPath .. "?v=" .. tostring(math.floor(os.time() / 30)))
	end)
	if ok and type(remoteSrc) == "string" and #remoteSrc > 0 then
		return loadstring(remoteSrc)()
	end
	for _, localPath in ipairs({ relPath, "luau/" .. relPath }) do
		if type(loadfile) == "function" and type(isfile) == "function" then
			local fOk, exists = pcall(isfile, localPath)
			if fOk and exists then
				return loadfile(localPath)()
			end
		end
		if type(readfile) == "function" and type(isfile) == "function" then
			local fOk, exists = pcall(isfile, localPath)
			if fOk and exists then
				return loadstring(readfile(localPath))()
			end
		end
	end
	error("Could not load module: " .. tostring(relPath))
end

local Library = LoadModule("Library.lua")
local SaveManager = LoadModule("addons/SaveManager.lua")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local Toggles = Library.Toggles
local Options = Library.Options

-- ============================================================================
-- CREATE MAIN WINDOW (708x564 1:1 ech0.fun Shell)
-- ============================================================================
local Window = Library:CreateWindow({
	Title = "ech0.fun",
	Center = true,
	AutoShow = true,
	MenuKeybind = Enum.KeyCode.RightShift,
	-- IconAtlas = "rbxassetid://0", -- Optional: paste uploaded `assets/icon_atlas.png` ID here if needed
})

-- ============================================================================
-- SIDEBAR TABS (8 main tabs matching main.cpp sidebar_icons & main_tab_labels)
-- ============================================================================
local Tabs = {
	Self = Window:AddTab("Self", "user"),
	Combat = Window:AddTab("Combat", "sword"),
	Visuals = Window:AddTab("Visuals", "eye"),
	Entities = Window:AddTab("Entity List", "list"),
	Vehicle = Window:AddTab("Vehicle", "car"),
	Server = Window:AddTab("Server", "server"),
	Configs = Window:AddTab("Configurations", "folder"),
	Settings = Window:AddTab("Settings", "gear"),
}

-- ============================================================================
-- TAB 1: SELF (Player | Equipment | Teleports | Strafe macro)
-- ============================================================================
do
	local SubPlayer = Tabs.Self:AddSubTab("Player", "user_gear")
	local SubEquip = Tabs.Self:AddSubTab("Equipment", "sword")
	local SubTeleports = Tabs.Self:AddSubTab("Teleports", "crosshair")
	local SubMacro = Tabs.Self:AddSubTab("Strafe macro", "keyboard")

	-- Left Groupbox: Self Options (matches screenshot 1:1)
	local SelfOptions = SubPlayer:AddLeftGroupbox("Self Options", "user")

	SelfOptions:AddToggle("Self_GhostMode", { Text = "Ghost Mode", Default = false })
		:AddKeyPicker("Self_GhostMode_Key", { Default = "X", Mode = "Toggle", Text = "Ghost Mode", SyncToggleState = true })

	SelfOptions:AddToggle("Self_GhostExtended", { Text = "Ghost Mode Extended", Default = false })
		:AddKeyPicker("Self_GhostExtended_Key", { Default = "None", Mode = "Toggle", Text = "Ghost Extended", SyncToggleState = true })

	SelfOptions:AddToggle("Self_Invisible", { Text = "Invisible", Default = false })
		:AddKeyPicker("Self_Invisible_Key", { Default = "None", Mode = "Toggle", Text = "Invisible", SyncToggleState = true })

	SelfOptions:AddToggle("Self_NoRagdoll", { Text = "No RagDoll", Default = true })
		:AddKeyPicker("Self_NoRagdoll_Key", { Default = "None", Mode = "Toggle", Text = "No RagDoll", SyncToggleState = true })

	SelfOptions:AddToggle("Self_Noclip", { Text = "Noclip", Default = false })
		:AddKeyPicker("Self_Noclip_Key", { Default = "V", Mode = "Toggle", Text = "Noclip", SyncToggleState = true })

	SelfOptions:AddToggle("Self_InfStamina", { Text = "Infinite Stamina", Default = true })
		:AddKeyPicker("Self_InfStamina_Key", { Default = "None", Mode = "Toggle", Text = "Inf Stamina", SyncToggleState = true })

	SelfOptions:AddToggle("Self_FastRun", { Text = "FastRun", Default = false })
		:AddKeyPicker("Self_FastRun_Key", { Default = "LeftAlt", Mode = "Hold", Text = "FastRun" })

	SelfOptions:AddToggle("Self_GodMode", { Text = "GodMode", Default = false })
		:AddKeyPicker("Self_GodMode_Key", { Default = "None", Mode = "Toggle", Text = "GodMode", SyncToggleState = true })

	SelfOptions:AddToggle("Self_Freecam", { Text = "Freecam", Default = false })
		:AddKeyPicker("Self_Freecam_Key", { Default = "C", Mode = "Toggle", Text = "Freecam", SyncToggleState = true })

	SelfOptions:AddToggle("Self_TinyPed", { Text = "Tiny Ped", Default = false })
	SelfOptions:AddToggle("Self_AntiHeadshot", { Text = "Anti Headshot", Default = false })
	SelfOptions:AddToggle("Self_InfRoll", { Text = "Infinite Roll", Default = false })
	SelfOptions:AddToggle("Self_CarEntry", { Text = "Car Entry", Default = false })

	-- Bottom-left Groupbox: Self Visuals
	local SelfVis = SubPlayer:AddLeftGroupbox("Visuals", "scan_eye")
	SelfVis:AddToggle("Self_ThirdPerson", { Text = "Third Person", Default = false })
	SelfVis:AddToggle("Self_Crosshair", { Text = "Custom Crosshair", Default = false })
		:AddColorPicker("Self_Crosshair_Col", { Default = Color3.fromRGB(142, 134, 246), Title = "Crosshair Color" })
	SelfVis:AddToggle("Self_FovChanger", { Text = "FOV Override", Default = false })
	SelfVis:AddSlider("Self_FovValue", { Text = "Field of View", Default = 90, Min = 50, Max = 120, Rounding = 0, Suffix = "°" })

	-- Top-right Groupbox: Gameplay (with inline GearPopup sliders & toggles!)
	local Gameplay = SubPlayer:AddRightGroupbox("Gameplay", "grid")

	Gameplay:AddToggle("GP_QuickPeek", { Text = "Quick Peek", Default = false })
		:AddKeyPicker("GP_QuickPeek_Key", { Default = "Q", Mode = "Hold", Text = "Quick Peek" })

	local fakeLagToggle = Gameplay:AddToggle("GP_FakeLag", { Text = "Fake Lag", Default = false })
	local fakeLagPopup = fakeLagToggle:AddGearPopup(236)
	fakeLagPopup:AddKeyPicker("GP_FakeLag_Key", { Default = "None", Mode = "Toggle", Text = "Fake Lag", SyncToggleState = true })
	fakeLagPopup:AddSlider("GP_FakeLag_Delay", { Text = "Lag Delay", Default = 200, Min = 10, Max = 1000, Rounding = 0, Suffix = " ms" })

	Gameplay:AddToggle("GP_Desync", { Text = "Desync", Default = false })
		:AddKeyPicker("GP_Desync_Key", { Default = "None", Mode = "Toggle", Text = "Desync", SyncToggleState = true })

	local reducerToggle = Gameplay:AddToggle("GP_ImpactReducer", { Text = "Impact Reducer", Default = false })
	local reducerPopup = reducerToggle:AddGearPopup(236)
	reducerPopup:AddKeyPicker("GP_ImpactReducer_Key", { Default = "None", Mode = "Toggle", Text = "Impact Reducer" })
	reducerPopup:AddSlider("GP_ImpactReducer_Pct", { Text = "Reduction", Default = 50, Min = 0, Max = 100, Rounding = 0, Suffix = "%" })

	local wheelToggle = Gameplay:AddToggle("GP_WheelAssist", { Text = "Wheel Precision", Default = false })
	local wheelPopup = wheelToggle:AddGearPopup(236)
	wheelPopup:AddKeyPicker("GP_WheelAssist_Key", { Default = "None", Mode = "Hold", Text = "Wheel Precision" })
	wheelPopup:AddToggle("GP_WheelTargetLine", { Text = "Show Target Line", Default = false })
	wheelPopup:AddSlider("GP_WheelDistance", { Text = "Max Distance", Default = 300, Min = 50, Max = 600, Rounding = 0, Suffix = "m" })

	-- Bottom-right Groupbox: Health Options (with smooth expandable DependencyBoxes!)
	local HealthBox = SubPlayer:AddRightGroupbox("Health Options", "heart")

	HealthBox:AddToggle("HP_AutoHeal", { Text = "Auto Heal", Default = false })
	local AutoHealDep = HealthBox:AddDependencyBox()
	AutoHealDep:AddSlider("HP_MinHP", { Text = "Minimum HP", Default = 50, Min = 1, Max = 199, Rounding = 0 })
	AutoHealDep:AddSlider("HP_HealAmount", { Text = "Heal Amount", Default = 100, Min = 10, Max = 200, Rounding = 0 })
	AutoHealDep:AddSlider("HP_HealDelay", { Text = "Heal Delay", Default = 0.10, Min = 0.05, Max = 2.00, Rounding = 2, Suffix = "s" })
	AutoHealDep:SetupDependencies({ { Toggles.HP_AutoHeal, true } })

	HealthBox:AddToggle("HP_AutoArmor", { Text = "Auto Armor", Default = false })
	local AutoArmorDep = HealthBox:AddDependencyBox()
	AutoArmorDep:AddSlider("HP_MinArmor", { Text = "Minimum Armor", Default = 20, Min = 1, Max = 99, Rounding = 0 })
	AutoArmorDep:AddSlider("HP_ArmorAmount", { Text = "Armor Amount", Default = 100, Min = 10, Max = 100, Rounding = 0 })
	AutoArmorDep:AddSlider("HP_ArmorDelay", { Text = "Armor Delay", Default = 0.10, Min = 0.05, Max = 2.00, Rounding = 2, Suffix = "s" })
	AutoArmorDep:SetupDependencies({ { Toggles.HP_AutoArmor, true } })

	HealthBox:AddDivider()

	HealthBox:AddSlider("HP_HealthVal", { Text = "Health", Default = 200.0, Min = 0.0, Max = 200.0, Rounding = 1 })
	HealthBox:AddSlider("HP_ArmorVal", { Text = "Armor", Default = 0.0, Min = 0.0, Max = 100.0, Rounding = 1 })
	HealthBox:AddButton("Set Health", function()
		Library:Notify("Applied Health: " .. tostring(Options.HP_HealthVal.Value), 2.5)
	end):AddTooltip("Apply the selected health value")
	HealthBox:AddButton("Set Armor", function()
		Library:Notify("Applied Armor: " .. tostring(Options.HP_ArmorVal.Value), 2.5)
	end):AddTooltip("Apply the selected armor value")

	-- Subtab 2: Equipment
	local EquipLeft = SubEquip:AddLeftGroupbox("Handling & Tuning", "sliders")
	local noRecoil = EquipLeft:AddToggle("Eq_RecoilCtrl", { Text = "Recoil Control", Default = false })
	local recoilPop = noRecoil:AddGearPopup(236)
	recoilPop:AddSlider("Eq_RecoilX", { Text = "Horizontal", Default = 0, Min = 0, Max = 100, Rounding = 0, Suffix = "%" })
	recoilPop:AddSlider("Eq_RecoilY", { Text = "Vertical", Default = 0, Min = 0, Max = 100, Rounding = 0, Suffix = "%" })

	local spreadCtrl = EquipLeft:AddToggle("Eq_SpreadCtrl", { Text = "Spread Control", Default = false })
	spreadCtrl:AddGearPopup(236):AddSlider("Eq_SpreadPct", { Text = "Spread Factor", Default = 0, Min = 0, Max = 100, Rounding = 0, Suffix = "%" })

	EquipLeft:AddToggle("Eq_FastReload", { Text = "Instant Reload", Default = false })
	EquipLeft:AddToggle("Eq_InfClip", { Text = "Infinite Magazine", Default = false })
	EquipLeft:AddDropdown("Eq_Attachment", {
		Text = "Attachment Preset",
		Values = { "Suppressor", "Extended Clip", "Tactical Grip", "Holographic Sight", "Heavy Barrel" },
		Default = 1,
	})
	EquipLeft:AddSlider("Eq_AmmoCount", { Text = "Reserve Count", Default = 250, Min = 0, Max = 999, Rounding = 0 })
	EquipLeft:AddButton("Apply Reserve", function()
		Library:Notify("Updated reserve to " .. tostring(Options.Eq_AmmoCount.Value), 2.5)
	end):AddTooltip("Update reserve count to slider value")

	local EquipRight = SubEquip:AddRightGroupbox("Loadout Selector", "box")
	EquipRight:AddDropdown("Eq_Category", {
		Text = "Category",
		Values = { "Handguns", "SMGs", "Rifles", "Shotguns", "Snipers", "Heavy", "Utility" },
		Default = 3,
	})
	EquipRight:AddDropdown("Eq_ItemName", {
		Text = "Model",
		Values = { "Carbine Mk2", "Special Carbine", "Bullpup Mk2", "Compact Rifle", "Marksman Mk2" },
		Default = 1,
	})
	EquipRight:AddToggle("Eq_MaxAttachments", { Text = "Equip Full Attachments", Default = true })
	EquipRight:AddToggle("Eq_CustomTint", { Text = "Apply Accent Finish", Default = false })
	EquipRight:AddButton("Equip Selected", function()
		Library:Notify("Equipped " .. tostring(Options.Eq_ItemName.Value), 2.5)
	end):AddTooltip("Equip the selected model and attachment preset")

	-- Subtab 3: Teleports
	local TpLeft = SubTeleports:AddLeftGroupbox("Quick Teleports", "crosshair")
	TpLeft:AddDropdown("Tp_PresetLoc", {
		Text = "Destination",
		Values = { "Waypoint", "Central Plaza", "Airport Terminal", "Harbor Docks", "Mountain Peak", "Observatory", "Sandy Airfield" },
		Default = 1,
	})
	TpLeft:AddButton("Teleport to Destination", function()
		Library:Notify("Teleporting to " .. tostring(Options.Tp_PresetLoc.Value), 2.5)
	end):AddTooltip("Move character to the selected preset destination")
	TpLeft:AddButton("Teleport to Waypoint", function()
		Library:Notify("Teleported to active waypoint", 2.5)
	end):AddTooltip("Move character to your active map waypoint")

	local TpRight = SubTeleports:AddRightGroupbox("Location Manager", "dots")
	TpRight:AddToggle("Tp_ShowSaved", { Text = "Show Saved Location", Default = false })
	TpRight:AddInput("Tp_CustomName", { Text = "Bookmark Name", Placeholder = "Enter location label...", Icon = "tag", Tooltip = "Name for saving your current coordinates" })
	TpRight:AddButton("Save Current Position", function()
		Library:Notify("Saved position bookmark", 2.5)
	end):AddTooltip("Save your current coordinates under Bookmark Name")
	TpRight:AddButton("Delete Selected Location", function()
		Library:Notify("Removed selected bookmark", 2.5)
	end):AddTooltip("Delete the selected saved location")

	-- Subtab 4: Strafe macro
	local MacroLeft = SubMacro:AddLeftGroupbox("Strafe Configuration", "keyboard")
	local macroToggle = MacroLeft:AddToggle("Mac_Enable", { Text = "Enable Strafe Macro", Default = false })
	local macroPop = macroToggle:AddGearPopup(236)
	macroPop:AddKeyPicker("Mac_Enable_Key", { Default = "Z", Mode = "Hold", Text = "Strafe Macro" })
	macroPop:AddToggle("Mac_RequireShift", { Text = "Require Sprint Key", Default = false })

	MacroLeft:AddToggle("Mac_DrawCircle", { Text = "Show Visualizer Ring", Default = false })
		:AddColorPicker("Mac_CircleCol", { Default = Color3.fromRGB(142, 134, 246), Title = "Ring Color" })
	MacroLeft:AddDropdown("Mac_TuningMode", {
		Text = "Timing Profile",
		Values = { "Balanced", "Responsive", "Smooth", "Competitive", "Custom" },
		Default = 1,
	})
	MacroLeft:AddSlider("Mac_Interval", { Text = "Step Interval", Default = 90, Min = 20, Max = 300, Rounding = 0, Suffix = " ms" })
	MacroLeft:AddSlider("Mac_ReleaseGap", { Text = "Release Gap", Default = 0, Min = 0, Max = 80, Rounding = 0, Suffix = " ms" })
	MacroLeft:AddSlider("Mac_Jitter", { Text = "Timing Variance", Default = 4, Min = 0, Max = 40, Rounding = 0, Suffix = " ms" })

	local MacroRight = SubMacro:AddRightGroupbox("Presets & Recording", "tag")
	MacroRight:AddButton("Record Sequence (4 keys)", function()
		Library:Notify("Listening for 4 movement keys...", 2.5)
	end):AddTooltip("Capture a custom 4-key movement sequence")
	MacroRight:AddDropdown("Mac_SequencePreset", {
		Text = "Quick Preset",
		Values = { "W-A-S-D", "D-A-A-W", "A-D-A-D", "D-A-D-A", "W-D-S-A", "D-W-A-S", "W-A-W-D" },
		Default = 1,
	})
	MacroRight:AddButton("Apply Preset", function()
		Library:Notify("Applied sequence: " .. tostring(Options.Mac_SequencePreset.Value), 2.5)
	end):AddTooltip("Load the selected movement preset")
end

-- ============================================================================
-- TAB 2: COMBAT (Lock | Precision | Reaction | Snap | Hitbox + Curve + Modal)
-- ============================================================================
do
	local SubLock = Tabs.Combat:AddSubTab("Lock", "target")
	local SubPrecision = Tabs.Combat:AddSubTab("Precision", "focus")
	local SubReaction = Tabs.Combat:AddSubTab("Reaction", "mouse")
	local SubSnap = Tabs.Combat:AddSubTab("Snap", "at")
	local SubHitbox = Tabs.Combat:AddSubTab("Hitbox", "shield")

	local LockLeft = SubLock:AddLeftGroupbox("Camera Lock", "target")
	LockLeft:AddToggle("Cmb_LockEnable", { Text = "Enable Camera Assist", Default = false })
		:AddKeyPicker("Cmb_LockKey", { Default = "MouseButton2", Mode = "Hold", Text = "Camera Assist" })
	LockLeft:AddToggle("Cmb_DrawFov", { Text = "Draw FOV Circle", Default = true })
		:AddColorPicker("Cmb_FovColor", { Default = Color3.fromRGB(142, 134, 246), Transparency = 0.25, Title = "FOV Circle" })
	LockLeft:AddToggle("Cmb_VisCheck", { Text = "Visible Only", Default = true })
	LockLeft:AddToggle("Cmb_TeamFilter", { Text = "Ignore Teammates", Default = true })
	LockLeft:AddToggle("Cmb_DynamicFov", { Text = "Distance Scaled FOV", Default = false })
	LockLeft:AddDropdown("Cmb_TargetZones", {
		Text = "Target Zones",
		Multi = true,
		Values = { "Head", "Neck", "UpperTorso", "LowerTorso", "Arms", "Legs" },
		Default = { "Head", "UpperTorso" },
	})
	LockLeft:AddDropdown("Cmb_Priority", {
		Text = "Selection Priority",
		Values = { "Crosshair Distance", "World Distance", "Lowest Health" },
		Default = 1,
	})

	local LockRight = SubLock:AddRightGroupbox("Smoothing & Response", "sliders")
	LockRight:AddSlider("Cmb_FovRadius", { Text = "FOV Radius", Default = 180, Min = 15, Max = 500, Rounding = 0, Suffix = " px" })
	LockRight:AddSlider("Cmb_SmoothX", { Text = "Horizontal Smooth", Default = 50, Min = 1, Max = 100, Rounding = 0, Suffix = "%" })
	LockRight:AddSlider("Cmb_SmoothY", { Text = "Vertical Smooth", Default = 50, Min = 1, Max = 100, Rounding = 0, Suffix = "%" })
	LockRight:AddSlider("Cmb_Deadzone", { Text = "Inner Deadzone", Default = 0, Min = 0, Max = 50, Rounding = 1, Suffix = " px" })
	LockRight:AddSlider("Cmb_MaxDist", { Text = "Max Range", Default = 240, Min = 25, Max = 1000, Rounding = 0, Suffix = "m" })
	-- 1:1 ech0.fun 5-point draggable yellow acceleration curve!
	LockRight:AddCurve("Cmb_ResponseCurve", {
		Text = "Acceleration Curve",
		Default = { 0.67, 0.72, 0.50, 0.25, 0.00 },
		Height = 118,
	})

	-- Precision Subtab
	local PrecLeft = SubPrecision:AddLeftGroupbox("Trajectory Redirection", "focus")
	PrecLeft:AddToggle("Cmb_PrecEnable", { Text = "Enable Redirection", Default = false })
		:AddKeyPicker("Cmb_PrecKey", { Default = "None", Mode = "Toggle", Text = "Redirection", SyncToggleState = true })
	PrecLeft:AddToggle("Cmb_PrecFov", { Text = "Show Radius Ring", Default = false })
		:AddColorPicker("Cmb_PrecFovCol", { Default = Color3.fromRGB(235, 204, 104), Title = "Precision Ring" })
	PrecLeft:AddDropdown("Cmb_PrecZones", {
		Text = "Active Bones",
		Multi = true,
		Values = { "Head", "UpperTorso", "LowerTorso" },
		Default = { "Head" },
	})
	local PrecRight = SubPrecision:AddRightGroupbox("Parameters", "sliders")
	PrecRight:AddSlider("Cmb_PrecRadius", { Text = "Radius", Default = 40, Min = 5, Max = 250, Rounding = 0, Suffix = " px" })
	PrecRight:AddSlider("Cmb_PrecAccuracy", { Text = "Hit Probability", Default = 92, Min = 1, Max = 100, Rounding = 0, Suffix = "%" })
	PrecRight:AddSlider("Cmb_PrecDist", { Text = "Max Distance", Default = 200, Min = 20, Max = 800, Rounding = 0, Suffix = "m" })

	-- Reaction Subtab
	local ReactLeft = SubReaction:AddLeftGroupbox("Auto Release", "mouse")
	ReactLeft:AddToggle("Cmb_ReactEnable", { Text = "Enable Auto Release", Default = false })
		:AddKeyPicker("Cmb_ReactKey", { Default = "E", Mode = "Hold", Text = "Auto Release" })
	ReactLeft:AddToggle("Cmb_ReactTeam", { Text = "Filter Allies", Default = true })
	local ReactRight = SubReaction:AddRightGroupbox("Timing", "sliders")
	ReactRight:AddSlider("Cmb_ReactDelay", { Text = "Reaction Time", Default = 35, Min = 0, Max = 300, Rounding = 0, Suffix = " ms" })
	ReactRight:AddSlider("Cmb_ReactInterval", { Text = "Burst Interval", Default = 80, Min = 10, Max = 500, Rounding = 0, Suffix = " ms" })

	-- Snap Subtab
	local SnapLeft = SubSnap:AddLeftGroupbox("Snap Assist", "at")
	SnapLeft:AddToggle("Cmb_SnapEnable", { Text = "Enable Snap", Default = false })
		:AddKeyPicker("Cmb_SnapKey", { Default = "F", Mode = "Hold", Text = "Snap Assist" })
	local SnapRight = SubSnap:AddRightGroupbox("Snap Tuning", "sliders")
	SnapRight:AddSlider("Cmb_SnapFov", { Text = "Snap FOV", Default = 40, Min = 5, Max = 180, Rounding = 0, Suffix = " px" })
	SnapRight:AddSlider("Cmb_SnapSpeed", { Text = "Snap Velocity", Default = 80, Min = 10, Max = 100, Rounding = 0, Suffix = "%" })

	-- Hitbox Subtab + 1:1 Quick Presets Slide-Up Modal (main.cpp lines 9057-9129)
	local HbLeft = SubHitbox:AddLeftGroupbox("Capsule Bounds", "shield")
	HbLeft:AddToggle("Hb_Enable", { Text = "Expand Bounds", Default = false })
	HbLeft:AddToggle("Hb_ShowPreview", { Text = "Visualize Capsule", Default = false })
		:AddColorPicker("Hb_PreviewCol", { Default = Color3.fromRGB(142, 134, 246), Transparency = 0.5, Title = "Bounds Color" })
	HbLeft:AddSlider("Hb_Height", { Text = "Height Scale", Default = 0.13, Min = 0.05, Max = 1.00, Rounding = 2 })
	HbLeft:AddSlider("Hb_Width", { Text = "Width Scale", Default = 0.13, Min = 0.05, Max = 1.00, Rounding = 2 })

	local PresetsModal = Window:CreateModal({
		Title = "Quick presets",
		Icon = "gear",
		Width = 310,
		Height = 268,
	})
	local presetDefs = {
		{ "Default Mode (0.13)", 0.13 },
		{ "Default V2 (0.16)", 0.16 },
		{ "Subtle Mode (0.18)", 0.18 },
		{ "Subtle V2 (0.20)", 0.20 },
		{ "Medium Mode (0.23)", 0.23 },
		{ "Medium V2 (0.35)", 0.35 },
		{ "Wide Mode (0.50)", 0.50 },
		{ "Max Mode (0.80)", 0.80 },
	}
	for i = 1, #presetDefs, 2 do
		local p1 = presetDefs[i]
		local p2 = presetDefs[i + 1]
		PresetsModal:AddButton({
			Text = p1[1],
			Icon = "check",
			Func = function()
				Options.Hb_Height:SetValue(p1[2])
				Options.Hb_Width:SetValue(p1[2])
				PresetsModal:Hide()
				Library:Notify("Applied " .. p1[1], 2.5)
			end,
		}):AddButton({
			Text = p2[1],
			Icon = "check",
			Func = function()
				Options.Hb_Height:SetValue(p2[2])
				Options.Hb_Width:SetValue(p2[2])
				PresetsModal:Hide()
				Library:Notify("Applied " .. p2[1], 2.5)
			end,
		})
	end

	local HbRight = SubHitbox:AddRightGroupbox("Presets", "tag")
	HbRight:AddButton("Open Quick Presets", function()
		PresetsModal:Show()
	end):AddTooltip("Open preset sizing modal")
	HbRight:AddButton("Reset Dimensions", function()
		Options.Hb_Height:SetValue(0.13)
		Options.Hb_Width:SetValue(0.13)
	end):AddTooltip("Restore default height and width (0.13)")
end

-- ============================================================================
-- TAB 3: VISUALS (Players | Vehicles | Objects | World + Color Swatches)
-- ============================================================================
do
	local SubVPlayers = Tabs.Visuals:AddSubTab("Players", "user")
	local SubVVehicles = Tabs.Visuals:AddSubTab("Vehicles", "car")
	local SubVObjects = Tabs.Visuals:AddSubTab("Objects", "box")
	local SubVWorld = Tabs.Visuals:AddSubTab("World", "globe")

	local VP_Left = SubVPlayers:AddLeftGroupbox("Player Overlays", "eye")

	local boxToggle = VP_Left:AddToggle("Vis_Box", { Text = "Bounding Box", Default = true })
		:AddColorPicker("Vis_BoxCol", { Default = Color3.fromRGB(142, 134, 246), Title = "Box Color" })
	local boxPop = boxToggle:AddGearPopup(236)
	boxPop:AddDropdown("Vis_BoxStyle", { Text = "Corner Style", Values = { "Full Rect", "Cornered", "3D Box" }, Default = 2 })
	boxPop:AddSlider("Vis_BoxThick", { Text = "Thickness", Default = 1.5, Min = 1.0, Max = 4.0, Rounding = 1, Suffix = " px" })

	VP_Left:AddToggle("Vis_Skeleton", { Text = "Skeleton Rig", Default = false })
		:AddColorPicker("Vis_SkeletonCol", { Default = Color3.fromRGB(235, 235, 240), Title = "Skeleton Color" })
	VP_Left:AddToggle("Vis_NameTag", { Text = "Display Name", Default = true })
		:AddColorPicker("Vis_NameCol", { Default = Color3.fromRGB(255, 255, 255), Title = "Name Color" })
	VP_Left:AddToggle("Vis_HealthBar", { Text = "Health Bar", Default = true })
	VP_Left:AddToggle("Vis_ArmorBar", { Text = "Armor Bar", Default = false })
	VP_Left:AddToggle("Vis_Distance", { Text = "Distance Tag", Default = true })
	VP_Left:AddToggle("Vis_Highlight", { Text = "Chams Highlight", Default = false })
		:AddColorPicker("Vis_HighlightFill", { Default = Color3.fromRGB(142, 134, 246), Transparency = 0.55, Title = "Fill Color" })
		:AddColorPicker("Vis_HighlightOut", { Default = Color3.fromRGB(255, 255, 255), Transparency = 0.1, Title = "Outline Color" })
	VP_Left:AddToggle("Vis_Offscreen", { Text = "Offscreen Arrows", Default = false })
		:AddColorPicker("Vis_OffscreenCol", { Default = Color3.fromRGB(142, 134, 246), Title = "Arrow Color" })

	local VP_Right = SubVPlayers:AddRightGroupbox("Filter & Range", "sliders")
	VP_Right:AddToggle("Vis_ShowSelf", { Text = "Include Local Player", Default = false })
	VP_Right:AddToggle("Vis_ShowTeam", { Text = "Include Teammates", Default = false })
	VP_Right:AddToggle("Vis_VisibleCheck", { Text = "Highlight Visible", Default = true })
	VP_Right:AddSlider("Vis_MaxDist", { Text = "Render Distance", Default = 250, Min = 25, Max = 1500, Rounding = 0, Suffix = "m" })
	VP_Right:AddSlider("Vis_TextSize", { Text = "Label Scale", Default = 13, Min = 10, Max = 18, Rounding = 0, Suffix = " px" })

	-- Vehicles Visuals
	local VV_Left = SubVVehicles:AddLeftGroupbox("Vehicle Overlays", "car")
	VV_Left:AddToggle("Vis_VehBox", { Text = "Vehicle 3D Box", Default = false })
		:AddColorPicker("Vis_VehBoxCol", { Default = Color3.fromRGB(142, 134, 246), Title = "Vehicle Box" })
	VV_Left:AddToggle("Vis_VehName", { Text = "Model Name", Default = true })
	VV_Left:AddToggle("Vis_VehDist", { Text = "Vehicle Distance", Default = true })
	VV_Left:AddSlider("Vis_VehMaxDist", { Text = "Max Vehicle Range", Default = 400, Min = 50, Max = 2000, Rounding = 0, Suffix = "m" })

	-- Objects Visuals + "Add Object" Modal (main.cpp lines 8988-9053)
	local VO_Left = SubVObjects:AddLeftGroupbox("Object Overlays", "box")
	VO_Left:AddToggle("Vis_ObjEnable", { Text = "Enable Object Labels", Default = false })
		:AddColorPicker("Vis_ObjCol", { Default = Color3.fromRGB(108, 224, 146), Title = "Object Color" })
	VO_Left:AddSlider("Vis_ObjDist", { Text = "Object Distance", Default = 200, Min = 10, Max = 1000, Rounding = 0, Suffix = "m" })

	local trackedObjects = { "LootCrate_Tier3", "SupplyDrop_01", "KeycardTerminal" }
	local VO_Right = SubVObjects:AddRightGroupbox("Tracked Objects", "list")
	local ObjList = VO_Right:AddListBox("Vis_TrackedObjList", {
		Values = trackedObjects,
		Height = 148,
		SearchPlaceholder = "Search tracked objects...",
	})

	local AddObjModal = Window:CreateModal({
		Title = "Add Object",
		Icon = "plus",
		Width = 260,
		Height = 206,
	})
	local objHashInp = AddObjModal:AddInput("Modal_ObjHash", { Compact = true, Icon = "tag", Placeholder = "Identifier / Hash" })
	local objNameInp = AddObjModal:AddInput("Modal_ObjName", { Compact = true, Icon = "tag", Placeholder = "Display Name" })
	AddObjModal:AddButton({
		Text = "Add",
		Icon = "check",
		Func = function()
			local label = objNameInp.Value ~= "" and objNameInp.Value or objHashInp.Value
			if label ~= "" then
				table.insert(trackedObjects, label)
				ObjList:SetValues(trackedObjects)
				objHashInp:SetValue("")
				objNameInp:SetValue("")
				AddObjModal:Hide()
				Library:Notify("Added tracked object: " .. label, 2.5)
			end
		end,
	})

	VO_Right:AddButton("Add Object", function()
		AddObjModal:Show()
	end):AddTooltip("Add a new world object to track"):AddButton("Remove", function()
		local cur = Options.Vis_TrackedObjList.Value
		local idx = table.find(trackedObjects, cur)
		if idx then
			table.remove(trackedObjects, idx)
			ObjList:SetValues(trackedObjects)
		end
	end):AddTooltip("Remove the selected object from the tracked list")

	-- World Visuals
	local VW_Left = SubVWorld:AddLeftGroupbox("World & Trails", "globe")
	local tracerToggle = VW_Left:AddToggle("Vis_Tracers", { Text = "Beam Trails", Default = false })
		:AddColorPicker("Vis_TracerCol", { Default = Color3.fromRGB(142, 134, 246), Title = "Trail Color" })
	local tracerPop = tracerToggle:AddGearPopup(236)
	tracerPop:AddSlider("Vis_TracerLife", { Text = "Duration", Default = 3.0, Min = 0.5, Max = 10.0, Rounding = 1, Suffix = "s" })
	tracerPop:AddSlider("Vis_TracerWidth", { Text = "Width", Default = 1.5, Min = 0.5, Max = 5.0, Rounding = 1 })

	VW_Left:AddToggle("Vis_HitMarker", { Text = "Impact Marker", Default = true })
		:AddColorPicker("Vis_HitMarkerCol", { Default = Color3.fromRGB(255, 255, 255), Title = "Marker Color" })
	VW_Left:AddToggle("Vis_CustomAmbience", { Text = "World Ambience", Default = false })
		:AddColorPicker("Vis_AmbienceCol", { Default = Color3.fromRGB(98, 92, 186), Title = "Ambience Tint" })
	VW_Left:AddSlider("Vis_ClockTime", { Text = "Time of Day", Default = 14.0, Min = 0.0, Max = 24.0, Rounding = 1, Suffix = "h" })
end

-- ============================================================================
-- TAB 4: ENTITY LIST (Live Roblox Players List + Friend Helper)
-- ============================================================================
do
	local SubEntPlayers = Tabs.Entities:AddSubTab("Players", "users")
	local SubEntVehicles = Tabs.Entities:AddSubTab("Vehicles", "car")
	local SubEntObjects = Tabs.Entities:AddSubTab("Objects", "box")
	local SubEntFriends = Tabs.Entities:AddSubTab("Friend Helper", "users")

	local function GetLivePlayerNames()
		local names = {}
		local statuses = {}
		for _, plr in ipairs(Players:GetPlayers()) do
			table.insert(names, plr.Name)
			statuses[plr.Name] = "online"
		end
		if #names == 0 then
			names = { "Player1", "Player2", "Hasbi_Dev", "EchoUser" }
			for _, n in ipairs(names) do
				statuses[n] = "online"
			end
		end
		return names, statuses
	end

	local pNames, pStats = GetLivePlayerNames()
	local EntLeft = SubEntPlayers:AddLeftGroupbox("Connected Players", "users")
	local PlayerListBox = EntLeft:AddListBox("Ent_SelectedPlayer", {
		Values = pNames,
		Statuses = pStats,
		Height = 250,
		SearchPlaceholder = "Search player...",
	})

	local EntRight = SubEntPlayers:AddRightGroupbox("Player Actions", "sliders")
	EntRight:AddDropdown("Ent_QuickPlayer", {
		Text = "Quick Target (Live)",
		SpecialType = "Player",
		SearchPlaceholder = "Filter server players...",
		Tooltip = "Auto-updating searchable player dropdown",
	})
	EntRight:AddButton("Refresh Player List", function()
		local nn, ns = GetLivePlayerNames()
		PlayerListBox:SetValues(nn, ns)
		Library:Notify("Synced " .. tostring(#nn) .. " players", 2.5)
	end):AddTooltip("Refresh live server player roster")
	EntRight:AddButton("Teleport to Player", function()
		local chosen = Options.Ent_QuickPlayer.Value or Options.Ent_SelectedPlayer.Value
		Library:Notify("Selected target: " .. tostring(chosen), 2.5)
	end):AddTooltip("Move to the currently selected player")
	EntRight:AddToggle("Ent_Spectate", { Text = "Spectate Selected", Default = false })
	EntRight:AddToggle("Ent_Whitelist", { Text = "Mark as Friendly", Default = false })

	SubEntVehicles:AddLeftGroupbox("Nearby Vehicles", "car"):AddListBox("Ent_VehList", {
		Values = { "Elegy Retro", "Sultan RS", "Comet S2", "Kuruma", "Sanchez" },
		Height = 220,
	})
	SubEntObjects:AddLeftGroupbox("Streamed Props", "box"):AddListBox("Ent_ObjList", {
		Values = { "prop_atm_01", "prop_vend_soda_01", "prop_Workbench_02" },
		Height = 220,
	})
	local FriendBox = SubEntFriends:AddLeftGroupbox("Friend Sync", "users")
	FriendBox:AddToggle("Ent_AutoFriendRoblox", { Text = "Auto Whitelist Roblox Friends", Default = true })
	FriendBox:AddToggle("Ent_HighlightFriends", { Text = "Show Friend Beacon", Default = true })
		:AddColorPicker("Ent_FriendCol", { Default = Color3.fromRGB(108, 224, 146), Title = "Friend Color" })
end

-- ============================================================================
-- TAB 5: VEHICLE (Current Vehicle | Vehicle Spawner | Vehicle Mods)
-- ============================================================================
do
	local SubCurVeh = Tabs.Vehicle:AddSubTab("Current Vehicle", "car")
	local SubSpawner = Tabs.Vehicle:AddSubTab("Vehicle Spawner", "car")
	local SubMods = Tabs.Vehicle:AddSubTab("Vehicle Mods", "car")

	local CVLeft = SubCurVeh:AddLeftGroupbox("Vehicle Controls", "car")
	CVLeft:AddToggle("Veh_Invulnerable", { Text = "Reinforced Chassis", Default = false })
	CVLeft:AddToggle("Veh_AutoRepair", { Text = "Auto Repair", Default = false })
	CVLeft:AddToggle("Veh_Seatbelt", { Text = "Lock Seated", Default = true })
	CVLeft:AddSlider("Veh_TorqueMult", { Text = "Torque Multiplier", Default = 1.0, Min = 1.0, Max = 5.0, Rounding = 1, Suffix = "x" })
	CVLeft:AddButton("Repair Vehicle Now", function()
		Library:Notify("Repaired current vehicle", 2.5)
	end):AddTooltip("Restore vehicle chassis and engine condition")

	local SpLeft = SubSpawner:AddLeftGroupbox("Select Model", "car")
	SpLeft:AddListBox("Veh_SpawnModel", {
		Values = { "Krieger", "T20", "Zentorno", "Sultan RS", "Elegy RH8", "Bati 801", "Furia", "nero_custom" },
		Height = 215,
		SearchPlaceholder = "Search vehicle...",
	})
	local SpRight = SubSpawner:AddRightGroupbox("Spawn Settings", "sliders")
	SpRight:AddToggle("Veh_SpawnInside", { Text = "Warp Into Driver Seat", Default = true })
	SpRight:AddToggle("Veh_SpawnMaxed", { Text = "Max Performance Tuning", Default = true })
	SpRight:AddToggle("Veh_ClearPrev", { Text = "Replace Previous Vehicle", Default = false })
	SpRight:AddButton("Spawn Selected Vehicle", function()
		Library:Notify("Spawning " .. tostring(Options.Veh_SpawnModel.Value), 2.5)
	end):AddTooltip("Spawn the selected vehicle model in front of you")

	local ModLeft = SubMods:AddLeftGroupbox("Appearance & Aero", "sliders")
	ModLeft:AddLabel("Primary Paint"):AddColorPicker("Veh_Paint1", { Default = Color3.fromRGB(142, 134, 246), Title = "Primary Paint" })
	ModLeft:AddLabel("Secondary Paint"):AddColorPicker("Veh_Paint2", { Default = Color3.fromRGB(14, 14, 18), Title = "Secondary Paint" })
	ModLeft:AddLabel("Underglow"):AddColorPicker("Veh_NeonCol", { Default = Color3.fromRGB(142, 134, 246), Title = "Underglow" })
	ModLeft:AddSlider("Veh_RideHeight", { Text = "Suspension Offset", Default = 0.0, Min = -0.5, Max = 0.5, Rounding = 2 })
end

-- ============================================================================
-- TAB 6: SERVER (Console | Resources | Inspector)
-- ============================================================================
do
	local SubConsole = Tabs.Server:AddSubTab("Console", "code")
	local SubResources = Tabs.Server:AddSubTab("Resources", "server")
	local SubInspector = Tabs.Server:AddSubTab("Inspector", "folder")

	local EditorGroup = SubConsole:AddFullGroupbox("Luau Script Console", "code")
	local CodeEd = EditorGroup:AddCodeEditor("Srv_LuaCode", {
		Height = 315,
		Default = '-- ech0.fun luau console\nprint("ech0.fun loaded successfully!")\nLibrary:Notify("Executed from console!", 3)',
	})
	EditorGroup:AddButton({
		Text = "Execute Script",
		Icon = "play",
		Tooltip = "Compile and run the Luau code in the editor",
		Func = function()
			local src = CodeEd:GetText()
			if type(loadstring) == "function" then
				local fn, err = loadstring(src)
				if fn then
					task.spawn(fn)
				else
					Library:Notify("Syntax error: " .. tostring(err), 4)
				end
			else
				Library:Notify("loadstring unavailable in this environment", 3)
			end
		end,
	}):AddButton({
		Text = "Clear Editor",
		Icon = "trash",
		Tooltip = "Clear all text from the script console",
		Func = function()
			CodeEd:SetValue("")
		end,
	})

	local resNames = { "core_framework", "ui_hud", "vehicle_shop", "inventory_sync", "weather_cycle" }
	local resStates = {
		["core_framework"] = "started",
		["ui_hud"] = "started",
		["vehicle_shop"] = "started",
		["inventory_sync"] = "started",
		["weather_cycle"] = "stopped",
	}
	local ResLeft = SubResources:AddLeftGroupbox("Active Modules", "server")
	local ResList = ResLeft:AddListBox("Srv_SelectedResource", {
		Values = resNames,
		Statuses = resStates,
		Height = 235,
		SearchPlaceholder = "Filter modules...",
	})

	local ResRight = SubResources:AddRightGroupbox("Module Control", "sliders")
	ResRight:AddButton("Start Module", function()
		local sel = Options.Srv_SelectedResource.Value
		if sel then
			ResList:SetStatus(sel, "started")
			Library:Notify("Started " .. tostring(sel), 2.5)
		end
	end):AddTooltip("Mark selected module as started")
	ResRight:AddButton("Stop Module", function()
		local sel = Options.Srv_SelectedResource.Value
		if sel then
			ResList:SetStatus(sel, "stopped")
			Library:Notify("Stopped " .. tostring(sel), 2.5)
		end
	end):AddTooltip("Stop selected module")

	local InspLeft = SubInspector:AddLeftGroupbox("Hierarchy Filter", "folder")
	InspLeft:AddInput("Srv_FilterQuery", { Text = "Path Filter", Placeholder = "ReplicatedStorage...", Icon = "search", Tooltip = "Filter instance hierarchy by path" })
	InspLeft:AddButton("Scan Scripts", function()
		Library:Notify("Scanned workspace hierarchy", 2.5)
	end):AddTooltip("Scan matching scripts in the hierarchy")
end

-- ============================================================================
-- TAB 7: CONFIGURATIONS (1:1 ech0.fun 3-Column Card Grid + Slide-Up Modal!)
-- ============================================================================
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind", "CustomAtlasInput" })
SaveManager:SetFolder("ech0fun_configs")
SaveManager:BuildConfigTab(Tabs.Configs)

-- ============================================================================
-- TAB 8: SETTINGS (Watermark, Keybind List, Menu Keybind, Atlas ID, Unload)
-- ============================================================================
do
	local GeneralGroup = Tabs.Settings:AddLeftGroupbox("General & Overlay", "gear")

	GeneralGroup:AddToggle("Set_Watermark", {
		Text = "Show Watermark",
		Default = true,
		Tooltip = "Toggle the top-left telemetry bar",
		Callback = function(val)
			Library:SetWatermarkVisibility(val)
		end,
	})

	GeneralGroup:AddToggle("Set_KeybindList", {
		Text = "Show Keybind List",
		Default = true,
		Tooltip = "Toggle the live active keybinds panel",
		Callback = function(val)
			Library:SetKeybindListVisibility(val)
		end,
	})

	GeneralGroup:AddToggle("Set_CustomCursor", {
		Text = "Custom Cursor",
		Default = true,
		Tooltip = "Render accent triangle cursor while the menu is open",
		Callback = function(val)
			Library:SetCustomCursor(val)
		end,
	})

	GeneralGroup:AddToggle("Set_Notifications", { Text = "Toast Notifications", Default = true })
	GeneralGroup:AddDivider()

	GeneralGroup:AddLabel("Menu Toggle Key"):AddKeyPicker("MenuKeybind", {
		Default = "RightShift",
		NoUI = true,
		Text = "Menu Keybind",
	})
	Library.ToggleKeybind = Options.MenuKeybind

	GeneralGroup:AddButton("Unload Interface", function()
		Library:Unload()
	end):AddTooltip("Disconnect all signals, restore cursor, and remove the UI")

	local AssetGroup = Tabs.Settings:AddRightGroupbox("Assets & Theme", "sliders")
	AssetGroup:AddDropdown("Set_ThemeMode", {
		Text = "Color Scheme",
		Values = { "Dark", "Light" },
		Default = 1,
		Tooltip = "Switch between Dark and Light color palettes",
		Callback = function(mode)
			Library:SetTheme(mode)
		end,
	})
	AssetGroup:AddInput("CustomAtlasInput", {
		Text = "Uploaded Icon Atlas ID",
		Placeholder = "rbxassetid://...",
		Icon = "tag",
		Finished = true,
		Tooltip = "Optional rbxassetid:// override for assets/icon_atlas.png",
	})
	AssetGroup:AddButton("Apply Uploaded Atlas", function()
		local raw = tostring(Options.CustomAtlasInput.Value or "")
		if raw ~= "" then
			if string.match(raw, "^%d+$") then
				raw = "rbxassetid://" .. raw
			end
			Library:SetIconAtlas(raw)
			Library:Notify("Applied custom icon atlas: " .. raw, 3)
		end
	end):AddTooltip("Apply the custom rbxassetid:// sprite sheet to all icons")
end

-- ============================================================================
-- INITIALIZE WATERMARK, KEYBIND LIST & LIVE TELEMETRY UPDATER
-- ============================================================================
Library:SetWatermarkVisibility(true)
Library:SetKeybindListVisibility(true)

local FrameTimer = tick()
local FrameCounter = 0
local CurrentFPS = 60

Library:GiveSignal(RunService.RenderStepped:Connect(function()
	FrameCounter += 1
	if (tick() - FrameTimer) >= 0.5 then
		CurrentFPS = math.floor(FrameCounter / (tick() - FrameTimer) + 0.5)
		FrameTimer = tick()
		FrameCounter = 0
	end

	if Library.WatermarkEnabled then
		local pingMs = 0
		pcall(function()
			pingMs = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue() + 0.5)
		end)
		local lp = Players.LocalPlayer
		local uname = (lp and lp.Name) or "Guest"
		Library:SetWatermark(string.format(
			"ech0.fun | %s | %d fps | %d ms | %s",
			uname,
			CurrentFPS,
			pingMs,
			os.date("%H:%M:%S")
		))
	end
end))

SaveManager:LoadAutoloadConfig()
Library:Notify("ech0.fun UI loaded — press RightShift to toggle", 4)
