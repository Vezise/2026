local repo = "https://raw.githubusercontent.com/Vezise/2026/main/Vez/Libraries/AssetLoggers/Violet/"
local load = function(f) return loadstring(game:HttpGet(repo .. f))() end
local fetch = function(f) return game:HttpGet(repo .. f) end

getgenv().UnpAcK = base64decode
local TweenService = cloneref and cloneref(game:GetService("TweenService")) or game:GetService("TweenService")
local UserInputService = cloneref and cloneref(game:GetService("UserInputService")) or game:GetService("UserInputService")
local Players = cloneref and cloneref(game:GetService("Players")) or game:GetService("Players")
local CoreGui = cloneref and cloneref(game:GetService("CoreGui")) or game:GetService("CoreGui")
local TextService = cloneref and cloneref(game:GetService("TextService")) or game:GetService("TextService")

local existing = CoreGui:FindFirstChild("SoundLoggerUI")
if existing then existing:Destroy() end

local RBXMXParser = load("RBXMXParser.lua")
local SoundLoggerUI = load("ParsedUI")

local ActiveTweens = {}
local TWEEN_FAST = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_DEFAULT = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local Style = {
	selected   = { transparency = 0,   strokeColor = Color3.fromRGB(51, 3, 53) },
	unselected = { transparency = 1,   strokeColor = Color3.fromRGB(22, 22, 22) },
	hover      = { transparency = 0.95 },
	toggleOn   = Color3.fromRGB(0, 170, 0),
	toggleOff  = Color3.fromRGB(50, 50, 50),
}

local function tween(instance, properties, info)
	pcall(function()
		if ActiveTweens[instance] then
			ActiveTweens[instance]:Cancel()
		end
		local t = TweenService:Create(instance, info or TWEEN_DEFAULT, properties)
		t.Completed:Connect(function()
			ActiveTweens[instance] = nil
		end)
		ActiveTweens[instance] = t
		t:Play()
		return t
	end)
end

do
	local worldModel = SoundLoggerUI.Background.little.contain.ViewportFrame.WorldModel
	local rig = worldModel.Rig
	rig:Destroy()

	local clone = Instance.new("Model")
	clone.Name = "ViewModel"
    clone.Parent = worldModel

	local primaryPart = Instance.new("Part")
	primaryPart.Name = "PrimaryPart"
	primaryPart.Anchored = true
	primaryPart.Transparency = 1
end

local scrollingFrame = SoundLoggerUI.Background.contain.left.contain.ScrollingFrame
local tabTemplate = scrollingFrame.logUn
local contentTemplate = SoundLoggerUI.Background.contain.center.contain
local tabs = {}

local function selectTab(target)
	for _, entry in tabs do
		local selected = (entry == target)
		local log = entry.tab:FindFirstChild("log")

		if log then
			tween(log, { BackgroundTransparency = selected and Style.selected.transparency or Style.unselected.transparency })
			tween(log.hover, { BackgroundTransparency = Style.unselected.transparency }, TWEEN_FAST)

			local stroke = log:FindFirstChildWhichIsA("UIStroke")
			if stroke then
				tween(stroke, { Color = selected and Style.selected.strokeColor or Style.unselected.strokeColor })
			end
		end

		entry.content.Visible = selected
	end
end

local function connectHover(button, tab, content)
	button.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and not content.Visible then
			local log = tab:FindFirstChild("log")
			if log then tween(log.hover, { BackgroundTransparency = Style.hover.transparency }, TWEEN_FAST) end
		end
	end)

	button.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement and not content.Visible then
			local log = tab:FindFirstChild("log")
			if log then tween(log.hover, { BackgroundTransparency = Style.unselected.transparency }, TWEEN_FAST) end
		end
	end)
end

do
	local background = SoundLoggerUI.Background
	local dragging, dragStart, startPos

	background.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = background.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			tween(background, {
				Position = UDim2.new(
					startPos.X.Scale, startPos.X.Offset + delta.X,
					startPos.Y.Scale, startPos.Y.Offset + delta.Y
				)
			}, TWEEN_FAST)
		end
	end)
end

local lib = {}
local stackingEnabled = false

