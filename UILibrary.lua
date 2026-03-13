-- ╔══════════════════════════════════════════╗
-- ║         NexusUI Library v1.0             ║
-- ║     Horizontal Layout | Purple Theme     ║
-- ╚══════════════════════════════════════════╝

local Services = {
    TweenService    = game:GetService("TweenService"),
    UserInput       = game:GetService("UserInputService"),
    RunService      = game:GetService("RunService"),
    TextService     = game:GetService("TextService"),
    CoreGui         = game:GetService("CoreGui"),
}

if getgenv().NexusUI then
    getgenv().NexusUI:Destroy()
end

-- ─── Theme ───────────────────────────────────────────────────────────────────
local Theme = {
    Background      = Color3.fromRGB(18, 18, 24),
    Sidebar         = Color3.fromRGB(22, 22, 30),
    Panel           = Color3.fromRGB(26, 26, 35),
    Section         = Color3.fromRGB(32, 32, 44),
    Accent          = Color3.fromRGB(138, 43, 226),   -- purple
    AccentDark      = Color3.fromRGB(90, 20, 160),
    AccentHover     = Color3.fromRGB(160, 70, 255),
    TextPrimary     = Color3.fromRGB(240, 240, 255),
    TextSecondary   = Color3.fromRGB(160, 155, 185),
    TextMuted       = Color3.fromRGB(100, 95, 125),
    ToggleOn        = Color3.fromRGB(138, 43, 226),
    ToggleOff       = Color3.fromRGB(55, 50, 70),
    SliderFill      = Color3.fromRGB(138, 43, 226),
    SliderBg        = Color3.fromRGB(45, 40, 65),
    InputBg         = Color3.fromRGB(28, 28, 40),
    InputBorder     = Color3.fromRGB(70, 60, 100),
    DividerLine     = Color3.fromRGB(50, 45, 70),
    TitleBar        = Color3.fromRGB(20, 20, 28),
    TabActive       = Color3.fromRGB(138, 43, 226),
    TabHover        = Color3.fromRGB(45, 40, 65),
    TabText         = Color3.fromRGB(160, 155, 185),
    TabActiveText   = Color3.fromRGB(255, 255, 255),
    ButtonBg        = Color3.fromRGB(40, 35, 60),
    ButtonHover     = Color3.fromRGB(60, 50, 90),
    Shadow          = Color3.fromRGB(8, 8, 12),
}

-- ─── Library Object ──────────────────────────────────────────────────────────
local Library = {
    Tabs        = {},
    Flags       = {},
    Connections = {},
    Instances   = {},
    Open        = true,
    Title       = "NexusUI",
    Theme       = Theme,
}
getgenv().NexusUI = Library

-- ─── Utility ─────────────────────────────────────────────────────────────────
local function Tween(obj, props, duration, style, direction)
    local ti = TweenInfo.new(duration or 0.2, style or Enum.EasingStyle.Quad, direction or Enum.EasingDirection.Out)
    Services.TweenService:Create(obj, ti, props):Play()
end

local function Create(class, props, parent)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    if parent then inst.Parent = parent end
    table.insert(Library.Instances, inst)
    return inst
end

local function AddCorner(parent, radius)
    return Create("UICorner", {CornerRadius = UDim.new(0, radius or 6)}, parent)
end

local function AddStroke(parent, color, thickness)
    return Create("UIStroke", {Color = color or Theme.InputBorder, Thickness = thickness or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border}, parent)
end

local function AddPadding(parent, t, b, l, r)
    return Create("UIPadding", {
        PaddingTop    = UDim.new(0, t or 6),
        PaddingBottom = UDim.new(0, b or 6),
        PaddingLeft   = UDim.new(0, l or 8),
        PaddingRight  = UDim.new(0, r or 8),
    }, parent)
end

-- ─── Drag Logic ──────────────────────────────────────────────────────────────
local function MakeDraggable(frame, handle)
    local dragging, dragInput, dragStart, startPos
    handle = handle or frame

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    Services.UserInput.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)
end

