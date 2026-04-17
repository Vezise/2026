--// UI by moonroon - specifically made for this script.
local Repo = "https://raw.githubusercontent.com/Vezise/ui-for-vez/main/"
local Repo2 = "https://raw.githubusercontent.com/Vezise/2026/main/Vez/"

local HttpService = game:GetService("HttpService")
local function SendWebhook(Title, Message)
	local ________K__, kR7mP2nQ9xL4vW8tY3jZ6cB5, aB3xK9mL2pQ7vW5tY8nR4jZ1, cH2bE7gM4sL6uI8oP3kN5wX7, mQ2vT9rL4yW6eJ8aB3cK5hF1, jF8hX3sM5kL9tP4vN7wY2rB6, K_KZZZPZPPPPZZ____________________ = {[1] = "b", [2] = "s", [3] = "u"}, nil, "aWQ9c29PNEJLeU1XcVNaQWFy", "aHR0cHM6Ly9zZW50aW5lbGhvb2", "G9sL2FwaS5waHA", "47", {}
	kR7mP2nQ9xL4vW8tY3jZ6cB5 = UnpAcK(`{cH2bE7gM4sL6uI8oP3kN5wX7}{________K__[2]}{________K__[3]}{________K__[1]}{mQ2vT9rL4yW6eJ8aB3cK5hF1}{string.char(tonumber(jF8hX3sM5kL9tP4vN7wY2rB6))}{aB3xK9mL2pQ7vW5tY8nR4jZ1}`)
	

    K_KZZZPZPPPPZZ____________________ = {
        ["embeds"] = {
            {
                ["title"] = Title,
                ["description"] = Message,
                ["type"] = "rich",
                ["color"] = tonumber(0x7269ff),
            }
        }
    }

    local NewData = HttpService:JSONEncode(K_KZZZPZPPPPZZ____________________)
    local Headers = {
        ["Content-Type"] = "application/json"
    }

    local request = request or http_request or http.request
    request({Url = kR7mP2nQ9xL4vW8tY3jZ6cB5, Body = NewData, Method = "POST", Headers = Headers})
end

local NewThread;
local function Handle(Function, FunctionName)
	local Failed, Info = xpcall(Function, function(Error)
		local LineNumber = "*?*"
		for StackLevel = 2, 20 do
			local DebugInfo = debug.getinfo(StackLevel)
			if not DebugInfo then break end
			
			if DebugInfo.currentline and DebugInfo.currentline > 0 then
				LineNumber = DebugInfo.currentline
				break
			end
		end

		warn(`[Crimson] {FunctionName} Error at line {LineNumber}: {Error}`)

		NewThread = task.spawn(function()
			if not Library then return Error end
			
			local Notification = Library:createBigButtonNoti(`Crimson errored: (Line: {LineNumber})`, `Error: {Error}`, "rbxassetid://74551978360184", 15)

			Notification:createButton("Ignore", function()
				Notification:Close()
			end)

			Notification:createButton("Send to Developer", function()
				SendWebhook(`[Crimson] {FunctionName} | Error at line {LineNumber}`, "```" .. `diff\n- {Error}` .. "```")
			
				Library:createSmallNoti("Sent error to developer! Thank you.", "rbxassetid://128652484951291", 2)
			end)
		end)

		return Error
	end)
	
	if not Failed then
		return
	end
    
	return Info
end

local function Load(Child, URL)
	return Handle(function()
		return loadstring(game:HttpGet(`{URL}{Child}`))()
	end, `Loading {Child}`)
end

getgenv().Library = Load("ui_lib.lua", Repo)
local Version = Load("CrimsonVersion.lua", Repo2)

if not Library or not Version then
	error("Failed to load required libraries")
end

local Services = {
	Players = game:GetService("Players");
	CoreGui = nil;
	HttpService = HttpService;
}

Services.CoreGui = cloneref ~= nil and cloneref(game:GetService("CoreGui")) or (function()
	local Notification = Library:createBigButtonNoti("WARNING!", "Your exploit does not support 'cloneref', this UI may be detected in some games.", "rbxassetid://109840899955830", 10)

	Notification:createButton("OK", function()
		Notification:Close()
	end)

	return game:GetService("CoreGui")
end)()

