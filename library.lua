-- EchoUI: a compact, animated Luau UI library inspired by the supplied ech0.fun menu.
-- This module only implements presentation, input widgets, and configuration storage.

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local EchoUI = {}
EchoUI.__index = EchoUI

local THEME = {
    Backdrop = Color3.fromRGB(45, 45, 45),
    Window = Color3.fromRGB(6, 6, 6),
    Surface = Color3.fromRGB(14, 14, 14),
    Raised = Color3.fromRGB(19, 19, 21),
    Hover = Color3.fromRGB(27, 27, 30),
    Border = Color3.fromRGB(34, 34, 37),
    Text = Color3.fromRGB(235, 235, 235),
    Muted = Color3.fromRGB(142, 142, 150),
    Faint = Color3.fromRGB(88, 88, 96),
    Accent = Color3.fromRGB(142, 134, 246),
    AccentSoft = Color3.fromRGB(62, 57, 104),
    White = Color3.fromRGB(255, 255, 255),
    Black = Color3.fromRGB(0, 0, 0),
}

local TWEEN_FAST = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_MEDIUM = TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local TWEEN_POP = TweenInfo.new(0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local function create(className, properties, parent)
    local object = Instance.new(className)
    for key, value in pairs(properties or {}) do
        object[key] = value
    end
    object.Parent = parent
    return object
end

local function corner(object, radius)
    create("UICorner", { CornerRadius = UDim.new(0, radius or 4) }, object)
end

local function stroke(object, color, transparency, thickness)
    return create("UIStroke", {
        Color = color or THEME.Border,
        Transparency = transparency or 0,
        Thickness = thickness or 1,
    }, object)
end

local function tween(object, info, properties)
    if object and object.Parent then
        local animation = TweenService:Create(object, info, properties)
        animation:Play()
        return animation
    end
end

local function label(parent, text, size, position, color, font, textSize)
    return create("TextLabel", {
        BackgroundTransparency = 1,
        Size = size,
        Position = position,
        Font = font or Enum.Font.Gotham,
        Text = text or "",
        TextColor3 = color or THEME.Text,
        TextSize = textSize or 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextTruncate = Enum.TextTruncate.AtEnd,
        RichText = false,
    }, parent)
end

local function button(parent, text, size, position)
    local result = create("TextButton", {
        AutoButtonColor = false,
        BackgroundColor3 = THEME.Surface,
        BorderSizePixel = 0,
        Size = size,
        Position = position,
        Font = Enum.Font.GothamMedium,
        Text = text or "",
        TextColor3 = THEME.Text,
        TextSize = 11,
        TextTruncate = Enum.TextTruncate.AtEnd,
    }, parent)
    corner(result, 4)
    result.MouseEnter:Connect(function()
        tween(result, TWEEN_FAST, { BackgroundColor3 = THEME.Hover })
    end)
    result.MouseLeave:Connect(function()
        tween(result, TWEEN_FAST, { BackgroundColor3 = THEME.Surface })
    end)
    return result
end

local function cleanName(value)
    local result = tostring(value or "config")
    result = result:gsub("[%c\\/:*?\"<>|]", "_")
    result = result:gsub("^%s+", ""):gsub("%s+$", "")
    if result == "" or result == "." or result == ".." then
        result = "config"
    end
    return result
end

local function shallowEqual(a, b)
    if a == b then
        return true
    end
    if type(a) ~= "table" or type(b) ~= "table" then
        return false
    end
    local count = 0
    for key, value in pairs(a) do
        count += 1
        if b[key] ~= value then
            return false
        end
    end
    for _ in pairs(b) do
        count -= 1
    end
    return count == 0
end

local function attachChanged(control)
    control._changedCallbacks = {}
    function control:OnChanged(callback)
        assert(type(callback) == "function", "OnChanged expects a function")
        local callbacks = self._changedCallbacks
        callbacks[#callbacks + 1] = callback
        local connection = { Connected = true }
        function connection:Disconnect()
            if not self.Connected then
                return
            end
            self.Connected = false
            for index, item in ipairs(callbacks) do
                if item == callback then
                    table.remove(callbacks, index)
                    break
                end
            end
        end
        return connection
    end
    function control:_fireChanged(...)
        if self.Callback then
            self.Callback(...)
        end
        for _, callback in ipairs(self._changedCallbacks) do
            callback(...)
        end
    end
end

local function makePage(host)
    local scroll = create("ScrollingFrame", {
        Active = true,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(),
        Position = UDim2.fromOffset(74, 66),
        ScrollBarImageColor3 = THEME.Accent,
        ScrollBarImageTransparency = 0.25,
        ScrollBarThickness = 2,
        ScrollingDirection = Enum.ScrollingDirection.Y,
        Size = UDim2.new(1, -84, 1, -78),
        Visible = false,
        ZIndex = 2,
    }, host)
    local columns = {}
    for index = 1, 2 do
        local column = create("Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(index == 1 and 0 or 309, 0),
            Size = UDim2.new(0, 293, 1, 0),
        }, scroll)
        local layout = create("UIListLayout", {
            Padding = UDim.new(0, 12),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, column)
        create("UIPadding", {
            PaddingBottom = UDim.new(0, 12),
            PaddingTop = UDim.new(0, 3),
        }, column)
        columns[index] = { Frame = column, Layout = layout }
    end
    local function updateCanvas()
        local height = math.max(columns[1].Layout.AbsoluteContentSize.Y, columns[2].Layout.AbsoluteContentSize.Y)
        scroll.CanvasSize = UDim2.fromOffset(0, height + 12)
    end
    columns[1].Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
    columns[2].Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)
    return { Scroll = scroll, Columns = columns, UpdateCanvas = updateCanvas }
end

local function normalizeDefault(defaultValue, values, multi)
    if multi then
        if type(defaultValue) == "table" then
            local picked = {}
            for _, value in ipairs(defaultValue) do
                picked[value] = true
            end
            return picked
        end
        return {}
    end
    if defaultValue ~= nil then
        return defaultValue
    end
    return values[1]
end

function EchoUI.new(options)
    options = options or {}
    local self = setmetatable({}, EchoUI)
    self.Settings = options
    self.Theme = table.clone(THEME)
    if options.Accent then
        self.Theme.Accent = options.Accent
    end
    self.Flags = {}
    self.Options = {}
    self.Toggles = {}
    self.Controls = {}
    self.Keybinds = {}
    self.Connections = {}
    self.Tabs = {}
    self.Visible = true
    self.Unloaded = false
    self._popup = nil
    self._popupAnchor = nil
    self._capture = nil
    self._dragging = nil
    self._activePage = nil
    self._watermarkEnabled = false
    self._keyListEnabled = false
    self._keyListRows = {}
    self._keyListSignature = nil
    self._notifyStack = {}
    self._title = options.Title or "ech0.fun"

    local player = Players.LocalPlayer
    local parent = options.Parent
    if not parent and player then
        parent = player:WaitForChild("PlayerGui")
    end
    assert(parent, "EchoUI needs a Parent or Players.LocalPlayer.PlayerGui")

    self.Gui = create("ScreenGui", {
        DisplayOrder = options.DisplayOrder or 100,
        IgnoreGuiInset = true,
        Name = options.Name or "EchoUI",
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    }, parent)

    self.Root = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(708, 564),
        Visible = true,
        ZIndex = 1,
    }, self.Gui)
    self.Scale = create("UIScale", { Scale = 1 }, self.Root)
    self.Root.Size = UDim2.fromOffset(690, 548)

    local shadow = create("Frame", {
        BackgroundColor3 = THEME.Black,
        BackgroundTransparency = 0.48,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(4, 6),
        Size = UDim2.fromScale(1, 1),
        ZIndex = 1,
    }, self.Root)
    corner(shadow, 6)

    self.Body = create("Frame", {
        BackgroundColor3 = THEME.Window,
        BorderSizePixel = 0,
        Size = UDim2.fromScale(1, 1),
        ZIndex = 2,
    }, self.Root)
    corner(self.Body, 5)
    stroke(self.Body, Color3.fromRGB(44, 44, 47), 0, 1)

    local inset = create("Frame", {
        BackgroundColor3 = THEME.Backdrop,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(1, 1),
        Size = UDim2.new(1, -2, 1, -2),
        ZIndex = 2,
    }, self.Body)
    corner(inset, 4)

    self.Header = create("Frame", {
        BackgroundColor3 = THEME.Window,
        BorderSizePixel = 0,
        Size = UDim2.new(1, 0, 0, 50),
        ZIndex = 3,
    }, self.Body)
    corner(self.Header, 5)
    local headerMask = create("Frame", {
        BackgroundColor3 = THEME.Window,
        BorderSizePixel = 0,
        Position = UDim2.new(0, 0, 1, -6),
        Size = UDim2.new(1, 0, 0, 6),
        ZIndex = 3,
    }, self.Header)
    local mark = create("Frame", {
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(17, 17),
        Size = UDim2.fromOffset(17, 17),
        ZIndex = 4,
    }, self.Header)
    corner(mark, 5)
    label(mark, "e", UDim2.fromScale(1, 1), UDim2.new(), THEME.White, Enum.Font.GothamBold, 13).TextXAlignment = Enum.TextXAlignment.Center

    local titleWhite = label(self.Header, "ech0.", UDim2.fromOffset(41, 24), UDim2.fromOffset(41, 13), THEME.Text, Enum.Font.GothamBold, 14)
    titleWhite.ZIndex = 4
    local titleAccent = label(self.Header, "fun", UDim2.fromOffset(27, 24), UDim2.fromOffset(79, 13), self.Theme.Accent, Enum.Font.GothamBold, 14)
    titleAccent.ZIndex = 4
    self.TitleAccentLabel = titleAccent
    create("Frame", {
        BackgroundColor3 = Color3.fromRGB(25, 25, 27),
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(112, 14),
        Size = UDim2.fromOffset(1, 22),
        ZIndex = 4,
    }, self.Header)
    self.HeaderTitle = label(self.Header, self._title, UDim2.new(1, -275, 1, 0), UDim2.fromOffset(134, 0), THEME.Text, Enum.Font.GothamMedium, 13)
    self.HeaderTitle.ZIndex = 4
    self.HeaderTitle.Size = UDim2.fromOffset(170, 50)
    self.SubtabHolder = create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(318, 0),
        Size = UDim2.new(1, -332, 1, 0),
        ZIndex = 4,
    }, self.Header)
    local dragGrip = create("TextButton", {
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 50),
        Text = "",
        ZIndex = 3,
    }, self.Header)

    self.Sidebar = create("Frame", {
        BackgroundColor3 = THEME.Window,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 48),
        Size = UDim2.new(0, 68, 1, -48),
        ZIndex = 3,
    }, self.Body)
    local rail = create("Frame", {
        BackgroundColor3 = Color3.fromRGB(22, 22, 24),
        BorderSizePixel = 0,
        Position = UDim2.new(1, -1, 0, 3),
        Size = UDim2.new(0, 1, 1, -12),
        ZIndex = 4,
    }, self.Sidebar)
    local activeRail = create("Frame", {
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(14, 21),
        Size = UDim2.fromOffset(2, 12),
        ZIndex = 5,
    }, self.Sidebar)
    corner(activeRail, 2)
    self.ActiveRail = activeRail
    self.PageHost = create("Frame", {
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.fromScale(1, 1),
        ZIndex = 2,
    }, self.Body)

    self.Watermark = create("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = THEME.Surface,
        BackgroundTransparency = 0.04,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -18, 0, 18),
        Size = UDim2.fromOffset(202, 31),
        Visible = false,
        ZIndex = 30,
    }, self.Gui)
    corner(self.Watermark, 4)
    stroke(self.Watermark, Color3.fromRGB(41, 41, 45), 0, 1)
    create("Frame", {
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(2, 17),
        Position = UDim2.fromOffset(8, 7),
        ZIndex = 31,
    }, self.Watermark)
    self.WatermarkText = label(self.Watermark, "ech0.fun", UDim2.new(1, -20, 1, 0), UDim2.fromOffset(17, 0), THEME.Text, Enum.Font.GothamSemibold, 11)
    self.WatermarkText.ZIndex = 31

    self.KeyList = create("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = THEME.Surface,
        BackgroundTransparency = 0.04,
        BorderSizePixel = 0,
        Position = UDim2.new(1, -18, 0, 57),
        Size = UDim2.fromOffset(202, 31),
        Visible = false,
        ZIndex = 30,
    }, self.Gui)
    corner(self.KeyList, 4)
    stroke(self.KeyList, Color3.fromRGB(41, 41, 45), 0, 1)
    local keyAccent = create("Frame", {
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new(1, -16, 0, 1),
        Position = UDim2.fromOffset(8, 26),
        ZIndex = 31,
    }, self.KeyList)
    self.KeyListTitle = label(self.KeyList, "keybinds", UDim2.new(1, -16, 0, 24), UDim2.fromOffset(8, 1), THEME.Text, Enum.Font.GothamSemibold, 10)
    self.KeyListTitle.ZIndex = 31
    self.KeyListRows = create("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(8, 33),
        Size = UDim2.new(1, -16, 1, -38),
        ZIndex = 31,
    }, self.KeyList)
    self.KeyListLayout = create("UIListLayout", {
        Padding = UDim.new(0, 3),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, self.KeyListRows)

    self:_scaleToViewport()
    tween(self.Root, TWEEN_MEDIUM, { Size = UDim2.fromOffset(708, 564) })
    local camera = workspace.CurrentCamera
    if camera then
        self.Connections[#self.Connections + 1] = camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            self:_scaleToViewport()
        end)
    end

    local draggingWindow = false
    local dragStart = nil
    local rootStart = nil
    dragGrip.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingWindow = true
            dragStart = input.Position
            rootStart = self.Root.Position
        end
    end)
    self.Connections[#self.Connections + 1] = UserInputService.InputChanged:Connect(function(input)
        if draggingWindow and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            self.Root.Position = UDim2.new(rootStart.X.Scale, rootStart.X.Offset + delta.X, rootStart.Y.Scale, rootStart.Y.Offset + delta.Y)
        end
    end)
    self.Connections[#self.Connections + 1] = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            draggingWindow = false
            self._dragging = nil
        end
    end)
    self.Connections[#self.Connections + 1] = UserInputService.InputBegan:Connect(function(input, processed)
        if input.UserInputType == Enum.UserInputType.MouseButton1 and self._popup then
            local point = input.Position
            local popupInside = self._popup and self._popup.AbsolutePosition
                and point.X >= self._popup.AbsolutePosition.X
                and point.X <= self._popup.AbsolutePosition.X + self._popup.AbsoluteSize.X
                and point.Y >= self._popup.AbsolutePosition.Y
                and point.Y <= self._popup.AbsolutePosition.Y + self._popup.AbsoluteSize.Y
            local anchorInside = self._popupAnchor and self._popupAnchor.Parent
                and point.X >= self._popupAnchor.AbsolutePosition.X
                and point.X <= self._popupAnchor.AbsolutePosition.X + self._popupAnchor.AbsoluteSize.X
                and point.Y >= self._popupAnchor.AbsolutePosition.Y
                and point.Y <= self._popupAnchor.AbsolutePosition.Y + self._popupAnchor.AbsoluteSize.Y
            if not popupInside and not anchorInside then
                self:_closePopup()
            end
        end
        if input.KeyCode == (options.ToggleKey or Enum.KeyCode.RightShift) and not processed then
            self:SetVisible(not self.Visible)
        end
    end)
    self.Connections[#self.Connections + 1] = UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and self._dragging then
            self._dragging:Move(input.Position)
        end
    end)
    self.Connections[#self.Connections + 1] = UserInputService.InputBegan:Connect(function(input, processed)
        if processed then
            return
        end
        if self._capture then
            if input.UserInputType ~= Enum.UserInputType.Keyboard then
                return
            end
            local captured = input.KeyCode
            if captured == Enum.KeyCode.Escape then
                captured = Enum.KeyCode.Unknown
            end
            self._capture:SetKey(captured)
            self._capture = nil
            return
        end
        if input.UserInputType ~= Enum.UserInputType.Keyboard then
            return
        end
        for _, keybind in ipairs(self.Keybinds) do
            if keybind.Value ~= Enum.KeyCode.Unknown and keybind.Value == input.KeyCode then
                if keybind.Mode == "Toggle" then
                    keybind.Active = not keybind.Active
                elseif keybind.Mode == "Hold" then
                    keybind.Active = true
                elseif keybind.Mode == "Always" then
                    keybind.Active = true
                end
                keybind:_refresh()
                keybind:_fireChanged(keybind.Active, keybind.Mode)
            end
        end
    end)
    self.Connections[#self.Connections + 1] = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.Keyboard then
            return
        end
        for _, keybind in ipairs(self.Keybinds) do
            if keybind.Mode == "Hold" and keybind.Value == input.KeyCode and keybind.Active then
                keybind.Active = false
                keybind:_refresh()
                keybind:_fireChanged(false, keybind.Mode)
            end
        end
    end)
    self.Connections[#self.Connections + 1] = RunService.RenderStepped:Connect(function(dt)
        if self.Unloaded then
            return
        end
        self:_updateKeyList(dt)
    end)

    if options.Watermark then
        self:AddWatermark(type(options.Watermark) == "string" and options.Watermark or nil)
    end
    if options.KeybindList then
        self:AddKeybindList()
    end
    return self
