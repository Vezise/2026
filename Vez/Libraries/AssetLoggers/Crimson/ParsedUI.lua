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

local function new(class, props, children)
	local inst = Instance.new(class)
	if props then
		for k, v in pairs(props) do
			inst[k] = v
		end
	end
	if children then
		for _, c in ipairs(children) do
			c.Parent = inst
		end
	end
	return inst
end

local robotoBold   = Font.new("rbxasset://fonts/families/Roboto.json",     Enum.FontWeight.Bold,    Enum.FontStyle.Normal)
local robotoReg    = Font.new("rbxasset://fonts/families/Roboto.json",     Enum.FontWeight.Regular, Enum.FontStyle.Normal)
local robotoItalic = Font.new("rbxasset://fonts/families/Roboto.json",     Enum.FontWeight.Regular, Enum.FontStyle.Italic)
local robotoMono   = Font.new("rbxasset://fonts/families/RobotoMono.json", Enum.FontWeight.Regular, Enum.FontStyle.Normal)

local ScreenGui = new("ScreenGui", {
	Name = "AnimLoggerUI",
	ResetOnSpawn = true,
	ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})

local Background = new("Frame", {
	Name = "Background",
	Parent = ScreenGui,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(676, 451),
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
	Image = getcustomasset and getcustomasset("Crimson/Assets/108453875048733.png") or "rbxassetid://108453875048733",
	BackgroundTransparency = 1,
	Position = UDim2n(0, -24, 0, -24),
	Size = UDim2n(0, 725, 0, 500),
	ZIndex = 0,
})

local top = new("ImageLabel", {
	Name = "top",
	Parent = Background,
	Image = getcustomasset and getcustomasset("Crimson/Assets/82686076130111.png") or "rbxassetid://82686076130111",
	BackgroundTransparency = 1,
	BorderSizePixel = 1,
	Size = UDim2.fromOffset(676, 30),
})

local layout1 = new("Frame", {
	Name = "layout1",
	Parent = top,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(8, 0),
	Size = UDim2.fromScale(1, 1),
})

new("UIListLayout", {
	Parent = layout1,
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Left,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 8),
})

new("ImageLabel", {
	Name = "OFF",
	Parent = layout1,
	Image = getcustomasset and getcustomasset("Crimson/Assets/95222964296464.png") or "rbxassetid://95222964296464",
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(10, 9),
	Size = UDim2.fromOffset(12, 12),
	Visible = false,
	ZIndex = 3,
})

new("ImageLabel", {
	Name = "ON",
	Parent = layout1,
	Image = getcustomasset and getcustomasset("Crimson/Assets/114069756293603") or "rbxassetid://114069756293603",
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(22, 5),
	Size = UDim2.fromOffset(20, 20),
	ZIndex = 4,
})

new("TextLabel", {
	Name = "title",
	Parent = layout1,
	FontFace = robotoBold,
	Text = "CRIMSON",
	TextColor3 = Color3.new(1, 1, 1),
	TextSize = 14,
	TextTransparency = 0.24,
	TextXAlignment = Enum.TextXAlignment.Right,
	BackgroundTransparency = 1,
	AutomaticSize = Enum.AutomaticSize.X,
	Size = UDim2.fromScale(0, 1),
	LayoutOrder = 1,
})

new("TextLabel", {
	Name = "dash",
	Parent = layout1,
	FontFace = robotoBold,
	Text = "-",
	TextColor3 = Color3.new(1, 1, 1),
	TextSize = 14,
	TextTransparency = 0.24,
	TextXAlignment = Enum.TextXAlignment.Right,
	BackgroundTransparency = 1,
	AutomaticSize = Enum.AutomaticSize.X,
	Size = UDim2.fromScale(0, 1),
	LayoutOrder = 2,
})