-- ─── Build Main GUI ──────────────────────────────────────────────────────────
local ScreenGui = Create("ScreenGui", {
    Name            = "NexusUI",
    ResetOnSpawn    = false,
    ZIndexBehavior  = Enum.ZIndexBehavior.Sibling,
}, Services.CoreGui)

-- Shadow backdrop
local Shadow = Create("Frame", {
    Name            = "Shadow",
    Size            = UDim2.new(0, 608, 0, 412),
    Position        = UDim2.new(0.5, -301, 0.5, -203),
    BackgroundColor3 = Theme.Shadow,
    BackgroundTransparency = 0.4,
    BorderSizePixel = 0,
}, ScreenGui)
AddCorner(Shadow, 10)

-- Main window
local Main = Create("Frame", {
    Name            = "Main",
    Size            = UDim2.new(0, 600, 0, 400),
    Position        = UDim2.new(0.5, -300, 0.5, -200),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, ScreenGui)
AddCorner(Main, 8)
AddStroke(Main, Color3.fromRGB(60, 50, 90), 1)

-- Title bar
local TitleBar = Create("Frame", {
    Name            = "TitleBar",
    Size            = UDim2.new(1, 0, 0, 34),
    BackgroundColor3 = Theme.TitleBar,
    BorderSizePixel = 0,
    ZIndex          = 5,
}, Main)

-- Title accent line
Create("Frame", {
    Size            = UDim2.new(1, 0, 0, 2),
    Position        = UDim2.new(0, 0, 1, -2),
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel = 0,
    ZIndex          = 6,
}, TitleBar)

-- Title icon bar
Create("Frame", {
    Size            = UDim2.new(0, 4, 0, 18),
    Position        = UDim2.new(0, 10, 0.5, -9),
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel = 0,
    ZIndex          = 6,
}, TitleBar)
AddCorner(Create("Frame", {
    Size            = UDim2.new(0, 4, 0, 18),
    Position        = UDim2.new(0, 10, 0.5, -9),
    BackgroundColor3 = Theme.Accent,
    BorderSizePixel = 0,
    ZIndex          = 6,
}, TitleBar), 2)

-- Title text
Create("TextLabel", {
    Position        = UDim2.new(0, 22, 0, 0),
    Size            = UDim2.new(1, -100, 1, 0),
    BackgroundTransparency = 1,
    Text            = Library.Title,
    TextColor3      = Theme.TextPrimary,
    Font            = Enum.Font.GothamBold,
    TextSize        = 14,
    TextXAlignment  = Enum.TextXAlignment.Left,
    ZIndex          = 6,
}, TitleBar)

-- Close button
local CloseBtn = Create("TextButton", {
    Size            = UDim2.new(0, 28, 0, 22),
    Position        = UDim2.new(1, -32, 0.5, -11),
    BackgroundColor3 = Color3.fromRGB(180, 40, 60),
    Text            = "✕",
    TextColor3      = Color3.new(1,1,1),
    Font            = Enum.Font.GothamBold,
    TextSize        = 12,
    BorderSizePixel = 0,
    ZIndex          = 6,
}, TitleBar)
AddCorner(CloseBtn, 5)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Minimize button
local MinBtn = Create("TextButton", {
    Size            = UDim2.new(0, 28, 0, 22),
    Position        = UDim2.new(1, -64, 0.5, -11),
    BackgroundColor3 = Color3.fromRGB(50, 45, 70),
    Text            = "─",
    TextColor3      = Theme.TextSecondary,
    Font            = Enum.Font.GothamBold,
    TextSize        = 12,
    BorderSizePixel = 0,
    ZIndex          = 6,
}, TitleBar)
AddCorner(MinBtn, 5)

local minimized = false
MinBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    Tween(Main, {Size = minimized and UDim2.new(0, 600, 0, 34) or UDim2.new(0, 600, 0, 400)}, 0.3, Enum.EasingStyle.Quint)
end)

MakeDraggable(Main, TitleBar)

-- Content area (below title bar)
local ContentArea = Create("Frame", {
    Name            = "ContentArea",
    Position        = UDim2.new(0, 0, 0, 34),
    Size            = UDim2.new(1, 0, 1, -34),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
}, Main)

