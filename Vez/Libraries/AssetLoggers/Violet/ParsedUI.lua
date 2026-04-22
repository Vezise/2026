-- SoundLoggerUI (by Vez) — generated from ui_lib_noti_13 (2).rbxmx
-- Builds the ScreenGui hierarchy in Luau.

local Assets = {
  "108453875048733.png";
  "82686076130111.png";
  "95222964296464.png";
  "114069756293603.png";
  "136563593316996.png";
}

local URL = "https://github.com/Vezise/2026/tree/main/Vez/Libraries/AssetLoggers/Violet/Assets"
local AssetData

if not isfolder("Violet") then
    makefolder("Violet")
end

if not isfolder("Violet/Assets") then
    makefolder("Violet/Assets")
end

for _, Asset in Assets do
    if not isfile(`Violet/Assets/{Asset}`) then
        AssetData = game:HttpGet(`{URL}/{Asset}`)
        writefile(`Violet/Assets/{Asset}`, AssetData)
    end
end

local function new(className, props, children)
	local inst = Instance.new(className)
	if props then
		for k, v in pairs(props) do
			if k ~= "Parent" then
				inst[k] = v
			end
		end
	end
	if children then
		for _, c in ipairs(children) do
			c.Parent = inst
		end
	end
	if props and props.Parent then
		inst.Parent = props.Parent
	end
	return inst
end

local UDim2n = UDim2.new
local UDimN  = UDim.new
local C3     = Color3.new
local C3RGB  = Color3.fromRGB
local V2     = Vector2.new