new("TextLabel", {
	Name = "ani",
	Parent = layout1,
	FontFace = robotoBold,
	Text = "Animation Logger",
	TextColor3 = Color3.fromRGB(225, 67, 67),
	TextSize = 14,
	TextTransparency = 0.24,
	TextXAlignment = Enum.TextXAlignment.Right,
	BackgroundTransparency = 1,
	AutomaticSize = Enum.AutomaticSize.X,
	Size = UDim2.fromScale(0, 1),
	LayoutOrder = 3,
})

new("TextLabel", {
	Name = "vez",
	Parent = layout1,
	FontFace = robotoItalic,
	Text = "By Vez",
	TextColor3 = Color3.new(1, 1, 1),
	TextSize = 12,
	TextTransparency = 0.58,
	TextXAlignment = Enum.TextXAlignment.Right,
	BackgroundTransparency = 1,
	AutomaticSize = Enum.AutomaticSize.X,
	Size = UDim2.fromScale(0, 1),
	LayoutOrder = 4,
})

local layout2 = new("Frame", {
	Name = "layout2",
	Parent = top,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(-4, 0),
	Size = UDim2.fromScale(1, 1),
})

new("UIListLayout", {
	Parent = layout2,
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Right,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 10),
})

local function makeTogglePill(name, labelText)
	local pill = new("Frame", {
		Name = name,
		Parent = layout2,
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundColor3 = Color3.fromRGB(22, 10, 10),
		Size = UDim2.new(0, 65, 1, -8),
		Visible = false,
	})
	new("UICorner", { Parent = pill, CornerRadius = UDim.new(0, 4) })
	new("UIStroke", { Parent = pill, Color = Color3.new(1, 1, 1), Transparency = 0.92 })

	local contain = new("Frame", {
		Name = "contain",
		Parent = pill,
		AnchorPoint = Vector2.new(0, 0.5),
		BackgroundTransparency = 1,
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
		BackgroundColor3 = (name == "togglelog") and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(50, 50, 50),
		Size = UDim2.fromOffset(8, 8),
	})
	new("UICorner", { Parent = circle, CornerRadius = UDim.new(1, 0) })

	new("TextLabel", {
		Parent = contain,
		FontFace = robotoReg,
		Text = labelText,
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 11,
		TextTransparency = 0.32,
		TextXAlignment = Enum.TextXAlignment.Right,
		BackgroundTransparency = 1,
		AutomaticSize = Enum.AutomaticSize.XY,
		Size = UDim2.fromOffset(0, 0),
	})

	new("TextButton", {
		Parent = pill,
		Text = "",
		AutoButtonColor = true,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		TextTransparency = 1,
	})

	local hover = new("Frame", {
		Name = "hover",
		Parent = pill,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
	})
	new("UICorner", { Parent = hover, CornerRadius = UDim.new(0, 4) })

	return pill
end

local togglelog   = makeTogglePill("togglelog",   "Logging")
local togglestack = makeTogglePill("togglestack", "Stacking")

local contain = new("Frame", {
	Name = "contain",
	Parent = Background,
	BackgroundColor3 = Color3.fromRGB(217, 217, 217),
	BackgroundTransparency = 0.9999,
	BorderSizePixel = 0,
	Size = UDim2.fromOffset(676, 451),
	ZIndex = 2,
})

local left = new("Frame", {
	Name = "left",
	Parent = contain,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(0, 30),
	Size = UDim2.fromOffset(238, 421),
})

new("Frame", {
	Name = "line",
	Parent = left,
	AnchorPoint = Vector2.new(1, 0.5),
	BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	BorderSizePixel = 0,
	Position = UDim2.new(1, 0, 0.5, 0),
	Size = UDim2.new(0, 1, 1, 0),
})

local leftText = new("Frame", {
	Name = "text",
	Parent = left,
	BackgroundTransparency = 1,
	Size = UDim2.new(1, 0, -0.11876484, 100),
})