local function getTabGroups()
	local groups = {}
	for _, entry in tabs do
		local id = entry.tab.Name
		if not groups[id] then
			groups[id] = {}
		end
		table.insert(groups[id], entry)
	end

	return groups
end

local function updateStackIndicator(entry, count)
	local log = entry.tab:FindFirstChild("log")
	if not log then return end
	local multi = log:FindFirstChild("multi")
	if not multi then return end
	if count and count > 1 then
		multi.Text = "x"..tostring(count)
		multi.Visible = true
	else
		multi.Visible = false
	end
end

local function hideTab(entry)
	local t = tween(entry.tab, { Size = UDim2.new(1, 0, 0, 0) }, TWEEN_DEFAULT)
	t.Completed:Connect(function()
		entry.tab.Visible = false
	end)
	if entry.content.Visible then
		entry.content.Visible = false
	end
end

local function showTab(entry)
	entry.tab.Visible = true
	entry.tab.Size = UDim2.new(1, 0, 0, 0)
	tween(entry.tab, { Size = UDim2.new(1, 0, 0, 43) }, TWEEN_DEFAULT)
end

function lib:stackTabs()
	local Success, Error = pcall(function()
		stackingEnabled = true
		local groups = getTabGroups()
		for _, group in groups do
			if #group > 1 then
				updateStackIndicator(group[1], #group)
				for i = 2, #group do
					local entry = group[i]
					if entry.tab and entry.tab.Parent then
						entry.tab:Destroy()
					end
					if entry.content and entry.content.Parent then
						entry.content:Destroy()
					end
				end
			end
		end
	end)
	if not Success then warn(`Crimson UI Library had an issue (stackTabs): {Error}`) end
end

function lib:unstackTabs()
	local Success, Error = pcall(function()
		stackingEnabled = false
		--[[
		local groups = getTabGroups()
		for _, group in groups do
			if #group > 1 then
				updateStackIndicator(group[1], nil)
				for i = 2, #group do
					showTab(group[i])
				end
			end
		end]]
	end)
	if not Success then warn(`Crimson UI Library had an issue (unstackTabs): {Error}`) end
end

function lib:isStacking()
	return stackingEnabled
end

function lib:createLog(id, name, length, priority, callback)
	local funcs = {}

	local tab = tabTemplate:Clone()
	tab.Name = id
	tab.Visible = true
    tab.Size = UDim2.new(1,0,0,0)
	tab.Parent = scrollingFrame

	local log = tab:FindFirstChild("log")
	if log then
		local label = log:FindFirstChild("TextLabel")
		if label then label.Text = id end
	end

	tween(tab, { Size = UDim2.new(1,0,0,43) }, TWEEN_DEFAULT)

	local content = contentTemplate:Clone()
	content.Name = id
	content.Visible = false
	content.Parent = contentTemplate.Parent

	content.name.value.Text = name
	content.contain.length.value.Text = length
	content.contain.priority.value.Text = priority

	local entry = { tab = tab, content = content }
	
	local isDuplicate = false
	local existingEntry = nil
	
	if stackingEnabled then
		for _, checkEntry in tabs do
			if checkEntry.tab.Name == id then
				isDuplicate = true
				existingEntry = checkEntry
				break
			end
		end
	end
	
	if isDuplicate and existingEntry then
		local log = existingEntry.tab:FindFirstChild("log")
		local multi = log and log:FindFirstChild("multi")
		local currentCount = 1
		
		if multi and multi.Visible then
			local countStr = multi.Text:match("x(%d+)")
			currentCount = tonumber(countStr) or 1
		end
		
		if currentCount ~= 999 then
			updateStackIndicator(existingEntry, currentCount + 1)
		end
		tab:Destroy()
		content:Destroy()
	else
		table.insert(tabs, entry)
		tab.LayoutOrder = -#tabs

		local button = tab:FindFirstChildWhichIsA("TextButton", true)
		if button then
			button.MouseButton1Click:Connect(function()
	            selectTab(entry)
	            if callback then callback() end
	        end)
			connectHover(button, tab, content)
		end
	end
		
	function funcs:makeProperty(name, val, color)
		if isDuplicate then
			return
		end
		
		local prop = content.propdif:Clone()
		prop.Visible = true
		prop.name.Text = name
		prop.value.Text = val
		if color then
			prop.value.TextColor3 = color
		end
		prop.Parent = content
	end

	return funcs
end

function lib:clearLogs()
	for Instance, Tween in ActiveTweens do
		if Tween then
			Tween:Cancel()
			ActiveTweens[Instance] = nil
		end
	end

	for _, Entry in tabs do
		if Entry.tab and Entry.tab.Parent then
			Entry.tab:Destroy()
		end
			
		if Entry.content and Entry.content.Parent then
			Entry.content:Destroy()
		end
	end
		
	for _, Log in CoreGui.SoundLoggerUI.Background.contain.left.contain.ScrollingFrame:GetChildren() do
		if Log.Name ~= "logUn" and Log.Name ~= "UIListLayout" then
			Log:Destroy()
		end
	end

	for _, Content in CoreGui.SoundLoggerUI.Background.contain.center:GetChildren() do
		if Content.Name ~= "contain" then
			Content:Destroy()
		end
	end
		
	tabs = {}
end

function lib:createTopToggle(name, callback)
	local parent = SoundLoggerUI.Background.top.layout2
	local toggle = parent.togglelog:Clone()
	toggle.Visible = true
	toggle.Parent = parent

	local circle = toggle.contain.circle
	local label = toggle.contain.TextLabel
	label.Text = name
	circle.BackgroundColor3 = Style.toggleOff
	task.wait()
	toggle.Size = UDim2.new(0, label.TextBounds.X + 25, 1, -8)

	local toggled = false

	local function setToggle(state)
		toggled = state
		tween(circle, { BackgroundColor3 = toggled and Style.toggleOn or Style.toggleOff })
		if callback then callback(toggled) end
	end

	local button = toggle:FindFirstChildWhichIsA("TextButton", true)
	if button then
		button.MouseButton1Click:Connect(function() setToggle(not toggled) end)
		button.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				tween(toggle.hover, { BackgroundTransparency = Style.hover.transparency }, TWEEN_FAST)
			end
		end)
		button.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				tween(toggle.hover, { BackgroundTransparency = 1 }, TWEEN_FAST)
			end
		end)
	else
		toggle.contain.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				setToggle(not toggled)
			end
		end)
	end