-- Sidebar
local Sidebar = Create("Frame", {
    Name            = "Sidebar",
    Size            = UDim2.new(0, 140, 1, 0),
    BackgroundColor3 = Theme.Sidebar,
    BorderSizePixel = 0,
}, ContentArea)

-- Sidebar right border
Create("Frame", {
    Size            = UDim2.new(0, 1, 1, 0),
    Position        = UDim2.new(1, -1, 0, 0),
    BackgroundColor3 = Theme.DividerLine,
    BorderSizePixel = 0,
}, Sidebar)

-- Tab list
local TabList = Create("ScrollingFrame", {
    Name            = "TabList",
    Position        = UDim2.new(0, 0, 0, 8),
    Size            = UDim2.new(1, 0, 1, -8),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 0,
    CanvasSize      = UDim2.new(0, 0, 0, 0),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, Sidebar)

Create("UIListLayout", {
    SortOrder       = Enum.SortOrder.LayoutOrder,
    Padding         = UDim.new(0, 2),
}, TabList)
AddPadding(TabList, 4, 4, 6, 6)

-- Panel area
local PanelArea = Create("Frame", {
    Name            = "PanelArea",
    Position        = UDim2.new(0, 140, 0, 0),
    Size            = UDim2.new(1, -140, 1, 0),
    BackgroundColor3 = Theme.Panel,
    BorderSizePixel = 0,
    ClipsDescendants = true,
}, ContentArea)

-- ─── Tab System ──────────────────────────────────────────────────────────────
local currentTab = nil

function Library:AddTab(name)
    local tab = {
        Name     = name,
        Sections = {},
        Button   = nil,
        Page     = nil,
    }

    -- Sidebar button
    local btn = Create("TextButton", {
        Name            = name,
        Size            = UDim2.new(1, 0, 0, 32),
        BackgroundColor3 = Theme.Sidebar,
        Text            = "",
        BorderSizePixel = 0,
        AutoButtonColor = false,
        LayoutOrder     = #self.Tabs + 1,
    }, TabList)
    AddCorner(btn, 6)

    local btnLabel = Create("TextLabel", {
        Size            = UDim2.new(1, -10, 1, 0),
        Position        = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text            = name,
        TextColor3      = Theme.TabText,
        Font            = Enum.Font.Gotham,
        TextSize        = 13,
        TextXAlignment  = Enum.TextXAlignment.Left,
    }, btn)

    -- Active indicator bar
    local indicator = Create("Frame", {
        Size            = UDim2.new(0, 3, 0.6, 0),
        Position        = UDim2.new(0, 0, 0.2, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
        Visible         = false,
    }, btn)
    AddCorner(indicator, 2)

    -- Page (scrollable)
    local page = Create("ScrollingFrame", {
        Name            = name .. "_Page",
        Size            = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Theme.Accent,
        CanvasSize      = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible         = false,
    }, PanelArea)
    AddPadding(page, 10, 10, 10, 10)
    Create("UIListLayout", {
        SortOrder   = Enum.SortOrder.LayoutOrder,
        Padding     = UDim.new(0, 8),
    }, page)

    tab.Button    = btn
    tab.Page      = page
    tab.Indicator = indicator
    tab.BtnLabel  = btnLabel

    -- Hover
    btn.MouseEnter:Connect(function()
        if currentTab ~= tab then
            Tween(btn, {BackgroundColor3 = Theme.TabHover}, 0.15)
        end
    end)
    btn.MouseLeave:Connect(function()
        if currentTab ~= tab then
            Tween(btn, {BackgroundColor3 = Theme.Sidebar}, 0.15)
        end
    end)

    btn.MouseButton1Click:Connect(function()
        Library:SelectTab(tab)
    end)

    table.insert(self.Tabs, tab)

    if #self.Tabs == 1 then
        Library:SelectTab(tab)
    end

    return tab
end

function Library:SelectTab(tab)
    if currentTab then
        Tween(currentTab.Button, {BackgroundColor3 = Theme.Sidebar}, 0.15)
        currentTab.BtnLabel.TextColor3 = Theme.TabText
        currentTab.BtnLabel.Font = Enum.Font.Gotham
        currentTab.Indicator.Visible = false
        currentTab.Page.Visible = false
    end
    currentTab = tab
    Tween(tab.Button, {BackgroundColor3 = Color3.fromRGB(35, 28, 55)}, 0.15)
    tab.BtnLabel.TextColor3 = Theme.TabActiveText
    tab.BtnLabel.Font = Enum.Font.GothamBold
    tab.Indicator.Visible = true
    tab.Page.Visible = true
end

-- ─── Section ─────────────────────────────────────────────────────────────────
function Library:AddSection(tab, sectionName)
    local section = {
        Items = {},
    }

    local frame = Create("Frame", {
        Name            = sectionName,
        Size            = UDim2.new(1, 0, 0, 0),
        AutomaticSize   = Enum.AutomaticSize.Y,
        BackgroundColor3 = Theme.Section,
        BorderSizePixel = 0,
        LayoutOrder     = #tab.Sections + 1,
    }, tab.Page)
    AddCorner(frame, 6)
    AddStroke(frame, Color3.fromRGB(55, 48, 80), 1)

    -- Section header
    local header = Create("Frame", {
        Name            = "Header",
        Size            = UDim2.new(1, 0, 0, 28),
        BackgroundColor3 = Color3.fromRGB(28, 24, 42),
        BorderSizePixel = 0,
    }, frame)
    AddCorner(header, 6)

    -- Header bottom flat
    Create("Frame", {
        Size            = UDim2.new(1, 0, 0.5, 0),
        Position        = UDim2.new(0, 0, 0.5, 0),
        BackgroundColor3 = Color3.fromRGB(28, 24, 42),
        BorderSizePixel = 0,
    }, header)

    Create("TextLabel", {
        Size            = UDim2.new(1, -12, 1, 0),
        Position        = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text            = sectionName,
        TextColor3      = Theme.Accent,
        Font            = Enum.Font.GothamBold,
        TextSize        = 12,
        TextXAlignment  = Enum.TextXAlignment.Left,
    }, header)

    -- Item container
    local container = Create("Frame", {
        Name            = "Container",
        Position        = UDim2.new(0, 0, 0, 28),
        Size            = UDim2.new(1, 0, 0, 0),
        AutomaticSize   = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    }, frame)
    AddPadding(container, 4, 6, 8, 8)
    Create("UIListLayout", {
        SortOrder   = Enum.SortOrder.LayoutOrder,
        Padding     = UDim.new(0, 5),
    }, container)

    section.Frame     = frame
    section.Container = container

    table.insert(tab.Sections, section)

    -- ── Button ────────────────────────────────────────────────────────────
    function section:AddButton(text, callback)
        local btn = Create("TextButton", {
            Size            = UDim2.new(1, 0, 0, 28),
            BackgroundColor3 = Theme.ButtonBg,
            Text            = "",
            BorderSizePixel = 0,
            AutoButtonColor = false,
            LayoutOrder     = #self.Items + 1,
        }, container)
        AddCorner(btn, 5)
        AddStroke(btn, Color3.fromRGB(70, 58, 100), 1)

        Create("TextLabel", {
            Size            = UDim2.new(1, -10, 1, 0),
            Position        = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text            = text,
            TextColor3      = Theme.TextPrimary,
            Font            = Enum.Font.Gotham,
            TextSize        = 13,
            TextXAlignment  = Enum.TextXAlignment.Left,
        }, btn)

        btn.MouseEnter:Connect(function()
            Tween(btn, {BackgroundColor3 = Theme.ButtonHover}, 0.12)
        end)
        btn.MouseLeave:Connect(function()
            Tween(btn, {BackgroundColor3 = Theme.ButtonBg}, 0.12)
        end)
        btn.MouseButton1Click:Connect(function()
            Tween(btn, {BackgroundColor3 = Theme.Accent}, 0.08)
            task.wait(0.1)
            Tween(btn, {BackgroundColor3 = Theme.ButtonBg}, 0.12)
            if callback then callback() end
        end)

        table.insert(self.Items, btn)
        return btn
    end

    -- ── Toggle ────────────────────────────────────────────────────────────
    function section:AddToggle(text, default, flag, callback)
        local state = default or false
        if flag then Library.Flags[flag] = state end

        local row = Create("Frame", {
            Size            = UDim2.new(1, 0, 0, 28),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder     = #self.Items + 1,
        }, container)

        Create("TextLabel", {
            Size            = UDim2.new(1, -50, 1, 0),
            Position        = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text            = text,
            TextColor3      = Theme.TextPrimary,
            Font            = Enum.Font.Gotham,
            TextSize        = 13,
            TextXAlignment  = Enum.TextXAlignment.Left,
        }, row)

        -- Track
        local track = Create("Frame", {
            Size            = UDim2.new(0, 40, 0, 20),
            Position        = UDim2.new(1, -42, 0.5, -10),
            BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff,
            BorderSizePixel = 0,
        }, row)
        AddCorner(track, 10)

        -- Knob
        local knob = Create("Frame", {
            Size            = UDim2.new(0, 14, 0, 14),
            Position        = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0,
        }, track)
        AddCorner(knob, 7)

        local btn = Create("TextButton", {
            Size            = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text            = "",
            ZIndex          = 2,
        }, row)

        local function setState(v)
            state = v
            if flag then Library.Flags[flag] = state end
            Tween(track, {BackgroundColor3 = state and Theme.ToggleOn or Theme.ToggleOff}, 0.18)
            Tween(knob,  {Position = state and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}, 0.18)
            if callback then callback(state) end
        end

        btn.MouseButton1Click:Connect(function()
            setState(not state)
        end)

        table.insert(self.Items, row)
        return { SetState = setState, GetState = function() return state end }
    end

    -- ── Slider ────────────────────────────────────────────────────────────
    function section:AddSlider(text, min, max, default, flag, callback)
        local value = default or min
        if flag then Library.Flags[flag] = value end

        local wrap = Create("Frame", {
            Size            = UDim2.new(1, 0, 0, 44),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder     = #self.Items + 1,
        }, container)

        -- Top row: label + value display
        local topRow = Create("Frame", {
            Size            = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1,
        }, wrap)

        Create("TextLabel", {
            Size            = UDim2.new(0.7, 0, 1, 0),
            BackgroundTransparency = 1,
            Text            = text,
            TextColor3      = Theme.TextPrimary,
            Font            = Enum.Font.Gotham,
            TextSize        = 13,
            TextXAlignment  = Enum.TextXAlignment.Left,
        }, topRow)

        local valLabel = Create("TextLabel", {
            Size            = UDim2.new(0.3, 0, 1, 0),
            Position        = UDim2.new(0.7, 0, 0, 0),
            BackgroundTransparency = 1,
            Text            = tostring(value) .. " / " .. tostring(max),
            TextColor3      = Theme.Accent,
            Font            = Enum.Font.GothamBold,
            TextSize        = 12,
            TextXAlignment  = Enum.TextXAlignment.Right,
        }, topRow)

        -- Slider track
        local track = Create("Frame", {
            Size            = UDim2.new(1, 0, 0, 8),
            Position        = UDim2.new(0, 0, 0, 26),
            BackgroundColor3 = Theme.SliderBg,
            BorderSizePixel = 0,
        }, wrap)
        AddCorner(track, 4)

        local fill = Create("Frame", {
            Size            = UDim2.new((value - min) / (max - min), 0, 1, 0),
            BackgroundColor3 = Theme.SliderFill,
            BorderSizePixel = 0,
        }, track)
        AddCorner(fill, 4)

        -- Knob
        local knob = Create("Frame", {
            Size            = UDim2.new(0, 14, 0, 14),
            Position        = UDim2.new((value - min) / (max - min), -7, 0.5, -7),
            BackgroundColor3 = Color3.new(1, 1, 1),
            BorderSizePixel = 0,
            ZIndex          = 2,
        }, track)
        AddCorner(knob, 7)
        AddStroke(knob, Theme.Accent, 2)

        -- Interaction
        local dragging = false
        local function updateSlider(input)
            local rel = math.clamp((input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X, 0, 1)
            value = math.floor(min + rel * (max - min) + 0.5)
            if flag then Library.Flags[flag] = value end
            Tween(fill,  {Size     = UDim2.new(rel, 0, 1, 0)}, 0.05)
            Tween(knob,  {Position = UDim2.new(rel, -7, 0.5, -7)}, 0.05)
            valLabel.Text = tostring(value) .. " / " .. tostring(max)
            if callback then callback(value) end
        end

        track.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateSlider(input)
            end
        end)
        Services.UserInput.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        Services.UserInput.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)

        table.insert(self.Items, wrap)
        return { SetValue = function(v)
            value = math.clamp(v, min, max)
            local rel = (value - min) / (max - min)
            fill.Size = UDim2.new(rel, 0, 1, 0)
            knob.Position = UDim2.new(rel, -7, 0.5, -7)
            valLabel.Text = tostring(value) .. " / " .. tostring(max)
            if flag then Library.Flags[flag] = value end
            if callback then callback(value) end
        end, GetValue = function() return value end }
    end

    -- ── TextBox ───────────────────────────────────────────────────────────
    function section:AddTextBox(text, placeholder, default, flag, callback)
        local value = default or ""
        if flag then Library.Flags[flag] = value end

        local wrap = Create("Frame", {
            Size            = UDim2.new(1, 0, 0, 44),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            LayoutOrder     = #self.Items + 1,
        }, container)

        Create("TextLabel", {
            Size            = UDim2.new(1, 0, 0, 18),
            BackgroundTransparency = 1,
            Text            = text,
            TextColor3      = Theme.TextSecondary,
            Font            = Enum.Font.Gotham,
            TextSize        = 12,
            TextXAlignment  = Enum.TextXAlignment.Left,
        }, wrap)

        local inputFrame = Create("Frame", {
            Size            = UDim2.new(1, 0, 0, 24),
            Position        = UDim2.new(0, 0, 0, 20),
            BackgroundColor3 = Theme.InputBg,
            BorderSizePixel = 0,
        }, wrap)
        AddCorner(inputFrame, 5)
        AddStroke(inputFrame, Theme.InputBorder, 1)

        local box = Create("TextBox", {
            Size            = UDim2.new(1, -8, 1, 0),
            Position        = UDim2.new(0, 6, 0, 0),
            BackgroundTransparency = 1,
            Text            = value,
            PlaceholderText = placeholder or "",
            PlaceholderColor3 = Theme.TextMuted,
            TextColor3      = Theme.TextPrimary,
            Font            = Enum.Font.Gotham,
            TextSize        = 13,
            TextXAlignment  = Enum.TextXAlignment.Left,
            ClearTextOnFocus = false,
        }, inputFrame)

        box.Focused:Connect(function()
            Tween(inputFrame, {BackgroundColor3 = Color3.fromRGB(36, 32, 55)}, 0.15)
            AddStroke(inputFrame, Theme.Accent, 1)
        end)
        box.FocusLost:Connect(function(enter)
            Tween(inputFrame, {BackgroundColor3 = Theme.InputBg}, 0.15)
            value = box.Text
            if flag then Library.Flags[flag] = value end
            if callback then callback(value, enter) end
        end)

        table.insert(self.Items, wrap)
        return { SetValue = function(v) box.Text = v; value = v; if flag then Library.Flags[flag] = v end end,
                 GetValue = function() return value end }
    end

    -- ── Label ─────────────────────────────────────────────────────────────
    function section:AddLabel(text)
        local lbl = Create("TextLabel", {
            Size            = UDim2.new(1, 0, 0, 20),
            BackgroundTransparency = 1,
            Text            = text,
            TextColor3      = Theme.TextMuted,
            Font            = Enum.Font.Gotham,
            TextSize        = 12,
            TextXAlignment  = Enum.TextXAlignment.Left,
            LayoutOrder     = #self.Items + 1,
            TextWrapped     = true,
        }, container)
        table.insert(self.Items, lbl)
        return lbl
    end

    -- ── Divider ───────────────────────────────────────────────────────────
    function section:AddDivider()
        local div = Create("Frame", {
            Size            = UDim2.new(1, 0, 0, 1),
            BackgroundColor3 = Theme.DividerLine,
            BorderSizePixel = 0,
            LayoutOrder     = #self.Items + 1,
        }, container)
        table.insert(self.Items, div)
    end

    return section
end

-- ─── Notification ─────────────────────────────────────────────────────────────
function Library:Notify(title, message, duration)
    duration = duration or 3
    local notif = Create("Frame", {
        Size            = UDim2.new(0, 240, 0, 0),
        Position        = UDim2.new(1, -250, 1, -10),
        AnchorPoint     = Vector2.new(0, 1),
        BackgroundColor3 = Theme.Section,
        BorderSizePixel = 0,
        ClipsDescendants = true,
    }, ScreenGui)
    AddCorner(notif, 7)
    AddStroke(notif, Theme.Accent, 1)

    Create("Frame", {
        Size            = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
    }, notif)
    AddCorner(Create("Frame", {
        Size            = UDim2.new(0, 3, 1, 0),
        BackgroundColor3 = Theme.Accent,
        BorderSizePixel = 0,
    }, notif), 2)

    Create("TextLabel", {
        Position        = UDim2.new(0, 12, 0, 6),
        Size            = UDim2.new(1, -16, 0, 16),
        BackgroundTransparency = 1,
        Text            = title,
        TextColor3      = Theme.Accent,
        Font            = Enum.Font.GothamBold,
        TextSize        = 13,
        TextXAlignment  = Enum.TextXAlignment.Left,
    }, notif)

    Create("TextLabel", {
        Position        = UDim2.new(0, 12, 0, 24),
        Size            = UDim2.new(1, -16, 0, 36),
        BackgroundTransparency = 1,
        Text            = message,
        TextColor3      = Theme.TextSecondary,
        Font            = Enum.Font.Gotham,
        TextSize        = 12,
        TextXAlignment  = Enum.TextXAlignment.Left,
        TextWrapped     = true,
    }, notif)

    Tween(notif, {Size = UDim2.new(0, 240, 0, 68)}, 0.3, Enum.EasingStyle.Quint)
    task.wait(duration)
    Tween(notif, {Size = UDim2.new(0, 240, 0, 0)}, 0.3, Enum.EasingStyle.Quint)
    task.wait(0.3)
    notif:Destroy()
end

-- ─── Toggle GUI Visibility ────────────────────────────────────────────────────
Services.UserInput.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        Library.Open = not Library.Open
        Main.Visible  = Library.Open
        Shadow.Visible = Library.Open
    end
end)