new("TextLabel", {
	Parent = leftText,
	FontFace = robotoMono,
	Text = "Logged Assets",
	TextColor3 = Color3.new(1, 1, 1),
	TextSize = 15,
	TextTransparency = 0.66,
	TextXAlignment = Enum.TextXAlignment.Left,
	AnchorPoint = Vector2.new(0, 0.5),
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 15, 0.5, 0),
	Size = UDim2.fromOffset(200, 50),
})

new("Frame", {
	Name = "line",
	Parent = leftText,
	AnchorPoint = Vector2.new(0.5, 1),
	BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	BorderSizePixel = 0,
	Position = UDim2.fromScale(0.5, 1),
	Size = UDim2.new(1, 0, 0, 1),
})

local leftList = new("Frame", {
	Name = "contain",
	Parent = left,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0.11876484, 0),
	Size = UDim2.fromOffset(236, 322),
})

local scroll = new("ScrollingFrame", {
	Parent = leftList,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.new(1, -20, 1, -20),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	ScrollBarThickness = 0,
	ScrollBarImageColor3 = Color3.new(0, 0, 0),
	ScrollingDirection = Enum.ScrollingDirection.Y,
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	CanvasSize = UDim2.new(),
})

new("UIListLayout", {
	Parent = scroll,
	FillDirection = Enum.FillDirection.Vertical,
	SortOrder = Enum.SortOrder.LayoutOrder,
	VerticalAlignment = Enum.VerticalAlignment.Top,
	Padding = UDim.new(0, 0),
})

local logUn = new("Frame", {
	Name = "logUn",
	Parent = scroll,
	BackgroundColor3 = Color3.fromRGB(20, 4, 4),
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	ClipsDescendants = true,
	Size = UDim2.new(1, 0, 0, 43),
	Visible = false,
})

local logEntry = new("Frame", {
	Name = "log",
	Parent = logUn,
	BackgroundTransparency = 1,
	Size = UDim2.new(1, 0, 0, 33),
})
new("UIStroke", {
	Parent = logEntry,
	Color = Color3.fromRGB(22, 22, 22),
	ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
	LineJoinMode = Enum.LineJoinMode.Round,
})
new("UICorner", { Parent = logEntry, CornerRadius = UDim.new(0, 5) })

new("TextButton", {
	Name = "vutton",
	Parent = logEntry,
	Text = "",
	AutoButtonColor = false,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	TextTransparency = 1,
})

new("TextLabel", {
	Parent = logEntry,
	FontFace = robotoMono,
	Text = "rbxassetid://0",
	TextColor3 = Color3.fromRGB(115, 119, 129),
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Left,
	AnchorPoint = Vector2.new(0, 0.5),
	BackgroundTransparency = 1,
	AutomaticSize = Enum.AutomaticSize.X,
	Position = UDim2.new(0, 10, 0.5, 0),
	Size = UDim2.new(0, 0, 1, 0),
})

local hover = new("Frame", {
	Name = "hover",
	Parent = logEntry,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
})
new("UICorner", { Parent = hover, CornerRadius = UDim.new(0, 4) })

new("TextLabel", {
	Name = "multi",
	Parent = logEntry,
	FontFace = robotoMono,
	Text = "x2",
	TextColor3 = Color3.fromRGB(0, 170, 0),
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Center,
	AnchorPoint = Vector2.new(1, 0.5),
	AutomaticSize = Enum.AutomaticSize.X,
	BackgroundTransparency = 1,
	Position = UDim2.new(1, -10, 0.5, 0),
	Size = UDim2.new(0, 0, 1, 0),
	Visible = false,
})

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

local btnContain = new("Frame", {
	Name = "contain",
	Parent = bottom,
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 1,
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.new(1, -19, 1, 0),
})

new("UIListLayout", {
	Parent = btnContain,
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Right,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 9),
})

local clearBtn = new("Frame", {
	Name = "clear",
	Parent = btnContain,
	BackgroundColor3 = Color3.fromRGB(153, 0, 0),
	BackgroundTransparency = 1,
	Size = UDim2.new(0, 100, 1, -20),
	LayoutOrder = 1,
	Visible = false,
})
new("UICorner", { Parent = clearBtn, CornerRadius = UDim.new(0, 4) })
new("UIStroke", { Parent = clearBtn, Color = Color3.fromRGB(45, 53, 66) })

