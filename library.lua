-- ech0.fun UI recreation for Lynx
-- UI only: this file intentionally contains no game/executor feature logic.
-- Lynx's Drawing API is used directly so the result stays visually close to the
-- original 708x564 ImGui canvas.

local UI = {}
UI.__index = UI

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local V2 = Vector2.new
local C = Color3.fromRGB

local THEME = {
	background = C(6, 6, 6), panel = C(12, 12, 12), panel2 = C(18, 18, 18),
	border = C(35, 35, 35), text = C(235, 235, 235), muted = C(142, 142, 142),
	accent = C(142, 134, 246), accentDark = C(73, 68, 130), white = C(255, 255, 255),
}

local function clamp(v, a, b) return math.max(a, math.min(b, v)) end
local function inside(p, x, y, w, h) return p.X >= x and p.X <= x + w and p.Y >= y and p.Y <= y + h end
local function safe(fn, ...) local ok, result = pcall(fn, ...); return ok, result end

function UI.new(options)
	options = options or {}
	local self = setmetatable({}, UI)
	self.Title = options.Title or "ech0.fun"
	self.Size = V2(708, 564)
	self.Position = V2(options.X or 160, options.Y or 110)
	self.Visible = options.Visible ~= false
	self.ToggleKey = options.ToggleKey or Enum.KeyCode.Insert
	self.Theme = options.Theme or THEME
	self.Active = 1
	self.Sub = {0, 0, 0, 0, 0, 0, 0, 0}
	self._objects, self._used, self._hits, self._connections = {}, {}, {}, {}
	self._drag, self._dragDelta = false, V2(0, 0)
	self._lastMouse = UIS:GetMouseLocation()
	self._pageFade, self._fadeTarget = 1, 1
	self._controls = {}
	self.ConfigFolder = options.ConfigFolder or "ech0.fun"
	self.ConfigName = options.ConfigName or "default"
	self.Flags = {}
	self._configValues = {}
	self:_bindInput()
	return self
end

function UI:_bindInput()
	self._connections[#self._connections + 1] = UIS.InputBegan:Connect(function(input, processed)
		if input.KeyCode == self.ToggleKey then self.Visible = not self.Visible; self:_setVisible(self.Visible) end
		if processed or not self.Visible then return end
		local mouse = UIS:GetMouseLocation()
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if inside(mouse, self.Position.X, self.Position.Y, self.Size.X, 28) then
				self._drag, self._dragDelta = true, V2(mouse.X - self.Position.X, mouse.Y - self.Position.Y)
			end
			for i = #self._hits, 1, -1 do
				local h = self._hits[i]
				if inside(mouse, h.x, h.y, h.w, h.h) then h.fn(mouse); break end
			end
		end
	end)
	self._connections[#self._connections + 1] = UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then self._drag = false end
	end)
	self._connections[#self._connections + 1] = UIS.InputChanged:Connect(function(input)
		if self._drag and input.UserInputType == Enum.UserInputType.MouseMovement then
			local m = UIS:GetMouseLocation()
			self.Position = V2(m.X - self._dragDelta.X, m.Y - self._dragDelta.Y)
		end
	end)
	self._connections[#self._connections + 1] = RunService.RenderStepped:Connect(function()
		self:Render()
	end)
end

function UI:_setVisible(value)
	for _, list in pairs(self._objects) do for _, obj in pairs(list) do obj.Visible = value end end
end

function UI:_obj(kind, id)
	self._used[kind] = (self._used[kind] or 0) + 1
	local n = self._used[kind]
	self._objects[kind] = self._objects[kind] or {}
	local obj = self._objects[kind][n]
	if not obj then obj = Drawing.new(kind); obj.ZIndex = 10; self._objects[kind][n] = obj end
	return obj
end

function UI:_rect(x, y, w, h, color, alpha, outline, thickness)
	local o = self:_obj("Square")
	o.Position, o.Size, o.Filled, o.Color, o.Transparency = V2(x, y), V2(w, h), true, color, alpha or 1
	o.Visible = self.Visible
	if outline then
		local b = self:_obj("Square")
		b.Position, b.Size, b.Filled, b.Thickness, b.Color, b.Transparency = V2(x, y), V2(w, h), false, thickness or 1, outline, alpha or 1
		b.Visible = self.Visible
	end
