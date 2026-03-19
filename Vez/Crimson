getgenv().AutoClearLogsDelay = 99999
--// How many seconds to wait before logs are automatically cleared
getgenv().BlockedAnimations = {"Animation1", "Animation2", "RunAnim", "WalkAnim"}
--// Animations to block from logging

getgenv().ChosenTargetFolder = nil
--[[ 
    In ChosenTargetFolder, change nil to destination folder
    to start logging the animations of all models with a
    humanoid within that folder when using 'Log: Others' option
    Otherwise it will not allow you to select 'Log: Others'
]]--

--// UI by moonroon - specifically made for this script.
local UI = {}
UI._tabs = {}
UI._selected = nil
UI._actionButtons = {}
UI._lines = {}
UI._logOrder = 0
UI._stacking = false

local collapseStacks
local expandStacks
local tabFingerprint

if getgenv().Frame1Gui and getgenv().Frame1Gui.Parent then
    getgenv().Frame1Gui:Destroy()
end

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function create(class, parent, props)
    local inst = Instance.new(class, parent)
    for k, v in pairs(props) do
        if k == "Attributes" then
            for ak, av in pairs(v) do
                inst:SetAttribute(ak, av)
            end
        else
            inst[k] = v
        end
    end
    return inst
end
local function roboto(weight, style)
    return Font.new("rbxasset://fonts/families/Roboto.json", weight or Enum.FontWeight.Bold, style or Enum.FontStyle.Normal)
end
local function mono(weight, style)
    return Font.new("rbxasset://fonts/families/RobotoMono.json", weight or Enum.FontWeight.Regular, style or Enum.FontStyle.Normal)
end
local function source()
    return Font.new("rbxasset://fonts/families/SourceSansPro.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
end
local function corner(parent, r)
    return create("UICorner", parent, { CornerRadius = UDim.new(unpack(r or {0, 4})) })
end
local function stroke(parent, props, position)
    local defaultProps = props or { Transparency = 0.92, Color = Color3.fromRGB(255, 255, 255) }
    defaultProps.BorderStrokePosition = position or Enum.BorderStrokePosition.Outer
    return create("UIStroke", parent, defaultProps)
end

local function hover(parent, r)
    local h = create("Frame", parent, {
        Name = "hover",
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
    })
    corner(h, r)
    return h
end

local function invisButton(parent)
    return create("TextButton", parent, {
        BorderSizePixel = 0,
        TextTransparency = 1,
        TextSize = 14,
        TextColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = source(),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
    })
end

local function makeToggle(parent, label, active)
    local t = {}
    t._inst = create("Frame", parent, {
        Name = "toggle" .. label:lower(),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(23, 11, 11),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 65, 1, -8),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
    })
    corner(t._inst)
    stroke(t._inst)
    local contain = create("Frame", t._inst, {
        Name = "contain",
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 10, 0, 10),
        Position = UDim2.new(0, 5, 0.5, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
    })
    t.circle = create("Frame", contain, {
        Name = "circle",
        BorderSizePixel = 0,
        BackgroundColor3 = active and Color3.fromRGB(0, 171, 0) or Color3.fromRGB(51, 51, 51),
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 8, 0, 8),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
    })
    corner(t.circle, {1, 0})
    create("UIListLayout", contain, {
        Padding = UDim.new(0, 4),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        FillDirection = Enum.FillDirection.Horizontal,
    })
    create("TextLabel", contain, {
        BorderSizePixel = 0,
        TextSize = 11,
        TextTransparency = 0.32,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = roboto(Enum.FontWeight.Regular),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = label,
        AutomaticSize = Enum.AutomaticSize.XY,
    })
    t.active = active
    t.button = invisButton(t._inst)
    hover(t._inst)
    t.button.MouseButton1Click:Connect(function()
        t.active = not t.active
        TweenService:Create(t.circle, TweenInfo.new(0.15), {
            BackgroundColor3 = t.active and Color3.fromRGB(0, 171, 0) or Color3.fromRGB(51, 51, 51)
        }):Play()
    end)
    t.button.MouseEnter:Connect(function()
        TweenService:Create(t._inst:FindFirstChild("hover"), TweenInfo.new(0.12), { BackgroundTransparency = 0.92 }):Play()
    end)
    t.button.MouseLeave:Connect(function()
        TweenService:Create(t._inst:FindFirstChild("hover"), TweenInfo.new(0.12), { BackgroundTransparency = 1 }):Play()
    end)
    return t
end

local function makeActionButton(parent, label, order, size, opts)
    opts = opts or {}
    local t = {}
    t._inst = create("Frame", parent, {
        Name = label:lower():gsub(" ", ""),
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(154, 0, 0),
        Size = size or UDim2.new(0, 100, 1, -20),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        LayoutOrder = order,
        BackgroundTransparency = opts.transparent and 1 or 0,
    })
    corner(t._inst)
    t.label = create("TextLabel", t._inst, {
        BorderSizePixel = 0,
        TextSize = 14,
        TextTransparency = 0.16,
        TextStrokeColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = roboto(),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = label,
        AutomaticSize = Enum.AutomaticSize.XY,
        Position = UDim2.new(0.5, 0, 0.5, 0),
    })
    t.button = invisButton(t._inst)
    t._stroke = stroke(t._inst, { Color = Color3.fromRGB(46, 54, 67), Transparency = opts.strokeTransparency or 0 })
    t._hover = hover(t._inst)
    t.button.MouseEnter:Connect(function()
        TweenService:Create(t._hover, TweenInfo.new(0.12), { BackgroundTransparency = 0.92 }):Play()
    end)
    t.button.MouseLeave:Connect(function()
        TweenService:Create(t._hover, TweenInfo.new(0.12), { BackgroundTransparency = 1 }):Play()
    end)
    return t