end

function lib:createSoundToggle(name, callback)
	local parent = SoundLoggerUI.Background.little.contain.layout2
	local toggle = parent.togglestack:Clone()
	toggle.Visible = true
	toggle.Parent = parent

	local circle = toggle.contain.circle
	local label = toggle.contain.TextLabel
	label.Text = name
	circle.BackgroundColor3 = Style.toggleOff
	task.wait()
	toggle.Size = UDim2.new(0, label.TextBounds.X + 25, 1, -8)

	local toggled = false

	local function setToggle(state)
		toggled = state
		tween(circle, { BackgroundColor3 = toggled and Style.toggleOn or Style.toggleOff })
		if callback then callback(toggled) end
	end

	local button = toggle:FindFirstChildWhichIsA("TextButton", true)
	if button then
		button.MouseButton1Click:Connect(function() setToggle(not toggled) end)
		button.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				tween(toggle.hover, { BackgroundTransparency = Style.hover.transparency }, TWEEN_FAST)
			end
		end)
		button.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				tween(toggle.hover, { BackgroundTransparency = 1 }, TWEEN_FAST)
			end
		end)
	else
		toggle.contain.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				setToggle(not toggled)
			end
		end)
	end
end

function lib:createBottomButton(name, callback)
	local parent = SoundLoggerUI.Background.contain.bottom.contain
	local toggle = parent.clear:Clone()
	toggle.Visible = true
	toggle.Parent = parent
	toggle.Name = name

	local label = toggle.TextLabel
	label.Name = name
	label.Text = name
	toggle.Size = UDim2.new(0, label.TextBounds.X + 25, 1, -20)

	local button = toggle:FindFirstChildWhichIsA("TextButton", true)
	if button then
		button.MouseButton1Click:Connect(callback)
		button.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				tween(toggle.hover, { BackgroundTransparency = Style.hover.transparency }, TWEEN_FAST)
			end
		end)
		button.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				tween(toggle.hover, { BackgroundTransparency = 1 }, TWEEN_FAST)
			end
		end)
	end