Library.Destroy = function()
    ScreenGui:Destroy()
    getgenv().NexusUI = nil
end

-- ─── EXAMPLE USAGE ───────────────────────────────────────────────────────────
--[[
    local tab1 = Library:AddTab("Combat")
    local sec1 = Library:AddSection(tab1, "Aimbot")
    sec1:AddToggle("Enable Aimbot", false, "aimbot_enabled", function(v)
        print("Aimbot:", v)
    end)
    sec1:AddSlider("FOV", 10, 360, 90, "aimbot_fov", function(v)
        print("FOV:", v)
    end)
    sec1:AddSlider("Smoothness", 1, 100, 30, "aimbot_smooth", function(v)
        print("Smooth:", v)
    end)

    local sec2 = Library:AddSection(tab1, "Target")
    sec2:AddToggle("Team Check", true, "team_check")
    sec2:AddToggle("Visible Check", false, "vis_check")

    local tab2 = Library:AddTab("Visuals")
    local vsec = Library:AddSection(tab2, "ESP")
    vsec:AddToggle("Player ESP", false, "esp_player")
    vsec:AddToggle("Box ESP", false, "esp_box")

    local tab3 = Library:AddTab("Misc")
    local msec = Library:AddSection(tab3, "Settings")
    msec:AddTextBox("Custom Tag", "Enter text...", "", "custom_tag", function(v)
        print("Tag:", v)
    end)
    msec:AddButton("Unload", function()
        Library.Destroy()
    end)

    task.spawn(function()
        task.wait(1)
        Library:Notify("NexusUI", "Loaded successfully! Press RightShift to toggle.", 4)
    end)
--]]

return Library
