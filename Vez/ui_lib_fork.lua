local repo = "https://raw.githubusercontent.com/ybahopper/ui-for-vez/main/"
local load = function(f) return loadstring(game:HttpGet(repo .. f))() end
local fetch = function(f) return game:HttpGet(repo .. f) end

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local existing = CoreGui:FindFirstChild("AnimLoggerUI")
if existing then existing:Destroy() end

local RBXMXParser = load("RBXMXParser.lua")
local AnimLoggerUI = RBXMXParser.Deserialize(fetch("ui_lib_1.rbxmx"), CoreGui)[1]

local TWEEN_FAST = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TWEEN_DEFAULT = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local Style = {
	selected   = { transparency = 0,   strokeColor = Color3.fromRGB(53, 3, 3) },
	unselected = { transparency = 1,   strokeColor = Color3.fromRGB(22, 22, 22) },
	hover      = { transparency = 0.95 },
	toggleOn   = Color3.fromRGB(0, 170, 0),
	toggleOff  = Color3.fromRGB(50, 50, 50),
}

local function tween(instance, properties, info)
	local t = TweenService:Create(instance, info or TWEEN_DEFAULT, properties)
	t:Play()
	return t
end

local previewAnimator
local currentTrack

do
	local worldModel = AnimLoggerUI.Background.little.contain.ViewportFrame.WorldModel
	local rig = worldModel.Rig
	local rigRootCFrame = (rig:FindFirstChild("HumanoidRootPart") or rig.PrimaryPart or rig:FindFirstChildWhichIsA("BasePart")).CFrame
	rig:Destroy()

	local char = Players.LocalPlayer.Character
    char.Archivable = true
	local clone = char:Clone()
    clone.PrimaryPart.CFrame = rigRootCFrame
    clone.Parent = worldModel

    previewAnimator = clone.Humanoid
end

local function stopPreview()
	if not currentTrack then return end
	currentTrack:Stop()
	currentTrack:Destroy()
	currentTrack = nil
end

local function playPreview(animationId)
	if not previewAnimator then return end

	if currentTrack then
		currentTrack:Stop()
		currentTrack:Destroy()
		currentTrack = nil
	end

	local anim = Instance.new("Animation")
	anim.AnimationId = animationId

	currentTrack = previewAnimator:LoadAnimation(anim)
	currentTrack:Play()
    currentTrack.Looped = false
	anim:Destroy()
end

local scrollingFrame = AnimLoggerUI.Background.contain.left.contain.ScrollingFrame
local tabTemplate = scrollingFrame.logUn
local contentTemplate = AnimLoggerUI.Background.contain.center.contain
local tabs = {}

local function selectTab(target)
	for _, entry in ipairs(tabs) do
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
	local background = AnimLoggerUI.Background
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

lib.playPreview = playPreview
lib.stopPreview = stopPreview

local function getTabGroups()
	local groups = {}
	for _, entry in ipairs(tabs) do
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
	stackingEnabled = true
	local groups = getTabGroups()
	for _, group in pairs(groups) do
		if #group > 1 then
			updateStackIndicator(group[1], #group)
			for i = 2, #group do
				hideTab(group[i])
			end
		end
	end
end

function lib:unstackTabs()
	stackingEnabled = false
	local groups = getTabGroups()
	for _, group in pairs(groups) do
		if #group > 1 then
			updateStackIndicator(group[1], nil)
			for i = 2, #group do
				showTab(group[i])
			end
		end
	end
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

	if stackingEnabled then
		local groups = getTabGroups()
		local group = groups[id]
		if group and #group > 1 then
			updateStackIndicator(group[1], #group)
			hideTab(entry)
		end
	end

	function funcs:makeProperty(name, val, color)
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

function lib:createTopToggle(name, callback)
	local parent = AnimLoggerUI.Background.top.layout2
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

function lib:createAnimToggle(name, callback)
	local parent = AnimLoggerUI.Background.little.contain.layout2
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
	local parent = AnimLoggerUI.Background.contain.bottom.contain
	local toggle = parent.clear:Clone()
	toggle.Visible = true
	toggle.Parent = parent

	local label = toggle.TextLabel
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
	local label = AnimLoggerUI.Background.contain.bottom.contain[button].TextLabel
  label.Text = name
	AnimLoggerUI.Background.contain.bottom.contain[button].Size = UDim2.new(0, label.TextBounds.X + 25, 1, -20)
end

function lib:createButtomLine()
	local parent = AnimLoggerUI.Background.contain.bottom.contain
	local toggle = parent.line:Clone()
	toggle.Visible = true
	toggle.Parent = parent
end

return lib
