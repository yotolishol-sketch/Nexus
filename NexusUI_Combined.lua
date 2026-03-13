-- NexusUI v3.0 - Combined Single Script
-- Paste this entire script into your executor

--[[
   ███╗   ██╗███████╗██╗  ██╗██╗   ██╗███████╗
   ████╗  ██║██╔════╝╚██╗██╔╝██║   ██║██╔════╝
   ██╔██╗ ██║█████╗   ╚███╔╝ ██║   ██║███████╗
   ██║╚██╗██║██╔══╝   ██╔██╗ ██║   ██║╚════██║
   ██║ ╚████║███████╗██╔╝ ██╗╚██████╔╝███████║
   ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝
   NexusUI  v3.0  |  Full-Featured Lua UI Library
--]]

-- ─── Services ────────────────────────────────────────────────────────────────
local Twen      = game:GetService("TweenService")
local Input     = game:GetService("UserInputService")
local Run       = game:GetService("RunService")
local TextServ  = game:GetService("TextService")
local Players   = game:GetService("Players")
local Http      = game:GetService("HttpService")
local LP        = Players.LocalPlayer
local CoreGui   = (gethui and gethui()) or game:FindFirstChild("CoreGui") or LP.PlayerGui

-- ─── Destroy old instance ────────────────────────────────────────────────────
pcall(function()
    if getgenv().NexusUI then getgenv().NexusUI:Destroy() end
end)

-- ─── Themes ──────────────────────────────────────────────────────────────────
local Themes = {
    Obsidian = { Accent=Color3.fromRGB(0,195,255),   Bg=Color3.fromRGB(8,8,10),    Header=Color3.fromRGB(12,12,15),  Elem=Color3.fromRGB(15,15,18),  Text=Color3.fromRGB(255,255,255) },
    Purple   = { Accent=Color3.fromRGB(138,43,226),  Bg=Color3.fromRGB(14,12,20),  Header=Color3.fromRGB(20,16,30),  Elem=Color3.fromRGB(22,18,34),  Text=Color3.fromRGB(235,225,255) },
    Blood    = { Accent=Color3.fromRGB(220,30,30),   Bg=Color3.fromRGB(10,5,5),    Header=Color3.fromRGB(5,5,5),     Elem=Color3.fromRGB(18,10,10),  Text=Color3.fromRGB(255,255,255) },
    Ocean    = { Accent=Color3.fromRGB(86,120,251),  Bg=Color3.fromRGB(14,20,40),  Header=Color3.fromRGB(20,28,55),  Elem=Color3.fromRGB(20,28,55),  Text=Color3.fromRGB(200,210,255) },
    Midnight = { Accent=Color3.fromRGB(26,200,160),  Bg=Color3.fromRGB(20,30,40),  Header=Color3.fromRGB(30,45,60),  Elem=Color3.fromRGB(28,40,52),  Text=Color3.fromRGB(255,255,255) },
    Grape    = { Accent=Color3.fromRGB(166,71,214),  Bg=Color3.fromRGB(40,28,48),  Header=Color3.fromRGB(28,18,35),  Elem=Color3.fromRGB(50,35,60),  Text=Color3.fromRGB(255,255,255) },
    Sentinel = { Accent=Color3.fromRGB(230,35,69),   Bg=Color3.fromRGB(20,20,20),  Header=Color3.fromRGB(14,14,14),  Elem=Color3.fromRGB(18,18,18),  Text=Color3.fromRGB(119,209,138) },
    Serpent  = { Accent=Color3.fromRGB(0,200,80),    Bg=Color3.fromRGB(18,26,28),  Header=Color3.fromRGB(12,18,20),  Elem=Color3.fromRGB(14,20,22),  Text=Color3.fromRGB(255,255,255) },
    Gold     = { Accent=Color3.fromRGB(255,195,0),   Bg=Color3.fromRGB(12,10,5),   Header=Color3.fromRGB(8,6,3),     Elem=Color3.fromRGB(16,13,7),   Text=Color3.fromRGB(255,240,200) },
}

-- ─── Accent system ───────────────────────────────────────────────────────────
local currentAccent = Color3.fromRGB(138,43,226)
local accentListeners = {}
local function setAccent(c) currentAccent=c; for _,fn in ipairs(accentListeners) do pcall(fn,c) end end
local function onAccent(fn) table.insert(accentListeners,fn) end

-- ─── Config Save/Load ────────────────────────────────────────────────────────
local ConfigAPI = {}
function ConfigAPI:Save(name, data)
    pcall(function() writefile("NexusUI_"..name..".json", Http:JSONEncode(data)) end)
end
function ConfigAPI:Load(name)
    local ok,r = pcall(function() return Http:JSONDecode(readfile("NexusUI_"..name..".json")) end)
    return ok and r or nil
end
function ConfigAPI:Delete(name)
    pcall(function() delfile("NexusUI_"..name..".json") end)
end

-- ─── Utility ─────────────────────────────────────────────────────────────────
local function tw(o,p,t,s,d)
    Twen:Create(o, TweenInfo.new(t or 0.2, s or Enum.EasingStyle.Quad, d or Enum.EasingDirection.Out), p):Play()
end
local TI1 = TweenInfo.new(0.6,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut)
local TI2 = TweenInfo.new(0.4,Enum.EasingStyle.Quint,Enum.EasingDirection.InOut)

local function Cfg(data, default)
    data = data or {}
    for k,v in pairs(default) do if data[k]==nil then data[k]=v end end
    return data
end

local function N(cls, props, parent)
    local o = Instance.new(cls)
    for k,v in pairs(props or {}) do o[k]=v end
    if parent then o.Parent=parent end
    return o
end
local function C(p,r)   return N("UICorner",{CornerRadius=UDim.new(0,r or 4)},p) end
local function S(p,c,t) return N("UIStroke",{Color=c or Color3.fromRGB(255,255,255),Transparency=t or 0.9,Thickness=1,ApplyStrokeMode=Enum.ApplyStrokeMode.Border},p) end
local function Grad(p,ns,rot)
    local g=N("UIGradient",{Transparency=ns,Rotation=rot or 90},p); return g
end
local function AR(p,ratio)
    return N("UIAspectRatioConstraint",{AspectRatio=ratio,AspectType=Enum.AspectType.ScaleWithParentSize},p)
end

-- ─── Notification system ─────────────────────────────────────────────────────
local _nGui = N("ScreenGui",{Name="NexusNotifications",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Global},CoreGui)
local _nCont = N("Frame",{BackgroundTransparency=1,AnchorPoint=Vector2.new(1,1),Position=UDim2.new(1,-12,1,-12),Size=UDim2.new(0,280,1,0),ZIndex=9999},_nGui)
local _nLayout = N("UIListLayout",{HorizontalAlignment=Enum.HorizontalAlignment.Right,VerticalAlignment=Enum.VerticalAlignment.Bottom,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6)},_nCont)

