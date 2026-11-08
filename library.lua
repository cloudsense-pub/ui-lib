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
local function rgbToHex(v)
	if type(v) == "table" then return string.format("#%02X%02X%02X", math.floor((v.r or 0)*255), math.floor((v.g or 0)*255), math.floor((v.b or 0)*255)) end
	return "#FFFFFF"
end
local function hexToRgb(hex)
	hex = tostring(hex or "#FFFFFF"):gsub("#", "")
	if #hex ~= 6 then return {r=1,g=1,b=1} end
	return {r=tonumber(hex:sub(1,2),16)/255,g=tonumber(hex:sub(3,4),16)/255,b=tonumber(hex:sub(5,6),16)/255}
end
local function hsvToRgb(h,s,v)
	local i=math.floor(h*6); local f=h*6-i; local p=v*(1-s); local q=v*(1-f*s); local t=v*(1-(1-f)*s); i=i%6
	if i==0 then return {r=v,g=t,b=p} elseif i==1 then return {r=q,g=v,b=p} elseif i==2 then return {r=p,g=v,b=t} elseif i==3 then return {r=p,g=q,b=v} elseif i==4 then return {r=t,g=p,b=v} end
	return {r=v,g=p,b=q}
end
local function rgbToHsv(c)
	local r,g,b=c.r,c.g,c.b; local mx=math.max(r,g,b); local mn=math.min(r,g,b); local d=mx-mn; local h=0
	if d~=0 then if mx==r then h=((g-b)/d)%6 elseif mx==g then h=(b-r)/d+2 else h=(r-g)/d+4 end; h=h/6 end
	return h, mx==0 and 0 or d/mx, mx
end

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
	self.Sub = {1, 1, 1, 1, 1, 1, 1, 1}
	self._objects, self._used, self._hits, self._connections = {}, {}, {}, {}
	self._drag, self._dragDelta = false, V2(0, 0)
	self._lastMouse = UIS:GetMouseLocation()
	self._pageFade, self._fadeTarget = 1, 1
	self._drawAlpha, self._lastClock = 1, os.clock()
	self._hover = {}
	self._notifications = {}
	self._controls = {}
	self.ConfigFolder = options.ConfigFolder or "ech0.fun"
	self.ConfigName = options.ConfigName or "default"
	self.Flags = {}
	self._configValues = {}
	self._ignore = {}
	self._colorOpen = nil
	self.Watermark = {Enabled = options.Watermark ~= false, Text = options.WatermarkText or "ech0.fun", ShowFps = false, ShowTime = false, Position = V2(options.WatermarkX or 18, options.WatermarkY or 18)}
	self.KeybindList = {Enabled = options.KeybindList == true, Position = V2(options.KeybindX or 18, options.KeybindY or 64), Items = {}}
	self:_bindInput()
	return self
end