local RobotoRegular = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local RobotoBold    = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Bold,    Enum.FontStyle.Normal)
local RobotoItalic  = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Italic)
local RobotoMono    = Font.new("rbxasset://fonts/families/RobotoMono.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

local SoundLoggerUI = new("ScreenGui", {
	Name = "SoundLoggerUI",
	ResetOnSpawn = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
	Parent = game:GetService("CoreGui"), -- or PlayerGui
})

local Background = new("Frame", {
	Name = "Background",
	Parent = SoundLoggerUI,
	AnchorPoint = V2(0.5, 0.5),
	Position = UDim2n(0.5, 0, 0.5, 0),
	Size = UDim2n(0, 676, 0, 451),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
})

new("UIAspectRatioConstraint", {
	Parent = Background,
	AspectRatio = 1.49889135,
})

new("ImageLabel", {
	Name = "back",
	Parent = Background,
	Image = getcustomasset and getcustomasset("Violet/Assets/108453875048733.png") or "rbxassetid://108453875048733",
	BackgroundTransparency = 1,
	Position = UDim2n(0, -24, 0, -24),
	Size = UDim2n(0, 725, 0, 500),
	ZIndex = 0,
})

local Top = new("ImageLabel", {
	Name = "top",
	Parent = Background,
	Image = getcustomasset and getcustomasset("Violet/Assets/82686076130111.png") or "rbxassetid://82686076130111",
	BackgroundTransparency = 1,
	Size = UDim2n(0, 676, 0, 30),
})

-- layout1 (left header: VIOLET - Sound Logger By Vez)
local layout1 = new("Frame", {
	Name = "layout1",
	Parent = Top,
	BackgroundTransparency = 1,
	Position = UDim2n(0, 8, 0, 0),
	Size = UDim2n(1, 0, 1, 0),
})

new("UIListLayout", {
	Parent = layout1,
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDimN(0, 8),
})

-- OFF icon
new("ImageLabel", {
	Name = "OFF",
	Parent = layout1,
	Image = getcustomasset and getcustomasset("Violet/Assets/95222964296464.png") or "rbxassetid://95222964296464",
	BackgroundTransparency = 1,
	Position = UDim2n(0, 10, 0, 9),
	Size = UDim2n(0, 12, 0, 12),
	Visible = false,
	ZIndex = 3,
})

-- ON icon
new("ImageLabel", {
	Name = "ON",
	Parent = layout1,
    Image = getcustomasset and getcustomasset("Violet/Assets/114069756293603.png") or "rbxassetid://114069756293603",
	BackgroundTransparency = 1,
	Position = UDim2n(0, 22, 0, 5),
	Size = UDim2n(0, 20, 0, 20),
	ZIndex = 4,
})

new("TextLabel", {
	Name = "title",
	Parent = layout1,
	LayoutOrder = 1,
	FontFace = RobotoBold,
	Text = "VIOLET",
	TextColor3 = C3(1, 1, 1),
	TextTransparency = 0.24,
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Right,
	BackgroundTransparency = 1,
	AutomaticSize = Enum.AutomaticSize.X,
	Size = UDim2n(0, 0, 1, 0),
})

new("TextLabel", {
	Name = "dash",
	Parent = layout1,
	LayoutOrder = 2,
	FontFace = RobotoBold,
	Text = "-",
	TextColor3 = C3(1, 1, 1),
	TextTransparency = 0.24,
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Right,
	BackgroundTransparency = 1,
	AutomaticSize = Enum.AutomaticSize.X,
	Size = UDim2n(0, 0, 1, 0),
})

new("TextLabel", {
	Name = "ani",
	Parent = layout1,
	LayoutOrder = 3,
	FontFace = RobotoBold,
	Text = "Sound Logger",
	TextColor3 = C3(0.498, 0, 1),
	TextTransparency = 0.24,
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Right,
	BackgroundTransparency = 1,
	AutomaticSize = Enum.AutomaticSize.X,
	Size = UDim2n(0, 0, 1, 0),
})

new("TextLabel", {
	Name = "vez",
	Parent = layout1,
	LayoutOrder = 4,
	FontFace = RobotoItalic,
	Text = "By Vez",
	TextColor3 = C3(1, 1, 1),
	TextTransparency = 0.58,
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Right,
	BackgroundTransparency = 1,
	AutomaticSize = Enum.AutomaticSize.X,
	Size = UDim2n(0, 0, 1, 0),
})

-- layout2 (right-side toggles: Logging / Stacking)
local layout2 = new("Frame", {
	Name = "layout2",
	Parent = Top,
	BackgroundTransparency = 1,
	Position = UDim2n(0, -4, 0, 0),
	Size = UDim2n(1, 0, 1, 0),
})

new("UIListLayout", {
	Parent = layout2,
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Right,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDimN(0, 10),
})

-- helper to build a toggle pill
local function makeToggle(name, labelText, bgColor, circleColor, parent)
	local t = new("Frame", {
		Name = name,
		Parent = parent,
		AnchorPoint = V2(0, 0.5),
		BackgroundColor3 = bgColor,
		BorderSizePixel = 0,
		Size = UDim2n(0, 65, 1, -8),
		Visible = false,
	})
	new("UICorner", { Parent = t, CornerRadius = UDimN(0, 4) })
	new("UIStroke", { Parent = t, Color = C3(1, 1, 1), Transparency = 0.92, Thickness = 1 })

	local contain = new("Frame", {
		Name = "contain",
		Parent = t,
		AnchorPoint = V2(0, 0.5),
		BackgroundTransparency = 1,
		Position = UDim2n(0, 5, 0.5, 0),
		Size = UDim2n(0, 10, 0, 10),
	})
	new("UIListLayout", {
		Parent = contain,
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDimN(0, 4),
	})

	local circle = new("Frame", {
		Name = "circle",
		Parent = contain,
		AnchorPoint = V2(0, 0.5),
		BackgroundColor3 = circleColor,
		BorderSizePixel = 0,
		Size = UDim2n(0, 8, 0, 8),
	})
	new("UICorner", { Parent = circle, CornerRadius = UDimN(1, 0) })

	new("TextLabel", {
		Parent = contain,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		FontFace = RobotoRegular,
		Text = labelText,
		TextColor3 = C3(1, 1, 1),
		TextTransparency = 0.32,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Right,
	})

	local btn = new("TextButton", {
		Parent = t,
		AnchorPoint = V2(0.5, 0.5),
		Position = UDim2n(0.5, 0, 0.5, 0),
		Size = UDim2n(1, 0, 1, 0),
		BackgroundTransparency = 1,
		TextTransparency = 1,
		Text = "Button",
	})

	local hover = new("Frame", {
		Name = "hover",
		Parent = t,
		AnchorPoint = V2(0.5, 0.5),
		Position = UDim2n(0.5, 0, 0.5, 0),
		Size = UDim2n(1, 0, 1, 0),
		BackgroundTransparency = 1,
	})
	new("UICorner", { Parent = hover, CornerRadius = UDimN(0, 4) })

	return t, btn
end

local togglelog   = makeToggle("togglelog",   "Logging",  C3RGB(13, 0, 26),     C3RGB(0, 170, 0),       layout2)
local togglestack = makeToggle("togglestack", "Stacking", C3RGB(22, 10, 10),    C3RGB(50, 50, 50),      layout2)

local Contain = new("Frame", {
	Name = "contain",
	Parent = Background,
	BackgroundColor3 = C3RGB(217, 217, 217),
	BackgroundTransparency = 0.9999,
	BorderSizePixel = 0,
	Size = UDim2n(0, 676, 0, 451),
	ZIndex = 2,
})

local Left = new("Frame", {
	Name = "left",
	Parent = Contain,
	BackgroundTransparency = 1,
	Position = UDim2n(0, 0, 0, 30),
	Size = UDim2n(0, 238, 0, 421),
})

new("Frame", {
	Name = "line",
	Parent = Left,
	AnchorPoint = V2(1, 0.5),
	Position = UDim2n(1, 0, 0.5, 0),
	Size = UDim2n(0, 1, 1, 0),
	BackgroundColor3 = C3RGB(22, 22, 22),
	BorderSizePixel = 0,
})

local leftText = new("Frame", {
	Name = "text",
	Parent = Left,
	BackgroundTransparency = 1,
	Size = UDim2n(1, 0, -0.118764848, 100),
})

new("TextLabel", {
	Parent = leftText,
	AnchorPoint = V2(0, 0.5),
	Position = UDim2n(0, 15, 0.5, 0),
	Size = UDim2n(0, 200, 0, 50),
	BackgroundTransparency = 1,
	FontFace = RobotoMono,
	Text = "Logged Assets",
	TextColor3 = C3(1, 1, 1),
	TextTransparency = 0.66,
	TextSize = 15,
	TextXAlignment = Enum.TextXAlignment.Left,
})

new("Frame", {
	Name = "line",
	Parent = leftText,
	AnchorPoint = V2(0.5, 1),
	Position = UDim2n(0.5, 0, 1, 0),
	Size = UDim2n(1, 0, 0, 1),
	BackgroundColor3 = C3RGB(22, 22, 22),
	BorderSizePixel = 0,
})

local leftContain = new("Frame", {
	Name = "contain",
	Parent = Left,
	BackgroundTransparency = 1,
	Position = UDim2n(0, 0, 0.118764848, 0),
	Size = UDim2n(0, 236, 0, 322),
})

local scroll = new("ScrollingFrame", {
	Name = "ScrollingFrame",
	Parent = leftContain,
	AnchorPoint = V2(0.5, 0.5),
	Position = UDim2n(0.5, 0, 0.5, 0),
	Size = UDim2n(1, -20, 1, -20),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ScrollBarThickness = 0,
	ScrollBarImageColor3 = C3(0, 0, 0),
	ScrollingDirection = Enum.ScrollingDirection.Y,
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	CanvasSize = UDim2n(),
	ClipsDescendants = true,
})

new("UIListLayout", {
	Parent = scroll,
	FillDirection = Enum.FillDirection.Vertical,
	SortOrder = Enum.SortOrder.LayoutOrder,
	VerticalAlignment = Enum.VerticalAlignment.Top,
})

-- Template log row (hidden — "logUn")
local logUn = new("Frame", {
	Name = "logUn",
	Parent = scroll,
	BackgroundColor3 = C3RGB(20, 4, 4),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Size = UDim2n(1, 0, 0, 43),
	ClipsDescendants = true,
	Visible = false,
})

local logRow = new("Frame", {
	Name = "log",
	Parent = logUn,
	BackgroundTransparency = 1,
	Size = UDim2n(1, 0, 0, 33),
})
new("UIStroke", {
	Parent = logRow,
	Color = C3RGB(22, 22, 22),
	ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
	Transparency = 0,
})
new("UICorner", { Parent = logRow, CornerRadius = UDimN(0, 5) })

new("TextButton", {
	Name = "vutton",
	Parent = logRow,
	AnchorPoint = V2(0.5, 0.5),
	Position = UDim2n(0.5, 0, 0.5, 0),
	Size = UDim2n(1, 0, 1, 0),
	BackgroundTransparency = 1,
	AutoButtonColor = false,
	Text = "Button",
	TextTransparency = 1,
})

new("TextLabel", {
	Parent = logRow,
	AnchorPoint = V2(0, 0.5),
	AutomaticSize = Enum.AutomaticSize.X,
	Position = UDim2n(0, 10, 0.5, 0),
	Size = UDim2n(0, 0, 1, 0),
	BackgroundTransparency = 1,
	FontFace = RobotoMono,
	Text = "rbxassetid://0",
	TextColor3 = C3RGB(115, 119, 129),
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Left,
})

local logHover = new("Frame", {
	Name = "hover",
	Parent = logRow,
	AnchorPoint = V2(0.5, 0.5),
	Position = UDim2n(0.5, 0, 0.5, 0),
	Size = UDim2n(1, 0, 1, 0),
	BackgroundTransparency = 1,
})
new("UICorner", { Parent = logHover, CornerRadius = UDimN(0, 4) })

new("TextLabel", {
	Name = "multi",
	Parent = logRow,
	AnchorPoint = V2(1, 0.5),
	AutomaticSize = Enum.AutomaticSize.X,
	Position = UDim2n(1, -10, 0.5, 0),
	Size = UDim2n(0, 0, 1, 0),
	BackgroundTransparency = 1,
	FontFace = RobotoMono,
	Text = "x2",
	TextColor3 = C3RGB(0, 170, 0),
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Center,
	Visible = false,
})

local Bottom = new("Frame", {
	Name = "bottom",
	Parent = Contain,
	BackgroundColor3 = C3RGB(5, 5, 5),
	BorderSizePixel = 0,
	Position = UDim2n(0, 0, 0.8713969, 0),
	Size = UDim2n(0, 676, 0, 58),
})
new("UICorner", { Parent = Bottom, CornerRadius = UDimN(0, 8) })

new("Frame", {
	Name = "line",
	Parent = Bottom,
	AnchorPoint = V2(0.5, 0),
	Position = UDim2n(0.5, 0, 0, 0),
	Size = UDim2n(1, 0, 0, 1),
	BackgroundColor3 = C3RGB(22, 22, 22),
	BorderSizePixel = 0,
})

local bottomContain = new("Frame", {
	Name = "contain",
	Parent = Bottom,
	AnchorPoint = V2(0.5, 0.5),
	Position = UDim2n(0.5, 0, 0.5, 0),
	Size = UDim2n(1, -19, 1, 0),
	BackgroundTransparency = 1,
})
new("UIListLayout", {
	Parent = bottomContain,
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Right,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDimN(0, 9),
})

local clear = new("Frame", {
	Name = "clear",
	Parent = bottomContain,
	LayoutOrder = 1,
	BackgroundColor3 = C3RGB(153, 0, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Size = UDim2n(0, 100, 1, -20),
	Visible = false,
})
new("UICorner", { Parent = clear, CornerRadius = UDimN(0, 4) })
new("UIStroke", {
	Parent = clear,
	Color = C3RGB(45, 53, 66),
	Thickness = 1,
})
new("TextLabel", {
	Parent = clear,
	AnchorPoint = V2(0.5, 0.5),
	Position = UDim2n(0.5, 0, 0.5, 0),
	Size = UDim2n(0, 0, 0, 0),
	AutomaticSize = Enum.AutomaticSize.XY,
	BackgroundTransparency = 1,
	FontFace = RobotoBold,
	Text = "Clear Logs",
	TextColor3 = C3(1, 1, 1),
	TextTransparency = 0.16,
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Right,
})
new("TextButton", {
	Parent = clear,
	AnchorPoint = V2(0.5, 0.5),
	Position = UDim2n(0.5, 0, 0.5, 0),
	Size = UDim2n(1, 0, 1, 0),
	BackgroundTransparency = 1,
	TextTransparency = 1,
	Text = "Button",
})
local clearHover = new("Frame", {
	Name = "hover",
	Parent = clear,
	AnchorPoint = V2(0.5, 0.5),
	Position = UDim2n(0.5, 0, 0.5, 0),
	Size = UDim2n(1, 0, 1, 0),
	BackgroundTransparency = 1,
})
new("UICorner", { Parent = clearHover, CornerRadius = UDimN(0, 4) })

local Center = new("Frame", {
	Name = "center",
	Parent = Contain,
	BackgroundColor3 = C3RGB(10, 10, 10),
	BorderSizePixel = 0,
	Position = UDim2n(0.352071017, 0, 0.0665188506, 0),
	Size = UDim2n(0, 438, 0, 363),
})

local centerContain = new("Frame", {
	Name = "contain",
	Parent = Center,
	AnchorPoint = V2(0.5, 0.5),
	Position = UDim2n(0.5, 0, 0.5, 0),
	Size = UDim2n(1, -30, 1, -30),
	BackgroundTransparency = 1,
	Visible = false,
})

new("UIListLayout", {
	Parent = centerContain,
	FillDirection = Enum.FillDirection.Vertical,
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDimN(0, 10),
})

local function makePropBlock(parent, propName, valueText)
	local f = new("Frame", {
		Name = propName:lower(),
		Parent = parent,
		BackgroundTransparency = 1,
		Size = UDim2n(0, 159, 0, 58),
	})
	new("UIListLayout", {
		Parent = f,
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDimN(0, 5),
	})
	new("TextLabel", {
		Name = "prop",
		Parent = f,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		FontFace = RobotoMono,
		Text = propName,
		TextColor3 = C3(1, 1, 1),
		TextTransparency = 0.45,
		TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
	})
	new("TextLabel", {
		Name = "value",
		Parent = f,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		FontFace = RobotoRegular,
		Text = valueText,
		TextColor3 = C3(1, 1, 1),
		TextSize = 24,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
	})
	return f
end

makePropBlock(centerContain, "Name", "Animation")

local lengthWrap = new("Frame", {
	Name = "contain",
	Parent = centerContain,
	BackgroundTransparency = 1,
	Size = UDim2n(0, 159, 0, 58),
})
new("UIListLayout", {
	Parent = lengthWrap,
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDimN(0, 30),
})
makePropBlock(lengthWrap, "Length", "0:30:0")
makePropBlock(lengthWrap, "Priority", "Action")

new("Frame", {
	Name = "line",
	Parent = centerContain,
	BackgroundColor3 = C3RGB(22, 22, 22),
	BorderSizePixel = 0,
	Size = UDim2n(1, 0, 0, 1),
})

local propdif = new("Frame", {
	Name = "propdif",
	Parent = centerContain,
	BackgroundTransparency = 1,
	Position = UDim2n(0, 0, 0.441441447, 0),
	Size = UDim2n(1, 0, 0, 15),
	Visible = false,
})
new("TextLabel", {
	Name = "name",
	Parent = propdif,
	AnchorPoint = V2(0, 0.5),
	Position = UDim2n(0, 0, 0.5, 0),
	BackgroundTransparency = 1,
	AutomaticSize = Enum.AutomaticSize.XY,
	FontFace = RobotoMono,
	Text = "Looped",
	TextColor3 = C3(1, 1, 1),
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Right,
})
new("TextLabel", {
	Name = "value",
	Parent = propdif,
	AnchorPoint = V2(1, 0.5),
	Position = UDim2n(1, 0, 0.5, 0),
	BackgroundTransparency = 1,
	AutomaticSize = Enum.AutomaticSize.XY,
	FontFace = RobotoMono,
	Text = "True",
	TextColor3 = C3RGB(0, 170, 0),
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Right,
})

local Little = new("Frame", {
	Name = "little",
	Parent = Background,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2n(0, -258, 0, 48),
	Size = UDim2n(0, 238, 0, 355),
	ZIndex = 5,
})

new("ImageLabel", {
	Name = "little",
	Parent = Little,
	Image = getcustomasset and getcustomasset("Violet/Assets/136563593316996.png") or "rbxassetid://136563593316996",
	BackgroundTransparency = 1,
	Position = UDim2n(0, -24, 0, -24),
	Size = UDim2n(0, 287, 0, 404),
	ZIndex = 0,
})

local littleContain = new("Frame", {
	Name = "contain",
	Parent = Little,
	BackgroundColor3 = C3(1, 1, 1),
	BackgroundTransparency = 0.999,
	BorderSizePixel = 0,
	Size = UDim2n(0, 238, 0, 355),
})

local viewport = new("ViewportFrame", {
	Parent = littleContain,
	AnchorPoint = V2(0.5, 0.5),
	Position = UDim2n(0.5, 0, 0.5, 0),
	Size = UDim2n(1, 0, 1, 0),
	BackgroundTransparency = 1,
	Ambient = C3RGB(200, 200, 200),
	LightColor = C3RGB(140, 140, 140),
	LightDirection = Vector3.new(-1, -1, -1)
})

local vpCamera = new("Camera", {
	Parent = viewport,
	FieldOfView = 61.2252426,
	CFrame = CFrame.new(0.203681, 3.98093462, 9.96826172)
		* CFrame.Angles(math.rad(10), math.rad(180), 0),
})
viewport.CurrentCamera = vpCamera

local worldModel = new("WorldModel", {
    Parent = viewport,
    Name = "WorldModel"
})

local rig = new("Model", {
    Parent = worldModel,
    Name = "Rig"
})

local littleLayout2 = new("Frame", {
	Name = "layout2",
	Parent = Little,
	BackgroundTransparency = 1,
	Position = UDim2n(0, -4, 0, 0),
	Size = UDim2n(1, 0, 0, 30),
})
new("UIListLayout", {
	Parent = littleLayout2,
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Right,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDimN(0, 10),
})
makeToggle("togglestack", "Playing", C3RGB(21, 21, 21), C3RGB(50, 50, 50), littleLayout2)

return SoundLoggerUI
