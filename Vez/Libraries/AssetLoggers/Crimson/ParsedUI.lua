local Assets = {
  "108453875048733.png";
  "82686076130111.png";
  "95222964296464.png";
  "114069756293603.png";
  "136563593316996.png";
}

local URL = "https://github.com/Vezise/2026/tree/main/Vez/Libraries/AssetLoggers/Crimson/Assets"
local AssetData

if not isfolder("Crimson") then
    makefolder("Crimson")
end

if not isfolder("Crimson/Assets") then
    makefolder("Crimson/Assets")
end

for _, Asset in Assets do
    if not isfile(`Crimson/Assets/{Asset}`) then
        AssetData = game:HttpGet(`{URL}/{Asset}`)
        writefile(`Crimson/Assets/{Asset}`, AssetData)
    end
end

local function new(className, props)
	local inst = Instance.new(className)
	local parent = nil
	for k, v in pairs(props or {}) do
		if k == "Parent" then
			parent = v
		else
			inst[k] = v
		end
	end
	if parent then inst.Parent = parent end
	return inst
end

----------------------------------------------------------------
-- ScreenGui
----------------------------------------------------------------
local AnimLoggerUI = new("ScreenGui", {
	Name = "AnimLoggerUI",
	ResetOnSpawn = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets,
	ClipToDeviceSafeArea = true,
})

----------------------------------------------------------------
-- Background (main window)
----------------------------------------------------------------
local Background = new("Frame", {
	Name = "Background",
	Parent = AnimLoggerUI,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(676, 451),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
})
Background:SetAttribute("Id", "122_6")

-- backdrop image
new("ImageLabel", {
	Name = "back",
	Parent = Background,
	Image = getcustomasset and getcustomasset("Crimson/Assets/108453875048733.png") or "rbxassetid://108453875048733",
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(-24, -24),
	Size = UDim2.fromOffset(725, 500),
	ZIndex = 0,
})

----------------------------------------------------------------
-- Top bar
----------------------------------------------------------------
local top = new("ImageLabel", {
	Name = "top",
	Parent = Background,
	Image = getcustomasset and getcustomasset("Crimson/Assets/82686076130111.png") or "rbxassetid://82686076130111",
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(0, 0),
	Size = UDim2.fromOffset(676, 30),
})

-- layout1 (left side of top bar)
local layout1 = new("Frame", {
	Name = "layout1",
	Parent = top,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(8, 0),
	Size = UDim2.fromScale(1, 1),
	BorderSizePixel = 0,
})

new("UIListLayout", {
	Parent = layout1,
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 8),
})

new("ImageLabel", {
	Name = "OFF",
	Parent = layout1,
	Image = getcustomasset and getcustomasset("Crimson/Assets/95222964296464.png") or "rbxassetid://95222964296464",
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(10, 9),
	Size = UDim2.fromOffset(12, 12),
	Visible = false,
	ZIndex = 3,
	LayoutOrder = 0,
})

new("ImageLabel", {
	Name = "ON",
	Parent = layout1,
	Image = getcustomasset and getcustomasset("Crimson/Assets/114069756293603.png") or "rbxassetid://114069756293603",
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(22, 5),
	Size = UDim2.fromOffset(20, 20),
	ZIndex = 4,
	LayoutOrder = 0,
})

new("TextLabel", {
	Name = "title",
	Parent = layout1,
	FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
	Text = "CRIMSON",
	TextColor3 = Color3.new(1, 1, 1),
	TextTransparency = 0.24,
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Right,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	AutomaticSize = Enum.AutomaticSize.X,
	Size = UDim2.new(0, 0, 1, 0),
	LayoutOrder = 1,
})

new("TextLabel", {
	Name = "dash",
	Parent = layout1,
	FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
	Text = "-",
	TextColor3 = Color3.new(1, 1, 1),
	TextTransparency = 0.24,
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Right,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	AutomaticSize = Enum.AutomaticSize.X,
	Size = UDim2.new(0, 0, 1, 0),
	LayoutOrder = 2,
})

new("TextLabel", {
	Name = "ani",
	Parent = layout1,
	FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
	Text = "Animation Logger",
	TextColor3 = Color3.fromRGB(225, 67, 67),
	TextTransparency = 0.24,
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Right,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	AutomaticSize = Enum.AutomaticSize.X,
	Size = UDim2.new(0, 0, 1, 0),
	LayoutOrder = 3,
})