end

function lib:updateBottomButton(button, name)
	local parent = SoundLoggerUI.Background.contain.bottom.contain
	local toggle = parent:FindFirstChild(button)
	if not toggle then return end
	local textLabel = toggle:FindFirstChild(button)
	if textLabel then
		textLabel.Text = name
		textLabel.Name = name
	end
	toggle.Name = name
	local newLabel = toggle:FindFirstChild(name)
	if newLabel then
		toggle.Size = UDim2.new(0, newLabel.TextBounds.X + 25, 1, -20)
	end
end

function lib:createButtomLine()
	local parent = SoundLoggerUI.Background.contain.bottom.contain
	local toggle = parent.line:Clone()
	toggle.Visible = true
	toggle.Parent = parent
end

local NotiOriginals = {}

function lib:createSmallNoti(text, icon, duration)
    local parent = SoundLoggerUI.Background.noticontain
    local noti = parent.small:Clone()
	noti.Name = "sigma"
	noti.noti.TextLabel.Text = text
	noti.noti.ImageLabel.Image = icon
	noti.Size = UDim2.new(0, 95,0, 0)
    noti.Visible = true
    noti.Parent = parent
	
	local textSizeX = noti.noti.TextLabel.TextBounds.X + 50
	noti.noti.Size = UDim2.new(0, textSizeX > 150 and textSizeX or 150, 0, 36)
	
	local tweenInfo = TweenInfo.new(.6, Enum.EasingStyle.Quint)
	tween(noti, { Size = UDim2.new(0, 95,0, 41) }, tweenInfo)
	lib:tweenNotiTransparency(noti, "out", TweenInfo.new(0))
	task.wait()
	lib:tweenNotiTransparency(noti, "in", TweenInfo.new(1, Enum.EasingStyle.Quint))
	
	task.delay(duration or 3, function()
		tween(noti, { Size = UDim2.new(0, 95,0, 0) }, tweenInfo)
		lib:tweenNotiTransparency(noti, "out", TweenInfo.new(1, Enum.EasingStyle.Quint))
		task.wait(1)
		NotiOriginals[noti] = nil
		noti:Destroy()
	end)
end

function lib:createBigNoti(title, desc, icon, duration)
    local parent = SoundLoggerUI.Background.noticontain
    local noti = parent.big:Clone()
	noti.Name = "sigma"
	noti.noti.moretext.desc.Text = desc
	noti.noti.moretext.title.Text = title
	noti.noti.ImageLabel.Image = icon
	noti.Size = UDim2.new(0, 95,0, 0)
    noti.Visible = true
    noti.Parent = parent
	local descLabel = noti.noti.moretext.desc
	local rawBounds = descLabel.TextBounds
	local textSizeX = rawBounds.X + 50
	local titleBoundsX = noti.noti.moretext.title.TextBounds.X
	local titleSizeX = titleBoundsX > 100 and (titleBoundsX + 50) or 0
	local tweenInfo = TweenInfo.new(.6, Enum.EasingStyle.Quint)
	
	if textSizeX >= 250 then
		local notiWidth = math.max(250, titleSizeX)
		noti.noti.Size = UDim2.new(0, notiWidth, 0, 0)
		local wrapWidth = noti.noti.AbsoluteSize.X - 50
		local lineH = rawBounds.Y
		local lines = math.max(1, math.ceil(rawBounds.X / wrapWidth))
		local wrappedHeight = (lines + 1) * lineH
		descLabel.AutomaticSize = Enum.AutomaticSize.None
		descLabel.TextWrapped = true
		descLabel.Size = UDim2.new(0, wrapWidth, 0, wrappedHeight)
		noti.noti.moretext.Size = UDim2.new(1, 0, 0, wrappedHeight + 20)
		noti.noti.Size = UDim2.new(0, notiWidth, 0, wrappedHeight + 40)
		tween(noti, { Size = UDim2.new(0, 95, 0, wrappedHeight + 45) }, tweenInfo)
	else
		local notiWidth = math.max(textSizeX > 170 and textSizeX or 170, titleSizeX)
		noti.noti.Size = UDim2.new(0, notiWidth, 0, 55)
		tween(noti, { Size = UDim2.new(0, 95,0, 60) }, tweenInfo)
	end
	
	lib:tweenNotiTransparency(noti, "out", TweenInfo.new(0))
	task.wait()
	lib:tweenNotiTransparency(noti, "in", TweenInfo.new(1, Enum.EasingStyle.Quint))
	
	task.delay(duration or 3, function()
		tween(noti, { Size = UDim2.new(0, 95,0, 0) }, tweenInfo)
		lib:tweenNotiTransparency(noti, "out", TweenInfo.new(1, Enum.EasingStyle.Quint))
		task.wait(1)
		NotiOriginals[noti] = nil
		noti:Destroy()
	end)
