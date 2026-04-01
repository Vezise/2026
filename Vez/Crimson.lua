--// UI by moonroon - specifically made for this script.
local Repo = "https://raw.githubusercontent.com/Vezise/ui-for-vez/main/"
local Load = function(f)
    return loadstring(
        game:HttpGet(`{Repo}{f}`)
    )()
end

local Library = Load("ui_lib.lua")

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
    OldValue = nil;
    NewValue = nil;
    LogDelay = 0;
    LogDelays = {0, 1, 2, 3};
    LogTargets = {"LocalPlayer", "AllPlayers", "Others"};
    LogTarget = "LocalPlayer";

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
    local PropertiesFolder = nil
    local PropertiesTable = {}

    for _, Log in self.Logs:GetChildren() do
        if Log:FindFirstChild("log") and Log.log.BackgroundTransparency == 0 then
            PropertiesFolder = self.LogProperties[Log.Name]
            break
        end
    end

    for _, Property in PropertiesFolder:GetChildren() do
        if Property.Name == "propdif" and Property.Visible == true then
            local SelectedProperty = self.Properties[Property.name.Text]

            if SelectedProperty then
                PropertiesTable[SelectedProperty] = Property.value.Text
                continue
            end
        end

        if Property.Name == "contain" then
            if Property.length then
                PropertiesTable.Length = Property.length.value.Text
            end
            
            if Property.priority then
                PropertiesTable.Priority = Property.priority.value.Text
            end
        end
    end

    return PropertiesTable
end

function Logger:PlayAnimation()
    self.Selected = self:GetSelected()
    if self.Selected == nil then return end

    local Anim = Instance.new("Animation")
    print(`rbxassetid://{self.Selected.AnimationId}`)
    Anim.AnimationId = `rbxassetid://{self.Selected.AnimationId}`

    local AnimTrack = self.LocalPlayer.Character.Humanoid:LoadAnimation(Anim)

    AnimTrack.Priority = Enum.AnimationPriority[self.Selected.Priority]
    AnimTrack.Looped = self.Selected.Looped
    AnimTrack:AdjustSpeed(self.Selected.Speed)
    AnimTrack.TimePosition = self.Selected["Time Position"]
    AnimTrack:Play()

    task.wait(self.Selected.Length)
    AnimTrack:Stop()
    Anim:Destroy()
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
    self.AnimationTracks = self.Humanoid.Animator:GetPlayingAnimationTracks()
    
    for _, Animation in self.AnimationTracks do
        self.SelectedAnim = Animation.Animation
        if table.find(BlockedAnimations, self.SelectedAnim.Name) then continue end
        
        local Log = Library:createLog(
            `rbxassetid://{self.SelectedAnim.AnimationId:match("%d+")}                    {self.SelectedAnim.Name}`,
            `{self.SelectedAnim.Name}`,
            `{string.format("%.3f", Animation.Length)}`,
            `{Animation.Priority.Name}`,
            function()
                print("created an anim log :fire:")
            end
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
            if Instance:IsA("Humanoid") then
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

    table.insert(Logger.Lines, `local Player = game:GetService("Players").LocalPlayer`)
    table.insert(Logger.Lines, "")
    table.insert(Logger.Lines, `local Anim = Instance.new("Animation")`)
    table.insert(Logger.Lines, `Anim.AnimationId = "rbxassetid://{Logger.Selected.AnimationId}"`)
    table.insert(Logger.Lines, "")
    table.insert(Logger.Lines, `local AnimTrack = Player.Character.Humanoid:LoadAnimation(Anim)`)
    table.insert(Logger.Lines, `AnimTrack.Priority = Enum.AnimationPriority.{Logger.Selected.Priority}`)
    table.insert(Logger.Lines, `AnimTrack.Looped = {Logger.Selected.Looped}`)
    table.insert(Logger.Lines, `AnimTrack:AdjustSpeed({Logger.Selected.Speed})`)
    table.insert(Logger.Lines, `AnimTrack.TimePosition = {Logger.Selected.TimePosition}`)
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
	if State then
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

        Library.playPreview(`rbxassetid://{Logger.Selected.AnimationId}`)

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
    
    setclipboard(`rbxassetid://{Logger.Selected.AnimationId}`)
end)

Library:createBottomButton("Copy Properties", function()
    Logger.Selected = Logger:GetSelected()
    if Logger.Selected == nil then return end
    
    Logger:CopyProperties()
end)

Library:createButtomLine()

Library:createBottomButton("Clear Logs", function()
    Library:clearLogs()
end)

Library:createBottomButton("Play Animation", function()
    Logger:PlayAnimation()
end)
Services.CoreGui.AnimLoggerUI.Background.contain.bottom.contain["Play Animation"].BackgroundTransparency = 0