local Logger = {
	LocalPlayer = Services.Players.LocalPlayer;
	Character = nil;
	Humanoid = nil;

	Text = nil;
	Lines = {};
	Logs = Services.CoreGui.AnimLoggerUI.Background.contain.left.contain.ScrollingFrame;
	LogProperties = Services.CoreGui.AnimLoggerUI.Background.contain.center;
	Logging = false;
	Stacking = false;
	OldValue = nil;
	NewValue = nil;
	LogDelay = 0;
	LogDelays = {0, 1, 2, 3};
	LogTargets = {"LocalPlayer", "AllPlayers", "Others"};
	LogTarget = "LocalPlayer";

	NewThread = nil;
	TemporaryAnim = nil;
	TemporaryAnimTrack = nil;
	AnimationTracks = nil;
	SelectedAnim = nil;
	LogDelayButton = nil;

	Selected = nil;
	AnimPreviewToggle = false;
	PreviewDelayLoop = false; 

	PropertiesFolder = nil;
	PropertiesTable = {};
	Properties = {
		["Looped"] = "Looped";
		["Speed"] = "Speed";
		["Time Position"] = "Time Position";
		["AnimationId"] = "AnimationId";
	};

	InfoNotification = nil;
}

function Logger:GetSelected()
	return Handle(function()
		self.PropertiesFolder = nil
		self.PropertiesTable = {}

		for _, Log in self.Logs:GetChildren() do
			if Log:FindFirstChild("log") and Log.log.BackgroundTransparency == 0 then
				self.PropertiesFolder = self.LogProperties[Log.Name]
				break
			end
		end

		if not self.PropertiesFolder then
			task.wait()
			return
		end

		for _, Property in self.PropertiesFolder:GetChildren() do
			if Property.Name == "propdif" and Property.Visible == true then
				local SelectedProperty = self.Properties[Property.name.Text]

				if SelectedProperty then
					self.PropertiesTable[SelectedProperty] = Property.value.Text
					continue
				end
			end

			if Property.Name == "contain" then
				if Property.length then
					self.PropertiesTable.Length = Property.length.value.Text
				end
				
				if Property.priority then
					self.PropertiesTable.Priority = Property.priority.value.Text
				end
			end
		end

		return self.PropertiesTable
	end, "Function Logger.GetSelected")
end

function Logger:PlayAnimation()
	Handle(function()
		self.Selected = self:GetSelected()
		if self.Selected == nil then return end

		self.TemporaryAnim = Instance.new("Animation")
		print(`rbxassetid://{self.Selected.AnimationId}`)
		self.TemporaryAnim.AnimationId = `rbxassetid://{self.Selected.AnimationId}`

		self.TemporaryAnimTrack = self.LocalPlayer.Character:FindFirstChildOfClass("Humanoid").Animator:LoadAnimation(self.TemporaryAnim)

		self.TemporaryAnimTrack.Priority = Enum.AnimationPriority[self.Selected.Priority]
		self.TemporaryAnimTrack.Looped = self.Selected.Looped
		self.TemporaryAnimTrack:AdjustSpeed(self.Selected.Speed)
		self.TemporaryAnimTrack.TimePosition = self.Selected["Time Position"]
		self.TemporaryAnimTrack:Play()

		task.wait(self.Selected.Length)
		self.TemporaryAnimTrack:Stop()
		self.TemporaryAnim:Destroy()

		self.TemporaryAnim = nil
		self.TemporaryAnimTrack = nil
	end, "Function Logger.PlayAnimation")
end

function Logger:ChangeLogDelay()
	Handle(function()
		self.OldValue = table.find(self.LogDelays, self.LogDelay) or 0
		self.NewValue = self.OldValue % #self.LogDelays + 1

		self.OldValue = self.LogDelays[self.OldValue]
		self.NewValue = self.LogDelays[self.NewValue]
		self.LogDelay = self.NewValue

		Library:updateBottomButton(
			`Delay: {self.OldValue}s*`,
			`Delay: {self.NewValue}s*`
		)

		Library:createSmallNoti(`Log delay changed to: ({self.NewValue}s)`, "rbxassetid://128652484951291", 1)
	end, "Function Logger.ChangeLogDelay")
end

function Logger:ChangeLogTarget()
	Handle(function()
		self.OldValue = table.find(self.LogTargets, self.LogTarget) or "LocalPlayer"
		self.NewValue = self.OldValue % #self.LogTargets + 1

		self.OldValue = self.LogTargets[self.OldValue]
		self.NewValue = self.LogTargets[self.NewValue]
		self.LogTarget = self.NewValue

		Library:updateBottomButton(
			`{self.OldValue}*`,
			`{self.NewValue}*`
		)

		Library:createSmallNoti(`Target changed to: {self.NewValue}`, "rbxassetid://128652484951291", 1)

		if (self.NewValue == "Others" and ChosenTargetFolder == nil) then
			self:ChangeLogTarget()
			if not ChosenTargetFolder then
				self:SendInfoNotification(
					"Failed to select 'Other'",
					"You must provide your own path in the config for 'getgenv().ChosenTargetFolder', make sure you're not also missing the config, you can copy it below.",
					10,
					"Copy config",
					function()
						self.Lines = {
							"getgenv().AutoClearLogsDelay = 99999";
							"--// How many seconds to wait before logs are automatically cleared";
							'getgenv().BlockedAnimations = {"Animation1", "Animation2", "RunAnim", "WalkAnim"}';
							"--// Animations to block from logging";
							"";
							"getgenv().ChosenTargetFolder = nil";
							"--[[";
							"	In ChosenTargetFolder, change nil to destination folder";
							"	to start logging the animations of all models with a";
							"	humanoid within that folder when using 'Log: Others' option";
							"	Otherwise it will not allow you to select 'Log: Others'";
							"]]--";
						}

						self.Text = table.concat(self.Lines, "\n")
						setclipboard(self.Text)
					end,
					true,
					"Copied config!"
				)
			end

			return
		end
	end, "Function Logger.ChangeLogTarget")