new("TextLabel", {
	Name = "vez",
	Parent = layout1,
	FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Regular, Enum.FontStyle.Italic),
	Text = "By Vez",
	TextColor3 = Color3.new(1, 1, 1),
	TextTransparency = 0.58,
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Right,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	AutomaticSize = Enum.AutomaticSize.X,
	Size = UDim2.new(0, 0, 1, 0),
	LayoutOrder = 4,
})

-- layout2 (right side of top bar — toggles)
local layout2 = new("Frame", {
	Name = "layout2",
	Parent = top,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(-4, 0),
	Size = UDim2.fromScale(1, 1),
	BorderSizePixel = 0,
})

new("UIListLayout", {
	Parent = layout2,
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Right,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 10),
})

-- Reusable toggle builder (togglelog / togglestack)
local function buildToggle(name, labelText, circleColor)
	local holder = new("Frame", {
		Name = name,
		Parent = layout2,
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Color3.fromRGB(22, 10, 10),
		BorderSizePixel = 0,
		Size = UDim2.new(0, 65, 1, -8),
		Visible = false,
	})
	new("UICorner", { Parent = holder, CornerRadius = UDim.new(0, 4) })
	new("UIStroke", {
		Parent = holder,
		Color = Color3.new(1, 1, 1),
		Thickness = 1,
		Transparency = 0.92,
	})

	local contain = new("Frame", {
		Name = "contain",
		Parent = holder,
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 5, 0.5, 0),
		Size = UDim2.fromOffset(10, 10),
	})
	new("UIListLayout", {
		Parent = contain,
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Left,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 4),
	})

	local circle = new("Frame", {
		Name = "circle",
		Parent = contain,
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = circleColor,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(8, 8),
	})
	new("UICorner", { Parent = circle, CornerRadius = UDim.new(1, 0) })

	new("TextLabel", {
		Parent = contain,
		FontFace = Font.new("rbxasset://fonts/families/Roboto.json"),
		Text = labelText,
		TextColor3 = Color3.new(1, 1, 1),
		TextTransparency = 0.32,
		TextSize = 11,
		TextXAlignment = Enum.TextXAlignment.Right,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		BorderSizePixel = 0,
		Size = UDim2.new(0, 0, 0, 0),
	})

	new("TextButton", {
		Parent = holder,
		Text = "",
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		AutoButtonColor = true,
		TextTransparency = 1,
	})

	local hover = new("Frame", {
		Name = "hover",
		Parent = holder,
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
	})
	new("UICorner", { Parent = hover, CornerRadius = UDim.new(0, 4) })

	return holder
end

buildToggle("togglelog",   "Logging",  Color3.fromRGB(0, 170, 0))
buildToggle("togglestack", "Stacking", Color3.fromRGB(50, 50, 50))

----------------------------------------------------------------
-- Contain (body under the top bar)
----------------------------------------------------------------
local contain = new("Frame", {
	Name = "contain",
	Parent = Background,
	BackgroundColor3 = Color3.fromRGB(217, 217, 217),
	BackgroundTransparency = 0.9999,
	BorderSizePixel = 0,
	Size = UDim2.fromOffset(676, 451),
	ZIndex = 2,
})
contain:SetAttribute("Id", "125_92")

----------------------------------------------------------------
-- Left panel (Logged Assets list)
----------------------------------------------------------------
local left = new("Frame", {
	Name = "left",
	Parent = contain,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(0, 30),
	Size = UDim2.fromOffset(238, 421),
})

-- right divider line
new("Frame", {
	Name = "line",
	Parent = left,
	AnchorPoint = Vector2.new(1, 0.5),
	BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	BorderSizePixel = 0,
	Position = UDim2.new(1, 0, 0.5, 0),
	Size = UDim2.new(0, 1, 1, 0),
})

-- header "Logged Assets"
local leftText = new("Frame", {
	Name = "text",
	Parent = left,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Size = UDim2.new(1, 0, -0.11876484, 100),
})
new("TextLabel", {
	Parent = leftText,
	AnchorPoint = Vector2.new(0, 0.5),
	FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json"),
	Text = "Logged Assets",
	TextColor3 = Color3.new(1, 1, 1),
	TextTransparency = 0.66,
	TextSize = 15,
	TextXAlignment = Enum.TextXAlignment.Left,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 15, 0.5, 0),
	Size = UDim2.fromOffset(200, 50),
	BorderSizePixel = 0,
})
new("Frame", {
	Name = "line",
	Parent = leftText,
	AnchorPoint = Vector2.new(0.5, 1),
	BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	BorderSizePixel = 0,
	Position = UDim2.new(0.5, 0, 1, 0),
	Size = UDim2.new(1, 0, 0, 1),
})

