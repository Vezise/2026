--// UI by moonroon - specifically made for this script.
local Repo = "https://raw.githubusercontent.com/Vezise/ui-for-vez/main/"
local Repo2 = "https://raw.githubusercontent.com/Vezise/2026/main/Vez/Violet/"

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

		warn(`[Violet] {FunctionName} Error at line {LineNumber}: {Error}`)

		NewThread = task.spawn(function()
			if not Library then return Error end
			
			local Notification = Library:createBigButtonNoti(`Violet errored: (Line: {LineNumber})`, `Error: {Error}`, "rbxassetid://74551978360184", 15)

			Notification:createButton("Ignore", function()
				Notification:Close()
			end)

			Notification:createButton("Send to Developer", function()
				SendWebhook(`[Violet] {FunctionName} | Error at line {LineNumber}`, "```" .. `diff\n- {Error}` .. "```")
			
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
local Version = Load("VioletVersion.lua", Repo2)

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

local VioletGui = Services.CoreGui.AnimLoggerUI
local Logger = {
	LocalPlayer = Services.Players.LocalPlayer;
	Character = nil;
	Humanoid = nil;

	Text = nil;
	Lines = {};
	Logs = VioletGui.Background.contain.left.contain.ScrollingFrame;
	LogProperties = VioletGui.Background.contain.center;
	Logging = false;
	Stacking = false;
	OldValue = nil;
	NewValue = nil;
	LogDelay = 0;
	LogDelays = {0, 1, 2, 3};
	LogTargets = {"LocalPlr", "AllPlrs", "Others"};
	LogTarget = "LocalPlr";

	NewThread = nil;
	LogDelayButton = nil;

	Selected = nil;
	SoundPreviewToggle = false;
    SoundExists = false;
	DelayLoop = false; 

	PropertiesFolder = nil;
	PropertiesTable = {};
	Properties = {
		["Looped"] = "Looped";
		["PlaybackSpeed"] = "PlaybackSpeed";
		["Time Position"] = "Time Position";
		["SoundId"] = "SoundId";
	};

	InfoNotification = nil;

    ViewModelSound = nil;
    ViewModel = VioletGui.Background.little.contain.ViewportFrame.WorldModel[Services.Players.LocalPlayer.Name];
    ViewModelHumanoid = VioletGui.Background.little.contain.ViewportFrame.WorldModel[Services.Players.LocalPlayer.Name].Humanoid;
    ViewModelPrimaryPart = VioletGui.Background.little.contain.ViewportFrame.WorldModel[Services.Players.LocalPlayer.Name].PrimaryPart;
    ViewModelParts = {};
    ViewModelOriginalCFrames = {};
    VisualiserSensitivity = 0.5;
    VisualiserMaxRotation = 45;
    VisualiserSounds = {};
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
					self.PropertiesTable.TimeLength = Property.length.value.Text
				end
				
				if Property.priority then
					self.PropertiesTable.RollOffMode = Property.priority.value.Text
				end
			end
		end

		return self.PropertiesTable
	end, "Function Logger.GetSelected")
end

function Logger:PlaySound()
	Handle(function()
		self.Selected = self:GetSelected()
		if self.Selected == nil then return end

		self.Sound = Instance.new("Sound")
        self.Sound.Parent = self.LocalPlayer.Character.PrimaryPart
		self.Sound.SoundId = `rbxassetid://{self.Selected.SoundId}`

		self.Sound.RollOffMode = Enum.RollOffMode[self.Selected.RollOffMode]
		self.Sound.Looped = self.Selected.Looped
		self.Sound.PlaybackSpeed = self.Selected.PlaybackSpeed
		self.Sound.TimePosition = self.Selected["Time Position"]
		self.Sound:Play()

		repeat task.wait() until self.Sound.IsPaused == true
		self.Sound:Destroy()

		self.Sound = nil
	end, "Function Logger.PlaySound")
end

function Logger:KillSounds()
    Handle(function()
        if not self.LocalPlayer.Character or not self.LocalPlayer.Character.PrimaryPart then return end
        
        for _, Sound in self.LocalPlayer.Character.PrimaryPart:GetChildren() do
            if Sound:IsA("Sound") then
                Sound:Destroy()
            end
        end
    end, "Function Logger.KillSounds")
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
		self.OldValue = table.find(self.LogTargets, self.LogTarget) or "LocalPlr"
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
                            "---------// SETTINGS \\---------";
							"getgenv().AutoClearLogsDelay = 99999";
							"--// How many seconds to wait before logs are automatically cleared";
							'getgenv().BlockedSounds = {"Jumping", "Climbing", "Running", "Landing"}';
							"--// Sounds to block from logging";
							"";
							"getgenv().ChosenTargetFolder = nil";
							"--[[";
							"	In ChosenTargetFolder, change nil to destination folder";
							"	to start logging all the sounds";
							"	within that folder when using 'Log: Others' option";
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
        if not self.Character or not self.Humanoid then return end
        local Sounds = self.Character:QueryDescendants("Sound")

		for _, Sound in Sounds do
            if not Sound.TimeLength or Sound.TimeLength == 0 then task.wait(0.1)end

			self.Sound = Sound
			if table.find(BlockedSounds, self.Sound.Name) then continue end
			if not self.Humanoid then return end
			
			local Log = Library:createLog(
				`rbxassetid://{self.Sound.SoundId:match("%d+")}                    {self.Sound.Name}`,
				`{self.Sound.Name}`,
				`{string.format("%.3f", Sound.TimeLength)}`,
				`{Sound.RollOffMode.Name}`
			)

			Log:makeProperty("SoundId", `{self.Sound.SoundId:match("%d+")}`, Color3.fromRGB(255, 200, 0))
			Log:makeProperty("IsPlaying", `{Sound.IsPlaying}`, (Sound.IsPlaying == true and Color3.fromRGB(0, 170, 0)) or Color3.fromRGB(222, 0, 0))
			Log:makeProperty("Looped", `{Sound.Looped}`, (Sound.Looped == true and Color3.fromRGB(0, 170, 0)) or Color3.fromRGB(222, 0, 0))
			Log:makeProperty("PlaybackSpeed", `{Sound.PlaybackSpeed}`, Color3.fromRGB(255, 200, 0))
			Log:makeProperty("Time Position", `{Sound.TimePosition}`, Color3.fromRGB(255, 200, 0))
			Log:makeProperty("Logged Player", `{self.Humanoid.Parent.Name}`, Color3.fromRGB(253, 75, 94))
		end
	end, "Function Logger.LoopAndCreateTab")
end

function Logger:LogTargetCreate(Target: string)
	Handle(function()
		if Target == "LocalPlr" then
			if not self.LocalPlayer.Character or not self.LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then return end
			self.Character = self.LocalPlayer.Character
            self.Humanoid = self.Character:FindFirstChildOfClass("Humanoid")
		
			self:LoopAndCreateTab()
			
			return task.wait(self.LogDelay)
		elseif Target == "AllPlrs" then
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
			local SearchedFolder = ChosenTargetFolder:QueryDescendants("Sound")

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
		self.Selected = self:GetSelected()
		if self.Selected == nil then return end
        
		self.Lines = {
			`--// Code generated by Violet {Version} - by vez`;
			`local Sound = Instance.new("Sound")`;
            `Sound.Parent = game:GetService("Players").LocalPlayer.Character.PrimaryPart`;
			`Sound.SoundId = "rbxassetid://{self.Selected.SoundId}"`;
			"";
			`Sound.RollOffMode = Enum.RollOffMode.{self.Selected.RollOffMode}`;
			`Sound.Looped = {self.Selected.Looped}`;
			`Sound.PlaybackSpeed = {self.Selected.PlaybackSpeed}`;
			`Sound.TimePosition = {self.Selected["Time Position"]}`;
			`Sound:Play()`;
			"";
			`repeat task.wait() until Sound.IsPaused == true`;
			`Sound:Destroy()`;
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
		`You are using version {Version} for the first time! Please make sure that you have the latest config! Enjoy Violet!`,
		15,
		"Copy Discord URL",
		function()
			setclipboard("https://discord.com/invite/6e7mm8xbbb")
		end,
		true,
		"Copied Discord Invite!"
	)
end

function Logger:VisualiserIndexCharacter()
    self.ViewModelParts = {}

    for _, Part in self.ViewModel:GetChildren() do
        if Part:IsA("BasePart") and Part ~= self.ViewModelPrimaryPart then
            table.insert(self.ViewModelParts, Part)
        end
    end

    return self.ViewModelParts
end

function Logger:ViewModelInsertSound(Sound)
	Handle(function()
        if self.SoundExists == true then return end
        self.SoundExists = true
		local Selected = Sound

		if self.ViewModelSound then
			self.ViewModelSound:Destroy()
		end

		self.ViewModelSound = Instance.new("Sound")
        self.ViewModelSound.Parent = self.ViewModelPrimaryPart
		self.ViewModelSound.SoundId = `rbxassetid://{Selected.SoundId}`

		self.ViewModelSound.RollOffMode = Enum.RollOffMode.Linear
		self.ViewModelSound.Looped = Selected.Looped
		self.ViewModelSound.PlaybackSpeed = Selected.PlaybackSpeed
		self.ViewModelSound.TimePosition = Selected["Time Position"]
		self.ViewModelSound.Volume = 2
		self.ViewModelSound:Play()
	end, "Function Logger.ViewModelInsertSound")
end

function Logger:CreateVisualiserModel()
    Handle(function()
        for _, Child in self.ViewModel:GetChildren() do
            if Child.Name ~= "VisualiserModel" then
                Child:Destroy()
            end
        end

        local OldModel = self.ViewModel:FindFirstChild("VisualiserModel")
        if OldModel then
            OldModel:Destroy()
        end

        local VisualiserModel = Instance.new("Model")
        VisualiserModel.Parent = self.ViewModel
        VisualiserModel.Name = "VisualiserModel"

        local VisualiserParts = {}
        local VisualiserOriginalPositions = {}
        
        local PrimaryPartPosition = self.ViewModelPrimaryPart.Position

        local SphereRadius = 6
        local VerticalRings = 6
        local PartsPerRing = 12
        
        for VerticalIndex = 1, VerticalRings do
            local LatitudeAngle = ((VerticalIndex - 1) / (VerticalRings - 1)) * math.pi - math.pi / 2
            local RingRadius = SphereRadius * math.cos(LatitudeAngle)
            local YOffset = SphereRadius * math.sin(LatitudeAngle)
            
            for HorizontalIndex = 1, PartsPerRing do
                local LongitudeAngle = (HorizontalIndex / PartsPerRing) * math.pi * 2
                local X = math.cos(LongitudeAngle) * RingRadius
                local Z = math.sin(LongitudeAngle) * RingRadius
                
                local Part = Instance.new("Part")
                Part.Name = `VisualiserPart_{VerticalIndex}_{HorizontalIndex}`
                Part.Shape = Enum.PartType.Ball
                Part.Size = Vector3.new(0.5, 0.5, 0.5)
                Part.CanCollide = false
                Part.CFrame = CFrame.new(PrimaryPartPosition + Vector3.new(X, YOffset - 5, Z + 15))

                local Hue = (HorizontalIndex / PartsPerRing)
                Part.Color = Color3.fromHSV(Hue, 0.8, 0.9)
                Part.Parent = VisualiserModel

                table.insert(VisualiserParts, Part)
                VisualiserOriginalPositions[Part] = Part.CFrame
            end
        end

        self.VisualiserParts = VisualiserParts
        self.VisualiserOriginalPositions = VisualiserOriginalPositions
        self.VisualiserModel = VisualiserModel

        return VisualiserParts
    end, "Logger.CreateVisualiserModel")
end

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
	Logger.SoundPreviewToggle = State

	if State == true then
        task.spawn(function()
            Handle(function()
                Logger:CreateVisualiserModel()
                
                local CharSound = Instance.new("Sound")
                CharSound.Parent = Logger.LocalPlayer.Character.PrimaryPart
                CharSound.Volume = 1
                
                local LastSoundId = nil
                local AnimationStartTime = tick()
                local SoundCompleted = false
                
                while Logger.SoundPreviewToggle == true do
                    Logger.Selected = Logger:GetSelected()
                    if Logger.Selected == nil then
                        task.wait(0.1)

                        continue
                    end

                    local NewSoundId = `rbxassetid://{Logger.Selected.SoundId}`
                    
                    if not Logger.ViewModelSound or LastSoundId ~= NewSoundId then
                        if Logger.ViewModelSound then
                            Logger.ViewModelSound:Destroy()
                        end
                        
                        Logger.ViewModelSound = Instance.new("Sound")
                        Logger.ViewModelSound.Parent = Logger.ViewModelPrimaryPart
                        Logger.ViewModelSound.SoundId = NewSoundId
                        Logger.ViewModelSound.Volume = 2
                        Logger.ViewModelSound.RollOffMode = Enum.RollOffMode.Linear
                        Logger.ViewModelSound.Looped = Logger.Selected.Looped
                        Logger.ViewModelSound.PlaybackSpeed = Logger.Selected.PlaybackSpeed
                        
                        CharSound.SoundId = NewSoundId
                        CharSound.Looped = Logger.Selected.Looped
                        CharSound.PlaybackSpeed = Logger.Selected.PlaybackSpeed
                        
                        task.wait(0.05)
                        
                        Logger.ViewModelSound:Play()
                        CharSound:Play()
                        AnimationStartTime = tick()
                        LastSoundId = NewSoundId
                        SoundCompleted = false
                    end

                    local Sound = Logger.ViewModelSound
                    local PrimaryPartPosition = Logger.ViewModelPrimaryPart.Position
                    local TimeLength = Logger.Selected.TimeLength or 1
                    local Strength = 0
                    
                    if Sound then
                        local ElapsedTime = tick() - AnimationStartTime
                        
                        if Logger.Selected.Looped then
                            Strength = (ElapsedTime % TimeLength) / TimeLength
                        else
                            Strength = math.min(ElapsedTime / TimeLength, 1)
                        end
                    end
                    
                    if Strength >= 0.99 and not Logger.Selected.Looped and not SoundCompleted then
                        SoundCompleted = true
                        if Logger.DelayLoop then
                            task.wait(1)
                            Logger.ViewModelSound:Play()
                            CharSound:Play()
                            AnimationStartTime = tick()
                            SoundCompleted = false
                        end
                    end
                    
                    for Index, Part in Logger.VisualiserParts do
                        if Part and Part.Parent then
                            local VerticalRings = 6
                            local PartsPerRing = 12
                            local SphereRadius = 6
                            
                            local VerticalIndex = math.ceil(Index / PartsPerRing)
                            local HorizontalIndex = ((Index - 1) % PartsPerRing) + 1
                            
                            local LatitudeAngle = ((VerticalIndex - 1) / (VerticalRings - 1)) * math.pi - math.pi / 2
                            local RingRadius = SphereRadius * math.cos(LatitudeAngle)
                            local BaseY = SphereRadius * math.sin(LatitudeAngle) - 5
                            
                            local LongitudeAngle = (HorizontalIndex / PartsPerRing) * math.pi * 2
                            local BaseX = math.cos(LongitudeAngle) * RingRadius
                            local BaseZ = math.sin(LongitudeAngle) * RingRadius + 15
                            
                            local IndexNormalized = Index / #Logger.VisualiserParts
                            local WavePos = Strength * 1.5
                            local DistanceFromWave = math.abs(IndexNormalized - WavePos)
                            local WaveAmount = math.exp(-DistanceFromWave * DistanceFromWave * 8)
                            
                            local HeightOffset = WaveAmount * 8
                            local SizeMultiplier = 0.5 + (WaveAmount * 0.5)
                            
                            Part.CFrame = CFrame.new(PrimaryPartPosition + Vector3.new(BaseX, BaseY + HeightOffset, BaseZ))
                            Part.Size = Vector3.new(SizeMultiplier, SizeMultiplier, SizeMultiplier)
                        end
                    end

                    task.wait(0.016)
                end
                
                CharSound:Destroy()
            end, "Loop Preview")
        end)
	else
		Logger.SoundPreviewToggle = false
		if Logger.ViewModelSound then
			Logger.ViewModelSound:Destroy()
			Logger.ViewModelSound = nil
		end
		if Logger.VisualiserModel then
			Logger.VisualiserModel:Destroy()
			Logger.VisualiserModel = nil
			Logger.VisualiserParts = {}
		end
	end
end)

Library:createBottomButton("Delay: 0s*", function()
	Logger:ChangeLogDelay()
end)

Library:createBottomButton("LocalPlr*", function()
	Logger:ChangeLogTarget()
end)

Library:createBottomButton("Copy Id", function()
	Handle(function()
		Logger.Selected = Logger:GetSelected()
		if Logger.Selected == nil then return end
		
		setclipboard(`--// Sound provided by Violet {Version} - by vez\nrbxassetid://{Logger.Selected.SoundId}`)
	end, "Copy AnimId")

	Library:createSmallNoti("Copied Sound!", "rbxassetid://128652484951291", 2)
end)

Library:createBottomButton("Copy Prop", function()
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

Library:createBottomButton("Kill Sounds", function()
	Logger:KillSounds()

    Library:createSmallNoti("All sounds killed!", "rbxassetid://128652484951291", 2)
end)

Library:createBottomButton("Play Sound", function()
    Library:createSmallNoti("Played sound!", "rbxassetid://128652484951291", 2)

	Logger:PlaySound()
end)

--// conversion from Crimson to Violet, yes it's very lazy and idc
local GUI = VioletGui.Background

task.spawn(function()
    for _, Part in GUI.little.contain.ViewportFrame.WorldModel[Services.Players.LocalPlayer.Name]:GetChildren() do
        if Part:IsA("BasePart") then
            Part.Transparency = 1
        elseif Part:IsA("Accessory") then
            Part:Destroy()
        end
    end
end)

GUI.contain.bottom.contain["Kill Sounds"].BackgroundTransparency = 0
GUI.contain.bottom.contain["Kill Sounds"].BackgroundColor3 = Color3.fromHex("#240047")
GUI.contain.bottom.contain["Play Sound"].BackgroundTransparency = 0
GUI.contain.bottom.contain["Play Sound"].BackgroundColor3 = Color3.fromHex("#962EFF")
GUI.top.Image = "rbxassetid://126216095768554"
GUI.top.layout1.ON.Image = "rbxassetid://105616411898519"
GUI.top.layout1.title.Text = "VIOLET"
GUI.top.layout1.ani.Text = "Sound Logger"
GUI.top.layout1.ani.TextColor3 = Color3.fromHex("#7F00FF")

for _, UIPart in GUI.top.layout2:GetChildren() do
    if UIPart:IsA("Frame") and UIPart.BackgroundColor3 == Color3.fromRGB(22, 10, 10) then
        UIPart.BackgroundColor3 = Color3.fromHex("#0D001A")
    end
end

do
	Handle(function()
		local Info = {
			Version = Version
		}

		local Data = nil

		if not isfile("Violet.lua") then
			writefile("Violet.lua", game:GetService("HttpService"):JSONEncode(Info))
			Logger:InformUser()
		else
			Data = game:GetService("HttpService"):JSONDecode(readfile("Violet.lua"))
			
			if Data.Version ~= Version then
				writefile("Violet.lua", game:GetService("HttpService"):JSONEncode(Info))
				Logger:InformUser()
			end
		end
	end, "ReadData")
end