end
-- 
UI.screenGui = create("ScreenGui", cloneref(game:GetService("CoreGui")), {
    Name = "Frame 1",
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
getgenv().Frame1Gui = UI.screenGui

UI.background = {}
UI.background._inst = create("Frame", UI.screenGui, {
    Name = "Background",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(0, 676, 0, 451),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Attributes = { Id = "122_6" },
})

create("UIAspectRatioConstraint", UI.background._inst, { AspectRatio = 1.49889 })

UI.background.backImage = create("ImageLabel", UI.background._inst, {
    Name = "back",
    ZIndex = 0,
    Image = "rbxassetid://108453875048733",
    Size = UDim2.new(0, 725, 0, 500),
    BackgroundTransparency = 1,
    Position = UDim2.new(0, -24, 0, -24),
    Attributes = { Id = "rbxassetid://108453875048733" },
})

UI.background.top = {}
UI.background.top._inst = create("ImageLabel", UI.background._inst, {
    Name = "top",
    Image = "rbxassetid://82686076130111",
    Size = UDim2.new(0, 676, 0, 30),
    BackgroundTransparency = 1,
    Attributes = { Id = "rbxassetid://82686076130111" },
})

UI.background.top.left = create("Frame", UI.background.top._inst, {
    Name = "layout1",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, 8, 0, 0),
    BorderColor3 = Color3.fromRGB(0, 0, 0),
})

create("UIListLayout", UI.background.top.left, {
    Padding = UDim.new(0, 8),
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
    FillDirection = Enum.FillDirection.Horizontal,
})

UI.background.top.iconWrap = create("Frame", UI.background.top.left, {
    Name = "iconWrap",
    BorderSizePixel = 0,
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 20, 0, 20),
    BorderColor3 = Color3.fromRGB(0, 0, 0),
})

UI.background.top.offIcon = create("ImageLabel", UI.background.top.iconWrap, {
    Name = "OFF",
    ZIndex = 3,
    Image = "rbxassetid://95222964296464",
    Size = UDim2.new(0, 12, 0, 12),
    Visible = true,
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Attributes = { Id = "rbxassetid://95222964296464" },
})

UI.background.top.onIcon = create("ImageLabel", UI.background.top.iconWrap, {
    Name = "ON",
    ZIndex = 4,
    Image = "rbxassetid://114069756293603",
    Size = UDim2.new(0, 20, 0, 20),
    Visible = false,
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Attributes = { Id = "rbxassetid://114069756293603" },
})

for _, info in ipairs({
    { name = "title", text = "CRIMSON",          color = Color3.fromRGB(255, 255, 255), order = 1 },
    { name = "dash",  text = "-",                color = Color3.fromRGB(255, 255, 255), order = 2 },
    { name = "ani",   text = "Animation Logger", color = Color3.fromRGB(226, 68, 68),  order = 3 },
    { name = "vez",   text = "By Vez",           color = Color3.fromRGB(255, 255, 255), order = 4,
      size = 12, transparency = 0.58, weight = Enum.FontWeight.Regular, style = Enum.FontStyle.Italic },
}) do
    create("TextLabel", UI.background.top.left, {
        Name = info.name,
        BorderSizePixel = 0,
        TextSize = info.size or 14,
        TextTransparency = info.transparency or 0.24,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = roboto(info.weight or Enum.FontWeight.Bold, info.style or Enum.FontStyle.Normal),
        TextColor3 = info.color,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = info.text,
        LayoutOrder = info.order,
        AutomaticSize = Enum.AutomaticSize.X,
    })
end

UI.background.top.right = create("Frame", UI.background.top._inst, {
    Name = "layout2",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 1, 0),
    Position = UDim2.new(0, -8, 0, 0),
    BorderColor3 = Color3.fromRGB(0, 0, 0),
})

create("UIListLayout", UI.background.top.right, {
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    Padding = UDim.new(0, 10),
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
    FillDirection = Enum.FillDirection.Horizontal,
})

UI.background.top.logToggle = makeToggle(UI.background.top.right, "Logging", false)
UI.background.top.stackToggle = makeToggle(UI.background.top.right, "Stacking", false)
UI.background.top.stackDo = makeToggle(UI.background.top.right, "Stack: ID", false)

UI.background.top.logToggle.button.MouseButton1Click:Connect(function()
    local active = UI.background.top.logToggle.active
    UI.background.top.onIcon.Visible = not active
    UI.background.top.offIcon.Visible = active
    if not active then
        UI.onLoggingEnabled()
    else
        UI.onLoggingDisabled()
    end
end)