end

function EchoUI:_scaleToViewport()
    local camera = workspace.CurrentCamera
    if not camera then
        return
    end
    local viewport = camera.ViewportSize
    local fit = math.min(viewport.X / 760, viewport.Y / 610, 1)
    self.Scale.Scale = math.max(0.65, fit)
end

function EchoUI:_makePage()
    return makePage(self.PageHost)
end

function EchoUI:_refreshSubtabs()
    for _, child in ipairs(self.SubtabHolder:GetChildren()) do
        child:Destroy()
    end
    local tab = self.ActiveTab
    if not tab then
        return
    end
    self.HeaderTitle.Text = tab.Name
    if #tab.Subtabs == 0 then
        return
    end
    local cursor = 0
    for index, subtab in ipairs(tab.Subtabs) do
        local width = math.max(62, #subtab.Name * 7 + 24)
        local item = create("TextButton", {
            AutoButtonColor = false,
            BackgroundColor3 = Color3.new(0, 0, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(cursor, 0),
            Size = UDim2.fromOffset(width, 50),
            Text = subtab.Name,
            TextColor3 = index == tab.ActiveSubtab and self.Theme.Accent or THEME.Muted,
            TextSize = 10,
            Font = Enum.Font.GothamMedium,
            ZIndex = 5,
        }, self.SubtabHolder)
        item.MouseEnter:Connect(function()
            if index ~= tab.ActiveSubtab then
                tween(item, TWEEN_FAST, { TextColor3 = THEME.Text })
            end
        end)
        item.MouseLeave:Connect(function()
            if index ~= tab.ActiveSubtab then
                tween(item, TWEEN_FAST, { TextColor3 = THEME.Muted })
            end
        end)
        item.Activated:Connect(function()
            self:_selectSubtab(tab, index)
        end)
        cursor += width + 4
    end
end

function EchoUI:_selectPage(page)
    if self._activePage == page then
        return
    end
    if self._activePage and self._activePage.Scroll then
        self._activePage.Scroll.Visible = false
    end
    self._activePage = page
    if page and page.Scroll then
        page.Scroll.Visible = true
        page.Scroll.Position = UDim2.fromOffset(82, 66)
        tween(page.Scroll, TWEEN_MEDIUM, { Position = UDim2.fromOffset(74, 66) })
    end
end

function EchoUI:_selectSubtab(tab, index)
    if not tab.Subtabs[index] then
        return
    end
    tab.ActiveSubtab = index
    self:_refreshSubtabs()
    self:_selectPage(tab.Subtabs[index].Page)
end

function EchoUI:AddTab(name, icon)
    local index = #self.Tabs + 1
    local tab = {
        Name = name,
        Icon = icon or string.sub(name, 1, 1),
        Index = index,
        Subtabs = {},
        ActiveSubtab = 1,
        Window = self,
        DefaultPage = self:_makePage(),
        CurrentPage = nil,
    }
    tab.CurrentPage = tab.DefaultPage
    tab.SideButton = create("TextButton", {
        AutoButtonColor = false,
        BackgroundColor3 = THEME.Window,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(10, 8 + (index - 1) * 38),
        Size = UDim2.fromOffset(48, 30),
        Text = tab.Icon,
        TextColor3 = THEME.Muted,
        TextSize = 15,
        Font = Enum.Font.GothamMedium,
        ZIndex = 5,
    }, self.Sidebar)
    tab.SideButton.Activated:Connect(function()
        self:SelectTab(tab)
    end)
    tab.SideButton.MouseEnter:Connect(function()
        if self.ActiveTab ~= tab then
            tween(tab.SideButton, TWEEN_FAST, { TextColor3 = THEME.Text })
        end
    end)
    tab.SideButton.MouseLeave:Connect(function()
        if self.ActiveTab ~= tab then
            tween(tab.SideButton, TWEEN_FAST, { TextColor3 = THEME.Muted })
        end
    end)
    self.Tabs[index] = tab
    if not self.ActiveTab then
        self:SelectTab(tab)
    end
    return tab
end

function EchoUI:SelectTab(tabOrName)
    local tab = tabOrName
    if type(tabOrName) == "string" then
        tab = nil
        for _, candidate in ipairs(self.Tabs) do
            if candidate.Name == tabOrName then
                tab = candidate
                break
            end
        end
    end
    if not tab then
        return
    end
    self.ActiveTab = tab
    for _, candidate in ipairs(self.Tabs) do
        local active = candidate == tab
        tween(candidate.SideButton, TWEEN_FAST, {
            TextColor3 = active and self.Theme.Accent or THEME.Muted,
            BackgroundTransparency = active and 0.82 or 1,
        })
    end
    tween(self.ActiveRail, TWEEN_MEDIUM, { Position = UDim2.fromOffset(14, 21 + (tab.Index - 1) * 38) })
    if #tab.Subtabs > 0 then
        tab.CurrentPage = tab.Subtabs[tab.ActiveSubtab].Page
    else
        tab.CurrentPage = tab.DefaultPage
    end
    self:_refreshSubtabs()
    self:_selectPage(tab.CurrentPage)
end

function EchoUI:AddSubTab(name)
    local tab = self
    local page = tab.Window:_makePage()
    local subtab = { Name = name, Page = page, Tab = tab, Index = #tab.Subtabs + 1 }
    tab.Subtabs[#tab.Subtabs + 1] = subtab
    if #tab.Subtabs == 1 then
        tab.DefaultPage.Scroll.Visible = false
        tab.ActiveSubtab = 1
        tab.CurrentPage = page
    end
    if tab.Window.ActiveTab == tab then
        tab.Window:_refreshSubtabs()
        tab.Window:_selectPage(page)
    end
    return subtab
end

function EchoUI:_addGroupbox(page, name, columnIndex)
    local column = page.Columns[columnIndex]
    local box = {
        Name = name,
        Window = self,
        Page = page,
        Height = 44,
        Rows = {},
        LayoutOrder = #column.Frame:GetChildren() + 1,
    }
    box.Frame = create("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = THEME.Surface,
        BorderSizePixel = 0,
        LayoutOrder = box.LayoutOrder,
        Size = UDim2.new(1, 0, 0, 40),
        ZIndex = 3,
    }, column.Frame)
    corner(box.Frame, 4)
    stroke(box.Frame, Color3.fromRGB(26, 26, 29), 0, 1)
    box.Header = create("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 39),
        ZIndex = 4,
    }, box.Frame)
    label(box.Header, name, UDim2.new(1, -30, 1, 0), UDim2.fromOffset(14, -1), Color3.fromRGB(214, 214, 220), Enum.Font.GothamSemibold, 12).ZIndex = 5
    create("Frame", {
        BackgroundColor3 = Color3.fromRGB(34, 34, 37),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 13, 1, -1),
        Size = UDim2.new(1, -26, 0, 1),
        ZIndex = 4,
    }, box.Header)
    box.Content = create("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(9, 43),
        Size = UDim2.new(1, -18, 0, 0),
        ZIndex = 4,
    }, box.Frame)
    box.ContentLayout = create("UIListLayout", {
        Padding = UDim.new(0, 0),
        SortOrder = Enum.SortOrder.LayoutOrder,
    }, box.Content)
    create("UIPadding", {
        PaddingBottom = UDim.new(0, 9),
    }, box.Content)
    box.ContentLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.UpdateCanvas()
    end)
    return box