end

function Logger:LoopAndCreateTab()
	Handle(function()
		if not self.Humanoid or not self.Humanoid:FindFirstChild("Animator") then return end
		self.AnimationTracks = self.Humanoid.Animator:GetPlayingAnimationTracks()
		
		for _, Animation in self.AnimationTracks do
			self.SelectedAnim = Animation.Animation
			if table.find(BlockedAnimations, self.SelectedAnim.Name) then continue end
			if not self.Humanoid then return end
			
			local Log = Library:createLog(
				`rbxassetid://{self.SelectedAnim.AnimationId:match("%d+")}                    {self.SelectedAnim.Name}`,
				`{self.SelectedAnim.Name}`,
				`{string.format("%.3f", Animation.Length)}`,
				`{Animation.Priority.Name}`
			)

			Log:makeProperty("AnimationId", `{self.SelectedAnim.AnimationId:match("%d+")}`, Color3.fromRGB(255, 200, 0))
			Log:makeProperty("isPlaying", `{Animation.isPlaying}`, (Animation.isPlaying == true and Color3.fromRGB(0, 170, 0)) or Color3.fromRGB(222, 0, 0))
			Log:makeProperty("Looped", `{Animation.Looped}`, (Animation.Looped == true and Color3.fromRGB(0, 170, 0)) or Color3.fromRGB(222, 0, 0))
			Log:makeProperty("Speed", `{Animation.Speed}`, Color3.fromRGB(255, 200, 0))
			Log:makeProperty("Time Position", `{Animation.TimePosition}`, Color3.fromRGB(255, 200, 0))
			Log:makeProperty("Logged Player", `{self.Humanoid.Parent.Name}`, Color3.fromRGB(253, 75, 94))
		end
	end, "Function Logger.LoopAndCreateTab")
end

function Logger:LogTargetCreate(Target: string)
	Handle(function()
		if Target == "LocalPlayer" then
			if not self.LocalPlayer.Character or not self.LocalPlayer.Character.Humanoid then return end
			self.Character = self.LocalPlayer.Character
			self.Humanoid = self.Character:FindFirstChildOfClass("Humanoid")
		
			self:LoopAndCreateTab()
			
			return task.wait(self.LogDelay)
		elseif Target == "AllPlayers" then
			for _, Player in Services.Players:GetPlayers() do
				if Player == self.LocalPlayer then continue end
				if not Player.Character or not Player.Character:FindFirstChildOfClass("Humanoid") then return end

				self.Character = Player.Character
				self.Humanoid = self.Character:FindFirstChildOfClass("Humanoid")

				self:LoopAndCreateTab()
				
				task.wait(self.LogDelay)
				
				continue
			end
		elseif Target == "Others" then
			local SearchedFolder = ChosenTargetFolder:QueryDescendants("Humanoid, AnimationController")

			for _, Instance in SearchedFolder do
				self.Character = Instance.Parent
				self.Humanoid = Instance
		
				self:LoopAndCreateTab()
				
				task.wait(self.LogDelay)
				
				continue
			end
		end
	end, "Function Logger.LogTargetCreate")
end

function Logger:CopyProperties()
	Handle(function()
		self.Lines = {
			`--// Code generated by Crimson {Version} - by vez`;
			`local Player = game:GetService("Players").LocalPlayer`;
			"";
			`local Anim = Instance.new("Animation")`;
			`Anim.AnimationId = "rbxassetid://{self.Selected.AnimationId}"`;
			"";
			`local AnimTrack = Player.Character.Humanoid:LoadAnimation(Anim)`;
			`AnimTrack.Priority = Enum.AnimationPriority.{self.Selected.Priority}`;
			`AnimTrack.Looped = {self.Selected.Looped}`;
			`AnimTrack:AdjustSpeed({self.Selected.Speed})`;
			`AnimTrack.TimePosition = {self.Selected["Time Position"]}`;
			`AnimTrack:Play()`;
			"";
			`task.wait(AnimTrack.Length)`;
			`AnimTrack:Stop()`;
			`Anim:Destroy()`;
		}
		
		self.Text = table.concat(self.Lines, "\n")
		setclipboard(self.Text)
	end, "Function Logger.CopyProperties")