-- scroll container
local leftContain = new("Frame", {
	Name = "contain",
	Parent = left,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 0, 0.118764848, 0),
	Size = UDim2.fromOffset(236, 322),
})

local ScrollingFrame = new("ScrollingFrame", {
	Parent = leftContain,
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.new(1, -20, 1, -20),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	CanvasSize = UDim2.new(),
	ScrollBarThickness = 0,
	ScrollingDirection = Enum.ScrollingDirection.Y,
	ClipsDescendants = true,
	ScrollBarImageColor3 = Color3.new(0, 0, 0),
})
new("UIListLayout", {
	Parent = ScrollingFrame,
	FillDirection = Enum.FillDirection.Vertical,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	VerticalAlignment = Enum.VerticalAlignment.Top,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 0),
})

-- Template log row "logUn" (hidden, clone on demand)
local logUn = new("Frame", {
	Name = "logUn",
	Parent = ScrollingFrame,
	BackgroundColor3 = Color3.fromRGB(20, 4, 4),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Size = UDim2.new(1, 0, 0, 43),
	Visible = false,
})

local log = new("Frame", {
	Name = "log",
	Parent = logUn,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Size = UDim2.new(1, 0, 0, 33),
})
new("UIStroke", {
	Parent = log,
	ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
	Color = Color3.fromRGB(22, 22, 22),
	Thickness = 1,
})
new("UICorner", { Parent = log, CornerRadius = UDim.new(0, 5) })

new("TextButton", {
	Name = "vutton",
	Parent = log,
	AnchorPoint = Vector2.new(0.5, 0.5),
	AutoButtonColor = false,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(1, 1),
	Text = "",
	TextTransparency = 1,
})

new("TextLabel", {
	Parent = log,
	AnchorPoint = Vector2.new(0, 0.5),
	FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json"),
	Text = "rbxassetid://0",
	TextColor3 = Color3.fromRGB(115, 119, 129),
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Left,
	AutomaticSize = Enum.AutomaticSize.X,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 10, 0.5, 0),
	Size = UDim2.new(0, 0, 1, 0),
})

local logHover = new("Frame", {
	Name = "hover",
	Parent = log,
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(1, 1),
})
new("UICorner", { Parent = logHover, CornerRadius = UDim.new(0, 4) })

new("TextLabel", {
	Name = "multi",
	Parent = log,
	AnchorPoint = Vector2.new(1, 0.5),
	FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json"),
	Text = "x2",
	TextColor3 = Color3.fromRGB(0, 170, 0),
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Center,
	AutomaticSize = Enum.AutomaticSize.X,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.new(1, -10, 0.5, 0),
	Size = UDim2.new(0, 0, 1, 0),
	Visible = false,
})

----------------------------------------------------------------
-- Bottom bar (Clear Logs)
----------------------------------------------------------------
local bottom = new("Frame", {
	Name = "bottom",
	Parent = contain,
	BackgroundColor3 = Color3.fromRGB(5, 5, 5),
	BorderSizePixel = 0,
	Position = UDim2.new(0, 0, 0.871396899, 0),
	Size = UDim2.fromOffset(676, 58),
})
new("UICorner", { Parent = bottom, CornerRadius = UDim.new(0, 8) })

new("Frame", {
	Name = "line",
	Parent = bottom,
	AnchorPoint = Vector2.new(0.5, 0),
	BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	BorderSizePixel = 0,
	Position = UDim2.fromScale(0.5, 0),
	Size = UDim2.new(1, 0, 0, 1),
})

local bottomContain = new("Frame", {
	Name = "contain",
	Parent = bottom,
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.new(1, -19, 1, 0),
})
new("UIListLayout", {
	Parent = bottomContain,
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Right,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 9),
})