new("TextLabel", {
	Parent = clearBtn,
	FontFace = robotoBold,
	Text = "Clear Logs",
	TextColor3 = Color3.new(1, 1, 1),
	TextSize = 14,
	TextTransparency = 0.16,
	TextXAlignment = Enum.TextXAlignment.Right,
	AnchorPoint = Vector2.new(0.5, 0.5),
	AutomaticSize = Enum.AutomaticSize.XY,
	BackgroundTransparency = 1,
	Position = UDim2.fromScale(0.5, 0.5),
})

new("TextButton", {
	Parent = clearBtn,
	Text = "",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	TextTransparency = 1,
})

local clearHover = new("Frame", {
	Name = "hover",
	Parent = clearBtn,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
})
new("UICorner", { Parent = clearHover, CornerRadius = UDim.new(0, 4) })

new("Frame", {
	Name = "line",
	Parent = btnContain,
	BackgroundColor3 = Color3.fromRGB(29, 29, 29),
	BorderSizePixel = 0,
	Size = UDim2.new(0, 2, 1, -35),
	LayoutOrder = 1,
	Visible = false,
})

local center = new("Frame", {
	Name = "center",
	Parent = contain,
	BackgroundColor3 = Color3.fromRGB(10, 10, 10),
	BorderSizePixel = 0,
	Position = UDim2.new(0.352071017, 0, 0.0665188506, 0),
	Size = UDim2.fromOffset(438, 363),
})

local centerContain = new("Frame", {
	Name = "contain",
	Parent = center,
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundTransparency = 1,
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.new(1, -30, 1, -30),
	Visible = false,
})

new("UIListLayout", {
	Parent = centerContain,
	FillDirection = Enum.FillDirection.Vertical,
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 10),
})

local function makePropRow(propName, propValue, valueColor)
	local frame = new("Frame", {
		Parent = centerContain,
		BackgroundTransparency = 1,
		Size = UDim2.fromOffset(159, 58),
	})
	new("UIListLayout", {
		Parent = frame,
		FillDirection = Enum.FillDirection.Vertical,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 5),
	})
	new("TextLabel", {
		Name = "prop",
		Parent = frame,
		FontFace = robotoMono,
		Text = propName,
		TextColor3 = Color3.new(1, 1, 1),
		TextSize = 15,
		TextTransparency = 0.45,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
	})
	new("TextLabel", {
		Name = "value",
		Parent = frame,
		FontFace = robotoReg,
		Text = propValue,
		TextColor3 = valueColor or Color3.new(1, 1, 1),
		TextSize = 24,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundTransparency = 1,
	})
	return frame
end

local row1 = new("Frame", {
	Parent = centerContain,
	BackgroundTransparency = 1,
	Size = UDim2.fromOffset(159, 58),
})
new("UIListLayout", {
	Parent = row1,
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 30),
})

makePropRow("Name",   "Animation"):SetAttribute("LayoutOrder", 0)

local row2 = new("Frame", {
	Parent = centerContain,
	BackgroundTransparency = 1,
	Size = UDim2.fromOffset(159, 58),
})
new("UIListLayout", {
	Parent = row2,
	FillDirection = Enum.FillDirection.Horizontal,
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
	VerticalAlignment = Enum.VerticalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 30),
})

local lengthFrame   = makePropRow("Length",   "0:30:0")
lengthFrame.Parent = row2
local priorityFrame = makePropRow("Priority", "Action")
priorityFrame.Parent = row2

new("Frame", {
	Name = "line",
	Parent = centerContain,
	BackgroundColor3 = Color3.fromRGB(22, 22, 22),
	BorderSizePixel = 0,
	Size = UDim2.new(1, 0, 0, 1),
})

