--// UI by moonroon - specifically made for this script.
local Repo = "https://raw.githubusercontent.com/Vezise/ui-for-vez/main/"
local Repo2 = "https://raw.githubusercontent.com/Vezise/2026/main/Vez/"
local Load = function(Child, URL)
    return loadstring(
        game:HttpGet(`{URL}{Child}`)
    )()
end

local Library = Load("ui_lib.lua", Repo)
local Version = Load("CrimsonVersion.lua", Repo2)

local Services = {
    Players = game:GetService("Players");
    CoreGui = game:GetService("CoreGui")
}

local Logger = {
    --// All cache, do not fuck with these vars (unless you know what you're doing)
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
    Properties = { -- Will always remain unchanged
        ["Looped"] = "Looped";
        ["Speed"] = "Speed";
        ["Time Position"] = "Time Position";
        ["AnimationId"] = "AnimationId";
    };
}

function Logger:GetSelected()
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

    local Success, Fail = pcall(function()
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
    end)

    if Success == false then
        warn(`[{Version}] Crimson had a stroke: {Fail} (This error is quite irrelevant most likely.)`)
    end

    return self.PropertiesTable
end

function Logger:PlayAnimation()
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
end

function Logger:ChangeLogDelay()
    self.OldValue = table.find(self.LogDelays, self.LogDelay) or 0
    self.NewValue = self.OldValue % #self.LogDelays + 1

    self.OldValue = self.LogDelays[self.OldValue]
    self.NewValue = self.LogDelays[self.NewValue]
    self.LogDelay = self.NewValue

    Library:updateBottomButton(
        `Delay: {self.OldValue}s*`,
        `Delay: {self.NewValue}s*`
    )
end

function Logger:ChangeLogTarget()
    self.OldValue = table.find(self.LogTargets, self.LogTarget) or "LocalPlayer"
    self.NewValue = self.OldValue % #self.LogTargets + 1

    self.OldValue = self.LogTargets[self.OldValue]
    self.NewValue = self.LogTargets[self.NewValue]
    self.LogTarget = self.NewValue

    Library:updateBottomButton(
        `{self.OldValue}*`,
        `{self.NewValue}*`
    )

    if (self.NewValue == "Others" and ChosenTargetFolder == nil) then
        self:ChangeLogTarget()
        return warn("Target folder containing models with 'Humanoid' not defined")
    end
end

function Logger:LoopAndCreateTab()
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
end

function Logger:LogTargetCreate(Target: string)
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
        for _, Instance in ChosenTargetFolder:GetDescendants() do -- i know this is not practical.
            if Instance:IsA("Humanoid") or Instance:IsA("AnimationController") then
                self.Character = Instance.Parent
                self.Humanoid = Instance
        
                self:LoopAndCreateTab()
                
                task.wait(self.LogDelay)
                
                continue
            end
        end
    end
end

function Logger:CopyProperties()
    Logger.Lines = {}

    table.insert(Logger.Lines, `--// Code generated by Crimson {Version} - by vez`)
    table.insert(Logger.Lines, `local Player = game:GetService("Players").LocalPlayer`)
    table.insert(Logger.Lines, "")
    table.insert(Logger.Lines, `local Anim = Instance.new("Animation")`)
    table.insert(Logger.Lines, `Anim.AnimationId = "rbxassetid://{Logger.Selected.AnimationId}"`)
    table.insert(Logger.Lines, "")
    table.insert(Logger.Lines, `local AnimTrack = Player.Character.Humanoid:LoadAnimation(Anim)`)
    table.insert(Logger.Lines, `AnimTrack.Priority = Enum.AnimationPriority.{Logger.Selected.Priority}`)
    table.insert(Logger.Lines, `AnimTrack.Looped = {Logger.Selected.Looped}`)
    table.insert(Logger.Lines, `AnimTrack:AdjustSpeed({Logger.Selected.Speed})`)
    table.insert(Logger.Lines, `AnimTrack.TimePosition = {Logger.Selected["Time Position"]}`)
    table.insert(Logger.Lines, `AnimTrack:Play()`)
    table.insert(Logger.Lines, "")
    table.insert(Logger.Lines, `task.wait(AnimTrack.Length)`)
    table.insert(Logger.Lines, `AnimTrack:Stop()`)
    table.insert(Logger.Lines, `Anim:Destroy()`)
    
    Logger.Text = table.concat(Logger.Lines, "\n")
    setclipboard(Logger.Text)
end

task.spawn(function()
    while task.wait() do
        task.wait((AutoClearLogsDelay and AutoClearLogsDelay) or math.huge)

        if Logger.Stacking then
            Library:unstackTabs()

            task.delay(0.1, Library.stackTabs)
        end

        Library:clearLogs()
    end
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

	if Logger.Stacking == true then
		Library:stackTabs()
	else
		Library:unstackTabs()
	end
end)

Library:createAnimToggle("Delay Loop", function(State) 
    Logger.DelayLoop = State
end)

Library:createAnimToggle("Loop Preview", function(State)
    Logger.AnimPreviewToggle = State

    while Logger.AnimPreviewToggle == true do
        Logger.Selected = Logger:GetSelected()
        if Logger.Selected == nil then continue end

        Logger.NewThread = task.spawn(function()
            if Logger.Selected ~= Logger:GetSelected() or Logger.AnimPreviewToggle == false then
                Library.stopPreview()
            end
        end)

        local Success, Fail = pcall(function()
            Library.playPreview(`rbxassetid://{Logger.Selected.AnimationId}`)
        end)

        if not Success then
            warn(`[{Version}] Crimson had a stroke (2): {Fail} (This error is quite irrelevant most likely.)`)
        end

        if Logger.DelayLoop == true then
            task.wait(1)
        else
            task.wait()
        end
    end
end)

Library:createBottomButton("Delay: 0s*", function()
    Logger:ChangeLogDelay()
end)

Library:createBottomButton("LocalPlayer*", function()
    Logger:ChangeLogTarget()
end)

Library:createBottomButton("Copy AnimId", function()
    Logger.Selected = Logger:GetSelected()
    if Logger.Selected == nil then return end
    
    setclipboard(`--// AnimationId provided by Crimson {Version} - by vez\nrbxassetid://{Logger.Selected.AnimationId}`)
end)

Library:createBottomButton("Copy Properties", function()
    Logger.Selected = Logger:GetSelected()
    if Logger.Selected == nil then return end
    
    Logger:CopyProperties()
end)

Library:createButtomLine()

Library:createBottomButton("Clear Logs", function()
    if Logger.Stacking then
        Library:unstackTabs()

        task.delay(0.1, Library.stackTabs)
    end

    Library:clearLogs()
end)

Library:createBottomButton("Play Animation", function()
    Logger:PlayAnimation()
end)
Services.CoreGui.AnimLoggerUI.Background.contain.bottom.contain["Play Animation"].BackgroundTransparency = 0