local clearBtn = new("Frame", {
	Name = "clear",
	Parent = bottomContain,
	BackgroundColor3 = Color3.fromRGB(153, 0, 0),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	LayoutOrder = 1,
	Size = UDim2.new(0, 100, 1, -20),
	Visible = false,
})
new("UICorner", { Parent = clearBtn, CornerRadius = UDim.new(0, 4) })
new("UIStroke", {
	Parent = clearBtn,
	Color = Color3.fromRGB(45, 53, 66),
	Thickness = 1,
})
new("TextLabel", {
	Parent = clearBtn,
	AnchorPoint = Vector2.new(0.5, 0.5),
	FontFace = Font.new("rbxasset://fonts/families/Roboto.json", Enum.FontWeight.Bold, Enum.FontStyle.Normal),
	Text = "Clear Logs",
	TextColor3 = Color3.new(1, 1, 1),
	TextTransparency = 0.16,
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Right,
	AutomaticSize = Enum.AutomaticSize.XY,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.new(),
})
new("TextButton", {
	Parent = clearBtn,
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(1, 1),
	Text = "",
	TextTransparency = 1,
})
local clearHover = new("Frame", {
	Name = "hover",
	Parent = clearBtn,
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(1, 1),
})
new("UICorner", { Parent = clearHover, CornerRadius = UDim.new(0, 4) })

new("Frame", {
	Name = "line",
	Parent = bottomContain,
	BackgroundColor3 = Color3.fromRGB(29, 29, 29),
	BorderSizePixel = 0,
	LayoutOrder = 1,
	Size = UDim2.new(0, 2, 1, -35),
	Visible = false,
})

----------------------------------------------------------------
-- Center panel (asset details: Name / Length / Priority / Action / Looped)
----------------------------------------------------------------
local center = new("Frame", {
	Name = "center",
	Parent = contain,
	BackgroundColor3 = Color3.fromRGB(10, 10, 10),
	BorderSizePixel = 0,
	Position = UDim2.new(0.352071017, 0, 0.0665188506, 0),
	Size = UDim2.fromOffset(438, 363),
})

local centerInner = new("Frame", {
	Name = "contain",
	Parent = center,
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.new(1, -30, 1, -30),
	Visible = false,
})
new("UIListLayout", {
	Parent = centerInner,
	FillDirection = Enum.FillDirection.Vertical,
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 10),
})

-- Field helper: prop label + big value
local function buildField(parent, propText, valueText, frameName)
	local f = new("Frame", {
		Name = frameName,
		Parent = parent,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(159, 58),
	})
	new("UIListLayout", {
		Parent = f,
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 5),
	})
	new("TextLabel", {
		Name = "prop",
		Parent = f,
		FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json"),
		Text = propText,
		TextColor3 = Color3.new(1, 1, 1),
		TextTransparency = 0.45,
		TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(),
	})
	new("TextLabel", {
		Name = "value",
		Parent = f,
		FontFace = Font.new("rbxasset://fonts/families/Roboto.json"),
		Text = valueText,
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 24,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Size = UDim2.new(),
	})
	return f
end

-- Row: Name
buildField(centerInner, "Name", "Animation", "name")

-- Row: Length + Priority + Action
local row = new("Frame", {
	Name = "contain",
	Parent = centerInner,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Size = UDim2.fromOffset(159, 58),
})
new("UIListLayout", {
	Parent = row,
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 30),
})
buildField(row, "Length",   "0:30:0",   "length")
buildField(row, "Priority", "Action",   "priority")

-- bottom inner divider
new("Frame", {
	Name = "line",
	Parent = centerInner,
	BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	BorderSizePixel = 0,
	Size = UDim2.new(1, 0, 0, 1),
})

-- Row: Looped  True/False
local propdif = new("Frame", {
	Name = "propdif",
	Parent = centerInner,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 0, 0.441441447, 0),
	Size = UDim2.new(1, 0, 0, 15),
	Visible = false,
})
new("TextLabel", {
	Name = "name",
	Parent = propdif,
	AnchorPoint = Vector2.new(0, 0.5),
	FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json"),
	Text = "Looped",
	TextColor3 = Color3.new(1, 1, 1),
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Right,
	AutomaticSize = Enum.AutomaticSize.XY,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 0, 0.5, 0),
	Size = UDim2.new(),
})
new("TextLabel", {
	Name = "value",
	Parent = propdif,
	AnchorPoint = Vector2.new(1, 0.5),
	FontFace = Font.new("rbxasset://fonts/families/RobotoMono.json"),
	Text = "True",
	TextColor3 = Color3.fromRGB(0, 170, 0),
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Right,
	AutomaticSize = Enum.AutomaticSize.XY,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.new(1, 0, 0.5, 0),
	Size = UDim2.new(),
})

