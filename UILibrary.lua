-- ╔══════════════════════════════════════════╗
-- ║         NexusUI Library v2.0             ║
-- ║   Fixed: Size, Slider Touch, Layout      ║
-- ╚══════════════════════════════════════════╝

local TweenService  = game:GetService("TweenService")
local UserInput     = game:GetService("UserInputService")
local CoreGui       = (gethui and gethui()) or game:GetService("CoreGui")

if getgenv().NexusUI then
    pcall(function() getgenv().NexusUI:Destroy() end)
end

-- ─── Theme ───────────────────────────────────────────────────────────────────
local T = {
    Bg          = Color3.fromRGB(18, 18, 24),
    Sidebar     = Color3.fromRGB(22, 22, 30),
    Panel       = Color3.fromRGB(26, 26, 35),
    Section     = Color3.fromRGB(30, 30, 42),
    SectionHead = Color3.fromRGB(24, 20, 38),
    Accent      = Color3.fromRGB(138, 43, 226),
    TxtPri      = Color3.fromRGB(235, 235, 250),
    TxtSec      = Color3.fromRGB(155, 150, 180),
    TxtMut      = Color3.fromRGB(100, 95, 120),
    TogOn       = Color3.fromRGB(138, 43, 226),
    TogOff      = Color3.fromRGB(50, 46, 65),
    SliderBg    = Color3.fromRGB(42, 38, 60),
    InputBg     = Color3.fromRGB(24, 24, 36),
    BtnBg       = Color3.fromRGB(36, 32, 54),
    BtnHov      = Color3.fromRGB(55, 46, 82),
    Divider     = Color3.fromRGB(48, 42, 68),
    TitleBar    = Color3.fromRGB(20, 18, 28),
    TabHov      = Color3.fromRGB(40, 36, 58),
    TabAct      = Color3.fromRGB(32, 26, 50),
    White       = Color3.new(1, 1, 1),
}

-- ─── Library ─────────────────────────────────────────────────────────────────
local Lib = { Flags = {}, Tabs = {}, _inst = {} }
getgenv().NexusUI = Lib

-- ─── Helpers ─────────────────────────────────────────────────────────────────
local function tw(obj, props, t, style)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.18, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        props):Play()
end

local function New(cls, props, parent)
    local o = Instance.new(cls)
    for k, v in pairs(props or {}) do o[k] = v end
    if parent then o.Parent = parent end
    table.insert(Lib._inst, o)
    return o
end

local function Corner(p, r)
    return New("UICorner", {CornerRadius = UDim.new(0, r or 6)}, p)
end
local function Stroke(p, c, t)
    return New("UIStroke", {Color = c or T.Divider, Thickness = t or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, p)
end
local function Pad(p, t, b, l, r)
    return New("UIPadding", {
        PaddingTop    = UDim.new(0, t or 6), PaddingBottom = UDim.new(0, b or 6),
        PaddingLeft   = UDim.new(0, l or 8), PaddingRight  = UDim.new(0, r or 8),
    }, p)
end
local function List(p, pad)
    return New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding   = UDim.new(0, pad or 4),
    }, p)
end

-- ─── ScreenGui ───────────────────────────────────────────────────────────────
local Screen = New("ScreenGui", {
    Name           = "NexusUI",
    ResetOnSpawn   = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
}, CoreGui)

local WIN_W, WIN_H, SIDEBAR_W, TITLE_H = 450, 300, 110, 30

local Main = New("Frame", {
    Name             = "Main",
    Size             = UDim2.new(0, WIN_W, 0, WIN_H),
    Position         = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2),
    BackgroundColor3 = T.Bg,
    BorderSizePixel  = 0,
    ClipsDescendants = true,
}, Screen)
Corner(Main, 8)
Stroke(Main, Color3.fromRGB(65, 48, 100), 1)

-- ─── Title Bar ───────────────────────────────────────────────────────────────
local TitleBar = New("Frame", {
    Size = UDim2.new(1, 0, 0, TITLE_H),
    BackgroundColor3 = T.TitleBar,
    BorderSizePixel  = 0,
    ZIndex           = 10,
}, Main)