UI.background.top.stackToggle.button.MouseButton1Click:Connect(function()
    local active = UI.background.top.stackToggle.active
    UI._stacking = not active
    if not active then
        collapseStacks()
    else
        expandStacks()
    end
end)

UI.background.top.stackDo.button.MouseButton1Click:Connect(function()
    local active = UI.background.top.stackDo.active
    tabFingerprint = (not active) and function(tab)
        return tab._data.id
    end or function(tab)
        local parts = { tab._data.id, tab._data.name, tab._data.length, tab._data.priority }
        for _, row in ipairs(tab._data.propRows) do
            table.insert(parts, row.name .. "=" .. row.value)
        end
        return table.concat(parts, "|")
    end
    collapseStacks()
end)

local dragging = false
local dragStart = nil
local startPos = nil
local dragTweenInfo = TweenInfo.new(0.08, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

UI.background.top._inst.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = UI.background._inst.Position
    end
end)

UI.background.top._inst.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
        TweenService:Create(UI.background._inst, dragTweenInfo, { Position = targetPos }):Play()
    end
end)

UI.background.contain = {}
UI.background.contain._inst = create("Frame", UI.background._inst, {
    Name = "contain",
    ZIndex = 2,
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(218, 218, 218),
    BackgroundTransparency = 0.9999,
    Size = UDim2.new(0, 676, 0, 451),
    Attributes = { Id = "125_92" },
})

UI.background.contain.left = {}
UI.background.contain.left._inst = create("Frame", UI.background.contain._inst, {
    Name = "left",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 238, 0, 421),
    Position = UDim2.new(0, 0, 0, 30),
    BorderColor3 = Color3.fromRGB(0, 0, 0),
})

create("Frame", UI.background.contain.left._inst, {
    Name = "line",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(23, 23, 23),
    AnchorPoint = Vector2.new(1, 0.5),
    Size = UDim2.new(0, 1, 1, 0),
    Position = UDim2.new(1, 0, 0.5, 0),
    BorderColor3 = Color3.fromRGB(0, 0, 0),
})

UI.background.contain.left.header = create("Frame", UI.background.contain.left._inst, {
    Name = "text",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, -0.11876, 100),
    BorderColor3 = Color3.fromRGB(0, 0, 0),
})

create("TextLabel", UI.background.contain.left.header, {
    BorderSizePixel = 0,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTransparency = 0.66,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    FontFace = mono(),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0, 0.5),
    Size = UDim2.new(0, 200, 0, 50),
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    Text = "Logged Assets",
    Position = UDim2.new(0, 15, 0.5, 0),
})

create("Frame", UI.background.contain.left.header, {
    Name = "line",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(23, 23, 23),
    AnchorPoint = Vector2.new(0.5, 1),
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0.5, 0, 1, 0),
    BorderColor3 = Color3.fromRGB(0, 0, 0),
})

local leftInner = create("Frame", UI.background.contain.left._inst, {
    Name = "contain",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 236, 0, 322),
    Position = UDim2.new(0, 0, 0.11876, 0),
    BorderColor3 = Color3.fromRGB(0, 0, 0),
})

UI.background.contain.left.scrollFrame = create("ScrollingFrame", leftInner, {
    Active = true,
    ScrollingDirection = Enum.ScrollingDirection.Y,
    BorderSizePixel = 0,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    AnchorPoint = Vector2.new(0.5, 0.5),
    AutomaticCanvasSize = Enum.AutomaticSize.Y,
    Size = UDim2.new(1, -20, 1, -20),
    ScrollBarImageColor3 = Color3.fromRGB(0, 0, 0),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    ScrollBarThickness = 0,
    BackgroundTransparency = 1,
})

create("UIListLayout", UI.background.contain.left.scrollFrame, {
    HorizontalAlignment = Enum.HorizontalAlignment.Center,
    Padding = UDim.new(0, 0),
    SortOrder = Enum.SortOrder.LayoutOrder,
})

UI.background.contain.center = {}
UI.background.contain.center._inst = create("Frame", UI.background.contain._inst, {
    Name = "center",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(11, 11, 11),
    Size = UDim2.new(0, 438, 0, 363),
    Position = UDim2.new(0.35207, 0, 0.06652, 0),
    BorderColor3 = Color3.fromRGB(0, 0, 0),
})

UI.background.contain.center._inner = create("CanvasGroup", UI.background.contain.center._inst, {
    Name = "contain",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    GroupTransparency = 0,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(1, -30, 1, -30),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BorderColor3 = Color3.fromRGB(0, 0, 0),
})

UI.background.contain.center._layout = create("UIListLayout", UI.background.contain.center._inner, {
    Padding = UDim.new(0, 10),
    SortOrder = Enum.SortOrder.LayoutOrder,
})

UI.background.contain.center._nameBlock = create("Frame", UI.background.contain.center._inner, {
    Name = "prop",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 159, 0, 58),
    BorderColor3 = Color3.fromRGB(0, 0, 0),
})

create("UIListLayout", UI.background.contain.center._nameBlock, { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder })

create("TextLabel", UI.background.contain.center._nameBlock, {
    Name = "prop",
    BorderSizePixel = 0,
    TextSize = 15,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextTransparency = 0.45,
    TextYAlignment = Enum.TextYAlignment.Top,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    FontFace = mono(),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    Text = "Name",
    AutomaticSize = Enum.AutomaticSize.XY,
})

UI.background.contain.center._nameValue = create("TextLabel", UI.background.contain.center._nameBlock, {
    Name = "value",
    BorderSizePixel = 0,
    TextSize = 24,
    TextXAlignment = Enum.TextXAlignment.Left,
    TextYAlignment = Enum.TextYAlignment.Top,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    FontFace = roboto(Enum.FontWeight.Regular),
    TextColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    BorderColor3 = Color3.fromRGB(0, 0, 0),
    Text = "Press Logging to start!",
    AutomaticSize = Enum.AutomaticSize.XY,
})

local propsRow = create("Frame", UI.background.contain.center._inner, {
    Name = "contain",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    Size = UDim2.new(0, 159, 0, 58),
    BorderColor3 = Color3.fromRGB(0, 0, 0),
})

create("UIListLayout", propsRow, {
    Padding = UDim.new(0, 30),
    SortOrder = Enum.SortOrder.LayoutOrder,
    FillDirection = Enum.FillDirection.Horizontal,
})

local function makePropBlockInst(parent, label, value, size)
    local frame = create("Frame", parent, {
        Name = "prop",
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        Size = size or UDim2.new(0, 159, 0, 68),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
    })
    create("TextLabel", frame, {
        Name = "prop",
        BorderSizePixel = 0,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextTransparency = 0.45,
        TextYAlignment = Enum.TextYAlignment.Top,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = mono(),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = label,
        AutomaticSize = Enum.AutomaticSize.XY,
    })
    create("UIListLayout", frame, { Padding = UDim.new(0, 5), SortOrder = Enum.SortOrder.LayoutOrder })
    local val = create("TextLabel", frame, {
        Name = "value",
        BorderSizePixel = 0,
        TextSize = 24,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = roboto(Enum.FontWeight.Regular),
        TextColor3 = Color3.fromRGB(255, 255, 255),
        BackgroundTransparency = 1,
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = value,
        AutomaticSize = Enum.AutomaticSize.XY,
    })
    return val
end

UI.background.contain.center._lengthValue = makePropBlockInst(propsRow, "Length", "0:00:0")
UI.background.contain.center._priorityValue = makePropBlockInst(propsRow, "Priority", "Action")

UI.background.contain.center._line = create("Frame", UI.background.contain.center._inner, {
    Name = "line",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(23, 23, 23),
    Size = UDim2.new(1, 0, 0, 1),
    BorderColor3 = Color3.fromRGB(0, 0, 0),
})

UI.background.contain.center._propRows = {}

local function renderCenter(tab)
    for _, inst in ipairs(UI.background.contain.center._propRows) do
        inst:Destroy()
    end
    UI.background.contain.center._propRows = {}

    if not tab then
        UI.background.contain.center._nameValue.Text = "Press Logging to start!"
        UI.background.contain.center._lengthValue.Text = "0:00:0"
        UI.background.contain.center._priorityValue.Text = "Action"
        return
    end

    UI.background.contain.center._nameValue.Text = tab._data.name
    UI.background.contain.center._lengthValue.Text = tab._data.length
    UI.background.contain.center._priorityValue.Text = tab._data.priority

    for i, prop in ipairs(tab._data.propRows) do
        local row = create("Frame", UI.background.contain.center._inner, {
            Name = "propdif",
            BorderSizePixel = 0,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 15),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            LayoutOrder = 100 + i,
        })
        create("TextLabel", row, {
            BorderSizePixel = 0,
            TextSize = 14,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            FontFace = mono(),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0, 0.5),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = prop.name,
            AutomaticSize = Enum.AutomaticSize.XY,
            Position = UDim2.new(0, 0, 0.5, 0),
        })
        create("TextLabel", row, {
            BorderSizePixel = 0,
            TextSize = 14,
            BackgroundColor3 = Color3.fromRGB(255, 255, 255),
            FontFace = mono(),
            TextColor3 = prop.color or Color3.fromRGB(0, 171, 0),
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(1, 0.5),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Text = prop.value,
            AutomaticSize = Enum.AutomaticSize.XY,
            Position = UDim2.new(1, 0, 0.5, 0),
        })
        table.insert(UI.background.contain.center._propRows, row)
    end
end

UI.background.contain.bottom = {}
UI.background.contain.bottom._inst = create("Frame", UI.background.contain._inst, {
    Name = "bottom",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(6, 6, 6),
    Size = UDim2.new(0, 676, 0, 58),
    Position = UDim2.new(0, 0, 0.8714, 0),
    BorderColor3 = Color3.fromRGB(0, 0, 0),
})

create("UICorner", UI.background.contain.bottom._inst, {})

create("Frame", UI.background.contain.bottom._inst, {
    Name = "line",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(23, 23, 23),
    AnchorPoint = Vector2.new(0.5, 0),
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0.5, 0, 0, 0),
    BorderColor3 = Color3.fromRGB(0, 0, 0),
})