local propdif = new("Frame", {
	Name = "propdif",
	Parent = centerContain,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0.441441447, 0),
	Size = UDim2.new(1, 0, 0, 15),
	Visible = false,
})
new("TextLabel", {
	Name = "name",
	Parent = propdif,
	FontFace = robotoMono,
	Text = "Looped",
	TextColor3 = Color3.new(1, 1, 1),
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Right,
	AnchorPoint = Vector2.new(0, 0.5),
	AutomaticSize = Enum.AutomaticSize.XY,
	BackgroundTransparency = 1,
	Position = UDim2.new(0, 0, 0.5, 0),
})
new("TextLabel", {
	Name = "value",
	Parent = propdif,
	FontFace = robotoMono,
	Text = "True",
	TextColor3 = Color3.fromRGB(0, 170, 0),
	TextSize = 14,
	TextXAlignment = Enum.TextXAlignment.Right,
	AnchorPoint = Vector2.new(1, 0.5),
	AutomaticSize = Enum.AutomaticSize.XY,
	BackgroundTransparency = 1,
	Position = UDim2.new(1, 0, 0.5, 0),
})

local little = new("Frame", {
	Name = "little",
	Parent = Background,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(-258, 48),
	Size = UDim2.fromOffset(238, 355),
	ZIndex = 5,
})