New("Frame", { -- accent line
    Size = UDim2.new(1,0,0,2), Position = UDim2.new(0,0,1,-2),
    BackgroundColor3 = T.Accent, BorderSizePixel = 0, ZIndex = 11,
}, TitleBar)

local ib = New("Frame", {
    Size = UDim2.new(0,3,0,14), Position = UDim2.new(0,8,0.5,-7),
    BackgroundColor3 = T.Accent, BorderSizePixel = 0, ZIndex = 11,
}, TitleBar)
Corner(ib, 2)

New("TextLabel", {
    Position = UDim2.new(0,18,0,0), Size = UDim2.new(1,-90,1,0),
    BackgroundTransparency = 1, Text = "NexusUI",
    TextColor3 = T.TxtPri, Font = Enum.Font.GothamBold,
    TextSize = 13, TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 11,
}, TitleBar)

local MinBtn = New("TextButton", {
    Size = UDim2.new(0,24,0,18), Position = UDim2.new(1,-56,0.5,-9),
    BackgroundColor3 = T.TabHov, Text = "─",
    TextColor3 = T.TxtSec, Font = Enum.Font.GothamBold,
    TextSize = 11, BorderSizePixel = 0, ZIndex = 11,
}, TitleBar)
Corner(MinBtn, 4)

local CloseBtn = New("TextButton", {
    Size = UDim2.new(0,24,0,18), Position = UDim2.new(1,-28,0.5,-9),
    BackgroundColor3 = Color3.fromRGB(170,35,55), Text = "✕",
    TextColor3 = T.White, Font = Enum.Font.GothamBold,
    TextSize = 11, BorderSizePixel = 0, ZIndex = 11,
}, TitleBar)
Corner(CloseBtn, 4)

CloseBtn.MouseButton1Click:Connect(function() Screen:Destroy() end)
CloseBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.Touch then Screen:Destroy() end
end)

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    tw(Main, {Size = minimized and UDim2.new(0,WIN_W,0,TITLE_H) or UDim2.new(0,WIN_W,0,WIN_H)}, 0.28, Enum.EasingStyle.Quint)
end)

-- ─── Drag (Mouse + Touch) ────────────────────────────────────────────────────
do
    local dragging, dragStart, startPos
    local function beginDrag(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging  = true
            dragStart = input.Position
            startPos  = Main.Position
            local con; con = input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false; con:Disconnect()
                end
            end)
        end
    end
    TitleBar.InputBegan:Connect(beginDrag)
    UserInput.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch) then
            local d = input.Position - dragStart
            Main.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + d.X,
                startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end)
end

-- ─── Body ────────────────────────────────────────────────────────────────────
local Body = New("Frame", {
    Position = UDim2.new(0,0,0,TITLE_H), Size = UDim2.new(1,0,1,-TITLE_H),
    BackgroundTransparency = 1,
}, Main)

-- Sidebar
local Sidebar = New("Frame", {
    Size = UDim2.new(0,SIDEBAR_W,1,0),
    BackgroundColor3 = T.Sidebar, BorderSizePixel = 0,
}, Body)
New("Frame", {
    Size=UDim2.new(0,1,1,0), Position=UDim2.new(1,-1,0,0),
    BackgroundColor3=T.Divider, BorderSizePixel=0,
}, Sidebar)