end

function lib:createBigButtonNoti(title, desc, icon, duration)
    local parent = SoundLoggerUI.Background.noticontain
    local noti = parent.bigbutton:Clone()
	noti.Name = "sigma"
	noti.noti.noti.moretext.desc.Text = desc
	noti.noti.noti.moretext.title.Text = title
	noti.noti.noti.ImageLabel.Image = icon
	noti.Size = UDim2.new(0, 95,0, 0)
    noti.Visible = true
    noti.Parent = parent
	local descLabel = noti.noti.noti.moretext.desc
	local rawBounds = descLabel.TextBounds
	local textSizeX = rawBounds.X + 50
	local titleBoundsX = noti.noti.noti.moretext.title.TextBounds.X
	local titleSizeX = titleBoundsX > 100 and (titleBoundsX + 50) or 0
	local tweenInfo = TweenInfo.new(.6, Enum.EasingStyle.Quint)
	if textSizeX >= 250 then
		local notiWidth = math.max(250, titleSizeX)
		noti.noti.Size = UDim2.new(0, notiWidth, 0, 0)
		local wrapWidth = noti.noti.AbsoluteSize.X - 50
		local lineH = rawBounds.Y
		local lines = math.max(1, math.ceil(rawBounds.X / wrapWidth))
		local wrappedHeight = (lines + 1) * lineH
		descLabel.AutomaticSize = Enum.AutomaticSize.None
		descLabel.TextWrapped = true
		descLabel.Size = UDim2.new(0, wrapWidth, 0, wrappedHeight)
		noti.noti.noti.moretext.Size = UDim2.new(1, 0, 0, wrappedHeight + 20)
		noti.noti.noti.Size = UDim2.new(1, 0, 0, wrappedHeight + 40)
		noti.noti.Size = UDim2.new(0, notiWidth, 0, wrappedHeight + 70)
		tween(noti, { Size = UDim2.new(0, 95, 0, wrappedHeight + 75) }, tweenInfo)
	else
		local notiWidth = math.max(textSizeX > 170 and textSizeX or 170, titleSizeX)
		noti.noti.Size = UDim2.new(0, notiWidth, 0, 85)
		tween(noti, { Size = UDim2.new(0, 95,0, 85+5) }, tweenInfo)
	end
	local functions = {}

	local BUTTON_FRAME = noti.noti.Frame
	local BUTTON_SEP = 5
	local BUTTON_PADDING = 20
	local buttons = {}

	local function relayoutButtons()
		local n = #buttons
		if n == 0 then return end
		local frameWidth = BUTTON_FRAME.AbsoluteSize.X
		local totalSep = (n - 1) * BUTTON_SEP
		local equalWidth = (frameWidth - totalSep) / n
		local maxTextWidth = 0
		
		for _, b in buttons do
			if b.textWidth > maxTextWidth then
				maxTextWidth = b.textWidth
			end
		end
		
		local minNeeded = maxTextWidth + BUTTON_PADDING
		local btnWidth = math.max(equalWidth, minNeeded)
		
		for i, b in buttons do
			b.btn.AnchorPoint = Vector2.new(0, 0)
			b.btn.Size = UDim2.new(0, btnWidth, 1, 0)
			b.btn.Position = UDim2.new(0, (i - 1) * (btnWidth + BUTTON_SEP), 0, 0)
		end
	end

	function functions:createButton(text, callback)
		local btn = BUTTON_FRAME.Button:Clone()
		btn.Visible = true
		btn.TextLabel.Text = text
		btn.Parent = BUTTON_FRAME

		local originals = NotiOriginals[noti]
		if originals then
			local function restore(template, clone)
				local saved = originals[template]
				if saved then
					for prop, val in saved do
						clone[prop] = val
					end
				end
				local tc = template:GetChildren()
				local cc = clone:GetChildren()
				for i, t in tc do
					if cc[i] then restore(t, cc[i]) end
				end
			end
			restore(BUTTON_FRAME.Button, btn)
		end

		btn.TextButton.MouseButton1Click:Connect(callback)

		btn.TextButton.BackgroundTransparency = 1
		local hoverInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quint)
		btn.TextButton.MouseEnter:Connect(function()
			tween(btn.TextButton, { BackgroundTransparency = 0.95 }, hoverInfo)
		end)
		btn.TextButton.MouseLeave:Connect(function()
			tween(btn.TextButton, { BackgroundTransparency = 1 }, hoverInfo)
		end)

		local tl = btn.TextLabel
		task.wait()
		local textWidth = tl.TextBounds.X
		table.insert(buttons, { btn = btn, textWidth = textWidth })
		relayoutButtons()
	end

	function functions:Close()
		tween(noti, { Size = UDim2.new(0, 95,0, 0) }, tweenInfo)
		lib:tweenNotiTransparency(noti, "out", TweenInfo.new(1, Enum.EasingStyle.Quint))
		task.wait(1)
		NotiOriginals[noti] = nil
		noti:Destroy()
	end

	task.spawn(function()
		lib:tweenNotiTransparency(noti, "out", TweenInfo.new(0))
		task.wait()
		lib:tweenNotiTransparency(noti, "in", TweenInfo.new(1, Enum.EasingStyle.Quint))
		task.delay(duration or 3, function()
			tween(noti, { Size = UDim2.new(0, 95,0, 0) }, tweenInfo)
			lib:tweenNotiTransparency(noti, "out", TweenInfo.new(1, Enum.EasingStyle.Quint))
			task.wait(1)
			NotiOriginals[noti] = nil
			noti:Destroy()
		end)
	end)

	return functions