function UI:_bindInput()
	self._connections[#self._connections + 1] = UIS.InputBegan:Connect(function(input, processed)
		if input.KeyCode == self.ToggleKey then self.Visible = not self.Visible; if self.Visible then self._drawAlpha=0 end; self:_setVisible(self.Visible) end
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
	self._connections[#self._connections + 1] = RunService.RenderStepped:Connect(function(dt)
		self:Render(dt)
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
	o.Position, o.Size, o.Filled, o.Color, o.Transparency = V2(x, y), V2(w, h), true, color, (alpha or 1) * self._drawAlpha
	o.Visible = self.Visible
	if outline then
		local b = self:_obj("Square")
		b.Position, b.Size, b.Filled, b.Thickness, b.Color, b.Transparency = V2(x, y), V2(w, h), false, thickness or 1, outline, (alpha or 1) * self._drawAlpha
		b.Visible = self.Visible
	end
end

function UI:_line(x1, y1, x2, y2, color, thickness)
	local o = self:_obj("Line"); o.From, o.To, o.Color, o.Thickness, o.Transparency = V2(x1,y1), V2(x2,y2), color, thickness or 1, self._drawAlpha; o.Visible = self.Visible
end

function UI:_text(text, x, y, size, color, center)
	local o = self:_obj("Text")
	o.Text, o.Position, o.Size, o.Color, o.Center, o.Outline, o.OutlineColor, o.Transparency = tostring(text), V2(x,y), size or 13, color or self.Theme.text, center == true, false, self.Theme.background, self._drawAlpha
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

function UI:_colorPicker(flag, label, x, y)
	if self.Flags[flag] == nil or type(self.Flags[flag]) ~= "table" then self.Flags[flag] = {r=0.56,g=0.53,b=0.96} end
	local color=self.Flags[flag]; local current=C(math.floor(color.r*255),math.floor(color.g*255),math.floor(color.b*255)); local m=UIS:GetMouseLocation()
	self:_text(label,x,y+2,12,self.Theme.muted)
	self:_rect(x+178,y,42,18,current,1,self.Theme.border)
	self:_hit(x+170,y-4,58,26,function() self._colorOpen = self._colorOpen == flag and nil or flag end)
	if self._colorOpen ~= flag then return end
	local px,py=x+4,y+30; local sw,sh=190,122; local hueX=px+sw+9
	-- A sampled HSV grid gives a real saturation/value picker using Drawing squares.
	local rows,cols=20,32; local h,s,v=rgbToHsv(color)
	for row=0,rows-1 do for col=0,cols-1 do local ss=col/(cols-1); local vv=1-row/(rows-1); self:_rect(px+col*(sw/cols),py+row*(sh/rows),sw/cols+1,sh/rows+1,C(math.floor(hsvToRgb(h,ss,vv).r*255),math.floor(hsvToRgb(h,ss,vv).g*255),math.floor(hsvToRgb(h,ss,vv).b*255)),1) end end
	for i=0,19 do local hh=i/19; local hc=hsvToRgb(hh,1,1); self:_rect(hueX,py+i*(sh/20),14,sh/20+1,C(hc.r*255,hc.g*255,hc.b*255),1) end
	self:_rect(px,py+sh+8,sw+19,31,self.Theme.panel2,1,self.Theme.border); self:_text(rgbToHex(color),px+9,py+sh+17,12,self.Theme.text)
	self:_hit(px,py,sw,sh,function(mouse) local ns=clamp((mouse.X-px)/sw,0,1); local nv=1-clamp((mouse.Y-py)/sh,0,1); self.Flags[flag]=hsvToRgb(h,ns,nv) end)
	self:_hit(hueX,py,14,sh,function(mouse) local nh=clamp((mouse.Y-py)/sh,0,1); self.Flags[flag]=hsvToRgb(nh,s,v) end)
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

local tabIcons = {"●", "◈", "◎", "▣", "◆", "◇", "▤", "⚙"}
local subIcons = {"•", "◦", "◇", "◆", "◈"}
local pageOptions = {
	[1] = {
		[1] = {"Auto Heal", "Auto Armor", "Godmode", "No Ragdoll", "Infinite Stamina", "Fast Run"},
		[2] = {"Infinite Ammo", "No Reload", "Weapon Bypass", "Recoil Control", "Spread Control", "Damage Multiplier"},
		[3] = {"Waypoint", "Last Location", "Police Station", "Hospital", "Garage", "Custom Location"},
		[4] = {"Enable Macro", "Circle Preview", "Humanize", "Auto Release", "Show Keybind"},
	},
	[2] = {
		[1] = {"Enable Aimlock", "Sticky Target", "Team Check", "Visible Check", "Prediction", "Auto Switch"},
		[2] = {"Enable Silent Aim", "Hit Chance", "Wall Check", "FOV Circle", "Target Priority"},
		[3] = {"Enable Triggerbot", "Require Visible", "Delay", "Burst Mode"},
		[4] = {"Enable FlickBot", "Flick Speed", "Target Bone", "Cooldown"},
		[5] = {"Custom Targeting", "Custom Prediction", "Custom FOV"},
	},
	[3] = {
		[1] = {"Box ESP", "Name ESP", "Health Bar", "Skeleton", "Distance", "Head Dot"},
		[2] = {"Vehicle ESP", "Vehicle Names", "Distance", "Health Bar", "Lock State"},
		[3] = {"Object ESP", "Dropped Items", "Pickups", "Interactables", "Distance"},
		[4] = {"World Lines", "Bullet Tracers", "Hit Data", "Crosshair", "Particles"},
	},
	[4] = {
		[1] = {"Search Players", "Select Player", "Teleport", "Spectate", "Friend"},
		[2] = {"Search Vehicles", "Select Vehicle", "Teleport", "Enter Vehicle", "Delete"},
		[3] = {"Search Objects", "Select Object", "Move", "Delete", "Inspect"},
		[4] = {"Friend Helper", "Auto Accept", "Highlight Friends", "Ignore Friends"},
	},
	[5] = {
		[1] = {"Vehicle ESP", "Godmode Vehicle", "Fix Vehicle", "Lock Vehicle", "Max Vehicle"},
		[2] = {"Vehicle Category", "Vehicle Model", "Spawn in Vehicle", "Hook into Resource"},
		[3] = {"Max Speed", "Acceleration", "Brakes", "Suspension", "Repair Vehicle"},
	},
	[6] = {
		[1] = {"Execute Script", "Editor", "Clear", "Run", "Monitor"},
		[2] = {"Search Resources", "Resource List", "Start Resource", "Stop Resource", "Start All"},
		[3] = {"Dump Resources", "Export Dump", "Search Dump", "Copy Output"},
	},
}

function UI:_sidebar()
	local x,y = self.Position.X,self.Position.Y
	self:_text("ech0.",x+20,y+8,14,self.Theme.text); self:_text("fun",x+57,y+8,14,self.Theme.accent)
	self:_line(x+113,y+4,x+113,y+28,self.Theme.border,1)
	for i, tab in ipairs(tabs) do
		local ty = y+54+(i-1)*38; local selected = self.Active == i; local m = UIS:GetMouseLocation(); local hover = inside(m,x+8,ty-7,105,30)
		if selected then self:_rect(x+14,ty+3,2,12,self.Theme.accent,1) end
		self:_text(tabIcons[i],x+24,ty-1,14,selected and self.Theme.accent or (hover and self.Theme.text or self.Theme.muted))
		self:_text(tab[1],x+47,ty-1,12,selected and self.Theme.text or (hover and self.Theme.text or self.Theme.muted))
		self:_hit(x+8,ty-7,105,30,function() if self.Active ~= i then self.Active=i; self.Sub[i]=self.Sub[i] or 1; self._drawAlpha=0 end end)
	end
	end

function UI:_topbar()
	local x,y = self.Position.X,self.Position.Y; local tab=tabs[self.Active]
	self:_text(tabIcons[self.Active],x+134,y+12,15,self.Theme.accent)
	self:_text(tab[1],x+154,y+13,14,self.Theme.text)
	self:_line(x+130,y+4,x+130,y+28,self.Theme.border,1)
	local sx=x+220
	for i,label in ipairs(tab[2]) do
		local width=#label*7+28; local selected=self.Sub[self.Active]==i; local m=UIS:GetMouseLocation(); local hover=inside(m,sx,y+4,width,28)
		self:_text(subIcons[((i-1)%#subIcons)+1],sx+8,y+13,11,selected and self.Theme.accent or self.Theme.muted)
		self:_text(label,sx+21,y+13,12,selected and self.Theme.accent or (hover and self.Theme.text or self.Theme.muted))
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
	self:_text("ECH0.FUN  /  "..string.upper(tabs[self.Active][1]),left+2,top+28,10,self.Theme.accent)
	local a={left,top+55,267,190}; local b={left+284,top+55,267,190}
	self:_section("General",table.unpack(a)); self:_section("Options",table.unpack(b))
	local options=pageOptions[self.Active] and pageOptions[self.Active][sub] or {"Enabled","Notifications","Use custom settings","Enable keybind"}
	for i,name in ipairs(options) do
		local column=i<=math.ceil(#options/2) and 1 or 2; local row=column==1 and i or i-math.ceil(#options/2); local ox=column==1 and left+16 or left+300; local oy=top+55+42+(row-1)*26
		self:_toggle("page_"..self.Active.."_"..sub.."_"..i,name,ox,oy,i==1 or i==3)
	end
	self:_slider("opacity_"..self.Active,"Opacity",left+16,top+55+161,220,0,1,.85)
	self:_slider("speed_"..self.Active,"Animation speed",left+300,top+55+161,220,0,10,5)
	if self.Active == 1 then self:_colorPicker("accent_color","Accent color",left+300,top+55+158) end
	self:_section("Preview content",left,top+265,551,135)
	self:_text("This is the "..label.." page.",left+18,top+303,13,self.Theme.text)
	self:_text("All controls are presentation-only and ready for callbacks.",left+18,top+329,12,self.Theme.muted)
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

function UI:_widgets()
	local m = UIS:GetMouseLocation()
	if self.Watermark.Enabled then
		local wtext = self.Watermark.Text
		if self.Watermark.ShowFps then wtext = wtext .. "  |  FPS" end
		if self.Watermark.ShowTime then wtext = wtext .. "  |  " .. os.date("%H:%M:%S") end
		local x,y=self.Watermark.Position.X,self.Watermark.Position.Y; local width=#wtext*7+28
		self:_rect(x,y,width,29,self.Theme.background,1,self.Theme.border)
		self:_rect(x+1,y+1,3,27,self.Theme.accent,1)
		self:_text(wtext,x+14,y+8,12,self.Theme.text)
		self:_hit(x,y,width,29,function() end)
	end
	for i=#self._notifications,1,-1 do
		local note=self._notifications[i]; note.Time=note.Time-(os.clock()-note.Last); note.Last=os.clock()
		if note.Time<=0 then table.remove(self._notifications,i) else
			local x,y=self.Position.X+self.Size.X+18,self.Position.Y+self.Size.Y-34-(i-1)*42; local width=math.max(190,#note.Text*7+28)
			self:_rect(x,y,width,30,self.Theme.background,1,self.Theme.border); self:_rect(x,y,3,30,self.Theme.accent,1); self:_text(note.Text,x+13,y+8,11,self.Theme.text)
		end
	end
	if self.KeybindList.Enabled then
		local entries={}; for _,item in ipairs(self.KeybindList.Items) do if item.Visible ~= false then entries[#entries+1]=item end end
		local x,y=self.KeybindList.Position.X,self.KeybindList.Position.Y; local width=190; local height=30+#entries*25
		self:_rect(x,y,width,height,self.Theme.background,1,self.Theme.border)
		self:_rect(x,y,width,29,self.Theme.panel2,1,self.Theme.border)
		self:_text("KEYBINDS",x+12,y+8,11,self.Theme.accent)
		for i,item in ipairs(entries) do
			local iy=y+29+(i-1)*25; self:_text(item.Name,x+12,iy+7,12,self.Theme.text); self:_text(item.Key or "",x+width-12,iy+7,11,self.Theme.muted,true)
		end
		self:_hit(x,y,width,29,function() end)
	end
	end

function UI:Render(dt)
	self._used={}; self._hits={}
	if not self.Visible then self:_setVisible(false); return end
	dt = clamp(tonumber(dt) or (os.clock()-self._lastClock), 0, 0.1); self._lastClock=os.clock()
	self._drawAlpha = self._drawAlpha + (1-self._drawAlpha)*clamp(dt*10,0,1)
	local accent=self.Flags.accent_color
	if type(accent)=="table" then self.Theme.accent=C(accent.r*255,accent.g*255,accent.b*255) end
	local x,y=self.Position.X,self.Position.Y; local w,h=self.Size.X,self.Size.Y
	self:_rect(x,y,w,h,C(45,45,45),1); self:_rect(x+1,y+1,w-2,h-2,C(10,10,10),1); self:_rect(x+4,y+4,w-8,h-8,self.Theme.background,1,self.Theme.border)
	self:_rect(x+4,y+4,113, h-8, C(9,9,9),1); self:_line(x+117,y+4,x+117,y+h-4,self.Theme.border,1)
	self:_sidebar(); self:_topbar(); self:_content()
	self:_widgets()
	for kind,list in pairs(self._objects) do for i,obj in ipairs(list) do if i>(self._used[kind] or 0) then obj.Visible=false end end end
	end

function UI:_path(name)
	return self.ConfigFolder.."/settings/"..name..".json"
	end

function UI:SetFolder(folder)
	self.ConfigFolder = folder
	self:BuildFolderTree()
	end

function UI:BuildFolderTree()
	if not makefolder then return end
	for _,path in ipairs({self.ConfigFolder,self.ConfigFolder.."/themes",self.ConfigFolder.."/settings"}) do pcall(makefolder,path) end
	end

function UI:SetIgnoreIndexes(list)
	for _,key in ipairs(list or {}) do self._ignore[key]=true end
	end

function UI:RefreshConfigList()
	local out={}; if not listfiles then return out end
	local ok,files=pcall(listfiles,self.ConfigFolder.."/settings"); if not ok or type(files)~="table" then return out end
	for _,file in ipairs(files) do if file:sub(-5)==".json" then local name=file:match("([^/\\]+)%.json$"); if name then out[#out+1]=name end end end
	table.sort(out); return out
	end

function UI:SetAutoload(name)
	if not name or not writefile then return false end
	self:BuildFolderTree(); return pcall(writefile,self.ConfigFolder.."/settings/autoload.txt",name)
	end

function UI:LoadAutoloadConfig()
	local path=self.ConfigFolder.."/settings/autoload.txt"
	if isfile and isfile(path) and readfile then local name=readfile(path); return self:LoadConfig(name:gsub("%s+$", "")) end
	return false
	end

function UI:SaveConfig(name)
	name=name or self.ConfigName; self.ConfigName=name
	local clean={}; for k,v in pairs(self.Flags) do if not self._ignore[k] then clean[k]=v end end
	local payload=HttpService:JSONEncode({objects=clean,version=1})
	self:BuildFolderTree()
	if writefile then local ok=pcall(writefile,self:_path(name),payload); return ok end
	self._configValues[name]=payload; return true
	end

function UI:LoadConfig(name)
	name=name or self.ConfigName; local raw
	if isfile and isfile(self:_path(name)) and readfile then raw=readfile(self:_path(name)) elseif self._configValues[name] then raw=self._configValues[name] end
	if not raw then return false end
	local ok,data=pcall(HttpService.JSONDecode,HttpService,raw); if ok and type(data)=="table" then local values=data.objects or data; for k,v in pairs(values) do if not self._ignore[k] then self.Flags[k]=v end end; return true end
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

function UI:RegisterColor(name, default)
	if self.Flags[name] == nil then
		if typeof(default) == "Color3" then self.Flags[name]={r=default.R,g=default.G,b=default.B}
		else self.Flags[name]=default or {r=1,g=1,b=1} end
	end
	return C(self.Flags[name].r*255,self.Flags[name].g*255,self.Flags[name].b*255)
	end

function UI:GetColor(name)
	local v=self.Flags[name]; if type(v)~="table" then return C(255,255,255) end
	return C(v.r*255,v.g*255,v.b*255)
	end

function UI:SetColor(name, value)
	if typeof(value)=="Color3" then self.Flags[name]={r=value.R,g=value.G,b=value.B} elseif type(value)=="table" then self.Flags[name]={r=clamp(value.r or 1,0,1),g=clamp(value.g or 1,0,1),b=clamp(value.b or 1,0,1)} end
	end

function UI:Toggle()
	self.Visible = not self.Visible
	self:_setVisible(self.Visible)
	end

function UI:SetWatermark(options)
	for key,value in pairs(options or {}) do if self.Watermark[key] ~= nil then self.Watermark[key]=value end end
	return self.Watermark
	end

function UI:AddKeybind(name, key, visible)
	local item={Name=name,Key=key or "",Visible=visible ~= false}; self.KeybindList.Items[#self.KeybindList.Items+1]=item; return item
	end

function UI:SetKeybindListEnabled(enabled)
	self.KeybindList.Enabled=enabled == true
	end

function UI:SetKeybindVisible(name, visible)
	for _,item in ipairs(self.KeybindList.Items) do if item.Name==name then item.Visible=visible ~= false end end
	end

function UI:Notify(text, duration)
	self._notifications[#self._notifications+1]={Text=tostring(text),Time=duration or 3,Last=os.clock()}
	end

function UI:SetTheme(theme)
	for key,value in pairs(theme or {}) do if self.Theme[key] ~= nil then self.Theme[key]=value end end
	return self.Theme
	end

function UI:Unload()
	for _,c in ipairs(self._connections) do c:Disconnect() end
	for _,list in pairs(self._objects) do for _,obj in ipairs(list) do pcall(function() obj:Remove() end) end end
	self._objects={}; self.Visible=false
	end

return UI