local TabScroll = New("ScrollingFrame", {
    Size = UDim2.new(1,0,1,0),
    BackgroundTransparency = 1, BorderSizePixel = 0,
    ScrollBarThickness = 0,
    CanvasSize = UDim2.new(0,0,0,0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, Sidebar)
Pad(TabScroll, 5, 5, 4, 4)
List(TabScroll, 2)

-- Panel
local Panel = New("ScrollingFrame", {
    Position = UDim2.new(0,SIDEBAR_W,0,0),
    Size = UDim2.new(1,-SIDEBAR_W,1,0),
    BackgroundColor3 = T.Panel, BorderSizePixel = 0,
    ScrollBarThickness = 2,
    ScrollBarImageColor3 = T.Accent,
    CanvasSize = UDim2.new(0,0,0,0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    ClipsDescendants = true,
}, Body)
Pad(Panel, 8, 8, 8, 8)
List(Panel, 6)

-- ─── Tab ─────────────────────────────────────────────────────────────────────
local currentTab = nil

function Lib:AddTab(name)
    local tab = { Name = name, Sections = {} }

    local btn = New("TextButton", {
        Size = UDim2.new(1,0,0,26),
        BackgroundColor3 = T.Sidebar, Text = "",
        BorderSizePixel = 0, AutoButtonColor = false,
        LayoutOrder = #self.Tabs + 1,
    }, TabScroll)
    Corner(btn, 5)

    local ind = New("Frame", {
        Size = UDim2.new(0,3,0,12), Position = UDim2.new(0,0,0.5,-6),
        BackgroundColor3 = T.Accent, BorderSizePixel = 0, Visible = false,
    }, btn)
    Corner(ind, 2)

    local lbl = New("TextLabel", {
        Size = UDim2.new(1,-8,1,0), Position = UDim2.new(0,8,0,0),
        BackgroundTransparency = 1, Text = name,
        TextColor3 = T.TxtSec, Font = Enum.Font.Gotham,
        TextSize = 12, TextXAlignment = Enum.TextXAlignment.Left,
    }, btn)

    local page = New("Frame", {
        Size = UDim2.new(1,0,0,0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Visible = false, LayoutOrder = #self.Tabs + 1,
    }, Panel)
    List(page, 6)

    tab.btn = btn; tab.lbl = lbl; tab.ind = ind; tab.page = page

    local function select()
        self:Select(tab)
    end
    btn.MouseEnter:Connect(function()
        if currentTab ~= tab then tw(btn,{BackgroundColor3=T.TabHov},0.12) end
    end)
    btn.MouseLeave:Connect(function()
        if currentTab ~= tab then tw(btn,{BackgroundColor3=T.Sidebar},0.12) end
    end)
    btn.MouseButton1Click:Connect(select)
    btn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.Touch then select() end
    end)

    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then self:Select(tab) end
    return tab
end

function Lib:Select(tab)
    if currentTab then
        tw(currentTab.btn, {BackgroundColor3=T.Sidebar}, 0.12)
        currentTab.lbl.TextColor3 = T.TxtSec
        currentTab.lbl.Font = Enum.Font.Gotham
        currentTab.ind.Visible = false
        currentTab.page.Visible = false
    end
    currentTab = tab
    tw(tab.btn, {BackgroundColor3=T.TabAct}, 0.12)
    tab.lbl.TextColor3 = T.TxtPri
    tab.lbl.Font = Enum.Font.GothamBold
    tab.ind.Visible = true
    tab.page.Visible = true
    Panel.CanvasPosition = Vector2.new(0,0)
end

-- ─── Section ─────────────────────────────────────────────────────────────────
function Lib:AddSection(tab, name)
    local sec = { Items = {} }

    local frame = New("Frame", {
        Size = UDim2.new(1,0,0,0), AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = T.Section, BorderSizePixel = 0,
        LayoutOrder = #tab.Sections + 1,
    }, tab.page)
    Corner(frame, 6)
    Stroke(frame, Color3.fromRGB(52,44,76), 1)

    local head = New("Frame", {
        Size = UDim2.new(1,0,0,22),
        BackgroundColor3 = T.SectionHead, BorderSizePixel = 0,
    }, frame)
    Corner(head, 6)
    New("Frame", { -- flatten bottom
        Size=UDim2.new(1,0,0.5,0), Position=UDim2.new(0,0,0.5,0),
        BackgroundColor3=T.SectionHead, BorderSizePixel=0,
    }, head)
    New("TextLabel", {
        Position=UDim2.new(0,8,0,0), Size=UDim2.new(1,-10,1,0),
        BackgroundTransparency=1, Text=name,
        TextColor3=T.Accent, Font=Enum.Font.GothamBold,
        TextSize=11, TextXAlignment=Enum.TextXAlignment.Left,
    }, head)

    local cont = New("Frame", {
        Position = UDim2.new(0,0,0,22), Size = UDim2.new(1,0,0,0),
        AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1,
    }, frame)
    Pad(cont, 4, 6, 7, 7)
    List(cont, 4)

    -- ── Button ────────────────────────────────────────────────────────────
    function sec:AddButton(text, cb)
        local btn = New("TextButton", {
            Size=UDim2.new(1,0,0,24), BackgroundColor3=T.BtnBg,
            Text="", BorderSizePixel=0, AutoButtonColor=false,
            LayoutOrder=#self.Items+1,
        }, cont)
        Corner(btn, 4)
        Stroke(btn, Color3.fromRGB(65,52,94), 1)
        New("TextLabel", {
            Size=UDim2.new(1,-10,1,0), Position=UDim2.new(0,8,0,0),
            BackgroundTransparency=1, Text=text,
            TextColor3=T.TxtPri, Font=Enum.Font.Gotham,
            TextSize=12, TextXAlignment=Enum.TextXAlignment.Left,
        }, btn)
        local function fire()
            tw(btn,{BackgroundColor3=T.Accent},0.07)
            task.delay(0.14, function() tw(btn,{BackgroundColor3=T.BtnBg},0.12) end)
            if cb then cb() end
        end
        btn.MouseEnter:Connect(function() tw(btn,{BackgroundColor3=T.BtnHov},0.1) end)
        btn.MouseLeave:Connect(function() tw(btn,{BackgroundColor3=T.BtnBg},0.1) end)
        btn.MouseButton1Click:Connect(fire)
        btn.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.Touch then fire() end
        end)
        table.insert(self.Items, btn)
    end

    -- ── Toggle ────────────────────────────────────────────────────────────
    function sec:AddToggle(text, default, flag, cb)
        local state = default or false
        if flag then Lib.Flags[flag] = state end

        local row = New("Frame", {
            Size=UDim2.new(1,0,0,24), BackgroundTransparency=1,
            LayoutOrder=#self.Items+1,
        }, cont)
        New("TextLabel", {
            Size=UDim2.new(1,-44,1,0), BackgroundTransparency=1,
            Text=text, TextColor3=T.TxtPri, Font=Enum.Font.Gotham,
            TextSize=12, TextXAlignment=Enum.TextXAlignment.Left,
        }, row)

        local track = New("Frame", {
            Size=UDim2.new(0,36,0,18), Position=UDim2.new(1,-38,0.5,-9),
            BackgroundColor3= state and T.TogOn or T.TogOff, BorderSizePixel=0,
        }, row)
        Corner(track, 9)

        local knob = New("Frame", {
            Size=UDim2.new(0,12,0,12),
            Position= state and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6),
            BackgroundColor3=T.White, BorderSizePixel=0,
        }, track)
        Corner(knob, 6)

        local function setState(v)
            state = v
            if flag then Lib.Flags[flag] = v end
            tw(track, {BackgroundColor3= v and T.TogOn or T.TogOff}, 0.15)
            tw(knob,  {Position= v and UDim2.new(1,-15,0.5,-6) or UDim2.new(0,3,0.5,-6)}, 0.15)
            if cb then cb(v) end
        end

        local btn = New("TextButton",{
            Size=UDim2.new(1,0,1,0), BackgroundTransparency=1, Text="", ZIndex=2,
        }, row)
        btn.MouseButton1Click:Connect(function() setState(not state) end)
        btn.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.Touch then setState(not state) end
        end)

        table.insert(self.Items, row)
        return { SetState=setState, GetState=function() return state end }
    end

    -- ── Slider (Mouse + Touch) ────────────────────────────────────────────
    function sec:AddSlider(text, min, max, default, flag, cb)
        local value = math.clamp(default or min, min, max)
        if flag then Lib.Flags[flag] = value end

        local wrap = New("Frame", {
            Size=UDim2.new(1,0,0,40), BackgroundTransparency=1,
            LayoutOrder=#self.Items+1,
        }, cont)

        local top = New("Frame",{Size=UDim2.new(1,0,0,16),BackgroundTransparency=1},wrap)
        New("TextLabel",{
            Size=UDim2.new(0.6,0,1,0), BackgroundTransparency=1,
            Text=text, TextColor3=T.TxtPri, Font=Enum.Font.Gotham,
            TextSize=12, TextXAlignment=Enum.TextXAlignment.Left,
        }, top)
        local valLbl = New("TextLabel",{
            Size=UDim2.new(0.4,0,1,0), Position=UDim2.new(0.6,0,0,0),
            BackgroundTransparency=1,
            Text=tostring(value).." / "..tostring(max),
            TextColor3=T.Accent, Font=Enum.Font.GothamBold,
            TextSize=11, TextXAlignment=Enum.TextXAlignment.Right,
        }, top)

        local track = New("Frame",{
            Size=UDim2.new(1,0,0,6), Position=UDim2.new(0,0,0,22),
            BackgroundColor3=T.SliderBg, BorderSizePixel=0,
        }, wrap)
        Corner(track, 3)

        local fill = New("Frame",{
            Size=UDim2.new((value-min)/(max-min),0,1,0),
            BackgroundColor3=T.Accent, BorderSizePixel=0,
        }, track)
        Corner(fill, 3)

        local knob = New("Frame",{
            Size=UDim2.new(0,12,0,12),
            Position=UDim2.new((value-min)/(max-min),-6,0.5,-6),
            BackgroundColor3=T.White, BorderSizePixel=0, ZIndex=3,
        }, track)
        Corner(knob, 6)
        Stroke(knob, T.Accent, 2)

        -- Big invisible hit zone
        local hit = New("TextButton",{
            Size=UDim2.new(1,0,0,26), Position=UDim2.new(0,0,0.5,-13),
            BackgroundTransparency=1, Text="", ZIndex=5,
        }, track)

        local dragging = false

        local function update(screenX)
            local rel = math.clamp(
                (screenX - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            value = math.floor(min + rel*(max-min) + 0.5)
            if flag then Lib.Flags[flag] = value end
            fill.Size     = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, -6, 0.5, -6)
            valLbl.Text   = tostring(value).." / "..tostring(max)
            if cb then cb(value) end
        end

        -- Mouse
        hit.MouseButton1Down:Connect(function()
            dragging = true
            update(UserInput:GetMouseLocation().X)
        end)
        UserInput.InputChanged:Connect(function(i)
            if dragging and i.UserInputType==Enum.UserInputType.MouseMovement then
                update(i.Position.X)
            end
        end)
        UserInput.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 then dragging=false end
        end)

        -- Touch
        hit.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.Touch then
                dragging=true; update(i.Position.X)
            end
        end)
        UserInput.InputChanged:Connect(function(i)
            if dragging and i.UserInputType==Enum.UserInputType.Touch then
                update(i.Position.X)
            end
        end)
        UserInput.InputEnded:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.Touch then dragging=false end
        end)

        table.insert(self.Items, wrap)
        return {
            SetValue = function(v)
                v = math.clamp(v, min, max); value = v
                local rel = (v-min)/(max-min)
                fill.Size=UDim2.new(rel,0,1,0)
                knob.Position=UDim2.new(rel,-6,0.5,-6)
                valLbl.Text=tostring(v).." / "..tostring(max)
                if flag then Lib.Flags[flag]=v end
                if cb then cb(v) end
            end,
            GetValue = function() return value end,
        }
    end

    -- ── TextBox ───────────────────────────────────────────────────────────
    function sec:AddTextBox(label, placeholder, default, flag, cb)
        local value = default or ""
        if flag then Lib.Flags[flag] = value end

        local wrap = New("Frame",{
            Size=UDim2.new(1,0,0,40), BackgroundTransparency=1,
            LayoutOrder=#self.Items+1,
        }, cont)
        New("TextLabel",{
            Size=UDim2.new(1,0,0,14), BackgroundTransparency=1,
            Text=label, TextColor3=T.TxtSec, Font=Enum.Font.Gotham,
            TextSize=11, TextXAlignment=Enum.TextXAlignment.Left,
        }, wrap)

        local inputF = New("Frame",{
            Size=UDim2.new(1,0,0,22), Position=UDim2.new(0,0,0,16),
            BackgroundColor3=T.InputBg, BorderSizePixel=0,
        }, wrap)
        Corner(inputF, 4)
        local stk = Stroke(inputF, T.Divider, 1)

        local box = New("TextBox",{
            Size=UDim2.new(1,-8,1,0), Position=UDim2.new(0,5,0,0),
            BackgroundTransparency=1, Text=value,
            PlaceholderText=placeholder or "",
            PlaceholderColor3=T.TxtMut, TextColor3=T.TxtPri,
            Font=Enum.Font.Gotham, TextSize=12,
            TextXAlignment=Enum.TextXAlignment.Left,
            ClearTextOnFocus=false,
        }, inputF)

        box.Focused:Connect(function()
            stk.Color=T.Accent
            tw(inputF,{BackgroundColor3=Color3.fromRGB(32,28,50)},0.12)
        end)
        box.FocusLost:Connect(function(enter)
            stk.Color=T.Divider
            tw(inputF,{BackgroundColor3=T.InputBg},0.12)
            value=box.Text
            if flag then Lib.Flags[flag]=value end
            if cb then cb(value,enter) end
        end)

        table.insert(self.Items, wrap)
        return {
            SetValue=function(v) box.Text=v; value=v; if flag then Lib.Flags[flag]=v end end,
            GetValue=function() return value end,
        }
    end

    -- ── Label ─────────────────────────────────────────────────────────────
    function sec:AddLabel(text)
        local l = New("TextLabel",{
            Size=UDim2.new(1,0,0,16), BackgroundTransparency=1,
            Text=text, TextColor3=T.TxtMut, Font=Enum.Font.Gotham,
            TextSize=11, TextXAlignment=Enum.TextXAlignment.Left,
            TextWrapped=true, LayoutOrder=#self.Items+1,
        }, cont)
        table.insert(self.Items, l)
        return l
    end

    -- ── Divider ───────────────────────────────────────────────────────────
    function sec:AddDivider()
        local d = New("Frame",{
            Size=UDim2.new(1,0,0,1), BackgroundColor3=T.Divider,
            BorderSizePixel=0, LayoutOrder=#self.Items+1,
        }, cont)
        table.insert(self.Items, d)
    end

    table.insert(tab.Sections, sec)
    return sec