end

function EchoUI:_newControl(groupbox, name, height, flag, callback, default)
    local row = create("Frame", {
        BackgroundTransparency = 1,
        LayoutOrder = #groupbox.Rows + 1,
        Size = UDim2.new(1, 0, 0, height),
        ZIndex = 5,
    }, groupbox.Content)
    local control = {
        Name = name,
        Flag = flag or (groupbox.Name .. "_" .. name):gsub("%W+", "_"),
        Callback = callback,
        Window = self,
        Groupbox = groupbox,
        Row = row,
        Value = default,
        Height = height,
    }
    attachChanged(control)
    control.Label = label(row, name, UDim2.new(1, -100, 1, 0), UDim2.fromOffset(5, 0), Color3.fromRGB(203, 203, 210), Enum.Font.Gotham, 11)
    control.Label.ZIndex = 6
    function control:_set(value, silent)
        if shallowEqual(self.Value, value) then
            return
        end
        self.Value = value
        self.Window.Flags[self.Flag] = value
        if self.Update then
            self:Update()
        end
        if not silent then
            self:_fireChanged(value)
        end
    end
    function control:SetValue(value)
        self:_set(value, false)
        return self
    end
    function control:GetValue()
        return self.Value
    end
    groupbox.Rows[#groupbox.Rows + 1] = control
    groupbox.Page.UpdateCanvas()
    self.Controls[#self.Controls + 1] = control
    self.Options[control.Flag] = control
    self.Flags[control.Flag] = default
    return control
end

function EchoUI:_makeToggle(groupbox, name, options)
    options = options or {}
    local control = self:_newControl(groupbox, name, 30, options.Flag, options.Callback, options.Default == true)
    control.Type = "Toggle"
    self.Toggles[control.Flag] = control
    self.Options[control.Flag] = nil
    control.Label.Size = UDim2.new(1, -52, 1, 0)
    control.Track = create("Frame", {
        BackgroundColor3 = Color3.fromRGB(45, 45, 48),
        BorderSizePixel = 0,
        Position = UDim2.new(1, -37, 0.5, -7),
        Size = UDim2.fromOffset(27, 14),
        ZIndex = 7,
    }, control.Row)
    corner(control.Track, 7)
    control.Knob = create("Frame", {
        BackgroundColor3 = Color3.fromRGB(185, 185, 191),
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(2, 2),
        Size = UDim2.fromOffset(10, 10),
        ZIndex = 8,
    }, control.Track)
    corner(control.Knob, 6)
    control.Hit = create("TextButton", {
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Text = "",
        ZIndex = 9,
    }, control.Row)
    function control:Update()
        tween(self.Track, TWEEN_FAST, { BackgroundColor3 = self.Value and self.Window.Theme.Accent or Color3.fromRGB(45, 45, 48) })
        tween(self.Knob, TWEEN_FAST, {
            BackgroundColor3 = self.Value and THEME.White or Color3.fromRGB(185, 185, 191),
            Position = UDim2.fromOffset(self.Value and 15 or 2, 2),
        })
    end
    control.Hit.Activated:Connect(function()
        control:SetValue(not control.Value)
    end)
    control:Update()
    function control:AddColorPicker(pickerName, pickerOptions)
        self._hasInlineColor = true
        self.Label.Size = UDim2.new(1, -140, 1, 0)
        return self.Window:_makeColorPicker(self.Groupbox, pickerName or (self.Name .. " color"), pickerOptions or {}, self.Row, 1)
    end
    function control:AddKeyPicker(keyName, keyOptions)
        self._hasInlineKey = true
        self.Label.Size = UDim2.new(1, self._hasInlineColor and -140 or -110, 1, 0)
        return self.Window:_makeKeyPicker(self.Groupbox, keyName or (self.Name .. " key"), keyOptions or {}, self.Row, 1)
    end
    return control
end

function EchoUI:_makeSlider(groupbox, name, options)
    options = options or {}
    local minimum = options.Min or 0
    local maximum = options.Max or 100
    local default = math.clamp(options.Default or minimum, minimum, maximum)
    local control = self:_newControl(groupbox, name, 48, options.Flag, options.Callback, default)
    control.Label.Size = UDim2.new(1, -74, 0, 25)
    control.ValueBox = create("TextBox", {
        BackgroundColor3 = Color3.fromRGB(20, 20, 22),
        BorderSizePixel = 0,
        Position = UDim2.new(1, -61, 0, 3),
        Size = UDim2.fromOffset(56, 20),
        Font = Enum.Font.GothamMedium,
        Text = tostring(default) .. (options.Suffix or ""),
        TextColor3 = THEME.Text,
        TextSize = 10,
        ClearTextOnFocus = false,
        ZIndex = 7,
    }, control.Row)
    corner(control.ValueBox, 3)
    control.Track = create("Frame", {
        BackgroundColor3 = Color3.fromRGB(37, 37, 40),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 5, 1, -11),
        Size = UDim2.new(1, -10, 0, 4),
        ZIndex = 6,
    }, control.Row)
    corner(control.Track, 3)
    control.Fill = create("Frame", {
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
        Size = UDim2.new(0, 0, 1, 0),
        ZIndex = 7,
    }, control.Track)
    corner(control.Fill, 3)
    control.Knob = create("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = THEME.White,
        BorderSizePixel = 0,
        Size = UDim2.fromOffset(10, 10),
        ZIndex = 8,
    }, control.Track)
    corner(control.Knob, 5)
    control.Hit = create("TextButton", {
        AutoButtonColor = false,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 22),
        Size = UDim2.new(1, 0, 1, -22),
        Text = "",
        ZIndex = 9,
    }, control.Row)
    control.Min, control.Max = minimum, maximum
    control.Rounding = options.Rounding == nil and 0 or options.Rounding
    control.Suffix = options.Suffix or ""
    local function formatValue(value)
        if control.Rounding <= 0 then
            return tostring(math.floor(value + 0.5))
        end
        return string.format("%." .. tostring(control.Rounding) .. "f", value)
    end
    function control:Update()
        local alpha = (self.Value - self.Min) / math.max(self.Max - self.Min, 0.0001)
        self.Fill.Size = UDim2.new(alpha, 0, 1, 0)
        self.Knob.Position = UDim2.new(alpha, 0, 0.5, 0)
        self.ValueBox.Text = formatValue(self.Value) .. self.Suffix
    end
    function control:SetFromPosition(x)
        local alpha = math.clamp((x - self.Track.AbsolutePosition.X) / math.max(self.Track.AbsoluteSize.X, 1), 0, 1)
        local value = self.Min + (self.Max - self.Min) * alpha
        local step = 10 ^ (-self.Rounding)
        value = math.clamp(math.floor(value / step + 0.5) * step, self.Min, self.Max)
        self:SetValue(value)
    end
    function control:SetValue(value)
        value = tonumber(value) or self.Min
        value = math.clamp(value, self.Min, self.Max)
        local step = 10 ^ (-self.Rounding)
        value = math.clamp(math.floor(value / step + 0.5) * step, self.Min, self.Max)
        self:_set(value, false)
        return self
    end
    control.Hit.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            control:SetFromPosition(input.Position.X)
            self._dragging = {
                Move = function(_, point)
                    control:SetFromPosition(point.X)
                end,
            }
        end
    end)
    control.ValueBox.FocusLost:Connect(function()
        local parsed = tonumber(control.ValueBox.Text)
        if parsed then
            control:SetValue(math.clamp(parsed, minimum, maximum))
        else
            control:Update()
        end
    end)
    control:Update()
    return control