end

local TRANSPARENCY_PROPS = {
	Frame       = { "BackgroundTransparency" },
	TextLabel   = { "BackgroundTransparency", "TextTransparency", "TextStrokeTransparency" },
	TextButton  = { "BackgroundTransparency", "TextTransparency", "TextStrokeTransparency" },
	ImageLabel  = { "BackgroundTransparency", "ImageTransparency" },
	ImageButton = { "BackgroundTransparency", "ImageTransparency" },
	ScrollingFrame = { "BackgroundTransparency", "ScrollBarImageTransparency" },
	UIStroke    = { "Transparency" },
}

function lib:tweenNotiTransparency(noti, direction, tweenInfo)
	tweenInfo = tweenInfo or TweenInfo.new(0.4, Enum.EasingStyle.Quint)

	local function recurse(inst, fn)
		fn(inst)
		for _, child in inst:GetChildren() do
			recurse(child, fn)
		end
	end

	if direction == "out" then
		if not NotiOriginals[noti] then
			NotiOriginals[noti] = {}
			recurse(noti, function(inst)
				local props = TRANSPARENCY_PROPS[inst.ClassName]
				if not props then return end
				NotiOriginals[noti][inst] = {}
				for _, prop in props do
					NotiOriginals[noti][inst][prop] = inst[prop]
				end
			end)
		end
		recurse(noti, function(inst)
			local props = TRANSPARENCY_PROPS[inst.ClassName]
			if not props then return end
			local goal = {}
			for _, prop in props do goal[prop] = 1 end
			tween(inst, goal, tweenInfo)
		end)
	elseif direction == "in" then
		local originals = NotiOriginals[noti]
		recurse(noti, function(inst)
			if originals and originals[inst] then
				tween(inst, originals[inst], tweenInfo)
			end
		end)
	end
end

return lib