UI._bottomInner = create("Frame", UI.background.contain.bottom._inst, {
    Name = "contain",
    BorderSizePixel = 0,
    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
    BackgroundTransparency = 1,
    AnchorPoint = Vector2.new(0.5, 0.5),
    Size = UDim2.new(1, -19, 1, 0),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BorderColor3 = Color3.fromRGB(0, 0, 0),
})

create("UIListLayout", UI._bottomInner, {
    HorizontalAlignment = Enum.HorizontalAlignment.Right,
    Padding = UDim.new(0, 9),
    VerticalAlignment = Enum.VerticalAlignment.Center,
    SortOrder = Enum.SortOrder.LayoutOrder,
    FillDirection = Enum.FillDirection.Horizontal,
})

local Tab = {}
Tab.__index = Tab

function Tab:select()
    if UI._selected and UI._selected ~= self and UI._selected._logContent then
        TweenService:Create(UI._selected._logContent, TweenInfo.new(0.15), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(UI._selected._logLabel, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(116, 120, 130) }):Play()
        TweenService:Create(UI._selected._logStroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(23, 23, 23) }):Play()
    end

    local prev = UI._selected
    UI._selected = self
    TweenService:Create(self._logContent, TweenInfo.new(0.15), { BackgroundTransparency = 0 }):Play()
    TweenService:Create(self._logLabel, TweenInfo.new(0.15), { TextColor3 = Color3.fromRGB(156, 45, 45) }):Play()
    TweenService:Create(self._logStroke, TweenInfo.new(0.15), { Color = Color3.fromRGB(53, 3, 3) }):Play()

    local inner = UI.background.contain.center._inner

    if prev and prev ~= self then
        local fadeOut = TweenService:Create(inner, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            GroupTransparency = 1,
        })
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            renderCenter(self)
            TweenService:Create(inner, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                GroupTransparency = 0,
            }):Play()
        end)
    else
        renderCenter(self)
    end
end

function Tab:setName(name)
    self._data.name = name
    if UI._selected == self then
        UI.background.contain.center._nameValue.Text = name
    end
end

function Tab:setLength(length)
    self._data.length = length
    if UI._selected == self then
        UI.background.contain.center._lengthValue.Text = length
    end
end

function Tab:setPriority(priority)
    self._data.priority = priority
    if UI._selected == self then
        UI.background.contain.center._priorityValue.Text = priority
    end
end

function Tab:setId(id)
    self._data.id = id
    self._logLabel.Text = id
end

function Tab:addPropRow(name, value, color)
    table.insert(self._data.propRows, {
        name = name,
        value = value,
        color = color or Color3.fromRGB(0, 171, 0),
    })
    if UI._selected == self then
        renderCenter(self)
    end
end

function Tab:clearPropRows()
    self._data.propRows = {}
    if UI._selected == self then
        renderCenter(self)
    end
end

function Tab:destroy()
    for i, t in ipairs(UI._tabs) do
        if t == self then
            table.remove(UI._tabs, i)
            break
        end
    end
    self._logInst:Destroy()
    if UI._selected == self then
        UI._selected = nil
        if #UI._tabs > 0 then
            UI._tabs[1]:select()
        else
            renderCenter(nil)
        end
    end
end

function Tab:finalize()
    if not UI._stacking then return self end
    local fp = tabFingerprint(self)
    for _, existing in ipairs(UI._tabs) do
        if existing ~= self and not existing._collapsed and tabFingerprint(existing) == fp then
            existing._stackCount = existing._stackCount + 1
            existing._stackLabel.Text = "x" .. existing._stackCount
            existing._stackLabel.Visible = true
            self._collapsed = true
            TweenService:Create(self._logContent, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                GroupTransparency = 1,
            }):Play()
            TweenService:Create(self._logStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Transparency = 1,
            }):Play()
            local tween = TweenService:Create(self._logInst, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 0),
            })
            tween.Completed:Connect(function()
                self._logInst.Visible = false
            end)
            tween:Play()
            if UI._selected == self then
                existing:select()
            end
            task.wait()
            return existing
        end
    end
    return self
end

tabFingerprint = function(tab)
    local parts = { tab._data.id, tab._data.name, tab._data.length, tab._data.priority }
    for _, row in ipairs(tab._data.propRows) do
        table.insert(parts, row.name .. "=" .. row.value)
    end
    return table.concat(parts, "|")
end

collapseStacks = function()
    local groups = {}
    local order = {}
    for _, tab in ipairs(UI._tabs) do
        local fp = tabFingerprint(tab)
        if not groups[fp] then
            groups[fp] = {}
            table.insert(order, fp)
        end
        table.insert(groups[fp], tab)
    end
    local reps = {}
    for _, fp in ipairs(order) do
        local tabs = groups[fp]
        local rep = tabs[#tabs]
        reps[rep] = true
        for _, tab in ipairs(tabs) do
            if tab == rep then
                tab._collapsed = false
                tab._logInst.Visible = true
                tab._stackCount = #tabs
                if #tabs > 1 then
                    tab._stackLabel.Text = "x" .. #tabs
                    tab._stackLabel.Visible = true
                else
                    tab._stackLabel.Text = ""
                    tab._stackLabel.Visible = false
                end
            else
                tab._collapsed = true
                tab._stackCount = 1
                tab._stackLabel.Text = ""
                tab._stackLabel.Visible = false
                TweenService:Create(tab._logContent, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    GroupTransparency = 1,
                }):Play()
                TweenService:Create(tab._logStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    Transparency = 1,
                }):Play()
                local tween = TweenService:Create(tab._logInst, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                    Size = UDim2.new(1, 0, 0, 0),
                })
                tween.Completed:Connect(function()
                    tab._logInst.Visible = false
                end)
                tween:Play()
            end
        end
    end
    if UI._selected and not reps[UI._selected] then
        for i = #UI._tabs, 1, -1 do
            if reps[UI._tabs[i]] then
                UI._tabs[i]:select()
                break
            end
        end
    end