end

function EchoUI:_openPopup(anchor, popup, width, height)
    self:_closePopup()
    self._popupAnchor = anchor
    self._popup = popup
    local camera = workspace.CurrentCamera
    local viewport = camera and camera.ViewportSize or Vector2.new(1280, 720)
    local absolute = anchor.AbsolutePosition
    local x = math.clamp(absolute.X, 8, math.max(8, viewport.X - width - 8))
    local below = absolute.Y + anchor.AbsoluteSize.Y + 6
    local y = below + height <= viewport.Y - 8 and below or math.max(8, absolute.Y - height - 6)
    popup.Position = UDim2.fromOffset(x, y + 6)
    popup.Size = UDim2.fromOffset(width, 0)
    popup.Visible = true
    tween(popup, TWEEN_POP, { Position = UDim2.fromOffset(x, y), Size = UDim2.fromOffset(width, height) })
end

function EchoUI:_closePopup()
    local popup = self._popup
    self._popup = nil
    self._popupAnchor = nil
    self._dragging = nil
    if popup and popup.Parent then
        local position = popup.Position
        tween(popup, TWEEN_FAST, {
            BackgroundTransparency = 1,
            Position = UDim2.new(position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset + 5),
        })
        task.delay(0.14, function()
            if popup and popup.Parent then
                popup:Destroy()
            end
        end)
    end
end