end

-- ─── Notification ─────────────────────────────────────────────────────────────
function Lib:Notify(title, msg, dur)
    dur = dur or 3
    local nf = New("Frame",{
        Size=UDim2.new(0,210,0,0), AnchorPoint=Vector2.new(1,1),
        Position=UDim2.new(1,-8,1,-8),
        BackgroundColor3=T.Section, BorderSizePixel=0,
        ClipsDescendants=true, ZIndex=20,
    }, Screen)
    Corner(nf, 6); Stroke(nf, T.Accent, 1)
    New("Frame",{Size=UDim2.new(0,3,1,0),BackgroundColor3=T.Accent,BorderSizePixel=0,ZIndex=21},nf)
    New("TextLabel",{
        Position=UDim2.new(0,10,0,5),Size=UDim2.new(1,-14,0,14),
        BackgroundTransparency=1,Text=title,TextColor3=T.Accent,
        Font=Enum.Font.GothamBold,TextSize=12,
        TextXAlignment=Enum.TextXAlignment.Left,ZIndex=21,
    },nf)
    New("TextLabel",{
        Position=UDim2.new(0,10,0,20),Size=UDim2.new(1,-14,0,30),
        BackgroundTransparency=1,Text=msg,TextColor3=T.TxtSec,
        Font=Enum.Font.Gotham,TextSize=11,
        TextXAlignment=Enum.TextXAlignment.Left,TextWrapped=true,ZIndex=21,
    },nf)
    tw(nf,{Size=UDim2.new(0,210,0,58)},0.28,Enum.EasingStyle.Quint)
    task.delay(dur,function()
        tw(nf,{Size=UDim2.new(0,210,0,0)},0.25,Enum.EasingStyle.Quint)
        task.delay(0.3,function() pcall(function() nf:Destroy() end) end)
    end)
end

-- ─── Hotkey ──────────────────────────────────────────────────────────────────
UserInput.InputBegan:Connect(function(inp, gpe)
    if not gpe and inp.KeyCode == Enum.KeyCode.RightShift then
        Main.Visible = not Main.Visible
    end
end)

function Lib:Destroy()
    Screen:Destroy()
    getgenv().NexusUI = nil
end

return Lib