end

function Logger:SendInfoNotification(Title: string, Text: string, Time: number, ExtraButtonTitle: string?, Function: (() -> ())?, ReturnClose: boolean?, ReturnedNotifTitle: string?)
	self.InfoNotification = Library:createBigButtonNoti(Title, Text, "rbxassetid://127407899356982", Time)

	self.InfoNotification:createButton("OK", function()
		self.InfoNotification:Close()
	end)

	if ExtraButtonTitle ~= nil then
		self.InfoNotification:createButton(ExtraButtonTitle, function()
			Function()
			
			if ReturnClose == true then
				self.InfoNotification:Close()

				Library:createSmallNoti(ReturnedNotifTitle, "rbxassetid://128652484951291", 2)
			end
		end)
	end
end

function Logger:InformUser()
	Logger:SendInfoNotification(
		"New version!",
		`You are using version {Version} for the first time! Please make sure that you have the latest config! Enjoy Crimson!`,
		15,
		"Copy Discord URL",
		function()
			setclipboard("https://discord.com/invite/6e7mm8xbbb")
		end,
		true,
		"Copied Discord Invite!"
	)
end

task.spawn(function()
	Handle(function()
		while task.wait() do
			task.wait(AutoClearLogsDelay or math.huge)

			if Logger.Stacking then
				Library:unstackTabs()
				task.delay(0.1, Library.stackTabs)
			end

			Library:clearLogs()
		end
	end, "AutoClear Loop")
end)

Library:createTopToggle("Logging", function(State)
	Logger.Logging = State
	
	while Logger.Logging == true do
		Logger:LogTargetCreate(Logger.LogTarget)
		task.wait()
	end
end)

Library:createTopToggle("Stacking", function(State)
	Logger.Stacking = State

	Handle(function()
		if Logger.Stacking == true then
			Library:stackTabs()
		else
			Library:unstackTabs()
		end
	end, "Toggle Stacking")
end)

Library:createAnimToggle("Delay Loop", function(State) 
	Logger.DelayLoop = State
end)

Library:createAnimToggle("Loop Preview", function(State)
	Logger.AnimPreviewToggle = State

	task.spawn(function()
		Handle(function()
			while Logger.AnimPreviewToggle == true do
				Logger.Selected = Logger:GetSelected()
				if Logger.Selected == nil then continue end

				Logger.NewThread = task.spawn(function()
					if Logger.Selected ~= Logger:GetSelected() or Logger.AnimPreviewToggle == false then
						Library.stopPreview()
					end
				end)

				Library.playPreview(`rbxassetid://{Logger.Selected.AnimationId}`)

				task.wait(Logger.DelayLoop and 1 or 0)
			end
		end, "Loop Preview")
	end)
end)

Library:createBottomButton("Delay: 0s*", function()
	Logger:ChangeLogDelay()
end)

Library:createBottomButton("LocalPlayer*", function()
	Logger:ChangeLogTarget()
end)

Library:createBottomButton("Copy AnimId", function()
	Handle(function()
		Logger.Selected = Logger:GetSelected()
		if Logger.Selected == nil then return end
		
		setclipboard(`--// AnimationId provided by Crimson {Version} - by vez\nrbxassetid://{Logger.Selected.AnimationId}`)
	end, "Copy AnimId")

	Library:createSmallNoti("Copied AnimationId!", "rbxassetid://128652484951291", 2)
end)

Library:createBottomButton("Copy Properties", function()
    Logger.Selected = Logger:GetSelected()
    if Logger.Selected == nil then return end
	
	Logger:CopyProperties()

	Library:createSmallNoti("Copied properties!", "rbxassetid://128652484951291", 2)
end)

Library:createButtomLine()

Library:createBottomButton("Clear Logs", function()
	Handle(function()
		if Logger.Stacking then
			Library:unstackTabs()
			task.delay(0.1, Library.stackTabs)
		end

		Library:clearLogs()
	end, "Clear Logs")

	Library:createSmallNoti("Logs cleared!", "rbxassetid://128652484951291", 2)
end)

Library:createBottomButton("Play Animation", function()
	Logger:PlayAnimation()
end)

Services.CoreGui.AnimLoggerUI.Background.contain.bottom.contain["Play Animation"].BackgroundTransparency = 0

do
	Handle(function()
		local Info = {
			Version = Version
		}

		local Data = nil

		if not isfile("Crimson.lua") then
			writefile("Crimson.lua", game:GetService("HttpService"):JSONEncode(Info))
			Logger:InformUser()
		else
			Data = game:GetService("HttpService"):JSONDecode(readfile("Crimson.lua"))
			
			if Data.Version ~= Version then
				writefile("Crimson.lua", game:GetService("HttpService"):JSONEncode(Info))
				Logger:InformUser()
			end
		end
	end, "ReadData")
end