function EchoUI:_makeDropdown(groupbox, name, options)
    options = options or {}
    local values = options.Values or {}
    local multi = options.Multi == true
    local default = normalizeDefault(options.Default, values, multi)
    local control = self:_newControl(groupbox, name, 49, options.Flag, options.Callback, default)
    control.Values = values
    control.Multi = multi
    control.AllowNull = options.AllowNull == true
    control.Label.Size = UDim2.new(1, -8, 0, 20)
    control.ValueButton = button(control.Row, "", UDim2.new(1, -10, 0, 25), UDim2.new(0, 5, 0, 22))
    control.ValueButton.TextXAlignment = Enum.TextXAlignment.Left
    control.ValueButton.TextSize = 10
    local valuePadding = create("UIPadding", { PaddingLeft = UDim.new(0, 9), PaddingRight = UDim.new(0, 24) }, control.ValueButton)
    control.Chevron = label(control.ValueButton, "⌄", UDim2.fromOffset(16, 22), UDim2.new(1, -22, 0, 1), THEME.Muted, Enum.Font.GothamMedium, 13)
    control.Chevron.TextXAlignment = Enum.TextXAlignment.Center
    function control:DisplayValue()
        if self.Multi then
            local picked = {}
            for _, value in ipairs(self.Values) do
                if self.Value[value] then
                    picked[#picked + 1] = tostring(value)
                end
            end
            if #picked == 0 then
                return "None"
            end
            local joined = table.concat(picked, ", ")
            if #joined > 28 then
                return string.sub(joined, 1, 25) .. "..."
            end
            return joined
        end
        return self.Value == nil and "None" or tostring(self.Value)
    end
    function control:Update()
        self.ValueButton.Text = self:DisplayValue()
        self.ValueButton.TextColor3 = THEME.Text
    end
    control.ValueButton.Activated:Connect(function()
        local popup = create("Frame", {
            BackgroundColor3 = Color3.fromRGB(17, 17, 19),
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Visible = false,
            ZIndex = 50,
        }, self.Gui)
        corner(popup, 4)
        stroke(popup, Color3.fromRGB(44, 44, 47), 0, 1)
        local listHeight = math.min(#values * 27 + 10, 190)
        local list = create("ScrollingFrame", {
            Active = true,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            CanvasSize = UDim2.fromOffset(0, #values * 27 + 10),
            Position = UDim2.fromOffset(4, 5),
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = self.Theme.Accent,
            Size = UDim2.new(1, -8, 1, -10),
            ZIndex = 51,
        }, popup)
        local listLayout = create("UIListLayout", {
            Padding = UDim.new(0, 1),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }, list)
        for index, value in ipairs(values) do
            local rowButton = create("TextButton", {
                AutoButtonColor = false,
                BackgroundColor3 = THEME.Surface,
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                LayoutOrder = index,
                Size = UDim2.new(1, -3, 0, 26),
                Text = "",
                ZIndex = 52,
            }, list)
            corner(rowButton, 3)
            local selected = self.Multi and self.Value[value] or self.Value == value
            local dot = create("Frame", {
                BackgroundColor3 = selected and self.Theme.Accent or Color3.fromRGB(54, 54, 58),
                BorderSizePixel = 0,
                Position = UDim2.fromOffset(8, 8),
                Size = UDim2.fromOffset(10, 10),
                ZIndex = 53,
            }, rowButton)
            corner(dot, self.Multi and 3 or 5)
            label(rowButton, tostring(value), UDim2.new(1, -29, 1, 0), UDim2.fromOffset(26, 0), selected and THEME.Text or Color3.fromRGB(177, 177, 184), Enum.Font.Gotham, 10).ZIndex = 53
            rowButton.MouseEnter:Connect(function()
                tween(rowButton, TWEEN_FAST, { BackgroundTransparency = 0 })
            end)
            rowButton.MouseLeave:Connect(function()
                tween(rowButton, TWEEN_FAST, { BackgroundTransparency = 1 })
            end)
            rowButton.Activated:Connect(function()
                if self.Multi then
                    local copy = table.clone(self.Value)
                    copy[value] = not copy[value] or nil
                    self:SetValue(copy)
                    dot.BackgroundColor3 = copy[value] and self.Theme.Accent or Color3.fromRGB(54, 54, 58)
                else
                    if self.AllowNull and self.Value == value then
                        self:SetValue(nil)
                    else
                        self:SetValue(value)
                    end
                    self.Window:_closePopup()
                end
            end)
        end
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            list.CanvasSize = UDim2.fromOffset(0, listLayout.AbsoluteContentSize.Y + 4)
        end)
        self.Window:_openPopup(self.ValueButton, popup, 265, listHeight)
    end)
    if control.Value == nil and not control.AllowNull and #values > 0 then
        control.Value = values[1]
        self.Flags[control.Flag] = control.Value
    end
    control:Update()
    return control
end

function EchoUI:_makeColorPicker(groupbox, name, options, existingRow, inlineIndex)
    options = options or {}
    local initial = options.Default or Color3.fromRGB(142, 134, 246)
    local row = existingRow
    local control
    if row then
        control = {
            Name = name,
            Flag = options.Flag or (groupbox.Name .. "_" .. name):gsub("%W+", "_"),
            Callback = options.Callback,
            Window = self,
            Groupbox = groupbox,
            Row = row,
            Value = initial,
        }
        attachChanged(control)
        self.Controls[#self.Controls + 1] = control
        self.Options[control.Flag] = control
        self.Flags[control.Flag] = initial
    else
        control = self:_newControl(groupbox, name, 34, options.Flag, options.Callback, initial)
        control.Label.Size = UDim2.new(1, -47, 1, 0)
    end
    local swatch = create("TextButton", {
        AutoButtonColor = false,
        BackgroundColor3 = initial,
        BorderSizePixel = 0,
        Position = UDim2.new(1, inlineIndex and -132 or -36, 0.5, -8),
        Size = UDim2.fromOffset(24, 16),
        Text = "",
        ZIndex = 9,
    }, row)
    corner(swatch, 3)
    stroke(swatch, Color3.fromRGB(86, 86, 92), 0.2, 1)
    control.Button = swatch
    control.Alpha = options.Transparency == true
    control.Transparency = math.clamp(options.DefaultTransparency or 0, 0, 1)
    if control.Alpha then
        self.Flags[control.Flag .. "_Transparency"] = control.Transparency
    end
    local h, s, v = initial:ToHSV()
    control.Hue, control.Saturation, control.Brightness = h, s, v
    function control:Update()
        local color = self.Value
        self.Button.BackgroundColor3 = color
        self.Button.BackgroundTransparency = self.Alpha and self.Transparency or 0
        if self._popupRefresh then
            self._popupRefresh()
        end
    end
    function control:SetValue(value)
        if type(value) == "table" and value.Color then
            self.Value = value.Color
            self.Transparency = math.clamp(value.Transparency or self.Transparency, 0, 1)
        else
            self.Value = value
        end
        self.Hue, self.Saturation, self.Brightness = self.Value:ToHSV()
        self.Window.Flags[self.Flag] = self.Value
        if self.Alpha then
            self.Window.Flags[self.Flag .. "_Transparency"] = self.Transparency
        end
        self:Update()
        self:_fireChanged(self.Value, self.Transparency)
        return self
    end
    function control:GetValue()
        if self.Alpha then
            return { Color = self.Value, Transparency = self.Transparency }
        end
        return self.Value
    end
    function control:SetHSV(hue, saturation, brightness)
        self.Hue = hue
        self.Saturation = saturation
        self.Brightness = brightness
        self:SetValue({
            Color = Color3.fromHSV(hue, saturation, brightness),
            Transparency = self.Transparency,
        })
    end
    function control:SetTransparency(transparency)
        self.Transparency = math.clamp(transparency, 0, 1)
        self.Window.Flags[self.Flag .. "_Transparency"] = self.Transparency
        self:Update()
        if self._opacityFill then
            self._opacityFill.Size = UDim2.new(1 - self.Transparency, 0, 1, 0)
        end
        self:_fireChanged(self.Value, self.Transparency)
        return self
    end
    swatch.Activated:Connect(function()
        local popup = create("Frame", {
            BackgroundColor3 = Color3.fromRGB(17, 17, 19),
            BorderSizePixel = 0,
            ClipsDescendants = true,
            Visible = false,
            ZIndex = 50,
        }, self.Gui)
        corner(popup, 4)
        stroke(popup, Color3.fromRGB(44, 44, 47), 0, 1)
        label(popup, name, UDim2.new(1, -18, 0, 23), UDim2.fromOffset(10, 3), Color3.fromRGB(214, 214, 220), Enum.Font.GothamMedium, 10).ZIndex = 52
        local sv = create("TextButton", {
            AutoButtonColor = false,
            BackgroundColor3 = Color3.fromHSV(control.Hue, 1, 1),
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(10, 31),
            Size = UDim2.fromOffset(185, 124),
            Text = "",
            ZIndex = 51,
        }, popup)
        corner(sv, 3)
        local whiteGradient = create("UIGradient", {
            Color = ColorSequence.new(THEME.White, THEME.White),
            Transparency = NumberSequence.new(0, 1),
            Rotation = 0,
        }, create("Frame", {
            BackgroundColor3 = THEME.White,
            BorderSizePixel = 0,
            Size = UDim2.fromScale(1, 1),
            ZIndex = 52,
        }, sv))
        local blackOverlay = create("Frame", {
            BackgroundColor3 = THEME.Black,
            BorderSizePixel = 0,
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 1),
            ZIndex = 53,
        }, sv)
        corner(blackOverlay, 3)
        create("UIGradient", {
            Color = ColorSequence.new(THEME.Black, THEME.Black),
            Transparency = NumberSequence.new(1, 0),
            Rotation = 90,
        }, blackOverlay)
        local selector = create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(control.Saturation, 0, 1 - control.Brightness, 0),
            Size = UDim2.fromOffset(8, 8),
            ZIndex = 56,
        }, sv)
        corner(selector, 5)
        stroke(selector, THEME.White, 0, 1)
        local hue = create("TextButton", {
            AutoButtonColor = false,
            BackgroundColor3 = THEME.White,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(202, 31),
            Size = UDim2.fromOffset(13, 124),
            Text = "",
            ZIndex = 52,
        }, popup)
        corner(hue, 3)
        create("UIGradient", {
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0)),
            }),
            Rotation = 90,
        }, hue)
        local hueMarker = create("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = THEME.White,
            BorderSizePixel = 0,
            Position = UDim2.new(0.5, 0, control.Hue, 0),
            Size = UDim2.new(1, 4, 0, 2),
            ZIndex = 56,
        }, hue)
        local opacityTrack
        local opacityFill
        if control.Alpha then
            label(popup, "opacity", UDim2.fromOffset(50, 16), UDim2.fromOffset(10, 190), THEME.Muted, Enum.Font.GothamMedium, 9).ZIndex = 52
            opacityTrack = create("Frame", {
                BackgroundColor3 = Color3.fromRGB(42, 42, 45),
                BorderSizePixel = 0,
                Position = UDim2.fromOffset(62, 196),
                Size = UDim2.fromOffset(153, 4),
                ZIndex = 52,
            }, popup)
            corner(opacityTrack, 3)
            opacityFill = create("Frame", {
                BackgroundColor3 = self.Theme.Accent,
                BorderSizePixel = 0,
                Size = UDim2.new(1 - control.Transparency, 0, 1, 0),
                ZIndex = 53,
            }, opacityTrack)
            control._opacityFill = opacityFill
            corner(opacityFill, 3)
            local opacityHit = create("TextButton", {
                AutoButtonColor = false,
                BackgroundTransparency = 1,
                Position = UDim2.new(0, -2, 0, -8),
                Size = UDim2.new(1, 4, 0, 20),
                Text = "",
                ZIndex = 54,
            }, opacityTrack)
            local function updateOpacity(point)
                local alpha = math.clamp((point.X - opacityTrack.AbsolutePosition.X) / opacityTrack.AbsoluteSize.X, 0, 1)
                control:SetTransparency(1 - alpha)
                opacityFill.Size = UDim2.new(alpha, 0, 1, 0)
            end
            opacityHit.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    self._dragging = { Move = updateOpacity }
                    updateOpacity(input.Position)
                end
            end)
        end
        local preview = create("Frame", {
            BackgroundColor3 = control.Value,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(10, 164),
            Size = UDim2.fromOffset(29, 18),
            ZIndex = 52,
        }, popup)
        corner(preview, 3)
        stroke(preview, Color3.fromRGB(78, 78, 84), 0.15, 1)
        local hex = label(popup, "#8E86F6", UDim2.fromOffset(72, 18), UDim2.fromOffset(46, 164), THEME.Text, Enum.Font.GothamMedium, 10)
        hex.ZIndex = 52
        local function refreshPicker()
            sv.BackgroundColor3 = Color3.fromHSV(control.Hue, 1, 1)
            selector.Position = UDim2.new(control.Saturation, 0, 1 - control.Brightness, 0)
            hueMarker.Position = UDim2.new(0.5, 0, control.Hue, 0)
            preview.BackgroundColor3 = control.Value
            local c = control.Value
            hex.Text = string.format("#%02X%02X%02X", math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5))
        end
        local function updateSV(point)
            local localX = math.clamp((point.X - sv.AbsolutePosition.X) / sv.AbsoluteSize.X, 0, 1)
            local localY = math.clamp((point.Y - sv.AbsolutePosition.Y) / sv.AbsoluteSize.Y, 0, 1)
            control:SetHSV(control.Hue, localX, 1 - localY)
            refreshPicker()
        end
        local function updateHue(point)
            local localY = math.clamp((point.Y - hue.AbsolutePosition.Y) / hue.AbsoluteSize.Y, 0, 1)
            control:SetHSV(localY, control.Saturation, control.Brightness)
            refreshPicker()
        end
        sv.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                self._dragging = { Move = updateSV }
                updateSV(input.Position)
            end
        end)
        hue.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                self._dragging = { Move = updateHue }
                updateHue(input.Position)
            end
        end)
        control.Callback = control.Callback
        control._popupRefresh = refreshPicker
        refreshPicker()
        self:_openPopup(swatch, popup, 226, control.Alpha and 218 or 192)
    end)
    control:Update()
    return control