end

expandStacks = function()
    for _, tab in ipairs(UI._tabs) do
        tab._stackCount = 1
        tab._stackLabel.Text = ""
        tab._stackLabel.Visible = false
        if tab._collapsed then
            tab._collapsed = false
            tab._logInst.Size = UDim2.new(1, 0, 0, 0)
            tab._logContent.GroupTransparency = 1
            tab._logStroke.Transparency = 1
            tab._logInst.Visible = true
            TweenService:Create(tab._logInst, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Size = UDim2.new(1, 0, 0, 43),
            }):Play()
            TweenService:Create(tab._logContent, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                GroupTransparency = 0,
            }):Play()
            TweenService:Create(tab._logStroke, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
                Transparency = 0,
            }):Play()
        end
    end
end

function UI.createTab(id)
    local tab = setmetatable({}, Tab)
    tab._data = {
        id = id or "null",
        name = "Animation",
        length = "0:00:0",
        priority = "Action",
        propRows = {},
    }

    UI._logOrder = UI._logOrder - 1

    tab._logInst = create("Frame", UI.background.contain.left.scrollFrame, {
        Name = "log",
        BorderSizePixel = 0,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        LayoutOrder = UI._logOrder,
    })

    TweenService:Create(tab._logInst, TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 0, 43),
    }):Play()

    tab._logContent = create("CanvasGroup", tab._logInst, {
        Name = "content",
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(21, 5, 5),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 33),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        GroupTransparency = 0,
    })
    tab._logStroke = stroke(tab._logContent, { Color = Color3.fromRGB(23, 23, 23) }, Enum.BorderStrokePosition.Inner)
    corner(tab._logContent, {0, 5})

    tab._logButton = create("TextButton", tab._logContent, {
        Name = "vutton",
        BorderSizePixel = 0,
        TextTransparency = 1,
        TextSize = 14,
        AutoButtonColor = false,
        TextColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = source(),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
    })
    corner(tab._logButton)

    tab._logLabel = create("TextLabel", tab._logContent, {
        BorderSizePixel = 0,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = mono(),
        TextColor3 = Color3.fromRGB(116, 120, 130),
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0, 0.5),
        Size = UDim2.new(0, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = tab._data.id,
        AutomaticSize = Enum.AutomaticSize.X,
        Position = UDim2.new(0, 10, 0.5, 0),
    })

    tab._stackCount = 1
    tab._collapsed = false
    tab._stackLabel = create("TextLabel", tab._logContent, {
        Name = "stackLabel",
        BorderSizePixel = 0,
        TextSize = 12,
        TextTransparency = 0.32,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
        FontFace = roboto(Enum.FontWeight.Bold),
        TextColor3 = Color3.fromRGB(0, 171, 0),
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(1, 0.5),
        Size = UDim2.new(0, 0, 1, 0),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        Text = "",
        Visible = false,
        AutomaticSize = Enum.AutomaticSize.XY,
        Position = UDim2.new(1, -10, 0.5, 0),
    })

    local hoverFrame = hover(tab._logContent)

    tab._logButton.MouseEnter:Connect(function()
        if UI._selected ~= tab then
            TweenService:Create(hoverFrame, TweenInfo.new(0.12), { BackgroundTransparency = 0.92 }):Play()
        end
    end)

    tab._logButton.MouseLeave:Connect(function()
        TweenService:Create(hoverFrame, TweenInfo.new(0.12), { BackgroundTransparency = 1 }):Play()
    end)

    tab._logButton.MouseButton1Click:Connect(function()
        tab:select()
    end)

    table.insert(UI._tabs, tab)

    if #UI._tabs == 1 then
        tab:select()
    end

    return tab
end

function UI.getSelected()
    return UI._selected
end

function UI.clearAll()
    for i = #UI._tabs, 1, -1 do
        UI._tabs[i]._logInst:Destroy()
    end
    UI._tabs = {}
    UI._logOrder = 0
    UI._selected = nil
    renderCenter(nil)
end

function UI.addActionButton(label, order, size, opts)
    local key = label:lower():gsub(" ", "")
    local btn = makeActionButton(UI._bottomInner, label, order, size, opts)
    UI._actionButtons[key] = btn
    UI.background.contain.bottom[key] = btn
    return btn
end