end

function UI:_line(x1, y1, x2, y2, color, thickness)
	local o = self:_obj("Line"); o.From, o.To, o.Color, o.Thickness, o.Transparency = V2(x1,y1), V2(x2,y2), color, thickness or 1, 1; o.Visible = self.Visible
end

function UI:_text(text, x, y, size, color, center)
	local o = self:_obj("Text")
	o.Text, o.Position, o.Size, o.Color, o.Center, o.Outline, o.OutlineColor, o.Transparency = tostring(text), V2(x,y), size or 13, color or self.Theme.text, center == true, false, self.Theme.background, 1
	o.Font = Drawing.Fonts.Montserrat or 4
	o.Visible = self.Visible
	end

function UI:_hit(x, y, w, h, fn)
	self._hits[#self._hits + 1] = {x=x,y=y,w=w,h=h,fn=fn}
	end

function UI:_button(label, x, y, w, h, fn, accent)
	local m = UIS:GetMouseLocation(); local hover = inside(m, x, y, w, h)
	self:_rect(x, y, w, h, accent and self.Theme.accentDark or (hover and self.Theme.panel2 or self.Theme.panel), 1, self.Theme.border)
	self:_text(label, x + w/2, y + (h-13)/2, 12, accent and self.Theme.white or self.Theme.text, true)
	self:_hit(x, y, w, h, fn)
	end

function UI:_toggle(flag, label, x, y, default)
	if self.Flags[flag] == nil then self.Flags[flag] = default == true end
	local value = self.Flags[flag]; local m = UIS:GetMouseLocation(); local hover = inside(m,x,y,200,22)
	self:_rect(x, y + 3, 14, 14, value and self.Theme.accent or self.Theme.panel2, 1, value and self.Theme.accent or self.Theme.border)
	if value then self:_line(x+3,y+10,x+6,y+13,self.Theme.white,2); self:_line(x+6,y+13,x+12,y+6,self.Theme.white,2) end
	self:_text(label, x+23, y+3, 12, hover and self.Theme.white or self.Theme.muted)
	self:_hit(x,y,220,22,function() self.Flags[flag] = not self.Flags[flag] end)
	end

function UI:_slider(flag, label, x, y, w, min, max, default)
	if self.Flags[flag] == nil then self.Flags[flag] = default or min end
	local value = clamp(self.Flags[flag], min, max); local m = UIS:GetMouseLocation(); local hover = inside(m,x,y,w,30)
	self:_text(label, x, y, 12, hover and self.Theme.text or self.Theme.muted)
	self:_text(string.format("%s", math.floor(value*100)/100), x+w, y, 12, self.Theme.text, true)
	self:_rect(x, y+19, w, 3, self.Theme.panel2, 1)
	self:_rect(x, y+19, w*((value-min)/(max-min)), 3, self.Theme.accent, 1)
	self:_hit(x,y,w,28,function(mouse) self.Flags[flag] = min + (max-min)*clamp((mouse.X-x)/w,0,1) end)
	end

function UI:_section(title, x, y, w, h)
	self:_rect(x,y,w,h,self.Theme.panel,1,self.Theme.border)
	self:_text(title,x+14,y+12,13,self.Theme.text)
	self:_line(x+14,y+34,x+w-14,y+34,self.Theme.border,1)
	end

function UI:_field(flag, placeholder, x, y, w)
	if self.Flags[flag] == nil then self.Flags[flag] = "" end
	self:_rect(x,y,w,27,self.Theme.panel2,1,self.Theme.border)
	self:_text(self.Flags[flag] ~= "" and self.Flags[flag] or placeholder,x+9,y+7,12,self.Flags[flag] ~= "" and self.Theme.text or self.Theme.muted)
	end

local tabs = {
	{"Self", {"Player", "Weapon", "Teleports", "Strafe macro"}},
	{"Combat", {"Aimlock", "Silent", "Trigger", "FlickBot", "Custom"}},
	{"Visuals", {"Players", "Vehicles", "Objects", "World"}},
	{"Entity List", {"Players", "Vehicles", "Objects", "Friend Helper"}},
	{"Vehicle", {"Current Vehicle", "Vehicle Spawner", "Vehicle Mods"}},
	{"Server", {"Executor", "Resources", "Dumper"}},
	{"Configurations", {}}, {"Settings", {"Settings"}},
}

function UI:_sidebar()
	local x,y = self.Position.X,self.Position.Y
	self:_text("ech0.",x+20,y+8,14,self.Theme.text); self:_text("fun",x+57,y+8,14,self.Theme.accent)
	self:_line(x+113,y+4,x+113,y+28,self.Theme.border,1)
	for i, tab in ipairs(tabs) do
		local ty = y+54+(i-1)*38; local selected = self.Active == i; local m = UIS:GetMouseLocation(); local hover = inside(m,x+8,ty-7,105,30)
		if selected then self:_rect(x+14,ty+3,2,12,self.Theme.accent,1) end
		self:_text(string.format("%02d",i),x+24,ty,10,selected and self.Theme.accent or self.Theme.muted)
		self:_text(tab[1],x+47,ty-1,12,selected and self.Theme.text or (hover and self.Theme.text or self.Theme.muted))
		self:_hit(x+8,ty-7,105,30,function() self.Active=i; self._fadeTarget=1 end)
	end
	end

function UI:_topbar()
	local x,y = self.Position.X,self.Position.Y; local tab=tabs[self.Active]
	self:_text(tab[1],x+142,y+13,14,self.Theme.text)
	self:_line(x+130,y+4,x+130,y+28,self.Theme.border,1)
	local sx=x+220
	for i,label in ipairs(tab[2]) do
		local width=#label*7+28; local selected=self.Sub[self.Active]==i; local m=UIS:GetMouseLocation(); local hover=inside(m,sx,y+4,width,28)
		self:_text(label,sx+12,y+13,12,selected and self.Theme.accent or (hover and self.Theme.text or self.Theme.muted))
		if selected then self:_line(sx+9,y+30,sx+width-9,y+30,self.Theme.accent,2) end
		self:_hit(sx,y+4,width,30,function() self.Sub[self.Active]=i end); sx=sx+width+2
	end
	end

function UI:_content()
	local x,y=self.Position.X,self.Position.Y; local left=x+130; local top=y+52; local width=562; local sub=self.Sub[self.Active]
	if self.Active==7 then
		self:_configPage(left,top,width); return
	elseif self.Active==8 then
		self:_settingsPage(left,top,width); return
	end
	local label=tabs[self.Active][2][sub] or tabs[self.Active][1]
	self:_text(label,left+2,top+4,18,self.Theme.text)
	self:_text("UI PREVIEW",left+2,top+28,10,self.Theme.accent)
	local a={left,top+55,267,190}; local b={left+284,top+55,267,190}
	self:_section("General",table.unpack(a)); self:_section("Options",table.unpack(b))
	self:_toggle("enabled_"..self.Active,"Enabled",left+16,top+55+52,true)
	self:_toggle("notifications_"..self.Active,"Notifications",left+16,top+55+82,false)
	self:_toggle("watermark_"..self.Active,"Show watermark",left+16,top+55+112,true)
	self:_slider("opacity_"..self.Active,"Opacity",left+16,top+55+147,220,0,1,.85)
	self:_toggle("option_"..self.Active,"Use custom settings",left+300,top+55+52,true)
	self:_toggle("bind_"..self.Active,"Enable keybind",left+300,top+55+82,false)
	self:_slider("speed_"..self.Active,"Animation speed",left+300,top+55+120,220,0,10,5)
	self:_section("Preview content",left,top+265,551,135)
	self:_text("This is the "..label.." page.",left+18,top+303,13,self.Theme.text)
	self:_text("Controls are intentionally presentation-only.",left+18,top+329,12,self.Theme.muted)
	self:_button("Reset page",left+385,top+350,145,30,function() end,false)
	end

function UI:_configPage(x,y,w)
	self:_text("Configurations",x+2,y+4,18,self.Theme.text); self:_text("SAVE MANAGER",x+2,y+28,10,self.Theme.accent)
	self:_section("Saved configurations",x,y+55,w,265)
	self:_text("Default",x+18,y+107,13,self.Theme.text); self:_text("Built-in configuration",x+18,y+129,11,self.Theme.muted)
	self:_button("Load",x+300,y+102,82,28,function() self:LoadConfig("default") end,true)
	self:_button("Save",x+390,y+102,82,28,function() self:SaveConfig("default") end,false)
	self:_button("Refresh",x+18,y+245,100,29,function() end,false)
	self:_button("Create",x+w-118,y+245,100,29,function() end,true)
	end

function UI:_settingsPage(x,y,w)
	self:_text("Settings",x+2,y+4,18,self.Theme.text); self:_text("GENERAL",x+2,y+28,10,self.Theme.accent)
	self:_section("General",x,y+55,267,230); self:_section("Addons",x+284,y+55,267,230)
	self:_toggle("watermark","Watermark",x+16,y+108,true); self:_toggle("fps","Show FPS",x+16,y+138,false); self:_toggle("accent","Accent animations",x+16,y+168,true)
	self:_toggle("autosave","Auto-save configs",x+300,y+108,true); self:_toggle("tips","Tooltips",x+300,y+138,true); self:_toggle("sound","Interface sounds",x+300,y+168,false)
	self:_text("Toggle key",x+16,y+225,12,self.Theme.muted); self:_button("INSERT",x+150,y+216,90,28,function() end,false)
	end

function UI:Render()
	self._used={}; self._hits={}
	if not self.Visible then self:_setVisible(false); return end
	local x,y=self.Position.X,self.Position.Y; local w,h=self.Size.X,self.Size.Y
	self:_rect(x,y,w,h,C(45,45,45),1); self:_rect(x+1,y+1,w-2,h-2,C(10,10,10),1); self:_rect(x+4,y+4,w-8,h-8,self.Theme.background,1,self.Theme.border)
	self:_rect(x+4,y+4,113, h-8, C(9,9,9),1); self:_line(x+117,y+4,x+117,y+h-4,self.Theme.border,1)
	self:_sidebar(); self:_topbar(); self:_content()
	for kind,list in pairs(self._objects) do for i,obj in ipairs(list) do if i>(self._used[kind] or 0) then obj.Visible=false end end end
	end

function UI:_path(name)
	return self.ConfigFolder.."/"..name..".json"
	end

function UI:SaveConfig(name)
	name=name or self.ConfigName; self.ConfigName=name
	local payload=HttpService:JSONEncode(self.Flags)
	if makefolder then pcall(makefolder,self.ConfigFolder) end
	if writefile then local ok=pcall(writefile,self:_path(name),payload); return ok end
	self._configValues[name]=payload; return true
	end

function UI:LoadConfig(name)
	name=name or self.ConfigName; local raw
	if isfile and isfile(self:_path(name)) and readfile then raw=readfile(self:_path(name)) elseif self._configValues[name] then raw=self._configValues[name] end
	if not raw then return false end
	local ok,data=pcall(HttpService.JSONDecode,HttpService,raw); if ok and type(data)=="table" then for k,v in pairs(data) do self.Flags[k]=v end; return true end
	return false
	end

-- Small Linoria-style public flag surface for UI-only consumers.
function UI:RegisterFlag(name, default)
	if self.Flags[name] == nil then self.Flags[name] = default end
	return self.Flags[name]
	end

function UI:SetFlag(name, value)
	self.Flags[name] = value
	return value
	end

function UI:GetFlag(name, fallback)
	local value = self.Flags[name]
	if value == nil then return fallback end
	return value
	end

function UI:Toggle()
	self.Visible = not self.Visible
	self:_setVisible(self.Visible)
	end

function UI:Unload()
	for _,c in ipairs(self._connections) do c:Disconnect() end
	for _,list in pairs(self._objects) do for _,obj in ipairs(list) do pcall(function() obj:Remove() end) end end
	self._objects={}; self.Visible=false
	end

return UI