new("ImageLabel", {
	Name = "little",
	Parent = little,
	Image = getcustomasset and getcustomasset("Violet/Assets/136563593316996.png") or "rbxassetid://136563593316996",

	BackgroundTransparency = 1,
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

local viewport = new("ViewportFrame", {
	Parent = littleContain,
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	Ambient = Color3.fromRGB(200, 200, 200),
	LightColor = Color3.fromRGB(140, 140, 140),
	LightDirection = Vector3.new(-1, -1, -1)
})

local vpCamera = Instance.new("Camera")
vpCamera.CFrame = CFrame.new(0.2037, 3.9809, 9.9683)
	* CFrame.fromMatrix(
		Vector3.zero,
		Vector3.new(-1, 0, 8.7423e-08),
		Vector3.new(1.5181e-08, 0.98481, 0.17365),
		Vector3.new(-8.6095e-08, 0.17365, -0.98481)
	)
vpCamera.FieldOfView = 61.2252426
vpCamera.Parent = viewport
viewport.CurrentCamera = vpCamera

local Rig = new("Model", { Name = "Rig", Parent = viewport })

local function makePart(props)
	local p = Instance.new("Part")
	p.Anchored = false
	p.CanCollide   = props.CanCollide ~= false
	p.TopSurface   = Enum.SurfaceType.Smooth
	p.BottomSurface= Enum.SurfaceType.Smooth
	p.Material = Enum.Material.Plastic
	p.Color= Color3.fromRGB(163, 162, 165)
	p.Size = props.Size
	p.CFrame   = props.CFrame
	p.Name = props.Name
	p.Parent   = Rig
	return p
end

local Torso = makePart({
	Name   = "Torso",
	Size   = Vector3.new(2, 2, 1),
	CFrame = CFrame.new(0.130892411, 3, 17.281414),
})

local Head = makePart({
	Name   = "Head",
	Size   = Vector3.new(2, 1, 1),
	CFrame = CFrame.new(0.130892411, 4.5, 17.281414),
})
local headMesh = Instance.new("SpecialMesh")
headMesh.MeshType = Enum.MeshType.Head
headMesh.Scale= Vector3.new(1.25, 1.25, 1.25)
headMesh.Parent   = Head

local face = Instance.new("Decal")
face.Name= "face"
face.Texture = "rbxasset://textures/face.png"
face.Face= Enum.NormalId.Front
face.Parent  = Head

local LeftArm = makePart({
	Name = "Left Arm",
	Size = Vector3.new(1, 2, 1),
	CFrame = CFrame.new(-1.3691076, 3, 17.281414),
	CanCollide = false,
})
local RightArm = makePart({
	Name = "Right Arm",
	Size = Vector3.new(1, 2, 1),
	CFrame = CFrame.new(1.6308924, 3, 17.281414),
	CanCollide = false,
})
local LeftLeg = makePart({
	Name = "Left Leg",
	Size = Vector3.new(1, 2, 1),
	CFrame = CFrame.new(-0.369107604, 1, 17.281414),
	CanCollide = false,
})
local RightLeg = makePart({
	Name = "Right Leg",
	Size = Vector3.new(1, 2, 1),
	CFrame = CFrame.new(0.630892396, 1, 17.281414),
	CanCollide = false,
})

local HRP = makePart({
	Name = "HumanoidRootPart",
	Size = Vector3.new(2, 2, 1),
	CFrame = CFrame.new(0.130892411, 3, 17.281414),
	CanCollide = false,
})
HRP.Transparency = 1
HRP.Color = Color3.fromRGB(165, 165, 165)

Rig.PrimaryPart = HRP

local function motor(name, parent, part0, part1, c0, c1)
	local m = Instance.new("Motor6D")
	m.Name = name
	m.Part0 = part0
	m.Part1 = part1
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
local rHipC0 = CFrame.new( 1, -1, 0) * CFrame.fromMatrix(Vector3.zero, Vector3.new(0,0,-1), Vector3.new(0,1,0))
local rHipC1 = CFrame.new( 0.5, 1, 0) * CFrame.fromMatrix(Vector3.zero, Vector3.new(0,0,-1), Vector3.new(0,1,0))
local lHipC0 = CFrame.new(-1, -1, 0) * CFrame.fromMatrix(Vector3.zero, Vector3.new(0,0, 1), Vector3.new(0,1,0))
local lHipC1 = CFrame.new(-0.5, 1, 0) * CFrame.fromMatrix(Vector3.zero, Vector3.new(0,0, 1), Vector3.new(0,1,0))
local neckC0 = CFrame.new(0, 1, 0) * CFrame.fromMatrix(Vector3.zero, Vector3.new(-1,0,0), Vector3.new(0,0,1))
local neckC1 = CFrame.new(0, -0.5, 0) * CFrame.fromMatrix(Vector3.zero, Vector3.new(-1,0,0), Vector3.new(0,0,1))
local rootC0 = CFrame.new(0, 0, 0) * CFrame.fromMatrix(Vector3.zero, Vector3.new(-1,0,0), Vector3.new(0,0,1))
local rootC1 = rootC0

motor("Right Shoulder", Torso, Torso, RightArm, rShoulderC0, rShoulderC1)
motor("Left Shoulder",  Torso, Torso, LeftArm,  lShoulderC0, lShoulderC1)
motor("Right Hip", Torso, Torso, RightLeg, rHipC0, rHipC1)
motor("Left Hip",  Torso, Torso, LeftLeg,  lHipC0, lHipC1)
motor("Neck", Torso, Torso, Head, neckC0, neckC1)
motor("RootJoint", HRP,   HRP,   Torso,rootC0, rootC1)

local Humanoid = Instance.new("Humanoid")
Humanoid.RigType = Enum.HumanoidRigType.R6
Humanoid.Parent = Rig

local Animator = Instance.new("Animator")
Animator.Parent = Humanoid

local BodyColors = Instance.new("BodyColors")
BodyColors.HeadColor3 = Color3.new(0.5, 0.5, 0.5)
BodyColors.TorsoColor3 = Color3.new(0.5, 0.5, 0.5)
BodyColors.LeftArmColor3 = Color3.new(0.5, 0.5, 0.5)
BodyColors.RightArmColor3 = Color3.new(0.5, 0.5, 0.5)
BodyColors.LeftLegColor3 = Color3.new(0.5, 0.5, 0.5)
BodyColors.RightLegColor3 = Color3.new(0.5, 0.5, 0.5)
BodyColors.Parent = Rig

AnimLoggerUI.Parent = game:GetService("CoreGui")

return AnimLoggerUI