function UI.removeActionButton(label)
    local key = label:lower():gsub(" ", "")
    local btn = UI._actionButtons[key]
    if btn then
        btn._inst:Destroy()
        UI._actionButtons[key] = nil
        UI.background.contain.bottom[key] = nil
    end
end

function UI.editActionButton(label, props)
    local key = label:lower():gsub(" ", "")
    local btn = UI._actionButtons[key]
    if not btn then return end
    if props.text then
        btn.label.Text = props.text
    end
    if props.color then
        btn._inst.BackgroundColor3 = props.color
    end
    if props.size then
        btn._inst.Size = props.size
    end
    if props.order then
        btn._inst.LayoutOrder = props.order
    end
    if props.transparent ~= nil then
        btn._inst.BackgroundTransparency = props.transparent and 1 or 0
    end
    if props.visible ~= nil then
        btn._inst.Visible = props.visible
    end
    return btn
end

function UI.addLine(order)
    local key = "line_" .. tostring(order)
    local line = create("Frame", UI._bottomInner, {
        Name = key,
        BorderSizePixel = 0,
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        Size = UDim2.new(0, 2, 1, -35),
        BorderColor3 = Color3.fromRGB(0, 0, 0),
        LayoutOrder = order,
    })
    UI._lines[key] = line
    return line
end

function UI.removeLine(order)
    local key = "line_" .. tostring(order)
    local line = UI._lines[key]
    if line then
        line:Destroy()
        UI._lines[key] = nil
    end
end

--// UI Lib end

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character;
local Humanoid;
local Tab;
local Logger = {}
local Logging = false
local LogDelay = 0
local LogTarget = "LocalPlayer"
local AnimLooped;
local AnimSpeed;
local AnimTimePosition;
local LogDelayButton;
LogDelayButton = UI.addActionButton("0s", 6, UDim2.new(0, 24, 1, -20), { transparent = true })
local LogAnimationsButton;
LogAnimationsButton = UI.addActionButton("Log: LocalPlayer", 7, UDim2.new(0, 120, 1, -20), { transparent = true })
local CopyAnimationButton = UI.addActionButton("Copy AnimId", 8, UDim2.new(0, 110, 1, -20), { transparent = true })
local CopyPropertiesButton = UI.addActionButton("Copy Properties", 9, UDim2.new(0, 120, 1, -20), { transparent = true })
local ClearLogsButton = UI.addActionButton("Clear Logs", 123, UDim2.new(0, 100, 1, -20), { transparent = true })

UI.addLine(12)
local PlayAnimationButton = UI.addActionButton("Play Animation", 124, UDim2.new(0, 120, 1, -20), { strokeTransparency = 1 })

PlayAnimationButton.button.MouseButton1Click:Connect(function()
    local Selected = UI.getSelected()
    if not Selected then return end
    
    local Lines = {}

    local Anim = Instance.new("Animation")
    Anim.Name = Selected._data.name
    Anim.AnimationId = Selected._data.id

    local AnimTrack = LocalPlayer.Character.Humanoid:LoadAnimation(Anim)
    AnimTrack.Priority = Enum.AnimationPriority[Selected._data.priority]
    AnimTrack.Looped = AnimLooped
    AnimTrack:AdjustSpeed(AnimSpeed)
    AnimTrack.TimePosition = AnimTimePosition
    AnimTrack:Play()

    task.wait(AnimTrack.Length)
    AnimTrack:Stop()
    Anim:Destroy()
end)

ClearLogsButton.button.MouseButton1Click:Connect(function()
    UI.clearAll()
end)

task.spawn(function()
    while task.wait(AutoClearLogsDelay) do
        UI.clearAll()
    end
end)

function Logger.ChangeLogDelay()
    local Selected = UI.getSelected()
    if not Selected then return end
    
    if LogDelay == 0 then
        LogDelay = 1
        LogDelayButton = UI.addActionButton("1s", 6, UDim2.new(0, 24, 1, -20), { transparent = true })
        UI.removeActionButton("0s")
    elseif LogDelay == 1 then
        LogDelay = 2
        LogDelayButton = UI.addActionButton("2s", 6, UDim2.new(0, 24, 1, -20), { transparent = true })
        UI.removeActionButton("1s")
    else
        LogDelay = 0
        LogDelayButton = UI.addActionButton("0s", 6, UDim2.new(0, 24, 1, -20), { transparent = true })
        UI.removeActionButton("2s")
    end
    
    LogDelayButton.button.MouseButton1Click:Connect(function()
        Logger:ChangeLogDelay()
    end)
end

function Logger.ChangeLogTarget()
    local sel = UI.getSelected()
    if not sel then return end
    
    if LogTarget == "LocalPlayer" then
        LogTarget = "AllPlayers"; print(LogTarget)
        LogAnimationsButton = UI.addActionButton("Log: AllPlrs", 7, UDim2.new(0, 112, 1, -20), { transparent = true })
        UI.removeActionButton("Log: LocalPlayer")
    elseif LogTarget == "AllPlayers" then
        LogTarget = "Others"; print(LogTarget)
        LogAnimationsButton = UI.addActionButton("Log: Others", 7, UDim2.new(0, 114, 1, -20), { transparent = true })
        UI.removeActionButton("Log: AllPlrs")
    else
        LogTarget = "LocalPlayer"; print(LogTarget)
        LogAnimationsButton = UI.addActionButton("Log: LocalPlayer", 7, UDim2.new(0, 120, 1, -20), { transparent = true })
        UI.removeActionButton("Log: Others")
    end
    
    LogAnimationsButton.button.MouseButton1Click:Connect(function()
        Logger:ChangeLogTarget()
    end)