----------------------------------------------------------------
-- Aspect ratio on the Background
----------------------------------------------------------------
new("UIAspectRatioConstraint", {
	Parent = Background,
	AspectRatio = 1.49889135,
	AspectType = Enum.AspectType.FitWithinMaxSize,
	DominantAxis = Enum.DominantAxis.Width,
})

----------------------------------------------------------------
-- "little" side panel (viewport + rig)
----------------------------------------------------------------
local little = new("Frame", {
	Name = "little",
	Parent = Background,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(-258, 48),
	Size = UDim2.fromOffset(238, 355),
	ZIndex = 5,
})
little:SetAttribute("Id", "170_2")

new("ImageLabel", {
	Name = "little",
	Parent = little,
	Image = getcustomasset and getcustomasset("Crimson/Assets/136563593316996.png") or "rbxassetid://136563593316996",
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(-24, -24),
	Size = UDim2.fromOffset(287, 404),
	ZIndex = 0,
})

local littleContain = new("Frame", {
	Name = "contain",
	Parent = little,
	BackgroundColor3 = Color3.new(1, 1, 1),
	BackgroundTransparency = 0.999,
	BorderSizePixel = 0,
	Size = UDim2.fromOffset(238, 355),
})
littleContain:SetAttribute("Id", "170_3")

local viewport = new("ViewportFrame", {
	Parent = littleContain,
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(1, 1),
	Ambient = Color3.fromRGB(200, 200, 200),
	LightColor = Color3.fromRGB(140, 140, 140),
	LightDirection = Vector3.new(-1, -1, -1)
})

local vpCamera = new("Camera", {
	Parent = viewport,
	CFrame = CFrame.new(0.203681, 3.980934, 9.968262) * CFrame.Angles(math.rad(-10), math.rad(180), 0),
	FieldOfView = 61.2252426,
})
viewport.CurrentCamera = vpCamera

local worldModel = new("WorldModel", { Name = "WorldModel", Parent = viewport })
----------------------------------------------------------------
-- Rig (R6 dummy inside viewport)
----------------------------------------------------------------
local Rig = new("Model", { Name = "Rig", Parent = worldModel })

local function makePart(props)
	local p = Instance.new("Part")
	p.Anchored      = false
	p.CanCollide    = props.CanCollide ~= false
	p.TopSurface    = Enum.SurfaceType.Smooth
	p.BottomSurface = Enum.SurfaceType.Smooth
	p.Material      = Enum.Material.Plastic
	p.Color         = Color3.fromRGB(163, 162, 165)
	p.Size          = props.Size
	p.CFrame        = props.CFrame
	p.Name          = props.Name
	p.Parent        = Rig
	return p
end

local Torso = makePart({
	Name = "Torso", Size = Vector3.new(2, 2, 1),
	CFrame = CFrame.new(0.130892411, 3, 17.281414),
})

local Head = makePart({
	Name = "Head", Size = Vector3.new(2, 1, 1),
	CFrame = CFrame.new(0.130892411, 4.5, 17.281414),
})
local headMesh = Instance.new("SpecialMesh")
headMesh.MeshType = Enum.MeshType.Head
headMesh.Scale = Vector3.new(1.25, 1.25, 1.25)
headMesh.Parent = Head

local face = Instance.new("Decal")
face.Name    = "face"
face.Texture = "rbxasset://textures/face.png"
face.Face    = Enum.NormalId.Front
face.Parent  = Head

local LeftArm  = makePart({ Name = "Left Arm",  Size = Vector3.new(1,2,1), CFrame = CFrame.new(-1.3691076, 3, 17.281414), CanCollide = false })
local RightArm = makePart({ Name = "Right Arm", Size = Vector3.new(1,2,1), CFrame = CFrame.new( 1.6308924, 3, 17.281414), CanCollide = false })
local LeftLeg  = makePart({ Name = "Left Leg",  Size = Vector3.new(1,2,1), CFrame = CFrame.new(-0.369107604, 1, 17.281414), CanCollide = false })
local RightLeg = makePart({ Name = "Right Leg", Size = Vector3.new(1,2,1), CFrame = CFrame.new( 0.630892396, 1, 17.281414), CanCollide = false })