end

function EchoUI:_makeKeyPicker(groupbox, name, options, existingRow, inlineIndex)
    options = options or {}
    local default = options.Default or Enum.KeyCode.Unknown
    local control
    if existingRow then
        control = {
            Name = name,
            Flag = options.Flag or (groupbox.Name .. "_" .. name):gsub("%W+", "_"),
            Callback = options.Callback,
            Window = self,
            Groupbox = groupbox,
            Row = existingRow,
            Value = default,
        }
        attachChanged(control)
        self.Controls[#self.Controls + 1] = control
        self.Options[control.Flag] = control
        self.Flags[control.Flag] = default
    else
        control = self:_newControl(groupbox, name, 32, options.Flag, options.Callback, default)
    end
    control.Mode = options.Mode or "Toggle"
    control.Active = control.Mode == "Always"
    control.NoUI = options.NoUI == true
    local keyOffset = inlineIndex and -102 or -64
    control.Button = button(existingRow or control.Row, default.Name, UDim2.fromOffset(58, 20), UDim2.new(1, keyOffset, 0.5, -10))
    control.Button.TextSize = 9
    control.Button.ZIndex = 9
    function control:_refresh()
        self.Button.Text = self.Window._capture == self and "..." or (self.Value == Enum.KeyCode.Unknown and "none" or self.Value.Name)
        self.Button.TextColor3 = self.Active and self.Window.Theme.Accent or THEME.Text
        if self.Window._keyListEnabled then
            self.Window:_updateKeyList(0)
        end
    end
    function control:SetKey(key)
        self.Value = key
        self.Window.Flags[self.Flag] = key
        self.Active = self.Mode == "Always"
        self:_refresh()
        self:_fireChanged(key, self.Mode)
    end
    function control:SetValue(key, mode)
        if mode then
            self.Mode = mode
        end
        if key then
            self:SetKey(key)
        else
            self.Active = self.Mode == "Always"
            self:_refresh()
        end
        return self
    end
    control.Button.Activated:Connect(function()
        self._capture = control
        control:_refresh()
    end)
    control.Button.MouseButton2Click:Connect(function()
        local modes = { "Toggle", "Hold", "Always" }
        local current = table.find(modes, control.Mode) or 1
        control.Mode = modes[current % #modes + 1]
        control.Active = control.Mode == "Always"
        control:_refresh()
        control:_fireChanged(control.Active, control.Mode)
    end)
    control:_refresh()
    self.Keybinds[#self.Keybinds + 1] = control
    return control
end

function EchoUI:_makeInput(groupbox, name, options)
    options = options or {}
    local control = self:_newControl(groupbox, name, 34, options.Flag, options.Callback, options.Default or "")
    control.Label.Size = UDim2.new(0.42, 0, 1, 0)
    control.Box = create("TextBox", {
        BackgroundColor3 = Color3.fromRGB(20, 20, 22),
        BorderSizePixel = 0,
        ClearTextOnFocus = false,
        Position = UDim2.new(0.42, 0, 0.5, -11),
        Size = UDim2.new(0.58, -4, 0, 22),
        Font = Enum.Font.Gotham,
        PlaceholderText = options.Placeholder or "",
        PlaceholderColor3 = THEME.Faint,
        Text = tostring(control.Value),
        TextColor3 = THEME.Text,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 7,
    }, control.Row)
    corner(control.Box, 3)
    create("UIPadding", { PaddingLeft = UDim.new(0, 7), PaddingRight = UDim.new(0, 5) }, control.Box)
    function control:Update()
        self.Box.Text = tostring(self.Value)
    end
    control.Box.FocusLost:Connect(function()
        control:SetValue(control.Box.Text)
    end)
    return control
end

function EchoUI:_makeButton(groupbox, name, options)
    options = options or {}
    local control = self:_newControl(groupbox, name, 34, options.Flag, nil, nil)
    control.Button = button(control.Row, name, UDim2.new(1, -10, 0, 25), UDim2.new(0, 5, 0.5, -12))
    control.Button.TextSize = 10
    control.Button.Activated:Connect(function()
        if options.Callback then
            options.Callback()
        end
    end)
    return control
end

function EchoUI:_makeLabel(groupbox, text, options)
    options = options or {}
    local control = self:_newControl(groupbox, text, options.Height or 25, options.Flag, options.Callback, text)
    control.Label.Size = UDim2.new(1, -10, 1, 0)
    control.Label.Position = UDim2.fromOffset(5, 0)
    control.Label.TextColor3 = options.Color or Color3.fromRGB(174, 174, 181)
    control.Label.TextSize = options.TextSize or 10
    function control:SetText(value)
        self.Value = tostring(value)
        self.Label.Text = self.Value
        return self
    end
    return control
end

function EchoUI:_makeParagraph(groupbox, title, description)
    local control = self:_newControl(groupbox, title, 55, nil, nil, description)
    control.Label.Text = title
    control.Label.Position = UDim2.fromOffset(5, 3)
    control.Label.Size = UDim2.new(1, -10, 0, 19)
    control.Description = label(control.Row, description, UDim2.new(1, -10, 0, 30), UDim2.fromOffset(5, 22), THEME.Muted, Enum.Font.Gotham, 9)
    control.Description.TextYAlignment = Enum.TextYAlignment.Top
    function control:SetText(newTitle, newDescription)
        self.Label.Text = newTitle
        self.Description.Text = newDescription
        return self
    end
    return control
end

function EchoUI:_makeDivider(groupbox, name)
    local control = self:_newControl(groupbox, name or "", 17, nil, nil, nil)
    control.Label.Visible = name ~= nil and name ~= ""
    control.Label.Size = UDim2.new(1, -10, 1, 0)
    control.Label.Position = UDim2.fromOffset(5, 0)
    control.Label.TextColor3 = THEME.Muted
    local line = create("Frame", {
        BackgroundColor3 = Color3.fromRGB(37, 37, 40),
        BorderSizePixel = 0,
        Position = UDim2.new(0, 5, 1, -1),
        Size = UDim2.new(1, -10, 0, 1),
        ZIndex = 6,
    }, control.Row)
    return control
end

function EchoUI:_installGroupboxAPI(box)
    box.AddToggle = function(_, name, options) return self:_makeToggle(box, name, options) end
    box.AddSlider = function(_, name, options) return self:_makeSlider(box, name, options) end
    box.AddDropdown = function(_, name, options) return self:_makeDropdown(box, name, options) end
    box.AddMultiDropdown = function(_, name, options)
        options = table.clone(options or {})
        options.Multi = true
        return self:_makeDropdown(box, name, options)
    end
    box.AddColorPicker = function(_, name, options) return self:_makeColorPicker(box, name, options) end
    box.AddKeyPicker = function(_, name, options) return self:_makeKeyPicker(box, name, options) end
    box.AddInput = function(_, name, options) return self:_makeInput(box, name, options) end
    box.AddButton = function(_, name, options) return self:_makeButton(box, name, options) end
    box.AddLabel = function(_, name, options) return self:_makeLabel(box, name, options) end
    box.AddParagraph = function(_, title, description) return self:_makeParagraph(box, title, description) end
    box.AddDivider = function(_, name) return self:_makeDivider(box, name) end
end

function EchoUI:_installTabAPI(tab)
    local function addGroupbox(owner, name, column)
        local page = owner.Page or owner.CurrentPage
        local box = self:_addGroupbox(page, name, column)
        self:_installGroupboxAPI(box)
        return box
    end
    tab.AddLeftGroupbox = function(_, name) return addGroupbox(tab, name, 1) end
    tab.AddRightGroupbox = function(_, name) return addGroupbox(tab, name, 2) end
    tab.AddGroupbox = function(_, name, column) return addGroupbox(tab, name, column == "right" and 2 or 1) end
    tab.AddSubTab = function(_, name)
        local subtab = EchoUI.AddSubTab(tab, name)
        subtab.AddLeftGroupbox = function(_, groupName) return addGroupbox(subtab, groupName, 1) end
        subtab.AddRightGroupbox = function(_, groupName) return addGroupbox(subtab, groupName, 2) end
        subtab.AddGroupbox = function(_, groupName, column) return addGroupbox(subtab, groupName, column == "right" and 2 or 1) end
        return subtab
    end
end

-- Rebind AddTab to install the Linoria-like groupbox methods on each tab.
local originalAddTab = EchoUI.AddTab
function EchoUI:AddTab(name, icon)
    local tab = originalAddTab(self, name, icon)
    self:_installTabAPI(tab)
    return tab
end

function EchoUI:AddWatermark(text)
    self._watermarkEnabled = true
    self.Watermark.Visible = true
    self.WatermarkText.Text = text or self._title
    tween(self.Watermark, TWEEN_MEDIUM, { BackgroundTransparency = 0.04, Position = UDim2.new(1, -18, 0, 18) })
    return self.Watermark
end

function EchoUI:AddKeybindList(title)
    self._keyListEnabled = true
    self.KeyList.Visible = true
    self.KeyListTitle.Text = title or "keybinds"
    tween(self.KeyList, TWEEN_MEDIUM, { BackgroundTransparency = 0.04 })
    self:_updateKeyList(0)
    return self.KeyList
end

function EchoUI:_updateKeyList()
    if not self._keyListEnabled or not self.KeyList or not self.KeyList.Parent then
        return
    end
    local active = {}
    for _, keybind in ipairs(self.Keybinds) do
        if not keybind.NoUI and keybind.Active then
            active[#active + 1] = keybind
        end
    end
    local signatureParts = {}
    for _, keybind in ipairs(active) do
        signatureParts[#signatureParts + 1] = keybind.Name .. ":" .. keybind.Value.Name .. ":" .. keybind.Mode
    end
    local signature = table.concat(signatureParts, "|")
    if signature == self._keyListSignature then
        return
    end
    self._keyListSignature = signature
    for _, child in ipairs(self.KeyListRows:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end
    for index, keybind in ipairs(active) do
        local row = create("Frame", {
            BackgroundTransparency = 1,
            LayoutOrder = index,
            Size = UDim2.new(1, 0, 0, 17),
            ZIndex = 32,
        }, self.KeyListRows)
        label(row, keybind.Name, UDim2.new(1, -48, 1, 0), UDim2.fromOffset(0, 0), Color3.fromRGB(190, 190, 197), Enum.Font.Gotham, 9).ZIndex = 33
        local value = keybind.Value == Enum.KeyCode.Unknown and keybind.Mode or keybind.Value.Name
        local keyLabel = label(row, value:lower(), UDim2.fromOffset(44, 17), UDim2.new(1, -44, 0, 0), self.Theme.Accent, Enum.Font.GothamMedium, 9)
        keyLabel.TextXAlignment = Enum.TextXAlignment.Right
        keyLabel.ZIndex = 33
    end
    local height = 31 + (#active > 0 and (#active * 18 + 8) or 0)
    tween(self.KeyList, TWEEN_MEDIUM, { Size = UDim2.fromOffset(202, height) })
    self.KeyListRows.Position = UDim2.fromOffset(8, 32)
    self.KeyListRows.Size = UDim2.new(1, -16, 0, math.max(0, height - 37))
end

function EchoUI:SetAccent(color)
    self.Theme.Accent = color
    self.TitleAccentLabel.TextColor3 = color
    self.Watermark:FindFirstChildWhichIsA("Frame").BackgroundColor3 = color
    self.KeyList:FindFirstChildWhichIsA("Frame").BackgroundColor3 = color
    tween(self.ActiveRail, TWEEN_FAST, { BackgroundColor3 = color })
    if self.ActiveTab then
        self.ActiveTab.SideButton.TextColor3 = color
    end
    for _, control in ipairs(self.Controls) do
        if control.Track and control.Value then
            control.Track.BackgroundColor3 = color
        end
        if control.Fill then
            control.Fill.BackgroundColor3 = color
        end
        if control._popupRefresh then
            control._popupRefresh()
        end
    end
    for _, keybind in ipairs(self.Keybinds) do
        keybind:_refresh()
    end
    self._keyListSignature = nil
    self:_updateKeyList()
    return self
end

function EchoUI:SetVisible(visible)
    self.Visible = visible
    if visible then
        self.Root.Visible = true
        self.Root.Size = UDim2.fromOffset(690, 548)
        tween(self.Root, TWEEN_MEDIUM, { Size = UDim2.fromOffset(708, 564) })
        tween(self.Body, TWEEN_MEDIUM, { BackgroundTransparency = 0 })
    else
        tween(self.Root, TWEEN_FAST, { Size = UDim2.fromOffset(690, 548) })
        task.delay(0.13, function()
            if not self.Visible and self.Root and self.Root.Parent then
                self.Root.Visible = false
            end
        end)
    end
    return self
end

function EchoUI:Notify(title, message, duration)
    local index = #self._notifyStack + 1
    local toast = create("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        BackgroundColor3 = THEME.Surface,
        BorderSizePixel = 0,
        Position = UDim2.new(1, 230, 0, 18 + (index - 1) * 68),
        Size = UDim2.fromOffset(220, 58),
        ZIndex = 60,
    }, self.Gui)
    corner(toast, 4)
    stroke(toast, Color3.fromRGB(43, 43, 47), 0, 1)
    create("Frame", {
        BackgroundColor3 = self.Theme.Accent,
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(8, 10),
        Size = UDim2.fromOffset(2, 38),
        ZIndex = 61,
    }, toast)
    label(toast, title or "ech0.fun", UDim2.new(1, -26, 0, 20), UDim2.fromOffset(17, 7), THEME.Text, Enum.Font.GothamSemibold, 11).ZIndex = 61
    local body = label(toast, message or "", UDim2.new(1, -26, 0, 23), UDim2.fromOffset(17, 28), THEME.Muted, Enum.Font.Gotham, 9)
    body.TextYAlignment = Enum.TextYAlignment.Top
    body.ZIndex = 61
    self._notifyStack[#self._notifyStack + 1] = toast
    tween(toast, TWEEN_MEDIUM, { Position = UDim2.new(1, -18, 0, 18 + (index - 1) * 68) })
    task.delay(duration or 3, function()
        if toast and toast.Parent then
            tween(toast, TWEEN_FAST, { Position = UDim2.new(1, 230, 0, toast.Position.Y.Offset), BackgroundTransparency = 1 })
            task.delay(0.15, function()
                if toast and toast.Parent then
                    toast:Destroy()
                end
            end)
        end
    end)
    return toast
end

local function encodeValue(value)
    if typeof(value) == "Color3" then
        return { __echoType = "Color3", r = value.R, g = value.G, b = value.B }
    end
    if typeof(value) == "EnumItem" then
        return { __echoType = "Enum", enum = tostring(value.EnumType), name = value.Name }
    end
    if type(value) == "table" then
        local result = {}
        for key, child in pairs(value) do
            result[key] = encodeValue(child)
        end
        return result
    end
    return value
end

local function decodeValue(value)
    if type(value) ~= "table" then
        return value
    end
    if value.__echoType == "Color3" then
        return Color3.new(value.r, value.g, value.b)
    end
    if value.__echoType == "Enum" then
        local enumTypeName = tostring(value.enum):match("Enum%.(.+)")
        local enumType = enumTypeName and Enum[enumTypeName]
        if enumType then
            return enumType[value.name]
        end
        return Enum.KeyCode.Unknown
    end
    local result = {}
    for key, child in pairs(value) do
        result[key] = decodeValue(child)
    end
    return result
end

function EchoUI:CreateConfigManager(options)
    options = options or {}
    local manager = {
        Window = self,
        Folder = cleanName(options.Folder or "EchoUI"),
        Extension = ".json",
        Storage = options.Storage,
        Memory = {},
    }

    local function executorEnvironment()
        local environment = _G
        pcall(function()
            if type(getgenv) == "function" then
                environment = getgenv()
            end
        end)
        return environment
    end

    local function callStorage(managerRef, operation, ...)
        local storage = managerRef.Storage
        if storage and type(storage[operation]) == "function" then
            local ok, result = pcall(storage[operation], ...)
            if ok then
                return result
            end
            return nil
        end
        local environment = executorEnvironment()
        local fn = environment[operation]
        if type(fn) == "function" then
            local ok, result = pcall(fn, ...)
            if ok then
                return result
            end
        end
        return nil
    end

    function manager:List()
        local files = callStorage(self, "listfiles", self.Folder)
        local names = {}
        if type(files) == "table" then
            for _, path in ipairs(files) do
                local name = tostring(path):match("([^/\\]+)%.json$")
                if name then
                    names[#names + 1] = name
                end
            end
        end
        if #names == 0 then
            for name in pairs(self.Memory) do
                names[#names + 1] = name
            end
        end
        table.sort(names)
        return names
    end

    function manager:Save(name)
        name = cleanName(name)
        local data = { Version = 1, Values = {} }
        for flag, value in pairs(self.Window.Flags) do
            data.Values[flag] = encodeValue(value)
        end
        for _, control in ipairs(self.Window.Controls) do
            if control.Mode and control.Value ~= nil then
                data.Values[control.Flag] = {
                    __echoType = "Keybind",
                    key = encodeValue(control.Value),
                    mode = control.Mode,
                }
            elseif control.SetTransparency then
                data.Values[control.Flag] = {
                    __echoType = "ColorPicker",
                    color = encodeValue(control.Value),
                    transparency = control.Transparency,
                }
            end
        end
        local json = HttpService:JSONEncode(data)
        local folderExists = callStorage(self, "isfolder", self.Folder)
        if folderExists == false then
            callStorage(self, "makefolder", self.Folder)
        elseif folderExists == nil then
            callStorage(self, "makefolder", self.Folder)
        end
        local path = self.Folder .. "/" .. name .. self.Extension
        local ok, result = pcall(function()
            return callStorage(self, "writefile", path, json)
        end)
        if not ok or result == nil then
            self.Memory[name] = json
        end
        return true, name
    end

    function manager:Load(name)
        name = cleanName(name)
        local path = self.Folder .. "/" .. name .. self.Extension
        local json = callStorage(self, "readfile", path)
        if type(json) ~= "string" then
            json = self.Memory[name]
        end
        if type(json) ~= "string" then
            return false, "Config not found: " .. name
        end
        local ok, decoded = pcall(function()
            return HttpService:JSONDecode(json)
        end)
        if not ok or type(decoded) ~= "table" or type(decoded.Values) ~= "table" then
            return false, "Invalid config data"
        end
        for flag, value in pairs(decoded.Values) do
            local control = nil
            for _, candidate in ipairs(self.Window.Controls) do
                if candidate.Flag == flag then
                    control = candidate
                    break
                end
            end
            if control then
                local restored = decodeValue(value)
                if type(value) == "table" and value.__echoType == "Keybind" and control.SetValue then
                    control:SetValue(decodeValue(value.key), value.mode)
                elseif type(value) == "table" and value.__echoType == "ColorPicker" and control.SetValue then
                    control:SetValue({
                        Color = decodeValue(value.color),
                        Transparency = value.transparency,
                    })
                elseif control.SetValue then
                    control:SetValue(restored)
                elseif control.SetKey and typeof(restored) == "EnumItem" then
                    control:SetKey(restored)
                end
            else
                self.Window.Flags[flag] = decodeValue(value)
            end
        end
        return true
    end

    function manager:Delete(name)
        name = cleanName(name)
        self.Memory[name] = nil
        local path = self.Folder .. "/" .. name .. self.Extension
        pcall(function()
            callStorage(self, "delfile", path)
        end)
        return true
    end

    function manager:Export(name)
        name = cleanName(name)
        local data = { Version = 1, Values = {} }
        for flag, value in pairs(self.Window.Flags) do
            data.Values[flag] = encodeValue(value)
        end
        for _, control in ipairs(self.Window.Controls) do
            if control.Mode and control.Value ~= nil then
                data.Values[control.Flag] = {
                    __echoType = "Keybind",
                    key = encodeValue(control.Value),
                    mode = control.Mode,
                }
            elseif control.SetTransparency then
                data.Values[control.Flag] = {
                    __echoType = "ColorPicker",
                    color = encodeValue(control.Value),
                    transparency = control.Transparency,
                }
            end
        end
        return HttpService:JSONEncode(data)
    end

    function manager:Import(name, json)
        name = cleanName(name)
        local ok = pcall(function()
            HttpService:JSONDecode(json)
        end)
        if not ok then
            return false, "Invalid JSON"
        end
        self.Memory[name] = json
        return self:Load(name)
    end

    self.ConfigManager = manager
    return manager
end

function EchoUI:Unload()
    if self.Unloaded then
        return
    end
    self.Unloaded = true
    for _, connection in ipairs(self.Connections) do
        pcall(function()
            connection:Disconnect()
        end)
    end
    self.Connections = {}
    self.Gui:Destroy()
end

function EchoUI.CreateWindow(first, second)
    local options = first == EchoUI and second or first
    return EchoUI.new(options)
end

return EchoUI