local function Notify(cfg)
    cfg = Cfg(cfg,{Title="NexusUI",Message="",Duration=4,Type="Info"})
    local typeCol = {Info=Color3.fromRGB(0,195,255),Success=Color3.fromRGB(0,210,100),Warning=Color3.fromRGB(255,180,0),Error=Color3.fromRGB(220,50,50)}
    local col = typeCol[cfg.Type] or typeCol.Info

    local Wrap = N("Frame",{BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.new(1,0,0,0),ClipsDescendants=true,LayoutOrder=-math.floor(tick())},_nCont)
    local Card = N("Frame",{BackgroundColor3=Color3.fromRGB(10,10,13),BorderSizePixel=0,Position=UDim2.new(0,290,0,0),Size=UDim2.new(1,0,0,64),ClipsDescendants=false},Wrap)
    C(Card,6); S(Card,col,0.82)
    local bar = N("Frame",{AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=col,BorderSizePixel=0,Position=UDim2.new(0,0,0.5,0),Size=UDim2.new(0,3,0.7,0)},Card); C(bar)
    local tl  = N("Frame",{BackgroundColor3=col,BorderSizePixel=0,Size=UDim2.new(1,0,0,1),ZIndex=5},Card)
    N("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,14,0,8),Size=UDim2.new(1,-40,0,20),Font=Enum.Font.GothamBold,Text=cfg.Title,TextColor3=Color3.fromRGB(255,255,255),TextSize=13,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5},Card)
    N("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,14,0,30),Size=UDim2.new(1,-18,0,28),Font=Enum.Font.Gotham,Text=cfg.Message,TextColor3=Color3.fromRGB(170,170,185),TextSize=12,TextWrapped=true,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=5},Card)
    local pb=N("Frame",{AnchorPoint=Vector2.new(0,1),BackgroundColor3=Color3.fromRGB(20,20,26),BorderSizePixel=0,Position=UDim2.new(0,0,1,0),Size=UDim2.new(1,0,0,3)},Card)
    local pf=N("Frame",{BackgroundColor3=col,BorderSizePixel=0,Size=UDim2.new(1,0,1,0)},pb)

    tw(Card,{Position=UDim2.new(0,0,0,0)},0.35,Enum.EasingStyle.Quint)
    tw(Wrap,{Size=UDim2.new(1,0,0,70)},0.35,Enum.EasingStyle.Quint)
    tw(pf,{Size=UDim2.new(0,0,1,0)},cfg.Duration,Enum.EasingStyle.Linear)

    local btn=N("TextButton",{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=11,Text="",Font=Enum.Font.SourceSans,TextSize=14},Card)
    btn.MouseButton1Click:Connect(function()
        tw(Card,{Position=UDim2.new(0,290,0,0)},0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.In)
        tw(Wrap,{Size=UDim2.new(1,0,0,0)},0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.In)
        task.delay(0.35,function() pcall(function() Wrap:Destroy() end) end)
    end)
    task.delay(cfg.Duration,function()
        tw(Card,{Position=UDim2.new(0,290,0,0)},0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.In)
        tw(Wrap,{Size=UDim2.new(1,0,0,0)},0.3,Enum.EasingStyle.Quint,Enum.EasingDirection.In)
        task.delay(0.35,function() pcall(function() Wrap:Destroy() end) end)
    end)
end

-- ─── Watermark ───────────────────────────────────────────────────────────────
local function SetWatermark(cfg)
    cfg = Cfg(cfg,{Text="NexusUI v3.0",ShowFPS=false,ShowPing=false})
    local WGui = N("ScreenGui",{Name="NexusWatermark",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Global},CoreGui)
    local WF = N("Frame",{BackgroundColor3=Color3.fromRGB(8,8,10),BackgroundTransparency=0.15,BorderSizePixel=0,Position=UDim2.new(0,12,0,12),Size=UDim2.new(0,0,0,28),AutomaticSize=Enum.AutomaticSize.X},WGui)
    C(WF,4)
    local wfs=S(WF,currentAccent,0.8)
    N("UIPadding",{PaddingLeft=UDim.new(0,10),PaddingRight=UDim.new(0,10)},WF)
    local AccLine=N("Frame",{BackgroundColor3=currentAccent,BorderSizePixel=0,Size=UDim2.new(1,0,0,1),ZIndex=5},WF)
    local WL=N("TextLabel",{BackgroundTransparency=1,Size=UDim2.new(0,0,1,0),AutomaticSize=Enum.AutomaticSize.X,Font=Enum.Font.GothamBold,Text=cfg.Text,TextColor3=Color3.fromRGB(255,255,255),TextSize=13,ZIndex=5},WF)
    onAccent(function(c) wfs.Color=c; AccLine.BackgroundColor3=c end)

    if cfg.ShowFPS or cfg.ShowPing then
        local base=cfg.Text; local lastT=tick(); local fps=60
        Run.RenderStepped:Connect(function()
            local now=tick(); fps=math.floor(1/(now-lastT+0.0001)); lastT=now
            local parts={base}
            if cfg.ShowFPS then table.insert(parts,"FPS: "..fps) end
            if cfg.ShowPing then pcall(function() table.insert(parts,"Ping: "..math.floor(game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()).."ms") end) end
            WL.Text=table.concat(parts,"  |  ")
        end)
    end

    return {SetText=function(t) WL.Text=t end, Destroy=function() WGui:Destroy() end}
end

-- ─── Gradient image effect ───────────────────────────────────────────────────
local function GradientImage(E, Color)
    local GL=N("ImageLabel",{Name="GLImage",Parent=E,AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,BorderSizePixel=0,Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.new(0.8,0,0.8,0),SizeConstraint=Enum.SizeConstraint.RelativeYY,ZIndex=(E.ZIndex or 1)-1,Image="rbxassetid://867619398",ImageColor3=Color or currentAccent,ImageTransparency=1})
    local upd=tick(); local nU,Sp,Sy,SZ=4,5,-5,0.8; local nM=UDim2.new(); local rng=Random.new(math.random(10,100000)+tick())
    local str='NX_GL_'..tostring(tick())
    Run:BindToRenderStep(str,45,function()
        if (tick()-upd)>nU then nU=rng:NextNumber(1.1,2.5); Sp=rng:NextNumber(-6,6); Sy=rng:NextNumber(-6,6); SZ=rng:NextNumber(0.6,0.9); upd=tick()
        else Sy=Sy+rng:NextNumber(-0.1,0.1); Sp=Sp+rng:NextNumber(-0.1,0.1) end
        nM=nM:Lerp(UDim2.new(0.5+(Sp/24),0,0.5+(Sy/24),0),.025)
        tw(GL,{Rotation=GL.Rotation+Sp,Position=nM,Size=UDim2.fromScale(SZ,SZ),ImageTransparency=rng:NextNumber(0.3,0.75)},1)
    end)
    return str
end

-- ═══════════════════════════════════════════════════════════════════════════════
--  MAIN WINDOW
-- ═══════════════════════════════════════════════════════════════════════════════
local function NewWindow(config)
    config = Cfg(config,{
        Title       = "NexusUI",
        Description = "v3.0",
        Keybind     = Enum.KeyCode.RightShift,
        Theme       = "Purple",
        AccentColor = nil,
        Size        = UDim2.new(0,550,0,340),
    })

    -- Apply theme
    local theme = Themes[config.Theme] or Themes.Purple
    if config.AccentColor then theme.Accent = config.AccentColor end
    setAccent(theme.Accent)

    local W = { Tabs={}, Flags={}, _open=true, _keybind=config.Keybind }
    local Connections = {}

    -- ── Screen GUI ──────────────────────────────────────────────────────────
    local SGui = N("ScreenGui",{Name="NexusUI",ResetOnSpawn=false,ZIndexBehavior=Enum.ZIndexBehavior.Global,IgnoreGuiInset=true},CoreGui)
    getgenv().NexusUI = W
    W._gui = SGui

    -- ── Main Frame ──────────────────────────────────────────────────────────
    local MF = N("Frame",{Name="Main",AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=theme.Bg,BackgroundTransparency=1,BorderSizePixel=0,Position=UDim2.fromScale(0.5,0.5),Size=config.Size,Active=true,ClipsDescendants=true},SGui)
    C(MF,7)
    local MStroke = S(MF,theme.Accent,0.85)
    onAccent(function(c) MStroke.Color=c end)

    -- Shadow
    local Shadow = N("ImageLabel",{Name="Shadow",Parent=MF,AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,BorderSizePixel=0,Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.new(1,50,1,50),ZIndex=0,Image="rbxassetid://6015897843",ImageColor3=Color3.new(0,0,0),ImageTransparency=1,ScaleType=Enum.ScaleType.Slice,SliceCenter=Rect.new(49,49,450,450)})
    tw(Shadow,{ImageTransparency=0.5},0.7,Enum.EasingStyle.Quint)
    tw(MF,{BackgroundTransparency=0.08},0.7,Enum.EasingStyle.Quint)

    -- Gradient ambient effect
    GradientImage(MF, theme.Accent)

    -- ── Left panel (tabs) ───────────────────────────────────────────────────
    local LPanel = N("Frame",{Name="LPanel",BackgroundColor3=theme.Header,BackgroundTransparency=0.3,BorderSizePixel=0,Size=UDim2.new(0.28,0,1,0)},MF)
    C(LPanel,7)
    N("Frame",{BackgroundColor3=theme.Header,BackgroundTransparency=0.3,BorderSizePixel=0,Position=UDim2.new(0.5,0,0,0),Size=UDim2.new(0.5,0,1,0)},LPanel) -- fill right half to make left rounded only

    -- Divider line
    N("Frame",{BackgroundColor3=theme.Accent,BackgroundTransparency=0.7,BorderSizePixel=0,Position=UDim2.new(1,-1,0,0),Size=UDim2.new(0,1,1,0)},LPanel)

    -- Header (logo area)
    local HeaderBox = N("Frame",{BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.6,BorderSizePixel=0,Size=UDim2.new(1,0,0,56)},LPanel)

    -- Title
    local TitleLbl = N("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,10,0,8),Size=UDim2.new(1,-14,0,22),Font=Enum.Font.GothamBold,Text=config.Title,TextColor3=theme.Text,TextSize=14,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3},HeaderBox)
    local DescLbl  = N("TextLabel",{BackgroundTransparency=1,Position=UDim2.new(0,10,0,30),Size=UDim2.new(1,-14,0,14),Font=Enum.Font.Gotham,Text=config.Description,TextColor3=theme.Text,TextTransparency=0.5,TextSize=11,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3},HeaderBox)

    -- Accent line under header
    local HLine = N("Frame",{BackgroundColor3=theme.Accent,BackgroundTransparency=0.6,BorderSizePixel=0,Position=UDim2.new(0,0,1,-1),Size=UDim2.new(1,0,0,1)},HeaderBox)
    onAccent(function(c) HLine.BackgroundColor3=c end)

    -- Tab scroll
    local TabScroll = N("ScrollingFrame",{BackgroundTransparency=1,BorderSizePixel=0,Position=UDim2.new(0,0,0,58),Size=UDim2.new(1,0,1,-58),ScrollBarThickness=0,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y},LPanel)
    N("UIPadding",{PaddingLeft=UDim.new(0,5),PaddingRight=UDim.new(0,5),PaddingTop=UDim.new(0,4)},TabScroll)
    local TabLayout = N("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,3)},TabScroll)

    -- ── Right panel (content) ───────────────────────────────────────────────
    local RPanel = N("ScrollingFrame",{Name="RPanel",BackgroundTransparency=1,BorderSizePixel=0,Position=UDim2.new(0.28,0,0,0),Size=UDim2.new(0.72,0,1,0),ScrollBarThickness=2,ScrollBarImageColor3=theme.Accent,CanvasSize=UDim2.new(0,0,0,0),AutomaticCanvasSize=Enum.AutomaticSize.Y,ClipsDescendants=true},MF)
    N("UIPadding",{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8),PaddingTop=UDim.new(0,8),PaddingBottom=UDim.new(0,8)},RPanel)
    N("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6)},RPanel)
    onAccent(function(c) RPanel.ScrollBarImageColor3=c end)

    -- ── Drag ────────────────────────────────────────────────────────────────
    do
        local drag,ds,sp=false,nil,nil
        HeaderBox.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                drag=true; ds=i.Position; sp=MF.Position
                local c; c=i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then drag=false; c:Disconnect() end end)
            end
        end)
        Input.InputChanged:Connect(function(i)
            if drag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                local d=i.Position-ds
                MF.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
            end
        end)
    end

    -- ── Toggle visibility ───────────────────────────────────────────────────
    local function toggleOpen(v)
        W._open = v
        if v then
            tw(MF,{Size=config.Size,BackgroundTransparency=0.08},0.5,Enum.EasingStyle.Quint)
            tw(Shadow,{ImageTransparency=0.5},0.5,Enum.EasingStyle.Quint)
        else
            tw(MF,{BackgroundTransparency=1},0.5,Enum.EasingStyle.Quint)
            tw(Shadow,{ImageTransparency=1},0.5,Enum.EasingStyle.Quint)
        end
        MF.Active = v
    end

    Input.InputBegan:Connect(function(io,gpe)
        if not gpe and io.KeyCode==W._keybind then
            toggleOpen(not W._open)
        end
    end)

    -- ── Current tab ─────────────────────────────────────────────────────────
    local currentTab = nil

    -- ── AddTab ──────────────────────────────────────────────────────────────
    function W:AddTab(cfg)
        cfg = Cfg(cfg,{Title="Tab",Icon=""})
        local Tab = { Sections={}, _col={Left={},Right={}} }

        -- Tab button
        local TBtn = N("Frame",{BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=1,BorderSizePixel=0,ClipsDescendants=true,Size=UDim2.new(1,0,0,36),ZIndex=5,LayoutOrder=#self.Tabs+1},TabScroll)
        C(TBtn,4)
        AR(TBtn,4.5)

        -- Active indicator
        local Ind = N("Frame",{BackgroundColor3=theme.Accent,BackgroundTransparency=1,BorderSizePixel=0,Position=UDim2.new(0,0,0.1,0),Size=UDim2.new(0,3,0.8,0),ZIndex=6},TBtn)
        C(Ind,2); onAccent(function(c) Ind.BackgroundColor3=c end)

        local TLbl = N("TextLabel",{AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1,BorderSizePixel=0,Position=UDim2.new(0.06,0,0.5,0),Size=UDim2.new(0.9,0,0.55,0),Font=Enum.Font.GothamBold,Text=cfg.Title,TextColor3=theme.Text,TextTransparency=0.4,TextScaled=true,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=6},TBtn)
        Grad(TLbl,NumberSequence.new{NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.84,0.25),NumberSequenceKeypoint.new(1,1)},90)

        -- Page frame
        local Page = N("Frame",{Name=cfg.Title.."_page",Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y,BackgroundTransparency=1,Visible=false,LayoutOrder=#self.Tabs+1},RPanel)
        -- Two column layout
        local ColFrame = N("Frame",{BackgroundTransparency=1,Size=UDim2.new(1,0,0,0),AutomaticSize=Enum.AutomaticSize.Y},Page)
        N("UIListLayout",{FillDirection=Enum.FillDirection.Horizontal,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6),VerticalAlignment=Enum.VerticalAlignment.Top},ColFrame)
        local LeftCol = N("Frame",{BackgroundTransparency=1,Size=UDim2.new(0.5,-3,0,0),AutomaticSize=Enum.AutomaticSize.Y,LayoutOrder=1},ColFrame)
        local RightCol= N("Frame",{BackgroundTransparency=1,Size=UDim2.new(0.5,-3,0,0),AutomaticSize=Enum.AutomaticSize.Y,LayoutOrder=2},ColFrame)
        N("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6)},LeftCol)
        N("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,6)},RightCol)

        Tab.Page=Page; Tab.LeftCol=LeftCol; Tab.RightCol=RightCol; Tab.Btn=TBtn; Tab.Lbl=TLbl; Tab.Ind=Ind

        local function select()
            -- deselect all
            for _,t in ipairs(self.Tabs) do
                tw(t.Btn,{BackgroundTransparency=1},0.15)
                tw(t.Lbl,{TextTransparency=0.4},0.15)
                t.Lbl.Font=Enum.Font.Gotham
                tw(t.Ind,{BackgroundTransparency=1},0.15)
                t.Page.Visible=false
            end
            -- select this
            tw(TBtn,{BackgroundTransparency=0.85},0.15)
            tw(TLbl,{TextTransparency=0},0.15)
            TLbl.Font=Enum.Font.GothamBold
            tw(Ind,{BackgroundTransparency=0},0.15)
            Page.Visible=true
            currentTab=Tab
            RPanel.CanvasPosition=Vector2.new(0,0)
        end

        N("TextButton",{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=10,Text="",Font=Enum.Font.SourceSans,TextSize=14},TBtn).MouseButton1Click:Connect(select)
        TBtn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then select() end end)

        table.insert(self.Tabs,Tab)
        if #self.Tabs==1 then select() end
        return Tab
    end

    -- ── AddSection ──────────────────────────────────────────────────────────
    function W:AddSection(tab, cfg)
        cfg = Cfg(type(cfg)=="string" and {Title=cfg} or (cfg or {}),{Title="Section",Position="Left"})
        local Sec = { _items={} }

        local parent = (cfg.Position=="Right") and tab.RightCol or tab.LeftCol
        local secIdx = #tab.Sections+1

        local SF = N("Frame",{BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.75,BorderSizePixel=0,Size=UDim2.new(1,0,0,200),ClipsDescendants=true,LayoutOrder=secIdx},parent)
        C(SF,4); S(SF,Color3.fromRGB(255,255,255),0.92)

        -- Header
        local Head = N("Frame",{BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.9,BorderSizePixel=0,Size=UDim2.new(1,0,0,32)},SF)
        C(Head,4); AR(Head,8)

        local HLine2 = N("Frame",{AnchorPoint=Vector2.new(0.5,1),BackgroundColor3=theme.Accent,BackgroundTransparency=0.8,BorderSizePixel=0,Position=UDim2.new(0.5,0,1,0),Size=UDim2.new(1,0,0,1),ZIndex=3},Head)
        onAccent(function(c) HLine2.BackgroundColor3=c end)

        local HL=N("TextLabel",{AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1,BorderSizePixel=0,Position=UDim2.new(0.04,0,0.5,0),Size=UDim2.new(0.9,0,0.5,0),Font=Enum.Font.GothamBold,Text=cfg.Title,TextColor3=theme.Text,TextScaled=true,TextXAlignment=Enum.TextXAlignment.Left,TextTransparency=0.1,ZIndex=4},Head)
        Grad(HL,NumberSequence.new{NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.84,0.25),NumberSequenceKeypoint.new(1,1)},90)

        -- Content layout
        local SAutoUI = N("UIListLayout",{HorizontalAlignment=Enum.HorizontalAlignment.Center,SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,3)},SF)
        SAutoUI:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            tw(SF,{Size=UDim2.new(1,0,0,math.max(SAutoUI.AbsoluteContentSize.Y,50)+(SAutoUI.Padding.Offset*1.1))},0.1)
        end)

        Sec._frame=SF; Sec._parent=parent

        -- ──────────────────────────────────────────────────────────────────
        --  TOGGLE
        -- ──────────────────────────────────────────────────────────────────
        function Sec:NewToggle(t)
            t=Cfg(t,{Title="Toggle",Default=false,Flag="",Callback=function()end})
            local state=t.Default
            if t.Flag~="" then W.Flags[t.Flag]=state end

            local FT=N("Frame",{BackgroundColor3=Color3.fromRGB(17,17,17),BackgroundTransparency=0.8,BorderSizePixel=0,Size=UDim2.new(0.95,0,0.5,0),ZIndex=17,LayoutOrder=#self._items+1},SF)
            C(FT,3); AR(FT,7); S(FT,Color3.fromRGB(255,255,255),0.95)

            local TI2=N("TextLabel",{AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1,BorderSizePixel=0,Position=UDim2.new(0.04,0,0.5,0),Size=UDim2.new(0.75,0,0.5,0),Font=Enum.Font.GothamBold,Text=t.Title,TextColor3=theme.Text,TextScaled=true,TextTransparency=0.25,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=18},FT)
            Grad(TI2,NumberSequence.new{NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.84,0.25),NumberSequenceKeypoint.new(1,1)},90)

            -- Track
            local Track=N("Frame",{AnchorPoint=Vector2.new(1,0.5),BackgroundColor3=state and theme.Accent or Color3.fromRGB(35,35,40),BackgroundTransparency=0,BorderSizePixel=0,Position=UDim2.new(0.97,0,0.5,0),Size=UDim2.new(0,36,0,18),ZIndex=18},FT)
            C(Track,9)
            local Knob=N("Frame",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0,Position=state and UDim2.new(0.78,0,0.5,0) or UDim2.new(0.22,0,0.5,0),Size=UDim2.new(0,12,0,12),ZIndex=19},Track)
            C(Knob,6)

            local function setState(v)
                state=v
                if t.Flag~="" then W.Flags[t.Flag]=v end
                tw(Track,{BackgroundColor3=v and theme.Accent or Color3.fromRGB(35,35,40)},0.2)
                tw(Knob,{Position=v and UDim2.new(0.78,0,0.5,0) or UDim2.new(0.22,0,0.5,0)},0.2)
                tw(TI2,{TextTransparency=v and 0 or 0.25},0.15)
                pcall(t.Callback,v)
            end

            local Btn=N("TextButton",{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=20,Text="",Font=Enum.Font.SourceSans,TextSize=14},FT)
            Btn.MouseButton1Click:Connect(function() setState(not state) end)
            Btn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then setState(not state) end end)

            table.insert(self._items,FT)
            return {SetState=setState,GetState=function() return state end,SetVisible=function(v) FT.Visible=v end}
        end

        -- ──────────────────────────────────────────────────────────────────
        --  SLIDER
        -- ──────────────────────────────────────────────────────────────────
        function Sec:NewSlider(s)
            s=Cfg(s,{Title="Slider",Min=0,Max=100,Default=50,Flag="",Callback=function()end})
            local value=math.clamp(s.Default,s.Min,s.Max)
            if s.Flag~="" then W.Flags[s.Flag]=value end

            local FS=N("Frame",{BackgroundColor3=Color3.fromRGB(17,17,17),BackgroundTransparency=0.8,BorderSizePixel=0,Size=UDim2.new(0.95,0,0.5,0),ZIndex=17,LayoutOrder=#self._items+1},SF)
            C(FS,3); AR(FS,6); S(FS,Color3.fromRGB(255,255,255),0.95)

            local TI3=N("TextLabel",{AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1,Position=UDim2.new(0.03,0,0.28,0),Size=UDim2.new(0.6,0,0.38,0),Font=Enum.Font.GothamBold,Text=s.Title,TextColor3=theme.Text,TextScaled=true,TextTransparency=0.25,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=18},FS)
            Grad(TI3,NumberSequence.new{NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.84,0.25),NumberSequenceKeypoint.new(1,1)},90)

            local ValT=N("TextLabel",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,Position=UDim2.new(0.5,0,0.28,0),Size=UDim2.new(0.92,0,0.36,0),Font=Enum.Font.GothamBold,Text=tostring(value).."/"..tostring(s.Max),TextColor3=theme.Text,TextScaled=true,TextTransparency=0.5,TextXAlignment=Enum.TextXAlignment.Right,ZIndex=18},FS)

            local MFR=N("Frame",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.8,BorderSizePixel=0,ClipsDescendants=true,Position=UDim2.new(0.5,0,0.76,0),Size=UDim2.new(0.94,0,0.28,0),ZIndex=18},FS)
            C(MFR,3); S(MFR,Color3.fromRGB(255,255,255),0.975)

            local Fill=N("Frame",{BackgroundColor3=theme.Accent,BackgroundTransparency=0.5,BorderSizePixel=0,Size=UDim2.new((value-s.Min)/(s.Max-s.Min),0,1,0),ZIndex=19},MFR)
            C(Fill,3); onAccent(function(c) Fill.BackgroundColor3=c end)

            local Holding=false
            local function update(Input)
                local rel=math.clamp((Input.Position.X-MFR.AbsolutePosition.X)/MFR.AbsoluteSize.X,0,1)
                value=math.round(s.Min+(s.Max-s.Min)*rel)
                if s.Flag~="" then W.Flags[s.Flag]=value end
                ValT.Text=tostring(value).."/"..tostring(s.Max)
                tw(Fill,{Size=UDim2.new(rel,0,1,0)},0.08)
                pcall(s.Callback,value)
            end

            MFR.InputBegan:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    Holding=true; update(i); tw(TI3,{TextTransparency=0},0.1)
                end
            end)
            MFR.InputEnded:Connect(function(i)
                if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                    Holding=false; tw(TI3,{TextTransparency=0.25},0.1)
                end
            end)
            Input.InputChanged:Connect(function(i)
                if Holding and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                    update(i)
                end
            end)

            table.insert(self._items,FS)
            return {
                SetValue=function(v) v=math.clamp(v,s.Min,s.Max); value=v; local r=(v-s.Min)/(s.Max-s.Min); Fill.Size=UDim2.new(r,0,1,0); ValT.Text=tostring(v).."/"..tostring(s.Max); if s.Flag~="" then W.Flags[s.Flag]=v end; pcall(s.Callback,v) end,
                GetValue=function() return value end,
                SetVisible=function(v) FS.Visible=v end,
            }
        end

        -- ──────────────────────────────────────────────────────────────────
        --  BUTTON
        -- ──────────────────────────────────────────────────────────────────
        function Sec:NewButton(b)
            b=Cfg(b,{Title="Button",Callback=function()end})

            local FB=N("Frame",{BackgroundColor3=Color3.fromRGB(17,17,17),BackgroundTransparency=0.8,BorderSizePixel=0,Size=UDim2.new(0.95,0,0.5,0),ZIndex=17,LayoutOrder=#self._items+1},SF)
            C(FB,3); AR(FB,7); S(FB,Color3.fromRGB(255,255,255),0.95)

            local BL=N("TextLabel",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.new(0.9,0,0.5,0),Font=Enum.Font.GothamBold,Text=b.Title,TextColor3=theme.Text,TextScaled=true,TextTransparency=0.25,ZIndex=18},FB)
            Grad(BL,NumberSequence.new{NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.84,0.25),NumberSequenceKeypoint.new(1,1)},90)

            -- Accent bar left
            local AccBar=N("Frame",{AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=theme.Accent,BorderSizePixel=0,Position=UDim2.new(0,0,0.5,0),Size=UDim2.new(0,2,0.6,0),ZIndex=20},FB)
            C(AccBar,1); onAccent(function(c) AccBar.BackgroundColor3=c end)

            local Btn=N("TextButton",{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=20,Text="",Font=Enum.Font.SourceSans,TextSize=14},FB)
            local function fire()
                tw(FB,{BackgroundTransparency=0.5},0.08)
                task.delay(0.15,function() tw(FB,{BackgroundTransparency=0.8},0.15) end)
                pcall(b.Callback)
            end
            Btn.MouseButton1Click:Connect(fire)
            Btn.InputBegan:Connect(function(i) if i.UserInputType==Enum.UserInputType.Touch then fire() end end)
            Btn.MouseEnter:Connect(function() tw(BL,{TextTransparency=0},0.1) end)
            Btn.MouseLeave:Connect(function() tw(BL,{TextTransparency=0.25},0.1) end)

            table.insert(self._items,FB)
        end

        -- ──────────────────────────────────────────────────────────────────
        --  TEXTBOX
        -- ──────────────────────────────────────────────────────────────────
        function Sec:NewTextBox(tb)
            tb=Cfg(tb,{Title="TextBox",Placeholder="Type here...",Default="",Flag="",Callback=function()end})
            local value=tb.Default
            if tb.Flag~="" then W.Flags[tb.Flag]=value end

            local FTB=N("Frame",{BackgroundColor3=Color3.fromRGB(17,17,17),BackgroundTransparency=0.8,BorderSizePixel=0,Size=UDim2.new(0.95,0,0.5,0),ZIndex=17,LayoutOrder=#self._items+1},SF)
            C(FTB,3); AR(FTB,7); S(FTB,Color3.fromRGB(255,255,255),0.95)

            local TLabel=N("TextLabel",{AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1,Position=UDim2.new(0.04,0,0.5,0),Size=UDim2.new(0.4,0,0.5,0),Font=Enum.Font.GothamBold,Text=tb.Title,TextColor3=theme.Text,TextScaled=true,TextTransparency=0.25,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=18},FTB)

            local InputF=N("Frame",{AnchorPoint=Vector2.new(1,0.5),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.7,BorderSizePixel=0,Position=UDim2.new(0.97,0,0.5,0),Size=UDim2.new(0.5,0,0.55,0),ZIndex=18},FTB)
            C(InputF,3)
            local IStroke=S(InputF,Color3.fromRGB(255,255,255),0.95)

            local Box=N("TextBox",{BackgroundTransparency=1,Size=UDim2.new(1,-6,1,0),Position=UDim2.new(0,4,0,0),Font=Enum.Font.Gotham,Text=value,PlaceholderText=tb.Placeholder,PlaceholderColor3=Color3.fromRGB(120,120,130),TextColor3=theme.Text,TextScaled=true,TextXAlignment=Enum.TextXAlignment.Left,ClearTextOnFocus=false,ZIndex=19},InputF)
            Box.Focused:Connect(function()
                IStroke.Color=theme.Accent; IStroke.Transparency=0.4
                tw(InputF,{BackgroundTransparency=0.4},0.15)
            end)
            Box.FocusLost:Connect(function(enter)
                IStroke.Color=Color3.fromRGB(255,255,255); IStroke.Transparency=0.95
                tw(InputF,{BackgroundTransparency=0.7},0.15)
                value=Box.Text
                if tb.Flag~="" then W.Flags[tb.Flag]=value end
                pcall(tb.Callback,value,enter)
            end)

            table.insert(self._items,FTB)
            return {SetValue=function(v) Box.Text=v; value=v; if tb.Flag~="" then W.Flags[tb.Flag]=v end end, GetValue=function() return value end, SetVisible=function(v) FTB.Visible=v end}
        end

        -- ──────────────────────────────────────────────────────────────────
        --  DROPDOWN
        -- ──────────────────────────────────────────────────────────────────
        function Sec:NewDropdown(d)
            d=Cfg(d,{Title="Dropdown",Data={},Default="",Flag="",Callback=function()end})
            local value=d.Default
            if d.Flag~="" then W.Flags[d.Flag]=value end
            local ddOpen=false

            local FD=N("Frame",{BackgroundColor3=Color3.fromRGB(17,17,17),BackgroundTransparency=0.8,BorderSizePixel=0,Size=UDim2.new(0.95,0,0.5,0),ZIndex=17,LayoutOrder=#self._items+1},SF)
            C(FD,3); AR(FD,5); S(FD,Color3.fromRGB(255,255,255),0.95)

            local DT=N("TextLabel",{AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1,Position=UDim2.new(0.04,0,0.3,0),Size=UDim2.new(0.55,0,0.35,0),Font=Enum.Font.GothamBold,Text=d.Title,TextColor3=theme.Text,TextScaled=true,TextTransparency=0.25,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=18},FD)

            local MFD=N("Frame",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.7,BorderSizePixel=0,ClipsDescendants=true,Position=UDim2.new(0.5,0,0.72,0),Size=UDim2.new(0.94,0,0.36,0),ZIndex=18},FD)
            C(MFD,3); S(MFD,Color3.fromRGB(255,255,255),0.975)

            local VT=N("TextLabel",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.new(0.9,0,0.8,0),Font=Enum.Font.GothamBold,Text=value=="" and "Select..." or value,TextColor3=theme.Text,TextScaled=true,TextTransparency=0.4,ZIndex=19},MFD)

            -- Panel
            local Panel=N("Frame",{BackgroundColor3=Color3.fromRGB(7,7,9),BorderSizePixel=0,Position=UDim2.new(0,0,1,1),Size=UDim2.new(1,0,0,0),ZIndex=100,ClipsDescendants=true},SF)
            C(Panel,3); S(Panel,Color3.fromRGB(255,255,255),0.85)
            local PList=N("UIListLayout",{SortOrder=Enum.SortOrder.LayoutOrder,Padding=UDim.new(0,1)},Panel)

            local function closeDD()
                ddOpen=false
                tw(Panel,{Size=UDim2.new(1,0,0,0)},0.2,Enum.EasingStyle.Quint)
            end
            local function openDD()
                ddOpen=true
                local h=math.min(#d.Data*26+4,130)
                tw(Panel,{Size=UDim2.new(1,0,0,h)},0.25,Enum.EasingStyle.Quint)
            end

            for _,opt in ipairs(d.Data) do
                local OB=N("TextButton",{BackgroundColor3=Color3.fromRGB(10,10,14),BorderSizePixel=0,Size=UDim2.new(1,0,0,26),ZIndex=101,Font=Enum.Font.Gotham,Text="  "..opt,TextColor3=Color3.fromRGB(200,200,210),TextSize=12,TextXAlignment=Enum.TextXAlignment.Left},Panel)
                C(OB,2)
                OB.MouseButton1Click:Connect(function()
                    value=opt; VT.Text=opt; VT.TextTransparency=0.1
                    if d.Flag~="" then W.Flags[d.Flag]=opt end
                    pcall(d.Callback,opt); closeDD()
                end)
            end

            local Btn=N("TextButton",{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=20,Text="",Font=Enum.Font.SourceSans,TextSize=14},FD)
            Btn.MouseButton1Click:Connect(function() if ddOpen then closeDD() else openDD() end end)

            table.insert(self._items,FD)
            return {SetValue=function(v) value=v; VT.Text=v; if d.Flag~="" then W.Flags[d.Flag]=v end end, GetValue=function() return value end, SetVisible=function(v) FD.Visible=v end, Close=closeDD}
        end

        -- ──────────────────────────────────────────────────────────────────
        --  KEYBIND
        -- ──────────────────────────────────────────────────────────────────
        function Sec:NewKeybind(k)
            k=Cfg(k,{Title="Keybind",Default=Enum.KeyCode.F,Flag="",Callback=function()end})
            local bound=k.Default
            if k.Flag~="" then W.Flags[k.Flag]=bound end
            local waiting=false

            local FK=N("Frame",{BackgroundColor3=Color3.fromRGB(17,17,17),BackgroundTransparency=0.8,BorderSizePixel=0,Size=UDim2.new(0.95,0,0.5,0),ZIndex=17,LayoutOrder=#self._items+1},SF)
            C(FK,3); AR(FK,7); S(FK,Color3.fromRGB(255,255,255),0.95)

            local KT=N("TextLabel",{AnchorPoint=Vector2.new(0,0.5),BackgroundTransparency=1,Position=UDim2.new(0.04,0,0.5,0),Size=UDim2.new(0.65,0,0.5,0),Font=Enum.Font.GothamBold,Text=k.Title,TextColor3=theme.Text,TextScaled=true,TextTransparency=0.25,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=18},FK)

            local KBox=N("Frame",{AnchorPoint=Vector2.new(1,0.5),BackgroundColor3=Color3.new(0,0,0),BackgroundTransparency=0.65,BorderSizePixel=0,Position=UDim2.new(0.97,0,0.5,0),Size=UDim2.new(0,50,0.6,0),ZIndex=18},FK)
            C(KBox,4); S(KBox,Color3.fromRGB(255,255,255),0.95)

            local KLbl=N("TextLabel",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.new(0.9,0,0.7,0),Font=Enum.Font.GothamBold,Text=Input:GetStringForKeyCode(bound) or bound.Name,TextColor3=theme.Text,TextScaled=true,TextTransparency=0.5,ZIndex=19},KBox)

            local function updateSize()
                local sz=TextServ:GetTextSize(KLbl.Text,12,Enum.Font.GothamBold,Vector2.new(math.huge,math.huge))
                tw(KBox,{Size=UDim2.new(0,sz.X+10,0.6,0)},0.15)
            end

            local Btn=N("TextButton",{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=20,Text="",Font=Enum.Font.SourceSans,TextSize=14},FK)
            local BindEvent=N("BindableEvent",{})
            Btn.MouseButton1Click:Connect(function()
                if waiting then return end; waiting=true
                KLbl.Text="..."; updateSize()
                local con=Input.InputBegan:Connect(function(key)
                    if key.KeyCode and key.KeyCode~=Enum.KeyCode.Unknown then
                        BindEvent:Fire(key.KeyCode)
                    end
                end)
                bound=BindEvent.Event:Wait(); con:Disconnect()
                KLbl.Text=Input:GetStringForKeyCode(bound) or bound.Name
                updateSize(); waiting=false
                if k.Flag~="" then W.Flags[k.Flag]=bound end
                pcall(k.Callback,bound)
            end)
            updateSize()

            table.insert(self._items,FK)
            return {SetKey=function(v) bound=v; KLbl.Text=v.Name; updateSize(); if k.Flag~="" then W.Flags[k.Flag]=v end end, GetKey=function() return bound end, SetVisible=function(v) FK.Visible=v end}
        end

        -- ──────────────────────────────────────────────────────────────────
        --  COLOR PICKER
        -- ──────────────────────────────────────────────────────────────────
        function Sec:NewColorPicker(cfg2)
            cfg2=Cfg(cfg2,{Title="Color",Default=Color3.fromRGB(255,0,0),Flag="",Callback=function()end})
            local hue,sat,val2=Color3.toHSV(cfg2.Default)
            local currentColor=cfg2.Default
            local pickerOpen=false; local rainbow=false; local rainbowConn
            if cfg2.Flag~="" then W.Flags[cfg2.Flag]=currentColor end

            local FCP=N("Frame",{BackgroundColor3=Color3.fromRGB(10,10,13),BackgroundTransparency=0.1,BorderSizePixel=0,Size=UDim2.new(0.95,0,0.5,0),ClipsDescendants=true,ZIndex=17,LayoutOrder=#self._items+1},SF)
            C(FCP,3); AR(FCP,8)

            local CPT=N("TextLabel",{BackgroundTransparency=1,AnchorPoint=Vector2.new(0,0.5),Position=UDim2.new(0.035,0,0.5,0),Size=UDim2.new(0.6,0,0.5,0),Font=Enum.Font.GothamBold,Text=cfg2.Title,TextColor3=theme.Text,TextScaled=true,TextTransparency=0.2,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=18},FCP)

            local SW=N("Frame",{AnchorPoint=Vector2.new(1,0.5),Position=UDim2.new(0.97,0,0.5,0),Size=UDim2.new(0.18,0,0.62,0),BackgroundColor3=currentColor,BorderSizePixel=0,ZIndex=18},FCP)
            C(SW,3); S(SW,Color3.fromRGB(255,255,255),0.65)

            local CA=N("Frame",{AnchorPoint=Vector2.new(0,0.5),BackgroundColor3=currentAccent,BorderSizePixel=0,Position=UDim2.new(0,0,0.5,0),Size=UDim2.new(0,2,0.6,0),ZIndex=20},FCP)
            C(CA,1); onAccent(function(c) CA.BackgroundColor3=c end)

            local Panel2=N("Frame",{BackgroundColor3=Color3.fromRGB(8,8,11),BorderSizePixel=0,Position=UDim2.new(0,0,1,2),Size=UDim2.new(1,0,0,0),ZIndex=16,ClipsDescendants=true},FCP)
            C(Panel2,3)

            local HSV=N("ImageButton",{BackgroundTransparency=1,Position=UDim2.new(0.03,0,0.05,0),Size=UDim2.new(0.62,0,0.88,0),Image="rbxassetid://6523286724",ZIndex=17},Panel2)
            C(HSV,3)
            local SVC=N("Frame",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0,Size=UDim2.new(0,10,0,10),ZIndex=20},HSV)
            C(SVC,5); S(SVC,Color3.new(0,0,0),0)

            local HB=N("ImageButton",{BackgroundTransparency=1,Position=UDim2.new(0.68,0,0.05,0),Size=UDim2.new(0.12,0,0.88,0),Image="rbxassetid://6523291212",ZIndex=17},Panel2)
            C(HB,3)
            local HC=N("Frame",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundColor3=Color3.fromRGB(255,255,255),BorderSizePixel=0,Size=UDim2.new(1.3,0,0,5),ZIndex=20},HB)
            C(HC,2); S(HC,Color3.new(0,0,0),0)

            local RB=N("TextButton",{BackgroundColor3=Color3.fromRGB(14,14,18),BorderSizePixel=0,Position=UDim2.new(0.83,0,0.05,0),Size=UDim2.new(0.14,0,0.42,0),ZIndex=18,Font=Enum.Font.GothamBold,Text="🌈",TextScaled=true},Panel2)
            C(RB,3); S(RB,Color3.fromRGB(255,255,255),0.85)

            local function updateColor()
                currentColor=Color3.fromHSV(hue,sat,val2); SW.BackgroundColor3=currentColor
                if cfg2.Flag~="" then W.Flags[cfg2.Flag]=currentColor end; pcall(cfg2.Callback,currentColor)
            end
            local function updateCursors()
                SVC.Position=UDim2.new(sat,0,1-val2,0); HC.Position=UDim2.new(0.5,0,1-hue,0)
            end

            local dragSV,dragHue=false,false
            local mouse=LP:GetMouse()
            mouse.Move:Connect(function()
                if dragSV then
                    sat=math.clamp((mouse.X-HSV.AbsolutePosition.X)/HSV.AbsoluteSize.X,0,1)
                    val2=1-math.clamp((mouse.Y-HSV.AbsolutePosition.Y)/HSV.AbsoluteSize.Y,0,1)
                    SVC.Position=UDim2.new(sat,0,1-val2,0); updateColor()
                end
                if dragHue then
                    hue=1-math.clamp((mouse.Y-HB.AbsolutePosition.Y)/HB.AbsoluteSize.Y,0,1)
                    HC.Position=UDim2.new(0.5,0,1-hue,0); updateColor()
                end
            end)
            HSV.MouseButton1Down:Connect(function() dragSV=true end)
            HB.MouseButton1Down:Connect(function() dragHue=true end)
            Input.InputEnded:Connect(function(i) if i.UserInputType==Enum.UserInputType.MouseButton1 then dragSV=false; dragHue=false end end)
            RB.MouseButton1Click:Connect(function()
                rainbow=not rainbow
                tw(RB,{BackgroundColor3=rainbow and Color3.fromRGB(25,15,35) or Color3.fromRGB(14,14,18)},0.15)
                if rainbow then
                    local cnt=0
                    rainbowConn=Run.RenderStepped:Connect(function()
                        cnt=(cnt+0.004)%1; hue=cnt; sat=1; val2=1; updateColor(); updateCursors()
                    end)
                elseif rainbowConn then rainbowConn:Disconnect() end
            end)

            N("TextButton",{BackgroundTransparency=1,Size=UDim2.new(1,0,1,0),ZIndex=19,Text="",Font=Enum.Font.SourceSans,TextSize=14},FCP).MouseButton1Click:Connect(function()
                pickerOpen=not pickerOpen
                tw(Panel2,{Size=UDim2.new(1,0,0,pickerOpen and 90 or 0)},0.25,Enum.EasingStyle.Quint)
                if pickerOpen then updateCursors() end
            end)
            updateCursors()

            table.insert(self._items,FCP)
            local CPF={}
            function CPF:SetColor(c) hue,sat,val2=Color3.toHSV(c); currentColor=c; SW.BackgroundColor3=c; updateCursors() end
            function CPF:GetColor() return currentColor end
            function CPF:SetVisible(v) FCP.Visible=v end
            return CPF
        end

        -- ──────────────────────────────────────────────────────────────────
        --  LABEL
        -- ──────────────────────────────────────────────────────────────────
        function Sec:NewLabel(text)
            local FL=N("Frame",{BackgroundTransparency=1,BorderSizePixel=0,Size=UDim2.new(0.95,0,0.5,0),ZIndex=17,LayoutOrder=#self._items+1},SF)
            AR(FL,12)
            local L=N("TextLabel",{AnchorPoint=Vector2.new(0.5,0.5),BackgroundTransparency=1,Position=UDim2.new(0.5,0,0.5,0),Size=UDim2.new(0.92,0,0.7,0),Font=Enum.Font.Gotham,Text=text,TextColor3=theme.Text,TextScaled=true,TextTransparency=0.5,ZIndex=18},FL)
            table.insert(self._items,FL)
            return {SetText=function(t) L.Text=t end, SetVisible=function(v) FL.Visible=v end}
        end

        table.insert(tab.Sections,Sec)
        return Sec
    end

    -- ── Window-level Notify ─────────────────────────────────────────────────
    W.Notify = Notify

    -- ── Keybind change ──────────────────────────────────────────────────────
    function W:SetKeybind(k) self._keybind=k end

    -- ── Destroy ─────────────────────────────────────────────────────────────
    function W:Destroy()
        SGui:Destroy(); _nGui:Destroy()
        getgenv().NexusUI=nil
    end

    -- ── Accent API ──────────────────────────────────────────────────────────
    function W:SetAccent(c) setAccent(c); theme.Accent=c; MStroke.Color=c end
    function W:GetAccent() return currentAccent end

    -- ── Config API ──────────────────────────────────────────────────────────
    W.Config = ConfigAPI

    -- ── Watermark API ───────────────────────────────────────────────────────
    W.SetWatermark = SetWatermark

    -- Startup tween
    tw(MF,{BackgroundTransparency=0.08,Size=config.Size},0.7,Enum.EasingStyle.Quint)

    print("[ NexusUI v3.0 ] Ready  |  Keybind: "..tostring(config.Keybind))
    return W
end


-- ─── Public API ──────────────────────────────────────────────────────────────
local NexusUI = {
    new          = NewWindow,
    Notify       = Notify,
    SetWatermark = SetWatermark,
    Themes       = Themes,
    Config       = ConfigAPI,
    Version      = "3.0",
}

-- ══════════════════════════════════════════════════════════════════════════════
--  TEST SCRIPT
-- ══════════════════════════════════════════════════════════════════════════════
-- ─── สร้าง Window ─────────────────────────────────────────────────────────
local W = NexusUI.new({
    Title       = "NexusUI",
    Description = "v3.0 Test",
    Keybind     = Enum.KeyCode.RightShift,
    Theme       = "Purple",   -- Obsidian / Purple / Blood / Ocean / Midnight / Grape / Sentinel / Serpent / Gold
})

-- ─── Watermark ────────────────────────────────────────────────────────────
local WM = W.SetWatermark({
    Text     = "NexusUI v3.0",
    ShowFPS  = true,
    ShowPing = true,
})

-- ══════════════════════════════════════════════
--  TAB 1 : Combat
-- ══════════════════════════════════════════════
local tabCombat = W:AddTab({ Title = "Combat" })

-- Section: Aimbot  (Left column)
local secAimbot = W:AddSection(tabCombat, { Title = "Aimbot", Position = "Left" })

secAimbot:NewToggle({
    Title    = "Enable Aimbot",
    Default  = false,
    Flag     = "aimbot_on",
    Callback = function(v) print("[Aimbot]", v) end,
})
secAimbot:NewToggle({
    Title    = "Silent Aim",
    Default  = false,
    Flag     = "silent_aim",
    Callback = function(v) print("[Silent Aim]", v) end,
})
secAimbot:NewSlider({
    Title    = "FOV",
    Min      = 10,
    Max      = 360,
    Default  = 90,
    Flag     = "aimbot_fov",
    Callback = function(v) print("[FOV]", v) end,
})
secAimbot:NewSlider({
    Title    = "Smoothness",
    Min      = 1,
    Max      = 100,
    Default  = 30,
    Flag     = "aimbot_smooth",
    Callback = function(v) print("[Smooth]", v) end,
})
secAimbot:NewKeybind({
    Title    = "Aimbot Key",
    Default  = Enum.KeyCode.E,
    Flag     = "aimbot_key",
    Callback = function(k) print("[Aimbot Key]", k) end,
})

-- Section: Target (Right column)
local secTarget = W:AddSection(tabCombat, { Title = "Target", Position = "Right" })

secTarget:NewToggle({ Title="Team Check",    Default=true,  Flag="team_check",  Callback=function(v) print("[Team Check]",v) end })
secTarget:NewToggle({ Title="Visible Check", Default=false, Flag="vis_check",   Callback=function(v) print("[Vis Check]",v) end })
secTarget:NewToggle({ Title="Through Walls", Default=false, Flag="walls",       Callback=function(v) print("[Walls]",v) end })
secTarget:NewDropdown({
    Title    = "Hit Part",
    Data     = { "Head", "Torso", "UpperTorso", "LowerTorso" },
    Default  = "Head",
    Flag     = "hit_part",
    Callback = function(v) print("[Hit Part]", v) end,
})
secTarget:NewButton({
    Title    = "Reset Combat",
    Callback = function()
        W:Notify({ Title="Combat", Message="Settings reset!", Type="Success", Duration=3 })
    end,
})

-- ══════════════════════════════════════════════
--  TAB 2 : Visuals
-- ══════════════════════════════════════════════
local tabVisuals = W:AddTab({ Title = "Visuals" })

local secESP = W:AddSection(tabVisuals, { Title = "ESP", Position = "Left" })
secESP:NewToggle({ Title="Player ESP",  Default=false, Flag="esp_player", Callback=function(v) print("[ESP]",v) end })
secESP:NewToggle({ Title="Box ESP",     Default=false, Flag="esp_box" })
secESP:NewToggle({ Title="Health Bar",  Default=false, Flag="esp_hp" })
secESP:NewToggle({ Title="Name Tag",    Default=true,  Flag="esp_name" })
secESP:NewSlider({ Title="Render Distance", Min=50, Max=2000, Default=500, Flag="esp_dist" })
secESP:NewColorPicker({
    Title    = "ESP Color",
    Default  = Color3.fromRGB(255, 80, 80),
    Flag     = "esp_color",
    Callback = function(c) print("[ESP Color]", c) end,
})

local secChams = W:AddSection(tabVisuals, { Title = "Chams", Position = "Right" })
secChams:NewToggle({ Title="Enable Chams", Default=false, Flag="chams_on" })
secChams:NewToggle({ Title="Visible Only", Default=true,  Flag="chams_vis" })
secChams:NewColorPicker({
    Title    = "Chams Color",
    Default  = Color3.fromRGB(0, 200, 255),
    Flag     = "chams_color",
})
secChams:NewButton({
    Title    = "Refresh ESP",
    Callback = function()
        W:Notify({ Title="Visuals", Message="ESP Refreshed!", Type="Info", Duration=3 })
    end,
})

-- ══════════════════════════════════════════════
--  TAB 3 : Movement
-- ══════════════════════════════════════════════
local tabMove = W:AddTab({ Title = "Movement" })

local secSpeed = W:AddSection(tabMove, { Title = "Speed & Fly", Position = "Left" })
secSpeed:NewToggle({
    Title    = "Speed Hack",
    Default  = false,
    Flag     = "speed_on",
    Callback = function(v)
        local char = game.Players.LocalPlayer.Character
        if char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum.WalkSpeed = v and (W.Flags.speed_val or 50) or 16 end
        end
    end,
})
secSpeed:NewSlider({
    Title    = "Walk Speed",
    Min      = 16,
    Max      = 300,
    Default  = 50,
    Flag     = "speed_val",
    Callback = function(v)
        if W.Flags.speed_on then
            local char = game.Players.LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = v end
            end
        end
    end,
})
secSpeed:NewToggle({ Title="Fly Hack", Default=false, Flag="fly_on" })
secSpeed:NewSlider({ Title="Fly Speed", Min=10, Max=200, Default=60, Flag="fly_speed" })

local secMisc2 = W:AddSection(tabMove, { Title = "Other", Position = "Right" })
secMisc2:NewToggle({
    Title    = "Infinite Jump",
    Default  = false,
    Flag     = "inf_jump",
    Callback = function(v)
        if v then
            getgenv()._ijCon = game:GetService("UserInputService").JumpRequest:Connect(function()
                if W.Flags.inf_jump then
                    local c=game.Players.LocalPlayer.Character
                    if c then local h=c:FindFirstChildOfClass("Humanoid"); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
                end
            end)
        else
            if getgenv()._ijCon then getgenv()._ijCon:Disconnect() end
        end
    end,
})
secMisc2:NewToggle({ Title="No Clip", Default=false, Flag="noclip" })
secMisc2:NewToggle({ Title="Anti-AFK", Default=true, Flag="anti_afk" })

-- ══════════════════════════════════════════════
--  TAB 4 : Misc
-- ══════════════════════════════════════════════
local tabMisc = W:AddTab({ Title = "Misc" })

local secGen = W:AddSection(tabMisc, { Title = "General", Position = "Left" })
secGen:NewTextBox({
    Title       = "Custom Tag",
    Placeholder = "Enter tag...",
    Default     = "",
    Flag        = "custom_tag",
    Callback    = function(v) print("[Tag]", v) end,
})
secGen:NewTextBox({
    Title       = "Discord",
    Placeholder = "discord.gg/...",
    Default     = "",
    Flag        = "discord",
})
secGen:NewLabel("RightShift = Toggle GUI")
secGen:NewButton({
    Title    = "Test All Notify Types",
    Callback = function()
        W:Notify({ Title="Info",    Message="This is an info message",    Type="Info",    Duration=3 })
        task.wait(0.5)
        W:Notify({ Title="Success", Message="Operation successful!",       Type="Success", Duration=3 })
        task.wait(0.5)
        W:Notify({ Title="Warning", Message="This is a warning!",          Type="Warning", Duration=3 })
        task.wait(0.5)
        W:Notify({ Title="Error",   Message="Something went wrong.",       Type="Error",   Duration=3 })
    end,
})

local secSettings = W:AddSection(tabMisc, { Title = "Settings", Position = "Right" })
secSettings:NewButton({
    Title    = "Print All Flags",
    Callback = function()
        print("\n─── NexusUI Flags ───")
        for k,v in pairs(W.Flags) do
            print(string.format("  %-22s = %s", k, tostring(v)))
        end
        print("─────────────────────\n")
    end,
})
secSettings:NewButton({
    Title    = "Save Config",
    Callback = function()
        W.Config:Save("test", W.Flags)
        W:Notify({ Title="Config", Message="Config saved!", Type="Success", Duration=3 })
    end,
})
secSettings:NewButton({
    Title    = "Load Config",
    Callback = function()
        local data = W.Config:Load("test")
        if data then
            for k,v in pairs(data) do W.Flags[k]=v end
            W:Notify({ Title="Config", Message="Config loaded!", Type="Success", Duration=3 })
        else
            W:Notify({ Title="Config", Message="No config found.", Type="Warning", Duration=3 })
        end
    end,
})
secSettings:NewButton({
    Title    = "Change Theme → Ocean",
    Callback = function()
        W:SetAccent(Color3.fromRGB(86,120,251))
        W:Notify({ Title="Theme", Message="Switched to Ocean accent!", Type="Info", Duration=3 })
    end,
})
secSettings:NewButton({
    Title    = "Unload",
    Callback = function()
        W:Notify({ Title="NexusUI", Message="Unloading in 2s...", Type="Warning", Duration=2 })
        task.delay(2, function() W:Destroy() end)
    end,
})

-- ─── Startup notification ─────────────────────────────────────────────────
task.spawn(function()
    task.wait(1)
    W:Notify({
        Title    = "NexusUI v3.0",
        Message  = "Loaded! RightShift = toggle GUI",
        Type     = "Success",
        Duration = 5,
    })
end)

print("[NexusUI] Test script loaded!")