local HRP = makePart({
	Name = "HumanoidRootPart",
	Size = Vector3.new(2, 2, 1),
	CFrame = CFrame.new(0.130892411, 3, 17.281414),
	CanCollide = false,
})
HRP.Transparency = 1
Rig.PrimaryPart = HRP

local function motor(name, parent, p0, p1, c0, c1)
	local m = Instance.new("Motor6D")
	m.Name = name
	m.Part0 = p0
	m.Part1 = p1
	m.C0 = c0
	m.C1 = c1
	m.MaxVelocity = 0.1
	m.Parent = parent
	return m
end

local rShoulderC0 = CFrame.new( 1, 0.5, 0) * CFrame.fromMatrix(Vector3.zero, Vector3.new(0,0,-1), Vector3.new(0,1,0))
local rShoulderC1 = CFrame.new(-0.5, 0.5, 0) * CFrame.fromMatrix(Vector3.zero, Vector3.new(0,0,-1), Vector3.new(0,1,0))
local lShoulderC0 = CFrame.new(-1, 0.5, 0) * CFrame.fromMatrix(Vector3.zero, Vector3.new(0,0, 1), Vector3.new(0,1,0))
local lShoulderC1 = CFrame.new( 0.5, 0.5, 0) * CFrame.fromMatrix(Vector3.zero, Vector3.new(0,0, 1), Vector3.new(0,1,0))
local rHipC0      = CFrame.new( 1, -1, 0) * CFrame.fromMatrix(Vector3.zero, Vector3.new(0,0,-1), Vector3.new(0,1,0))
local rHipC1      = CFrame.new( 0.5, 1, 0) * CFrame.fromMatrix(Vector3.zero, Vector3.new(0,0,-1), Vector3.new(0,1,0))
local lHipC0      = CFrame.new(-1, -1, 0) * CFrame.fromMatrix(Vector3.zero, Vector3.new(0,0, 1), Vector3.new(0,1,0))
local lHipC1      = CFrame.new(-0.5, 1, 0) * CFrame.fromMatrix(Vector3.zero, Vector3.new(0,0, 1), Vector3.new(0,1,0))
local neckC0      = CFrame.new(0, 1, 0)   * CFrame.fromMatrix(Vector3.zero, Vector3.new(-1,0,0), Vector3.new(0,0,1))
local neckC1      = CFrame.new(0, -0.5, 0) * CFrame.fromMatrix(Vector3.zero, Vector3.new(-1,0,0), Vector3.new(0,0,1))
local rootC0      = CFrame.fromMatrix(Vector3.zero, Vector3.new(-1,0,0), Vector3.new(0,0,1))
local rootC1      = rootC0

motor("Right Shoulder", Torso, Torso, RightArm, rShoulderC0, rShoulderC1)
motor("Left Shoulder",  Torso, Torso, LeftArm,  lShoulderC0, lShoulderC1)
motor("Right Hip",      Torso, Torso, RightLeg, rHipC0, rHipC1)
motor("Left Hip",       Torso, Torso, LeftLeg,  lHipC0, lHipC1)
motor("Neck",           Torso, Torso, Head,     neckC0, neckC1)
motor("RootJoint",      HRP,   HRP,   Torso,    rootC0, rootC1)

local Humanoid = Instance.new("Humanoid")
Humanoid.RigType = Enum.HumanoidRigType.R6
Humanoid.Parent = Rig

local Animator = Instance.new("Animator")
Animator.Parent = Humanoid

local BodyColors = Instance.new("BodyColors")
BodyColors.HeadColor3     = Color3.new(0.5, 0.5, 0.5)
BodyColors.TorsoColor3    = Color3.new(0.5, 0.5, 0.5)
BodyColors.LeftArmColor3  = Color3.new(0.5, 0.5, 0.5)
BodyColors.RightArmColor3 = Color3.new(0.5, 0.5, 0.5)
BodyColors.LeftLegColor3  = Color3.new(0.5, 0.5, 0.5)
BodyColors.RightLegColor3 = Color3.new(0.5, 0.5, 0.5)
BodyColors.Parent = Rig

----------------------------------------------------------------
-- Parent
----------------------------------------------------------------
AnimLoggerUI.Parent = game:GetService("CoreGui")

return AnimLoggerUI