end

function Logger.LoopAndCreateTab()
    AnimationTracks = Humanoid.Animator:GetPlayingAnimationTracks()
    
    for _, Animation in AnimationTracks do
        SelectedAnim = Animation.Animation
        
        if table.find(BlockedAnimations, SelectedAnim.Name) then continue end
        
        AnimLooped = Animation.Looped
        AnimSpeed = Animation.Speed
        AnimTimePosition = Animation.TimePosition
        
        Tab = UI.createTab(`rbxassetid://{SelectedAnim.AnimationId:match("%d+")}`)
        Tab:setName(`{SelectedAnim.Name}`)
        Tab:setLength(`{string.format("%.3f", Animation.Length)}`)
        Tab:setPriority(`{Animation.Priority.Name}`)
        Tab:addPropRow("isPlaying", `{Animation.isPlaying}`)
        Tab:addPropRow("Looped", `{AnimLooped}`)
        Tab:addPropRow("Speed", `{AnimSpeed}`, Color3.fromRGB(255, 200, 0))
        Tab:addPropRow("Time Position", `{AnimTimePosition}`, Color3.fromRGB(255, 200, 0))
        Tab:addPropRow("Logged Player", `{Humanoid.Parent.Name}`, Color3.fromRGB(53, 260, 0))
        Tab:finalize()
    end
end

function Logger.LogTargetCreate(self, Target: string)
    local AnimationTracks;
    local SelectedAnim;
    
    if Target == "LocalPlayer" then
        if not LocalPlayer.Character or not LocalPlayer.Character.Humanoid then Logger:LogTargetCreate(LogTarget) end
        Character = LocalPlayer.Character
        Humanoid = Character:FindFirstChildOfClass("Humanoid")
    
        Logger.LoopAndCreateTab()
        
        return task.wait(LogDelay)
    elseif Target == "AllPlayers" then
        for _, Player in Players:GetPlayers() do
            if Player == LocalPlayer then continue end
            if not Player.Character or not Player.Character:FindFirstChildOfClass("Humanoid") then continue end

            Character = Player.Character
            Humanoid = Character:FindFirstChildOfClass("Humanoid")

            Logger.LoopAndCreateTab()
            
            task.wait(LogDelay)
            
            continue
        end
    elseif Target == "Others" then
        if ChosenTargetFolder == nil then Logger:ChangeLogTarget(); return warn("Target folder containing models with 'Humanoid' not defined") end

        for _, Instance in ChosenTargetFolder:GetDescendants() do -- i know this is not practical.
            if Instance:IsA("Humanoid") then
                Character = Instance.Parent
                Humanoid = Instance
        
                Logger.LoopAndCreateTab()
                
                task.wait(LogDelay) 
                
                continue
            end
        end
    end
end

LogDelayButton.button.MouseButton1Click:Connect(function()
    Logger:ChangeLogDelay()
end)

LogAnimationsButton.button.MouseButton1Click:Connect(function()
    Logger:ChangeLogTarget()
end)

CopyAnimationButton.button.MouseButton1Click:Connect(function()
    local Selected = UI.getSelected()
    if not Selected then return end
    
    setclipboard(Selected._data.id)
end)

CopyPropertiesButton.button.MouseButton1Click:Connect(function()
    local Selected = UI.getSelected()
    if not Selected then return end
    
    local Lines = {}
    table.insert(Lines, `local Player = game:GetService("Players").LocalPlayer`)
    table.insert(Lines, "")
    table.insert(Lines, `local Anim = Instance.new("Animation")`)
    table.insert(Lines, `Anim.Name = "{Selected._data.name}"`)
    table.insert(Lines, `Anim.AnimationId = "{Selected._data.id}"`)
    table.insert(Lines, "")
    table.insert(Lines, `local AnimTrack = Player.Character.Humanoid:LoadAnimation(Anim)`)
    table.insert(Lines, `AnimTrack.Priority = Enum.AnimationPriority.{Selected._data.priority}`)
    table.insert(Lines, `AnimTrack.Looped = {AnimLooped}`)
    table.insert(Lines, `AnimTrack:AdjustSpeed({AnimSpeed})`)
    table.insert(Lines, `AnimTrack.TimePosition = {AnimTimePosition}`)
    table.insert(Lines, `AnimTrack:Play()`)
    table.insert(Lines, "")
    table.insert(Lines, `task.wait(AnimTrack.Length)`)
    table.insert(Lines, `AnimTrack:Stop()`)
    
    local text = table.concat(Lines, "\n")
    setclipboard(text)
end)

function UI.onLoggingEnabled()
    Logging = true
    
    while Logging == true do
        Logger:LogTargetCreate(LogTarget)
        
        task.wait()
    end
end

function UI.onLoggingDisabled()
    Logging = false
end

return UI
