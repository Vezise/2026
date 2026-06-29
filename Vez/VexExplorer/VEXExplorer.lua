getgenv().VexExecutedCheck = false

local RiskyServices = {
    "EncodingService";
    "ExperienceStateRecordingService";
    "LodDataService";
    "TelemetryService";
    "BrowserService";
    "CommerceService";
    "HSRDataContentProvider";
    "StylingService";
    "ControllerService";
    "AvatarEditorService";
    "GenericChallengeService";
    "CSGDictionaryService";
    "EditableService";
    "AchievementService";
    "CollectionService";
    "ScriptRegistrationService";
    "AdService";
    "InsertService";
    "StudioData";
    "RobloxReplicatedStorage";
    "LogService";
    "SolidModelContentProvider";
    "ExperienceNotificationService";
    "Visit";
    "SoundService";
    "ScriptService";
    "ChangeHistoryService";
    "RuntimeContentService";
    "HapticService";
    "MaterialService";
    "ContentProvider";
    "IXPService";
    "UserService";
    "NonReplicatedCSGDictionaryService";
    "TextService";
    "Stats";
    "NetworkClient";
    "TweenService";
    "PlatformLibraries";
    "GuidRegistryService";
    "PlayerHydrationService";
    "KeyframeSequenceProvider";
    "HttpRbxApiService";
    "CorePackages";
    "GuiService";
    "Teleport Service";
    "TextBoxService";
    "CookiesService";
    "VRService";
    "FaceAnimatorService";
    "CreatorStoreService";
    "PhysicsService";
    "AvatarSettings";
    "LocalizationTable";
    "RuntimeScriptService";
    "HttpService";
    "ThirdPartyUserService";
    "PlatformFriendsService";
    "UIDragDetectorService";
    "HeapProfilerService";
    "FilteredSelection";
    "FacialAgeEstimationService";
    "PlatformCloudStorageService";
    "SessionService";
    "CaptureService";
    "ModerationService";
    "ExperienceService";
    "AuroraService";
    "RtMessagingService";
    "PolicyService";
    "GroupService";
    "SpawnerService";
    "RbxAnalyticsService";
    "Chat";
    "AudioFocusService";
    "Selection";
    "VoiceChatService";
    "SlimContentProvider";
    "ExperienceAuthService";
    "GamepadService";
    "TouchInputService";
    "Run Service";
    "SharedTableRegistry";
    "Script Context";
    "AvatarCreationService";
    "FriendService";
    "ScriptProfilerService";
    "AppLifecycleObserverService";
    "SafetyService";
    "SocialService";
    "AssetService";
    "AvatarChatService";
    "AnimationClipProvider";
    "TemporaryCageMeshProvider";
    "LinkingService";
    "PlayerEmulatorService";
    "MemStorageService";
    "RobloxServerStorage";
    "TestService";
    "ProximityPromptService";
    "VideoService";
    "MessageBusService";
    "TextChatService";
    "BadgeService";
    "ExperienceStateCaptureService";
    "EventIngestService";
    "WebViewService";
    "PermissionsService";
    "MarketplaceService";
    "MeshContentProvider";
    "TimerService";
    "AppStorageService";
    "UserInputService";
    "NetworkServer";
    "MouseService";
    "LocalizationService";
    "RecommendationService";
    "AnalyticsService";
    "Instance";
    "KeyboardService";
    "JointsService";
    "HeatmapService";
    "NotificationService";
    "MicroProfilerService";
    "VideoCaptureService";
    "ContextActionService";
    "PointsService";
    "FeatureRestrictionManager";
    "GamePassService";
    "GenerationService";
    "SlimReplicationService";
    "SlimAnimationReplicationService";
    "Packages";
    "Debris";
    "ServerScriptService";
    "ServerStorage";
}

local NewInstance = Instance.new

local cloneref = (function()
    local Native = cloneref
    if not Native then
        return function(Object)
            return Object
        end
    end

    local Cache = setmetatable({}, {__mode = "v"})

    return function(Object)
        if not Object then
            return nil
        end

        local Id = Object:GetDebugId()
        local Cached = Cache[Id]
        if Cached then
            return Cached
        end

        local Cloned = Native(Object)
        Cache[Id] = Cloned

        return Cloned
    end
end)()

local function GetService(Name)
    return cloneref(game:GetService(Name))
end

local Services = {
    Players = GetService("Players");
    UserInputService = GetService("UserInputService");
    TweenService = GetService("TweenService");
    RunService = GetService("RunService");
    HttpService = GetService("HttpService");
    CoreGui = GetService("CoreGui");
    TeleportService = GetService("TeleportService");
    CollectionService = game:GetService("CollectionService");
    GuiService = GetService("GuiService");
}

task.wait(0.2)

do
    local Hosts = {}
    local Good, GuiHolder = pcall(gethui)
    if Good and GuiHolder then
        table.insert(Hosts, GuiHolder)
    end
    table.insert(Hosts, Services.CoreGui)

    for _, Host in Hosts do
        for _, Child in Host:GetChildren() do
            if Child.Name == "VexExplorer" then
                pcall(function()
                    Child:Destroy()
                end)
            end
        end
    end
end

local LocalPlayer = cloneref(Services.Players.LocalPlayer)
local RawGetChildren = game.GetChildren
local RawGetDescendants = game.GetDescendants

local function ClonerefInstance(Object)
    if cloneref then
        local Good, Cloned = pcall(cloneref, Object)
        if Good then
            return Cloned
        end
    end

    return Object
end

local function WeakGetChildren(Object)
    local Good, Raw = pcall(RawGetChildren, Object)
    if not Good or type(Raw) ~= "table" then
        return setmetatable({}, {__mode = "v"})
    end

    setmetatable(Raw, {__mode = "v"})
    local Out = {}
    for Index = 1, #Raw do
        Out[Index] = ClonerefInstance(Raw[Index])
    end

    return Out
end

local function WeakGetDescendants(Object)
    local Good, Raw = pcall(RawGetDescendants, Object)
    if not Good or type(Raw) ~= "table" then
        return setmetatable({}, {__mode = "v"})
    end

    setmetatable(Raw, {__mode = "v"})
    local Out = {}
    for Index = 1, #Raw do
        Out[Index] = ClonerefInstance(Raw[Index])
    end

    return Out
end

local KillScript = false
local Connections = {}

local function Track(Connection)
    table.insert(Connections, Connection)
    return Connection
end

local function CompactConnections()
    local Kept = {}
    for _, C in Connections do
        if C and C.Connected then
            Kept[#Kept + 1] = C
        end
    end
    Connections = Kept
end

local function SafeGet(Object, Key)
    local Good, Result = pcall(function()
        return Object[Key]
    end)

    if Good then
        return Result
    end

    return nil
end

local function SafeSet(Object, Key, Value)
    pcall(function()
        Object[Key] = Value
    end)
end

local SerializeSkip = {
    Parent = true; ClassName = true; RobloxLocked = true; Archivable = true;
    DataCost = true; Container = true;
    LocalPlayer = true; Character = true;
    Position = true; Orientation = true; Rotation = true;
    Attributes = true;
}

local SerializePriority = {
    Name = 1;
    CFrame = 2; Size = 3;
    Color = 4; Material = 5;
    Anchored = 6; CanCollide = 7;
}

local function FormatLuaString(Value)
    return string.format("%q", Value)
end

local function FormatNumber(Value)
    if Value ~= Value then return "0/0" end
    if Value == math.huge then return "math.huge" end
    if Value == -math.huge then return "-math.huge" end
    if math.floor(Value) == Value and math.abs(Value) < 1e15 then
        return tostring(math.floor(Value))
    end
    return string.format("%.6g", Value)
end

local function FormatStringForCode(Value)
    if type(Value) ~= "string" then
        return tostring(Value)
    end

    if not Value:find("[\"\\\n\r]") then
        return `"{Value}"`
    end

    local Level = 0
    while Value:find(`]{string.rep("=", Level)}]`, 1, true) do
        Level += 1
    end

    local Eq = string.rep("=", Level)
    local Prefix = Value:sub(1, 1) == "\n" and "\n" or ""
    return `[{Eq}[{Prefix}{Value}]{Eq}]`
end

local LuaKeywords = {
    ["and"] = true; ["break"] = true; ["do"] = true; ["else"] = true;
    ["elseif"] = true; ["end"] = true; ["false"] = true; ["for"] = true;
    ["function"] = true; ["goto"] = true; ["if"] = true; ["in"] = true;
    ["local"] = true; ["nil"] = true; ["not"] = true; ["or"] = true;
    ["repeat"] = true; ["return"] = true; ["then"] = true; ["true"] = true;
    ["until"] = true; ["while"] = true; ["continue"] = true;
}

local function IsValidIdentifier(Name)
    if type(Name) ~= "string" or Name == "" then return false end
    if LuaKeywords[Name] then return false end
    return Name:match("^[%a_][%w_]*$") ~= nil
end

local function BuildLuaPath(Object)
    if typeof(Object) ~= "Instance" then
        return "nil"
    end

    local Parts = {}
    local Cursor = Object
    while Cursor and Cursor.Parent ~= nil do
        table.insert(Parts, 1, Cursor.Name)
        Cursor = Cursor.Parent
    end

    if #Parts == 0 then
        return "game"
    end

    local Result = "game"
    local ServiceIndex = 1
    local FirstName = Parts[1]

    Result = `game:GetService("{FirstName}")`
    ServiceIndex = 2

    for I = ServiceIndex, #Parts do
        local Name = Parts[I]
        if IsValidIdentifier(Name) then
            Result = `{Result}.{Name}`
        else
            Result = `{Result}[{FormatStringForCode(Name)}]`
        end
    end

    return Result
end

local function SerializeValue(Value)
    local Type = typeof(Value)

    if Type == "string" then
        return FormatStringForCode(Value)
    elseif Type == "number" then
        return FormatNumber(Value)
    elseif Type == "boolean" then
        return tostring(Value)
    elseif Type == "nil" then
        return "nil"
    elseif Type == "Vector3" then
        return `Vector3.new({FormatNumber(Value.X)}, {FormatNumber(Value.Y)}, {FormatNumber(Value.Z)})`
    elseif Type == "Vector2" then
        return `Vector2.new({FormatNumber(Value.X)}, {FormatNumber(Value.Y)})`
    elseif Type == "UDim" then
        return `UDim.new({FormatNumber(Value.Scale)}, {FormatNumber(Value.Offset)})`
    elseif Type == "UDim2" then
        return `UDim2.new({FormatNumber(Value.X.Scale)}, {FormatNumber(Value.X.Offset)}, {FormatNumber(Value.Y.Scale)}, {FormatNumber(Value.Y.Offset)})`
    elseif Type == "Color3" then
        return `Color3.fromRGB({math.floor(Value.R * 255 + 0.5)}, {math.floor(Value.G * 255 + 0.5)}, {math.floor(Value.B * 255 + 0.5)})`
    elseif Type == "BrickColor" then
        return `BrickColor.new({FormatLuaString(Value.Name)})`
    elseif Type == "CFrame" then
        local C = {Value:GetComponents()}
        local Parts = {}
        for I, V in C do Parts[I] = FormatNumber(V) end
        return `CFrame.new({table.concat(Parts, ", ")})`
    elseif Type == "EnumItem" then
        return `Enum.{tostring(Value.EnumType)}.{Value.Name}`
    elseif Type == "Rect" then
        return `Rect.new({FormatNumber(Value.Min.X)}, {FormatNumber(Value.Min.Y)}, {FormatNumber(Value.Max.X)}, {FormatNumber(Value.Max.Y)})`
    elseif Type == "NumberRange" then
        return `NumberRange.new({FormatNumber(Value.Min)}, {FormatNumber(Value.Max)})`
    elseif Type == "NumberSequence" then
        local Parts = {}
        for _, K in Value.Keypoints do
            table.insert(Parts, `NumberSequenceKeypoint.new({FormatNumber(K.Time)}, {FormatNumber(K.Value)}, {FormatNumber(K.Envelope)})`)
        end
        return "NumberSequence.new({" .. table.concat(Parts, ", ") .. "})"
    elseif Type == "ColorSequence" then
        local Parts = {}
        for _, K in Value.Keypoints do
            table.insert(Parts, `ColorSequenceKeypoint.new({FormatNumber(K.Time)}, {SerializeValue(K.Value)})`)
        end
        return "ColorSequence.new({" .. table.concat(Parts, ", ") .. "})"
    elseif Type == "Vector3int16" then
        return `Vector3int16.new({Value.X}, {Value.Y}, {Value.Z})`
    elseif Type == "Vector2int16" then
        return `Vector2int16.new({Value.X}, {Value.Y})`
    elseif Type == "Instance" then
        return `nil --[[ ref: {Value:GetFullName()} ]]`
    elseif Type == "Font" then
        return `Font.new({FormatLuaString(Value.Family)}, Enum.FontWeight.{Value.Weight.Name}, Enum.FontStyle.{Value.Style.Name})`
    end

    return `nil --[[ unsupported {Type} ]]`
end

local SerializeDeprecated = {
    Position = true; Orientation = true; Rotation = true;
    brickColor = true; BrickColor = true;
    size = true; Size_Deprecated = true;
    CollisionGroupId = true;
    AssemblyCenterOfMass = true; AssemblyMass = true; AssemblyRootPart = true;
    AssemblyLinearVelocity = true; AssemblyAngularVelocity = true;
    ExtentsCFrame = true; ExtentsSize = true;
    Mass = true; ReceiveAge = true;
    DataCost = true; Container = true;
    Archivable = true; RobloxLocked = true;
    LocalTransparencyModifier = true;
    ChatHistory = true;
}

local ReadOnlyProperties = {
    ClassName = true;
    AccountAge = true;
    UserId = true;
    MembershipType = true;
    FollowUserId = true;
    LocalPlayer = true;
    NumPlayers = true;
    MaxPlayers = true;
    PreferredPlayers = true;
    IsLoaded = true;
    IsPlaying = true;
    IsPaused = true;
    TimeLength = true;
    Occupant = true;
    AssemblyLinearVelocity = true;
    AssemblyAngularVelocity = true;
    WorldCFrame = true;
    WorldPosition = true;
}

local CollectProperties;
local function GetPropertyDiff(Object)
    local ClassGood, ClassName = pcall(function() return Object.ClassName end)
    if not ClassGood then return {} end

    local TemplateGood, Template = pcall(Instance.new, ClassName)
    if not TemplateGood or not Template then
        return {}
    end

    local Names = CollectProperties(Object)
    local Out = {}

    for _, PropName in Names do
        if SerializeSkip[PropName] then continue end
        if SerializeDeprecated[PropName] then continue end
        if ReadOnlyProperties and ReadOnlyProperties[PropName] then continue end
        if PropName == "Parent" then continue end

        local ReadGood, Value = pcall(function() return Object[PropName] end)
        if not ReadGood then continue end

        if typeof(Value) == "Instance" then
            continue
        end

        local DefGood, Default = pcall(function() return Template[PropName] end)
        if not DefGood then
            table.insert(Out, {Name = PropName, Value = Value})
            continue
        end

        if Value ~= Default then
            table.insert(Out, {Name = PropName, Value = Value})
        end
    end

    pcall(function() Template:Destroy() end)

    table.sort(Out, function(L, R)
        local LP = SerializePriority[L.Name] or 1000
        local RP = SerializePriority[R.Name] or 1000
        if LP ~= RP then return LP < RP end
        return L.Name < R.Name
    end)

    return Out
end

local function SerializeInstance(Object)
    if typeof(Object) ~= "Instance" then
        return "-- not an instance"
    end

    local Lines = {}
    local VarName = "Object"
    local PathExpr = BuildLuaPath(Object)

    table.insert(Lines, `local {VarName} = Instance.new("{Object.ClassName}")`)

    local Diff = GetPropertyDiff(Object)
    for _, Entry in Diff do
        table.insert(Lines, `{VarName}.{Entry.Name} = {SerializeValue(Entry.Value)}`)
    end

    local AttrGood, Attrs = pcall(function() return Object:GetAttributes() end)
    if AttrGood and type(Attrs) == "table" then
        local AttrNames = {}
        for K in Attrs do table.insert(AttrNames, K) end
        table.sort(AttrNames)
        if #AttrNames > 0 then
            table.insert(Lines, "")
            for _, K in AttrNames do
                table.insert(Lines, `{VarName}:SetAttribute("{K}", {SerializeValue(Attrs[K])})`)
            end
        end
    end

    local TagsGood, Tags = pcall(function()
        return Services.CollectionService:GetTags(Object)
    end)
    if TagsGood and type(Tags) == "table" and #Tags > 0 then
        table.insert(Lines, "")
        table.insert(Lines, `local CollectionService = game:GetService("CollectionService")`)
        for _, Tag in Tags do
            table.insert(Lines, `CollectionService:AddTag({VarName}, {FormatLuaString(Tag)})`)
        end
    end

    table.insert(Lines, "")
    table.insert(Lines, `-- Source: {PathExpr}`)
    table.insert(Lines, `{VarName}.Parent = {BuildLuaPath(Object.Parent) or "workspace"}`)

    return table.concat(Lines, "\n")
end

local ErrorLogFolder = "Vex/ErrorLogs"
local ErrorLogPath = nil
local ErrorLogReady = false

local function InitialiseErrorLog()
    if ErrorLogReady then
        return
    end

    if not makefolder
        or not isfolder
        or not isfile
        or not writefile
    then
        return
    end

    pcall(function()
        if not isfolder("Vex") then
            makefolder("Vex")
        end

        if not isfolder(ErrorLogFolder) then
            makefolder(ErrorLogFolder)
        end
    end)

    local Index = 1

    while true do
        local Candidate = `{ErrorLogFolder}/ErrorLog_{Index}.txt`
        if not isfile(Candidate) then
            ErrorLogPath = Candidate
            break
        end

        Index += 1

        if Index > 100 then
            ErrorLogPath = `{ErrorLogFolder}/ErrorLog_overflow.txt`

            break
        end
    end

    pcall(function()
        local Header = `=== Vex Explorer error log session started {os.date("%Y-%m-%d %H:%M:%S")} ===\n`
        writefile(ErrorLogPath, Header)
    end)

    ErrorLogReady = true
end

local function AppendErrorLog(Text)
    InitialiseErrorLog()

    if not ErrorLogPath then
        return
    end

    local Stamp = os.date("[%H:%M:%S]")
    local Line = `{Stamp} {Text}\n`

    if appendfile then
        pcall(appendfile, ErrorLogPath, Line)
    else
        return
    end
end

local Explorer
local function NotifyError(Message)
    if Explorer and Explorer.ShowErrorNotification then
        pcall(function()
            Explorer:ShowErrorNotification(Message)
        end)
    end
end

local function Handle(Callback, FunctionName)
    local Failed, Info = xpcall(Callback, function(ErrorMessage)
        local LineNumber = "*?*"
        for StackLevel = 2, 20 do
            local DebugInfo = debug.getinfo(StackLevel)
            if not DebugInfo then break end

            if DebugInfo.currentline and DebugInfo.currentline > 0 then
                LineNumber = DebugInfo.currentline
                break
            end
        end

        if KillScript or VexExecutedCheck then
            return task.wait(9e9)
        end

        local Formatted = `[Vex] {FunctionName} Error at line {LineNumber} [Time: {DateTime.now()}]: {ErrorMessage}`
        AppendErrorLog(Formatted)
        NotifyError(`{FunctionName} (line {LineNumber})`)

        return ErrorMessage
    end)

    if not Failed then
        return
    end

    return Info
end

local CachedDecompile = decompile
local last = 0
getgenv().decompile = function(scr) -- lua.expert
    local ok, bytecode = pcall(getscriptbytecode, scr)
    if not ok then
        return "-- failed to read script bytecode\n--[[\n" .. tostring(bytecode) .. "\n--]]"
    end

    local elapsed = os.clock() - last
    if elapsed < 0.12 then
        task.wait(0.12 - elapsed)
    end

    local encoder = base64_encode
    if not encoder then
        encoder = function(data)
            local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
            return ((data:gsub('.', function(x)
                local r,byte = '',x:byte()
                for i=8,1,-1 do
                    r = r .. (byte % 2^i - byte % 2^(i-1) > 0 and '1' or '0')
                end
                return r
            end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
                if #x < 6 then return '' end
                local c = 0
                for i=1,6 do
                    c = c + (x:sub(i,i) == '1' and 2^(6-i) or 0)
                end
                return b:sub(c+1,c+1)
            end)..({ '', '==', '=' })[#data % 3 + 1])
        end
    end

    local res = request({
        Url = "https://api.lua.expert/decompile",
        Method = "POST",
        Headers = {
            ["content-type"] = "application/json"
        },
        Body = Services.HttpService:JSONEncode({
            script = encoder(bytecode)
        })
    })

    last = os.clock()

    if not res or res.StatusCode ~= 200 then
        return "-- api request error\n--[[\n" .. (res and res.Body or "no response") .. "\n--]]"
    end

    return res.Body
end
local AssetBaseURL = "https://raw.githubusercontent.com/Vezise/2026/main/Vez/Libraries/VexExplorer/Assets"
local AssetFolder = "Vex"
local AssetsSubFolder = "Vex/Assets"

local AvailableAssets = {
    Accessory = true; AnimationTrack = true; Attachment = true; Backpack = true;
    BindableEvent = true; BindableFunction = true; BodyVelocity = true;
    BoxHandleAdornment = true; Camera = true; Chat = true; ClickDetector = true;
    ColorCorrectionEffect = true; ConeHandleAdornment = true; Configuration = true;
    ConsoleIcon = true;
    CoreGui = true; CylinderHandleAdornment = true; Explosion = true; Fire = true;
    Flag = true; FlagStand = true; Folder = true; Frame = true;
    FreezeIcon = true;
    Highlight = true;
    HingeConstraint = true; Humanoid = true; ImageButton = true; ImageFrame = true;
    ImageHandleAdornment = true; ImageLabel = true; InsertService = true;
    JointsService = true; Lighting = true; LineHandleAdornment = true;
    LocalScript = true; MeshPart = true; Model = true; ModuleScript = true;
    Motor6D = true; NetworkClient = true; NumberValue = true; Pants = true;
    Part = true; ParticleEffect = true; Player = true; Players = true;
    RemoteEvent = true; RemoteFunction = true; ReplicatedFirst = true;
    ReplicatedStorage = true; ScreenGui = true; Script = true; Seat = true;
    Selection = true; SelectionPartLasso = true; Shirt = true; Sky = true;
    Smoke = true; Sound = true; SpawnLocation = true; SphereHandleAdornment = true;
    StarterGui = true; StarterPlayer = true; StringValue = true; SearchIcon = true;
    SettingsIcon = true;
    SurfaceGui = true; TShirt = true; Team = true; Teams = true; Terrain = true;
    TestService = true; TextButton = true; TextChatService = true; TextLabel = true;
    Texture = true; Tool = true; TouchInterest = true; UIListLayout = true;
    UnionOperation = true; Unspecified = true; Weld = true; Workspace = true;
}

local Lib = Lib or {}
Lib.IconMap = (function()
		local funcs = {}
		local IconList = {
			Old = {
				MapId = 483448923,
				IconSize = 16,
				Witdh = 16,
				Height = 16,
				Icons = {
					["Accessory"] = 32;
					["Accoutrement"] = 32;
					["AdService"] = 73;
					["Animation"] = 60;
					["AnimationController"] = 60;
					["AnimationTrack"] = 60;
					["Animator"] = 60;
					["ArcHandles"] = 56;
					["AssetService"] = 72;
					["Attachment"] = 34;
					["Backpack"] = 20;
					["BadgeService"] = 75;
					["BallSocketConstraint"] = 89;
					["BillboardGui"] = 64;
					["BinaryStringValue"] = 4;
					["BindableEvent"] = 67;
					["BindableFunction"] = 66;
					["BlockMesh"] = 8;
					["BloomEffect"] = 90;
					["BlurEffect"] = 90;
					["BodyAngularVelocity"] = 14;
					["BodyForce"] = 14;
					["BodyGyro"] = 14;
					["BodyPosition"] = 14;
					["BodyThrust"] = 14;
					["BodyVelocity"] = 14;
					["BoolValue"] = 4;
					["BoxHandleAdornment"] = 54;
					["BrickColorValue"] = 4;
					["Camera"] = 5;
					["CFrameValue"] = 4;
					["CharacterMesh"] = 60;
					["Chat"] = 33;
					["ClickDetector"] = 41;
					["CollectionService"] = 30;
					["Color3Value"] = 4;
					["ColorCorrectionEffect"] = 90;
					["ConeHandleAdornment"] = 54;
					["Configuration"] = 58;
					["ContentProvider"] = 72;
					["ContextActionService"] = 41;
					["CoreGui"] = 46;
					["CoreScript"] = 18;
					["CornerWedgePart"] = 1;
					["CustomEvent"] = 4;
					["CustomEventReceiver"] = 4;
					["CylinderHandleAdornment"] = 54;
					["CylinderMesh"] = 8;
					["CylindricalConstraint"] = 89;
					["Debris"] = 30;
					["Decal"] = 7;
					["Dialog"] = 62;
					["DialogChoice"] = 63;
					["DoubleConstrainedValue"] = 4;
					["Explosion"] = 36;
					["FileMesh"] = 8;
					["Fire"] = 61;
					["Flag"] = 38;
					["FlagStand"] = 39;
					["FloorWire"] = 4;
					["Folder"] = 70;
					["ForceField"] = 37;
					["Frame"] = 48;
					["GamePassService"] = 19;
					["Glue"] = 34;
					["GuiButton"] = 52;
					["GuiMain"] = 47;
					["GuiService"] = 47;
					["Handles"] = 53;
					["HapticService"] = 84;
					["Hat"] = 45;
					["HingeConstraint"] = 89;
					["Hint"] = 33;
					["HopperBin"] = 22;
					["HttpService"] = 76;
					["Humanoid"] = 9;
					["ImageButton"] = 52;
					["ImageLabel"] = 49;
					["InsertService"] = 72;
					["IntConstrainedValue"] = 4;
					["IntValue"] = 4;
					["JointInstance"] = 34;
					["JointsService"] = 34;
					["Keyframe"] = 60;
					["KeyframeSequence"] = 60;
					["KeyframeSequenceProvider"] = 60;
					["Lighting"] = 13;
					["LineHandleAdornment"] = 54;
					["LocalScript"] = 18;
					["LogService"] = 87;
					["MarketplaceService"] = 46;
					["Message"] = 33;
					["Model"] = 2;
					["ModuleScript"] = 71;
					["Motor"] = 34;
					["Motor6D"] = 34;
					["MoveToConstraint"] = 89;
					["NegateOperation"] = 78;
					["NetworkClient"] = 16;
					["NetworkReplicator"] = 29;
					["NetworkServer"] = 15;
					["NumberValue"] = 4;
					["ObjectValue"] = 4;
					["Pants"] = 44;
					["ParallelRampPart"] = 1;
					["Part"] = 1;
					["ParticleEmitter"] = 69;
					["PartPairLasso"] = 57;
					["PathfindingService"] = 37;
					["Platform"] = 35;
					["Player"] = 12;
					["PlayerGui"] = 46;
					["Players"] = 21;
					["PlayerScripts"] = 82;
					["PointLight"] = 13;
					["PointsService"] = 83;
					["Pose"] = 60;
					["PrismaticConstraint"] = 89;
					["PrismPart"] = 1;
					["PyramidPart"] = 1;
					["RayValue"] = 4;
					["ReflectionMetadata"] = 86;
					["ReflectionMetadataCallbacks"] = 86;
					["ReflectionMetadataClass"] = 86;
					["ReflectionMetadataClasses"] = 86;
					["ReflectionMetadataEnum"] = 86;
					["ReflectionMetadataEnumItem"] = 86;
					["ReflectionMetadataEnums"] = 86;
					["ReflectionMetadataEvents"] = 86;
					["ReflectionMetadataFunctions"] = 86;
					["ReflectionMetadataMember"] = 86;
					["ReflectionMetadataProperties"] = 86;
					["ReflectionMetadataYieldFunctions"] = 86;
					["RemoteEvent"] = 80;
					["RemoteFunction"] = 79;
					["ReplicatedFirst"] = 72;
					["ReplicatedStorage"] = 72;
					["RightAngleRampPart"] = 1;
					["RocketPropulsion"] = 14;
					["RodConstraint"] = 89;
					["RopeConstraint"] = 89;
					["Rotate"] = 34;
					["RotateP"] = 34;
					["RotateV"] = 34;
					["RunService"] = 66;
					["ScreenGui"] = 47;
					["Script"] = 6;
					["ScrollingFrame"] = 48;
					["Seat"] = 35;
					["Selection"] = 55;
					["SelectionBox"] = 54;
					["SelectionPartLasso"] = 57;
					["SelectionPointLasso"] = 57;
					["SelectionSphere"] = 54;
					["ServerScriptService"] = 0;
					["ServerStorage"] = 74;
					["Shirt"] = 43;
					["ShirtGraphic"] = 40;
					["SkateboardPlatform"] = 35;
					["Sky"] = 28;
					["SlidingBallConstraint"] = 89;
					["Smoke"] = 59;
					["Snap"] = 34;
					["Sound"] = 11;
					["SoundService"] = 31;
					["Sparkles"] = 42;
					["SpawnLocation"] = 25;
					["SpecialMesh"] = 8;
					["SphereHandleAdornment"] = 54;
					["SpotLight"] = 13;
					["SpringConstraint"] = 89;
					["StarterCharacterScripts"] = 82;
					["StarterGear"] = 20;
					["StarterGui"] = 46;
					["StarterPack"] = 20;
					["StarterPlayer"] = 88;
					["StarterPlayerScripts"] = 82;
					["Status"] = 2;
					["StringValue"] = 4;
					["SunRaysEffect"] = 90;
					["SurfaceGui"] = 64;
					["SurfaceLight"] = 13;
					["SurfaceSelection"] = 55;
					["Team"] = 24;
					["Teams"] = 23;
					["TeleportService"] = 81;
					["Terrain"] = 65;
					["TerrainRegion"] = 65;
					["TestService"] = 68;
					["TextBox"] = 51;
					["TextButton"] = 51;
					["TextLabel"] = 50;
					["Texture"] = 10;
					["TextureTrail"] = 4;
					["Tool"] = 17;
					["TouchTransmitter"] = 37;
					["TrussPart"] = 1;
					["UnionOperation"] = 77;
					["UserInputService"] = 84;
					["Vector3Value"] = 4;
					["VehicleSeat"] = 35;
					["VelocityMotor"] = 34;
					["WedgePart"] = 1;
					["Weld"] = 34;
					["Workspace"] = 19;

				}
			},
			Vanilla3 = {
				MapId = (114851699900089),
				IconSize = 32,
				Witdh = 25,
				Height = 25,
				Icons = {
					Accessory = 1,
					Accoutrement = 2,
					Actor = 3,
					AdGui = 4,
					AdPortal = 5,
					AdService = 6,
					AdvancedDragger = 7,
					AirController = 8,
					AlignOrientation = 9,
					AlignPosition = 10,
					AnalysticsService = 11,
					AnalysticsSettings = 12,
					AnalyticsService = 13,
					AngularVelocity = 14,
					Animation = 15,
					AnimationClip = 16,
					AnimationClipProvider = 17,
					AnimationController = 18,
					AnimationFromVideoCreatorService = 19,
					AnimationFromVideoCreatorStudioService = 20,
					AnimationRigData = 21,
					AnimationStreamTrack = 22,
					AnimationTrack = 23,
					Animator = 24,
					AppStorageService = 25,
					AppUpdateService = 26,
					ArcHandles = 27,
					AssetCounterService = 28,
					AssetDeliveryProxy = 29,
					AssetImportService = 30,
					AssetImportSession = 31,
					AssetManagerService = 32,
					AssetService = 33,
					AssetSoundEffect = 34,
					Atmosphere = 35,
					Attachment = 36,
					AvatarEditorService = 37,
					AvatarImportService = 38,
					Backpack = 39,
					BackpackItem = 40,
					BadgeService = 41,
					BallSocketConstraint = 42,
					BasePart = 43,
					BasePlayerGui = 44,
					BaseScript = 45,
					BaseWrap = 46,
					Beam = 47,
					BevelMesh = 48,
					BillboardGui = 49,
					BinaryStringValue = 50,
					BindableEvent = 51,
					BindableFunction = 52,
					BlockMesh = 53,
					BloomEffect = 54,
					BlurEffect = 55,
					BodyAngularVelocity = 56,
					BodyColors = 57,
					BodyForce = 58,
					BodyGyro = 59,
					BodyMover = 60,
					BodyPosition = 61,
					BodyThrust = 62,
					BodyVelocity = 63,
					Bone = 64,
					BoolValue = 65,
					BoxHandleAdornment = 66,
					Breakpoint = 67,
					BreakpointManager = 68,
					BrickColorValue = 69,
					BrowserService = 70,
					BubbleChatConfiguration = 71,
					BulkImportService = 72,
					CacheableContentProvider = 73,
					CalloutService = 74,
					Camera = 75,
					CanvasGroup = 76,
					CatalogPages = 77,
					CFrameValue = 78,
					ChangeHistoryService = 79,
					ChannelSelectorSoundEffect = 80,
					CharacterAppearance = 81,
					CharacterMesh = 82,
					Chat = 83,
					ChatInputBarConfiguration = 84,
					ChatWindowConfiguration = 85,
					ChorusSoundEffect = 86,
					ClickDetector = 87,
					ClientReplicator = 88,
					ClimbController = 89,
					Clothing = 90,
					Clouds = 91,
					ClusterPacketCache = 92,
					CollectionService = 93,
					Color3Value = 94,
					ColorCorrectionEffect = 95,
					CommandInstance = 96,
					CommandService = 97,
					CompressorSoundEffect = 98,
					ConeHandleAdornment = 99,
					Configuration = 100,
					ConfigureServerService = 101,
					Constraint = 102,
					ContentProvider = 103,
					ContextActionService = 104,
					Controller = 105,
					ControllerBase = 106,
					ControllerManager = 107,
					ControllerService = 108,
					CookiesService = 109,
					CoreGui = 110,
					CorePackages = 111,
					CoreScript = 112,
					CoreScriptSyncService = 113,
					CornerWedgePart = 114,
					CrossDMScriptChangeListener = 115,
					CSGDictionaryService = 116,
					CurveAnimation = 117,
					CustomEvent = 118,
					CustomEventReceiver = 119,
					CustomSoundEffect = 120,
					CylinderHandleAdornment = 121,
					CylinderMesh = 122,
					CylindricalConstraint = 123,
					DataModel = 124,
					DataModelMesh = 125,
					DataModelPatchService = 126,
					DataModelSession = 127,
					DataStore = 128,
					DataStoreIncrementOptions = 129,
					DataStoreInfo = 130,
					DataStoreKey = 131,
					DataStoreKeyInfo = 132,
					DataStoreKeyPages = 133,
					DataStoreListingPages = 134,
					DataStoreObjectVersionInfo = 135,
					DataStoreOptions = 136,
					DataStorePages = 137,
					DataStoreService = 138,
					DataStoreSetOptions = 139,
					DataStoreVersionPages = 140,
					Debris = 141,
					DebuggablePluginWatcher = 142,
					DebuggerBreakpoint = 143,
					DebuggerConnection = 144,
					DebuggerConnectionManager = 145,
					DebuggerLuaResponse = 146,
					DebuggerManager = 147,
					DebuggerUIService = 148,
					DebuggerVariable = 149,
					DebuggerWatch = 150,
					DebugSettings = 151,
					Decal = 152,
					DepthOfFieldEffect = 153,
					DeviceIdService = 154,
					Dialog = 155,
					DialogChoice = 156,
					DistortionSoundEffect = 157,
					DockWidgetPluginGui = 158,
					DoubleConstrainedValue = 159,
					DraftsService = 160,
					Dragger = 161,
					DraggerService = 162,
					DynamicRotate = 163,
					EchoSoundEffect = 164,
					EmotesPages = 165,
					EqualizerSoundEffect = 166,
					EulerRotationCurve = 167,
					EventIngestService = 168,
					Explosion = 169,
					FaceAnimatorService = 170,
					FaceControls = 171,
					FaceInstance = 172,
					FacialAnimationRecordingService = 173,
					FacialAnimationStreamingService = 174,
					Feature = 175,
					File = 176,
					FileMesh = 177,
					Fire = 178,
					Flag = 179,
					FlagStand = 180,
					FlagStandService = 181,
					FlangeSoundEffect = 182,
					FloatCurve = 183,
					FloorWire = 184,
					FlyweightService = 185,
					Folder = 186,
					ForceField = 187,
					FormFactorPart = 188,
					Frame = 189,
					FriendPages = 190,
					FriendService = 191,
					FunctionalTest = 192,
					GamepadService = 193,
					GamePassService = 194,
					GameSettings = 195,
					GenericSettings = 196,
					Geometry = 197,
					GetTextBoundsParams = 198,
					GlobalDataStore = 199,
					GlobalSettings = 200,
					Glue = 201,
					GoogleAnalyticsConfiguration = 202,
					GroundController = 203,
					GroupService = 204,
					GuiBase = 205,
					GuiBase2d = 206,
					GuiBase3d = 207,
					GuiButton = 208,
					GuidRegistryService = 209,
					GuiLabel = 210,
					GuiMain = 211,
					GuiObject = 212,
					GuiService = 213,
					HandleAdornment = 214,
					Handles = 215,
					HandlesBase = 216,
					HapticService = 217,
					Hat = 218,
					HeightmapImporterService = 219,
					HiddenSurfaceRemovalAsset = 220,
					Highlight = 221,
					HingeConstraint = 222,
					Hint = 223,
					Hole = 224,
					Hopper = 225,
					HopperBin = 226,
					HSRDataContentProvider = 227,
					HttpRbxApiService = 228,
					HttpRequest = 229,
					HttpService = 230,
					Humanoid = 231,
					HumanoidController = 232,
					HumanoidDescription = 233,
					IKControl = 234,
					ILegacyStudioBridge = 235,
					ImageButton = 236,
					ImageHandleAdornment = 237,
					ImageLabel = 238,
					ImporterAnimationSettings = 239,
					ImporterBaseSettings = 240,
					ImporterFacsSettings = 241,
					ImporterGroupSettings = 242,
					ImporterJointSettings = 243,
					ImporterMaterialSettings = 244,
					ImporterMeshSettings = 245,
					ImporterRootSettings = 246,
					IncrementalPatchBuilder = 247,
					InputObject = 248,
					InsertService = 249,
					Instance = 250,
					InstanceAdornment = 251,
					IntConstrainedValue = 252,
					IntValue = 253,
					InventoryPages = 254,
					IXPService = 255,
					JointInstance = 256,
					JointsService = 257,
					KeyboardService = 258,
					Keyframe = 259,
					KeyframeMarker = 260,
					KeyframeSequence = 261,
					KeyframeSequenceProvider = 262,
					LanguageService = 263,
					LayerCollector = 264,
					LegacyStudioBridge = 265,
					Light = 266,
					Lighting = 267,
					LinearVelocity = 268,
					LineForce = 269,
					LineHandleAdornment = 270,
					LocalDebuggerConnection = 271,
					LocalizationService = 272,
					LocalizationTable = 273,
					LocalScript = 274,
					LocalStorageService = 275,
					LodDataEntity = 276,
					LodDataService = 277,
					LoginService = 278,
					LogService = 279,
					LSPFileSyncService = 280,
					LuaSettings = 281,
					LuaSourceContainer = 282,
					LuauScriptAnalyzerService = 283,
					LuaWebService = 284,
					ManualGlue = 285,
					ManualSurfaceJointInstance = 286,
					ManualWeld = 287,
					MarkerCurve = 288,
					MarketplaceService = 289,
					MaterialService = 290,
					MaterialVariant = 291,
					MemoryStoreQueue = 292,
					MemoryStoreService = 293,
					MemoryStoreSortedMap = 294,
					MemStorageConnection = 295,
					MemStorageService = 296,
					MeshContentProvider = 297,
					MeshPart = 298,
					Message = 299,
					MessageBusConnection = 300,
					MessageBusService = 301,
					MessagingService = 302,
					MetaBreakpoint = 303,
					MetaBreakpointContext = 304,
					MetaBreakpointManager = 305,
					Model = 306,
					ModuleScript = 307,
					Motor = 308,
					Motor6D = 309,
					MotorFeature = 310,
					Mouse = 311,
					MouseService = 312,
					MultipleDocumentInterfaceInstance = 313,
					NegateOperation = 314,
					NetworkClient = 315,
					NetworkMarker = 316,
					NetworkPeer = 317,
					NetworkReplicator = 318,
					NetworkServer = 319,
					NetworkSettings = 320,
					NoCollisionConstraint = 321,
					NonReplicatedCSGDictionaryService = 322,
					NotificationService = 323,
					NumberPose = 324,
					NumberValue = 325,
					ObjectValue = 326,
					OrderedDataStore = 327,
					OutfitPages = 328,
					PackageLink = 329,
					PackageService = 330,
					PackageUIService = 331,
					Pages = 332,
					Pants = 333,
					ParabolaAdornment = 334,
					Part = 335,
					PartAdornment = 336,
					ParticleEmitter = 337,
					PartOperation = 338,
					PartOperationAsset = 339,
					PatchMapping = 340,
					Path = 341,
					PathfindingLink = 342,
					PathfindingModifier = 343,
					PathfindingService = 344,
					PausedState = 345,
					PausedStateBreakpoint = 346,
					PausedStateException = 347,
					PermissionsService = 348,
					PhysicsService = 349,
					PhysicsSettings = 350,
					PitchShiftSoundEffect = 351,
					Plane = 352,
					PlaneConstraint = 353,
					Platform = 354,
					Player = 355,
					PlayerEmulatorService = 356,
					PlayerGui = 357,
					PlayerMouse = 358,
					Players = 359,
					PlayerScripts = 360,
					Plugin = 361,
					PluginAction = 362,
					PluginDebugService = 363,
					PluginDragEvent = 364,
					PluginGui = 365,
					PluginGuiService = 366,
					PluginManagementService = 367,
					PluginManager = 368,
					PluginManagerInterface = 369,
					PluginMenu = 370,
					PluginMouse = 371,
					PluginPolicyService = 372,
					PluginToolbar = 373,
					PluginToolbarButton = 374,
					PointLight = 375,
					PointsService = 376,
					PolicyService = 377,
					Pose = 378,
					PoseBase = 379,
					PostEffect = 380,
					PrismaticConstraint = 381,
					ProcessInstancePhysicsService = 382,
					ProximityPrompt = 383,
					ProximityPromptService = 384,
					PublishService = 385,
					PVAdornment = 386,
					PVInstance = 387,
					QWidgetPluginGui = 388,
					RayValue = 389,
					RbxAnalyticsService = 390,
					ReflectionMetadata = 391,
					ReflectionMetadataCallbacks = 392,
					ReflectionMetadataClass = 393,
					ReflectionMetadataClasses = 394,
					ReflectionMetadataEnum = 395,
					ReflectionMetadataEnumItem = 396,
					ReflectionMetadataEnums = 397,
					ReflectionMetadataEvents = 398,
					ReflectionMetadataFunctions = 399,
					ReflectionMetadataItem = 400,
					ReflectionMetadataMember = 401,
					ReflectionMetadataProperties = 402,
					ReflectionMetadataYieldFunctions = 403,
					RemoteDebuggerServer = 404,
					RemoteEvent = 405,
					RemoteFunction = 406,
					RenderingTest = 407,
					RenderSettings = 408,
					ReplicatedFirst = 409,
					ReplicatedStorage = 410,
					ReverbSoundEffect = 411,
					RigidConstraint = 412,
					RobloxPluginGuiService = 413,
					RobloxReplicatedStorage = 414,
					RocketPropulsion = 415,
					RodConstraint = 416,
					RopeConstraint = 417,
					Rotate = 418,
					RotateP = 419,
					RotateV = 420,
					RotationCurve = 421,
					RtMessagingService = 422,
					RunningAverageItemDouble = 423,
					RunningAverageItemInt = 424,
					RunningAverageTimeIntervalItem = 425,
					RunService = 426,
					RuntimeScriptService = 427,
					ScreenGui = 428,
					ScreenshotHud = 429,
					Script = 430,
					ScriptChangeService = 431,
					ScriptCloneWatcher = 432,
					ScriptCloneWatcherHelper = 433,
					ScriptContext = 434,
					ScriptDebugger = 435,
					ScriptDocument = 436,
					ScriptEditorService = 437,
					ScriptRegistrationService = 438,
					ScriptService = 439,
					ScrollingFrame = 440,
					Seat = 441,
					Selection = 442,
					SelectionBox = 443,
					SelectionLasso = 444,
					SelectionPartLasso = 445,
					SelectionPointLasso = 446,
					SelectionSphere = 447,
					ServerReplicator = 448,
					ServerScriptService = 449,
					ServerStorage = 450,
					ServiceProvider = 451,
					SessionService = 452,
					Shirt = 453,
					ShirtGraphic = 454,
					SkateboardController = 455,
					SkateboardPlatform = 456,
					Skin = 457,
					Sky = 458,
					SlidingBallConstraint = 459,
					Smoke = 460,
					Snap = 461,
					SnippetService = 462,
					SocialService = 463,
					SolidModelContentProvider = 464,
					Sound = 465,
					SoundEffect = 466,
					SoundGroup = 467,
					SoundService = 468,
					Sparkles = 469,
					SpawnerService = 470,
					SpawnLocation = 471,
					Speaker = 472,
					SpecialMesh = 473,
					SphereHandleAdornment = 474,
					SpotLight = 475,
					SpringConstraint = 476,
					StackFrame = 477,
					StandalonePluginScripts = 478,
					StandardPages = 479,
					StarterCharacterScripts = 480,
					StarterGear = 481,
					StarterGui = 482,
					StarterPack = 483,
					StarterPlayer = 484,
					StarterPlayerScripts = 485,
					Stats = 486,
					StatsItem = 487,
					Status = 488,
					StopWatchReporter = 489,
					StringValue = 490,
					Studio = 491,
					StudioAssetService = 492,
					StudioData = 493,
					StudioDeviceEmulatorService = 494,
					StudioHighDpiService = 495,
					StudioPublishService = 496,
					StudioScriptDebugEventListener = 497,
					StudioService = 498,
					StudioTheme = 499,
					SunRaysEffect = 500,
					SurfaceAppearance = 501,
					SurfaceGui = 502,
					SurfaceGuiBase = 503,
					SurfaceLight = 504,
					SurfaceSelection = 505,
					SwimController = 506,
					TaskScheduler = 507,
					Team = 508,
					TeamCreateService = 509,
					Teams = 510,
					TeleportAsyncResult = 511,
					TeleportOptions = 512,
					TeleportService = 513,
					TemporaryCageMeshProvider = 514,
					TemporaryScriptService = 515,
					Terrain = 516,
					TerrainDetail = 517,
					TerrainRegion = 518,
					TestService = 519,
					TextBox = 520,
					TextBoxService = 521,
					TextButton = 522,
					TextChannel = 523,
					TextChatCommand = 524,
					TextChatConfigurations = 525,
					TextChatMessage = 526,
					TextChatMessageProperties = 527,
					TextChatService = 528,
					TextFilterResult = 529,
					TextLabel = 530,
					TextService = 531,
					TextSource = 532,
					Texture = 533,
					ThirdPartyUserService = 534,
					ThreadState = 535,
					TimerService = 536,
					ToastNotificationService = 537,
					Tool = 538,
					ToolboxService = 539,
					Torque = 540,
					TorsionSpringConstraint = 541,
					TotalCountTimeIntervalItem = 542,
					TouchInputService = 543,
					TouchTransmitter = 544,
					TracerService = 545,
					TrackerStreamAnimation = 546,
					Trail = 547,
					Translator = 548,
					TremoloSoundEffect = 549,
					TriangleMeshPart = 550,
					TrussPart = 551,
					Tween = 552,
					TweenBase = 553,
					TweenService = 554,
					UGCValidationService = 555,
					UIAspectRatioConstraint = 556,
					UIBase = 557,
					UIComponent = 558,
					UIConstraint = 559,
					UICorner = 560,
					UIGradient = 561,
					UIGridLayout = 562,
					UIGridStyleLayout = 563,
					UILayout = 564,
					UIListLayout = 565,
					UIPadding = 566,
					UIPageLayout = 567,
					UIScale = 568,
					UISizeConstraint = 569,
					UIStroke = 570,
					UITableLayout = 571,
					UITextSizeConstraint = 572,
					UnionOperation = 573,
					UniversalConstraint = 574,
					UnvalidatedAssetService = 575,
					UserGameSettings = 576,
					UserInputService = 577,
					UserService = 578,
					UserSettings = 579,
					UserStorageService = 580,
					ValueBase = 581,
					Vector3Curve = 582,
					Vector3Value = 583,
					VectorForce = 584,
					VehicleController = 585,
					VehicleSeat = 586,
					VelocityMotor = 587,
					VersionControlService = 588,
					VideoCaptureService = 589,
					VideoFrame = 590,
					ViewportFrame = 591,
					VirtualInputManager = 592,
					VirtualUser = 593,
					VisibilityService = 594,
					Visit = 595,
					VoiceChannel = 596,
					VoiceChatInternal = 597,
					VoiceChatService = 598,
					VoiceSource = 599,
					VRService = 600,
					WedgePart = 601,
					Weld = 602,
					WeldConstraint = 603,
					WireframeHandleAdornment = 604,
					Workspace = 605,
					WorldModel = 606,
					WorldRoot = 607,
					WrapLayer = 608,
					WrapTarget = 609,

				}
			},
			NewDark = {
				MapId = 135148380892747,
				Icons = {
					Accessory = 1,
					Actor = 2,
					AdGui = 3,
					AdPortal = 4,
					AirController = 5,
					AlignOrientation = 6,
					AlignPosition = 7,
					AngularVelocity = 8,
					Animation = 9,
					AnimationConstraint = 10,
					AnimationController = 11,
					AnimationFromVideoCreatorService = 12,
					Animator = 13,
					ArcHandles = 14,
					Atmosphere = 15,
					Attachment = 16,
					AudioAnalyzer = 17,
					AudioChannelMixer = 18,
					AudioChannelSplitter = 19,
					AudioChorus = 20,
					AudioCompressor = 21,
					AudioDeviceInput = 22,
					AudioDeviceOutput = 23,
					AudioDistortion = 24,
					AudioEcho = 25,
					AudioEmitter = 26,
					AudioEqualizer = 27,
					AudioFader = 28,
					AudioFilter = 29,
					AudioFlanger = 30,
					AudioGate = 31,
					AudioLimiter = 32,
					AudioListener = 33,
					AudioPitchShifter = 34,
					AudioPlayer = 35,
					AudioRecorder = 36,
					AudioReverb = 37,
					AudioTextToSpeech = 38,
					AuroraScript = 39,
					AvatarEditorService = 40,
					AvatarSettings = 41,
					Backpack = 42,
					BallSocketConstraint = 43,
					BasePlate = 44,
					Beam = 45,
					BillboardGui = 46,
					BindableEvent = 47,
					BindableFunction = 48,
					BlockMesh = 49,
					BloomEffect = 50,
					BlurEffect = 51,
					BodyAngularVelocity = 52,
					BodyColors = 53,
					BodyForce = 54,
					BodyGyro = 55,
					BodyPosition = 56,
					BodyThrust = 57,
					BodyVelocity = 58,
					Bone = 59,
					BoolValue = 60,
					BoxHandleAdornment = 61,
					Breakpoint = 62,
					BrickColorValue = 63,
					BubbleChatConfiguration = 64,
					Buggaroo = 65,
					Camera = 66,
					CanvasGroup = 67,
					CFrameValue = 68,
					ChannelTabsConfiguration = 69,
					CharacterControllerManager = 70,
					CharacterMesh = 71,
					Chat = 72,
					ChatInputBarConfiguration = 73,
					ChatWindowConfiguration = 74,
					ChorusSoundEffect = 75,
					Class = 76,
					Cleanup = 77,
					ClickDetector = 78,
					ClientReplicator = 79,
					ClimbController = 80,
					Clouds = 81,
					Color = 82,
					ColorCorrectionEffect = 83,
					CompressorSoundEffect = 84,
					ConeHandleAdornment = 85,
					Configuration = 86,
					Constant = 87,
					Constructor = 88,
					Controller = 89,
					CoreGui = 90,
					CornerWedgePart = 91,
					CylinderHandleAdornment = 92,
					CylindricalConstraint = 93,
					Decal = 94,
					DepthOfFieldEffect = 95,
					Dialog = 96,
					DialogChoice = 97,
					DistortionSoundEffect = 98,
					DragDetector = 99,
					EchoSoundEffect = 100,
					EditableImage = 101,
					EditableMesh = 102,
					Enum = 103,
					EnumMember = 104,
					EqualizerSoundEffect = 105,
					Event = 106,
					Explosion = 107,
					FaceControls = 108,
					Field = 109,
					File = 110,
					Fire = 111,
					FlangeSoundEffect = 112,
					Folder = 113,
					ForceField = 114,
					Frame = 115,
					Function = 116,
					GameSettings = 117,
					GroundController = 118,
					Handles = 119,
					HapticEffect = 120,
					HapticService = 121,
					HeightmapImporterService = 122,
					Highlight = 123,
					HingeConstraint = 124,
					Humanoid = 125,
					HumanoidDescription = 126,
					IKControl = 127,
					ImageButton = 128,
					ImageHandleAdornment = 129,
					ImageLabel = 130,
					InputAction = 131,
					InputBinding = 132,
					InputContext = 133,
					Interface = 134,
					IntersectOperation = 135,
					Keyword = 136,
					Lighting = 137,
					LinearVelocity = 138,
					LineForce = 139,
					LineHandleAdornment = 140,
					LocalFile = 141,
					LocalizationService = 142,
					LocalizationTable = 143,
					LocalScript = 144,
					MaterialService = 145,
					MaterialVariant = 146,
					MemoryStoreService = 147,
					MeshPart = 148,
					Meshparts = 149,
					MessagingService = 150,
					Method = 151,
					Model = 152,
					Modelgroups = 153,
					Module = 154,
					ModuleScript = 155,
					Motor6D = 156,
					NegateOperation = 157,
					NetworkClient = 158,
					NoCollisionConstraint = 159,
					Operator = 160,
					PackageLink = 161,
					Pants = 162,
					Part = 163,
					ParticleEmitter = 164,
					Path2D = 165,
					PathfindingLink = 166,
					PathfindingModifier = 167,
					PathfindingService = 168,
					PitchShiftSoundEffect = 169,
					Place = 170,
					Placeholder = 171,
					Plane = 172,
					PlaneConstraint = 173,
					Player = 174,
					Players = 175,
					PluginGuiService = 176,
					PointLight = 177,
					PrismaticConstraint = 178,
					Property = 179,
					ProximityPrompt = 180,
					PublishService = 181,
					Reference = 182,
					RemoteEvent = 183,
					RemoteFunction = 184,
					RenderingTest = 185,
					ReplicatedFirst = 186,
					ReplicatedScriptService = 187,
					ReplicatedStorage = 188,
					ReverbSoundEffect = 189,
					RigidConstraint = 190,
					RobloxPluginGuiService = 191,
					RocketPropulsion = 192,
					RodConstraint = 193,
					RopeConstraint = 194,
					Rotate = 195,
					ScreenGui = 196,
					Script = 197,
					ScrollingFrame = 198,
					Seat = 199,
					Selected_Workspace = 200,
					SelectionBox = 201,
					SelectionSphere = 202,
					ServerScriptService = 203,
					ServerStorage = 204,
					Service = 205,
					Shirt = 206,
					ShirtGraphic = 207,
					SkinnedMeshPart = 208,
					Sky = 209,
					Smoke = 210,
					Snap = 211,
					Snippet = 212,
					SocialService = 213,
					Sound = 214,
					SoundEffect = 215,
					SoundGroup = 216,
					SoundService = 217,
					Sparkles = 218,
					SpawnLocation = 219,
					SpecialMesh = 220,
					SphereHandleAdornment = 221,
					SpotLight = 222,
					SpringConstraint = 223,
					StandalonePluginScripts = 224,
					StarterCharacterScripts = 225,
					StarterGui = 226,
					StarterPack = 227,
					StarterPlayer = 228,
					StarterPlayerScripts = 229,
					Struct = 230,
					StyleDerive = 231,
					StyleLink = 232,
					StyleRule = 233,
					StyleSheet = 234,
					SunRaysEffect = 235,
					SurfaceAppearance = 236,
					SurfaceGui = 237,
					SurfaceLight = 238,
					SurfaceSelection = 239,
					SwimController = 240,
					TaskScheduler = 241,
					Team = 242,
					Teams = 243,
					Terrain = 244,
					TerrainDetail = 245,
					TestService = 246,
					TextBox = 247,
					TextBoxService = 248,
					TextButton = 249,
					TextChannel = 250,
					TextChatCommand = 251,
					TextChatService = 252,
					TextLabel = 253,
					TextString = 254,
					Texture = 255,
					Tool = 256,
					Torque = 257,
					TorsionSpringConstraint = 258,
					Trail = 259,
					TremoloSoundEffect = 260,
					TrussPart = 261,
					TypeParameter = 262,
					UGCValidationService = 263,
					UIAspectRatioConstraint = 264,
					UICorner = 265,
					UIDragDetector = 266,
					UIFlexItem = 267,
					UIGradient = 268,
					UIGridLayout = 269,
					UIListLayout = 270,
					UIPadding = 271,
					UIPageLayout = 272,
					UIScale = 273,
					UISizeConstraint = 274,
					UIStroke = 275,
					UITableLayout = 276,
					UITextSizeConstraint = 277,
					UnionOperation = 278,
					Unit = 279,
					UniversalConstraint = 280,
					UnreliableRemoteEvent = 281,
					UpdateAvailable = 282,
					UserService = 283,
					Value = 284,
					Variable = 285,
					VectorForce = 286,
					VehicleSeat = 287,
					VideoDisplay = 288,
					VideoFrame = 289,
					VideoPlayer = 290,
					ViewportFrame = 291,
					VirtualUser = 292,
					VoiceChannel = 293,
					Voicechat = 294,
					VoiceChatService = 295,
					VRService = 296,
					WedgePart = 297,
					Weld = 298,
					WeldConstraint = 299,
					Wire = 300,
					WireframeHandleAdornment = 301,
					Workspace = 302,
					WorldModel = 303,
					WrapDeformer = 304,
					WrapLayer = 305,
					WrapTarget = 306,
					
					Color3Value = 284,
					IntValue = 284,
					NumberValue = 284,
					ObjectValue = 284,
					RayValue = 284,
					StringValue = 284,
					Vector3Value = 284,
				},
				IconSize = 32,
				Witdh = 18,
				Height = 18,
			},
			NewLight = {
				MapId = "",
				Icons = {
					Class = "rbxasset://studio_svg_textures/Shared/InsertableObjects/Light/Standard/",
				},
				IconSize = 16,
				Witdh = 18,
				Height = 18,
			}
		}
		funcs._ActiveTheme = "NewDark"

		function funcs.SetExplorerTheme(themeName)
			if not themeName or not IconList[themeName] then
				themeName = "NewDark"
			end
			funcs._ActiveTheme = themeName
			local data = IconList[themeName]
			funcs.ExplorerIcons = {
				MapId = data.MapId,
				Icons = data.Icons,
				IconSize = data.IconSize,
				Witdh = data.Witdh,
				Height = data.Height,
			}
		end

		funcs.SetExplorerTheme("NewDark")
		
		

		funcs.GetLabel = function(self)
			local label = Instance.new("ImageLabel")
			self:SetupLabel(label)
			return label
		end

		funcs.SetupLabel = function(self,obj)
			obj.BackgroundTransparency = 1
			obj.ImageRectOffset = Vector2.new(0, 0)
			obj.ImageRectSize = Vector2.new(self.IconSizeX, self.IconSizeY)
			obj.ScaleType = Enum.ScaleType.Crop
			obj.Size = UDim2.new(0, self.IconSizeX, 0, self.IconSizeY)
		end

		funcs.Display = function(self,obj,index)
			obj.Image = self.MapId
			obj.ImageRectSize = Vector2.new(self.IconSizeX, self.IconSizeY)
			if not self.NumX then
				obj.ImageRectOffset = Vector2.new(self.IconSizeX*index, 0)
			else
				obj.ImageRectOffset = Vector2.new(self.IconSizeX*(index % self.NumX), self.IconSizeY*math.floor(index / self.NumX))
			end
		end

		funcs.DisplayByKey = function(self, obj, key)
			if self.IndexDict[key] then
				self:Display(obj, self.IndexDict[key])
			end
		end

		funcs.IconDehash = function(self, _id)
			return math.floor(_id / 14 % 14), math.floor(_id % 14)
		end
		
		local ClassNameNoImage = {}
		funcs.GetExplorerIcon = function(self, obj, index)
			if funcs._ActiveTheme == "Vanilla3" then
				obj.Size = UDim2.fromOffset(16, 16)

				index = (self.ExplorerIcons.Icons[index] or 250) - 1
				obj.ImageRectOffset = Vector2.new(funcs.ExplorerIcons.IconSize * (index % funcs.ExplorerIcons.Height), funcs.ExplorerIcons.IconSize * math.floor(index / funcs.ExplorerIcons.Height))
				obj.ImageRectSize = Vector2.new(funcs.ExplorerIcons.IconSize, funcs.ExplorerIcons.IconSize)
			elseif funcs._ActiveTheme == "Old" then
				index = (self.ExplorerIcons.Icons[index] or 0)
				local row, col = self:IconDehash(index)
				local MapSize = Vector2.new(256, 256)
				local pad, border = 2, 1

				obj.Position = UDim2.new(-col - (pad * (col + 1) + border) / funcs.ExplorerIcons.IconSize, 0, -row - (pad * (row + 1) + border) / funcs.ExplorerIcons.IconSize, 0)
				obj.Size = UDim2.new(MapSize.X / funcs.ExplorerIcons.IconSize, 0, MapSize.Y / funcs.ExplorerIcons.IconSize, 0)
			elseif funcs._ActiveTheme == "NewLight" or funcs._ActiveTheme == "NewDark" then
				local isService = string.find(index, "Service") and game:GetService(index)
				
				obj.Size = UDim2.fromOffset(16, 16)
				index = (self.ExplorerIcons.Icons[index] or (isService and self.ExplorerIcons.Icons.Service) or self.ExplorerIcons.Icons.Placeholder) - 1
				obj.ImageRectOffset = Vector2.new(funcs.ExplorerIcons.IconSize * (index % funcs.ExplorerIcons.Height), funcs.ExplorerIcons.IconSize * math.floor(index / funcs.ExplorerIcons.Height))
				obj.ImageRectSize = Vector2.new(funcs.ExplorerIcons.IconSize, funcs.ExplorerIcons.IconSize)
			else
				index = (self.ExplorerIcons.Icons[index] or 0)
				local row, col = self:IconDehash(index)
				local MapSize = Vector2.new(256, 256)
				local pad, border = 2, 1

				obj.Position = UDim2.new(-col - (pad * (col + 1) + border) / funcs.ExplorerIcons.IconSize, 0, -row - (pad * (row + 1) + border) / funcs.ExplorerIcons.IconSize, 0)
				obj.Size = UDim2.new(MapSize.X / funcs.ExplorerIcons.IconSize, 0, MapSize.Y / funcs.ExplorerIcons.IconSize, 0)
			end
			
		end

		funcs.DisplayExplorerIcons = function(self, Frame, index)
			if Frame:FindFirstChild("IconMap") then
				self:GetExplorerIcon(Frame.IconMap, index)
			else
				Frame.ClipsDescendants = true

				local obj = Instance.new("ImageLabel", Frame)
				obj.BackgroundTransparency = 1
				obj.Image = ("http://www.roblox.com/asset/?id=" .. (self.ExplorerIcons.MapId))
				obj.Name = "IconMap"
				self:GetExplorerIcon(obj, index)
			end
		end

		funcs.SetDict = function(self,dict)
			self.IndexDict = dict
		end

		local mt = {}
		mt.__index = funcs

		local function new(mapId,mapSizeX,mapSizeY,iconSizeX,iconSizeY)
			local obj = setmetatable({
				MapId = mapId,
				MapSizeX = mapSizeX,
				MapSizeY = mapSizeY,
				IconSizeX = iconSizeX,
				IconSizeY = iconSizeY,
				NumX = mapSizeX/iconSizeX,
				IndexDict = {}
			}, mt)
			return obj
		end

		local function newLinear(mapId,iconSizeX,iconSizeY)
			local obj = setmetatable({
				MapId = mapId,
				IconSizeX = iconSizeX,
				IconSizeY = iconSizeY,
				IndexDict = {}
			},mt)
			return obj
		end
		
		local function getIconDataFromName(name)
			return IconList[name] or error("Name not found")
		end

		return {new = new, newLinear = newLinear, getIconDataFromName = getIconDataFromName, SetExplorerTheme = funcs.SetExplorerTheme, IconList = IconList}
	end)()


local ClassIconThemes = {"NewDark", "Vanilla3", "Old"}

local function CreateExplorerClassIcons(ClassIconTheme)
    local theme = ClassIconTheme or "NewDark"
    if not table.find(ClassIconThemes, theme) then
        theme = "NewDark"
    end

    Lib.IconMap.SetExplorerTheme(theme)

    local iconData = Lib.IconMap.getIconDataFromName(theme)
    local atlasW = iconData.IconSize * iconData.Witdh
    local atlasH = iconData.IconSize * iconData.Height

    local ClassIcons = Lib.IconMap.new(
        "rbxassetid://" .. tostring(iconData.MapId),
        atlasW,
        atlasH,
        iconData.IconSize,
        iconData.IconSize
    )

    ClassIcons.ExplorerIcons = {
        MapId = iconData.MapId,
        Icons = iconData.Icons,
        IconSize = iconData.IconSize,
        Witdh = iconData.Witdh,
        Height = iconData.Height,
    }
    ClassIcons._ActiveTheme = theme

    return ClassIcons
end

local function GetUIAssetId(AssetName)
    if not AssetsEnabled then
        return nil
    end

    local CacheKey = `__UI_{AssetName}`
    if AssetCache[CacheKey] ~= nil then
        return AssetCache[CacheKey] or nil
    end

    EnsureAssetFolders()
    local Path = DownloadAsset(AssetName)
    if not Path then
        AssetCache[CacheKey] = false

        return nil
    end

    local Good, AssetId = pcall(getcustomasset, Path)
    if Good and type(AssetId) == "string" and AssetId ~= "" then
        AssetCache[CacheKey] = AssetId

        return AssetId
    end

    AssetCache[CacheKey] = false

    return nil
end

local function PrefetchAssets()
    if not AssetsEnabled then
        return
    end

    task.spawn(function()
        EnsureAssetFolders()

        pcall(DownloadAsset, "CloseIcon")
        pcall(DownloadAsset, "FreezeIcon")
        pcall(DownloadAsset, "ConsoleIcon")
        pcall(DownloadAsset, "SearchIcon")
        pcall(DownloadAsset, "SettingsIcon")
    end)
end

PrefetchAssets()

local PinnedServices = {
    "Workspace";
    "Players";
    "Lighting";
    "ReplicatedFirst";
    "ReplicatedStorage";
    "StarterGui";
    "StarterPlayer";
    "StarterPack";
    "CoreGui";
}

local PinnedRank = {}
for Index, Name in PinnedServices do
    PinnedRank[Name] = Index
end

local function SortServices(Children)
    local Pinned = {}
    local Others = {}
    for _, Child in Children do
        if PinnedRank[Child.Name] then
            table.insert(Pinned, Child)
        else
            table.insert(Others, Child)
        end
    end

    table.sort(Pinned, function(Left, Right)
        return PinnedRank[Left.Name] < PinnedRank[Right.Name]
    end)

    table.sort(Others, function(Left, Right)
        return Left.Name:lower() < Right.Name:lower()
    end)

    local Sorted = {}
    for _, Child in Pinned do
        table.insert(Sorted, Child)
    end

    for _, Child in Others do
        table.insert(Sorted, Child)
    end

    return Sorted
end

local PropertyGroups = {
    {
        Class = "Instance";
        Properties = {
            "Name";
            "ClassName";
            "Parent";
            "Archivable";
        };
    };

    {
        Class = "BasePart";
        Properties = {
            "Anchored";
            "CanCollide";
            "CanTouch";
            "CanQuery";
            "CastShadow";
            "Locked";
            "Massless";
            "Material";
            "Color";
            "Transparency";
            "Reflectance";
            "Position";
            "Orientation";
            "Size";
            "CFrame";
            "AssemblyLinearVelocity";
            "AssemblyAngularVelocity";
            "CollisionGroup";
            "RootPriority";
        };
    };

    {
        Class = "FormFactorPart";
        Properties = {
            "Shape";
        };
    };

    {
        Class = "Part";
        Properties = {
            "Shape";
        };
    };

    {
        Class = "TrussPart";
        Properties = {
            "Style";
        };
    };

    {
        Class = "MeshPart";
        Properties = {
            "MeshId";
            "TextureID";
            "DoubleSided";
        };
    };

    {
        Class = "UnionOperation";
        Properties = {
            "UsePartColor";
        };
    };

    {
        Class = "Seat";
        Properties = {
            "Disabled";
            "Occupant";
        };
    };

    {
        Class = "VehicleSeat";
        Properties = {
            "HeadsUpDisplay";
            "MaxSpeed";
            "Torque";
            "TurnSpeed";
            "Steer";
            "Throttle";
        };
    };

    {
        Class = "SpawnLocation";
        Properties = {
            "Enabled";
            "Neutral";
            "TeamColor";
            "Duration";
            "AllowTeamChangeOnTouch";
        };
    };

    {
        Class = "Model";
        Properties = {
            "PrimaryPart";
            "WorldPivot";
            "ModelStreamingMode";
        };
    };

    {
        Class = "Workspace";
        Properties = {
            "Gravity";
            "FilteringEnabled";
            "StreamingEnabled";
            "FallenPartsDestroyHeight";
            "AllowThirdPartySales";
        };
    };

    {
        Class = "Lighting";
        Properties = {
            "Ambient";
            "OutdoorAmbient";
            "Brightness";
            "ClockTime";
            "TimeOfDay";
            "GeographicLatitude";
            "FogColor";
            "FogStart";
            "FogEnd";
            "GlobalShadows";
            "ColorShift_Top";
            "ColorShift_Bottom";
            "EnvironmentDiffuseScale";
            "EnvironmentSpecularScale";
            "ExposureCompensation";
            "ShadowSoftness";
            "Technology";
        };
    };

    {
        Class = "Players";
        Properties = {
            "MaxPlayers";
            "PreferredPlayers";
            "NumPlayers";
            "RespawnTime";
            "CharacterAutoLoads";
            "BubbleChat";
            "ClassicChat";
            "LocalPlayer";
        };
    };

    {
        Class = "Player";
        Properties = {
            "Character";
            "UserId";
            "DisplayName";
            "Team";
            "TeamColor";
            "Neutral";
            "AccountAge";
            "MembershipType";
            "FollowUserId";
            "CharacterAppearanceId";
            "AutoJumpEnabled";
            "CanLoadCharacter";
            "CameraMode";
            "CameraMaxZoomDistance";
            "CameraMinZoomDistance";
            "DevCameraOcclusionMode";
            "DevComputerCameraMode";
            "DevComputerMovementMode";
            "DevTouchCameraMode";
            "DevTouchMovementMode";
            "DevEnableMouseLock";
            "HealthDisplayDistance";
            "NameDisplayDistance";
        };
    };

    {
        Class = "Hat";
        Properties = {
            "AttachmentForward";
            "AttachmentPoint";
            "AttachmentPos";
            "AttachmentRight";
            "AttachmentUp";
        };
    };

    {
        Class = "HumanoidDescription";
        Properties = {
            "BackAccessory";
            "BodyTypeScale";
            "ClimbAnimation";
            "DepthScale";
            "Face";
            "FaceAccessory";
            "FallAnimation";
            "FrontAccessory";
            "GraphicTShirt";
            "HairAccessory";
            "HatAccessory";
            "Head";
            "HeadColor";
            "HeadScale";
            "HeightScale";
            "IdleAnimation";
            "JumpAnimation";
            "LeftArm";
            "LeftArmColor";
            "LeftLeg";
            "LeftLegColor";
            "MoodAnimation";
            "NeckAccessory";
            "Pants";
            "ProportionScale";
            "RightArm";
            "RightArmColor";
            "RightLeg";
            "RightLegColor";
            "RunAnimation";
            "Shirt";
            "ShouldersAccessory";
            "SwimAnimation";
            "Torso";
            "TorsoColor";
            "WaistAccessory";
            "WalkAnimation";
            "WidthScale";
        };
    };

    {
        Class = "WrapLayer";
        Properties = {
            "AutoSkin";
            "BindOffset";
            "Color";
            "DebugMode";
            "Enabled";
            "Order";
            "Puffiness";
            "ReferenceMeshId";
            "ReferenceOrigin";
            "ShrinkFactor";
        };
    };

    {
        Class = "WrapTarget";
        Properties = {
            "CageMeshId";
            "CageOrigin";
            "ImportOrigin";
            "Stiffness";
        };
    };

    {
        Class = "SurfaceAppearance";
        Properties = {
            "AlphaMode";
            "ColorMap";
            "MetalnessMap";
            "NormalMap";
            "RoughnessMap";
        };
    };

    {
        Class = "Humanoid";
        Properties = {
            "Health";
            "MaxHealth";
            "WalkSpeed";
            "JumpPower";
            "JumpHeight";
            "HipHeight";
            "AutoRotate";
            "PlatformStand";
            "Sit";
            "Jump";
            "MaxSlopeAngle";
            "AutoJumpEnabled";
            "DisplayName";
            "RigType";
            "HealthDisplayType";
            "HealthDisplayDistance";
            "NameDisplayDistance";
            "DisplayDistanceType";
            "BreakJointsOnDeath";
            "RequiresNeck";
            "UseJumpPower";
            "EvaluateStateMachine";
        };
    };

    {
        Class = "Sound";
        Properties = {
            "SoundId";
            "Volume";
            "Playing";
            "Looped";
            "PlaybackSpeed";
            "TimePosition";
            "MaxDistance";
            "EmitterSize";
            "RollOffMode";
            "PlayOnRemove";
            "TimeLength";
            "IsPaused";
            "IsPlaying";
            "IsLoaded";
        };
    };

    {
        Class = "SoundGroup";
        Properties = {
            "Volume";
        };
    };

    {
        Class = "EqualizerSoundEffect";
        Properties = {
            "Enabled";
            "HighGain";
            "LowGain";
            "MidGain";
            "Priority";
        };
    };

    {
        Class = "ReverbSoundEffect";
        Properties = {
            "DecayTime";
            "Density";
            "Diffusion";
            "DryLevel";
            "Enabled";
            "Priority";
            "WetLevel";
        };
    };

    {
        Class = "ChorusSoundEffect";
        Properties = {
            "Depth";
            "Enabled";
            "Mix";
            "Priority";
            "Rate";
        };
    };

    {
        Class = "CompressorSoundEffect";
        Properties = {
            "Attack";
            "Enabled";
            "GainMakeup";
            "Priority";
            "Ratio";
            "Release";
            "SideChain";
            "Threshold";
        };
    };

    {
        Class = "DistortionSoundEffect";
        Properties = {
            "Enabled";
            "Level";
            "Priority";
        };
    };

    {
        Class = "EchoSoundEffect";
        Properties = {
            "Delay";
            "DryLevel";
            "Enabled";
            "Feedback";
            "Priority";
            "WetLevel";
        };
    };

    {
        Class = "FlangeSoundEffect";
        Properties = {
            "Depth";
            "Enabled";
            "Mix";
            "Priority";
            "Rate";
        };
    };

    {
        Class = "PitchShiftSoundEffect";
        Properties = {
            "Enabled";
            "Octave";
            "Priority";
        };
    };

    {
        Class = "TremoloSoundEffect";
        Properties = {
            "Depth";
            "Duty";
            "Enabled";
            "Frequency";
            "Priority";
        };
    };

    {
        Class = "Tool";
        Properties = {
            "Grip";
            "GripForward";
            "GripPos";
            "GripRight";
            "GripUp";
            "RequiresHandle";
            "CanBeDropped";
            "ToolTip";
            "TextureId";
            "Enabled";
            "ManualActivationOnly";
        };
    };

    {
        Class = "LayerCollector";
        Properties = {
            "Enabled";
            "ResetOnSpawn";
            "ZIndexBehavior";
        };
    };

    {
        Class = "GuiBase2d";
        Properties = {
            "AbsolutePosition";
            "AbsoluteRotation";
            "AbsoluteSize";
        };
    };

    {
        Class = "GuiButton";
        Properties = {
            "AutoButtonColor";
            "Modal";
            "Selected";
            "Style";
        };
    };

    {
        Class = "ViewportFrame";
        Properties = {
            "Ambient";
            "CurrentCamera";
            "ImageColor3";
            "ImageTransparency";
            "LightColor";
            "LightDirection";
        };
    };

    {
        Class = "CanvasGroup";
        Properties = {
            "GroupColor3";
            "GroupTransparency";
        };
    };

    {
        Class = "VideoFrame";
        Properties = {
            "Video";
            "Volume";
            "Playing";
            "Looped";
            "PlaybackSpeed";
            "TimePosition";
            "Resolution";
            "IsLoaded";
        };
    };

    {
        Class = "UIPageLayout";
        Properties = {
            "Animated";
            "Circular";
            "CurrentPage";
            "EasingDirection";
            "EasingStyle";
            "GamepadInputEnabled";
            "Padding";
            "ScrollWheelInputEnabled";
            "TouchInputEnabled";
            "TweenTime";
        };
    };

    {
        Class = "UITableLayout";
        Properties = {
            "FillEmptySpaceColumns";
            "FillEmptySpaceRows";
            "MajorAxis";
            "Padding";
        };
    };

    {
        Class = "UITextSizeConstraint";
        Properties = {
            "MaxTextSize";
            "MinTextSize";
        };
    };

    {
        Class = "UIFlexItem";
        Properties = {
            "FlexMode";
            "GrowRatio";
            "ItemLineAlignment";
            "ShrinkRatio";
        };
    };

    {
        Class = "RemoteEvent";
        Properties = {};
    };

    {
        Class = "RemoteFunction";
        Properties = {};
    };

    {
        Class = "UnreliableRemoteEvent";
        Properties = {};
    };

    {
        Class = "BindableEvent";
        Properties = {};
    };

    {
        Class = "BindableFunction";
        Properties = {};
    };

    {
        Class = "BallSocketConstraint";
        Properties = {
            "LimitsEnabled";
            "MaxFrictionTorque";
            "Radius";
            "Restitution";
            "TwistLimitsEnabled";
            "TwistLowerAngle";
            "TwistUpperAngle";
            "UpperAngle";
        };
    };

    {
        Class = "PrismaticConstraint";
        Properties = {
            "ActuatorType";
            "LimitsEnabled";
            "LowerLimit";
            "UpperLimit";
            "Restitution";
            "ServoMaxForce";
            "Speed";
            "TargetPosition";
            "Velocity";
        };
    };

    {
        Class = "CylindricalConstraint";
        Properties = {
            "ActuatorType";
            "AngularActuatorType";
            "AngularLimitsEnabled";
            "AngularRestitution";
            "AngularSpeed";
            "AngularVelocity";
            "InclinationAngle";
            "LimitsEnabled";
            "LowerAngle";
            "LowerLimit";
            "MotorMaxAngularAcceleration";
            "MotorMaxForce";
            "Restitution";
            "ServoMaxForce";
            "TargetAngle";
            "TargetPosition";
            "UpperAngle";
            "UpperLimit";
        };
    };

    {
        Class = "PlaneConstraint";
        Properties = {};
    };

    {
        Class = "NoCollisionConstraint";
        Properties = {
            "Part0";
            "Part1";
            "Enabled";
        };
    };

    {
        Class = "PathfindingModifier";
        Properties = {
            "Label";
            "PassThrough";
        };
    };

    {
        Class = "PathfindingLink";
        Properties = {
            "Attachment0";
            "Attachment1";
            "IsBidirectional";
            "Label";
        };
    };

    {
        Class = "Dialog";
        Properties = {
            "BehaviorType";
            "ConversationDistance";
            "GoodbyeChoiceActive";
            "GoodbyeDialog";
            "InUse";
            "InitialPrompt";
            "Purpose";
            "Tone";
            "TriggerDistance";
            "TriggerOffset";
        };
    };

    {
        Class = "DialogChoice";
        Properties = {
            "GoodbyeChoiceActive";
            "GoodbyeDialog";
            "ResponseDialog";
            "UserDialog";
        };
    };

    {
        Class = "ForceField";
        Properties = {
            "Visible";
        };
    };

    {
        Class = "Decal";
        Properties = {
            "Texture";
            "Color3";
            "Transparency";
            "Face";
            "ZIndex";
        };
    };

    {
        Class = "Texture";
        Properties = {
            "Texture";
            "Color3";
            "Transparency";
            "Face";
            "StudsPerTileU";
            "StudsPerTileV";
            "OffsetStudsU";
            "OffsetStudsV";
        };
    };

    {
        Class = "Animation";
        Properties = {
            "AnimationId";
        };
    };

    {
        Class = "Animator";
        Properties = {
            "RootMotion";
            "RootMotionWeight";
            "EvaluationThrottled";
        };
    };

    {
        Class = "AnimationController";
        Properties = {};
    };

    {
        Class = "AnimationTrack";
        Properties = {
            "Animation";
            "Length";
            "TimePosition";
            "Speed";
            "Looped";
            "Priority";
            "IsPlaying";
            "WeightCurrent";
            "WeightTarget";
        };
    };

    {
        Class = "KeyframeSequence";
        Properties = {
            "Loop";
            "Priority";
            "AuthoredHipHeight";
        };
    };

    {
        Class = "Keyframe";
        Properties = {
            "Time";
        };
    };

    {
        Class = "Pose";
        Properties = {
            "CFrame";
            "EasingDirection";
            "EasingStyle";
            "Weight";
        };
    };

    {
        Class = "Camera";
        Properties = {
            "CFrame";
            "Focus";
            "FieldOfView";
            "CameraType";
            "CameraSubject";
            "HeadLocked";
            "HeadScale";
        };
    };

    {
        Class = "Attachment";
        Properties = {
            "CFrame";
            "Position";
            "Orientation";
            "Visible";
            "WorldCFrame";
            "WorldPosition";
        };
    };

    {
        Class = "ScreenGui";
        Properties = {
            "Enabled";
            "ResetOnSpawn";
            "IgnoreGuiInset";
            "ZIndexBehavior";
            "DisplayOrder";
        };
    };

    {
        Class = "GuiObject";
        Properties = {
            "Active";
            "Visible";
            "BackgroundColor3";
            "BackgroundTransparency";
            "BorderColor3";
            "BorderSizePixel";
            "Position";
            "Size";
            "AnchorPoint";
            "Rotation";
            "ZIndex";
            "ClipsDescendants";
            "LayoutOrder";
        };
    };

    {
        Class = "TextLabel";
        Properties = {
            "Text";
            "TextColor3";
            "Font";
            "TextSize";
            "TextScaled";
            "TextWrapped";
            "TextXAlignment";
            "TextYAlignment";
            "RichText";
            "TextStrokeColor3";
            "TextStrokeTransparency";
        };
    };

    {
        Class = "TextButton";
        Properties = {
            "Text";
            "TextColor3";
            "Font";
            "TextSize";
            "TextScaled";
            "TextWrapped";
            "TextXAlignment";
            "TextYAlignment";
            "AutoButtonColor";
            "Modal";
            "RichText";
        };
    };

    {
        Class = "TextBox";
        Properties = {
            "Text";
            "TextColor3";
            "Font";
            "TextSize";
            "PlaceholderText";
            "PlaceholderColor3";
            "ClearTextOnFocus";
            "MultiLine";
            "TextEditable";
        };
    };

    {
        Class = "ImageLabel";
        Properties = {
            "Image";
            "ImageColor3";
            "ImageTransparency";
            "ScaleType";
            "ImageRectOffset";
            "ImageRectSize";
            "ResampleMode";
        };
    };

    {
        Class = "ImageButton";
        Properties = {
            "Image";
            "ImageColor3";
            "ImageTransparency";
            "ScaleType";
            "ImageRectOffset";
            "ImageRectSize";
            "AutoButtonColor";
            "Modal";
        };
    };

    {
        Class = "ValueBase";
        Properties = {
            "Value";
        };
    };

    {
        Class = "ParticleEmitter";
        Properties = {
            "Enabled";
            "Rate";
            "Lifetime";
            "Speed";
            "Size";
            "Texture";
            "Transparency";
            "ZOffset";
            "Rotation";
            "RotSpeed";
            "SpreadAngle";
            "Acceleration";
            "Drag";
            "EmissionDirection";
            "LightEmission";
            "LightInfluence";
            "VelocityInheritance";
            "TimeScale";
        };
    };

    {
        Class = "Light";
        Properties = {
            "Brightness";
            "Color";
            "Enabled";
            "Shadows";
        };
    };

    {
        Class = "PointLight";
        Properties = {
            "Range";
        };
    };

    {
        Class = "SpotLight";
        Properties = {
            "Range";
            "Angle";
            "Face";
        };
    };

    {
        Class = "SurfaceLight";
        Properties = {
            "Range";
            "Angle";
            "Face";
        };
    };

    {
        Class = "BodyVelocity";
        Properties = {
            "Velocity";
            "MaxForce";
            "P";
        };
    };

    {
        Class = "BodyPosition";
        Properties = {
            "Position";
            "MaxForce";
            "P";
            "D";
        };
    };

    {
        Class = "BodyGyro";
        Properties = {
            "CFrame";
            "MaxTorque";
            "P";
            "D";
        };
    };

    {
        Class = "BodyAngularVelocity";
        Properties = {
            "AngularVelocity";
            "MaxTorque";
            "P";
        };
    };

    {
        Class = "ClickDetector";
        Properties = {
            "MaxActivationDistance";
            "CursorIcon";
        };
    };

    {
        Class = "ProximityPrompt";
        Properties = {
            "ActionText";
            "ObjectText";
            "HoldDuration";
            "MaxActivationDistance";
            "RequiresLineOfSight";
            "Enabled";
            "KeyboardKeyCode";
        };
    };

    {
        Class = "Highlight";
        Properties = {
            "Adornee";
            "Enabled";
            "FillColor";
            "FillTransparency";
            "OutlineColor";
            "OutlineTransparency";
            "DepthMode";
        };
    };

    {
        Class = "Beam";
        Properties = {
            "Attachment0";
            "Attachment1";
            "Enabled";
            "Color";
            "Texture";
            "TextureLength";
            "TextureSpeed";
            "TextureMode";
            "Transparency";
            "Width0";
            "Width1";
            "Segments";
            "FaceCamera";
            "LightEmission";
            "LightInfluence";
            "CurveSize0";
            "CurveSize1";
            "ZOffset";
        };
    };

    {
        Class = "Trail";
        Properties = {
            "Attachment0";
            "Attachment1";
            "Enabled";
            "Color";
            "Texture";
            "TextureLength";
            "TextureMode";
            "Transparency";
            "Lifetime";
            "MinLength";
            "MaxLength";
            "FaceCamera";
            "LightEmission";
            "LightInfluence";
            "WidthScale";
        };
    };

    {
        Class = "Fire";
        Properties = {
            "Enabled";
            "Heat";
            "Size";
            "Color";
            "SecondaryColor";
        };
    };

    {
        Class = "Smoke";
        Properties = {
            "Enabled";
            "Color";
            "Opacity";
            "RiseVelocity";
            "Size";
            "TimeScale";
        };
    };

    {
        Class = "Sparkles";
        Properties = {
            "Enabled";
            "SparkleColor";
            "TimeScale";
        };
    };

    {
        Class = "Explosion";
        Properties = {
            "BlastPressure";
            "BlastRadius";
            "DestroyJointRadius";
            "ExplosionType";
            "Position";
            "TimeScale";
            "Visible";
        };
    };

    {
        Class = "Atmosphere";
        Properties = {
            "Density";
            "Offset";
            "Color";
            "Decay";
            "Glare";
            "Haze";
        };
    };

    {
        Class = "Sky";
        Properties = {
            "SkyboxBk";
            "SkyboxDn";
            "SkyboxFt";
            "SkyboxLf";
            "SkyboxRt";
            "SkyboxUp";
            "StarCount";
            "SunAngularSize";
            "MoonAngularSize";
            "SunTextureId";
            "MoonTextureId";
            "CelestialBodiesShown";
        };
    };

    {
        Class = "Clouds";
        Properties = {
            "Cover";
            "Density";
            "Color";
            "Enabled";
        };
    };

    {
        Class = "BloomEffect";
        Properties = {
            "Enabled";
            "Intensity";
            "Size";
            "Threshold";
        };
    };

    {
        Class = "BlurEffect";
        Properties = {
            "Enabled";
            "Size";
        };
    };

    {
        Class = "DepthOfFieldEffect";
        Properties = {
            "Enabled";
            "FarIntensity";
            "FocusDistance";
            "InFocusRadius";
            "NearIntensity";
        };
    };

    {
        Class = "SunRaysEffect";
        Properties = {
            "Enabled";
            "Intensity";
            "Spread";
        };
    };

    {
        Class = "BillboardGui";
        Properties = {
            "Adornee";
            "AlwaysOnTop";
            "Enabled";
            "LightInfluence";
            "MaxDistance";
            "Size";
            "SizeOffset";
            "StudsOffset";
            "StudsOffsetWorldSpace";
            "ExtentsOffset";
            "ExtentsOffsetWorldSpace";
            "PlayerToHideFrom";
            "DistanceLowerLimit";
            "DistanceUpperLimit";
            "DistanceStep";
        };
    };

    {
        Class = "SurfaceGui";
        Properties = {
            "Adornee";
            "Enabled";
            "Active";
            "AlwaysOnTop";
            "Brightness";
            "ClipsDescendants";
            "Face";
            "LightInfluence";
            "PixelsPerStud";
            "SizingMode";
            "ToolPunchThroughDistance";
            "ZOffset";
        };
    };

    {
        Class = "Frame";
        Properties = {
            "Style";
        };
    };

    {
        Class = "ScrollingFrame";
        Properties = {
            "AutomaticCanvasSize";
            "CanvasPosition";
            "CanvasSize";
            "ScrollBarImageColor3";
            "ScrollBarImageTransparency";
            "ScrollBarThickness";
            "ScrollingDirection";
            "ScrollingEnabled";
            "VerticalScrollBarInset";
            "HorizontalScrollBarInset";
            "BottomImage";
            "MidImage";
            "TopImage";
            "ElasticBehavior";
            "VerticalScrollBarPosition";
        };
    };

    {
        Class = "VideoFrame";
        Properties = {
            "Video";
            "Volume";
            "Playing";
            "Looped";
            "PlaybackSpeed";
            "TimePosition";
            "Resolution";
        };
    };

    {
        Class = "UICorner";
        Properties = {
            "CornerRadius";
        };
    };

    {
        Class = "UIStroke";
        Properties = {
            "ApplyStrokeMode";
            "Color";
            "LineJoinMode";
            "Thickness";
            "Transparency";
            "Enabled";
        };
    };

    {
        Class = "UIPadding";
        Properties = {
            "PaddingBottom";
            "PaddingLeft";
            "PaddingRight";
            "PaddingTop";
        };
    };

    {
        Class = "UIListLayout";
        Properties = {
            "FillDirection";
            "HorizontalAlignment";
            "VerticalAlignment";
            "Padding";
            "SortOrder";
            "Wraps";
            "ItemLineAlignment";
        };
    };

    {
        Class = "UIGridLayout";
        Properties = {
            "CellPadding";
            "CellSize";
            "FillDirection";
            "FillDirectionMaxCells";
            "HorizontalAlignment";
            "VerticalAlignment";
            "SortOrder";
            "StartCorner";
        };
    };

    {
        Class = "UIScale";
        Properties = {
            "Scale";
        };
    };

    {
        Class = "UIAspectRatioConstraint";
        Properties = {
            "AspectRatio";
            "AspectType";
            "DominantAxis";
        };
    };

    {
        Class = "UIGradient";
        Properties = {
            "Color";
            "Enabled";
            "Offset";
            "Rotation";
            "Transparency";
        };
    };

    {
        Class = "UISizeConstraint";
        Properties = {
            "MaxSize";
            "MinSize";
        };
    };

    {
        Class = "Constraint";
        Properties = {
            "Attachment0";
            "Attachment1";
            "Color";
            "Enabled";
            "Visible";
        };
    };

    {
        Class = "HingeConstraint";
        Properties = {
            "ActuatorType";
            "AngularSpeed";
            "AngularVelocity";
            "TargetAngle";
            "LimitsEnabled";
            "LowerAngle";
            "UpperAngle";
            "Restitution";
            "ServoMaxTorque";
            "MotorMaxTorque";
            "MotorMaxAcceleration";
            "AngularResponsiveness";
            "CurrentAngle";
        };
    };

    {
        Class = "SpringConstraint";
        Properties = {
            "Stiffness";
            "Damping";
            "FreeLength";
            "MaxForce";
            "MaxLength";
            "MinLength";
            "LimitsEnabled";
            "Coils";
            "Radius";
            "Thickness";
        };
    };

    {
        Class = "RopeConstraint";
        Properties = {
            "Length";
            "Restitution";
            "Thickness";
            "WinchEnabled";
            "WinchForce";
            "WinchResponsiveness";
            "WinchSpeed";
            "WinchTarget";
        };
    };

    {
        Class = "RodConstraint";
        Properties = {
            "Length";
            "Thickness";
            "LimitsEnabled";
            "LimitAngle0";
            "LimitAngle1";
        };
    };

    {
        Class = "AlignPosition";
        Properties = {
            "Attachment0";
            "Attachment1";
            "Mode";
            "ApplyAtCenterOfMass";
            "MaxForce";
            "MaxVelocity";
            "Position";
            "Responsiveness";
            "RigidityEnabled";
            "ReactionForceEnabled";
        };
    };

    {
        Class = "AlignOrientation";
        Properties = {
            "Attachment0";
            "Attachment1";
            "Mode";
            "AlignType";
            "CFrame";
            "MaxAngularVelocity";
            "MaxTorque";
            "Responsiveness";
            "PrimaryAxisOnly";
            "ReactionTorqueEnabled";
            "RigidityEnabled";
        };
    };

    {
        Class = "VectorForce";
        Properties = {
            "Attachment0";
            "Attachment1";
            "ApplyAtCenterOfMass";
            "Force";
            "RelativeTo";
        };
    };

    {
        Class = "Weld";
        Properties = {
            "Part0";
            "Part1";
            "C0";
            "C1";
        };
    };

    {
        Class = "WeldConstraint";
        Properties = {
            "Part0";
            "Part1";
            "Enabled";
        };
    };

    {
        Class = "Motor6D";
        Properties = {
            "Part0";
            "Part1";
            "C0";
            "C1";
            "Transform";
            "DesiredAngle";
            "CurrentAngle";
            "MaxVelocity";
        };
    };

    {
        Class = "Terrain";
        Properties = {
            "WaterColor";
            "WaterReflectance";
            "WaterTransparency";
            "WaterWaveSize";
            "WaterWaveSpeed";
            "Decoration";
            "MaterialColors";
            "MaxExtents";
        };
    };

    {
        Class = "Team";
        Properties = {
            "AutoAssignable";
            "TeamColor";
            "Score";
        };
    };

    {
        Class = "Accessory";
        Properties = {
            "AccessoryType";
            "AttachmentForward";
            "AttachmentPoint";
            "AttachmentPos";
            "AttachmentRight";
            "AttachmentUp";
        };
    };

    {
        Class = "Shirt";
        Properties = {
            "ShirtTemplate";
        };
    };

    {
        Class = "Pants";
        Properties = {
            "PantsTemplate";
        };
    };

    {
        Class = "ShirtGraphic";
        Properties = {
            "Graphic";
            "Color3";
        };
    };

    {
        Class = "BodyColors";
        Properties = {
            "HeadColor3";
            "TorsoColor3";
            "LeftArmColor3";
            "RightArmColor3";
            "LeftLegColor3";
            "RightLegColor3";
        };
    };

    {
        Class = "SpecialMesh";
        Properties = {
            "MeshType";
            "MeshId";
            "TextureId";
            "Scale";
            "Offset";
            "VertexColor";
        };
    };

    {
        Class = "BlockMesh";
        Properties = {
            "Scale";
            "Offset";
        };
    };

    {
        Class = "CylinderMesh";
        Properties = {
            "Scale";
            "Offset";
        };
    };

    {
        Class = "FileMesh";
        Properties = {
            "MeshId";
            "TextureId";
            "Scale";
            "Offset";
        };
    };

    {
        Class = "LuaSourceContainer";
        Properties = {
            "Source";
            "LinkedSource";
        };
    };

    {
        Class = "Script";
        Properties = {
            "Disabled";
            "RunContext";
        };
    };

    {
        Class = "LocalScript";
        Properties = {
            "Disabled";
        };
    };

    {
        Class = "ModuleScript";
        Properties = {};
    };

    {
        Class = "ReplicatedStorage";
        Properties = {};
    };

    {
        Class = "ReplicatedFirst";
        Properties = {};
    };

    {
        Class = "ServerStorage";
        Properties = {};
    };

    {
        Class = "ServerScriptService";
        Properties = {};
    };

    {
        Class = "StarterGui";
        Properties = {
            "ResetPlayerGuiOnSpawn";
            "ScreenOrientation";
        };
    };

    {
        Class = "StarterPack";
        Properties = {};
    };

    {
        Class = "StarterPlayer";
        Properties = {
            "AllowCustomAnimations";
            "AutoJumpEnabled";
            "CameraMaxZoomDistance";
            "CameraMinZoomDistance";
            "CameraMode";
            "CharacterJumpHeight";
            "CharacterJumpPower";
            "CharacterMaxSlopeAngle";
            "CharacterUseJumpPower";
            "CharacterWalkSpeed";
            "DevCameraOcclusionMode";
            "DevComputerCameraMovementMode";
            "DevComputerMovementMode";
            "DevTouchCameraMovementMode";
            "DevTouchMovementMode";
            "EnableMouseLockOption";
            "HealthDisplayDistance";
            "LoadCharacterAppearance";
            "NameDisplayDistance";
        };
    };

    {
        Class = "Teams";
        Properties = {};
    };

    {
        Class = "SoundService";
        Properties = {
            "AmbientReverb";
            "DistanceFactor";
            "DopplerScale";
            "RolloffScale";
            "RespectFilteringEnabled";
        };
    };

    {
        Class = "CollectionService";
        Properties = {};
    };

    {
        Class = "TweenService";
        Properties = {};
    };

    {
        Class = "TextChatService";
        Properties = {
            "ChatVersion";
            "CreateDefaultCommands";
            "CreateDefaultTextChannels";
        };
    };

    {
        Class = "Folder";
        Properties = {};
    };

    {
        Class = "Configuration";
        Properties = {};
    };

    {
        Class = "PackageLink";
        Properties = {
            "PackageId";
            "VersionNumber";
            "AutoUpdate";
        };
    };

    {
        Class = "CornerWedgePart";
        Properties = {};
    };

    {
        Class = "WedgePart";
        Properties = {};
    };

    {
        Class = "FlagStand";
        Properties = {
            "TeamColor";
        };
    };

    {
        Class = "SkateboardPlatform";
        Properties = {
            "Steer";
            "Throttle";
        };
    };
}

CollectProperties = function(Object)
    local Ordered = {}
    local Seen = {}
    for _, Group in PropertyGroups do
        local IsAClass = SafeGet(Object, "ClassName") ~= nil
        local Matches = false
        if IsAClass then
            local Good, Result = pcall(function()
                return Object:IsA(Group.Class)
            end)

            Matches = Good and Result
        end

        if Matches then
            for _, PropertyName in Group.Properties do
                if not Seen[PropertyName] then
                    Seen[PropertyName] = true
                    table.insert(Ordered, PropertyName)
                end
            end
        end
    end

    return Ordered
end

local function CollectAttributes(Object)
    local Items = {}
    local Good, Map = pcall(function()
        return Object:GetAttributes()
    end)

    if not Good or type(Map) ~= "table" then
        return Items
    end

    for Name, Value in Map do
        table.insert(Items, {Name = Name; Value = Value})
    end

    table.sort(Items, function(Left, Right)
        return Left.Name:lower() < Right.Name:lower()
    end)

    return Items
end

local function CollectTags(Object)
    local Good, Tags = pcall(function()
        return Services.CollectionService:GetTags(Object)
    end)

    if not Good or type(Tags) ~= "table" then
        return {}
    end

    table.sort(Tags, function(Left, Right)
        return tostring(Left):lower() < tostring(Right):lower()
    end)

    return Tags
end

local function ResolveSelfForGlobal(Object, Method)
    if Method.SelfFrom == "Parent" then
        local Good, Parent = pcall(function() return Object.Parent end)
        if Good and typeof(Parent) == "Instance" then
            return Parent
        end
    end
    return Object
end

local function GetGlobalCallable(Name)
    local Env
    pcall(function() Env = getgenv and getgenv() end)

    if Env then
        local Good, Fn = pcall(function() return Env[Name] end)
        if Good and type(Fn) == "function" then
            return Fn
        end
    end

    local Good, Fn = pcall(function() return _G[Name] end)
    if Good and type(Fn) == "function" then
        return Fn
    end

    return nil
end

local function GetLocalCharacterRootPart()
    local Players = Services.Players or game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer and LocalPlayer.Character

    if not Character then
        return nil
    end

    return Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("Torso")
        or Character:FindFirstChild("UpperTorso")
        or Character:FindFirstChildWhichIsA("BasePart")
end

local SynSaveInstance
local SynSaveInstanceErr
local SynSaveInstanceTried = false
local function LoadSynSaveInstance()
    if SynSaveInstance then return SynSaveInstance end
    if SynSaveInstanceTried then return nil, SynSaveInstanceErr end
    SynSaveInstanceTried = true

    local Params = {
        RepoURL = "https://raw.githubusercontent.com/luau/UniversalSynSaveInstance/main/";
        SSI = "saveinstance";
    }

    local GoodHttp, Source = pcall(function()
        return game:HttpGet(Params.RepoURL .. Params.SSI .. ".luau", true)
    end)
    if not GoodHttp or type(Source) ~= "string" or Source == "" then
        SynSaveInstanceErr = `HttpGet failed: {tostring(Source)}`
        return nil, SynSaveInstanceErr
    end

    local Chunk, ParseErr = loadstring(Source, Params.SSI)
    if not Chunk then
        SynSaveInstanceErr = `loadstring failed: {tostring(ParseErr)}`
        return nil, SynSaveInstanceErr
    end

    local GoodRun, Result = pcall(Chunk)
    if not GoodRun or type(Result) ~= "function" then
        SynSaveInstanceErr = `module returned non-function: {tostring(Result)}`
        return nil, SynSaveInstanceErr
    end

    SynSaveInstance = Result
    return SynSaveInstance
end

local MethodGroups = {
    {
        Class = "Instance";
        Methods = {
            {
                "ClearAllChildren";
                "void";
                {};
            };
            {
                "Clone";
                "Instance";
                {};
            };
            {
                "Destroy";
                "void";
                {};
            };
            {
                "GetChildren";
                "table";
                {};
            };
            {
                "GetDescendants";
                "table";
                {};
            };
            {
                "GetFullName";
                "string";
                {};
            };
            {
                "getconnections"; "table";
                {
                    { "signal"; "RBXScriptSignal"; "MouseButton1Click"; };
                };
                "global";
                NoSelf = true;
            };

            {
                "firesignal"; "void";
                {
                    { "signal"; "RBXScriptSignal"; "MouseButton1Click"; };
                    { "args"; "Variadic"; ""; };
                };
                "global";
                NoSelf = true;
            };
            {
                "replicatesignal"; "void"; { { "signal"; "RBXScriptSignal"; "MouseButton1Click"; }; { "args"; "Variadic"; "" ; }; }; "global"; NoSelf = true;
            };
            {
                "getproperties"; "table"; {}; "global"; NoSelf = false;
            };
            {
                "gethiddenproperties"; "table"; {}; "global";
            };
            {
                "gethiddenproperty"; "any"; { { "name"; "string"; }; }; "global";
            };
            {
                "sethiddenproperty"; "void"; { { "name"; "string"; }; { "value"; "any"; }; }; "global";
            };
            {
                "getcallbackvalue"; "function"; { { "name"; "string"; }; }; "global";
            };
            {
                "synsaveinstance";
                "void";
                {
                    { "FilePath"; "string"; "vex_dump.rbxm"; };
                    { "Mode"; "string";  "optimized"; };
                    { "SafeMode"; "boolean"; "true"; };
                    { "KillAllScripts"; "boolean"; "true"; };
                    { "Decompile"; "boolean"; "true"; };
                    { "DecompileTimeout"; "number";  "15"; };
                    { "SaveBytecode"; "boolean"; "false"; };
                    { "scriptcache"; "boolean"; "true"; };
                    { "NilInstances"; "boolean"; "false"; };
                    { "IgnoreDefaultProperties"; "boolean"; "true"; };
                    { "IgnoreNotArchivable"; "boolean"; "true"; };
                    { "AlternativeWritefile"; "boolean"; "true"; };
                    { "IgnoreSharedStrings"; "boolean"; "true"; };
                    { "BoostFPS"; "boolean"; "false"; };
                    { "ShutdownWhenDone"; "boolean"; "false"; };
                    { "AntiIdle"; "boolean"; "true"; };
                    { "IsModel"; "boolean"; "false"; };
                    { "SavePlayerCharacters"; "boolean"; "false"; };
                    { "IsolatePlayers"; "boolean"; "false"; };
                    { "IsolateLocalPlayer"; "boolean"; "false"; };
                };
                "global";
                BuildOptions = true;
                Resolve = function()
                    return LoadSynSaveInstance()
                end;
                PostBuild = function(Options, Object)
                    if typeof(Object) == "Instance" and Object ~= game then
                        Options.Object = Object
                        if Options.Mode == "optimized" then
                            Options.Mode = "full"
                        end

                        if Options.IsModel == nil then
                            Options.IsModel = true
                        end
                    end

                    return Options
                end;
            };
        };
    };

    {
        Class = "Model";
        Methods = {
            {
                "BreakJoints";
                "void";
                {};
            };
            {
                "GetExtentsSize";
                "Vector3";
                {};
            };
            {
                "GetPrimaryPartCFrame";
                "CFrame";
                {};
            };
            {
                "MakeJoints";
                "void";
                {};
            };
            {
                "MoveTo";
                "void";
                {
                    {
                        "position";
                        "Vector3";
                    };
                };
            };
            {
                "SetPrimaryPartCFrame";
                "void";
                {
                    {
                        "cframe";
                        "CFrame";
                    };
                };
            };
            {
                "TranslateBy";
                "void";
                {
                    {
                        "delta";
                        "Vector3";
                    };
                };
            };
            { "PivotTo"; "void"; { { "cframe"; "CFrame"; }; }; };
            { "GetPivot"; "CFrame"; {}; };
            { "GetBoundingBox"; "CFrame"; {}; };
            { "ScaleTo"; "void"; { { "scale"; "number"; "1"; }; }; };
            { "GetScale"; "number"; {}; };
        };
    };

    {
        Class = "BasePart";
        Methods = {
            {
                "BreakJoints";
                "void";
                {};
            };
            {
                "MakeJoints";
                "void";
                {};
            };
            {
                "GetMass";
                "number";
                {};
            };
            {
                "GetVelocityAtPosition";
                "Vector3";
                {
                    {
                        "position";
                        "Vector3";
                    };
                };
            };
            {
                "ApplyImpulse";
                "void";
                {
                    {
                        "impulse";
                        "Vector3";
                    };
                };
            };
            {
                "ApplyAngularImpulse";
                "void";
                {
                    {
                        "impulse";
                        "Vector3";
                    };
                };
            };
        };
    };

    {
        Class = "Humanoid";
        Methods = {
            {
                "TakeDamage";
                "void";
                {
                    {
                        "amount";
                        "number";
                        "10";
                    };
                };
            };
            {
                "Move";
                "void";
                {
                    {
                        "moveDirection";
                        "Vector3";
                    };
                    {
                        "relativeToCamera";
                        "boolean";
                        "false";
                    };
                };
            };
            {
                "MoveTo";
                "void";
                {
                    {
                        "location";
                        "Vector3";
                    };
                    {
                        "part";
                        "BasePart";
                    };
                };
            };
            {
                "Jump";
                "void";
                {};
            };
            {
                "ChangeState";
                "void";
                {
                    {
                        "state";
                        "string";
                        "GettingUp";
                    };
                };
            };
            {
                "GetState";
                "EnumItem";
                {};
            };
            {
                "SetStateEnabled";
                "void";
                {
                    {
                        "state";
                        "string";
                        "Dead";
                    };
                    {
                        "enabled";
                        "boolean";
                        "true";
                    };
                };
            };
            {
                "GetStateEnabled";
                "boolean";
                {
                    {
                        "state";
                        "string";
                        "Dead";
                    };
                };
            };
            {
                "EquipTool";
                "void";
                {
                    {
                        "tool";
                        "Instance";
                    };
                };
            };
            {
                "UnequipTools";
                "void";
                {};
            };
            {
                "AddAccessory";
                "void";
                {
                    {
                        "accessory";
                        "Instance";
                    };
                };
            };
            {
                "RemoveAccessories";
                "void";
                {};
            };
            {
                "GetAccessories";
                "table";
                {};
            };
            {
                "GetAccessoryHandleAttachmentPoint";
                "CFrame";
                {
                    {
                        "accessory";
                        "Instance";
                    };
                    {
                        "attachmentName";
                        "string";
                        "HatAttachment";
                    };
                };
            };
            {
                "ReplaceBodyPartR15";
                "boolean";
                {
                    {
                        "bodyPart";
                        "string";
                        "Head";
                    };
                    {
                        "part";
                        "BasePart";
                    };
                };
            };
            {
                "GetBodyPartR15";
                "EnumItem";
                {
                    {
                        "part";
                        "BasePart";
                    };
                };
            };
            {
                "GetLimb";
                "EnumItem";
                {
                    {
                        "part";
                        "BasePart";
                    };
                };
            };
            {
                "BuildRigFromAttachments";
                "void";
                {};
            };
            {
                "GetPlayingAnimationTracks";
                "table";
                {};
            };
            {
                "LoadAnimation";
                "AnimationTrack";
                {
                    {
                        "animation";
                        "Animation";
                    };
                };
            };
            {
                "GetMoveVelocity";
                "Vector3";
                {};
            };
            {
                "GetAppliedDescription";
                "Instance";
                {};
            };
            {
                "ApplyDescription";
                "void";
                {
                    {
                        "humanoidDescription";
                        "Instance";
                    };
                };
            };
            {
                "ApplyDescriptionReset";
                "void";
                {
                    {
                        "humanoidDescription";
                        "Instance";
                    };
                };
            };
            {
                "PlayEmote";
                "boolean";
                {
                    {
                        "emoteName";
                        "string";
                        "wave";
                    };
                };
            };
            {
                "PlayEmoteAndGetAnimTrackById";
                "AnimationTrack";
                {
                    {
                        "emoteId";
                        "number";
                        "0";
                    };
                };
            };
        };
    };
    
    {
        Class = "Player";
        Methods = {
            {
                "Kick";
                "void";
                {
                    {
                        "message";
                        "string";
                        "''";
                    };
                };
            };
            {
                "LoadCharacter";
                "void";
                {};
            };
            {
                "LoadCharacterBlocking";
                "void";
                {};
            };
            {
                "LoadCharacterWithHumanoidDescription";
                "void";
                {
                    {
                        "humanoidDescription";
                        "Instance";
                    };
                };
            };
            {
                "GetMouse";
                "Mouse";
                {};
            };
            {
                "IsInGroup";
                "boolean";
                {
                    {
                        "groupId";
                        "number";
                        "0";
                    };
                };
            };
            {
                "GetRankInGroup";
                "number";
                {
                    {
                        "groupId";
                        "number";
                        "0";
                    };
                };
            };
            {
                "GetRoleInGroup";
                "string";
                {
                    {
                        "groupId";
                        "number";
                        "0";
                    };
                };
            };
            {
                "IsFriendsWith";
                "boolean";
                {
                    {
                        "userId";
                        "number";
                        "0";
                    };
                };
            };
            {
                "GetFriendsOnline";
                "table";
                {
                    {
                        "maxFriends";
                        "number";
                        "200";
                    };
                };
            };
            {
                "GetNetworkPing";
                "number";
                {};
            };
            {
                "DistanceFromCharacter";
                "number";
                {
                    {
                        "point";
                        "Vector3";
                    };
                };
            };
            {
                "ClearCharacterAppearance";
                "void";
                {};
            };
            {
                "HasAppearanceLoaded";
                "boolean";
                {};
            };
            {
                "GetJoinData";
                "table";
                {};
            };
            {
                "GetGameSessionID";
                "string";
                {};
            };
            {
                "GetUnder13";
                "boolean";
                {};
            };
            {
                "Move";
                "void";
                {
                    {
                        "walkDirection";
                        "Vector3";
                    };
                    {
                        "relativeToCamera";
                        "boolean";
                        "false";
                    };
                };
            };
        };
    };

    {
        Class = "RemoteEvent";
        Methods = {
            {
                "FireServer";
                "void";
                {
                    {
                        "args";
                        "Variadic";
                        "";
                    };
                };
            };
        };
    };

    {
        Class = "UnreliableRemoteEvent";
        Methods = {
            {
                "FireServer";
                "void";
                {
                    {
                        "args";
                        "Variadic";
                        "";
                    };
                };
            };
        };
    };

    {
        Class = "RemoteFunction";
        Methods = {
            {
                "InvokeServer";
                "any";
                {
                    {
                        "args";
                        "Variadic";
                        "";
                    };
                };
            };
        };
    };

    {
        Class = "BindableEvent";
        Methods = {
            {
                "Fire";
                "void";
                {
                    {
                        "args";
                        "Variadic";
                        "";
                    };
                };
            };
        };
    };

    {
        Class = "BindableFunction";
        Methods = {
            {
                "Invoke";
                "any";
                {
                    {
                        "args";
                        "Variadic";
                        "";
                    };
                };
            };
        };
    };

    {
        Class = "Sound";
        Methods = {
            {
                "Play";
                "void";
                {};
            };
            {
                "Pause";
                "void";
                {};
            };
            {
                "Resume";
                "void";
                {};
            };
            {
                "Stop";
                "void";
                {};
            };
            { "GetWaveformAsync"; "table"; {}; };
        };
    };

    {
        Class = "Tool";
        Methods = {
            {
                "Activate";
                "void";
                {};
            };
            {
                "Deactivate";
                "void";
                {};
            };
        };
    };

    {
        Class = "Camera";
        Methods = {
            {
                "GetRenderCFrame";
                "CFrame";
                {};
            };
            {
                "GetRoll";
                "number";
                {};
            };
            {
                "SetRoll";
                "void";
                {
                    {
                        "rollAngle";
                        "number";
                        "0";
                    };
                };
            };
            {
                "ZoomTo";
                "void";
                {
                    {
                        "distance";
                        "number";
                        "10";
                    };
                };
            };
            {
                "ScreenPointToRay";
                "Ray";
                {
                    {
                        "x";
                        "number";
                        "0";
                    };
                    {
                        "y";
                        "number";
                        "0";
                    };
                    {
                        "depth";
                        "number";
                        "0";
                    };
                };
            };
            {
                "ViewportPointToRay";
                "Ray";
                {
                    {
                        "x";
                        "number";
                        "0";
                    };
                    {
                        "y";
                        "number";
                        "0";
                    };
                    {
                        "depth";
                        "number";
                        "0";
                    };
                };
            };
            {
                "WorldToScreenPoint";
                "Vector3";
                {
                    {
                        "worldPoint";
                        "Vector3";
                    };
                };
            };
            {
                "WorldToViewportPoint";
                "Vector3";
                {
                    {
                        "worldPoint";
                        "Vector3";
                    };
                };
            };
            {
                "GetPartsObscuringTarget";
                "table";
                {
                    {
                        "castPoints";
                        "table";
                    };
                    {
                        "ignoreList";
                        "table";
                    };
                };
            };
        };
    };

    {
        Class = "Workspace";
        Methods = {
            {
                "Raycast";
                "RaycastResult";
                {
                    {
                        "origin";
                        "Vector3";
                    };
                    {
                        "direction";
                        "Vector3";
                    };
                };
            };
            {
                "Blockcast";
                "RaycastResult";
                {
                    {
                        "cframe";
                        "CFrame";
                    };
                    {
                        "size";
                        "Vector3";
                    };
                    {
                        "direction";
                        "Vector3";
                    };
                };
            };
            {
                "Spherecast";
                "RaycastResult";
                {
                    {
                        "origin";
                        "Vector3";
                    };
                    {
                        "radius";
                        "number";
                        "1";
                    };
                    {
                        "direction";
                        "Vector3";
                    };
                };
            };
            {
                "Shapecast";
                "RaycastResult";
                {
                    {
                        "part";
                        "BasePart";
                    };
                    {
                        "direction";
                        "Vector3";
                    };
                };
            };
            {
                "GetPartBoundsInBox";
                "table";
                {
                    {
                        "cframe";
                        "CFrame";
                    };
                    {
                        "size";
                        "Vector3";
                    };
                };
            };
            {
                "GetPartBoundsInRadius";
                "table";
                {
                    {
                        "position";
                        "Vector3";
                    };
                    {
                        "radius";
                        "number";
                        "10";
                    };
                };
            };
            {
                "GetPartsInPart";
                "table";
                {
                    {
                        "part";
                        "BasePart";
                    };
                };
            };
            {
                "FindPartOnRay";
                "BasePart";
                {
                    {
                        "ray";
                        "Ray";
                    };
                };
            };
            {
                "FindPartOnRayWithIgnoreList";
                "BasePart";
                {
                    {
                        "ray";
                        "Ray";
                    };
                    {
                        "ignoreList";
                        "table";
                    };
                };
            };
            {
                "FindPartOnRayWithWhitelist";
                "BasePart";
                {
                    {
                        "ray";
                        "Ray";
                    };
                    {
                        "whitelist";
                        "table";
                    };
                };
            };
            {
                "IsAncestorOf";
                "boolean";
                {
                    {
                        "descendant";
                        "Instance";
                    };
                };
            };
            {
                "GetServerTimeNow";
                "number";
                {};
            };
            {
                "GetRealPhysicsFPS";
                "number";
                {};
            };
            {
                "PGSIsEnabled";
                "boolean";
                {};
            };
        };
    };

    {
        Class = "Lighting";
        Methods = {
            {
                "GetMinutesAfterMidnight";
                "number";
                {};
            };
            {
                "SetMinutesAfterMidnight";
                "void";
                {
                    {
                        "minutes";
                        "number";
                        "720";
                    };
                };
            };
            {
                "GetMoonDirection";
                "Vector3";
                {};
            };
            {
                "GetSunDirection";
                "Vector3";
                {};
            };
        };
    };

    {
        Class = "Animator";
        Methods = {
            {
                "LoadAnimation";
                "AnimationTrack";
                {
                    {
                        "animation";
                        "Animation";
                    };
                };
            };
            {
                "GetPlayingAnimationTracks";
                "table";
                {};
            };
            {
                "StepAnimations";
                "void";
                {
                    {
                        "deltaTime";
                        "number";
                        "0.0166";
                    };
                };
            };
        };
    };

    {
        Class = "ClickDetector";
        Methods = {
            {
                "fireclickdetector";
                "void";
                {
                    {
                        "distance";
                        "number";
                        "0";
                    };
                    {
                        "event";
                        "string";
                        "MouseClick";
                    };
                };
                "global";
            };
        };
    };

    {
        Class = "ProximityPrompt";
        Methods = {
            {
                "fireproximityprompt";
                "void";
                {
                    {
                        "amount";
                        "number";
                        "1";
                    };
                    {
                        "skip";
                        "boolean";
                        "true";
                    };
                };
                "global";
            };
        };
    };

    {
        Class = "BasePart";
        Methods = {
            {
                "firetouchinterest";
                "void";
                {
                    {
                        "target";
                        "BasePart";
                        "character";
                    };
                    {
                        "toggle";
                        "number";
                        "0";
                    };
                };
                "global";
            };
        };
    };

    {
        Class = "TouchTransmitter";
        Methods = {
            {
                "firetouchinterest";
                "void";
                {
                    {
                        "target";
                        "BasePart";
                        "character";
                    };
                    {
                        "toggle";
                        "number";
                        "0";
                    };
                };
                "global";
                SelfFrom = "Parent";
            };
        };
    };
}

local function CollectMethods(Object)
    local Ordered = {}
    local Seen = {}

    for _, Group in MethodGroups do
        local Good, Matches = pcall(function()
            return Object:IsA(Group.Class)
        end)

        if Good and Matches then
            for _, Method in Group.Methods do
                local MethodName = Method[1]
                local IsGlobal = Method[4] == "global"
                local HasResolver = type(Method.Resolve) == "function"

                if IsGlobal and not HasResolver and not GetGlobalCallable(MethodName) then
                    continue
                end

                local SeenKey = IsGlobal and `global:{MethodName}` or MethodName

                if not Seen[SeenKey] then
                    Seen[SeenKey] = true
                    table.insert(Ordered, Method)
                end
            end
        end
    end

    return Ordered
end

local InsertableClasses = {
    "Accessory";
    "AlignOrientation";
    "AlignPosition";
    "Animation";
    "AnimationController";
    "Animator";
    "Atmosphere";
    "BallSocketConstraint";
    "Beam";
    "BillboardGui";
    "BindableEvent";
    "BindableFunction";
    "BlockMesh";
    "BloomEffect";
    "BlurEffect";
    "BodyAngularVelocity";
    "BodyColors";
    "BodyForce";
    "BodyGyro";
    "BodyPosition";
    "BodyThrust";
    "BodyVelocity";
    "BoolValue";
    "BoxHandleAdornment";
    "BrickColorValue";
    "Camera";
    "CFrameValue";
    "CharacterMesh";
    "ClickDetector";
    "Clouds";
    "Color3Value";
    "ColorCorrectionEffect";
    "ConeHandleAdornment";
    "Configuration";
    "CornerWedgePart";
    "CylinderHandleAdornment";
    "CylinderMesh";
    "Decal";
    "DepthOfFieldEffect";
    "Dialog";
    "DialogChoice";
    "Explosion";
    "FileMesh";
    "Fire";
    "Folder";
    "Frame";
    "Hat";
    "Highlight";
    "HingeConstraint";
    "HopperBin";
    "Humanoid";
    "ImageButton";
    "ImageHandleAdornment";
    "ImageLabel";
    "IntValue";
    "LineForce";
    "LineHandleAdornment";
    "LocalScript";
    "MeshPart";
    "Model";
    "Motor6D";
    "NumberValue";
    "ObjectValue";
    "Pants";
    "Part";
    "ParticleEmitter";
    "PointLight";
    "PrismaticConstraint";
    "ProximityPrompt";
    "RayValue";
    "RemoteEvent";
    "RemoteFunction";
    "RodConstraint";
    "RopeConstraint";
    "ScreenGui";
    "Script";
    "ScrollingFrame";
    "Seat";
    "SelectionBox";
    "Shirt";
    "ShirtGraphic";
    "Sky";
    "Smoke";
    "Sound";
    "SoundGroup";
    "Sparkles";
    "SpawnLocation";
    "SpecialMesh";
    "SphereHandleAdornment";
    "SpotLight";
    "SpringConstraint";
    "StringValue";
    "SunRaysEffect";
    "SurfaceGui";
    "SurfaceLight";
    "Texture";
    "Tool";
    "Torque";
    "Trail";
    "TrussPart";
    "UIAspectRatioConstraint";
    "UICorner";
    "UIGradient";
    "UIGridLayout";
    "UIListLayout";
    "UIPadding";
    "UIScale";
    "UISizeConstraint";
    "UIStroke";
    "UnreliableRemoteEvent";
    "Vector3Value";
    "VectorForce";
    "VehicleSeat";
    "VideoFrame";
    "WedgePart";
    "Weld";
    "WeldConstraint";
}

local Theme = {
    Background = Color3.fromRGB(15, 15, 17);
    Window = Color3.fromRGB(20, 20, 23);
    TitleBar = Color3.fromRGB(13, 13, 15);
    Border = Color3.fromRGB(34, 34, 38);
    BorderSoft = Color3.fromRGB(26, 26, 30);
    Field = Color3.fromRGB(28, 28, 32);
    FieldHover = Color3.fromRGB(36, 36, 42);
    Selected = Color3.fromRGB(56, 36, 38);
    SelectionBar = Color3.fromRGB(232, 55, 55);
    Text = Color3.fromRGB(232, 232, 236);
    TextDim = Color3.fromRGB(150, 150, 160);
    TextFaded = Color3.fromRGB(110, 110, 120);
    TextHeader = Color3.fromRGB(120, 120, 130);
    Accent = Color3.fromRGB(232, 55, 55);
    ToggleOn = Color3.fromRGB(0, 187, 0);
    ToggleOff = Color3.fromRGB(45, 45, 50);
    Green = Color3.fromRGB(95, 200, 120);
    Red = Color3.fromRGB(232, 80, 80);
    Yellow = Color3.fromRGB(220, 180, 90);
    Blue = Color3.fromRGB(110, 165, 240);
    Purple = Color3.fromRGB(180, 140, 240);
    Pink = Color3.fromRGB(244, 114, 182);
    PropString = Color3.fromRGB(255, 198, 109);
    PropNumber = Color3.fromRGB(130, 170, 255);
    PropInstance = Color3.fromRGB(130, 170, 255);
    PropEnum = Color3.fromRGB(195, 232, 141);
    PropNil = Color3.fromRGB(140, 140, 145);
    PropDefault = Color3.fromRGB(220, 220, 220);
}

local DefaultTheme = table.clone(Theme)
local UITransparency = {
    Window = 0;
    TitleBar = 0;
    Field = 0;
    Background = 0;
    ModalOverlay = 0.5;
}

local SaveConfigDeferred
local InBatchSave = false

local ThemeBindings = {}
local TransparencyBindings = {}

local function BindTheme(ThemeKey, Apply)
    ThemeBindings[ThemeKey] = ThemeBindings[ThemeKey] or {}

    local Wrapper
    Wrapper = function(Color)
        local Good, Result = pcall(Apply, Color)
        if not Good then
            return false
        end

        return Result ~= false
    end

    table.insert(ThemeBindings[ThemeKey], Wrapper)
    Apply(Theme[ThemeKey])
end

local function BindTransparency(Key, Apply)
    TransparencyBindings[Key] = TransparencyBindings[Key] or {}

    local Wrapper
    Wrapper = function(Value)
        local Good, Result = pcall(Apply, Value)
        if not Good then
            return false
        end
        return Result ~= false
    end

    table.insert(TransparencyBindings[Key], Wrapper)
    Apply(UITransparency[Key] or 0)
end

local function ClampTransparency(Value)
    return math.clamp(tonumber(Value) or 0, 0, 0.95)
end

local function SetUITransparency(Key, Value)
    UITransparency[Key] = ClampTransparency(Value)

    local Bindings = TransparencyBindings[Key]
    if Bindings then
        local Kept = {}
        for _, Wrapper in Bindings do
            if Wrapper(UITransparency[Key]) ~= false then
                Kept[#Kept + 1] = Wrapper
            end
        end
        TransparencyBindings[Key] = Kept
    end

    if SaveConfigDeferred and not InBatchSave then
        pcall(SaveConfigDeferred)
    end
end

local function RefreshThemePresetButton()
    if Explorer
        and Explorer.ThemePresetButton
        and Explorer.ThemePresetButton.Parent
    then
        Explorer.ThemePresetButton.Text = `{Explorer.ThemePresetName or "Custom"}`
    end
end

local function SetThemePresetName(Name)
    if not Explorer then
        return
    end

    Explorer.ThemePresetName = Name or "Custom"
    RefreshThemePresetButton()
end

local ApplyingPreset = false
local function MarkThemeCustom()
    if ApplyingPreset then
        return
    end

    if not Explorer then
        return
    end

    if Explorer.ThemePresetName ~= "Custom" then
        Explorer.ThemePresetName = "Custom"
        RefreshThemePresetButton()
    end
end

local function SetThemeColor(ThemeKey, NewColor)
    Theme[ThemeKey] = NewColor

    local Bindings = ThemeBindings[ThemeKey]
    if Bindings then
        local Kept = {}
        for _, Wrapper in Bindings do
            if Wrapper(NewColor) ~= false then
                Kept[#Kept + 1] = Wrapper
            end
        end
        ThemeBindings[ThemeKey] = Kept
    end

    if not InBatchSave then
        MarkThemeCustom()
    end

    if SaveConfigDeferred and not InBatchSave then
        pcall(SaveConfigDeferred)
    end
end

local Presets = {
    {
        Name = "Crimson (Default)";
        Colors = {
            Background = Color3.fromRGB(15, 15, 17);
            Window = Color3.fromRGB(20, 20, 23);
            TitleBar = Color3.fromRGB(13, 13, 15);
            Border = Color3.fromRGB(34, 34, 38);
            BorderSoft = Color3.fromRGB(26, 26, 30);
            Field = Color3.fromRGB(28, 28, 32);
            FieldHover = Color3.fromRGB(36, 36, 42);
            Selected = Color3.fromRGB(56, 36, 38);
            SelectionBar = Color3.fromRGB(232, 55, 55);
            Text = Color3.fromRGB(232, 232, 236);
            TextDim = Color3.fromRGB(150, 150, 160);
            TextFaded = Color3.fromRGB(110, 110, 120);
            TextHeader = Color3.fromRGB(120, 120, 130);
            Accent = Color3.fromRGB(232, 55, 55);
            PropString = Color3.fromRGB(255, 170, 130);
            PropNumber = Color3.fromRGB(255, 120, 130);
            PropInstance = Color3.fromRGB(255, 140, 150);
            PropEnum = Color3.fromRGB(220, 200, 140);
            PropNil = Color3.fromRGB(120, 120, 120);
            PropDefault = Color3.fromRGB(220, 220, 220);
        }
    };

    {
        Name = "Studio";
        Colors = {
            Background = Color3.fromRGB(35, 35, 38);
            Window = Color3.fromRGB(46, 46, 50);
            TitleBar = Color3.fromRGB(53, 53, 56);
            Border = Color3.fromRGB(70, 70, 74);
            BorderSoft = Color3.fromRGB(55, 55, 60);
            Field = Color3.fromRGB(46, 46, 50);
            FieldHover = Color3.fromRGB(60, 60, 66);
            Selected = Color3.fromRGB(11, 90, 175);
            SelectionBar = Color3.fromRGB(11, 90, 175);
            Text = Color3.fromRGB(220, 220, 220);
            TextDim = Color3.fromRGB(170, 170, 175);
            TextFaded = Color3.fromRGB(120, 120, 130);
            TextHeader = Color3.fromRGB(150, 150, 160);
            Accent = Color3.fromRGB(54, 145, 255);
            PropString = Color3.fromRGB(173, 241, 149);
            PropNumber = Color3.fromRGB(255, 198, 109);
            PropInstance = Color3.fromRGB(150, 200, 255);
            PropEnum = Color3.fromRGB(195, 232, 141);
            PropNil = Color3.fromRGB(140, 140, 145);
            PropDefault = Color3.fromRGB(220, 220, 220);
        }
    };

    {
        Name = "Discord";
            Colors = {
            Background = Color3.fromRGB(30, 31, 34);
            Window = Color3.fromRGB(43, 45, 49);
            TitleBar = Color3.fromRGB(30, 31, 34);
            Border = Color3.fromRGB(56, 58, 64);
            BorderSoft = Color3.fromRGB(40, 42, 46);
            Field = Color3.fromRGB(56, 58, 64);
            FieldHover = Color3.fromRGB(70, 73, 80);
            Selected = Color3.fromRGB(64, 78, 132);
            SelectionBar = Color3.fromRGB(88, 101, 242);
            Text = Color3.fromRGB(242, 243, 245);
            TextDim = Color3.fromRGB(181, 186, 193);
            TextFaded = Color3.fromRGB(128, 132, 142);
            TextHeader = Color3.fromRGB(148, 155, 164);
            Accent = Color3.fromRGB(88, 101, 242);
            PropString = Color3.fromRGB(255, 211, 132);
            PropNumber = Color3.fromRGB(150, 175, 255);
            PropInstance = Color3.fromRGB(120, 195, 255);
            PropEnum = Color3.fromRGB(170, 230, 160);
            PropNil = Color3.fromRGB(128, 132, 142);
            PropDefault = Color3.fromRGB(220, 222, 230);
        }
    };

    {
        Name = "Ocean";
        Colors = {
            Background = Color3.fromRGB(13, 25, 35);
            Window = Color3.fromRGB(18, 32, 44);
            TitleBar = Color3.fromRGB(11, 22, 32);
            Border = Color3.fromRGB(34, 52, 68);
            BorderSoft = Color3.fromRGB(24, 40, 54);
            Field = Color3.fromRGB(24, 40, 56);
            FieldHover = Color3.fromRGB(34, 54, 72);
            Selected = Color3.fromRGB(34, 70, 96);
            SelectionBar = Color3.fromRGB(66, 184, 255);
            Text = Color3.fromRGB(220, 235, 245);
            TextDim = Color3.fromRGB(140, 170, 190);
            TextFaded = Color3.fromRGB(95, 125, 145);
            TextHeader = Color3.fromRGB(110, 145, 170);
            Accent = Color3.fromRGB(66, 184, 255);
            PropString = Color3.fromRGB(110, 230, 215);
            PropNumber = Color3.fromRGB(120, 200, 255);
            PropInstance = Color3.fromRGB(170, 220, 255);
            PropEnum = Color3.fromRGB(140, 240, 200);
            PropNil = Color3.fromRGB(95, 125, 145);
            PropDefault = Color3.fromRGB(220, 235, 245);
        }
    };

    {
        Name = "Forest";
        Colors = {
            Background = Color3.fromRGB(16, 24, 18);
            Window = Color3.fromRGB(22, 32, 24);
            TitleBar = Color3.fromRGB(14, 22, 16);
            Border = Color3.fromRGB(40, 56, 42);
            BorderSoft = Color3.fromRGB(28, 42, 30);
            Field = Color3.fromRGB(28, 42, 30);
            FieldHover = Color3.fromRGB(38, 56, 40);
            Selected = Color3.fromRGB(44, 78, 50);
            SelectionBar = Color3.fromRGB(110, 200, 120);
            Text = Color3.fromRGB(225, 240, 225);
            TextDim = Color3.fromRGB(150, 180, 155);
            TextFaded = Color3.fromRGB(100, 130, 105);
            TextHeader = Color3.fromRGB(120, 150, 125);
            Accent = Color3.fromRGB(110, 200, 120);
            PropString = Color3.fromRGB(230, 200, 110);
            PropNumber = Color3.fromRGB(160, 220, 170);
            PropInstance = Color3.fromRGB(180, 230, 150);
            PropEnum = Color3.fromRGB(210, 230, 130);
            PropNil = Color3.fromRGB(100, 130, 105);
            PropDefault = Color3.fromRGB(225, 240, 225);
        }
    };

    {
        Name = "Midnight";
        Colors = {
            Background = Color3.fromRGB(10, 10, 16);
            Window = Color3.fromRGB(16, 16, 26);
            TitleBar = Color3.fromRGB(8, 8, 14);
            Border = Color3.fromRGB(36, 32, 56);
            BorderSoft = Color3.fromRGB(22, 22, 36);
            Field = Color3.fromRGB(24, 24, 38);
            FieldHover = Color3.fromRGB(34, 32, 52);
            Selected = Color3.fromRGB(58, 42, 96);
            SelectionBar = Color3.fromRGB(160, 110, 255);
            Text = Color3.fromRGB(232, 230, 245);
            TextDim = Color3.fromRGB(160, 155, 185);
            TextFaded = Color3.fromRGB(110, 105, 135);
            TextHeader = Color3.fromRGB(130, 125, 160);
            Accent = Color3.fromRGB(160, 110, 255);
            PropString = Color3.fromRGB(255, 170, 220);
            PropNumber = Color3.fromRGB(180, 150, 255);
            PropInstance = Color3.fromRGB(200, 170, 255);
            PropEnum = Color3.fromRGB(150, 220, 230);
            PropNil = Color3.fromRGB(110, 105, 135);
            PropDefault = Color3.fromRGB(232, 230, 245);
        }
    };

    {
        Name = "Eye Cancer";
        Colors = {
            Background = Color3.fromRGB(245, 246, 248);
            Window = Color3.fromRGB(252, 252, 254);
            TitleBar = Color3.fromRGB(232, 234, 238);
            Border = Color3.fromRGB(210, 214, 220);
            BorderSoft = Color3.fromRGB(225, 228, 234);
            Field = Color3.fromRGB(238, 240, 244);
            FieldHover = Color3.fromRGB(225, 228, 234);
            Selected = Color3.fromRGB(210, 224, 248);
            SelectionBar = Color3.fromRGB(60, 110, 220);
            Text = Color3.fromRGB(28, 30, 36);
            TextDim = Color3.fromRGB(80, 88, 100);
            TextFaded = Color3.fromRGB(140, 148, 160);
            TextHeader = Color3.fromRGB(110, 118, 132);
            Accent = Color3.fromRGB(60, 110, 220);
            PropString = Color3.fromRGB(180, 90, 30);
            PropNumber = Color3.fromRGB(40, 90, 200);
            PropInstance = Color3.fromRGB(50, 110, 180);
            PropEnum = Color3.fromRGB(40, 140, 90);
            PropNil = Color3.fromRGB(140, 148, 160);
            PropDefault = Color3.fromRGB(28, 30, 36);
        }
    };
    {
        Name = "DEX++";
        Colors = {
            Background = Color3.fromRGB(24, 25, 24);
            Window = Color3.fromRGB(35, 36, 34);
            TitleBar = Color3.fromRGB(43, 44, 41);
            Border = Color3.fromRGB(73, 76, 72);
            BorderSoft = Color3.fromRGB(50, 52, 49);
            Field = Color3.fromRGB(30, 32, 31);
            FieldHover = Color3.fromRGB(48, 51, 49);
            Selected = Color3.fromRGB(0, 82, 150);
            SelectionBar = Color3.fromRGB(0, 120, 215);
            Text = Color3.fromRGB(225, 225, 220);
            TextDim = Color3.fromRGB(172, 174, 168);
            TextFaded = Color3.fromRGB(115, 118, 112);
            TextHeader = Color3.fromRGB(160, 165, 156);
            Accent = Color3.fromRGB(38, 169, 245);
            PropString = Color3.fromRGB(145, 220, 135);
            PropNumber = Color3.fromRGB(255, 174, 78);
            PropInstance = Color3.fromRGB(95, 185, 255);
            PropEnum = Color3.fromRGB(210, 210, 135);
            PropNil = Color3.fromRGB(130, 130, 125);
            PropDefault = Color3.fromRGB(220, 220, 215);
        }
    };

    {
        Name = "Obsidian Blue";
        Colors = {
            Background = Color3.fromRGB(8, 12, 18);
            Window = Color3.fromRGB(13, 19, 28);
            TitleBar = Color3.fromRGB(7, 11, 17);
            Border = Color3.fromRGB(27, 42, 60);
            BorderSoft = Color3.fromRGB(18, 30, 44);
            Field = Color3.fromRGB(18, 27, 39);
            FieldHover = Color3.fromRGB(26, 40, 57);
            Selected = Color3.fromRGB(24, 58, 94);
            SelectionBar = Color3.fromRGB(65, 156, 255);
            Text = Color3.fromRGB(225, 236, 245);
            TextDim = Color3.fromRGB(145, 165, 185);
            TextFaded = Color3.fromRGB(85, 105, 125);
            TextHeader = Color3.fromRGB(115, 145, 175);
            Accent = Color3.fromRGB(65, 156, 255);
            PropString = Color3.fromRGB(120, 220, 190);
            PropNumber = Color3.fromRGB(120, 175, 255);
            PropInstance = Color3.fromRGB(100, 200, 255);
            PropEnum = Color3.fromRGB(190, 220, 140);
            PropNil = Color3.fromRGB(90, 105, 120);
            PropDefault = Color3.fromRGB(225, 236, 245);
        }
    };

    {
        Name = "Rose Noir";
        Colors = {
            Background = Color3.fromRGB(17, 10, 14);
            Window = Color3.fromRGB(27, 16, 23);
            TitleBar = Color3.fromRGB(15, 8, 13);
            Border = Color3.fromRGB(58, 32, 48);
            BorderSoft = Color3.fromRGB(38, 22, 32);
            Field = Color3.fromRGB(35, 20, 30);
            FieldHover = Color3.fromRGB(50, 28, 42);
            Selected = Color3.fromRGB(84, 36, 62);
            SelectionBar = Color3.fromRGB(255, 95, 160);
            Text = Color3.fromRGB(245, 225, 236);
            TextDim = Color3.fromRGB(190, 145, 170);
            TextFaded = Color3.fromRGB(135, 90, 115);
            TextHeader = Color3.fromRGB(170, 115, 145);
            Accent = Color3.fromRGB(255, 95, 160);
            PropString = Color3.fromRGB(255, 175, 130);
            PropNumber = Color3.fromRGB(255, 125, 160);
            PropInstance = Color3.fromRGB(255, 150, 200);
            PropEnum = Color3.fromRGB(225, 190, 135);
            PropNil = Color3.fromRGB(135, 90, 115);
            PropDefault = Color3.fromRGB(245, 225, 236);
        }
    };

    {
        Name = "Amethyst";
        Colors = {
            Background = Color3.fromRGB(13, 10, 22);
            Window = Color3.fromRGB(22, 17, 36);
            TitleBar = Color3.fromRGB(11, 8, 20);
            Border = Color3.fromRGB(48, 38, 76);
            BorderSoft = Color3.fromRGB(32, 25, 52);
            Field = Color3.fromRGB(30, 24, 48);
            FieldHover = Color3.fromRGB(43, 34, 68);
            Selected = Color3.fromRGB(68, 45, 115);
            SelectionBar = Color3.fromRGB(170, 120, 255);
            Text = Color3.fromRGB(235, 230, 250);
            TextDim = Color3.fromRGB(170, 155, 200);
            TextFaded = Color3.fromRGB(115, 100, 145);
            TextHeader = Color3.fromRGB(145, 125, 180);
            Accent = Color3.fromRGB(170, 120, 255);
            PropString = Color3.fromRGB(255, 185, 230);
            PropNumber = Color3.fromRGB(190, 160, 255);
            PropInstance = Color3.fromRGB(205, 175, 255);
            PropEnum = Color3.fromRGB(150, 225, 235);
            PropNil = Color3.fromRGB(115, 100, 145);
            PropDefault = Color3.fromRGB(235, 230, 250);
        }
    };

    {
        Name = "Cyber Lime";
        Colors = {
            Background = Color3.fromRGB(5, 12, 9);
            Window = Color3.fromRGB(10, 20, 15);
            TitleBar = Color3.fromRGB(4, 10, 7);
            Border = Color3.fromRGB(28, 62, 42);
            BorderSoft = Color3.fromRGB(18, 38, 27);
            Field = Color3.fromRGB(14, 30, 22);
            FieldHover = Color3.fromRGB(22, 48, 34);
            Selected = Color3.fromRGB(35, 80, 48);
            SelectionBar = Color3.fromRGB(110, 255, 120);
            Text = Color3.fromRGB(220, 255, 225);
            TextDim = Color3.fromRGB(145, 195, 150);
            TextFaded = Color3.fromRGB(85, 125, 90);
            TextHeader = Color3.fromRGB(120, 170, 125);
            Accent = Color3.fromRGB(110, 255, 120);
            PropString = Color3.fromRGB(215, 255, 120);
            PropNumber = Color3.fromRGB(120, 240, 160);
            PropInstance = Color3.fromRGB(130, 255, 210);
            PropEnum = Color3.fromRGB(255, 225, 120);
            PropNil = Color3.fromRGB(85, 125, 90);
            PropDefault = Color3.fromRGB(220, 255, 225);
        }
    };

    {
        Name = "Nord Frost";
        Colors = {
            Background = Color3.fromRGB(36, 41, 51);
            Window = Color3.fromRGB(46, 52, 64);
            TitleBar = Color3.fromRGB(40, 45, 56);
            Border = Color3.fromRGB(76, 86, 106);
            BorderSoft = Color3.fromRGB(59, 66, 82);
            Field = Color3.fromRGB(59, 66, 82);
            FieldHover = Color3.fromRGB(67, 76, 94);
            Selected = Color3.fromRGB(67, 94, 116);
            SelectionBar = Color3.fromRGB(136, 192, 208);
            Text = Color3.fromRGB(236, 239, 244);
            TextDim = Color3.fromRGB(216, 222, 233);
            TextFaded = Color3.fromRGB(129, 161, 193);
            TextHeader = Color3.fromRGB(143, 188, 187);
            Accent = Color3.fromRGB(136, 192, 208);
            PropString = Color3.fromRGB(163, 190, 140);
            PropNumber = Color3.fromRGB(180, 142, 173);
            PropInstance = Color3.fromRGB(129, 161, 193);
            PropEnum = Color3.fromRGB(235, 203, 139);
            PropNil = Color3.fromRGB(129, 161, 193);
            PropDefault = Color3.fromRGB(236, 239, 244);
        }
    };

    {
        Name = "Gruvbox Dark";
        Colors = {
            Background = Color3.fromRGB(29, 32, 33);
            Window = Color3.fromRGB(40, 40, 40);
            TitleBar = Color3.fromRGB(35, 35, 35);
            Border = Color3.fromRGB(80, 73, 69);
            BorderSoft = Color3.fromRGB(60, 56, 54);
            Field = Color3.fromRGB(50, 48, 47);
            FieldHover = Color3.fromRGB(60, 56, 54);
            Selected = Color3.fromRGB(69, 64, 51);
            SelectionBar = Color3.fromRGB(250, 189, 47);
            Text = Color3.fromRGB(235, 219, 178);
            TextDim = Color3.fromRGB(189, 174, 147);
            TextFaded = Color3.fromRGB(146, 131, 116);
            TextHeader = Color3.fromRGB(168, 153, 132);
            Accent = Color3.fromRGB(250, 189, 47);
            PropString = Color3.fromRGB(184, 187, 38);
            PropNumber = Color3.fromRGB(211, 134, 155);
            PropInstance = Color3.fromRGB(131, 165, 152);
            PropEnum = Color3.fromRGB(250, 189, 47);
            PropNil = Color3.fromRGB(146, 131, 116);
            PropDefault = Color3.fromRGB(235, 219, 178);
        }
    };

    {
        Name = "Tokyo Night";
        Colors = {
            Background = Color3.fromRGB(22, 22, 30);
            Window = Color3.fromRGB(31, 35, 53);
            TitleBar = Color3.fromRGB(26, 27, 38);
            Border = Color3.fromRGB(65, 72, 104);
            BorderSoft = Color3.fromRGB(41, 46, 66);
            Field = Color3.fromRGB(36, 40, 59);
            FieldHover = Color3.fromRGB(45, 51, 74);
            Selected = Color3.fromRGB(41, 66, 111);
            SelectionBar = Color3.fromRGB(122, 162, 247);
            Text = Color3.fromRGB(192, 202, 245);
            TextDim = Color3.fromRGB(169, 177, 214);
            TextFaded = Color3.fromRGB(86, 95, 137);
            TextHeader = Color3.fromRGB(125, 135, 190);
            Accent = Color3.fromRGB(122, 162, 247);
            PropString = Color3.fromRGB(158, 206, 106);
            PropNumber = Color3.fromRGB(255, 158, 100);
            PropInstance = Color3.fromRGB(125, 207, 255);
            PropEnum = Color3.fromRGB(224, 175, 104);
            PropNil = Color3.fromRGB(86, 95, 137);
            PropDefault = Color3.fromRGB(192, 202, 245);
        }
    };

    {
        Name = "Dracula";
        Colors = {
            Background = Color3.fromRGB(33, 34, 44);
            Window = Color3.fromRGB(40, 42, 54);
            TitleBar = Color3.fromRGB(30, 31, 40);
            Border = Color3.fromRGB(68, 71, 90);
            BorderSoft = Color3.fromRGB(52, 55, 70);
            Field = Color3.fromRGB(48, 50, 64);
            FieldHover = Color3.fromRGB(59, 62, 78);
            Selected = Color3.fromRGB(68, 54, 95);
            SelectionBar = Color3.fromRGB(189, 147, 249);
            Text = Color3.fromRGB(248, 248, 242);
            TextDim = Color3.fromRGB(190, 190, 185);
            TextFaded = Color3.fromRGB(120, 120, 130);
            TextHeader = Color3.fromRGB(160, 160, 170);
            Accent = Color3.fromRGB(189, 147, 249);
            PropString = Color3.fromRGB(80, 250, 123);
            PropNumber = Color3.fromRGB(255, 184, 108);
            PropInstance = Color3.fromRGB(139, 233, 253);
            PropEnum = Color3.fromRGB(241, 250, 140);
            PropNil = Color3.fromRGB(120, 120, 130);
            PropDefault = Color3.fromRGB(248, 248, 242);
        }
    };

    {
        Name = "Solarized Dark";
        Colors = {
            Background = Color3.fromRGB(0, 33, 41);
            Window = Color3.fromRGB(0, 43, 54);
            TitleBar = Color3.fromRGB(0, 29, 36);
            Border = Color3.fromRGB(7, 54, 66);
            BorderSoft = Color3.fromRGB(3, 45, 56);
            Field = Color3.fromRGB(7, 54, 66);
            FieldHover = Color3.fromRGB(12, 66, 80);
            Selected = Color3.fromRGB(18, 78, 92);
            SelectionBar = Color3.fromRGB(38, 139, 210);
            Text = Color3.fromRGB(238, 232, 213);
            TextDim = Color3.fromRGB(147, 161, 161);
            TextFaded = Color3.fromRGB(101, 123, 131);
            TextHeader = Color3.fromRGB(131, 148, 150);
            Accent = Color3.fromRGB(38, 139, 210);
            PropString = Color3.fromRGB(133, 153, 0);
            PropNumber = Color3.fromRGB(203, 75, 22);
            PropInstance = Color3.fromRGB(42, 161, 152);
            PropEnum = Color3.fromRGB(181, 137, 0);
            PropNil = Color3.fromRGB(101, 123, 131);
            PropDefault = Color3.fromRGB(238, 232, 213);
        }
    };

    {
        Name = "Catppuccin Mocha";
        Colors = {
            Background = Color3.fromRGB(17, 17, 27);
            Window = Color3.fromRGB(30, 30, 46);
            TitleBar = Color3.fromRGB(24, 24, 37);
            Border = Color3.fromRGB(69, 71, 90);
            BorderSoft = Color3.fromRGB(49, 50, 68);
            Field = Color3.fromRGB(41, 42, 58);
            FieldHover = Color3.fromRGB(49, 50, 68);
            Selected = Color3.fromRGB(58, 53, 88);
            SelectionBar = Color3.fromRGB(203, 166, 247);
            Text = Color3.fromRGB(205, 214, 244);
            TextDim = Color3.fromRGB(186, 194, 222);
            TextFaded = Color3.fromRGB(127, 132, 156);
            TextHeader = Color3.fromRGB(166, 173, 200);
            Accent = Color3.fromRGB(203, 166, 247);
            PropString = Color3.fromRGB(166, 227, 161);
            PropNumber = Color3.fromRGB(250, 179, 135);
            PropInstance = Color3.fromRGB(137, 220, 235);
            PropEnum = Color3.fromRGB(249, 226, 175);
            PropNil = Color3.fromRGB(127, 132, 156);
            PropDefault = Color3.fromRGB(205, 214, 244);
        }
    };

    {
        Name = "Monokai";
        Colors = {
            Background = Color3.fromRGB(25, 26, 24);
            Window = Color3.fromRGB(39, 40, 34);
            TitleBar = Color3.fromRGB(31, 32, 28);
            Border = Color3.fromRGB(73, 72, 62);
            BorderSoft = Color3.fromRGB(55, 55, 48);
            Field = Color3.fromRGB(48, 49, 43);
            FieldHover = Color3.fromRGB(60, 61, 54);
            Selected = Color3.fromRGB(73, 64, 42);
            SelectionBar = Color3.fromRGB(253, 151, 31);
            Text = Color3.fromRGB(248, 248, 242);
            TextDim = Color3.fromRGB(190, 190, 180);
            TextFaded = Color3.fromRGB(117, 113, 94);
            TextHeader = Color3.fromRGB(160, 155, 135);
            Accent = Color3.fromRGB(253, 151, 31);
            PropString = Color3.fromRGB(230, 219, 116);
            PropNumber = Color3.fromRGB(174, 129, 255);
            PropInstance = Color3.fromRGB(102, 217, 239);
            PropEnum = Color3.fromRGB(166, 226, 46);
            PropNil = Color3.fromRGB(117, 113, 94);
            PropDefault = Color3.fromRGB(248, 248, 242);
        }
    };

    {
        Name = "Cherry Blossom";
        Colors = {
            Background = Color3.fromRGB(24, 15, 20);
            Window = Color3.fromRGB(36, 24, 31);
            TitleBar = Color3.fromRGB(28, 18, 24);
            Border = Color3.fromRGB(80, 50, 64);
            BorderSoft = Color3.fromRGB(55, 35, 45);
            Field = Color3.fromRGB(45, 30, 39);
            FieldHover = Color3.fromRGB(62, 40, 52);
            Selected = Color3.fromRGB(90, 50, 68);
            SelectionBar = Color3.fromRGB(255, 155, 190);
            Text = Color3.fromRGB(255, 235, 242);
            TextDim = Color3.fromRGB(210, 165, 185);
            TextFaded = Color3.fromRGB(145, 100, 120);
            TextHeader = Color3.fromRGB(185, 130, 155);
            Accent = Color3.fromRGB(255, 155, 190);
            PropString = Color3.fromRGB(255, 210, 145);
            PropNumber = Color3.fromRGB(255, 145, 170);
            PropInstance = Color3.fromRGB(190, 190, 255);
            PropEnum = Color3.fromRGB(190, 235, 170);
            PropNil = Color3.fromRGB(145, 100, 120);
            PropDefault = Color3.fromRGB(255, 235, 242);
        }
    };

    {
        Name = "Mint Slate";
        Colors = {
            Background = Color3.fromRGB(13, 22, 22);
            Window = Color3.fromRGB(20, 34, 34);
            TitleBar = Color3.fromRGB(12, 26, 26);
            Border = Color3.fromRGB(38, 70, 66);
            BorderSoft = Color3.fromRGB(28, 50, 48);
            Field = Color3.fromRGB(25, 45, 44);
            FieldHover = Color3.fromRGB(35, 62, 60);
            Selected = Color3.fromRGB(38, 82, 75);
            SelectionBar = Color3.fromRGB(95, 230, 190);
            Text = Color3.fromRGB(225, 245, 240);
            TextDim = Color3.fromRGB(150, 190, 180);
            TextFaded = Color3.fromRGB(95, 130, 125);
            TextHeader = Color3.fromRGB(125, 165, 155);
            Accent = Color3.fromRGB(95, 230, 190);
            PropString = Color3.fromRGB(150, 245, 180);
            PropNumber = Color3.fromRGB(130, 210, 255);
            PropInstance = Color3.fromRGB(130, 245, 235);
            PropEnum = Color3.fromRGB(220, 230, 150);
            PropNil = Color3.fromRGB(95, 130, 125);
            PropDefault = Color3.fromRGB(225, 245, 240);
        }
    };

    {
        Name = "Amber Terminal";
        Colors = {
            Background = Color3.fromRGB(12, 9, 3);
            Window = Color3.fromRGB(22, 17, 7);
            TitleBar = Color3.fromRGB(15, 11, 4);
            Border = Color3.fromRGB(65, 45, 14);
            BorderSoft = Color3.fromRGB(38, 28, 10);
            Field = Color3.fromRGB(30, 22, 8);
            FieldHover = Color3.fromRGB(46, 33, 11);
            Selected = Color3.fromRGB(80, 52, 14);
            SelectionBar = Color3.fromRGB(255, 176, 50);
            Text = Color3.fromRGB(255, 230, 180);
            TextDim = Color3.fromRGB(210, 165, 95);
            TextFaded = Color3.fromRGB(135, 95, 45);
            TextHeader = Color3.fromRGB(180, 125, 60);
            Accent = Color3.fromRGB(255, 176, 50);
            PropString = Color3.fromRGB(255, 210, 95);
            PropNumber = Color3.fromRGB(255, 145, 70);
            PropInstance = Color3.fromRGB(255, 190, 110);
            PropEnum = Color3.fromRGB(220, 220, 120);
            PropNil = Color3.fromRGB(135, 95, 45);
            PropDefault = Color3.fromRGB(255, 230, 180);
        }
    };

    {
        Name = "Royal Navy";
        Colors = {
            Background = Color3.fromRGB(7, 10, 24);
            Window = Color3.fromRGB(13, 18, 40);
            TitleBar = Color3.fromRGB(8, 12, 30);
            Border = Color3.fromRGB(35, 45, 82);
            BorderSoft = Color3.fromRGB(22, 30, 58);
            Field = Color3.fromRGB(19, 27, 52);
            FieldHover = Color3.fromRGB(28, 39, 72);
            Selected = Color3.fromRGB(38, 58, 105);
            SelectionBar = Color3.fromRGB(90, 145, 255);
            Text = Color3.fromRGB(230, 235, 255);
            TextDim = Color3.fromRGB(160, 175, 215);
            TextFaded = Color3.fromRGB(95, 110, 150);
            TextHeader = Color3.fromRGB(125, 145, 190);
            Accent = Color3.fromRGB(90, 145, 255);
            PropString = Color3.fromRGB(140, 220, 180);
            PropNumber = Color3.fromRGB(170, 170, 255);
            PropInstance = Color3.fromRGB(110, 200, 255);
            PropEnum = Color3.fromRGB(240, 210, 130);
            PropNil = Color3.fromRGB(95, 110, 150);
            PropDefault = Color3.fromRGB(230, 235, 255);
        }
    };

    {
        Name = "Graphite";
        Colors = {
            Background = Color3.fromRGB(12, 12, 13);
            Window = Color3.fromRGB(22, 22, 24);
            TitleBar = Color3.fromRGB(16, 16, 18);
            Border = Color3.fromRGB(48, 48, 52);
            BorderSoft = Color3.fromRGB(32, 32, 36);
            Field = Color3.fromRGB(30, 30, 34);
            FieldHover = Color3.fromRGB(42, 42, 47);
            Selected = Color3.fromRGB(55, 55, 62);
            SelectionBar = Color3.fromRGB(170, 170, 180);
            Text = Color3.fromRGB(235, 235, 238);
            TextDim = Color3.fromRGB(165, 165, 172);
            TextFaded = Color3.fromRGB(105, 105, 112);
            TextHeader = Color3.fromRGB(135, 135, 145);
            Accent = Color3.fromRGB(170, 170, 180);
            PropString = Color3.fromRGB(210, 210, 160);
            PropNumber = Color3.fromRGB(160, 190, 230);
            PropInstance = Color3.fromRGB(160, 210, 230);
            PropEnum = Color3.fromRGB(190, 220, 170);
            PropNil = Color3.fromRGB(105, 105, 112);
            PropDefault = Color3.fromRGB(235, 235, 238);
        }
    };

    {
        Name = "Blood Moon";
        Colors = {
            Background = Color3.fromRGB(16, 5, 7);
            Window = Color3.fromRGB(28, 9, 12);
            TitleBar = Color3.fromRGB(20, 6, 8);
            Border = Color3.fromRGB(70, 24, 28);
            BorderSoft = Color3.fromRGB(44, 14, 17);
            Field = Color3.fromRGB(36, 12, 15);
            FieldHover = Color3.fromRGB(54, 18, 22);
            Selected = Color3.fromRGB(85, 25, 32);
            SelectionBar = Color3.fromRGB(255, 65, 75);
            Text = Color3.fromRGB(255, 225, 225);
            TextDim = Color3.fromRGB(205, 140, 145);
            TextFaded = Color3.fromRGB(135, 75, 80);
            TextHeader = Color3.fromRGB(175, 100, 105);
            Accent = Color3.fromRGB(255, 65, 75);
            PropString = Color3.fromRGB(255, 170, 120);
            PropNumber = Color3.fromRGB(255, 115, 125);
            PropInstance = Color3.fromRGB(255, 145, 155);
            PropEnum = Color3.fromRGB(230, 195, 115);
            PropNil = Color3.fromRGB(135, 75, 80);
            PropDefault = Color3.fromRGB(255, 225, 225);
        }
    };

    {
        Name = "Glass Steel";
        Colors = {
            Background = Color3.fromRGB(18, 22, 26);
            Window = Color3.fromRGB(28, 34, 40);
            TitleBar = Color3.fromRGB(22, 27, 32);
            Border = Color3.fromRGB(58, 70, 82);
            BorderSoft = Color3.fromRGB(40, 48, 56);
            Field = Color3.fromRGB(34, 42, 50);
            FieldHover = Color3.fromRGB(45, 55, 65);
            Selected = Color3.fromRGB(48, 68, 84);
            SelectionBar = Color3.fromRGB(135, 200, 235);
            Text = Color3.fromRGB(230, 240, 245);
            TextDim = Color3.fromRGB(160, 180, 190);
            TextFaded = Color3.fromRGB(100, 120, 130);
            TextHeader = Color3.fromRGB(130, 155, 168);
            Accent = Color3.fromRGB(135, 200, 235);
            PropString = Color3.fromRGB(170, 230, 200);
            PropNumber = Color3.fromRGB(150, 190, 240);
            PropInstance = Color3.fromRGB(135, 215, 245);
            PropEnum = Color3.fromRGB(220, 220, 160);
            PropNil = Color3.fromRGB(100, 120, 130);
            PropDefault = Color3.fromRGB(230, 240, 245);
        }
    };

    {
        Name = "Synthwave";
        Colors = {
            Background = Color3.fromRGB(20, 8, 35);
            Window = Color3.fromRGB(32, 14, 52);
            TitleBar = Color3.fromRGB(24, 9, 42);
            Border = Color3.fromRGB(75, 35, 100);
            BorderSoft = Color3.fromRGB(48, 22, 70);
            Field = Color3.fromRGB(42, 18, 62);
            FieldHover = Color3.fromRGB(60, 26, 86);
            Selected = Color3.fromRGB(82, 42, 112);
            SelectionBar = Color3.fromRGB(255, 80, 220);
            Text = Color3.fromRGB(245, 230, 255);
            TextDim = Color3.fromRGB(200, 150, 220);
            TextFaded = Color3.fromRGB(135, 90, 160);
            TextHeader = Color3.fromRGB(180, 115, 205);
            Accent = Color3.fromRGB(255, 80, 220);
            PropString = Color3.fromRGB(255, 220, 95);
            PropNumber = Color3.fromRGB(255, 120, 190);
            PropInstance = Color3.fromRGB(80, 235, 255);
            PropEnum = Color3.fromRGB(140, 255, 170);
            PropNil = Color3.fromRGB(135, 90, 160);
            PropDefault = Color3.fromRGB(245, 230, 255);
        }
    };

    {
        Name = "Vapor Ice";
        Colors = {
            Background = Color3.fromRGB(12, 18, 28);
            Window = Color3.fromRGB(22, 31, 46);
            TitleBar = Color3.fromRGB(16, 24, 36);
            Border = Color3.fromRGB(45, 68, 92);
            BorderSoft = Color3.fromRGB(32, 48, 68);
            Field = Color3.fromRGB(28, 42, 62);
            FieldHover = Color3.fromRGB(38, 58, 82);
            Selected = Color3.fromRGB(48, 70, 98);
            SelectionBar = Color3.fromRGB(110, 230, 255);
            Text = Color3.fromRGB(230, 245, 255);
            TextDim = Color3.fromRGB(165, 200, 215);
            TextFaded = Color3.fromRGB(100, 130, 150);
            TextHeader = Color3.fromRGB(135, 170, 190);
            Accent = Color3.fromRGB(110, 230, 255);
            PropString = Color3.fromRGB(185, 255, 220);
            PropNumber = Color3.fromRGB(160, 185, 255);
            PropInstance = Color3.fromRGB(130, 235, 255);
            PropEnum = Color3.fromRGB(255, 205, 250);
            PropNil = Color3.fromRGB(100, 130, 150);
            PropDefault = Color3.fromRGB(230, 245, 255);
        }
    };

    {
        Name = "Pumpkin";
        Colors = {
            Background = Color3.fromRGB(18, 10, 5);
            Window = Color3.fromRGB(30, 18, 9);
            TitleBar = Color3.fromRGB(22, 13, 6);
            Border = Color3.fromRGB(75, 42, 18);
            BorderSoft = Color3.fromRGB(48, 28, 13);
            Field = Color3.fromRGB(40, 24, 12);
            FieldHover = Color3.fromRGB(58, 34, 15);
            Selected = Color3.fromRGB(88, 48, 16);
            SelectionBar = Color3.fromRGB(255, 125, 35);
            Text = Color3.fromRGB(255, 235, 215);
            TextDim = Color3.fromRGB(220, 165, 120);
            TextFaded = Color3.fromRGB(145, 95, 60);
            TextHeader = Color3.fromRGB(190, 125, 80);
            Accent = Color3.fromRGB(255, 125, 35);
            PropString = Color3.fromRGB(255, 205, 110);
            PropNumber = Color3.fromRGB(255, 145, 80);
            PropInstance = Color3.fromRGB(255, 185, 125);
            PropEnum = Color3.fromRGB(180, 230, 130);
            PropNil = Color3.fromRGB(145, 95, 60);
            PropDefault = Color3.fromRGB(255, 235, 215);
        }
    };

    {
        Name = "Aqua Matrix";
        Colors = {
            Background = Color3.fromRGB(3, 13, 15);
            Window = Color3.fromRGB(8, 25, 28);
            TitleBar = Color3.fromRGB(4, 18, 20);
            Border = Color3.fromRGB(20, 70, 76);
            BorderSoft = Color3.fromRGB(14, 45, 50);
            Field = Color3.fromRGB(12, 36, 40);
            FieldHover = Color3.fromRGB(18, 55, 60);
            Selected = Color3.fromRGB(24, 82, 88);
            SelectionBar = Color3.fromRGB(70, 255, 230);
            Text = Color3.fromRGB(220, 255, 250);
            TextDim = Color3.fromRGB(140, 215, 205);
            TextFaded = Color3.fromRGB(75, 140, 135);
            TextHeader = Color3.fromRGB(105, 180, 170);
            Accent = Color3.fromRGB(70, 255, 230);
            PropString = Color3.fromRGB(130, 255, 170);
            PropNumber = Color3.fromRGB(95, 205, 255);
            PropInstance = Color3.fromRGB(75, 245, 255);
            PropEnum = Color3.fromRGB(220, 255, 140);
            PropNil = Color3.fromRGB(75, 140, 135);
            PropDefault = Color3.fromRGB(220, 255, 250);
        }
    };

    {
        Name = "Deep Space";
        Colors = {
            Background = Color3.fromRGB(6, 6, 14);
            Window = Color3.fromRGB(11, 11, 22);
            TitleBar = Color3.fromRGB(4, 4, 11);
            Border = Color3.fromRGB(28, 28, 52);
            BorderSoft = Color3.fromRGB(16, 16, 32);
            Field = Color3.fromRGB(14, 14, 28);
            FieldHover = Color3.fromRGB(22, 22, 42);
            Selected = Color3.fromRGB(34, 28, 78);
            SelectionBar = Color3.fromRGB(120, 90, 255);
            Text = Color3.fromRGB(225, 225, 245);
            TextDim = Color3.fromRGB(155, 155, 190);
            TextFaded = Color3.fromRGB(95, 95, 130);
            TextHeader = Color3.fromRGB(130, 130, 170);
            Accent = Color3.fromRGB(120, 90, 255);
            PropString = Color3.fromRGB(190, 150, 255);
            PropNumber = Color3.fromRGB(140, 170, 255);
            PropInstance = Color3.fromRGB(170, 200, 255);
            PropEnum = Color3.fromRGB(220, 180, 255);
            PropNil = Color3.fromRGB(95, 95, 130);
            PropDefault = Color3.fromRGB(225, 225, 245);
        }
    };

    {
        Name = "Galaxy";
        Colors = {
            Background = Color3.fromRGB(10, 8, 30);
            Window = Color3.fromRGB(18, 14, 46);
            TitleBar = Color3.fromRGB(8, 6, 24);
            Border = Color3.fromRGB(58, 42, 110);
            BorderSoft = Color3.fromRGB(32, 24, 70);
            Field = Color3.fromRGB(26, 20, 60);
            FieldHover = Color3.fromRGB(40, 30, 88);
            Selected = Color3.fromRGB(72, 38, 130);
            SelectionBar = Color3.fromRGB(220, 130, 255);
            Text = Color3.fromRGB(238, 230, 255);
            TextDim = Color3.fromRGB(190, 170, 230);
            TextFaded = Color3.fromRGB(120, 105, 165);
            TextHeader = Color3.fromRGB(165, 140, 210);
            Accent = Color3.fromRGB(220, 130, 255);
            PropString = Color3.fromRGB(255, 175, 220);
            PropNumber = Color3.fromRGB(155, 180, 255);
            PropInstance = Color3.fromRGB(180, 220, 255);
            PropEnum = Color3.fromRGB(255, 220, 150);
            PropNil = Color3.fromRGB(120, 105, 165);
            PropDefault = Color3.fromRGB(238, 230, 255);
        }
    };

    {
        Name = "Nebula";
        Colors = {
            Background = Color3.fromRGB(14, 10, 24);
            Window = Color3.fromRGB(26, 18, 42);
            TitleBar = Color3.fromRGB(12, 8, 22);
            Border = Color3.fromRGB(82, 40, 95);
            BorderSoft = Color3.fromRGB(46, 24, 56);
            Field = Color3.fromRGB(38, 22, 50);
            FieldHover = Color3.fromRGB(55, 32, 72);
            Selected = Color3.fromRGB(120, 45, 110);
            SelectionBar = Color3.fromRGB(255, 105, 200);
            Text = Color3.fromRGB(248, 232, 255);
            TextDim = Color3.fromRGB(200, 160, 215);
            TextFaded = Color3.fromRGB(140, 100, 155);
            TextHeader = Color3.fromRGB(180, 130, 200);
            Accent = Color3.fromRGB(255, 105, 200);
            PropString = Color3.fromRGB(255, 180, 230);
            PropNumber = Color3.fromRGB(180, 140, 255);
            PropInstance = Color3.fromRGB(140, 200, 255);
            PropEnum = Color3.fromRGB(255, 200, 140);
            PropNil = Color3.fromRGB(140, 100, 155);
            PropDefault = Color3.fromRGB(248, 232, 255);
        }
    };

    {
        Name = "Pitch Black";
        Colors = {
            Background = Color3.fromRGB(0, 0, 0);
            Window = Color3.fromRGB(8, 8, 8);
            TitleBar = Color3.fromRGB(0, 0, 0);
            Border = Color3.fromRGB(30, 30, 30);
            BorderSoft = Color3.fromRGB(18, 18, 18);
            Field = Color3.fromRGB(14, 14, 14);
            FieldHover = Color3.fromRGB(24, 24, 24);
            Selected = Color3.fromRGB(40, 40, 40);
            SelectionBar = Color3.fromRGB(220, 220, 220);
            Text = Color3.fromRGB(240, 240, 240);
            TextDim = Color3.fromRGB(160, 160, 160);
            TextFaded = Color3.fromRGB(95, 95, 95);
            TextHeader = Color3.fromRGB(130, 130, 130);
            Accent = Color3.fromRGB(220, 220, 220);
            PropString = Color3.fromRGB(220, 220, 180);
            PropNumber = Color3.fromRGB(180, 200, 240);
            PropInstance = Color3.fromRGB(170, 220, 240);
            PropEnum = Color3.fromRGB(200, 230, 180);
            PropNil = Color3.fromRGB(95, 95, 95);
            PropDefault = Color3.fromRGB(240, 240, 240);
        }
    };

    {
        Name = "Aurora";
        Colors = {
            Background = Color3.fromRGB(8, 16, 26);
            Window = Color3.fromRGB(14, 26, 40);
            TitleBar = Color3.fromRGB(6, 14, 24);
            Border = Color3.fromRGB(40, 80, 90);
            BorderSoft = Color3.fromRGB(22, 44, 56);
            Field = Color3.fromRGB(20, 38, 52);
            FieldHover = Color3.fromRGB(30, 56, 72);
            Selected = Color3.fromRGB(38, 92, 110);
            SelectionBar = Color3.fromRGB(120, 255, 200);
            Text = Color3.fromRGB(225, 250, 240);
            TextDim = Color3.fromRGB(150, 200, 195);
            TextFaded = Color3.fromRGB(90, 135, 140);
            TextHeader = Color3.fromRGB(120, 175, 175);
            Accent = Color3.fromRGB(120, 255, 200);
            PropString = Color3.fromRGB(180, 255, 200);
            PropNumber = Color3.fromRGB(150, 200, 255);
            PropInstance = Color3.fromRGB(180, 230, 255);
            PropEnum = Color3.fromRGB(255, 220, 170);
            PropNil = Color3.fromRGB(90, 135, 140);
            PropDefault = Color3.fromRGB(225, 250, 240);
        }
    };

    {
        Name = "Lava";
        Colors = {
            Background = Color3.fromRGB(14, 6, 4);
            Window = Color3.fromRGB(26, 10, 6);
            TitleBar = Color3.fromRGB(18, 7, 4);
            Border = Color3.fromRGB(90, 30, 12);
            BorderSoft = Color3.fromRGB(50, 18, 10);
            Field = Color3.fromRGB(40, 14, 8);
            FieldHover = Color3.fromRGB(60, 22, 12);
            Selected = Color3.fromRGB(110, 38, 16);
            SelectionBar = Color3.fromRGB(255, 110, 30);
            Text = Color3.fromRGB(255, 230, 210);
            TextDim = Color3.fromRGB(220, 160, 120);
            TextFaded = Color3.fromRGB(140, 90, 60);
            TextHeader = Color3.fromRGB(190, 120, 80);
            Accent = Color3.fromRGB(255, 110, 30);
            PropString = Color3.fromRGB(255, 200, 90);
            PropNumber = Color3.fromRGB(255, 130, 70);
            PropInstance = Color3.fromRGB(255, 170, 110);
            PropEnum = Color3.fromRGB(255, 220, 100);
            PropNil = Color3.fromRGB(140, 90, 60);
            PropDefault = Color3.fromRGB(255, 230, 210);
        }
    };

    {
        Name = "Cyberpunk";
        Colors = {
            Background = Color3.fromRGB(8, 4, 20);
            Window = Color3.fromRGB(16, 8, 36);
            TitleBar = Color3.fromRGB(6, 2, 16);
            Border = Color3.fromRGB(255, 30, 130);
            BorderSoft = Color3.fromRGB(40, 16, 70);
            Field = Color3.fromRGB(24, 12, 50);
            FieldHover = Color3.fromRGB(40, 20, 80);
            Selected = Color3.fromRGB(80, 20, 90);
            SelectionBar = Color3.fromRGB(0, 255, 240);
            Text = Color3.fromRGB(240, 240, 255);
            TextDim = Color3.fromRGB(200, 140, 230);
            TextFaded = Color3.fromRGB(120, 80, 150);
            TextHeader = Color3.fromRGB(255, 60, 180);
            Accent = Color3.fromRGB(0, 255, 240);
            PropString = Color3.fromRGB(255, 240, 90);
            PropNumber = Color3.fromRGB(255, 80, 200);
            PropInstance = Color3.fromRGB(0, 230, 255);
            PropEnum = Color3.fromRGB(150, 255, 130);
            PropNil = Color3.fromRGB(120, 80, 150);
            PropDefault = Color3.fromRGB(240, 240, 255);
        }
    };

    {
        Name = "Carbon";
        Colors = {
            Background = Color3.fromRGB(18, 18, 20);
            Window = Color3.fromRGB(26, 26, 30);
            TitleBar = Color3.fromRGB(14, 14, 16);
            Border = Color3.fromRGB(60, 60, 66);
            BorderSoft = Color3.fromRGB(38, 38, 42);
            Field = Color3.fromRGB(32, 32, 36);
            FieldHover = Color3.fromRGB(46, 46, 52);
            Selected = Color3.fromRGB(62, 62, 72);
            SelectionBar = Color3.fromRGB(255, 90, 60);
            Text = Color3.fromRGB(230, 230, 232);
            TextDim = Color3.fromRGB(165, 165, 170);
            TextFaded = Color3.fromRGB(110, 110, 115);
            TextHeader = Color3.fromRGB(140, 140, 145);
            Accent = Color3.fromRGB(255, 90, 60);
            PropString = Color3.fromRGB(255, 180, 130);
            PropNumber = Color3.fromRGB(170, 200, 240);
            PropInstance = Color3.fromRGB(160, 220, 240);
            PropEnum = Color3.fromRGB(200, 230, 160);
            PropNil = Color3.fromRGB(110, 110, 115);
            PropDefault = Color3.fromRGB(230, 230, 232);
        }
    };

    {
        Name = "Toxic";
        Colors = {
            Background = Color3.fromRGB(10, 14, 6);
            Window = Color3.fromRGB(18, 24, 10);
            TitleBar = Color3.fromRGB(8, 12, 5);
            Border = Color3.fromRGB(70, 100, 20);
            BorderSoft = Color3.fromRGB(36, 50, 14);
            Field = Color3.fromRGB(28, 38, 12);
            FieldHover = Color3.fromRGB(44, 60, 18);
            Selected = Color3.fromRGB(70, 100, 24);
            SelectionBar = Color3.fromRGB(190, 255, 40);
            Text = Color3.fromRGB(235, 255, 210);
            TextDim = Color3.fromRGB(180, 210, 130);
            TextFaded = Color3.fromRGB(110, 140, 70);
            TextHeader = Color3.fromRGB(150, 185, 95);
            Accent = Color3.fromRGB(190, 255, 40);
            PropString = Color3.fromRGB(220, 255, 110);
            PropNumber = Color3.fromRGB(160, 220, 90);
            PropInstance = Color3.fromRGB(180, 240, 120);
            PropEnum = Color3.fromRGB(240, 255, 140);
            PropNil = Color3.fromRGB(110, 140, 70);
            PropDefault = Color3.fromRGB(235, 255, 210);
        }
    };

    {
        Name = "Void";
        Colors = {
            Background = Color3.fromRGB(4, 4, 8);
            Window = Color3.fromRGB(10, 10, 16);
            TitleBar = Color3.fromRGB(2, 2, 6);
            Border = Color3.fromRGB(40, 30, 80);
            BorderSoft = Color3.fromRGB(20, 16, 40);
            Field = Color3.fromRGB(14, 12, 26);
            FieldHover = Color3.fromRGB(26, 22, 50);
            Selected = Color3.fromRGB(48, 30, 100);
            SelectionBar = Color3.fromRGB(140, 80, 255);
            Text = Color3.fromRGB(220, 215, 240);
            TextDim = Color3.fromRGB(150, 140, 185);
            TextFaded = Color3.fromRGB(90, 80, 125);
            TextHeader = Color3.fromRGB(125, 110, 165);
            Accent = Color3.fromRGB(140, 80, 255);
            PropString = Color3.fromRGB(210, 160, 255);
            PropNumber = Color3.fromRGB(150, 130, 240);
            PropInstance = Color3.fromRGB(180, 160, 255);
            PropEnum = Color3.fromRGB(180, 200, 255);
            PropNil = Color3.fromRGB(90, 80, 125);
            PropDefault = Color3.fromRGB(220, 215, 240);
        }
    };
}

table.sort(Presets, function(First, Second)
    return First.Name < Second.Name
end) -- just becoz i don't wanna follow alphabetical order myself each time i add a new preset :D

local function GetDefaultPresetName()
    return Presets[1] and Presets[1].Name or "Custom"
end

local function ApplyPreset(Preset)
    ApplyingPreset = true
    InBatchSave = true

    for Key, Color in Preset.Colors do
        SetThemeColor(Key, Color)
    end

    InBatchSave = false
    ApplyingPreset = false

    SetThemePresetName(Preset.Name)

    if SaveConfigDeferred then
        pcall(SaveConfigDeferred)
    end
end

local UserOriginalFPSCap
local VexAppliedUnlimited
local function ApplyFPSCap(Unlimited)
    local SetFn, GetFn
    pcall(function()
        local Env = getgenv and getgenv() or nil
        if Env then
            SetFn = Env.setfpscap
            GetFn = Env.getfpscap
        end
    end)

    if type(SetFn) ~= "function" then
        return false, "setfpscap not available"
    end

    if UserOriginalFPSCap == nil then
        if type(GetFn) == "function" then
            local Good, Current = pcall(GetFn)
            if Good and type(Current) == "number" and Current > 0 and Current ~= math.huge then
                UserOriginalFPSCap = Current
            end
        end
        UserOriginalFPSCap = UserOriginalFPSCap or 60
    end

    if Unlimited then
        local Good, Err = pcall(SetFn, math.huge)
        if Good then
            VexAppliedUnlimited = true
        end

        return Good, Err
    else
        if VexAppliedUnlimited then
            local Good, Err = pcall(SetFn, UserOriginalFPSCap)
            if Good then
                VexAppliedUnlimited = false
            end

            return Good, Err
        end

        return true
    end
end

local function BeautifyJson(Compact, IndentStr)
    IndentStr = IndentStr or "    "

    local Out = {}
    local Depth = 0
    local InString = false
    local Escape = false
    local Length = #Compact

    local function Newline()
        Out[#Out + 1] = "\n"
        Out[#Out + 1] = string.rep(IndentStr, Depth)
    end

    for I = 1, Length do
        local Char = Compact:sub(I, I)

        if InString then
            Out[#Out + 1] = Char
            if Escape then
                Escape = false
            elseif Char == "\\" then
                Escape = true
            elseif Char == "\"" then
                InString = false
            end
        else
            if Char == "\"" then
                InString = true
                Out[#Out + 1] = Char
            elseif Char == "{" or Char == "[" then
                Out[#Out + 1] = Char
                local Next = Compact:sub(I + 1, I + 1)
                if Next == "}" or Next == "]" then
                else
                    Depth += 1
                    Newline()
                end
            elseif Char == "}" or Char == "]" then
                local Prev = Compact:sub(I - 1, I - 1)
                if Prev ~= "{" and Prev ~= "[" then
                    Depth -= 1
                    Newline()
                end
                Out[#Out + 1] = Char
            elseif Char == "," then
                Out[#Out + 1] = Char
                Newline()
            elseif Char == ":" then
                Out[#Out + 1] = ": "
            elseif Char ~= " " and Char ~= "\t" and Char ~= "\n" and Char ~= "\r" then
                Out[#Out + 1] = Char
            end
        end
    end

    return table.concat(Out)
end

local Fonts = {
    Bold = Enum.Font.GothamBold;
    SemiBold = Enum.Font.GothamSemibold;
    Medium = Enum.Font.GothamMedium;
    Regular = Enum.Font.Gotham;
    Mono = Enum.Font.RobotoMono;
    Code = Enum.Font.Code;
    Heading = Enum.Font.Ubuntu;
}

local DefaultFonts = {}
for K, V in Fonts do
    DefaultFonts[K] = V
end

local TweenSnappy = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local TweenSlide = TweenInfo.new(0.25, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local VexUI = {}

function VexUI:CreateInstance(ClassName, Properties)
    local Object = Instance.new(ClassName)
    for Key, Value in Properties do
        Object[Key] = Value
    end

    return Object
end

function VexUI:AddStroke(Parent, ColorOrThemeKey, Thickness, Transparency)
    local Stroke = self:CreateInstance("UIStroke", {
        Color = Theme.Border;
        Thickness = Thickness or 1;
        Transparency = Transparency or 0;
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border;
        Parent = Parent;
    })

    if type(ColorOrThemeKey) == "string" then
        local ThemeKey = ColorOrThemeKey

        Stroke.Color = Theme[ThemeKey] or Theme.Border

        BindTheme(ThemeKey, function(Color)
            if Stroke and Stroke.Parent then
                Stroke.Color = Color
            end
        end)
    else
        Stroke.Color = ColorOrThemeKey or Theme.Border
    end

    return Stroke
end

function VexUI:AddPadding(Parent, Top, Right, Bottom, Left)
    return self:CreateInstance("UIPadding", {
        PaddingTop = UDim.new(0, Top or 0);
        PaddingRight = UDim.new(0, Right or Top or 0);
        PaddingBottom = UDim.new(0, Bottom or Top or 0);
        PaddingLeft = UDim.new(0, Left or Right or Top or 0);
        Parent = Parent;
    })
end

function VexUI:AddListLayout(Parent, Padding, Direction)
    return self:CreateInstance("UIListLayout", {
        FillDirection = Direction or Enum.FillDirection.Vertical;
        Padding = UDim.new(0, Padding or 4);
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = Parent;
    })
end

function VexUI:Tween(Object, Properties, TweenInfoOverride)
    Services.TweenService:Create(Object, TweenInfoOverride or TweenSnappy, Properties):Play()
end

function VexUI:CreateScreenGui()
    local ScreenGui = self:CreateInstance("ScreenGui", {
        Name = "VexExplorer";
        ResetOnSpawn = false;
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling;
        IgnoreGuiInset = true;
    })

    local Good = pcall(function()
        ScreenGui.Parent = gethui()
    end)

    if not Good then
        ScreenGui.Parent = Services.CoreGui
    end

    self.MainGui = ScreenGui
    return ScreenGui
end

function VexUI:CreateWindow(Config)
    local Parent = Config.Parent
    local Title = Config.Title or "Window"
    local Brand = Config.Brand
    local Size = Config.Size or UDim2.fromOffset(380, 480)
    local Position = Config.Position
        or UDim2.new(0.5, -Size.X.Offset / 2, 0.5, -Size.Y.Offset / 2)

    local Window = self:CreateInstance("Frame", {
        Size = Size;
        Position = Position;
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        ClipsDescendants = true;
        Parent = Parent;
    })

    local WindowStroke = self:AddStroke(Window, "Border", 1)

    local TitleBarHeight = Brand and 36 or 30
    local TitleBar = self:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, TitleBarHeight);
        BackgroundColor3 = Theme.TitleBar;
        BackgroundTransparency = UITransparency.TitleBar;
        BorderSizePixel = 0;
        Parent = Window;
    })

    BindTheme("TitleBar", function(Color)
        TitleBar.BackgroundColor3 = Color
    end)

    BindTransparency("TitleBar", function(Value)
        TitleBar.BackgroundTransparency = Value
    end)

    local TitleLabel = self:CreateInstance("TextLabel", {
        Size = UDim2.new(1, -240, 1, 0);
        Position = UDim2.new(0, 12, 0, 0);
        BackgroundTransparency = 1;
        Font = Fonts.Bold;
        Text = Brand and "" or Title:upper();
        TextColor3 = Theme.Text;
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextYAlignment = Enum.TextYAlignment.Center;
        Visible = not Brand;
        ZIndex = 4;
        Parent = TitleBar;
    })
    BindTheme("Text", function(Color)
        TitleLabel.TextColor3 = Color
    end)

    if Brand then
        local BrandHolder = self:CreateInstance("Frame", {
            Size = UDim2.new(0, 260, 1, 0);
            Position = UDim2.new(0, 12, 0, 0);
            BackgroundTransparency = 1;
            ZIndex = 4;
            Parent = TitleBar;
        })

        local BrandLayout = self:AddListLayout(BrandHolder, 6, Enum.FillDirection.Horizontal)
        BrandLayout.VerticalAlignment = Enum.VerticalAlignment.Center

        local BrandVersion = self:CreateInstance("TextLabel", {
            AutomaticSize = Enum.AutomaticSize.X;
            Size = UDim2.new(0, 0, 0, 18);
            BackgroundTransparency = 1;
            Font = Fonts.Bold;
            Text = `VEX [{Explorer:FetchVersion()}]`;
            TextColor3 = Theme.Text;
            TextSize = 13;
            LayoutOrder = 1;
            ZIndex = 4;
            Parent = BrandHolder;
        })

        BindTheme("Text", function(Color)
            if BrandVersion and BrandVersion.Parent then
                BrandVersion.TextColor3 = Color
            end
        end)

        local BrandDash = self:CreateInstance("TextLabel", {
            Size = UDim2.new(0, 8, 0, 18);
            BackgroundTransparency = 1;
            Font = Fonts.Bold;
            Text = "-";
            TextColor3 = Theme.TextFaded;
            TextSize = 13;
            LayoutOrder = 2;
            ZIndex = 4;
            Parent = BrandHolder;
        })

        BindTheme("TextFaded", function(Color)
            if BrandDash and BrandDash.Parent then
                BrandDash.TextColor3 = Color
            end
        end)

        local BrandAccent = self:CreateInstance("TextLabel", {
            AutomaticSize = Enum.AutomaticSize.X;
            Size = UDim2.new(0, 0, 0, 18);
            BackgroundTransparency = 1;
            Font = Fonts.Bold;
            Text = "Explorer";
            TextColor3 = Theme.Accent;
            TextSize = 13;
            LayoutOrder = 3;
            ZIndex = 4;
            Parent = BrandHolder;
        })

        BindTheme("Accent", function(Color)
            if BrandAccent and BrandAccent.Parent then
                BrandAccent.TextColor3 = Color
            end
        end)

        local BrandBy = self:CreateInstance("TextLabel", {
            AutomaticSize = Enum.AutomaticSize.X;
            Size = UDim2.new(0, 0, 0, 18);
            BackgroundTransparency = 1;
            Font = Fonts.Medium;
            Text = "By Vez";
            TextColor3 = Theme.TextFaded;
            TextSize = 11;
            LayoutOrder = 4;
            ZIndex = 4;
            Parent = BrandHolder;
        })

        BindTheme("TextFaded", function(Color)
            if BrandBy and BrandBy.Parent then
                BrandBy.TextColor3 = Color
            end
        end)
    end

    local ButtonRow = self:CreateInstance("Frame", {
        Size = UDim2.new(0, 0, 0, 22);
        AutomaticSize = Enum.AutomaticSize.X;
        Position = UDim2.new(1, -8, 0.5, -11);
        AnchorPoint = Vector2.new(1, 0);
        BackgroundTransparency = 1;
        ZIndex = 4;
        Parent = TitleBar;
    })
    local ButtonRowLayout = self:AddListLayout(ButtonRow, 6, Enum.FillDirection.Horizontal)
    ButtonRowLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    ButtonRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    local Body = self:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, -TitleBarHeight);
        Position = UDim2.new(0, 0, 0, TitleBarHeight);
        BackgroundColor3 = Theme.Window;
        BackgroundTransparency = UITransparency.Window;
        BorderSizePixel = 0;
        Parent = Window;
    })

    BindTheme("Window", function(Color)
        Body.BackgroundColor3 = Color
    end)

    BindTransparency("Window", function(Value)
        Body.BackgroundTransparency = Value
    end)

    local Dragging = false
    local Resizing = nil
    local DragStart, StartPosition
    local ResizeStart, ResizeStartSize, ResizeStartUDim

    Track(TitleBar.InputBegan:Connect(function(Input)
        if Resizing then
            return
        end

        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch
        then
            Dragging = true
            DragStart = Input.Position
            StartPosition = Window.Position
        end
    end))

    Track(Services.UserInputService.InputChanged:Connect(function(Input)
        if Resizing then
            return
        end

        if not Dragging then
            return
        end

        if Input.UserInputType ~= Enum.UserInputType.MouseMovement
            and Input.UserInputType ~= Enum.UserInputType.Touch
        then
            return
        end

        local Delta = Input.Position - DragStart
        Window.Position = UDim2.new(
            StartPosition.X.Scale, StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y
        )
    end))

    Track(Services.UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType ~= Enum.UserInputType.MouseButton1
            and Input.UserInputType ~= Enum.UserInputType.Touch
        then
            return
        end

        if not Dragging then
            return
        end
        Dragging = false

        local Camera = workspace.CurrentCamera
        if not Camera then
            return
        end

        local Viewport = Camera.ViewportSize
        local SizeX = Window.AbsoluteSize.X
        local SizeY = Window.AbsoluteSize.Y
        local AbsX = Window.AbsolutePosition.X
        local AbsY = Window.AbsolutePosition.Y
        local SnapEdge = 40

        local NewX = AbsX
        local NewY = AbsY
        local SnappedToEdge = false

        if AbsX <= SnapEdge then
            NewX = 0
            SnappedToEdge = true
        elseif AbsX + SizeX >= Viewport.X - SnapEdge then
            NewX = Viewport.X - SizeX
            SnappedToEdge = true
        end

        local InsetTop = 0
        pcall(function()
            local Inset = Services.GuiService:GetGuiInset()
            InsetTop = Inset.Y
        end)

        if AbsY <= SnapEdge + InsetTop then
            NewY = -InsetTop
            SnappedToEdge = true
        elseif AbsY + SizeY >= Viewport.Y - SnapEdge then
            NewY = Viewport.Y - SizeY
            SnappedToEdge = true
        end

        if not SnappedToEdge and Window.Parent then
            for _, Sibling in Window.Parent:GetChildren() do
                if Sibling ~= Window and Sibling:IsA("Frame") and Sibling.Visible then
                    local SibX = Sibling.AbsolutePosition.X
                    local SibY = Sibling.AbsolutePosition.Y
                    local SibW = Sibling.AbsoluteSize.X
                    local SibH = Sibling.AbsoluteSize.Y
                    local SibPos = Sibling.Position
                    local SibSize = Sibling.Size
                    local SnapTrigger = SnapEdge + 20

                    if math.abs(NewX - SibX) <= 80 and math.abs(SibW - SizeX) <= 80 then
                        if math.abs(AbsY - (SibY + SibH)) <= SnapTrigger then
                            NewX = SibX
                            Window.Size = UDim2.fromOffset(SibW, SizeY)
                            SizeX = SibW

                            local DesiredY = SibY + SibH
                            local AvailableBelow = Viewport.Y - DesiredY

                            if SizeY > AvailableBelow then
                                local ShrinkBy = SizeY - AvailableBelow
                                local NewSibH = math.max(200, SibH - ShrinkBy)
                                Sibling.Size = UDim2.new(
                                    SibSize.X.Scale, SibSize.X.Offset,
                                    SibSize.Y.Scale, SibSize.Y.Offset - (SibH - NewSibH)
                                )
                                DesiredY = SibY + NewSibH
                            end

                            NewY = DesiredY
                            SizeY = Window.AbsoluteSize.Y

                            break
                        elseif math.abs((AbsY + SizeY) - SibY) <= SnapTrigger then
                            NewX = SibX
                            Window.Size = UDim2.fromOffset(SibW, SizeY)
                            SizeX = SibW

                            local DesiredY = SibY - SizeY

                            if DesiredY < 0 then
                                local ShrinkBy = -DesiredY
                                local NewSibH = math.max(200, SibH - ShrinkBy)
                                Sibling.Position = UDim2.new(
                                    SibPos.X.Scale, SibPos.X.Offset,
                                    SibPos.Y.Scale, SibPos.Y.Offset + (SibH - NewSibH)
                                )
                                Sibling.Size = UDim2.new(
                                    SibSize.X.Scale, SibSize.X.Offset,
                                    SibSize.Y.Scale, SibSize.Y.Offset - (SibH - NewSibH)
                                )
                                DesiredY = 0
                            end

                            NewY = DesiredY
                            SizeY = Window.AbsoluteSize.Y

                            break
                        end
                    end
                end
            end
        end

        if NewY + SizeY > Viewport.Y then
            local ClampedH = math.max(200, Viewport.Y - NewY)
            Window.Size = UDim2.fromOffset(Window.AbsoluteSize.X, ClampedH)
        end

        if NewX ~= AbsX or NewY ~= AbsY then
            local DeltaX = NewX - AbsX
            local DeltaY = NewY - AbsY
            local Cur = Window.Position
            VexUI:Tween(Window, {
                Position = UDim2.new(
                    Cur.X.Scale, Cur.X.Offset + DeltaX,
                    Cur.Y.Scale, Cur.Y.Offset + DeltaY
                );
            }, TweenSlide)
        end
    end))

    local function MakeEdge(Side)
        local Edge = self:CreateInstance("Frame", {
            BackgroundTransparency = 1;
            ZIndex = 200;
            Active = true;
            Parent = Window;
        })

        if Side == "Right" then
            Edge.Size = UDim2.new(0, 6, 1, -32)
            Edge.Position = UDim2.new(1, -6, 0, 16)
        elseif Side == "Left" then
            Edge.Size = UDim2.new(0, 6, 1, -32)
            Edge.Position = UDim2.new(0, 0, 0, 16)
        elseif Side == "Bottom" then
            Edge.Size = UDim2.new(1, -16, 0, 6)
            Edge.Position = UDim2.new(0, 8, 1, -6)
        elseif Side == "Top" then
            Edge.Size = UDim2.new(1, -120, 0, 6)
            Edge.Position = UDim2.new(0, 60, 0, 0)
        elseif Side == "BottomRight" then
            Edge.Size = UDim2.new(0, 14, 0, 14)
            Edge.Position = UDim2.new(1, -14, 1, -14)
        elseif Side == "BottomLeft" then
            Edge.Size = UDim2.new(0, 14, 0, 14)
            Edge.Position = UDim2.new(0, 0, 1, -14)
        elseif Side == "TopRight" then
            Edge.Size = UDim2.new(0, 12, 0, 12)
            Edge.Position = UDim2.new(1, -12, 0, 0)
        elseif Side == "TopLeft" then
            Edge.Size = UDim2.new(0, 12, 0, 12)
            Edge.Position = UDim2.new(0, 0, 0, 0)
        end

        return Edge
    end

    local RightEdge = MakeEdge("Right")
    local LeftEdge = MakeEdge("Left")
    local BottomEdge = MakeEdge("Bottom")
    local TopEdge = MakeEdge("Top")
    local BottomRightCorner = MakeEdge("BottomRight")
    local BottomLeftCorner = MakeEdge("BottomLeft")
    local TopRightCorner = MakeEdge("TopRight")
    local TopLeftCorner = MakeEdge("TopLeft")

    local function HookEdge(Edge, Mode)
        Track(Edge.InputBegan:Connect(function(Input)
            if Dragging then
                return
            end

            if Input.UserInputType == Enum.UserInputType.MouseButton1
                or Input.UserInputType == Enum.UserInputType.Touch
            then
                Resizing = Mode
                ResizeStart = Input.Position
                ResizeStartSize = Window.AbsoluteSize
                ResizeStartUDim = Window.Position
            end
        end))
    end

    HookEdge(RightEdge, "R")
    HookEdge(LeftEdge, "L")
    HookEdge(BottomEdge, "B")
    HookEdge(TopEdge, "T")
    HookEdge(BottomRightCorner, "BR")
    HookEdge(BottomLeftCorner, "BL")
    HookEdge(TopRightCorner, "TR")
    HookEdge(TopLeftCorner, "TL")

    Track(Services.UserInputService.InputChanged:Connect(function(Input)
        if not Resizing then
            return
        end

        if Input.UserInputType ~= Enum.UserInputType.MouseMovement
            and Input.UserInputType ~= Enum.UserInputType.Touch
        then
            return
        end

        local Delta = Input.Position - ResizeStart
        local MinW = 280
        local MinH = 200

        local NewWidth = ResizeStartSize.X
        local NewHeight = ResizeStartSize.Y
        local OffsetXDelta = 0
        local OffsetYDelta = 0

        local ResizeRight = Resizing == "R" or Resizing == "BR" or Resizing == "TR"
        local ResizeLeft = Resizing == "L" or Resizing == "BL" or Resizing == "TL"
        local ResizeBottom = Resizing == "B" or Resizing == "BR" or Resizing == "BL"
        local ResizeTop = Resizing == "T" or Resizing == "TR" or Resizing == "TL"

        if ResizeRight then
            NewWidth = math.max(MinW, ResizeStartSize.X + Delta.X)
        elseif ResizeLeft then
            local MaxLeftDelta = ResizeStartSize.X - MinW
            local ClampedDX = math.min(Delta.X, MaxLeftDelta)
            NewWidth = ResizeStartSize.X - ClampedDX
            OffsetXDelta = ClampedDX
        end

        if ResizeBottom then
            NewHeight = math.max(MinH, ResizeStartSize.Y + Delta.Y)
        elseif ResizeTop then
            local MaxTopDelta = ResizeStartSize.Y - MinH
            local ClampedDY = math.min(Delta.Y, MaxTopDelta)
            NewHeight = ResizeStartSize.Y - ClampedDY
            OffsetYDelta = ClampedDY
        end

        Window.Size = UDim2.fromOffset(NewWidth, NewHeight)
        Window.Position = UDim2.new(
            ResizeStartUDim.X.Scale, ResizeStartUDim.X.Offset + OffsetXDelta,
            ResizeStartUDim.Y.Scale, ResizeStartUDim.Y.Offset + OffsetYDelta
        )
    end))

    Track(Services.UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch
        then
            Resizing = nil
        end
    end))

    local Class = {
        Frame = Window;
        TitleBar = TitleBar;
        Body = Body;
        TitleLabel = TitleLabel;
        ButtonRow = ButtonRow;
    }

    function Class:SetVisible(Visible)
        Window.Visible = Visible
    end

    function Class:SetTitle(NewTitle)
        TitleLabel.Text = (NewTitle or ""):upper()
    end

    function Class:AddTitleButton(Text, Width, IsDanger, OnClick, IconAssetName, TextSizeOverride, IconSizeOverride)
        local AssetId = IconAssetName and GetUIAssetId(IconAssetName) or nil
        local IconSize = IconSizeOverride or 14
        local IconHalf = IconSize / 2

        local Button = VexUI:CreateInstance("TextButton", {
            Size = UDim2.new(0, Width, 0, 22);
            BackgroundColor3 = IsDanger and Theme.Accent or Theme.Border;
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            AutoButtonColor = false;
            Font = Fonts.Bold;
            Text = AssetId and "" or Text;
            TextColor3 = IsDanger and Color3.fromRGB(245, 245, 245) or Theme.TextDim;
            TextSize = 10;
            LayoutOrder = #ButtonRow:GetChildren();
            ZIndex = 4;
            Parent = ButtonRow;
        })

        local Stroke = VexUI:AddStroke(Button, IsDanger and "Accent" or "Border", 1)

        local Icon
        if AssetId then
            Icon = VexUI:CreateInstance("ImageLabel", {
                Size = UDim2.fromOffset(IconSize, IconSize);
                Position = UDim2.new(0.5, -IconHalf, 0.5, -IconHalf);
                BackgroundTransparency = 1;
                Image = AssetId;
                ImageColor3 = IsDanger and Theme.Text or Theme.TextDim;
                ImageTransparency = 0;
                ScaleType = Enum.ScaleType.Fit;
                ZIndex = 5;
                Parent = Button;
            })
        end

        local Hovered = false

        local function GetButtonTransparency()
            local TitleTransparency = UITransparency.TitleBar or 0

            if Hovered then
                if IsDanger then
                    return math.clamp(TitleTransparency * 0.55, 0, 0.9)
                end

                return math.clamp(TitleTransparency * 0.65, 0, 0.92)
            end

            if IsDanger then
                return math.clamp(math.max(0.85, TitleTransparency), 0, 0.96)
            end

            return math.clamp(TitleTransparency + 0.12, 0, 1)
        end

        local function GetButtonColor()
            if Hovered then
                return IsDanger and Theme.Accent or Theme.Selected
            end

            return IsDanger and Theme.Accent or Theme.Border
        end

        local function GetTextColor()
            if Hovered and IsDanger then
                return Theme.Red or Theme.Accent
            end

            if Hovered then
                return Theme.Text
            end

            return Theme.TextDim
        end

        local function ApplyVisual(UseTween)
            local TargetTransparency = GetButtonTransparency()
            local TargetBackground = GetButtonColor()
            local TargetText = GetTextColor()

            if UseTween then
                VexUI:Tween(Button, {
                    BackgroundColor3 = TargetBackground;
                    BackgroundTransparency = TargetTransparency;
                    TextColor3 = TargetText;
                })

                if Icon then
                    VexUI:Tween(Icon, {
                        ImageColor3 = TargetText;
                    })
                end
            else
                Button.BackgroundColor3 = TargetBackground
                Button.BackgroundTransparency = TargetTransparency
                Button.TextColor3 = TargetText

                if Icon then
                    if UseTween then
                        VexUI:Tween(Icon, {
                            ImageColor3 = TargetText;
                        })
                    else
                        Icon.ImageColor3 = TargetText
                    end
                end
            end

            if Stroke then
                Stroke.Color = IsDanger and Theme.Accent or Theme.Border
                Stroke.Transparency = math.clamp(TargetTransparency + 0.1, 0, 1)
            end
        end

        BindTransparency("TitleBar", function()
            if Button and Button.Parent then
                ApplyVisual(false)
            end
        end)

        if IsDanger then
            BindTheme("Accent", function()
                if Button and Button.Parent then
                    ApplyVisual(false)
                end
            end)

            BindTheme("Text", function()
                if Button and Button.Parent then
                    ApplyVisual(false)
                end
            end)

            BindTheme("TextDim", function()
                if Button and Button.Parent then
                    ApplyVisual(false)
                end
            end)

            BindTheme("Red", function()
                if Button and Button.Parent then
                    ApplyVisual(false)
                end
            end)
        else
            BindTheme("Border", function()
                if Button and Button.Parent then
                    ApplyVisual(false)
                end
            end)

            BindTheme("TextDim", function()
                if Button and Button.Parent then
                    ApplyVisual(false)
                end
            end)

            BindTheme("Text", function()
                if Button and Button.Parent then
                    ApplyVisual(false)
                end
            end)

            BindTheme("Selected", function()
                if Button and Button.Parent then
                    ApplyVisual(false)
                end
            end)
        end

        Track(Button.MouseEnter:Connect(function()
            Hovered = true
            ApplyVisual(true)
        end))

        Track(Button.MouseLeave:Connect(function()
            Hovered = false
            ApplyVisual(true)
        end))

        if OnClick then
            Track(Button.MouseButton1Click:Connect(OnClick))
        end

        ApplyVisual(false)

        return Button
    end

    return Class
end

function VexUI:CreateClassIcon(ClassName, Parent)
    local Icon = self:CreateInstance("ImageLabel", {
        Size = UDim2.new(0, 16, 0, 16);
        BackgroundTransparency = 1;
        Parent = Parent;
    })
    VexUI:ApplyClassIcon(Icon, ClassName or "Instance")
    return Icon
end

function VexUI:CreateTooltip(Parent, Text)
    local Tooltip = self:CreateInstance("Frame", {
        Size = UDim2.new(0, 0, 0, 22);
        AutomaticSize = Enum.AutomaticSize.X;
        BackgroundColor3 = Theme.TitleBar;
        BorderSizePixel = 0;
        Visible = false;
        ZIndex = 200;
        Parent = self.MainGui;
    })
    self:AddStroke(Tooltip, "Border", 1)
    self:AddPadding(Tooltip, 4, 8, 4, 8)
    BindTheme("TitleBar", function(Color) Tooltip.BackgroundColor3 = Color end)

    local Label = self:CreateInstance("TextLabel", {
        AutomaticSize = Enum.AutomaticSize.X;
        Size = UDim2.new(0, 0, 1, 0);
        BackgroundTransparency = 1;
        Font = Fonts.Medium;
        Text = Text;
        TextColor3 = Theme.Text;
        TextSize = 11;
        ZIndex = 201;
        Parent = Tooltip;
    })
    BindTheme("Text", function(Color) Label.TextColor3 = Color end)

    Track(Parent.MouseEnter:Connect(function()
        Tooltip.Visible = true
        local AbsPos = Parent.AbsolutePosition
        local AbsSize = Parent.AbsoluteSize
        Tooltip.Position = UDim2.fromOffset(AbsPos.X + AbsSize.X / 2 - 40, AbsPos.Y + AbsSize.Y + 6)
    end))

    Track(Parent.MouseLeave:Connect(function()
        Tooltip.Visible = false
    end))

    return Tooltip
end

function VexUI:ApplyClassIcon(ImageLabel, ClassName)
    if not ImageLabel then return end

    if not ClassName then
        ImageLabel.ClipsDescendants = false
        ImageLabel.Image = ""
        ImageLabel.ImageTransparency = 1
        local Child = ImageLabel:FindFirstChild("IconMap")
        if Child then
            Child:Destroy()
        end
        return
    end

    local ClassIcons = Explorer.ClassIcons
    if not ClassIcons then return end

    ImageLabel.Image = ""
    ImageLabel.ImageTransparency = 0
    ImageLabel.ClipsDescendants = true
    ClassIcons:DisplayExplorerIcons(ImageLabel, ClassName)
end

local function IsLuaIdentifier(Name)
    if type(Name) ~= "string" or #Name == 0 then
        return false
    end

    if Name:match("^[%a_][%w_]*$") == nil then
        return false
    end

    local Reserved = {
        ["and"] = true; ["break"] = true; ["do"] = true; ["else"] = true;
        ["elseif"] = true; ["end"] = true; ["false"] = true; ["for"] = true;
        ["function"] = true; ["goto"] = true; ["if"] = true; ["in"] = true;
        ["local"] = true; ["nil"] = true; ["not"] = true; ["or"] = true;
        ["repeat"] = true; ["return"] = true; ["then"] = true; ["true"] = true;
        ["until"] = true; ["while"] = true; ["continue"] = true;
    }

    return not Reserved[Name]
end

local function FormatSegment(Name, IsRoot)
    if IsLuaIdentifier(Name) then
        return IsRoot and Name or `.{Name}`
    end

    return `[{string.format("%q", Name)}]`
end

local function IsScriptViewable(Instance)
    if not Instance then
        return false
    end

    local ClassName = Instance.ClassName

    if ClassName == "LocalScript"
        or ClassName == "ModuleScript"
    then
        return true
    end

    if ClassName == "Script" then
        local Success, RunContext = pcall(function()
            return Instance.RunContext
        end)

        return Success and RunContext == Enum.RunContext.Client
    end

    return false
end

local ClassPriority = {
    Camera = 1;
    Terrain = 2;

    Folder = 10;
    Model = 11;
    Configuration = 12;

    Script = 30;
    LocalScript = 31;
    ModuleScript = 32;

    RemoteEvent = 40;
    RemoteFunction = 41;
    BindableEvent = 42;
    BindableFunction = 43;
    UnreliableRemoteEvent = 44;

    Part = 60;
    MeshPart = 61;
    UnionOperation = 62;
    WedgePart = 63;

    Humanoid = 80;
}

local function SortExplorerChildren(Children)
    table.sort(Children, function(Left, Right)
        local LeftClass = Left.ClassName
        local RightClass = Right.ClassName

        local LeftPriority = ClassPriority[LeftClass] or 999
        local RightPriority = ClassPriority[RightClass] or 999

        if LeftPriority ~= RightPriority then
            return LeftPriority < RightPriority
        end

        local LeftName = Left.Name:lower()
        local RightName = Right.Name:lower()

        if LeftName ~= RightName then
            return LeftName < RightName
        end

        return LeftClass < RightClass
    end)

    return Children
end

local ExplorerClass = {}
ExplorerClass.__index = ExplorerClass

Explorer = setmetatable({
    LocalPlayer = LocalPlayer;
    ScreenGui = nil;
    ExplorerWindow = nil;
    PropertiesWindow = nil;

    SelectedInstance = nil;
    SelectedSet = {};
    SelectedOrder = {};
    SelectionAnchor = nil;

    SearchQuery = "";
    PropertyFilter = "";

    ToggleKey = Enum.KeyCode.RightAlt;
    WindowVisible = true;
    UnlimitedFPS = false;
    AutoRefreshProperties = true;
    RefreshDelay = 0;

    PropertyConnections = {};
    PropertyRows = {};

    Clipboard = nil;

    CtrlHeld = false;
    ShiftHeld = false;
    ReparentMode = false;
    ReparentSources = {};

    Tasks = {};

    AllServicesHidden = false;
    NilFilterClass = "";
    ActiveClassFilters = {};
    HiddenServices = {};
    HideNilContainer = false;

    FilterClassOptions = {
        "Folder";
        "Model";
        "Configuration";
        "Part";
        "MeshPart";
        "UnionOperation";
        "WedgePart";
        "BasePart";
        "Script";
        "LocalScript";
        "ModuleScript";
        "RemoteEvent";
        "RemoteFunction";
        "BindableEvent";
        "BindableFunction";
        "UnreliableRemoteEvent";
        "Humanoid";
        "HumanoidDescription";
        "Animation";
        "AnimationTrack";
        "Sound";
        "SoundGroup";
        "Frame";
        "ScrollingFrame";
        "ScreenGui";
        "SurfaceGui";
        "BillboardGui";
        "TextLabel";
        "TextButton";
        "TextBox";
        "ImageLabel";
        "ImageButton";
        "UIListLayout";
        "UIGridLayout";
        "UICorner";
        "UIStroke";
        "UIPadding";
        "Tool";
        "Accessory";
        "Hat";
        "Shirt";
        "Pants";
        "StringValue";
        "NumberValue";
        "BoolValue";
        "IntValue";
        "ObjectValue";
        "CFrameValue";
        "ClickDetector";
        "ProximityPrompt";
        "ParticleEmitter";
        "Decal";
        "Texture";
        "Beam";
        "Trail";
        "Attachment";
        "Motor6D";
        "Weld";
        "WeldConstraint";
        "Player";
    };

    ConfigFolder = "Vex";
    ConfigPath = "Vex/Vex.lua";
    Version = nil;
    ConfigLoaded = false;

    ScriptViewerWindows = {};

    NilRowHeight = 22;
    NilRowGap = 1;
    NilBufferRows = 4;

    MatchSet = {};
    SubtreeMatchSet = {};

    _FilterRowRefreshers = {};

    PropertyFilters = {};
    PropertyFilterTemplate = nil;

    ExpandedInstances = setmetatable({}, {__mode = "k"});
    SelectionHighlights = setmetatable({}, {__mode = "k"});

    DragOperation = nil;
    _JustDragged = false;

    UseLuaExpertDecompiler = false;

    ViewedObject = nil;
    ViewConnection = nil;
    ViewSavedCFrame = nil;
    ViewSavedCameraType = nil;

    ThemePresetName = "Crimson (Default)";
    ThemePresetButton = nil;

    ClickPartToSelect = false;
    _ClickPartConnection = nil;
    _QuickDropdown = nil;

    SearchIndex = {};
    SearchIndexByInstance = setmetatable({}, {__mode = "k"});
    SearchIndexBuilt = false;
    _SearchIndexHooked = false;
    _LastIndexedQuery = nil;
    _LastIndexedResults = nil;
    _FilterChangedSinceLastSearch = false;

    MatchByClassName = false;
    MatchByProperty = false;

    FlatSearchResults = false;
    ClassIcon = "NewDark";
    ClassIcons = nil;
    _FlatResultsContainer = nil;
    _FlatResultsPool = nil;
    _FlatResultsItems = nil;
    _FlatRowHeight = 22;
    _FlatRowGap = 0;
    _FlatBufferRows = 6;

    _VTreeRows = nil;
    _VTreeRowsByInstance = nil;
    _VTreeFilteredRows = nil;
    _VTreeFilterActive = false;
    _VTreeFilteredExpanded = nil;
    _VTreeExpanded = nil;
    _VTreeContainer = nil;
    _VTreePool = nil;
    _VTreeRowHeight = 22;
    _VTreeRowGap = 0;
    _VTreeBufferRows = 4;
    _VTreeIndent = 16;
    _VTreeScrollConn = nil;
    _VTreeRebuildScheduled = false;
    _VTreeFilteredPageSize = 150;

    _NilWalkCache = nil;
    _NilWalkCacheTime = 0;
    _NilWalkCacheTTL = math.huge;
    _NilRefreshDebounceToken = 0;

    PinnedPaths = {};
}, ExplorerClass)

local function RebindFont(OldEnum, NewEnum)
    if OldEnum == NewEnum then return end
    local Root = Explorer.ScreenGui
    if not Root then return end

    for _, Desc in Root:GetDescendants() do
        if Desc:IsA("TextLabel")
            or Desc:IsA("TextButton")
            or Desc:IsA("TextBox")
        then
            if Desc.Font == OldEnum then
                pcall(function()
                    Desc.Font = NewEnum
                end)
            end
        end
    end
end

function Explorer:InitClassIcons()
    self.ClassIcons = CreateExplorerClassIcons(self.ClassIcon or "NewDark")
end

function Explorer:InvalidateAllClassIcons()
    if self._VTreePool then
        for _, Entry in self._VTreePool do
            Entry.IconClassName = nil
        end
    end

    if self._FlatResultsPool then
        for _, Entry in self._FlatResultsPool do
            if Entry.IconClassName ~= nil then
                Entry.IconClassName = nil
            end
        end
    end

    self:_VTreeScheduleRebuild()
end

function Explorer:SetClassIconTheme(ThemeName)
    if not table.find(ClassIconThemes, ThemeName) then
        ThemeName = "NewDark"
    end

    if self.ClassIcon == ThemeName and self.ClassIcons then
        return
    end

    self.ClassIcon = ThemeName
    self.ClassIcons = CreateExplorerClassIcons(ThemeName)
    self:InvalidateAllClassIcons()
    self:SaveConfig()
end

function Explorer:SpawnTask(TaskName, Callback)
    Handle(function()
        if self.Tasks[TaskName] then
            pcall(task.cancel, self.Tasks[TaskName])
            self.Tasks[TaskName] = nil
        end

        self.Tasks[TaskName] = task.spawn(Callback)
    end, `Task Spawn ({TaskName})`)
end

function Explorer:ResetTasks()
    for TaskName, Thread in self.Tasks do
        pcall(task.cancel, Thread)
        self.Tasks[TaskName] = nil
    end
end

local function ResolveInstanceText(Text)
    Text = tostring(Text or "")

    local Lowered = Text:lower()
    if Lowered == ""
        or Lowered == "character"
        or Lowered == "char"
        or Lowered == "hrp"
        or Lowered == "me"
    then
        return GetLocalCharacterRootPart()
    end

    if Lowered == "selected" then
        return Explorer.SelectedInstance
    end

    return nil
end

function Explorer:GetInstancePath(Object)
    if not Object or typeof(Object) ~= "Instance" then
        return ""
    end

    local LocalPlayerRef = self.LocalPlayer or Services.Players.LocalPlayer

    local function IsGame(Inst)
        return Inst == game
    end

    local function IsWorkspace(Inst)
        if Inst == workspace then
            return true
        end

        local Good, Match = pcall(function()
            return Inst:IsA("Workspace")
        end)

        return Good and Match == true
    end

    local function IsLocalPlayer(Inst)
        if Inst == LocalPlayerRef then
            return true
        end

        if not LocalPlayerRef then
            return false
        end

        local Good, IsPlayer = pcall(function()
            return Inst:IsA("Player")
        end)

        if not Good or not IsPlayer then
            return false
        end

        local GoodId, UserId = pcall(function()
            return Inst.UserId
        end)

        local GoodRefId, RefUserId = pcall(function()
            return LocalPlayerRef.UserId
        end)

        if not GoodId or not GoodRefId then
            return false
        end

        return UserId == RefUserId and UserId ~= 0
    end

    if IsGame(Object) then
        return "game"
    end

    if IsLocalPlayer(Object) then
        return `game:GetService("Players").LocalPlayer`
    end

    local Segments = {}
    local Cursor = Object
    local Anchor

    while Cursor and not IsGame(Cursor) do
        if IsLocalPlayer(Cursor) then
            Anchor = `game:GetService("Players").LocalPlayer`

            break
        end

        local GoodName, Name = pcall(function()
            return Cursor.Name
        end)

        if not GoodName or type(Name) ~= "string" then
            return ""
        end

        local GoodParent, Parent = pcall(function()
            return Cursor.Parent
        end)

        if not GoodParent then
            return ""
        end

        if Parent and IsGame(Parent) then
            local GoodClass, ClassName = pcall(function()
                return Cursor.ClassName
            end)

            if GoodClass and type(ClassName) == "string" then
                local GoodService, Service = pcall(function()
                    return game:GetService(ClassName)
                end)

                if GoodService and Service then
                    local SameService = Service == Cursor
                    if not SameService then
                        local GoodSvcName, SvcName = pcall(function()
                            return Service.Name
                        end)

                        SameService = GoodSvcName and SvcName == Name
                    end

                    if SameService then
                        Anchor = `game:GetService("{ClassName}")`

                        break
                    end
                end
            end
        end

        table.insert(Segments, 1, Name)
        Cursor = Parent
    end

    if not Anchor then
        Anchor = "game"
    end

    local Path = Anchor
    for _, Name in Segments do
        Path ..= FormatSegment(Name, false)
    end

    return Path
end

function Explorer:FullPathFor(Object)
    if not Object or typeof(Object) ~= "Instance" then
        return ""
    end

    local Path = self:GetInstancePath(Object)
    if Path == "" then
        return ""
    end

    return Path
end

function Explorer:FullPath()
    local Target = self.SelectedInstance
    if not Target then
        return
    end

    return self:FullPathFor(Target)
end

function Explorer:CopySelectionField(Extractor, SingleLabel, MultiLabel)
    local Selection = self:GetSelectionList()
    if #Selection == 0 then
        return
    end

    if #Selection == 1 then
        pcall(setclipboard, Extractor(Selection[1]))
        self:Notify(SingleLabel)
    else
        local Lines = {}
        for _, Inst in Selection do
            table.insert(Lines, Extractor(Inst))
        end
        pcall(setclipboard, table.concat(Lines, "\n"))
        self:Notify(`{MultiLabel} ({#Selection})`)
    end
end

function Explorer:FormatValue(Value)
    if Value == nil then
        return "nil"
    end

    local ValueType = typeof(Value)

    if ValueType == "boolean" then
        return tostring(Value)
    end

    if ValueType == "number" then
        if Value == math.floor(Value) then
            return tostring(math.floor(Value))
        end

        return string.format("%.5g", Value)
    end

    if ValueType == "string" then
        return Value
    end

    if ValueType == "Vector3" then
        return string.format("%.4g, %.4g, %.4g", Value.X, Value.Y, Value.Z)
    end

    if ValueType == "Vector2" then
        return string.format("%.4g, %.4g", Value.X, Value.Y)
    end

    if ValueType == "CFrame" then
        local Position = Value.Position

        return string.format("%.4g, %.4g, %.4g", Position.X, Position.Y, Position.Z)
    end

    if ValueType == "Color3" then
        return string.format("%d, %d, %d",
            math.floor(Value.R * 255),
            math.floor(Value.G * 255),
            math.floor(Value.B * 255)
        )
    end

    if ValueType == "BrickColor" then
        return Value.Name
    end

    if ValueType == "UDim2" then
        return string.format("{%.3g,%d},{%.3g,%d}",
            Value.X.Scale, Value.X.Offset,
            Value.Y.Scale, Value.Y.Offset
        )
    end

    if ValueType == "UDim" then
        return string.format("%.3g, %d", Value.Scale, Value.Offset)
    end

    if ValueType == "EnumItem" then
        return Value.Name
    end

    if ValueType == "Instance" then
        return `{Value.ClassName}({Value.Name})`
    end

    return tostring(Value)
end

function Explorer:GetValueColor(Value)
    if Value == nil then
        return Theme.PropNil
    end

    local ValueType = typeof(Value)
    if ValueType == "boolean" then
        return Value and Theme.Green or Theme.Red
    end

    if ValueType == "number" then
        return Theme.PropNumber
    end

    if ValueType == "string" then
        return Theme.PropString
    end

    if ValueType == "EnumItem" then
        return Theme.PropEnum
    end

    if ValueType == "Instance" then
        return Theme.PropInstance
    end

    if ValueType == "Vector3"
        or ValueType == "Vector2"
        or ValueType == "Vector3int16"
        or ValueType == "Vector2int16"
        or ValueType == "CFrame"
        or ValueType == "UDim"
        or ValueType == "UDim2"
        or ValueType == "NumberRange"
        or ValueType == "NumberSequence"
        or ValueType == "Rect"
        or ValueType == "Region3"
    then
        return Theme.PropNumber
    end

    if ValueType == "Color3"
        or ValueType == "BrickColor"
        or ValueType == "ColorSequence"
    then
        return Theme.PropString
    end

    return Theme.PropDefault
end

function Explorer:IsEditableValue(Value)
    local ValueType = typeof(Value)
    return ValueType == "string"
        or ValueType == "number"
        or ValueType == "Vector3"
        or ValueType == "Vector2"
        or ValueType == "UDim2"
        or ValueType == "UDim"
        or ValueType == "CFrame"
end

function Explorer:ParseEditValue(RawText, Reference)
    local ValueType = typeof(Reference)

    if ValueType == "string" then
        return RawText
    end

    if ValueType == "number" then
        return tonumber(RawText)
    end

    if ValueType == "boolean" then
        local Lowered = RawText:lower()
        if Lowered == "true" or Lowered == "1" then
            return true
        end

        if Lowered == "false" or Lowered == "0" then
            return false
        end

        return nil
    end

    if ValueType == "Vector3" then
        local VectorX, VectorY, VectorZ = RawText:match("([%-%d%.]+)[,%s]+([%-%d%.]+)[,%s]+([%-%d%.]+)")
        if VectorX then
            return Vector3.new(tonumber(VectorX), tonumber(VectorY), tonumber(VectorZ))
        end
    end

    if ValueType == "Vector2" then
        local VectorX, VectorY = RawText:match("([%-%d%.]+)[,%s]+([%-%d%.]+)")
        if VectorX then
            return Vector2.new(tonumber(VectorX), tonumber(VectorY))
        end
    end

    if ValueType == "CFrame" then
        local Numbers = {}
        for NumberStr in RawText:gmatch("[%-%d%.]+") do
            table.insert(Numbers, tonumber(NumberStr))
        end

        if #Numbers == 12 then
            return CFrame.new(table.unpack(Numbers))
        end

        if #Numbers == 6 then
            return CFrame.new(
                Numbers[1], Numbers[2], Numbers[3])
                * CFrame.Angles(math.rad(Numbers[4]), math.rad(Numbers[5]), math.rad(Numbers[6])
            )
        end

        if #Numbers == 3 then
            local CurrentRotation = Reference - Reference.Position

            return CurrentRotation + Vector3.new(Numbers[1], Numbers[2], Numbers[3])
        end

        return nil
    end

    if ValueType == "UDim2" then
        local ScaleX, OffsetX, ScaleY, OffsetY = RawText:match("{?([%-%d%.]+)[,%s]+([%-%d]+)}?[,%s}]+{?([%-%d%.]+)[,%s]+([%-%d]+)}?")
        if ScaleX then
            return UDim2.new(tonumber(ScaleX), tonumber(OffsetX), tonumber(ScaleY), tonumber(OffsetY))
        end
    end

    if ValueType == "UDim" then
        local Scale, Offset = RawText:match("([%-%d%.]+)[,%s]+([%-%d]+)")
        if Scale then
            return UDim.new(tonumber(Scale), tonumber(Offset))
        end
    end

    return nil
end

function Explorer:ApplyToSelection(PropertyName, Value)
    for _, Object in self.SelectedOrder do
        SafeSet(Object, PropertyName, Value)
    end
end

function Explorer:HandleDoubleClick(Node)
    if not Node or not Node.Instance then
        return
    end

    if Node.IsNilContainer then
        return
    end

    if IsScriptViewable(Node.Instance) then
        self:OpenScriptViewer(Node.Instance, not self.UseLuaExpertDecompiler)

        return
    end

    self:BeginRename(Node)
end

function Explorer:BeginRename(Node)
    if not Node
        or not Node.Label
        or not Node.Label.Parent
    then
        return
    end

    local Label = Node.Label
    local OldText = Node.Instance.Name
    Label.Visible = false

    local Box = VexUI:CreateInstance("TextBox", {
        Size = Label.Size;
        Position = Label.Position;
        BackgroundColor3 = Theme.Field;
        BackgroundTransparency = 0.15;
        BorderSizePixel = 0;
        Font = Label.Font;
        Text = OldText;
        TextColor3 = Theme.Text;
        TextSize = Label.TextSize;
        TextXAlignment = Enum.TextXAlignment.Left;
        ClearTextOnFocus = false;
        ZIndex = (Label.ZIndex or 1) + 1;
        Parent = Label.Parent;
    })
    VexUI:AddStroke(Box, Theme.Accent, 1)

    task.defer(function()
        if Box.Parent then
            Box:CaptureFocus()
            Box.SelectionStart = 1
            Box.CursorPosition = #OldText + 1
        end
    end)

    local Done = false
    local function Finish(Apply)
        if Done then
            return
        end

        Done = true

        if Apply then
            local NewName = Box.Text
            if NewName ~= "" and NewName ~= OldText then
                pcall(function()
                    Node.Instance.Name = NewName 
                end)
            end
        end

        if Box.Parent then
            Box:Destroy()
        end
        if Label.Parent then
            Label.Visible = true
        end
    end

    Box.FocusLost:Connect(function(Enter)
        Finish(Enter)
    end)
end

function Explorer:UpdateSelectionHighlights()
    self.SelectionHighlights = self.SelectionHighlights or setmetatable({}, {__mode = "k"})

    for Inst, Highlight in self.SelectionHighlights do
        if not self.SelectedSet[Inst] then
            pcall(function()
                Highlight:Destroy()
            end)
            self.SelectionHighlights[Inst] = nil
        end
    end

    for Inst in self.SelectedSet do
        if not self.SelectionHighlights[Inst] then
            local CanAdorn = false
            pcall(function()
                CanAdorn = Inst:IsA("BasePart") or Inst:IsA("Model")
            end)
            if CanAdorn then
                local Good, Highlight = pcall(function()
                    local H = Instance.new("Highlight")
                    H.Name = "VexSelectionHighlight"
                    H.FillTransparency = 1
                    H.FillColor = Theme.Accent
                    H.OutlineColor = Theme.Accent
                    H.OutlineTransparency = 0
                    H.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    H.Adornee = Inst
                    H.Parent = self.ScreenGui
                    return H
                end)
                if Good and Highlight then
                    self.SelectionHighlights[Inst] = Highlight
                end
            end
        end
    end
end

function Explorer:JumpToInstance(Target)
    if typeof(Target) ~= "Instance" then
        return
    end

    if self.SearchQuery ~= "" then
        self._SearchTextToken = (self._SearchTextToken or 0) + 1
        self._SuppressSearchBoxChanged = true

        if self.SearchBox then
            self.SearchBox.Text = ""
        end

        self._SuppressSearchBoxChanged = false
        self._LastAppliedSearchQuery = ""

        if self.ClearSearchStateWithoutRebuild then
            self:ClearSearchStateWithoutRebuild()
        end
    end

    local Cloned = ClonerefInstance(Target)

    if self._VTreeRevealInstance then
        self:_VTreeRevealInstance(Cloned, {
            Select = true;
            Scroll = true;
            Expand = true;
        })
        self.SelectionAnchor = Cloned
        return
    end

    self:SetSelection({Cloned})
    self.SelectionAnchor = Cloned
end

function Explorer:JumpToCharacter(Player)
    if not Player then
        return
    end

    local Good, Character = pcall(function()
        return Player.Character
    end)

    if not Good or not Character then
        if self.ShowErrorNotification then
            pcall(function()
                self:ShowErrorNotification(`{Player.Name} has no Character`)
            end)
        end

        return
    end

    self:JumpToInstance(ClonerefInstance(Character))
end

function Explorer:JumpToPlayer(Player)
    local Good, Player = pcall(function()
        return Services.Players[Player.Name]
    end)

    if not Good or not Player then
        if self.ShowErrorNotification then
            pcall(function()
                self:ShowErrorNotification(`{Player.Name} no longer exists`)
            end)
        end

        return
    end

    self:JumpToInstance(ClonerefInstance(Player))
end

function Explorer:ToggleAllServicesHidden()
    self.AllServicesHidden = not self.AllServicesHidden
    if self.AllServicesHidden then
        for _, Service in WeakGetChildren(game) do
            self.HiddenServices[Service.Name] = true
        end
    else
        self.HiddenServices = {}
    end
    self:SaveConfig()

    if self._FilterRowRefreshers then
        for _, Refresh in self._FilterRowRefreshers do
            pcall(Refresh)
        end
    end
    self:RebuildExplorer()
end

function Explorer:_FlatAllocateRow(Container)
    local Row = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 0, self._FlatRowHeight);
        Position = UDim2.new(0, 0, 0, 0);
        BackgroundColor3 = Theme.Field;
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Text = "";
        Visible = false;
        Parent = Container;
    })

    local Icon = VexUI:CreateInstance("ImageLabel", {
        Size = UDim2.new(0, 16, 0, 16);
        Position = UDim2.new(0, 6, 0.5, -8);
        BackgroundTransparency = 1;
        Image = "";
        ScaleType = Enum.ScaleType.Fit;
        Parent = Row;
    })

    local Label = VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(0.55, -28, 1, 0);
        Position = UDim2.new(0, 28, 0, 0);
        BackgroundTransparency = 1;
        Font = Fonts.Medium;
        RichText = true;
        Text = "";
        TextColor3 = Theme.Text;
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextTruncate = Enum.TextTruncate.AtEnd;
        Parent = Row;
    })

    local Path = VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(0.45, -8, 1, 0);
        Position = UDim2.new(0.55, 0, 0, 0);
        BackgroundTransparency = 1;
        Font = Fonts.Medium;
        Text = "";
        TextColor3 = Theme.TextFaded;
        TextSize = 11;
        TextXAlignment = Enum.TextXAlignment.Right;
        TextTruncate = Enum.TextTruncate.AtEnd;
        Parent = Row;
    })

    local PoolEntry = {
        Row = Row;
        Icon = Icon;
        Label = Label;
        Path = Path;
        Item = nil;
        IconClassName = nil;
    }

    Row.MouseEnter:Connect(function()
        if PoolEntry.Item and not self.SelectedSet[PoolEntry.Item] then
            Row.BackgroundTransparency = 0.85
        end
    end)

    Row.MouseLeave:Connect(function()
        if PoolEntry.Item and not self.SelectedSet[PoolEntry.Item] then
            Row.BackgroundTransparency = 1
        end
    end)

    Row.MouseButton1Click:Connect(function()
        local Item = PoolEntry.Item
        if not Item then return end

        if self.CtrlHeld then
            local New = {}
            for _, Existing in self.SelectedOrder do
                table.insert(New, Existing)
            end
            if self.SelectedSet[Item] then
                for I, V in New do
                    if V == Item then table.remove(New, I); break end
                end
            else
                table.insert(New, Item)
            end
            self:SetSelection(New)
        else
            self:SetSelection({Item})
        end

        self:_FlatRefreshVisibleSelection()
    end)

    Row.MouseButton2Click:Connect(function()
        local Item = PoolEntry.Item
        if not Item then return end

        if not self.SelectedSet[Item] then
            self:SetSelection({Item})
            self.SelectionAnchor = Item
        end
        local Mouse = self.LocalPlayer:GetMouse()
        self:OpenContextMenu(Mouse.X, Mouse.Y)
        self:_FlatRefreshVisibleSelection()
    end)

    return PoolEntry
end

function Explorer:_FlatBuildPath(Inst)
    local Parts = {}
    local Cursor = Inst.Parent
    local Depth = 0

    while Cursor and Cursor ~= game and Depth < 6 do
        Parts[#Parts + 1] = Cursor.Name
        Cursor = Cursor.Parent
        Depth += 1
    end

    if Cursor == nil and Inst.Parent ~= nil then
        Parts[#Parts + 1] = "[nil]"
    end

    local Reversed = {}
    for I = #Parts, 1, -1 do
        Reversed[#Reversed + 1] = Parts[I]
    end

    return table.concat(Reversed, " › ")
end

function Explorer:_FlatBindRow(PoolEntry, Item, IndexY)
    PoolEntry.Item = Item
    PoolEntry.Row.Position = UDim2.new(0, 0, 0, IndexY)
    PoolEntry.Row.Visible = true

    local GoodClass, ClassName = pcall(function() return Item.ClassName end)
    if not GoodClass or type(ClassName) ~= "string" then
        ClassName = "Instance"
    end

    if PoolEntry.IconClassName ~= ClassName then
        local NewIcon = VexUI:CreateClassIcon(ClassName, PoolEntry.Row)
        NewIcon.Size = UDim2.new(0, 16, 0, 16)
        NewIcon.Position = UDim2.new(0, 6, 0.5, -8)
        if PoolEntry.Icon and PoolEntry.Icon ~= NewIcon then
            PoolEntry.Icon:Destroy()
        end
        PoolEntry.Icon = NewIcon
        PoolEntry.IconClassName = ClassName
    end

    local GoodName, Name = pcall(function() return Item.Name end)
    local DisplayName = (GoodName and Name) or "?"

    local HLText, _ = self:_BuildHighlightedName(DisplayName, self.SearchQuery)
    PoolEntry.Label.Text = HLText

    PoolEntry.Path.Text = self:_FlatBuildPath(Item)

    if self.SelectedSet[Item] then
        PoolEntry.Row.BackgroundColor3 = Theme.Selected
        PoolEntry.Row.BackgroundTransparency = 0.4
    else
        PoolEntry.Row.BackgroundColor3 = Theme.Field
        PoolEntry.Row.BackgroundTransparency = 1
    end
end

function Explorer:_FlatHideRow(PoolEntry)
    PoolEntry.Item = nil
    PoolEntry.Row.Visible = false
end

function Explorer:_FlatEnsureContainer()
    local Scroll = self.ExplorerColumn and self.ExplorerColumn.Content
    if not Scroll then return nil end

    if self._FlatResultsContainer and self._FlatResultsContainer.Parent then
        return self._FlatResultsContainer
    end

    local Container = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 0);
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        Visible = false;
        ZIndex = 100;
        Parent = Scroll;
    })

    self._FlatResultsContainer = Container
    self._FlatResultsPool = {}

    return Container
end

function Explorer:_FlatRebuildVisible()
    local Container = self._FlatResultsContainer
    if not Container or not Container.Visible then return end

    local Scroll = self.ExplorerColumn and self.ExplorerColumn.Content
    if not Scroll then return end

    local Items = self._FlatResultsItems or {}
    local Slot = self._FlatRowHeight + self._FlatRowGap

    local CTopOnScreen = Container.AbsolutePosition.Y
    local VTopOnScreen = Scroll.AbsolutePosition.Y
    local ViewHeight = Scroll.AbsoluteSize.Y
    local LayoutNotReady = ViewHeight <= 0 or (CTopOnScreen == 0 and VTopOnScreen == 0)

    local FirstIndex, LastIndex
    if LayoutNotReady then
        FirstIndex = 1
        LastIndex = math.min(#Items, 30)
    else
        local Offset = VTopOnScreen - CTopOnScreen
        FirstIndex = math.max(1, math.floor(Offset / Slot) + 1 - self._FlatBufferRows)
        LastIndex = math.min(#Items, FirstIndex + math.ceil(ViewHeight / Slot) + self._FlatBufferRows * 2)
    end

    local NeededRows = math.max(0, LastIndex - FirstIndex + 1)
    local Pool = self._FlatResultsPool

    while #Pool < NeededRows do
        Pool[#Pool + 1] = self:_FlatAllocateRow(Container)
    end

    for SlotIndex = 1, NeededRows do
        local PoolEntry = Pool[SlotIndex]
        local DataIndex = FirstIndex + SlotIndex - 1
        local Item = Items[DataIndex]
        if Item then
            self:_FlatBindRow(PoolEntry, Item, (DataIndex - 1) * Slot)
        else
            self:_FlatHideRow(PoolEntry)
        end
    end

    for SlotIndex = NeededRows + 1, #Pool do
        self:_FlatHideRow(Pool[SlotIndex])
    end
end

function Explorer:_FlatApplyResults(Matches)
    local Container = self:_FlatEnsureContainer()
    if not Container then return end

    local Items = table.create(#Matches)
    for I = 1, #Matches do
        local Entry = Matches[I]
        if Entry and Entry.Instance and Entry.Instance.Parent ~= nil then
            Items[#Items + 1] = Entry.Instance
        end
    end

    self._FlatResultsItems = Items

    local Slot = self._FlatRowHeight + self._FlatRowGap
    Container.Size = UDim2.new(1, 0, 0, math.max(0, #Items * Slot))
    Container.Visible = true

    self:_FlatRebuildVisible()
    task.defer(function()
        if Container and Container.Parent then
            self:_FlatRebuildVisible()
        end
    end)
end

function Explorer:_FlatHideContainer()
    if self._FlatResultsContainer then
        self._FlatResultsContainer.Visible = false
    end
    self._FlatResultsItems = nil
end

function Explorer:_FlatIsActive()
    return self.FlatSearchResults == true and self.SearchQuery ~= ""
end

function Explorer:_FlatHookScroll()
    if self._FlatScrollConn then return end
    local Scroll = self.ExplorerColumn and self.ExplorerColumn.Content
    if not Scroll then return end

    self._FlatScrollConn = Scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        if self:_FlatIsActive() then
            self:_FlatRebuildVisible()
        end
    end)
end

function Explorer:_FlatRefreshVisibleSelection()
    if not self._FlatResultsPool then return end
    for _, PoolEntry in self._FlatResultsPool do
        if PoolEntry.Item and PoolEntry.Row.Visible then
            if self.SelectedSet[PoolEntry.Item] then
                PoolEntry.Row.BackgroundColor3 = Theme.Selected
                PoolEntry.Row.BackgroundTransparency = 0.4
            else
                PoolEntry.Row.BackgroundColor3 = Theme.Field
                PoolEntry.Row.BackgroundTransparency = 1
            end
        end
    end
end

function Explorer:SetNilFilterClass(Value, Source)
    self.NilFilterClass = Value or ""
    self._SyncingClassFilter = true

    if self.FiltersClassFilterBox
        and self.FiltersClassFilterBox ~= Source
        and self.FiltersClassFilterBox.Text ~= Value
    then
        self.FiltersClassFilterBox.Text = Value
    end

    if self.SettingsClassFilterBox
        and self.SettingsClassFilterBox ~= Source
        and self.SettingsClassFilterBox.Text ~= Value
    then
        self.SettingsClassFilterBox.Text = Value
    end

    self._SyncingClassFilter = false
end

function Explorer:_CheckFreezeSearchMatch(Child)
    if self.ExplorerFrozen then
        return
    end

    local Term = self.FreezeSearchTerm
    if not Term or Term == "" then
        return
    end

    local GoodName, Name = pcall(function()
        return Child.Name
    end)

    if not GoodName or type(Name) ~= "string" then
        return
    end

    if Name:lower():find(Term:lower(), 1, true) then
        self:SetExplorerFrozen(true, `matched "{Name}"`)
    end
end

function Explorer:RebuildExplorer()
    Handle(function()
        if self.ExplorerColumn and self.ExplorerColumn.Clear then
            self.ExplorerColumn:Clear()
        end

        if typeof(self.HiddenServices) ~= "table" then
            self.HiddenServices = {}
        end

        self:_VTreeActivate()

        if not self._RootServiceHooksInstalled then
            self._RootServiceHooksInstalled = true

            Track(game.ChildAdded:Connect(function(Child)
                if typeof(Child) ~= "Instance" then return end
                if self.HiddenServices[Child.Name] then return end

                if self.ExplorerFrozen then
                    self.FrozenPendingAdds[ClonerefInstance(Child)] = true
                    return
                end

                self:_VTreeScheduleRebuild()
            end))

            Track(game.ChildRemoved:Connect(function(Child)
                if typeof(Child) ~= "Instance" then return end

                if self.ExplorerFrozen then
                    self.FrozenPendingRemoves[ClonerefInstance(Child)] = true
                    return
                end

                self:_VTreeScheduleRebuild()
            end))
        end

        if not self.SearchIndexBuilt then
            task.spawn(function() self:BuildSearchIndex() end)
        end
    end, "Function Explorer.RebuildExplorer")
end

function Explorer:_VTreeMakeRowData(Instance, Depth, IsNilContainerSlot)
    return {
        Instance = Instance;
        Depth = Depth;
        Expanded = false;
        HasChildren = false;
        IsNilContainer = IsNilContainerSlot == true;
        RawName = "";
        ClassName = "";
        MatchState = "none";
    }
end

function Explorer:_VTreeRefreshRowMeta(RowData)
    if RowData.IsNilContainer then
        local Count = 0
        local Good, List = pcall(function() return self:_CollectNilInstances() end)
        if Good and type(List) == "table" then
            Count = #List
        end
        RowData.RawName = `Nil Instances ({Count})`
        RowData.ClassName = "Folder"
        RowData.HasChildren = Count > 0
        return
    end

    local Inst = RowData.Instance
    if not Inst then return end

    local GoodName, Name = pcall(function() return Inst.Name end)
    RowData.RawName = (GoodName and Name) or "?"

    local GoodClass, ClassName = pcall(function() return Inst.ClassName end)
    RowData.ClassName = (GoodClass and ClassName) or "Instance"

    local GoodChildren, FirstChild = pcall(function()
        local Kids = WeakGetChildren(Inst)
        return Kids and Kids[1] or nil
    end)
    RowData.HasChildren = GoodChildren and FirstChild ~= nil
end

function Explorer:_VTreeBuildRoots()
    self._VTreeRows = {}
    self._VTreeRowsByInstance = {}
    self._VTreeExpanded = self._VTreeExpanded or {}

    local TempServices = {}
    for _, Service in WeakGetChildren(game) do
        if not self.HiddenServices[Service.Name] and not self.AllServicesHidden then
            TempServices[#TempServices + 1] = Service
        elseif self.AllServicesHidden and self.HiddenServices[Service.Name] == false then
            TempServices[#TempServices + 1] = Service
        end
    end

    TempServices = SortServices(TempServices)

    for _, Service in TempServices do
        local RowData = self:_VTreeMakeRowData(Service, 0, false)
        self:_VTreeRefreshRowMeta(RowData)
        self._VTreeRows[#self._VTreeRows + 1] = RowData
        self._VTreeRowsByInstance[Service] = #self._VTreeRows
    end

    if not self.HideNilContainer then
        local NilRow = self:_VTreeMakeRowData(nil, 0, true)
        self:_VTreeRefreshRowMeta(NilRow)
        self._VTreeRows[#self._VTreeRows + 1] = NilRow
    end
end

function Explorer:_VTreeEnsureContainer()
    local Scroll = self.ExplorerColumn and self.ExplorerColumn.Content
    if not Scroll then return nil end

    if self._VTreeContainer and self._VTreeContainer.Parent then
        return self._VTreeContainer
    end

    local Container = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 0);
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        Visible = false;
        ZIndex = 50;
        Parent = Scroll;
    })

    self._VTreeContainer = Container
    self._VTreePool = {}

    return Container
end

function Explorer:_VTreeBeginRename(PoolEntry, RowData)
    if not PoolEntry or not RowData or not RowData.Instance then return end
    if RowData.IsNilContainer then return end

    local Inst = RowData.Instance
    local Label = PoolEntry.Label
    if not Label or not Label.Parent then return end

    local GoodOld, OldText = pcall(function() return Inst.Name end)
    if not GoodOld or type(OldText) ~= "string" then OldText = RowData.RawName or "" end

    Label.Visible = false

    local Box = VexUI:CreateInstance("TextBox", {
        Size = Label.Size;
        Position = Label.Position;
        BackgroundColor3 = Theme.Field;
        BackgroundTransparency = 0.15;
        BorderSizePixel = 0;
        Font = Label.Font;
        Text = OldText;
        TextColor3 = Theme.Text;
        TextSize = Label.TextSize;
        TextXAlignment = Enum.TextXAlignment.Left;
        ClearTextOnFocus = false;
        ZIndex = (Label.ZIndex or 1) + 1;
        Parent = Label.Parent;
    })
    VexUI:AddStroke(Box, Theme.Accent, 1)

    task.defer(function()
        if Box.Parent then
            Box:CaptureFocus()
            Box.SelectionStart = 1
            Box.CursorPosition = #OldText + 1
        end
    end)

    local Done = false
    local function Finish(Apply)
        if Done then return end
        Done = true

        if Apply then
            local NewName = Box.Text
            if NewName ~= "" and NewName ~= OldText then
                pcall(function() Inst.Name = NewName end)
            end
        end

        if Box.Parent then Box:Destroy() end
        if Label and Label.Parent then Label.Visible = true end
    end

    Box.FocusLost:Connect(function(Enter) Finish(Enter) end)
end

function Explorer:_VTreeAllocateRow(Container)
    local Row = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 0, self._VTreeRowHeight);
        Position = UDim2.new(0, 0, 0, 0);
        BackgroundColor3 = Theme.Field;
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Text = "";
        Visible = false;
        ZIndex = 51;
        Parent = Container;
    })

    local AccentStrip = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(0, 2, 1, 0);
        Position = UDim2.new(0, 0, 0, 0);
        BackgroundColor3 = Theme.Accent;
        BorderSizePixel = 0;
        Visible = false;
        ZIndex = 53;
        Parent = Row;
    })

    BindTheme("Accent", function(Color)
        AccentStrip.BackgroundColor3 = Color
    end)

    local Arrow = VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(0, 14, 0, 14);
        Position = UDim2.new(0, 0, 0.5, -7);
        BackgroundTransparency = 1;
        Font = Fonts.Bold;
        Text = "+";
        TextColor3 = Theme.TextDim;
        TextSize = 16;
        TextXAlignment = Enum.TextXAlignment.Center;
        Visible = false;
        ZIndex = 52;
        Parent = Row;
    })

    local ArrowHit = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(0, 18, 1, 0);
        Position = UDim2.new(0, -2, 0, 0);
        BackgroundTransparency = 1;
        Text = "";
        AutoButtonColor = false;
        ZIndex = 53;
        Parent = Row;
    })

    local Icon = VexUI:CreateInstance("ImageLabel", {
        Size = UDim2.new(0, 16, 0, 16);
        Position = UDim2.new(0, 18, 0.5, -8);
        BackgroundTransparency = 1;
        Image = "";
        ScaleType = Enum.ScaleType.Fit;
        ZIndex = 52;
        Parent = Row;
    })

    local Label = VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0);
        Position = UDim2.new(0, 38, 0, 0);
        BackgroundTransparency = 1;
        Font = Fonts.Medium;
        RichText = true;
        Text = "";
        TextColor3 = Theme.Text;
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextTruncate = Enum.TextTruncate.AtEnd;
        ZIndex = 52;
        Parent = Row;
    })

    local PoolEntry = {
        Row = Row;
        AccentStrip = AccentStrip;
        Arrow = Arrow;
        ArrowHit = ArrowHit;
        Icon = Icon;
        Label = Label;
        IconClassName = nil;
        Bound = nil;
    }

    Row.MouseEnter:Connect(function()
        local RowData = PoolEntry.Bound
        if RowData and RowData.Instance and not self.SelectedSet[RowData.Instance] then
            Row.BackgroundTransparency = 0.85
        end
    end)

    Row.MouseLeave:Connect(function()
        local RowData = PoolEntry.Bound
        if RowData and RowData.Instance and not self.SelectedSet[RowData.Instance] then
            Row.BackgroundTransparency = 1
        end
    end)

    ArrowHit.MouseButton1Click:Connect(function()
        local RowData = PoolEntry.Bound
        if not RowData or not RowData.HasChildren then return end
        if self._VTreeFilterActive then
            if RowData.Expanded then
                self:_VTreeCollapseFiltered(RowData)
            else
                self:_VTreeExpandFiltered(RowData)
            end
        elseif RowData.Expanded then
            self:_VTreeCollapse(RowData)
        else
            self:_VTreeExpand(RowData)
        end
    end)

    local LastClickAt = 0
    Row.MouseButton1Click:Connect(function()
        local RowData = PoolEntry.Bound
        if not RowData then return end
        if RowData.IsNilContainer then return end

        local Inst = RowData.Instance
        if not Inst then return end

        if self._JustDragged or self.JustDragged then return end

        if self.ReparentMode then
            self:CommitReparent(Inst)
            return
        end

        local Now = os.clock()
        if Now - LastClickAt < 0.35 then
            LastClickAt = 0

            local IsScript = false
            local Cls = RowData.ClassName
            if Cls == "LocalScript" or Cls == "ModuleScript" then
                IsScript = true
            elseif Cls == "Script" then
                local Good, RC = pcall(function() return Inst.RunContext end)
                if Good and RC == Enum.RunContext.Client then
                    IsScript = true
                end
            end

            if IsScript then
                self:OpenScriptViewer(Inst, true)
            else
                self:_VTreeBeginRename(PoolEntry, RowData)
            end
            return
        end
        LastClickAt = Now

        if self.ShiftHeld and self.SelectionAnchor then
            local Rows = self:_VTreeActiveRows()
            local AnchorIdx, TargetIdx
            for I = 1, #Rows do
                local RI = Rows[I].Instance
                if RI == self.SelectionAnchor then AnchorIdx = I end
                if RI == Inst then TargetIdx = I end
                if AnchorIdx and TargetIdx then break end
            end
            if AnchorIdx and TargetIdx then
                if AnchorIdx > TargetIdx then AnchorIdx, TargetIdx = TargetIdx, AnchorIdx end
                local NewSel = {}
                for I = AnchorIdx, TargetIdx do
                    local RI = Rows[I].Instance
                    if RI then table.insert(NewSel, RI) end
                end
                self:SetSelection(NewSel)
            else
                self:SetSelection({Inst})
                self.SelectionAnchor = Inst
            end
        elseif self.CtrlHeld then
            local New = {}
            for _, Existing in self.SelectedOrder do
                table.insert(New, Existing)
            end
            if self.SelectedSet[Inst] then
                for I, V in New do
                    if V == Inst then table.remove(New, I); break end
                end
            else
                table.insert(New, Inst)
            end
            self:SetSelection(New)
        else
            self:SetSelection({Inst})
            self.SelectionAnchor = Inst
        end

        self:_VTreeRefreshVisibleSelection()
    end)

    Row.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            local RowData = PoolEntry.Bound
            if not RowData or not RowData.Instance or RowData.IsNilContainer then return end
            self.DragOperation = {
                StartX = Input.Position.X;
                StartY = Input.Position.Y;
                HasStarted = false;
                Source = RowData.Instance;
                SourceName = SafeGet(RowData.Instance, "Name") or "?";
            }
        elseif Input.UserInputType == Enum.UserInputType.MouseButton3 then
            local RowData = PoolEntry.Bound
            if RowData and RowData.Instance then
                self:ToggleViewObject(RowData.Instance)
            end
        end
    end)

    Row.MouseButton2Click:Connect(function()
        local RowData = PoolEntry.Bound
        if not RowData or not RowData.Instance then return end

        if not self.SelectedSet[RowData.Instance] then
            self:SetSelection({RowData.Instance})
            self.SelectionAnchor = RowData.Instance
        end
        local Mouse = self.LocalPlayer:GetMouse()
        self:OpenContextMenu(Mouse.X, Mouse.Y)
        self:_VTreeRefreshVisibleSelection()
    end)

    return PoolEntry
end

function Explorer:_VTreeBindRow(PoolEntry, RowData, YPos)
    PoolEntry.Bound = RowData

    local Row = PoolEntry.Row

    if RowData.IsTruncationNotice then
        Row.Position = UDim2.new(0, 0, 0, YPos)
        Row.Visible = true
        Row.BackgroundTransparency = 1
        PoolEntry.AccentStrip.Visible = false
        PoolEntry.Arrow.Visible = false
        PoolEntry.ArrowHit.Visible = false
        VexUI:ApplyClassIcon(PoolEntry.Icon, nil)
        PoolEntry.Icon.ImageTransparency = 1
        PoolEntry.IconClassName = nil
        PoolEntry.Label.Position = UDim2.new(0, 12, 0, 0)
        PoolEntry.Label.Size = UDim2.new(1, -16, 1, 0)
        PoolEntry.Label.Font = Fonts.Medium
        PoolEntry.Label.Text = self:_EscapeRichText(RowData.RawName)
        PoolEntry.Label.TextColor3 = Theme.TextFaded
        return
    end

    if RowData.Instance and not RowData.IsNilContainer then
        local GoodN, FreshName = pcall(function() return RowData.Instance.Name end)
        if GoodN and FreshName and FreshName ~= RowData.RawName then
            if self._VTreeHighlightCache then
                self._VTreeHighlightCache[RowData.RawName] = nil
            end
            RowData.RawName = FreshName
        end
        self:_VTreeEnsureInstanceHooks(RowData.Instance)
    end

    Row.Position = UDim2.new(0, 0, 0, YPos)
    Row.Visible = true

    local IndentPx = RowData.Depth * self._VTreeIndent + 4

    if RowData.HasChildren then
        PoolEntry.Arrow.Visible = true
        PoolEntry.Arrow.Text = RowData.Expanded and "-" or "+"
        PoolEntry.Arrow.Position = UDim2.new(0, IndentPx, 0.5, -7)
        PoolEntry.ArrowHit.Position = UDim2.new(0, IndentPx - 2, 0, 0)
        PoolEntry.ArrowHit.Visible = true
    else
        PoolEntry.Arrow.Visible = false
        PoolEntry.ArrowHit.Visible = false
    end

    local ClassName = RowData.ClassName
    if PoolEntry.IconClassName ~= ClassName then
        VexUI:ApplyClassIcon(PoolEntry.Icon, ClassName)
        PoolEntry.IconClassName = ClassName
    end

    PoolEntry.Icon.Position = UDim2.new(0, IndentPx + 16, 0.5, -8)
    PoolEntry.Label.Position = UDim2.new(0, IndentPx + 36, 0, 0)
    PoolEntry.Label.Size = UDim2.new(1, -(IndentPx + 40), 1, 0)
    PoolEntry.Label.Font = RowData.Depth == 0 and Fonts.SemiBold or Fonts.Medium

    local Query = self.SearchQuery or ""
    local IsMatched = (not RowData.IsNilContainer)
        and RowData.Instance
        and self.MatchSet
        and self.MatchSet[RowData.Instance] == true

    if Query ~= "" and IsMatched then
        local Cache = self._VTreeHighlightCache
        if not Cache then
            Cache = {}
            self._VTreeHighlightCache = Cache
        end
        local HLText = Cache[RowData.RawName]
        if not HLText then
            HLText = self:_BuildHighlightedName(RowData.RawName, Query)
            Cache[RowData.RawName] = HLText
        end
        PoolEntry.Label.Text = HLText
    else
        PoolEntry.Label.Text = self:_EscapeRichText(RowData.RawName)
    end

    if Query ~= "" then
        if RowData.IsNilContainer then
            PoolEntry.Label.TextColor3 = Theme.Accent
        elseif IsMatched then
            PoolEntry.Label.TextColor3 = Theme.Accent
        elseif self.SubtreeMatchSet and self.SubtreeMatchSet[RowData.Instance] then
            PoolEntry.Label.TextColor3 = Theme.TextDim
        else
            PoolEntry.Label.TextColor3 = Theme.TextFaded
        end
    else
        PoolEntry.Label.TextColor3 = Theme.Text
    end

    local Selected = RowData.Instance and self.SelectedSet[RowData.Instance]
    if Selected then
        Row.BackgroundColor3 = Theme.Selected
        Row.BackgroundTransparency = 0.55
        PoolEntry.AccentStrip.Visible = true
    else
        Row.BackgroundColor3 = Theme.Field
        Row.BackgroundTransparency = 1
        PoolEntry.AccentStrip.Visible = false
    end
end

function Explorer:_VTreeHideRow(PoolEntry)
    PoolEntry.Bound = nil
    PoolEntry.Row.Visible = false
end

function Explorer:_VTreeRefreshVisibleSelection()
    if not self._VTreePool then return end
    for _, PoolEntry in self._VTreePool do
        local RowData = PoolEntry.Bound
        if RowData and PoolEntry.Row.Visible then
            local Inst = RowData.Instance
            if Inst and self.SelectedSet[Inst] then
                PoolEntry.Row.BackgroundColor3 = Theme.Selected
                PoolEntry.Row.BackgroundTransparency = 0.55
                PoolEntry.AccentStrip.Visible = true
            else
                PoolEntry.Row.BackgroundColor3 = Theme.Field
                PoolEntry.Row.BackgroundTransparency = 1
                PoolEntry.AccentStrip.Visible = false
            end
        end
    end
end

function Explorer:_VTreeRebuildVisible()
    self._VTreeRebuildScheduled = false

    local Container = self._VTreeContainer
    if not Container or not Container.Visible then return end

    local Scroll = self.ExplorerColumn and self.ExplorerColumn.Content
    if not Scroll then return end

    local Rows = self:_VTreeActiveRows()
    local Slot = self._VTreeRowHeight + self._VTreeRowGap

    local CTopOnScreen = Container.AbsolutePosition.Y
    local VTopOnScreen = Scroll.AbsolutePosition.Y
    local ViewHeight = Scroll.AbsoluteSize.Y
    local LayoutNotReady = ViewHeight <= 0 or (CTopOnScreen == 0 and VTopOnScreen == 0)

    local FirstIndex, LastIndex
    if LayoutNotReady then
        FirstIndex = 1
        LastIndex = math.min(#Rows, 40)
    else
        local Offset = VTopOnScreen - CTopOnScreen
        FirstIndex = math.max(1, math.floor(Offset / Slot) + 1 - self._VTreeBufferRows)
        LastIndex = math.min(#Rows, FirstIndex + math.ceil(ViewHeight / Slot) + self._VTreeBufferRows * 2)
    end

    if self._VTreeLastFirstIndex == FirstIndex
        and self._VTreeLastLastIndex == LastIndex
        and self._VTreeLastRowCount == #Rows
    then
        return
    end
    self._VTreeLastFirstIndex = FirstIndex
    self._VTreeLastLastIndex = LastIndex
    self._VTreeLastRowCount = #Rows

    local NeededRows = math.max(0, LastIndex - FirstIndex + 1)
    local Pool = self._VTreePool

    while #Pool < NeededRows do
        Pool[#Pool + 1] = self:_VTreeAllocateRow(Container)
    end

    for SlotIndex = 1, NeededRows do
        local PoolEntry = Pool[SlotIndex]
        local DataIndex = FirstIndex + SlotIndex - 1
        local RowData = Rows[DataIndex]
        if RowData then
            self:_VTreeBindRow(PoolEntry, RowData, (DataIndex - 1) * Slot)
        else
            self:_VTreeHideRow(PoolEntry)
        end
    end

    for SlotIndex = NeededRows + 1, #Pool do
        self:_VTreeHideRow(Pool[SlotIndex])
    end
end

function Explorer:_VTreeInvalidateVisibleCache()
    self._VTreeLastFirstIndex = nil
    self._VTreeLastLastIndex = nil
    self._VTreeLastRowCount = nil
end

function Explorer:_VTreeEnsureInstanceHooks(Inst)
    if not Inst then return end

    self._VTreeNameConns = self._VTreeNameConns or setmetatable({}, {__mode = "k"})
    if not self._VTreeNameConns[Inst] then
        local GoodSig, Sig = pcall(function()
            return Inst:GetPropertyChangedSignal("Name")
        end)
        if GoodSig and Sig then
            self._VTreeNameConns[Inst] = Track(Sig:Connect(function()
                local GoodN, NN = pcall(function() return Inst.Name end)
                if GoodN then
                    self:_VTreeUpdateInstanceName(Inst, NN or "?")
                end
            end))
        end
    end

    self:_VTreeHookAncestryFor(Inst)
end

function Explorer:_VTreeUpdateCanvasSize()
    local Container = self._VTreeContainer
    if not Container then return end

    local Rows = self:_VTreeActiveRows()
    local Slot = self._VTreeRowHeight + self._VTreeRowGap
    Container.Size = UDim2.new(1, 0, 0, math.max(0, #Rows * Slot))
end

function Explorer:_VTreeActiveRows()
    if self._VTreeFilterActive and self._VTreeFilteredRows then
        return self._VTreeFilteredRows
    end
    return self._VTreeRows or {}
end

function Explorer:_VTreeScheduleRebuild()
    if self._VTreeRebuildScheduled then return end
    self._VTreeRebuildScheduled = true

    local RenderConn
    RenderConn = Services.RunService.PreRender:Connect(function()
        RenderConn:Disconnect()
        self._VTreeRebuildScheduled = false
        self:_VTreeRebuildVisible()
    end)
end

function Explorer:_VTreeHookScroll()
    if self._VTreeScrollConn then return end
    local Scroll = self.ExplorerColumn and self.ExplorerColumn.Content
    if not Scroll then return end

    self._VTreeScrollConn = Scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        self:_VTreeScheduleRebuild()

        if self._VTreeFilterActive
            and self._VTreeFilteredResume
            and not self._VTreeFilteredExhausted
        then
            local Y = Scroll.CanvasPosition.Y
            local Bottom = Y + Scroll.AbsoluteSize.Y
            local CanvasH = Scroll.AbsoluteCanvasSize.Y
            if CanvasH - Bottom < Scroll.AbsoluteSize.Y * 1.5 then
                if not self._VTreeStreamScheduled then
                    self._VTreeStreamScheduled = true
                    task.defer(function()
                        self._VTreeStreamScheduled = false
                        if self._VTreeFilteredResume then
                            self._VTreeFilteredResume()
                        end
                    end)
                end
            end
        end

        if self._VTreeNilResume and not self._VTreeNilExhausted then
            local Y = Scroll.CanvasPosition.Y
            local Bottom = Y + Scroll.AbsoluteSize.Y
            local CanvasH = Scroll.AbsoluteCanvasSize.Y
            if CanvasH - Bottom < Scroll.AbsoluteSize.Y * 1.5 then
                if not self._VTreeNilStreamScheduled then
                    self._VTreeNilStreamScheduled = true
                    task.defer(function()
                        self._VTreeNilStreamScheduled = false
                        if self._VTreeNilResume then
                            self._VTreeNilResume()
                        end
                    end)
                end
            end
        end
    end)
end

function Explorer:_VTreeExpandFiltered(RowData)
    if not RowData or RowData.Expanded then return end
    if not RowData.HasChildren then return end

    if RowData.IsNilContainer then
        if not self._VTreeFilteredExpanded then
            self._VTreeFilteredExpanded = {}
        end
        self._VTreeFilteredExpanded.__NilContainer = true
        self:_VTreeBuildFiltered()
        self:_VTreeUpdateCanvasSize()
        self:_VTreeScheduleRebuild()
        return
    end

    local Inst = RowData.Instance
    if not Inst then return end

    if not self._VTreeFilteredExpanded then
        self._VTreeFilteredExpanded = {}
    end
    self._VTreeFilteredExpanded[Inst] = true
    self:_VTreeBuildFiltered()
    self:_VTreeUpdateCanvasSize()
    self:_VTreeScheduleRebuild()
end

function Explorer:_VTreeCollapseFiltered(RowData)
    if not RowData or not RowData.Expanded then return end

    if RowData.IsNilContainer then
        if not self._VTreeFilteredExpanded then
            self._VTreeFilteredExpanded = {}
        end
        self._VTreeFilteredExpanded.__NilContainer = false
        self:_VTreeBuildFiltered()
        self:_VTreeUpdateCanvasSize()
        self:_VTreeScheduleRebuild()
        return
    end

    local Inst = RowData.Instance
    if not Inst then return end

    if not self._VTreeFilteredExpanded then
        self._VTreeFilteredExpanded = {}
    end
    self._VTreeFilteredExpanded[Inst] = false
    self:_VTreeBuildFiltered()
    self:_VTreeUpdateCanvasSize()
    self:_VTreeScheduleRebuild()
end

function Explorer:_VTreeExpand(RowData)
    if not RowData or RowData.Expanded then return end
    if not RowData.HasChildren then return end

    if self._VTreeFilterActive then
        self:_VTreeExpandFiltered(RowData)
        return
    end

    RowData.Expanded = true

    if RowData.IsNilContainer then
        self:_VTreeStartNilStream(RowData)
        return
    end

    local ParentInst = RowData.Instance
    if not ParentInst then return end

    self._VTreeExpanded[ParentInst] = true

    local ParentIndex = self._VTreeRowsByInstance[ParentInst]
    if not ParentIndex then return end

    local Children = self:_VTreeGetSortedChildren(ParentInst)
    if #Children == 0 then
        RowData.HasChildren = false
        self:_VTreeUpdateCanvasSize()
        self:_VTreeScheduleRebuild()
        return
    end

    local InsertAt = ParentIndex + 1
    local Rows = self._VTreeRows
    local Count = #Children

    local OldLen = #Rows
    for I = OldLen, InsertAt, -1 do
        Rows[I + Count] = Rows[I]
    end

    for I, Child in Children do
        local ChildRow = self:_VTreeMakeRowData(Child, RowData.Depth + 1, false)
        self:_VTreeRefreshRowMeta(ChildRow)
        Rows[InsertAt + I - 1] = ChildRow
        self._VTreeRowsByInstance[Child] = InsertAt + I - 1

        if self._VTreeExpanded[Child] and ChildRow.HasChildren then
            task.defer(function()
                if ChildRow.Instance and ChildRow.Instance.Parent then
                    ChildRow.Expanded = false
                    self:_VTreeExpand(ChildRow)
                end
            end)
        end
    end

    self:_VTreeReindexRows(InsertAt + Count)

    if self._VTreeFilterActive and not self._VTreeSuppressFilterRebuild then
        self:_VTreeBuildFiltered()
    end

    self:_VTreeUpdateCanvasSize()
    self:_VTreeInvalidateVisibleCache()
    self:_VTreeScheduleRebuild()
end

function Explorer:_VTreeCollapse(RowData)
    if not RowData or not RowData.Expanded then return end

    if self._VTreeFilterActive then
        self:_VTreeCollapseFiltered(RowData)
        return
    end

    RowData.Expanded = false

    if RowData.IsNilContainer then
        self._VTreeNilStreamToken = (self._VTreeNilStreamToken or 0) + 1
        self._VTreeNilResume = nil
        self._VTreeNilExhausted = false

        local ContainerIdx
        for I, R in self._VTreeRows do
            if R == RowData then
                ContainerIdx = I
                break
            end
        end
        if not ContainerIdx then
            self:_VTreeUpdateCanvasSize()
            self:_VTreeScheduleRebuild()
            return
        end

        local Rows = self._VTreeRows
        local RemoveStart = ContainerIdx + 1
        local RemoveEnd = ContainerIdx
        local ParentDepth = RowData.Depth

        for I = ContainerIdx + 1, #Rows do
            if Rows[I].Depth > ParentDepth then
                RemoveEnd = I
            else
                break
            end
        end

        if RemoveEnd >= RemoveStart then
            for I = RemoveStart, RemoveEnd do
                local R = Rows[I]
                if R.Instance then
                    self._VTreeRowsByInstance[R.Instance] = nil
                end
            end

            local RemoveCount = RemoveEnd - RemoveStart + 1
            local Len = #Rows
            for I = RemoveEnd + 1, Len do
                Rows[I - RemoveCount] = Rows[I]
            end
            for I = Len, Len - RemoveCount + 1, -1 do
                Rows[I] = nil
            end

            self:_VTreeReindexRows(RemoveStart)
        end

        self:_VTreeUpdateCanvasSize()
        self:_VTreeInvalidateVisibleCache()
        self:_VTreeScheduleRebuild()

        return
    end

    local ParentInst = RowData.Instance
    if not ParentInst then return end

    self._VTreeExpanded[ParentInst] = nil

    local ParentIndex = self._VTreeRowsByInstance[ParentInst]
    if not ParentIndex then return end

    local Rows = self._VTreeRows
    local ParentDepth = RowData.Depth
    local RemoveStart = ParentIndex + 1
    local RemoveEnd = ParentIndex

    for I = ParentIndex + 1, #Rows do
        if Rows[I].Depth > ParentDepth then
            RemoveEnd = I
        else
            break
        end
    end

    if RemoveEnd >= RemoveStart then
        for I = RemoveStart, RemoveEnd do
            local R = Rows[I]
            if R.Instance then
                self._VTreeRowsByInstance[R.Instance] = nil
            end
        end

        local RemoveCount = RemoveEnd - RemoveStart + 1
        local Len = #Rows
        for I = RemoveEnd + 1, Len do
            Rows[I - RemoveCount] = Rows[I]
        end
        for I = Len, Len - RemoveCount + 1, -1 do
            Rows[I] = nil
        end

        self:_VTreeReindexRows(RemoveStart)
    end

    if self._VTreeFilterActive and not self._VTreeSuppressFilterRebuild then
        self:_VTreeBuildFiltered()
    end

    self:_VTreeUpdateCanvasSize()
    self:_VTreeInvalidateVisibleCache()
    self:_VTreeScheduleRebuild()
end

function Explorer:_VTreeRevealInstance(Inst, Options)
    if not Inst then return end
    Options = Options or {}

    local Chain = {}

    local GoodP, Cur = pcall(function() return Inst.Parent end)
    if GoodP then Cur = Cur end
    while Cur and Cur ~= game do
        table.insert(Chain, 1, Cur)
        local GoodCur, P = pcall(function() return Cur.Parent end)
        if not GoodCur then break end
        Cur = P
    end

    self._VTreeSuppressFilterRebuild = true
    for _, Ancestor in Chain do
        local Idx = self._VTreeRowsByInstance[Ancestor]
            or self:_VTreeResolveRowIndex(Ancestor)
        if Idx then
            local Row = self._VTreeRows[Idx]
            if Row and Row.HasChildren and not Row.Expanded then
                self:_VTreeExpand(Row)
            end
        end
    end
    self._VTreeSuppressFilterRebuild = false

    self:_VTreeUpdateCanvasSize()

    if Options.Select then
        self:SetSelection({Inst})
        self.SelectionAnchor = Inst
    end

    local TargetIdx = self._VTreeRowsByInstance[Inst]
        or self:_VTreeResolveRowIndex(Inst)

    if not TargetIdx then
        self:_VTreeScheduleRebuild()
        return
    end

    local Scroll = self.ExplorerColumn and self.ExplorerColumn.Content
    if Scroll then
        local RowH = self._VTreeRowHeight or 22
        local TargetY = (TargetIdx - 1) * RowH
        local ViewH = Scroll.AbsoluteSize.Y
        local CurTop = Scroll.CanvasPosition.Y
        local CurBot = CurTop + ViewH

        if TargetY < CurTop or TargetY + RowH > CurBot then
            local NewY = math.max(0, TargetY - math.floor(ViewH / 2) + RowH)
            Scroll.CanvasPosition = Vector2.new(Scroll.CanvasPosition.X, NewY)
        end
    end

    if Options.Select then
        self:SetSelection({Inst})
        self.SelectionAnchor = Inst
    end

    self:_VTreeInvalidateVisibleCache()
    self:_VTreeScheduleRebuild()
end

function Explorer:_VTreeFindChildInsertIndex(ParentInst, NewChild)
    local ParentIndex = self._VTreeRowsByInstance[ParentInst]
    if not ParentIndex then return nil end

    local Rows = self._VTreeRows
    local ParentDepth = Rows[ParentIndex].Depth
    local ChildDepth = ParentDepth + 1

    local NewClass = NewChild.ClassName
    local NewPriority = ClassPriority[NewClass] or 999
    local NewName = (NewChild.Name or ""):lower()
    local InsertAt = ParentIndex + 1

    for I = ParentIndex + 1, #Rows do
        local R = Rows[I]
        if R.Depth <= ParentDepth then
            return I
        end
        if R.Depth == ChildDepth then
            local ExistingClass = R.ClassName
            if not ExistingClass and R.Instance then
                local Good, C = pcall(function() return R.Instance.ClassName end)
                if Good then ExistingClass = C end
            end
            local ExistingPriority = ClassPriority[ExistingClass or ""] or 999
            local ExistingName = (R.RawName or ""):lower()

            local NewComesFirst
            if NewPriority ~= ExistingPriority then
                NewComesFirst = NewPriority < ExistingPriority
            elseif NewName ~= ExistingName then
                NewComesFirst = NewName < ExistingName
            else
                NewComesFirst = (NewClass or "") < (ExistingClass or "")
            end

            if NewComesFirst then
                return I
            end
            InsertAt = I + 1
        end
    end

    return InsertAt
end

function Explorer:_VTreeInsertChildRow(ParentInst, NewChild)
    if not ParentInst or not NewChild then return end
    if self._VTreeRowsByInstance[NewChild] then return end

    local ParentIndex = self._VTreeRowsByInstance[ParentInst]
    if not ParentIndex then return end

    local ParentRow = self._VTreeRows[ParentIndex]
    if not ParentRow then return end

    if not ParentRow.HasChildren then
        ParentRow.HasChildren = true
    end

    if not ParentRow.Expanded then
        self:_VTreeScheduleRebuild()

        return
    end

    local InsertAt = self:_VTreeFindChildInsertIndex(ParentInst, NewChild)
    if not InsertAt then return end

    local Rows = self._VTreeRows
    local ChildRow = self:_VTreeMakeRowData(NewChild, ParentRow.Depth + 1, false)
    self:_VTreeRefreshRowMeta(ChildRow)

    local OldLen = #Rows
    for I = OldLen, InsertAt, -1 do
        Rows[I + 1] = Rows[I]
    end
    Rows[InsertAt] = ChildRow

    self:_VTreeReindexRows(InsertAt)

    if self._VTreeFilterActive then
        self:_VTreeBuildFiltered()
    end

    self:_VTreeUpdateCanvasSize()
    self:_VTreeStabiliseScrollAroundInsert(InsertAt, 1)
    self:_VTreeInvalidateVisibleCache()
    self:_VTreeScheduleRebuild()
end

function Explorer:_VTreeRemoveInstanceRow(Inst)
    if not Inst then return end

    local Rows = self._VTreeRows
    if not Rows then return end

    local Index = self._VTreeRowsByInstance[Inst] or self:_VTreeResolveRowIndex(Inst)

    if not Index then
        local GoodParent, ParentInst = pcall(function() return Inst.Parent end)
        if not GoodParent or not ParentInst then return end

        local ParentIndex = self._VTreeRowsByInstance[ParentInst]
            or self:_VTreeResolveRowIndex(ParentInst)
        if not ParentIndex then return end

        local ParentRow = Rows[ParentIndex]
        if not ParentRow then return end

        local StillHasKids = false
        local PDepth = ParentRow.Depth
        for I = ParentIndex + 1, #Rows do
            local R = Rows[I]
            if R.Depth <= PDepth then break end
            if R.Depth == PDepth + 1 then StillHasKids = true; break end
        end

        if not StillHasKids then
            local GoodKids, Kids = pcall(function() return WeakGetChildren(ParentInst) end)
            local HasKids = false
            if GoodKids and Kids then
                for _, Child in Kids do
                    if Child ~= Inst then HasKids = true; break end
                end
            end
            if ParentRow.HasChildren ~= HasKids then
                ParentRow.HasChildren = HasKids
                if not HasKids then
                    ParentRow.Expanded = false
                    if self._VTreeExpanded then
                        self._VTreeExpanded[ParentInst] = nil
                    end
                end
                self:_VTreeInvalidateVisibleCache()
                self:_VTreeScheduleRebuild()
            end
        end
        return
    end

    local TargetRow = Rows[Index]
    local TargetDepth = TargetRow.Depth

    local RemoveEnd = Index
    for I = Index + 1, #Rows do
        if Rows[I].Depth > TargetDepth then
            RemoveEnd = I
        else
            break
        end
    end

    for I = Index, RemoveEnd do
        local R = Rows[I]
        if R.Instance then
            self._VTreeRowsByInstance[R.Instance] = nil
            self._VTreeExpanded[R.Instance] = nil
        end
    end

    local RemoveCount = RemoveEnd - Index + 1
    local Len = #Rows
    for I = RemoveEnd + 1, Len do
        Rows[I - RemoveCount] = Rows[I]
    end
    for I = Len, Len - RemoveCount + 1, -1 do
        Rows[I] = nil
    end

    self:_VTreeReindexRows(Index)

    local ParentInst
    local GoodParent, P = pcall(function() return Inst.Parent end)
    if GoodParent then ParentInst = P end
    if ParentInst then
        local ParentIndex = self._VTreeRowsByInstance[ParentInst]
        if ParentIndex then
            local ParentRow = Rows[ParentIndex]
            if ParentRow then
                local StillHasKids = false
                local PDepth = ParentRow.Depth
                for I = ParentIndex + 1, #Rows do
                    local R = Rows[I]
                    if R.Depth <= PDepth then break end
                    if R.Depth == PDepth + 1 then StillHasKids = true; break end
                end
                if ParentRow.HasChildren ~= StillHasKids then
                    ParentRow.HasChildren = StillHasKids
                    if not StillHasKids then
                        ParentRow.Expanded = false
                        self._VTreeExpanded[ParentInst] = nil
                    end
                end
            end
        end
    end

    self:_VTreeUpdateCanvasSize()
    self:_VTreeStabiliseScrollAroundRemove(Index, RemoveCount)
    self:_VTreeInvalidateVisibleCache()
    self:_VTreeScheduleRebuild()
end

function Explorer:_VTreeUpdateInstanceName(Inst, NewName)
    local Index = self._VTreeRowsByInstance[Inst]
    if not Index then return end
    local RowData = self._VTreeRows[Index]
    if not RowData then return end

    RowData.RawName = NewName

    if self._VTreeFilterActive then
        self:_VTreeBuildFiltered()
        self:_VTreeUpdateCanvasSize()
    end

    self:_VTreeInvalidateVisibleCache()
    self:_VTreeScheduleRebuild()
end

function Explorer:_VTreeHookAncestryFor(Inst)
    self._VTreeAncestryConns = self._VTreeAncestryConns or setmetatable({}, {__mode = "k"})
    if self._VTreeAncestryConns[Inst] then return end

    local GoodSig, Sig = pcall(function() return Inst.AncestryChanged end)
    if not GoodSig or not Sig then return end

    self._VTreeAncestryConns[Inst] = Track(Sig:Connect(function(_, NewParent)
        task.defer(function()
            local OldIdx = self._VTreeRowsByInstance[Inst]
            if not OldIdx then return end

            local GoodP, RealParent = pcall(function() return Inst.Parent end)
            if not GoodP then return end

            if not RealParent then
                self:_VTreeRemoveInstanceRow(Inst)
                return
            end

            self:_VTreeRemoveInstanceRow(Inst)

            local ParentIdx = self._VTreeRowsByInstance[RealParent]
                or self:_VTreeResolveRowIndex(RealParent)
            if ParentIdx then
                local CanonicalParent = self._VTreeRows[ParentIdx].Instance
                self:_VTreeInsertChildRow(CanonicalParent or RealParent, Inst)
            end
        end)
    end))
end

function Explorer:_VTreeHookGameSignals()
    if self._VTreeGameSignalsHooked then return end
    self._VTreeGameSignalsHooked = true

    self._VTreeAddedConn = Track(game.DescendantAdded:Connect(function(Inst)
        task.defer(function()
            local GoodParent, Parent = pcall(function() return Inst.Parent end)
            if not GoodParent or not Parent then return end

            if Parent == game then
                if self._VTreeRowsByInstance[Inst] then return end

                local InsertAt = 1
                local Rows = self._VTreeRows
                local NewName = (Inst.Name or ""):lower()
                for I = 1, #Rows do
                    local R = Rows[I]
                    if R.Depth == 0 and not R.IsNilContainer then
                        if (R.RawName or ""):lower() > NewName then
                            InsertAt = I
                            break
                        end
                        InsertAt = I + 1
                    end
                end

                local NewRow = self:_VTreeMakeRowData(Inst, 0, false)
                self:_VTreeRefreshRowMeta(NewRow)
                local OldLen = #Rows
                for I = OldLen, InsertAt, -1 do
                    Rows[I + 1] = Rows[I]
                end

                Rows[InsertAt] = NewRow
                self:_VTreeReindexRows(InsertAt)
                self:_VTreeStabiliseScrollAroundInsert(InsertAt, 1)
                self:_VTreeUpdateCanvasSize()
                self:_VTreeInvalidateVisibleCache()
                self:_VTreeScheduleRebuild()
                return
            end

            if self._VTreeRowsByInstance[Inst] then return end

            local ParentIdx = self._VTreeRowsByInstance[Parent]
                or self:_VTreeResolveRowIndex(Parent)
            if ParentIdx then
                local CanonicalParent = self._VTreeRows[ParentIdx].Instance
                self:_VTreeInsertChildRow(CanonicalParent or Parent, Inst)
            end
        end)
    end))

    self._VTreeRemovingConn = Track(game.DescendantRemoving:Connect(function(Inst)
        self:_VTreeRemoveInstanceRow(Inst)

        if self._VTreeNameConns and self._VTreeNameConns[Inst] then
            pcall(function() self._VTreeNameConns[Inst]:Disconnect() end)
            self._VTreeNameConns[Inst] = nil
        end

        if self._VTreeAncestryConns and self._VTreeAncestryConns[Inst] then
            pcall(function() self._VTreeAncestryConns[Inst]:Disconnect() end)
            self._VTreeAncestryConns[Inst] = nil
        end
    end))
end

function Explorer:_VTreeResolveRowIndex(Inst)
    local Idx = self._VTreeRowsByInstance[Inst]
    if Idx then
        return Idx
    end

    local GoodName, Name = pcall(function()
        return Inst.Name
    end)

    if not GoodName or not Name then
        return nil
    end

    local Chain = {Name}
    local Cursor

    local GoodParent, ParentInst = pcall(function()
        return Inst.Parent
    end)

    Cursor = GoodParent and ParentInst or nil

    local Safety = 0
    while Cursor and Cursor ~= game and Safety < 64 do
        local GoodCursorName, CursorName = pcall(function()
            return Cursor.Name
        end)

        if not GoodCursorName or not CursorName then
            return nil
        end

        Chain[#Chain + 1] = CursorName

        local GoodCursorParent, CursorParent = pcall(function()
            return Cursor.Parent
        end)

        Cursor = GoodCursorParent and CursorParent or nil
        Safety += 1
    end

    if Cursor ~= game then
        return nil
    end

    local CurrentIdx
    local CurrentDepth = -1

    for I = #Chain, 1, -1 do
        local SegName = Chain[I]
        local TargetDepth = CurrentDepth + 1

        if not CurrentIdx then
            for J = 1, #self._VTreeRows do
                local Row = self._VTreeRows[J]
                if Row.Depth == 0
                    and not Row.IsNilContainer
                    and Row.RawName == SegName
                then
                    CurrentIdx = J
                    CurrentDepth = 0
                    break
                end
            end

            if not CurrentIdx then
                return nil
            end
        else
            local Found

            for J = CurrentIdx + 1, #self._VTreeRows do
                local Row = self._VTreeRows[J]

                if Row.Depth <= CurrentDepth then
                    break
                end

                if Row.Depth == TargetDepth and Row.RawName == SegName then
                    Found = J
                    break
                end
            end

            if not Found then
                return nil
            end

            CurrentIdx = Found
            CurrentDepth = TargetDepth
        end
    end

    return CurrentIdx
end

function Explorer:_VTreeActivate()
    if self.ExplorerColumn and self.ExplorerColumn.Clear then
        self.ExplorerColumn:Clear()
    end

    self:_VTreeBuildRoots()

    local Container = self:_VTreeEnsureContainer()
    if not Container then return end
    Container.Visible = true

    self:_VTreeHookScroll()
    self:_VTreeHookGameSignals()
    self:_VTreeUpdateCanvasSize()
    self:_VTreeRebuildVisible()
end

function Explorer:_VTreeDeactivate()
    if self._VTreeContainer then
        self._VTreeContainer.Visible = false
    end
end

function Explorer:_VTreeReindexRows(StartIndex)
    StartIndex = StartIndex or 1
    local Rows = self._VTreeRows
    local Map = self._VTreeRowsByInstance
    for I = StartIndex, #Rows do
        local RowData = Rows[I]
        if RowData.Instance then
            Map[RowData.Instance] = I
        end
    end
end

function Explorer:_VTreeGetSortedChildren(Parent)
    if not Parent then return {} end

    local Kids = WeakGetChildren(Parent)
    if not Kids then return {} end

    local Filtered = {}
    for _, Child in Kids do
        if Child ~= self.ScreenGui then
            Filtered[#Filtered + 1] = Child
        end
    end

    if Parent == game then
        return SortServices(Filtered)
    end

    return SortExplorerChildren(Filtered)
end

function Explorer:_VTreeBuildFiltered()
    local Query = self.SearchQuery or ""
    self._VTreeFilterBuildToken = (self._VTreeFilterBuildToken or 0) + 1
    local Token = self._VTreeFilterBuildToken

    self._VTreeFilteredResume = nil
    self._VTreeFilteredExhausted = false

    if Query == "" then
        self._VTreeFilterActive = false
        self._VTreeFilteredRows = nil
        return
    end

    local MatchSet = self.MatchSet
    if not MatchSet then
        self._VTreeFilterActive = true
        self._VTreeFilteredRows = {}
        return
    end

    self._VTreeFilterActive = true
    self._VTreeFilteredRows = {}
    self:_VTreeInvalidateVisibleCache()

    local Include = {}
    local ChildrenByParent = {}
    local Roots = {}
    local NilRootChildren = {}

    local function AddChild(ParentInst, ChildInst)
        local List = ChildrenByParent[ParentInst]
        if not List then
            List = {}
            ChildrenByParent[ParentInst] = List
        end
        for _, Existing in List do
            if Existing == ChildInst then return end
        end
        List[#List + 1] = ChildInst
    end

    for Inst in MatchSet do
        if Inst then
            local Cursor = Inst
            local Prev
            local Safety = 0

            while Cursor and Cursor ~= game and Safety < 64 do
                local Already = Include[Cursor]
                Include[Cursor] = true
                if Prev then AddChild(Cursor, Prev) end
                if Already then break end
                Prev = Cursor
                local GoodP, P = pcall(function() return Cursor.Parent end)
                Cursor = GoodP and P or nil
                Safety += 1
            end

            if Cursor == game and Prev then
                Roots[Prev] = true
            elseif Prev then
                NilRootChildren[Prev] = true
            end
        end
    end

    local RootList = {}
    for Inst in Roots do RootList[#RootList + 1] = Inst end
    RootList = SortServices(RootList)

    local NilChildList = {}
    for Inst in NilRootChildren do
        NilChildList[#NilChildList + 1] = Inst
    end
    if #NilChildList > 0 then
        table.sort(NilChildList, function(A, B)
            local AN = (A.Name or ""):lower()
            local BN = (B.Name or ""):lower()
            if AN == BN then return tostring(A) < tostring(B) end
            return AN < BN
        end)
    end

    for _, List in ChildrenByParent do
        table.sort(List, function(A, B)
            local AN = (A.Name or ""):lower()
            local BN = (B.Name or ""):lower()
            if AN == BN then return tostring(A) < tostring(B) end
            return AN < BN
        end)
    end

    if not self._VTreeFilteredExpanded then
        self._VTreeFilteredExpanded = {}
    end

    for Inst in Include do
        if self._VTreeFilteredExpanded[Inst] == nil then
            self._VTreeFilteredExpanded[Inst] = true
        end
    end

    local FilteredExpanded = self._VTreeFilteredExpanded
    local Filtered = self._VTreeFilteredRows
    local PageSize = self._VTreeFilteredPageSize or 150

    local function IsFilteredExpanded(Inst)
        local State = FilteredExpanded[Inst]
        if State == nil then
            return true
        end
        return State ~= false
    end

    local function MakeRow(Inst, Depth, HasKids, Expanded)
        local GoodN, N = pcall(function() return Inst.Name end)
        local GoodC, C = pcall(function() return Inst.ClassName end)
        return {
            Instance = Inst;
            Depth = Depth;
            Expanded = Expanded;
            HasChildren = HasKids;
            IsNilContainer = false;
            RawName = (GoodN and N) or "?";
            ClassName = (GoodC and C) or "Instance";
        }
    end

    local Co = coroutine.create(function()
        local Emitted = 0
        local Threshold = PageSize

        local Walk
        Walk = function(Inst, Depth)
            local Kids = ChildrenByParent[Inst]
            local HasKids = Kids ~= nil and #Kids > 0
            local Expanded = IsFilteredExpanded(Inst)
            Filtered[#Filtered + 1] = MakeRow(Inst, Depth, HasKids, Expanded)
            Emitted += 1

            if Emitted >= Threshold then
                coroutine.yield()
                Threshold = Emitted + PageSize
            end

            if HasKids and Expanded and Kids then
                for _, Child in Kids do
                    Walk(Child, Depth + 1)
                end
            end
        end

        for _, Root in RootList do
            Walk(Root, 0)
        end

        if #NilChildList > 0 then
            local NilExpanded = FilteredExpanded.__NilContainer
            if NilExpanded == nil then
                NilExpanded = true
            else
                NilExpanded = NilExpanded ~= false
            end

            Filtered[#Filtered + 1] = {
                Instance = nil;
                Depth = 0;
                Expanded = NilExpanded;
                HasChildren = true;
                IsNilContainer = true;
                RawName = `Nil Instances ({#NilChildList})`;
                ClassName = "Folder";
            }
            Emitted += 1
            if Emitted >= Threshold then
                coroutine.yield()
                Threshold = Emitted + PageSize
            end

            if NilExpanded then
                for _, Child in NilChildList do
                    Walk(Child, 1)
                end
            end
        end
    end)

    local Self = self
    local function Resume()
        if Token ~= Self._VTreeFilterBuildToken then return end
        if coroutine.status(Co) == "dead" then
            Self._VTreeFilteredExhausted = true
            Self._VTreeFilteredResume = nil
            Self:_VTreeUpdateCanvasSize()
            Self:_VTreeScheduleRebuild()
            return
        end
        coroutine.resume(Co)
        if coroutine.status(Co) == "dead" then
            Self._VTreeFilteredExhausted = true
            Self._VTreeFilteredResume = nil
        end
        Self:_VTreeUpdateCanvasSize()
        Self:_VTreeScheduleRebuild()
    end

    self._VTreeFilteredResume = Resume

    Resume()
end

function Explorer:_VTreeApplyFilter()
    local Query = self.SearchQuery or ""
    local PrevQuery = self._VTreeLastQuery or ""

    if PrevQuery == "" and Query ~= "" then
        self:_VTreeSaveScroll()
    end

    self._VTreeLastQuery = Query

    if PrevQuery ~= Query then
        self._VTreeHighlightCache = {}
        self._VTreeFilteredExpanded = {}
    end

    if Query == "" then
        self._VTreeFilterActive = false
        self._VTreeFilteredRows = nil
        self._VTreeFilteredResume = nil
        self._VTreeFilteredExhausted = false

        if self.FlatSearchResults then
            self:_FlatHideContainer()
        end
        if self._VTreeContainer then
            self._VTreeContainer.Visible = true
        end

        self:_VTreeUpdateCanvasSize()
        self:_VTreeInvalidateVisibleCache()
        self:_VTreeRebuildVisible()
        if PrevQuery ~= "" then
            self:_VTreeRestoreScroll()
        end
        return
    end

    if self.FlatSearchResults then
        self._VTreeFilterActive = false
        self._VTreeFilteredRows = nil
        if self._VTreeContainer then
            self._VTreeContainer.Visible = false
        end
        return
    end

    if self._VTreeContainer then
        self._VTreeContainer.Visible = true
    end

    self:_VTreeBuildFiltered()
    self:_VTreeUpdateCanvasSize()
    self:_VTreeRebuildVisible()
end

function Explorer:_VTreeSaveScroll()
    local Scroll = self.ExplorerColumn and self.ExplorerColumn.Content
    if not Scroll then return end
    self._VTreeSavedScrollY = Scroll.CanvasPosition.Y
end

function Explorer:_VTreeRestoreScroll()
    local Scroll = self.ExplorerColumn and self.ExplorerColumn.Content
    if not Scroll then return end
    if not self._VTreeSavedScrollY then return end
    local Y = self._VTreeSavedScrollY
    self._VTreeSavedScrollY = nil

    task.defer(function()
        if not Scroll or not Scroll.Parent then return end
        local MaxY = math.max(0, Scroll.AbsoluteCanvasSize.Y - Scroll.AbsoluteSize.Y)
        Scroll.CanvasPosition = Vector2.new(0, math.clamp(Y, 0, MaxY))
    end)
end

function Explorer:_VTreeStabiliseScrollAroundInsert(InsertedAtRowIndex, NumInserted)
    local Scroll = self.ExplorerColumn and self.ExplorerColumn.Content
    if not Scroll then return end

    local Slot = self._VTreeRowHeight + (self._VTreeRowGap or 0)
    local CurrentY = Scroll.CanvasPosition.Y
    local FirstVisibleIdx = math.floor(CurrentY / Slot) + 1

    if InsertedAtRowIndex < FirstVisibleIdx then
        task.defer(function()
            if not Scroll or not Scroll.Parent then return end
            local MaxY = math.max(0, Scroll.AbsoluteCanvasSize.Y - Scroll.AbsoluteSize.Y)
            Scroll.CanvasPosition = Vector2.new(0, math.clamp(CurrentY + Slot * NumInserted, 0, MaxY))
        end)
    end
end

function Explorer:_VTreeStabiliseScrollAroundRemove(RemovedAtRowIndex, NumRemoved)
    local Scroll = self.ExplorerColumn and self.ExplorerColumn.Content
    if not Scroll then return end

    local Slot = self._VTreeRowHeight + (self._VTreeRowGap or 0)
    local CurrentY = Scroll.CanvasPosition.Y
    local FirstVisibleIdx = math.floor(CurrentY / Slot) + 1

    if RemovedAtRowIndex < FirstVisibleIdx then
        task.defer(function()
            if not Scroll or not Scroll.Parent then return end
            local NewY = math.max(0, CurrentY - Slot * NumRemoved)
            local MaxY = math.max(0, Scroll.AbsoluteCanvasSize.Y - Scroll.AbsoluteSize.Y)
            Scroll.CanvasPosition = Vector2.new(0, math.clamp(NewY, 0, MaxY))
        end)
    end
end

function Explorer:_CollectNilInstances()
    local Result = {}
    local Seen = {}
    local Getter = getnilinstances

    if type(Getter) ~= "function" then
        return Result
    end

    local Good, List = pcall(Getter)
    if not Good or type(List) ~= "table" then
        return Result
    end

    local ClassFilter = (self.NilFilterClass or ""):lower()
    if ClassFilter == "" then ClassFilter = nil end

    for _, Inst in List do
        if typeof(Inst) ~= "Instance" or Seen[Inst] or Inst == game then
            continue
        end

        local GoodP, Parent = pcall(function() return Inst.Parent end)
        if not GoodP or Parent ~= nil then
            continue
        end

        if Inst:IsA("ServiceProvider")
            or Inst:IsA("Workspace")
            or Inst:IsA("Players")
            or Inst:IsA("Lighting")
            or Inst:IsA("StarterGui")
            or Inst:IsA("StarterPack")
            or Inst:IsA("StarterPlayer")
            or Inst:IsA("ReplicatedStorage")
            or Inst:IsA("ReplicatedFirst")
            or Inst:IsA("ServerStorage")
            or Inst:IsA("ServerScriptService")
            or Inst:IsA("CoreGui")
            or Inst:IsA("Teams")
            or Inst:IsA("Player")
        then
            continue
        end

        local ReachableFromGame = false
        local GoodAnc, IsDesc = pcall(function() return Inst:IsDescendantOf(game) end)
        if GoodAnc and IsDesc then
            ReachableFromGame = true
        end

        if ReachableFromGame then
            continue
        end

        if ClassFilter then
            local GoodC, ClassName = pcall(function() return Inst.ClassName end)
            if not GoodC or not ClassName then continue end
            if not string.find(ClassName:lower(), ClassFilter, 1, true) then
                continue
            end
        end

        Seen[Inst] = true
        Result[#Result + 1] = Inst
    end

    table.sort(Result, function(A, B)
        local AN = (A.Name or ""):lower()
        local BN = (B.Name or ""):lower()
        if AN == BN then return tostring(A) < tostring(B) end
        return AN < BN
    end)

    return Result
end

function Explorer:_VTreeStartNilStream(ContainerRow)
    self._VTreeNilStreamToken = (self._VTreeNilStreamToken or 0) + 1
    local Token = self._VTreeNilStreamToken

    local NilInsts = self:_CollectNilInstances()
    local PageSize = self._VTreeFilteredPageSize or 150
    local Cursor = 1
    local Self = self

    local function FindContainerIdx()
        for I, R in Self._VTreeRows do
            if R == ContainerRow then
                return I
            end
        end
        return nil
    end

    local function EmitPage()
        if Token ~= Self._VTreeNilStreamToken then return end
        if not ContainerRow.Expanded then return end

        local ContainerIdx = FindContainerIdx()
        if not ContainerIdx then return end

        local Rows = Self._VTreeRows
        local Depth = ContainerRow.Depth
        local InsertAt = ContainerIdx + 1
        for I = ContainerIdx + 1, #Rows do
            if Rows[I].Depth > Depth then
                InsertAt = I + 1
            else
                break
            end
        end

        local Limit = math.min(Cursor + PageSize - 1, #NilInsts)
        local Count = Limit - Cursor + 1
        if Count <= 0 then
            Self._VTreeNilResume = nil
            Self._VTreeNilExhausted = true
            return
        end

        local OldLen = #Rows
        for I = OldLen, InsertAt, -1 do
            Rows[I + Count] = Rows[I]
        end

        for I = 0, Count - 1 do
            local Inst = NilInsts[Cursor + I]
            local ChildRow = Self:_VTreeMakeRowData(Inst, Depth + 1, false)
            Self:_VTreeRefreshRowMeta(ChildRow)
            Rows[InsertAt + I] = ChildRow
            Self._VTreeRowsByInstance[Inst] = InsertAt + I
        end

        Cursor = Limit + 1
        Self:_VTreeReindexRows(InsertAt + Count)
        Self:_VTreeUpdateCanvasSize()
        Self:_VTreeInvalidateVisibleCache()
        Self:_VTreeScheduleRebuild()

        if Cursor > #NilInsts then
            Self._VTreeNilResume = nil
            Self._VTreeNilExhausted = true
        end
    end

    self._VTreeNilResume = EmitPage
    self._VTreeNilExhausted = false

    EmitPage()
end

function Explorer:ToggleMatchByClassName()
    self.MatchByClassName = not self.MatchByClassName
    self._FilterChangedSinceLastSearch = true
    self:SaveConfig()

    if self.SearchQuery ~= "" then
        self:RefreshAllSearchFilters()
    end
end

function Explorer:ToggleMatchByProperty()
    self.MatchByProperty = not self.MatchByProperty
    self._FilterChangedSinceLastSearch = true
    self:SaveConfig()

    if self.SearchQuery ~= "" then
        self:RefreshAllSearchFilters()
    end
end

function Explorer:ToggleClassFilter(ClassName)
    if self.ActiveClassFilters[ClassName] then
        self.ActiveClassFilters[ClassName] = nil
    else
        self.ActiveClassFilters[ClassName] = true
    end

    self._FilterChangedSinceLastSearch = true

    self:SaveConfig()

    if self.SearchQuery ~= "" then
        self:RefreshAllSearchFilters()
    end
end

function Explorer:ToggleServiceFilter(ServiceName)
    if self.HiddenServices[ServiceName] then
        self.HiddenServices[ServiceName] = nil
        self.AllServicesHidden = false
    else
        self.HiddenServices[ServiceName] = true
    end

    self:SaveConfig()
    self:RebuildExplorer()
end

function Explorer:ToggleNilContainerFilter()
    self.HideNilContainer = not self.HideNilContainer
    self:SaveConfig()
    self:RebuildExplorer()
end

function Explorer:_EscapeRichText(Text)
    Text = Text:gsub("&", "&amp;")
    Text = Text:gsub("<", "&lt;")
    Text = Text:gsub(">", "&gt;")
    Text = Text:gsub("\"", "&quot;")
    Text = Text:gsub("'", "&apos;")
    return Text
end

local _ComparisonOperators = {">=", "<=", "==", "=", ">", "<", "~"}

function Explorer:_ParsePropertyQuery(Query)
    for _, Op in _ComparisonOperators do
        local SplitPos = string.find(Query, Op, 1, true)
        if SplitPos then
            local PropName = string.sub(Query, 1, SplitPos - 1):gsub("^%s+", ""):gsub("%s+$", "")
            local RawValue = string.sub(Query, SplitPos + #Op):gsub("^%s+", ""):gsub("%s+$", "")

            if PropName == "" then
                return nil
            end

            return {
                Property = PropName;
                Operator = Op;
                RawValue = RawValue;
                LowerRawValue = RawValue:lower();
                NumericValue = tonumber(RawValue);
                BooleanValue = (RawValue:lower() == "true") and true
                    or (RawValue:lower() == "false") and false
                    or nil;
            }
        end
    end

    return nil
end

function Explorer:_CompareValues(Actual, Parsed)
    local Op = Parsed.Operator
    local ActualType = typeof(Actual)

    if Op == "~" then
        if ActualType == "string" then
            return string.find(Actual:lower(), Parsed.LowerRawValue, 1, true) ~= nil
        end
        return string.find(tostring(Actual):lower(), Parsed.LowerRawValue, 1, true) ~= nil
    end

    if Op == "=" or Op == "==" then
        if ActualType == "boolean" and Parsed.BooleanValue ~= nil then
            return Actual == Parsed.BooleanValue
        end
        if ActualType == "number" and Parsed.NumericValue ~= nil then
            return Actual == Parsed.NumericValue
        end
        if ActualType == "string" then
            return Actual:lower() == Parsed.LowerRawValue
        end
        if ActualType == "EnumItem" then
            return Actual.Name:lower() == Parsed.LowerRawValue
        end
        return tostring(Actual):lower() == Parsed.LowerRawValue
    end

    if Parsed.NumericValue == nil then
        return false
    end

    local Numeric
    if ActualType == "number" then
        Numeric = Actual
    elseif ActualType == "boolean" then
        Numeric = Actual and 1 or 0
    else
        return false
    end

    if Op == ">" then return Numeric > Parsed.NumericValue end
    if Op == "<" then return Numeric < Parsed.NumericValue end
    if Op == ">=" then return Numeric >= Parsed.NumericValue end
    if Op == "<=" then return Numeric <= Parsed.NumericValue end

    return false
end

function Explorer:_EntryMatchesPropertyQuery(Entry, Parsed)
    local Inst = Entry.Instance
    if not Inst or Inst.Parent == nil then
        return false
    end

    local PropName = Parsed.Property

    if PropName:lower() == "classname" then
        if Parsed.Operator == "~" then
            return string.find(Entry.ClassName:lower(), Parsed.LowerRawValue, 1, true) ~= nil
        end
        return Entry.ClassName:lower() == Parsed.LowerRawValue
    end

    if PropName:lower() == "name" then
        if Parsed.Operator == "~" then
            return string.find(Entry.LowerName, Parsed.LowerRawValue, 1, true) ~= nil
        end
        return Entry.LowerName == Parsed.LowerRawValue
    end

    local Good, Value = pcall(function() return Inst[PropName] end)
    if not Good then
        return false
    end

    return self:_CompareValues(Value, Parsed)
end

function Explorer:_EntryMatchesQuery(Entry, LowerQuery, ParsedProperty)
    if ParsedProperty then
        return self:_EntryMatchesPropertyQuery(Entry, ParsedProperty)
    end

    local NameMatches = string.find(Entry.LowerName, LowerQuery, 1, true) ~= nil
    if NameMatches then
        return true
    end

    if self.MatchByClassName then
        local ClassMatches = string.find(Entry.ClassName:lower(), LowerQuery, 1, true) ~= nil
        if ClassMatches then
            return true
        end
    end

    return false
end

function Explorer:_BuildHighlightedName(Name, Query)
    if not Query or Query == "" then
        return self:_EscapeRichText(Name), false
    end

    local LowerName = Name:lower()
    local LowerQuery = Query:lower()
    local MatchStart, MatchEnd = string.find(LowerName, LowerQuery, 1, true)

    if not MatchStart then
        return self:_EscapeRichText(Name), false
    end

    local Before = self:_EscapeRichText(Name:sub(1, MatchStart - 1))
    local Match = self:_EscapeRichText(Name:sub(MatchStart, MatchEnd))
    local After = self:_EscapeRichText(Name:sub(MatchEnd + 1))

    local AccentColor = Theme.Accent
    local Hex = string.format("#%02X%02X%02X",
        math.floor(AccentColor.R * 255 + 0.5),
        math.floor(AccentColor.G * 255 + 0.5),
        math.floor(AccentColor.B * 255 + 0.5))

    return `{Before}<font color="{Hex}"><b>{Match}</b></font>{After}`, true
end

function Explorer:BuildSearchIndex()
    if self.SearchIndexBuilt then
        return
    end

    self.SearchIndex = {}
    self.SearchIndexByInstance = setmetatable({}, {__mode = "k"})

    local Descendants = WeakGetDescendants(game)
    for Index = 1, #Descendants do
        local Inst = Descendants[Index]
        if typeof(Inst) ~= "Instance" then
            continue
        end

        local GoodName, Name = pcall(function() return Inst.Name end)
        local GoodClass, ClassName = pcall(function() return Inst.ClassName end)
        if not GoodName or not GoodClass or type(Name) ~= "string" then
            continue
        end

        local Entry = {
            Instance = Inst;
            LowerName = Name:lower();
            ClassName = ClassName;
        }

        local NewLength = #self.SearchIndex + 1
        self.SearchIndex[NewLength] = Entry
        self.SearchIndexByInstance[Inst] = NewLength

        if Index % 5000 == 0 then
            task.wait()
            if KillScript then
                return
            end
        end
    end

    self.SearchIndexBuilt = true
    self:HookSearchIndexEvents()
end

function Explorer:_AddToSearchIndex(Inst)
    if typeof(Inst) ~= "Instance" or self.SearchIndexByInstance[Inst] then
        return
    end

    local GoodName, Name = pcall(function() return Inst.Name end)
    local GoodClass, ClassName = pcall(function() return Inst.ClassName end)
    if not GoodName or not GoodClass or type(Name) ~= "string" then
        return
    end

    local Entry = {
        Instance = Inst;
        LowerName = Name:lower();
        ClassName = ClassName;
    }

    local NewLength = #self.SearchIndex + 1
    self.SearchIndex[NewLength] = Entry
    self.SearchIndexByInstance[Inst] = NewLength
end

function Explorer:_RemoveFromSearchIndex(Inst)
    if typeof(Inst) ~= "Instance" then
        return
    end

    local Idx = self.SearchIndexByInstance[Inst]
    if not Idx then
        return
    end

    local Last = #self.SearchIndex
    if Idx ~= Last then
        local Moved = self.SearchIndex[Last]
        self.SearchIndex[Idx] = Moved
        if Moved and Moved.Instance then
            self.SearchIndexByInstance[Moved.Instance] = Idx
        end
    end

    self.SearchIndex[Last] = nil
    self.SearchIndexByInstance[Inst] = nil
end

function Explorer:_UpdateSearchIndexName(Inst, NewName)
    if typeof(Inst) ~= "Instance" or type(NewName) ~= "string" then
        return
    end

    local Idx = self.SearchIndexByInstance[Inst]
    if not Idx then
        return
    end

    local Entry = self.SearchIndex[Idx]
    if Entry then
        Entry.LowerName = NewName:lower()
    end
end

function Explorer:HookSearchIndexEvents()
    if self._SearchIndexHooked then
        return
    end
    self._SearchIndexHooked = true

    Track(game.DescendantAdded:Connect(function(RawInst)
        if typeof(RawInst) ~= "Instance" then
            return
        end

        local Inst = ClonerefInstance(RawInst)
        self:_AddToSearchIndex(Inst)
    end))

    Track(game.DescendantRemoving:Connect(function(RawInst)
        if typeof(RawInst) ~= "Instance" then
            return
        end

        local Inst = ClonerefInstance(RawInst)
        self:_RemoveFromSearchIndex(Inst)
    end))
end

function Explorer:_MarkAncestorsForSearch(Object)
    local Cursor = ClonerefInstance(Object)
    while Cursor and Cursor ~= game do
        self.SubtreeMatchSet[Cursor] = true
        Cursor = ClonerefInstance(Cursor.Parent)
    end
end

function Explorer:RunIndexedSearch(Query, Token)
    if not self.SearchIndexBuilt then
        self:BuildSearchIndex()
    end

    if Token ~= self.SearchToken or KillScript then
        return
    end

    local LowerQuery = Query:lower()
    local Filters = self.ActiveClassFilters or {}
    local FilterActive = next(Filters) ~= nil

    local ParsedProperty = nil
    if self.MatchByProperty then
        ParsedProperty = self:_ParsePropertyQuery(Query)
    end

    local Source
    local PrevQuery = self._LastIndexedQuery
    local PrevResults = self._LastIndexedResults
    local PrevWasProperty = self._LastIndexedWasProperty
    local UsePrefix = false

    local IsPropertyNow = ParsedProperty ~= nil

    if PrevQuery
        and PrevResults
        and #PrevQuery > 0
        and not IsPropertyNow
        and not PrevWasProperty
        and string.find(LowerQuery, PrevQuery, 1, true) == 1
        and not self._FilterChangedSinceLastSearch
    then
        Source = PrevResults
        UsePrefix = true
    else
        Source = self.SearchIndex
    end

    local Matches = {}
    local SourceLength = #Source
    local Scanned = 0

    for Index = 1, SourceLength do
        local Entry = Source[Index]
        if Entry and Entry.Instance and (Entry.Instance.Parent ~= nil or self.SearchIncludesNil) then
            local NameGood = self:_EntryMatchesQuery(Entry, LowerQuery, ParsedProperty)
            local ClassGood = (not FilterActive) or Filters[Entry.ClassName]

            if NameGood and ClassGood then
                self.MatchSet[Entry.Instance] = true
                self:_MarkAncestorsForSearch(Entry.Instance)
                Matches[#Matches + 1] = Entry
            end
        end

        Scanned += 1
        if Scanned % 8000 == 0 then
            task.wait()
            if Token ~= self.SearchToken or KillScript then
                return
            end
        end
    end

    if self.SearchIncludesNil then
        local NilRoots = self:_CollectNilInstances()
        local SeenNil = {}

        local Stack = {}
        for _, Inst in NilRoots do
            Stack[#Stack + 1] = Inst
        end

        local NilScanned = 0
        while #Stack > 0 do
            local Inst = table.remove(Stack)
            if not SeenNil[Inst] then
                SeenNil[Inst] = true

                local GoodName, Name = pcall(function() return Inst.Name end)
                local GoodClass, ClassName = pcall(function() return Inst.ClassName end)
                if GoodName and GoodClass and type(Name) == "string" then
                    local Entry = {
                        Instance = Inst;
                        LowerName = Name:lower();
                        ClassName = ClassName;
                    }

                    local NameOk = self:_EntryMatchesQuery(Entry, LowerQuery, ParsedProperty)
                    local ClassOk = (not FilterActive) or Filters[ClassName]
                    if NameOk and ClassOk then
                        self.MatchSet[Inst] = true
                        self:_MarkAncestorsForSearch(Inst)
                        Matches[#Matches + 1] = Entry
                    end
                end

                local GoodKids, Kids = pcall(function() return WeakGetChildren(Inst) end)
                if GoodKids and Kids then
                    for _, Child in Kids do
                        if not SeenNil[Child] then
                            Stack[#Stack + 1] = Child
                        end
                    end
                end
            end

            NilScanned += 1
            if NilScanned % 4000 == 0 then
                task.wait()
                if Token ~= self.SearchToken or KillScript then
                    return
                end
            end
        end
    end

    self._LastIndexedQuery = LowerQuery
    self._LastIndexedResults = Matches
    self._LastIndexedWasProperty = IsPropertyNow
    self._FilterChangedSinceLastSearch = false

    if self.FlatSearchResults then
        self:_FlatHookScroll()
        self:_FlatApplyResults(Matches)
    else
        self:_FlatHideContainer()
    end

    self:_VTreeApplyFilter()
end

function Explorer:RefreshAllSearchFilters()
    local Query = self.SearchQuery or ""

    self.SearchToken = (self.SearchToken or 0) + 1
    local Token = self.SearchToken

    self.MatchSet = {}
    self.SubtreeMatchSet = {}

    if Query == "" then
        self._LastIndexedQuery = nil
        self._LastIndexedResults = nil

        self:_FlatHideContainer()
        self:_VTreeApplyFilter()
        return
    end

    task.spawn(function()
        self:RunIndexedSearch(Query, Token)
    end)
end

function Explorer:ClearSearchAndJumpTo()
    local Target = self.SelectedInstance
    if typeof(Target) ~= "Instance" then return end

    self._SearchTextToken = (self._SearchTextToken or 0) + 1
    self._SuppressSearchBoxChanged = true
    if self.SearchBox then
        self.SearchBox.Text = ""
    end
    self._SuppressSearchBoxChanged = false
    self._LastAppliedSearchQuery = ""
    self.SearchQuery = ""

    self:ClearSearchStateWithoutRebuild()
    self._VTreeFilterActive = false
    self._VTreeFilteredRows = nil
    self._VTreeLastQuery = ""
    self._VTreeSavedScrollY = nil

    local Chain = {}
    local Cursor = Target
    local Safety = 0
    while Cursor and Cursor ~= game and Safety < 64 do
        Chain[#Chain + 1] = Cursor
        local GoodP, P = pcall(function() return Cursor.Parent end)
        Cursor = GoodP and P or nil
        Safety += 1
    end
    if Cursor ~= game then
        self:_VTreeUpdateCanvasSize()
        self:_VTreeRebuildVisible()
        return
    end

    for I = #Chain, 2, -1 do
        local Ancestor = Chain[I]
        local Idx = self._VTreeRowsByInstance[Ancestor]
            or self:_VTreeResolveRowIndex(Ancestor)
        if not Idx then break end
        local Row = self._VTreeRows[Idx]
        if Row and Row.HasChildren and not Row.Expanded then
            self:_VTreeExpand(Row)
        end
    end

    self:_VTreeUpdateCanvasSize()
    self:_VTreeRebuildVisible()

    task.defer(function()
        if KillScript then return end
        local Idx = self._VTreeRowsByInstance[Target]
            or self:_VTreeResolveRowIndex(Target)
        if not Idx then return end

        self:SetSelection({Target})
        self.SelectionAnchor = Target

        local Scroll = self.ExplorerColumn and self.ExplorerColumn.Content
        if Scroll then
            local Slot = self._VTreeRowHeight + (self._VTreeRowGap or 0)
            local RowY = (Idx - 1) * Slot
            local Center = RowY - Scroll.AbsoluteSize.Y / 2 + Slot
            local MaxY = math.max(0, Scroll.AbsoluteCanvasSize.Y - Scroll.AbsoluteSize.Y)
            Scroll.CanvasPosition = Vector2.new(0, math.clamp(Center, 0, MaxY))
        end

        self:_VTreeRefreshVisibleSelection()
    end)

    return
end

function Explorer:ClearSearchStateWithoutRebuild()
    self.SearchQuery = ""

    self.MatchSet = {}
    self.SubtreeMatchSet = {}

    self.SearchToken = (self.SearchToken or 0) + 1

    self._RefreshDebounceToken = (self._RefreshDebounceToken or 0) + 1
    self._SearchTextToken = (self._SearchTextToken or 0) + 1
    self._LastAppliedSearchQuery = ""

    self._VTreeFilterActive = false
    self._VTreeFilteredRows = nil
    self._VTreeFilteredResume = nil
    self._VTreeFilteredExhausted = false
    self._VTreeFilterBuildToken = (self._VTreeFilterBuildToken or 0) + 1

    if self._VTreeHighlightCache then
        self._VTreeHighlightCache = {}
    end

    if self._VTreeInvalidateVisibleCache then
        self:_VTreeInvalidateVisibleCache()
    end

    if self._VTreeUpdateCanvasSize then
        self:_VTreeUpdateCanvasSize()
    end

    if self._VTreeScheduleRebuild then
        self:_VTreeScheduleRebuild()
    end
end

function Explorer:HandleSearchSubmit()
    local Query = self.SearchQuery
    if Query == "" then return end

    local Now = os.clock()
    if self._LastSearchSubmitQuery == Query
        and self._LastSearchSubmitTime
        and Now - self._LastSearchSubmitTime < 0.4
    then return end

    self._LastSearchSubmitQuery = Query
    self._LastSearchSubmitTime = Now

    return
end

function Explorer:CollectVisibleFlatOrder()
    local Order = {}
    local Index = {}
    local function IsRowVisible(Node)
        if not Node.Row or not Node.Row.Visible then
            return false
        end

        local Holder = Node.Row.Parent
        if Holder and not Holder.Visible then
            return false
        end

        return true
    end

    local function Traverse(Node)
        if not Node or not IsRowVisible(Node) then
            return
        end

        table.insert(Order, Node.Instance)
        Index[Node.Instance] = #Order

        if Node.Expanded then
            for _, Child in Node.Children do
                Traverse(Child)
            end
        end
    end

    for _, Root in self.RootNodes do
        Traverse(Root)
    end

    return Order, Index
end

function Explorer:RangeSelect(AnchorInstance, EndInstance)
    local Rows = self._VTreeFilterActive
        and self._VTreeFilteredRows
        or self._VTreeRows
    if not Rows then
        self:SetSelection({EndInstance})
        self.SelectionAnchor = EndInstance
        return
    end

    local AnchorIdx, EndIdx
    for I, Row in Rows do
        if Row.Instance == AnchorInstance then AnchorIdx = I end
        if Row.Instance == EndInstance then EndIdx = I end
        if AnchorIdx and EndIdx then break end
    end

    if not AnchorIdx or not EndIdx then
        self:SetSelection({EndInstance})
        self.SelectionAnchor = EndInstance
        return
    end

    local Low = math.min(AnchorIdx, EndIdx)
    local High = math.max(AnchorIdx, EndIdx)
    local Range = {}
    for Position = Low, High do
        local Row = Rows[Position]
        if Row and Row.Instance then
            table.insert(Range, Row.Instance)
        end
    end

    self:SetSelection(Range)
    self.SelectedInstance = EndInstance
    self:OnSelectionChanged()
end

function Explorer:SetSelection(InstanceList)
    local Old = {}
    for Object in self.SelectedSet do
        Old[Object] = true
    end

    self.SelectedSet = {}
    self.SelectedOrder = {}
    for _, Object in InstanceList do
        if not self.SelectedSet[Object] then
            self.SelectedSet[Object] = true
            table.insert(self.SelectedOrder, Object)
        end
    end

    self.SelectedInstance = self.SelectedOrder[#self.SelectedOrder]

    self:OnSelectionChanged()

    self:_VTreeRefreshVisibleSelection()
end

function Explorer:ToggleInSelection(Object)
    if self.SelectedSet[Object] then
        self.SelectedSet[Object] = nil
        for Index, Value in self.SelectedOrder do
            if Value == Object then
                table.remove(self.SelectedOrder, Index)
                
                break
            end
        end

        if self.SelectedInstance == Object then
            self.SelectedInstance = self.SelectedOrder[#self.SelectedOrder]
        end
    else
        self.SelectedSet[Object] = true
        table.insert(self.SelectedOrder, Object)
        self.SelectedInstance = Object
    end

    self:OnSelectionChanged()
end

function Explorer:GetSelectionList()
    return {table.unpack(self.SelectedOrder)}
end

function Explorer:OnSelectionChanged()
    local Count = 0
    if self.SelectedOrder then
        for _ in self.SelectedOrder do Count += 1 end
    end

    if self.SelectedInstance then
        self:RenderProperties(self.SelectedInstance)
        self:UpdateSelectionHighlights()

        if self.PropertiesTitleLabel then
            if Count > 1 then
                self.PropertiesTitleLabel.Text =
                    `{self.SelectedInstance.ClassName}  -  {self.SelectedInstance.Name}  ({Count} selected)`
            else
                self.PropertiesTitleLabel.Text =
                    `{self.SelectedInstance.ClassName}  -  {self.SelectedInstance.Name}`
            end
        end
    else
        self:ClearPropertyConnections()
        self.PropertyRows = {}
        self:ClearPropertiesContent()

        if self.PropertiesTitleLabel then
            self.PropertiesTitleLabel.Text = "(no selection)"
        end

        self:AddPropertiesLabel("Select an instance.")
    end
end

function Explorer:ClearPropertiesContent()
    if not self.PropertiesContent then
        return
    end

    for _, Child in WeakGetChildren(self.PropertiesContent) do
        if Child:IsA("GuiObject") then
            Child:Destroy()
        end
    end
end

function Explorer:AddPropertiesLabel(Text)
    local Label = VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 24);
        BackgroundTransparency = 1;
        Font = Fonts.Medium;
        Text = Text;
        TextColor3 = Theme.TextDim;
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Left;
        Parent = self.PropertiesContent;
    })

    BindTheme("TextDim", function(Color)
        if Label and Label.Parent then
            Label.TextColor3 = Color
        end
    end)

    return Label
end

function Explorer:ClearPropertyConnections()
    for _, Connection in self.PropertyConnections do
        pcall(function()
            Connection:Disconnect()
        end)
    end

    self.PropertyConnections = {}
end

function Explorer:CreatePropertyRow(GroupParent)
    return VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 24);
        BackgroundColor3 = Theme.Field;
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        Parent = GroupParent or self.PropertiesContent;
    })
end

function Explorer:CreatePropertyLabel(Row, PropertyName)
    return VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(0.42, -8, 1, 0);
        Position = UDim2.new(0, 8, 0, 0);
        BackgroundTransparency = 1;
        Font = Fonts.Medium;
        Text = PropertyName;
        TextColor3 = Theme.TextDim;
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextTruncate = Enum.TextTruncate.AtEnd;
        Parent = Row;
    })
end

function Explorer:AttachPropertyCopyHandler(Row, Object, PropertyName, DisplayName)
    if not Row or not Row.Parent or typeof(Object) ~= "Instance" then
        return
    end

    DisplayName = DisplayName or PropertyName

    local ClickCatcher = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, 0);
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        ZIndex = 199;
        Parent = Row;
    })

    ClickCatcher.InputBegan:Connect(function(Input)
        if Input.UserInputType ~= Enum.UserInputType.MouseButton2 then
            return
        end

        local ReadGood, CurrentValue = pcall(function()
            return Object[PropertyName]
        end)

        if not ReadGood then
            self:Notify(`Couldn't read {DisplayName}`)
            return
        end

        local PathExpr = BuildLuaPath(Object)
        local Code = `{PathExpr}.{DisplayName} = {SerializeValue(CurrentValue)}`
        pcall(setclipboard, Code)
        self:Notify(`Copied property "{DisplayName}"`)
    end)

    return ClickCatcher
end

function Explorer:CreateTextRow(Object, PropertyName, Value, Editable, Parent)
    local Row = self:CreatePropertyRow(Parent)
    self:CreatePropertyLabel(Row, PropertyName)

    local Input = VexUI:CreateInstance(Editable and "TextBox" or "TextLabel", {
        Size = UDim2.new(0.58, -8, 1, 0);
        Position = UDim2.new(0.42, 0, 0, 0);
        BackgroundTransparency = 1;
        Font = Fonts.Mono;
        Text = self:FormatValue(Value);
        TextColor3 = self:GetValueColor(Value);
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Right;
        ClipsDescendants = true;
        Parent = Row;
    })

    local RowState = {
        Editing = false;
        Input = Input;
        Update = function(NewValue)
            Input.Text = self:FormatValue(NewValue)
            Input.TextColor3 = self:GetValueColor(NewValue)
        end;
    }

    if Editable then
        Input.ClearTextOnFocus = false
        Input.Focused:Connect(function()
            RowState.Editing = true
        end)

        Input.FocusLost:Connect(function(EnterPressed)
            RowState.Editing = false
            if EnterPressed then
                local Current = SafeGet(Object, PropertyName)
                if Current == nil then
                    return
                end

                local Parsed = self:ParseEditValue(Input.Text, Current)
                if Parsed == nil then
                    Input.Text = self:FormatValue(Current)

                    return
                end

                self:ApplyToSelection(PropertyName, Parsed)
            else
                local Current = SafeGet(Object, PropertyName)
                if Current ~= nil then
                    Input.Text = self:FormatValue(Current)
                end
            end
        end)

        RowState.Update = function(NewValue)
            if RowState.Editing then
                return
            end

            Input.Text = self:FormatValue(NewValue)
            Input.TextColor3 = self:GetValueColor(NewValue)
        end
    end

    self.PropertyRows[PropertyName] = RowState
    self:AttachPropertyCopyHandler(Row, Object, PropertyName)
end

function Explorer:CreateBooleanRow(Object, PropertyName, Value, Parent)
    local Row = self:CreatePropertyRow(Parent)
    self:CreatePropertyLabel(Row, PropertyName)

    local Toggle = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(0, 56, 0, 18);
        Position = UDim2.new(1, -64, 0.5, -9);
        BackgroundColor3 = Value and Theme.Accent or Theme.ToggleOff;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Font = Fonts.SemiBold;
        Text = Value and "true" or "false";
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 11;
        Parent = Row;
    })

    VexUI:AddStroke(Toggle, "Border", 1)

    local function ApplyVisual(NewValue)
        Toggle.BackgroundColor3 = NewValue and Theme.Accent or Theme.ToggleOff
        Toggle.Text = NewValue and "true" or "false"
    end

    Toggle.MouseButton1Click:Connect(function()
        local Current = SafeGet(Object, PropertyName)
        if Current == nil then
            return
        end

        local NewValue = not Current
        self:ApplyToSelection(PropertyName, NewValue)
        ApplyVisual(NewValue)
    end)

    self.PropertyRows[PropertyName] = {
        Update = function(NewValue)
            ApplyVisual(NewValue == true)
        end;
    }
    self:AttachPropertyCopyHandler(Row, Object, PropertyName)
end

function Explorer:CreateBooleanAttributeRow(Object, AttributeName, Value, Parent)
    local Row = self:CreatePropertyRow(Parent)
    self:CreatePropertyLabel(Row, AttributeName)

    local Toggle = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(0, 56, 0, 18);
        Position = UDim2.new(1, -64, 0.5, -9);
        BackgroundColor3 = Value and Theme.Accent or Theme.ToggleOff;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Font = Fonts.SemiBold;
        Text = Value and "true" or "false";
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 11;
        Parent = Row;
    })

    VexUI:AddStroke(Toggle, "Border", 1)

    local function ApplyVisual(NewValue)
        local BoolValue = NewValue == true
        Toggle.BackgroundColor3 = BoolValue and Theme.Accent or Theme.ToggleOff
        Toggle.Text = BoolValue and "true" or "false"
    end

    Toggle.MouseButton1Click:Connect(function()
        local Current = false

        pcall(function()
            Current = Object:GetAttribute(AttributeName) == true
        end)

        local NewValue = not Current

        for _, Obj in self:GetSelectionList() do
            pcall(function()
                Obj:SetAttribute(AttributeName, NewValue)
            end)
        end

        ApplyVisual(NewValue)
    end)

    self.PropertyRows[`@{AttributeName}`] = {
        Update = function(NewValue)
            ApplyVisual(NewValue == true)
        end;
    }

    return Row
end

function VexUI:BindThemeColor(Object, PropertyName, ThemeKey)
    if not Object or not PropertyName or not ThemeKey then
        return
    end

    Object[PropertyName] = Theme[ThemeKey] or Object[PropertyName]

    BindTheme(ThemeKey, function(Color)
        if Object and Object.Parent then
            Object[PropertyName] = Color
        end
    end)
end

function Explorer:CreateColorRow(Object, PropertyName, Value, Parent)
    local Row = self:CreatePropertyRow(Parent)
    self:CreatePropertyLabel(Row, PropertyName)

    local Container = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(0.58, -8, 1, 0);
        Position = UDim2.new(0.42, 0, 0, 0);
        BackgroundTransparency = 1;
        Parent = Row;
    })

    local TextLabel = VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, -52, 1, 0);
        BackgroundTransparency = 1;
        Font = Fonts.Mono;
        Text = self:FormatValue(Value);
        TextColor3 = Theme.PropString;
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Right;
        Parent = Container;
    })

    local Swatch = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(0, 44, 0, 18);
        Position = UDim2.new(1, -44, 0.5, -9);
        BackgroundColor3 = (typeof(Value) == "BrickColor") and Value.Color or Value;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Text = "";
        Parent = Container;
    })
    VexUI:AddStroke(Swatch, "Border", 1)

    Swatch.MouseButton1Click:Connect(function()
        local Current = SafeGet(Object, PropertyName)
        if Current == nil then return end
        local CurrentColor = (typeof(Current) == "BrickColor") and Current.Color or Current
        self:OpenColorPicker(CurrentColor, function(NewColor)
            local FinalValue = (typeof(Value) == "BrickColor") and BrickColor.new(NewColor) or NewColor
            self:ApplyToSelection(PropertyName, FinalValue)
        end)
    end)

    self.PropertyRows[PropertyName] = {
        Update = function(NewValue)
            TextLabel.Text = self:FormatValue(NewValue)
            Swatch.BackgroundColor3 = (typeof(NewValue) == "BrickColor") and NewValue.Color or NewValue
        end;
    }
    self:AttachPropertyCopyHandler(Row, Object, PropertyName)
end

function Explorer:CreateEnumRow(Object, PropertyName, Value, Parent)
    local Row = self:CreatePropertyRow(Parent)
    self:CreatePropertyLabel(Row, PropertyName)

    local EnumType = Value.EnumType
    local EnumName = tostring(EnumType):gsub("Enum%.", "")

    local Button = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(0.58, -12, 0, 20);
        Position = UDim2.new(0.42, 4, 0.5, -10);
        BackgroundColor3 = Theme.Field;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Font = Fonts.Mono;
        Text = `{Value.Name}`;
        TextColor3 = Theme.PropEnum;
        TextSize = 11;
        TextXAlignment = Enum.TextXAlignment.Left;
        Parent = Row;
    })
    VexUI:AddStroke(Button, "Border", 1)
    VexUI:AddPadding(Button, 0, 8, 0, 8)

    Button.MouseButton1Click:Connect(function()
        local Focused = Services.UserInputService:GetFocusedTextBox()
        if Focused then
            pcall(function()
                Focused:ReleaseFocus()
            end)
        end

        local Items = EnumType:GetEnumItems()
        self:OpenListModal(EnumName:upper(), Items,
            function(Item)
                return Item.Name
            end,
            function(Selected)
                self:ApplyToSelection(PropertyName, Selected)
                self:CloseModal()
            end,
            true
        )
    end)

    self.PropertyRows[PropertyName] = {
        Update = function(NewValue)
            if typeof(NewValue) == "EnumItem" then
                Button.Text = `{NewValue.Name}`
            end
        end;
    }
    self:AttachPropertyCopyHandler(Row, Object, PropertyName)
end

function Explorer:RefreshPropertyValues()
    if not self.SelectedInstance then
        return
    end

    local Focused = Services.UserInputService:GetFocusedTextBox()
    local Object = self.SelectedInstance

    for PropertyName, RowState in self.PropertyRows do
        if not (RowState.Input and RowState.Input == Focused) then
            local Good, NewValue = pcall(function()
                return Object[PropertyName]
            end)

            if Good and RowState.Update then
                pcall(RowState.Update, NewValue)
            end
        end
    end
end

function Explorer:CreatePropertyCategoryHeader(Parent, CategoryName)
    local Holder = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 22);
        BackgroundTransparency = 1;
        Parent = Parent;
    })

    VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0);
        BackgroundTransparency = 1;
        Font = Fonts.Bold;
        Text = CategoryName:upper();
        TextColor3 = Theme.TextHeader;
        TextSize = 10;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextYAlignment = Enum.TextYAlignment.Bottom;
        Parent = Holder;
    })

    return Holder
end

function Explorer:GetPropertyCategoryFor(PropertyName, Object)
    for _, Group in PropertyGroups do
        local Good, Matches = pcall(function()
            return Object:IsA(Group.Class) 
        end)

        if Good and Matches then
            for _, Name in Group.Properties do
                if Name == PropertyName then
                    return Group.Class
                end
            end
        end
    end

    return "Other"
end

function Explorer:RenderAttributesSection(Object, Parent, OrderStart)
    local Items = CollectAttributes(Object)
    if #Items == 0 then
        return OrderStart
    end

    local Order = OrderStart
    VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18);
        BackgroundTransparency = 1;
        Font = Fonts.Bold;
        Text = "ATTRIBUTES";
        TextColor3 = Theme.TextHeader;
        TextSize = 11;
        TextXAlignment = Enum.TextXAlignment.Left;
        LayoutOrder = Order;
        Parent = Parent;
    })

    Order += 1

    for _, Entry in Items do
        local SetValue = function(NewValue)
            pcall(function()
                Object:SetAttribute(Entry.Name, NewValue)
            end)
        end

        self:CreatePropertyRow(Parent, Order, Entry.Name, Entry.Value, typeof(Entry.Value), SetValue, true)
        Order += 1
    end

    return Order
end

function Explorer:RenderTagsSection(Object, Parent, OrderStart)
    local Tags = CollectTags(Object)
    if #Tags == 0 then
        return OrderStart
    end

    local Order = OrderStart
    VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18);
        BackgroundTransparency = 1;
        Font = Fonts.Bold;
        Text = "TAGS";
        TextColor3 = Theme.TextHeader;
        TextSize = 11;
        TextXAlignment = Enum.TextXAlignment.Left;
        LayoutOrder = Order;
        Parent = Parent;
    })

    Order += 1

    for _, Tag in Tags do
        local Row = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 22);
            BackgroundTransparency = 1;
            LayoutOrder = Order;
            Parent = Parent;
        })

        VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, -52, 1, 0);
            BackgroundTransparency = 1;
            Font = Fonts.Mono;
            Text = tostring(Tag);
            TextColor3 = Theme.PropString;
            TextSize = 12;
            TextXAlignment = Enum.TextXAlignment.Left;
            Parent = Row;
        })

        local RemoveButton = VexUI:CreateInstance("TextButton", {
            Size = UDim2.new(0, 48, 0, 18);
            Position = UDim2.new(1, -48, 0.5, -9);
            BackgroundColor3 = Theme.Field;
            BorderSizePixel = 0;
            AutoButtonColor = false;
            Font = Fonts.SemiBold;
            Text = "Remove";
            TextColor3 = Theme.Text;
            TextSize = 10;
            Parent = Row;
        })
        VexUI:AddStroke(RemoveButton, "Border", 1)

        RemoveButton.MouseButton1Click:Connect(function()
            pcall(function()
                Services.CollectionService:RemoveTag(Object, Tag)
            end)

            if self.SelectedInstance == Object then
                self:RenderProperties(Object)
            end
        end)

        Order += 1
    end

    return Order
end

function Explorer:RenderProperties(Object)
    Handle(function()
        self:ClearPropertyConnections()
        self.PropertyRows = {}
        self:ClearPropertiesContent()

        if self.PropertiesTitleLabel then
            if #self.SelectedOrder > 1 then
                self.PropertiesTitleLabel.Text = `{Object.ClassName}  -  {Object.Name}   ({#self.SelectedOrder} selected)`
            else
                self.PropertiesTitleLabel.Text = `{Object.ClassName}  -  {Object.Name}`
            end
        end

        local PropertyNames = CollectProperties(Object)
        local Filter = (self.PropertyFilter or ""):lower()

        local Buckets = {}
        local BucketOrder = {}
        for _, PropertyName in PropertyNames do
            if Filter ~= "" and not PropertyName:lower():find(Filter, 1, true) then
                continue
            end

            local Category = self:GetPropertyCategoryFor(PropertyName, Object)
            if not Buckets[Category] then
                Buckets[Category] = {}
                table.insert(BucketOrder, Category)
            end

            table.insert(Buckets[Category], PropertyName)
        end

        local function AddSpacer(Height)
            VexUI:CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, Height);
                BackgroundTransparency = 1;
                Parent = self.PropertiesContent;
            })
        end

        local function AddDivider()
            local Divider = VexUI:CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 1);
                BackgroundColor3 = Theme.BorderSoft;
                BorderSizePixel = 0;
                Parent = self.PropertiesContent;
            })
            BindTheme("BorderSoft", function(Color)
                Divider.BackgroundColor3 = Color
            end)
        end

        for _, Category in BucketOrder do
            self:CreatePropertyCategoryHeader(self.PropertiesContent, Category)
            AddSpacer(4)

            local GroupHolder = VexUI:CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 0);
                AutomaticSize = Enum.AutomaticSize.Y;
                BackgroundTransparency = 1;
                Parent = self.PropertiesContent;
            })

            VexUI:AddListLayout(GroupHolder, 1, Enum.FillDirection.Vertical)

            for _, PropertyName in Buckets[Category] do
                local Good, Value = pcall(function()
                    return Object[PropertyName]
                end)

                if not Good then
                    continue
                end

                local IsReadOnly = ReadOnlyProperties[PropertyName] == true or PropertyName == "Parent"
                local ValueType = typeof(Value)

                if ValueType == "boolean" and not IsReadOnly then
                    self:CreateBooleanRow(Object, PropertyName, Value, GroupHolder)
                elseif (ValueType == "Color3" or ValueType == "BrickColor") and not IsReadOnly then
                    self:CreateColorRow(Object, PropertyName, Value, GroupHolder)
                elseif ValueType == "EnumItem" and not IsReadOnly then
                    self:CreateEnumRow(Object, PropertyName, Value, GroupHolder)
                else
                    local Editable = not IsReadOnly and self:IsEditableValue(Value)
                    self:CreateTextRow(Object, PropertyName, Value, Editable, GroupHolder)
                end

                local Connected, Connection = pcall(function()
                    if typeof(Object) ~= "Instance" then
                        return nil
                    end

                    local Signal = Object:GetPropertyChangedSignal(PropertyName)
                    if not Signal then
                        return nil
                    end

                    return Signal:Connect(function()
                        local ReadGood, NewValue = pcall(function()
                            return Object[PropertyName]
                        end)

                        local RowState = self.PropertyRows[PropertyName]
                        if ReadGood and RowState and RowState.Update then
                            RowState.Update(NewValue)
                        end
                    end)
                end)

                if Connected and Connection then
                    table.insert(self.PropertyConnections, Connection)
                end
            end

            AddSpacer(6)
            AddDivider()
            AddSpacer(4)
        end

        local Attributes = CollectAttributes(Object)
        if Filter ~= "" then
            local Kept = {}
            for _, Entry in Attributes do
                if Entry.Name:lower():find(Filter, 1, true) then
                    table.insert(Kept, Entry)
                end
            end
            Attributes = Kept
        end

        if #Attributes > 0 or Filter == "" then
            self:CreatePropertyCategoryHeader(self.PropertiesContent, "Attributes")
            AddSpacer(4)

            local AttributeHolder = VexUI:CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 0);
                AutomaticSize = Enum.AutomaticSize.Y;
                BackgroundTransparency = 1;
                Parent = self.PropertiesContent;
            })
            VexUI:AddListLayout(AttributeHolder, 1, Enum.FillDirection.Vertical)

            if #Attributes == 0 then
                VexUI:CreateInstance("TextLabel", {
                    Size = UDim2.new(1, 0, 0, 22);
                    BackgroundTransparency = 1;
                    Font = Fonts.Medium;
                    Text = `  (no attributes)`;
                    TextColor3 = Theme.TextFaded;
                    TextSize = 12;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    Parent = AttributeHolder;
                })
            else
                for _, Entry in Attributes do
                    local Name = Entry.Name
                    local Value = Entry.Value
                    local ValueType = typeof(Value)

                    local StringValue = ValueType == "string" and Value:lower() or nil
                    local IsBooleanLikeAttribute = ValueType == "boolean"
                        or StringValue == "true"
                        or StringValue == "false"

                    local InitialBoolValue = Value == true or StringValue == "true"

                    if IsBooleanLikeAttribute then
                        local Row = self:CreatePropertyRow(AttributeHolder)
                        self:CreatePropertyLabel(Row, Name)

                        for _, Child in Row:GetChildren() do
                            if Child:IsA("TextLabel") and Child.Text == Name then
                                Child.TextColor3 = Theme.PropEnum
                            end
                        end

                        local Toggle = VexUI:CreateInstance("TextButton", {
                            Size = UDim2.new(0, 56, 0, 18);
                            Position = UDim2.new(1, -64, 0.5, -9);
                            BackgroundColor3 = InitialBoolValue and Theme.Accent or Theme.Field;
                            BorderSizePixel = 0;
                            AutoButtonColor = false;
                            Font = Fonts.SemiBold;
                            Text = InitialBoolValue and "true" or "false";
                            TextColor3 = Theme.Text;
                            TextSize = 11;
                            ZIndex = 203;
                            Parent = Row;
                        })

                        VexUI:AddStroke(Toggle, InitialBoolValue and Theme.Accent or "Border", 1)

                        local function ApplyAttributeToggleVisual(NewValue)
                            local NewType = typeof(NewValue)
                            local NewString = NewType == "string" and NewValue:lower() or nil
                            local BoolValue = NewValue == true or NewString == "true"

                            Toggle.BackgroundColor3 = BoolValue and Theme.Accent or Theme.Field
                            Toggle.Text = BoolValue and "true" or "false"

                            local Stroke = Toggle:FindFirstChildOfClass("UIStroke")
                            if Stroke then
                                Stroke.Color = BoolValue and Theme.Accent or Theme.Border
                            end
                        end

                        Toggle.MouseButton1Click:Connect(function()
                            local CurrentValue = Object:GetAttribute(Name)
                            local CurrentType = typeof(CurrentValue)
                            local CurrentString = CurrentType == "string" and CurrentValue:lower() or nil
                            local CurrentBool = CurrentValue == true or CurrentString == "true"

                            local NewValue = not CurrentBool

                            for _, Obj in self:GetSelectionList() do
                                pcall(function()
                                    Obj:SetAttribute(Name, NewValue)
                                end)
                            end

                            ApplyAttributeToggleVisual(NewValue)
                        end)

                        self.PropertyRows[`@{Name}`] = {
                            Update = function(NewValue)
                                ApplyAttributeToggleVisual(NewValue)
                            end;
                        }

                    elseif ValueType == "Color3" or ValueType == "BrickColor" then
                        self:CreateColorRow(Object, `@{Name}`, Value, AttributeHolder)
                    else
                        local Editable = self:IsEditableValue(Value)
                        self:CreateTextRow(Object, `@{Name}`, Value, Editable, AttributeHolder)
                    end

                    local Row = AttributeHolder:GetChildren()[#AttributeHolder:GetChildren()]
                    if Row then
                        for _, Child in Row:GetChildren() do
                            if Child:IsA("TextLabel") and Child.Text == `@{Name}` then
                                Child.Text = Name
                                Child.TextColor3 = Theme.PropEnum
                            end
                        end

                        local ClickCatcher = VexUI:CreateInstance("Frame", {
                            Size = UDim2.new(1, 0, 1, 0);
                            BackgroundTransparency = 1;
                            BorderSizePixel = 0;
                            ZIndex = 199;
                            Parent = Row;
                        })

                        ClickCatcher.InputBegan:Connect(function(Input)
                            if Input.UserInputType ~= Enum.UserInputType.MouseButton2 then
                                return
                            end

                            local CurrentValue = Object:GetAttribute(Name)
                            local PathExpr = BuildLuaPath(Object)
                            local Code = `{PathExpr}:SetAttribute("{Name}", {SerializeValue(CurrentValue)})`
                            pcall(setclipboard, Code)
                            self:Notify(`Copied attribute "{Name}"`)
                        end)
                    end

                    local AttrConnGood, AttrConn = pcall(function()
                        return Object:GetAttributeChangedSignal(Name):Connect(function()
                            local NewValue = Object:GetAttribute(Name)
                            local RowState = self.PropertyRows[`@{Name}`]
                            if RowState and RowState.Update then
                                pcall(RowState.Update, NewValue)
                            end
                        end)
                    end)

                    if AttrConnGood and AttrConn then
                        table.insert(self.PropertyConnections, AttrConn)
                    end
                end
            end

            AddSpacer(4)

            local AttributeButtonRow = VexUI:CreateInstance("Frame", {
                Size = UDim2.new(1, 0, 0, 26);
                BackgroundTransparency = 1;
                Parent = self.PropertiesContent;
            })

            local AttributeButtonLayout = VexUI:AddListLayout(
                AttributeButtonRow,
                4,
                Enum.FillDirection.Horizontal
            )

            AttributeButtonLayout.FillDirection = Enum.FillDirection.Horizontal

            local function CreateAttributeButton(ButtonText, Callback)
                local Button = VexUI:CreateInstance("TextButton", {
                    Size = UDim2.new(0.25, -3, 1, 0);
                    BackgroundColor3 = Theme.Field;
                    BorderSizePixel = 0;
                    AutoButtonColor = false;
                    Font = Fonts.SemiBold;
                    Text = ButtonText;
                    TextColor3 = Theme.Text;
                    TextSize = 11;
                    Parent = AttributeButtonRow;
                })

                VexUI:AddStroke(Button, "Border", 1)

                Button.MouseButton1Click:Connect(Callback)

                return Button
            end

            CreateAttributeButton("Add", function()
                self:OpenAttributeModal("Add Attribute", nil, nil)
            end)

            CreateAttributeButton("Edit", function()
                self:OpenEditAttributeModal()
            end)

            CreateAttributeButton("Remove", function()
                self:OpenRemoveAttributeModal()
            end)

            CreateAttributeButton("Copy", function()
                local AttrGood, AttrMap = pcall(function() return Object:GetAttributes() end)
                if not AttrGood or type(AttrMap) ~= "table" then
                    self:Notify("No attributes")
                    return
                end

                local Names = {}
                for K in AttrMap do table.insert(Names, K) end
                table.sort(Names)

                if #Names == 0 then
                    self:Notify("No attributes")
                    return
                end

                local PathExpr = BuildLuaPath(Object)
                local Lines = {}
                for _, K in Names do
                    table.insert(Lines, `{PathExpr}:SetAttribute("{K}", {SerializeValue(AttrMap[K])})`)
                end

                pcall(setclipboard, table.concat(Lines, "\n"))
                self:Notify(`Copied {#Names} attribute(s)`)
            end)

            AddSpacer(6)
            AddDivider()
            AddSpacer(4)
        end

        local Tags = CollectTags(Object)
        self:CreatePropertyCategoryHeader(self.PropertiesContent, "Tags")
        AddSpacer(4)

        local TagsHolder = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 0);
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundTransparency = 1;
            Parent = self.PropertiesContent;
        })
        VexUI:AddListLayout(TagsHolder, 1, Enum.FillDirection.Vertical)

        if #Tags == 0 then
            VexUI:CreateInstance("TextLabel", {
                Size = UDim2.new(1, 0, 0, 22);
                BackgroundTransparency = 1;
                Font = Fonts.Medium;
                Text = `  (no tags)`;
                TextColor3 = Theme.TextFaded;
                TextSize = 12;
                TextXAlignment = Enum.TextXAlignment.Left;
                Parent = TagsHolder;
            })
        else
            for _, Tag in Tags do
                local TagName = tostring(Tag)
                local Row = self:CreatePropertyRow(TagsHolder)
                VexUI:CreateInstance("TextLabel", {
                    Size = UDim2.new(1, -16, 1, 0);
                    Position = UDim2.new(0, 8, 0, 0);
                    BackgroundTransparency = 1;
                    Font = Fonts.Mono;
                    Text = TagName;
                    TextColor3 = Theme.PropString;
                    TextSize = 12;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextTruncate = Enum.TextTruncate.AtEnd;
                    Parent = Row;
                })

                local ClickCatcher = VexUI:CreateInstance("Frame", {
                    Size = UDim2.new(1, 0, 1, 0);
                    BackgroundTransparency = 1;
                    BorderSizePixel = 0;
                    ZIndex = 199;
                    Parent = Row;
                })

                ClickCatcher.InputBegan:Connect(function(Input)
                    if Input.UserInputType ~= Enum.UserInputType.MouseButton2 then
                        return
                    end
                    
                    local PathExpr = BuildLuaPath(Object)
                    local Code = `game:GetService("CollectionService"):AddTag({PathExpr}, "{TagName}")`
                    pcall(setclipboard, Code)
                    self:Notify(`Copied tag "{TagName}"`)
                end)
            end
        end

        AddSpacer(4)

        local TagButtonRow = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 26);
            BackgroundTransparency = 1;
            Parent = self.PropertiesContent;
        })

        VexUI:AddListLayout(
            TagButtonRow,
            6,
            Enum.FillDirection.Horizontal
        )

        local function CreateTagButton(ButtonText, Callback)
            local Button = VexUI:CreateInstance("TextButton", {
                Size = UDim2.new(1 / 3, -3, 1, 0);
                BackgroundColor3 = Theme.Field;
                BorderSizePixel = 0;
                AutoButtonColor = false;
                Font = Fonts.SemiBold;
                Text = ButtonText;
                TextColor3 = Theme.Text;
                TextSize = 11;
                Parent = TagButtonRow;
            })

            VexUI:AddStroke(Button, "Border", 1)

            Button.MouseButton1Click:Connect(Callback)

            return Button
        end

        CreateTagButton("Add Tag", function()
            self:OpenAddTagModal()
        end)

        CreateTagButton("Remove Tag", function()
            self:OpenRemoveTagModal()
        end)

        CreateTagButton("Copy Tags", function()
            local TagsGood, AllTags = pcall(function()
                return Services.CollectionService:GetTags(Object)
            end)

            if not TagsGood or type(AllTags) ~= "table" or #AllTags == 0 then
                self:Notify("No tags")
                return
            end

            local PathExpr = BuildLuaPath(Object)
            local Lines = {`local CollectionService = game:GetService("CollectionService")`}
            for _, Tag in AllTags do
                table.insert(Lines, `CollectionService:AddTag({PathExpr}, "{Tag}")`)
            end

            pcall(setclipboard, table.concat(Lines, "\n"))
            self:Notify(`Copied {#AllTags} tag(s)`)
        end)

        AddSpacer(6)
        AddDivider()
        AddSpacer(4)

        if #PropertyNames == 0 and #Attributes == 0 and #Tags == 0 then
            self:AddPropertiesLabel("No registered properties for this class.")
        end
    end, "Function Explorer.RenderProperties")
end

function Explorer:CloseModal()
    if self.ModalWindow then
        self.ModalWindow:Destroy()
        self.ModalWindow = nil
    end

    if self.ModalBlocker then
        self.ModalBlocker:Destroy()
        self.ModalBlocker = nil
    end
end

function Explorer:CreateModalWindow(Title, Width, Height, Options)
    Options = Options or {}

    if not Options.KeepExisting then
        self:CloseModal()
    end

    local Blocker = nil

    if not Options.Floating then
        Blocker = VexUI:CreateInstance("TextButton", {
            Size = UDim2.fromScale(1, 1);
            BackgroundColor3 = Color3.fromRGB(0, 0, 0);
            BackgroundTransparency = UITransparency.ModalOverlay;
            BorderSizePixel = 0;
            AutoButtonColor = false;
            Text = "";
            Modal = true;
            ZIndex = 200;
            Parent = self.ScreenGui;
        })

        BindTransparency("ModalOverlay", function(Value)
            if Blocker and Blocker.Parent then
                Blocker.BackgroundTransparency = Value
            end
        end)
    end

    local Window = VexUI:CreateInstance("Frame", {
        Size = UDim2.fromOffset(Width, Height);
        Position = UDim2.new(0.5, -Width / 2, 0.5, -Height / 2);
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        ClipsDescendants = true;
        ZIndex = 201;
        Parent = self.ScreenGui;
    })

    if Options.Position then
        Window.Position = Options.Position
    end

    local WindowStroke = VexUI:AddStroke(Window, "Border", 1)
    BindTheme("Window", function(Color) Window.BackgroundColor3 = Color end)
    BindTheme("Border", function(Color) WindowStroke.Color = Color end)

    local TitleBar = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 32);
        BackgroundColor3 = Theme.TitleBar;
        BackgroundTransparency = UITransparency.TitleBar;
        BorderSizePixel = 0;
        ZIndex = 202;
        Parent = Window;
    })

    BindTransparency("TitleBar", function(Value)
        if TitleBar and TitleBar.Parent then
            TitleBar.BackgroundTransparency = Value
        end
    end)
    BindTheme("TitleBar", function(Color) TitleBar.BackgroundColor3 = Color end)

    local ModalBodyBackground = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, -32);
        Position = UDim2.new(0, 0, 0, 32);
        BackgroundColor3 = Theme.Window;
        BackgroundTransparency = UITransparency.Window;
        BorderSizePixel = 0;
        ZIndex = 201;
        Parent = Window;
    })

    BindTheme("Window", function(Color)
        ModalBodyBackground.BackgroundColor3 = Color
    end)

    BindTransparency("Window", function(Value)
        ModalBodyBackground.BackgroundTransparency = Value
    end)

    VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 1);
        Position = UDim2.new(0, 0, 1, -1);
        BackgroundColor3 = Theme.Border;
        BorderSizePixel = 0;
        ZIndex = 204;
        Parent = TitleBar;
    })

    VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, -80, 1, 0);
        Position = UDim2.new(0, 12, 0, 0);
        BackgroundTransparency = 1;
        Font = Fonts.Bold;
        Text = Title:upper();
        TextColor3 = Theme.Text;
        TextSize = 11;
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = 203;
        Parent = TitleBar;
    })

    local CloseAssetId = GetUIAssetId("CloseIcon")
    local CloseButton = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(0, 24, 0, 20);
        Position = UDim2.new(1, -32, 0.5, -10);
        BackgroundColor3 = Theme.Border;
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Font = Fonts.Bold;
        Text = CloseAssetId and "" or "x";
        TextColor3 = Theme.TextDim;
        TextSize = 10;
        ZIndex = 203;
        Parent = TitleBar;
    })
    VexUI:AddStroke(CloseButton, "Border", 1)

    local CloseIcon
    if CloseAssetId then
        CloseIcon = VexUI:CreateInstance("ImageLabel", {
            Size = UDim2.fromOffset(12, 12);
            Position = UDim2.new(0.5, -6, 0.5, -6);
            BackgroundTransparency = 1;
            Image = CloseAssetId;
            ImageColor3 = Theme.TextDim;
            ScaleType = Enum.ScaleType.Fit;
            ZIndex = 204;
            Parent = CloseButton;
        })
    end

    CloseButton.MouseButton1Click:Connect(function()
        if Options.Floating then
            Window:Destroy()
        else
            self:CloseModal()
        end
    end)

    local CloseHovered = false
    local function ApplyCloseButtonVisual(UseTween)
        local TitleTransparency = UITransparency.TitleBar or 0
        local TargetTransparency

        if CloseHovered then
            TargetTransparency = math.clamp(TitleTransparency * 0.55, 0, 0.9)
        else
            TargetTransparency = math.clamp(TitleTransparency + 0.05, 0, 0.96)
        end

        local TargetBackground = CloseHovered and Theme.Selected or Theme.Border
        local TargetColor = CloseHovered and Theme.Text or Theme.TextDim

        if UseTween then
            VexUI:Tween(CloseButton, {
                BackgroundColor3 = TargetBackground;
                BackgroundTransparency = TargetTransparency;
                TextColor3 = TargetColor;
            })
        else
            CloseButton.BackgroundColor3 = TargetBackground
            CloseButton.BackgroundTransparency = TargetTransparency
            CloseButton.TextColor3 = TargetColor
        end

        if CloseIcon then
            if UseTween then
                VexUI:Tween(CloseIcon, {
                    ImageColor3 = TargetColor;
                })
            else
                CloseIcon.ImageColor3 = TargetColor
            end
        end
    end

    BindTransparency("TitleBar", function()
        if CloseButton and CloseButton.Parent then
            ApplyCloseButtonVisual(false)
        end
    end)

    CloseButton.MouseEnter:Connect(function()
        CloseHovered = true
        ApplyCloseButtonVisual(true)
    end)

    CloseButton.MouseLeave:Connect(function()
        CloseHovered = false
        ApplyCloseButtonVisual(true)
    end)

    ApplyCloseButtonVisual(false)

    local Body = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, -20, 1, -44);
        Position = UDim2.new(0, 10, 0, 38);
        BackgroundTransparency = 1;
        ZIndex = 202;
        Parent = Window;
    })

    local DragStart, StartPos
    local Dragging = false
    TitleBar.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = Input.Position
            StartPos = Window.Position
        end
    end)

    Track(Services.UserInputService.InputChanged:Connect(function(Input)
        if not Dragging or not Window.Parent then
            return
        end

        if Input.UserInputType ~= Enum.UserInputType.MouseMovement then
            return
        end

        local Delta = Input.Position - DragStart
        Window.Position = UDim2.new(
            StartPos.X.Scale, StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y
        )
    end))

    Track(Services.UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = false
        end
    end))

    if not Options.Floating then
        self.ModalWindow = Window
        self.ModalBlocker = Blocker
    end

    if Options.Resizable then
        local MinW = Options.MinWidth or 320
        local MinH = Options.MinHeight or 240
        local EdgeThickness = 6

        local function BringToFront() end

        local function MakeEdge(Position, Size, DirX, DirY)
            local Edge = VexUI:CreateInstance("Frame", {
                Position = Position;
                Size = Size;
                BackgroundTransparency = 1;
                ZIndex = 210;
                Active = true;
                Parent = Window;
            })

            local Resizing = false
            local StartInput, StartSize, StartPosition

            Edge.InputBegan:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1
                    or Input.UserInputType == Enum.UserInputType.Touch
                then
                    Resizing = true
                    StartInput = Input.Position
                    StartSize = Window.AbsoluteSize
                    StartPosition = Window.Position
                end
            end)

            Track(Services.UserInputService.InputChanged:Connect(function(Input)
                if not Resizing or not Window.Parent then return end
                if Input.UserInputType ~= Enum.UserInputType.MouseMovement
                    and Input.UserInputType ~= Enum.UserInputType.Touch
                then return end

                local Delta = Input.Position - StartInput
                local NewW = StartSize.X
                local NewH = StartSize.Y
                local NewX = StartPosition.X.Offset
                local NewY = StartPosition.Y.Offset

                if DirX == 1 then
                    NewW = math.max(MinW, StartSize.X + Delta.X)
                elseif DirX == -1 then
                    local Width = math.max(MinW, StartSize.X - Delta.X)
                    NewX = StartPosition.X.Offset + (StartSize.X - Width)
                    NewW = Width
                end

                if DirY == 1 then
                    NewH = math.max(MinH, StartSize.Y + Delta.Y)
                elseif DirY == -1 then
                    local Height = math.max(MinH, StartSize.Y - Delta.Y)
                    NewY = StartPosition.Y.Offset + (StartSize.Y - Height)
                    NewH = Height
                end

                Window.Size = UDim2.fromOffset(NewW, NewH)
                Window.Position = UDim2.new(StartPosition.X.Scale, NewX, StartPosition.Y.Scale, NewY)
            end))

            Track(Services.UserInputService.InputEnded:Connect(function(Input)
                if Input.UserInputType == Enum.UserInputType.MouseButton1
                    or Input.UserInputType == Enum.UserInputType.Touch
                then
                    Resizing = false
                end
            end))
        end

        MakeEdge(UDim2.new(1, -EdgeThickness, 0, EdgeThickness), UDim2.new(0, EdgeThickness, 1, -EdgeThickness * 2), 1, 0)
        MakeEdge(UDim2.new(0, 0, 0, EdgeThickness), UDim2.new(0, EdgeThickness, 1, -EdgeThickness * 2), -1, 0)
        MakeEdge(UDim2.new(0, EdgeThickness, 1, -EdgeThickness), UDim2.new(1, -EdgeThickness * 2, 0, EdgeThickness), 0, 1)
        MakeEdge(UDim2.new(0, EdgeThickness, 0, 0), UDim2.new(1, -EdgeThickness * 2, 0, EdgeThickness), 0, -1)
        MakeEdge(UDim2.new(1, -EdgeThickness, 1, -EdgeThickness), UDim2.fromOffset(EdgeThickness, EdgeThickness), 1, 1)
        MakeEdge(UDim2.new(0, 0, 1, -EdgeThickness), UDim2.fromOffset(EdgeThickness, EdgeThickness), -1, 1)
        MakeEdge(UDim2.new(1, -EdgeThickness, 0, 0), UDim2.fromOffset(EdgeThickness, EdgeThickness), 1, -1)
        MakeEdge(UDim2.new(0, 0, 0, 0), UDim2.fromOffset(EdgeThickness, EdgeThickness), -1, -1)
    end

    return Window, Body
end

function Explorer:OpenColorPicker(CurrentColor, Callback, Options)
    Options = Options or {}

    local InitialColor = CurrentColor or Color3.fromRGB(255, 255, 255)
    local OnApply = Callback or function() end

    local PickerWidth = 320
    local PickerHeight = 420
    local WindowPosition = nil

    if Options.Floating and Options.AnchorWindow and Options.AnchorWindow.Parent then
        local Camera = workspace.CurrentCamera
        local Viewport = Camera and Camera.ViewportSize or Vector2.new(1366, 768)

        local AnchorPosition = Options.AnchorWindow.AbsolutePosition
        local AnchorSize = Options.AnchorWindow.AbsoluteSize

        local X = AnchorPosition.X + AnchorSize.X + 8
        local Y = AnchorPosition.Y

        if X + PickerWidth > Viewport.X then
            X = AnchorPosition.X - PickerWidth - 8
        end

        if Y + PickerHeight > Viewport.Y then
            Y = math.max(0, Viewport.Y - PickerHeight)
        end

        X = math.max(0, X)
        Y = math.max(0, Y)

        WindowPosition = UDim2.fromOffset(X, Y)
    end
    
    local Window, Body = self:CreateModalWindow("Color Picker", PickerWidth, PickerHeight, {
        KeepExisting = Options.Floating == true;
        Floating = Options.Floating == true;
        Position = WindowPosition;
    })

    VexUI:AddListLayout(Body, 8, Enum.FillDirection.Vertical)

    local PickerConns = {}
    local function PConn(Signal, Fn)
        local C = Signal:Connect(Fn)
        table.insert(PickerConns, C)
        Track(C)
        return C
    end

    Window.AncestryChanged:Connect(function(_, Parent)
        if Parent == nil then
            for _, C in PickerConns do
                pcall(function() C:Disconnect() end)
            end
            table.clear(PickerConns)
        end
    end)

    local H, S, V = Color3.toHSV(InitialColor)
    local R = math.floor(InitialColor.R * 255 + 0.5)
    local G = math.floor(InitialColor.G * 255 + 0.5)
    local B = math.floor(InitialColor.B * 255 + 0.5)
    local Updating = false

    local Preview = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 36);
        BackgroundColor3 = InitialColor;
        BorderSizePixel = 0;
        LayoutOrder = 1;
        ZIndex = 202;
        Parent = Body;
    })
    VexUI:AddStroke(Preview, "Border", 1)

    local SVBox = VexUI:CreateInstance("ImageButton", {
        Size = UDim2.new(1, 0, 0, 140);
        BackgroundColor3 = Color3.fromHSV(H, 1, 1);
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Image = "";
        LayoutOrder = 2;
        ZIndex = 202;
        Parent = Body;
    })

    local WhiteOverlay = VexUI:CreateInstance("Frame", {
        Size = UDim2.fromScale(1, 1);
        BackgroundColor3 = Color3.new(1,1,1);
        BorderSizePixel = 0;
        ZIndex = 203;
        Parent = SVBox;
    })
    VexUI:CreateInstance("UIGradient", {
        Color = ColorSequence.new(Color3.new(1,1,1));
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0),
            NumberSequenceKeypoint.new(1, 1),
        });
        Parent = WhiteOverlay;
    })

    local BlackOverlay = VexUI:CreateInstance("Frame", {
        Size = UDim2.fromScale(1, 1);
        BackgroundColor3 = Color3.new(0,0,0);
        BorderSizePixel = 0;
        ZIndex = 204;
        Parent = SVBox;
    })
    VexUI:CreateInstance("UIGradient", {
        Color = ColorSequence.new(Color3.new(0,0,0));
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(1, 0),
        });
        Rotation = 90;
        Parent = BlackOverlay;
    })

    local SVCursor = VexUI:CreateInstance("Frame", {
        Size = UDim2.fromOffset(10, 10);
        Position = UDim2.fromScale(S, 1 - V);
        AnchorPoint = Vector2.new(0.5, 0.5);
        BackgroundTransparency = 1;
        ZIndex = 205;
        Parent = SVBox;
    })
    VexUI:AddStroke(SVCursor, Color3.new(1,1,1), 2)

    local HueStrip = VexUI:CreateInstance("ImageButton", {
        Size = UDim2.new(1, 0, 0, 18);
        BackgroundColor3 = Color3.new(1,1,1);
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Image = "";
        LayoutOrder = 3;
        ZIndex = 202;
        Parent = Body;
    })
    VexUI:CreateInstance("UIGradient", {
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHSV(0,1, 1)),
            ColorSequenceKeypoint.new(1/6, Color3.fromHSV(1/6, 1, 1)),
            ColorSequenceKeypoint.new(2/6, Color3.fromHSV(2/6, 1, 1)),
            ColorSequenceKeypoint.new(3/6, Color3.fromHSV(3/6, 1, 1)),
            ColorSequenceKeypoint.new(4/6, Color3.fromHSV(4/6, 1, 1)),
            ColorSequenceKeypoint.new(5/6, Color3.fromHSV(5/6, 1, 1)),
            ColorSequenceKeypoint.new(1, Color3.fromHSV(0.999, 1, 1))
        });
        Parent = HueStrip;
    })

    local HueCursor = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(0, 4, 1, 4);
        Position = UDim2.new(H, 0, 0, -2);
        AnchorPoint = Vector2.new(0.5, 0);
        BackgroundColor3 = Color3.new(1,1,1);
        BorderSizePixel = 0;
        ZIndex = 203;
        Parent = HueStrip;
    })
    VexUI:AddStroke(HueCursor, Color3.fromRGB(0,0,0), 1)

    local function CommitColor()
        local C = Color3.fromHSV(H, S, V)
        R = math.floor(C.R * 255 + 0.5)
        G = math.floor(C.G * 255 + 0.5)
        B = math.floor(C.B * 255 + 0.5)
        Preview.BackgroundColor3 = C
        SVBox.BackgroundColor3 = Color3.fromHSV(H, 1, 1)
        SVCursor.Position = UDim2.fromScale(S, 1 - V)
        HueCursor.Position = UDim2.new(H, 0, 0, -2)
        OnApply(C)
    end

    local function FromRGB()
        H, S, V = Color3.toHSV(Color3.fromRGB(R, G, B))
        CommitColor()
    end

    local SVDrag = false
    local function UpdateSV(InputX, InputY)
        local Frac_x = math.clamp((InputX - SVBox.AbsolutePosition.X) / SVBox.AbsoluteSize.X, 0, 1)
        local Frac_y = math.clamp((InputY - SVBox.AbsolutePosition.Y) / SVBox.AbsoluteSize.Y, 0, 1)
        S = Frac_x
        V = 1 - Frac_y
        CommitColor()
    end

    SVBox.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch
        then
            SVDrag = true
            UpdateSV(Input.Position.X, Input.Position.Y)
        end
    end)

    PConn(Services.UserInputService.InputChanged, function(Input)
        if SVDrag and (Input.UserInputType == Enum.UserInputType.MouseMovement
            or Input.UserInputType == Enum.UserInputType.Touch)
        then
            UpdateSV(Input.Position.X, Input.Position.Y)
        end
    end)

    PConn(Services.UserInputService.InputEnded, function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch
        then
            SVDrag = false
        end
    end)

    local HueDrag = false
    local function UpdateHue(InputX)
        local Frac = math.clamp((InputX - HueStrip.AbsolutePosition.X) / HueStrip.AbsoluteSize.X, 0, 0.999)
        H = Frac
        CommitColor()
    end

    HueStrip.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch
        then
            HueDrag = true
            UpdateHue(Input.Position.X)
        end
    end)

    PConn(Services.UserInputService.InputChanged, function(Input)
        if HueDrag and (Input.UserInputType == Enum.UserInputType.MouseMovement
            or Input.UserInputType == Enum.UserInputType.Touch)
        then
            UpdateHue(Input.Position.X)
        end
    end)

    PConn(Services.UserInputService.InputEnded, function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch
        then
            HueDrag = false
        end
    end)

    local function CreateChannelSlider(LabelText, ChannelColor, GetVal, SetVal, OrderIndex)
        local Holder = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 32);
            BackgroundTransparency = 1;
            LayoutOrder = OrderIndex;
            ZIndex = 202;
            Parent = Body;
        })

        VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(0, 14, 0, 14);
            BackgroundTransparency = 1;
            Font = Fonts.Bold;
            Text = LabelText;
            TextColor3 = ChannelColor;
            TextSize = 11;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 203;
            Parent = Holder;
        })

        local ValueLabel = VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(0, 32, 0, 14);
            Position = UDim2.new(1, -32, 0, 0);
            BackgroundTransparency = 1;
            Font = Fonts.Mono;
            Text = tostring(GetVal());
            TextColor3 = Theme.Text;
            TextSize = 11;
            TextXAlignment = Enum.TextXAlignment.Right;
            ZIndex = 203;
            Parent = Holder;
        })

        local Tk = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 6);
            Position = UDim2.new(0, 0, 0, 20);
            BackgroundColor3 = Theme.Field;
            BorderSizePixel = 0;
            ZIndex = 203;
            Parent = Holder;
        })

        local Fill = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(GetVal()/255, 0, 1, 0);
            BackgroundColor3 = ChannelColor;
            BorderSizePixel = 0;
            ZIndex = 204;
            Parent = Tk;
        })

        local Hit = VexUI:CreateInstance("TextButton", {
            Size = UDim2.new(1, 0, 0, 22);
            Position = UDim2.new(0, 0, 0, 12);
            BackgroundTransparency = 1;
            AutoButtonColor = false;
            Text = "";
            ZIndex = 204;
            Parent = Holder;
        })

        local Drag = false
        local function Up(X)
            local F = math.clamp((X - Tk.AbsolutePosition.X) / Tk.AbsoluteSize.X, 0, 1)
            local NV = math.floor(F * 255 + 0.5)
            Fill.Size = UDim2.new(F, 0, 1, 0)
            ValueLabel.Text = tostring(NV)
            SetVal(NV)
            FromRGB()
        end

        Hit.InputBegan:Connect(function(I)
            if I.UserInputType == Enum.UserInputType.MouseButton1
                or I.UserInputType == Enum.UserInputType.Touch
            then
                Drag = true Up(I.Position.X)
            end
        end)

        PConn(Services.UserInputService.InputChanged, function(I)
            if Drag
                and (I.UserInputType == Enum.UserInputType.MouseMovement or I.UserInputType == Enum.UserInputType.Touch)
            then
                Up(I.Position.X)
            end
        end)

        PConn(Services.UserInputService.InputEnded, function(I)
            if I.UserInputType == Enum.UserInputType.MouseButton1
                or I.UserInputType == Enum.UserInputType.Touch
            then
                Drag = false
            end
        end)

        return function()
            Fill.Size = UDim2.new(GetVal()/255, 0, 1, 0)
            ValueLabel.Text = tostring(GetVal())
        end
    end

    CreateChannelSlider("R", Theme.Red,
        function()
            return R
        end,
        function(v)
            R = v
        end,
        4
    )

    CreateChannelSlider("G", Theme.Green,
        function()
            return G
        end,
        function(v)
            G = v
        end,
        5
    )

    CreateChannelSlider("B", Theme.Blue,
        function()
            return B
        end,
        function(v)
            B = v
        end,
        6
    )
end

function Explorer:OpenListModal(Title, Items, ItemTextFunction, OnPick, ShowSearch, ItemHeight, ItemIconFunction, Options)
    Options = Options or {}

    local ListWidth = Options.Width or 360
    local ListHeight = Options.Height or 440
    local WindowPosition = nil

    if Options.Floating and Options.AnchorWindow and Options.AnchorWindow.Parent then
        local Camera = workspace.CurrentCamera
        local Viewport = Camera and Camera.ViewportSize or Vector2.new(1366, 768)

        local AnchorPosition = Options.AnchorWindow.AbsolutePosition
        local AnchorSize = Options.AnchorWindow.AbsoluteSize

        local X = AnchorPosition.X + AnchorSize.X + 8
        local Y = AnchorPosition.Y

        if X + ListWidth > Viewport.X then
            X = AnchorPosition.X - ListWidth - 8
        end

        if Y + ListHeight > Viewport.Y then
            Y = math.max(0, Viewport.Y - ListHeight)
        end

        X = math.max(0, X)
        Y = math.max(0, Y)

        WindowPosition = UDim2.fromOffset(X, Y)
    end

    local Window, Body = self:CreateModalWindow(Title, ListWidth, ListHeight, {
        KeepExisting = Options.Floating == true;
        Floating = Options.Floating == true;
        Position = WindowPosition;
    })

    local Layout = VexUI:AddListLayout(Body, 6, Enum.FillDirection.Vertical)
    local Filter = ""
    local SearchBox

    if ShowSearch then
        SearchBox = VexUI:CreateInstance("TextBox", {
            Size = UDim2.new(1, 0, 0, 26);
            BackgroundColor3 = Theme.Field;
            BorderSizePixel = 0;
            Font = Fonts.Mono;
            PlaceholderText = "Search...";
            PlaceholderColor3 = Theme.TextFaded;
            Text = "";
            TextColor3 = Theme.Text;
            TextSize = 11;
            TextXAlignment = Enum.TextXAlignment.Left;
            ClearTextOnFocus = false;
            LayoutOrder = 1;
            ZIndex = 202;
            Parent = Body;
        })
        
        VexUI:AddStroke(SearchBox, "Border", 1)
        VexUI:AddPadding(SearchBox, 0, 8, 0, 8)

        BindTheme("Field", function(Color)
            if SearchBox and SearchBox.Parent then
                SearchBox.BackgroundColor3 = Color
            end
        end)

        BindTheme("Text", function(Color)
            if SearchBox and SearchBox.Parent then
                SearchBox.TextColor3 = Color
            end
        end)

        BindTheme("TextFaded", function(Color)
            if SearchBox and SearchBox.Parent then
                SearchBox.PlaceholderColor3 = Color
            end
        end)
    end

    local Scroll = VexUI:CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, ShowSearch and -34 or 0);
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        ScrollBarThickness = 4;
        ScrollBarImageColor3 = Theme.Border;
        CanvasSize = UDim2.new(0, 0, 0, 0);
        AutomaticCanvasSize = Enum.AutomaticSize.Y;
        ScrollingDirection = Enum.ScrollingDirection.Y;
        LayoutOrder = 2;
        ZIndex = 202;
        Parent = Body;
    })

    VexUI:BindThemeColor(Scroll, "ScrollBarImageColor3", "Border")

    local ListLayout = VexUI:AddListLayout(Scroll, 2, Enum.FillDirection.Vertical)

    local ButtonHeight = ItemHeight or 24
    local Multiline = ButtonHeight >= 36

    local function Render()
        for _, Child in Scroll:GetChildren() do
            if Child:IsA("GuiObject") then
                Child:Destroy()
            end
        end

        local LoweredFilter = Filter:lower()
        for _, Item in Items do
            local Text = ItemTextFunction(Item)
            if LoweredFilter == "" or Text:lower():find(LoweredFilter, 1, true) then
                local IconAssetName = ItemIconFunction and ItemIconFunction(Item)
                local LeftPad = IconAssetName and 26 or 8

                local Button = VexUI:CreateInstance("TextButton", {
                    Size = UDim2.new(1, 0, 0, ButtonHeight);
                    BackgroundColor3 = Theme.Field;
                    BackgroundTransparency = 0.5;
                    BorderSizePixel = 0;
                    AutoButtonColor = false;
                    Font = Fonts.Mono;
                    Text = Text;
                    TextColor3 = Theme.Text;
                    TextSize = 11;
                    TextXAlignment = Enum.TextXAlignment.Left;
                    TextYAlignment = Multiline and Enum.TextYAlignment.Top or Enum.TextYAlignment.Center;
                    TextWrapped = Multiline;
                    ClipsDescendants = true;
                    ZIndex = 203;
                    Parent = Scroll;
                })
                
                VexUI:AddPadding(Button, Multiline and 4 or 0, 8, Multiline and 4 or 0, LeftPad)

                if IconAssetName then
                    local IconHost = VexUI:CreateInstance("ImageLabel", {
                        Size = UDim2.new(0, 14, 0, 14);
                        Position = UDim2.new(0, 6 - LeftPad, 0.5, -7);
                        BackgroundTransparency = 1;
                        Active = false;
                        ZIndex = 204;
                        Parent = Button;
                    })
                    VexUI:ApplyClassIcon(IconHost, IconAssetName)
                end

                Button.MouseEnter:Connect(function()
                    VexUI:Tween(Button, {BackgroundTransparency = 0})
                end)

                Button.MouseLeave:Connect(function()
                    VexUI:Tween(Button, {BackgroundTransparency = 0.5})
                end)

                Button.MouseButton1Click:Connect(function()
                    if Options.Floating then
                        if Window and Window.Parent then
                            Window:Destroy()
                        end
                    else
                        self:CloseModal()
                    end

                    OnPick(Item)
                end)
            end
        end
    end

    if SearchBox then
        SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
            Filter = SearchBox.Text
            Render()
        end)
    end

    Render()
end

function Explorer:CopySelection()
    local Selection = self:GetSelectionList()
    if #Selection == 0 then
        return
    end

    local Clones = {}
    for _, Object in Selection do
        local Good, Clone = pcall(function()
            return Object:Clone()
        end)

        if Good and Clone then
            table.insert(Clones, Clone)
        end
    end

    self.Clipboard = Clones
end

function Explorer:PasteIntoSelection()
    if not self.Clipboard or #self.Clipboard == 0 then
        return
    end

    local Selection = self:GetSelectionList()
    if #Selection == 0 then
        return
    end

    for _, Target in Selection do
        for _, Source in self.Clipboard do
            pcall(function()
                local Clone = Source:Clone()
                Clone.Parent = Target
            end)
        end
    end
end

function Explorer:DestroySelection()
    local Selection = self:GetSelectionList()
    if #Selection == 0 then
        return
    end

    local Fallback
    for _, Object in Selection do
        local ParentObject = Object.Parent
        if ParentObject and ParentObject ~= game then
            Fallback = ParentObject

            break
        end
    end

    for _, Object in Selection do
        pcall(function()
            Object:Destroy()
        end)
    end

    if Fallback then
        self:SetSelection({Fallback})
    end
end

function Explorer:DuplicateSelection()
    local Selection = self:GetSelectionList()
    local Count = 0
    for _, Object in Selection do
        local Good = pcall(function()
            local Clone = Object:Clone()
            Clone.Parent = Object.Parent
        end)

        if Good then
            Count += 1
        end
    end

    return Count
end

function Explorer:SelectChildrenOfSelection()
    local Sources = {}

    if self.SelectedOrder and #self.SelectedOrder > 0 then
        for _, Item in self.SelectedOrder do
            if typeof(Item) == "Instance" then
                table.insert(Sources, Item)
            end
        end
    elseif typeof(self.SelectedInstance) == "Instance" then
        table.insert(Sources, self.SelectedInstance)
    end

    if #Sources == 0 then return end

    for _, Parent in Sources do
        local Idx = self._VTreeRowsByInstance[Parent]
            or self:_VTreeResolveRowIndex(Parent)
        if Idx then
            local Row = self._VTreeRows[Idx]
            if Row and Row.HasChildren and not Row.Expanded then
                self:_VTreeExpand(Row)
            end
        end
    end

    local Collected = {}
    local Seen = setmetatable({}, {__mode = "k"})

    for _, Parent in Sources do
        local Good, Children = pcall(function()
            return WeakGetChildren(Parent)
        end)

        if Good and type(Children) == "table" then
            SortExplorerChildren(Children)
            for _, Child in Children do
                if typeof(Child) == "Instance" and not Seen[Child] then
                    Seen[Child] = true
                    table.insert(Collected, Child)
                end
            end
        end
    end

    if #Collected == 0 then
        self:Notify("Selected instance has no children")
        return
    end

    self:SetSelection(Collected)
end

function Explorer:SetAnchorOnSelection(Anchored)
    local Selection = self:GetSelectionList()
    local Count = 0
    for _, Object in Selection do
        pcall(function()
            if Object:IsA("BasePart") then
                Object.Anchored = Anchored
                Count += 1
            end

            for _, Descendant in WeakGetDescendants(Object) do
                if Descendant:IsA("BasePart") then
                    Descendant.Anchored = Anchored
                    Count += 1
                end
            end
        end)
    end

    return Count
end

function Explorer:TeleportSelfTo(Object)
    if not Object then
        return false, "no instance"
    end

    local Target
    if Object:IsA("Model") then
        pcall(function()
            Target = Object:GetModelCFrame()
        end)

        if not Target then
            pcall(function()
                Target = Object.WorldPivot
            end)
        end
    elseif Object:IsA("BasePart") then
        Target = Object.CFrame
    elseif Object:IsA("Attachment") then
        Target = Object.WorldCFrame
    elseif Object:IsA("Tool") then
        Target = Object.WorldPivot
    end

    if not Target then
        return false, "no position"
    end

    local Character = self.LocalPlayer.Character
    local PrimaryPart = Character and (Character:FindFirstChild("HumanoidRootPart") or Character.PrimaryPart)
    if not PrimaryPart then
        return false, "no HumanoidRootPart/PrimaryPart"
    end

    PrimaryPart.CFrame = Target + Vector3.new(0, 3, 0)

    return true
end

function Explorer:GetViewTarget(Instance)
    if typeof(Instance) ~= "Instance" then
        return nil
    end

    if Instance:IsA("Model") then
        local Success, BoundingCFrame, BoundingSize = pcall(function()
            local ModelCFrame, ModelSize = Instance:GetBoundingBox()
            return ModelCFrame, ModelSize
        end)

        if Success and BoundingCFrame then
            return BoundingCFrame, BoundingSize
        end

        local Success2, PivotCFrame = pcall(function()
            return Instance:GetPivot()
        end)

        if Success2 and PivotCFrame then
            return PivotCFrame, Vector3.new(8, 8, 8)
        end

    elseif Instance:IsA("BasePart") then
        return Instance.CFrame, Instance.Size
    end

    return nil
end


function Explorer:StartViewObject(Instance)
    self:StopViewObject()

    if not self:GetViewTarget(Instance) then
        self:Notify("Cannot view this instance")
        return
    end

    local Camera = workspace.CurrentCamera
    if not Camera then
        return
    end

    self.ViewSavedCFrame = Camera.CFrame
    self.ViewSavedCameraType = Camera.CameraType

    Camera.CameraType = Enum.CameraType.Scriptable
    self.ViewedObject = Instance

    self.ViewConnection = Track(Services.RunService.PreRender:Connect(function()
        local ViewedObject = self.ViewedObject
        if not ViewedObject or not Camera.Parent then
            return
        end

        local TargetCFrame, TargetSize = self:GetViewTarget(ViewedObject)
        if not TargetCFrame then
            self:StopViewObject()
            return
        end

        local MaxSize = math.max(TargetSize.X, TargetSize.Y, TargetSize.Z, 4)
        local Distance = MaxSize * 2.6

        Camera.CFrame = CFrame.lookAt(
            TargetCFrame.Position + Vector3.new(Distance * 0.7, Distance * 0.45, Distance * 0.7),
            TargetCFrame.Position
        )
    end))

    self:Notify(`Viewing {Instance.Name} (middle-click to reset)`)
end


function Explorer:StopViewObject()
    if self.ViewConnection then
        pcall(function()
            self.ViewConnection:Disconnect()
        end)
        self.ViewConnection = nil
    end

    local Camera = workspace.CurrentCamera

    if Camera and self.ViewSavedCameraType then
        pcall(function()
            Camera.CameraType = self.ViewSavedCameraType

            if self.ViewSavedCFrame then
                Camera.CFrame = self.ViewSavedCFrame
            end
        end)
    end

    self.ViewedObject = nil
    self.ViewSavedCFrame = nil
    self.ViewSavedCameraType = nil
end


function Explorer:ToggleViewObject(Instance)
    if self.ViewedObject == Instance then
        self:StopViewObject()
    else
        self:StartViewObject(Instance)
    end
end

function Explorer:UpdateReparentIndicator()
    if not self.ReparentIndicator then
        return
    end

    if self.ReparentMode then
        self.ReparentIndicator.Visible = true
        self.ReparentIndicator.Text = `REPARENT: click target ({#self.ReparentSources})`
    else
        self.ReparentIndicator.Visible = false
    end
end

function Explorer:BeginReparent()
    local Selection = self:GetSelectionList()
    if #Selection == 0 then
        return
    end

    self.ReparentSources = Selection
    self.ReparentMode = true
    self:UpdateReparentIndicator()
end

function Explorer:CommitReparent(NewParent)
    if not self.ReparentMode then
        return
    end

    for _, Object in self.ReparentSources do
        if Object ~= NewParent and not NewParent:IsDescendantOf(Object) then
            SafeSet(Object, "Parent", NewParent)
        end
    end

    self:Notify(`Reparented {#self.ReparentSources} into {NewParent.Name}`)
    self.ReparentMode = false
    self.ReparentSources = {}
    self:UpdateReparentIndicator()
end

function Explorer:CancelReparent()
    self.ReparentMode = false
    self.ReparentSources = {}
    self:UpdateReparentIndicator()
end

function Explorer:OpenInsertObject()
    local Selection = self:GetSelectionList()
    if #Selection == 0 then
        self:Notify("Select a parent first")

        return
    end

    self:OpenListModal("Insert Object", InsertableClasses,
        function(ClassName)
            return ClassName
        end,
        function(ClassName)
            if self._InsertingObject then return end
            self._InsertingObject = true

            local Count = 0
            local LastInserted
            for _, Object in Selection do
                local NewObject
                local Good = pcall(function()
                    NewObject = Instance.new(ClassName)
                    NewObject.Parent = Object
                end)
                if Good and NewObject then
                    Count += 1
                    LastInserted = NewObject
                end
            end

            if LastInserted then
                self:_VTreeRevealInstance(LastInserted, {Select = true})
            end

            self:Notify(`Inserted {ClassName} into {Count} target(s)`)
            self:CloseModal()
            self._InsertingObject = false
        end,
        true,
        24,
        function(ClassName)
            return ClassName
        end
    )
end

local AttributeTypes = {
    "string"; "number"; "boolean";
    "Vector3"; "Vector2";
    "Color3"; "BrickColor";
    "UDim"; "UDim2"; "CFrame";
    "NumberRange";
}

function Explorer:ParseAttributeValue(AttributeType, InputText)
    local Text = InputText or ""

    if AttributeType == "string" then
        return Text
    end

    if AttributeType == "number" then
        return tonumber(Text)
    end

    if AttributeType == "boolean" then
        local NormalizedText = Text:lower()

        if NormalizedText == "true" or NormalizedText == "1" then
            return true
        end

        if NormalizedText == "false" or NormalizedText == "0" or NormalizedText == "" then
            return false
        end

        return nil
    end

    if AttributeType == "Vector3" then
        local XValue, YValue, ZValue =
            Text:match("([%-%d%.]+)[,%s]+([%-%d%.]+)[,%s]+([%-%d%.]+)")

        if XValue then
            return Vector3.new(
                tonumber(XValue),
                tonumber(YValue),
                tonumber(ZValue)
            )
        end
    elseif AttributeType == "Vector2" then
        local XValue, YValue =
            Text:match("([%-%d%.]+)[,%s]+([%-%d%.]+)")

        if XValue then
            return Vector2.new(
                tonumber(XValue),
                tonumber(YValue)
            )
        end
    elseif AttributeType == "Color3" then
        local RedValue, GreenValue, BlueValue =
            Text:match("([%-%d%.]+)[,%s]+([%-%d%.]+)[,%s]+([%-%d%.]+)")

        if RedValue then
            local Red = tonumber(RedValue)
            local Green = tonumber(GreenValue)
            local Blue = tonumber(BlueValue)

            if Red > 1 or Green > 1 or Blue > 1 then
                return Color3.fromRGB(
                    math.clamp(Red, 0, 255),
                    math.clamp(Green, 0, 255),
                    math.clamp(Blue, 0, 255)
                )
            end

            return Color3.new(Red, Green, Blue)
        end
    elseif AttributeType == "BrickColor" then
        local Success, BrickColorValue = pcall(BrickColor.new, Text)

        if Success then
            return BrickColorValue
        end
    elseif AttributeType == "UDim" then
        local ScaleValue, OffsetValue =
            Text:match("([%-%d%.]+)[,%s]+([%-%d]+)")

        if ScaleValue then
            return UDim.new(
                tonumber(ScaleValue),
                tonumber(OffsetValue)
            )
        end
    elseif AttributeType == "UDim2" then
        local ScaleX, OffsetX, ScaleY, OffsetY =
            Text:match("{?([%-%d%.]+)[,%s]+([%-%d]+)}?[,%s}]+{?([%-%d%.]+)[,%s]+([%-%d]+)}?")

        if ScaleX then
            return UDim2.new(
                tonumber(ScaleX),
                tonumber(OffsetX),
                tonumber(ScaleY),
                tonumber(OffsetY)
            )
        end
    elseif AttributeType == "CFrame" then
        local NumberValues = {}

        for Value in Text:gmatch("[%-%d%.]+") do
            table.insert(NumberValues, tonumber(Value))
        end

        if #NumberValues == 12 then
            return CFrame.new(table.unpack(NumberValues))
        end

        if #NumberValues == 3 then
            return CFrame.new(
                NumberValues[1],
                NumberValues[2],
                NumberValues[3]
            )
        end
    elseif AttributeType == "NumberRange" then
        local MinimumValue, MaximumValue =
            Text:match("([%-%d%.]+)[,%s]+([%-%d%.]+)")

        if MinimumValue then
            return NumberRange.new(
                tonumber(MinimumValue),
                tonumber(MaximumValue)
            )
        end
    end

    return nil
end

function Explorer:OpenAttributeModal(Title, ExistingName, ExistingValue)
    local Object = self.SelectedInstance
    if not Object then
        return
    end

    local Window, Body = self:CreateModalWindow(Title or "Attribute", 320, 175)
    VexUI:AddListLayout(Body, 8, Enum.FillDirection.Vertical)

    local function MakeFieldRow(LabelText, Order)
        local Row = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 26);
            BackgroundTransparency = 1;
            LayoutOrder = Order;
            ZIndex = 202;
            Parent = Body;
        })
        VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(0, 50, 1, 0);
            BackgroundTransparency = 1;
            Font = Fonts.Medium;
            Text = LabelText;
            TextColor3 = Theme.TextDim;
            TextSize = 12;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 203;
            Parent = Row;
        })
        return Row
    end

    local NameRow = MakeFieldRow("Name", 1)
    local NameBox = VexUI:CreateInstance("TextBox", {
        Size = UDim2.new(1, -56, 1, 0);
        Position = UDim2.new(0, 56, 0, 0);
        BackgroundColor3 = Theme.Field;
        BorderSizePixel = 0;
        Font = Fonts.Mono;
        PlaceholderText = "Attribute name";
        PlaceholderColor3 = Theme.TextFaded;
        Text = ExistingName or "";
        TextColor3 = Theme.Text;
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Left;
        ClearTextOnFocus = false;
        ZIndex = 203;
        Parent = NameRow;
    })
    
    VexUI:AddStroke(NameBox, "Border", 1)
    VexUI:AddPadding(NameBox, 0, 6, 0, 6)

    local TypeRow = MakeFieldRow("Type", 2)
    local CurrentType = "string"
    if ExistingValue ~= nil then
        local detected = typeof(ExistingValue)
        for _, Type in AttributeTypes do
            if Type == detected then
                CurrentType = Type
                
                break
            end
        end
    end

    local TypeBtn = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(1, -56, 1, 0);
        Position = UDim2.new(0, 56, 0, 0);
        BackgroundColor3 = Theme.Field;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Font = Fonts.Mono;
        Text = `{CurrentType}`;
        TextColor3 = Theme.PropEnum;
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = 203;
        Parent = TypeRow;
    })
    
    VexUI:AddStroke(TypeBtn, "Border", 1)
    VexUI:AddPadding(TypeBtn, 0, 8, 0, 8)

    local DropdownLayer = VexUI:CreateInstance("Frame", {
        Size = UDim2.fromScale(1, 1);
        Position = UDim2.fromOffset(0, 0);
        BackgroundTransparency = 1;
        ClipsDescendants = false;
        ZIndex = 999;
        Parent = self.ScreenGui;
    })

    local TypeDropdown = VexUI:CreateInstance("Frame", {
        Size = UDim2.fromOffset(180, #AttributeTypes * 22);
        Position = UDim2.fromOffset(0, 0);
        BackgroundColor3 = Theme.Window;
        BorderSizePixel = 0;
        Visible = false;
        ClipsDescendants = true;
        Active = true;
        ZIndex = 1000;
        Parent = DropdownLayer;
    })

    VexUI:AddStroke(TypeDropdown, "Border", 1)

    VexUI:CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical;
        SortOrder = Enum.SortOrder.LayoutOrder;
        Padding = UDim.new(0, 0);
        Parent = TypeDropdown;
    })

    local DropdownFollowConnection = nil
    local PositionTypeDropdown

    PositionTypeDropdown = function()
        if not TypeBtn
            or not TypeBtn.Parent
            or not TypeDropdown
            or not TypeDropdown.Parent
            or not DropdownLayer
            or not DropdownLayer.Parent
        then
            return
        end

        local ButtonPosition = TypeBtn.AbsolutePosition
        local ButtonSize = TypeBtn.AbsoluteSize
        local LayerPosition = DropdownLayer.AbsolutePosition

        TypeDropdown.Position = UDim2.fromOffset(
            ButtonPosition.X - LayerPosition.X,
            ButtonPosition.Y - LayerPosition.Y + ButtonSize.Y + 2
        )

        TypeDropdown.Size = UDim2.fromOffset(
            ButtonSize.X,
            #AttributeTypes * 22
        )
    end

    local function StartDropdownFollow()
        if DropdownFollowConnection then
            DropdownFollowConnection:Disconnect()
            DropdownFollowConnection = nil
        end

        DropdownFollowConnection = Services.RunService.PreRender:Connect(function()
            if TypeDropdown and TypeDropdown.Parent and TypeDropdown.Visible then
                PositionTypeDropdown()
            end
        end)
    end

    local function StopDropdownFollow()
        if DropdownFollowConnection then
            DropdownFollowConnection:Disconnect()
            DropdownFollowConnection = nil
        end
    end

    for Index, Type in AttributeTypes do
        local Item = VexUI:CreateInstance("TextButton", {
            Size = UDim2.new(1, 0, 0, 22);
            BackgroundColor3 = Theme.Field;
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            AutoButtonColor = false;
            Font = Fonts.Mono;
            Text = "  " .. Type;
            TextColor3 = Theme.Text;
            TextSize = 11;
            TextXAlignment = Enum.TextXAlignment.Left;
            LayoutOrder = Index;
            ZIndex = 1001;
            Parent = TypeDropdown;
        })

        Item.MouseEnter:Connect(function()
            Item.BackgroundTransparency = 0.4
        end)

        Item.MouseLeave:Connect(function()
            Item.BackgroundTransparency = 1
        end)

        Item.MouseButton1Click:Connect(function()
            CurrentType = Type
            TypeBtn.Text = `{Type}`
            TypeDropdown.Visible = false
            StopDropdownFollow()
        end)
    end

    TypeBtn.MouseButton1Click:Connect(function()
        TypeDropdown.Visible = not TypeDropdown.Visible

        if TypeDropdown.Visible then
            PositionTypeDropdown()
            StartDropdownFollow()
        else
            StopDropdownFollow()
        end
    end)

    local ValueRow = MakeFieldRow("Value", 3)
    local ValueBox = VexUI:CreateInstance("TextBox", {
        Size = UDim2.new(1, -56, 1, 0);
        Position = UDim2.new(0, 56, 0, 0);
        BackgroundColor3 = Theme.Field;
        BorderSizePixel = 0;
        Font = Fonts.Mono;
        Text = ExistingValue ~= nil and tostring(ExistingValue) or "";
        PlaceholderText = "Value";
        PlaceholderColor3 = Theme.TextFaded;
        TextColor3 = Theme.Text;
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Left;
        ClearTextOnFocus = false;
        ZIndex = 203;
        Parent = ValueRow;
    })
    
    VexUI:AddStroke(ValueBox, "Border", 1)
    VexUI:AddPadding(ValueBox, 0, 6, 0, 6)

    local BtnRow = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 30);
        BackgroundTransparency = 1;
        LayoutOrder = 5;
        ZIndex = 202;
        Parent = Body;
    })
    local BL = VexUI:AddListLayout(BtnRow, 8, Enum.FillDirection.Horizontal)
    BL.HorizontalAlignment = Enum.HorizontalAlignment.Right

    local function MakeBtn(Text, Accent)
        local B = VexUI:CreateInstance("TextButton", {
            Size = UDim2.fromOffset(90, 28);
            BackgroundColor3 = Accent and Theme.Accent or Theme.Field;
            BackgroundTransparency = Accent and 0.85 or 0;
            BorderSizePixel = 0;
            AutoButtonColor = false;
            Font = Fonts.SemiBold;
            Text = Text;
            TextColor3 = Accent and Theme.Accent or Theme.Text;
            TextSize = 12;
            ZIndex = 203;
            Parent = BtnRow;
        })
        
        VexUI:AddStroke(B, Accent and Theme.Accent or "Border", 1)
        return B
    end

    local AttributeModalClosed = false

    local function CleanupAttributeDropdown()
        if AttributeModalClosed then
            return
        end

        AttributeModalClosed = true

        StopDropdownFollow()

        if TypeDropdown and TypeDropdown.Parent then
            TypeDropdown:Destroy()
        end

        if DropdownLayer and DropdownLayer.Parent then
            DropdownLayer:Destroy()
        end
    end

    local function CloseAttributeModal()
        CleanupAttributeDropdown()
        self:CloseModal()
    end

    Window.Destroying:Connect(function()
        CleanupAttributeDropdown()
    end)

    Window.AncestryChanged:Connect(function(_, Parent)
        if Parent == nil then
            CleanupAttributeDropdown()
        end
    end)

    Window:GetPropertyChangedSignal("Visible"):Connect(function()
        if Window.Visible == false then
            CleanupAttributeDropdown()
        end
    end)

    local SaveBtn = MakeBtn("Save", true)
    local CancelBtn = MakeBtn("Cancel", false)

    CancelBtn.MouseButton1Click:Connect(function()
        CloseAttributeModal()
    end)

    SaveBtn.MouseButton1Click:Connect(function()
        local NewName = (NameBox.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
        if NewName == "" then
            self:Notify("Name required")
            
            return
        end

        local NewValue = self:ParseAttributeValue(CurrentType, ValueBox.Text)
        if NewValue == nil and CurrentType ~= "string" then
            if CurrentType == "boolean" then
                NewValue = false
            else
                self:Notify(`Invalid {CurrentType} value`)

                return
            end
        end

        for _, Obj in self:GetSelectionList() do
            pcall(function()
                if ExistingName and ExistingName ~= NewName then
                    Obj:SetAttribute(ExistingName, nil)
                end
                Obj:SetAttribute(NewName, NewValue)
            end)
        end

        CloseAttributeModal()
        if self.SelectedInstance then
            self:RenderProperties(self.SelectedInstance)
        end
    end)
end

function Explorer:OpenRemoveAttributeModal()
    local Object = self.SelectedInstance
    if not Object then
        return
    end

    local Items = CollectAttributes(Object)
    if #Items == 0 then
        self:Notify("No attributes")

        return
    end

    self:OpenListModal("Remove Attribute", Items,
        function(e)
            return `{e.Name}  ({typeof(e.Value)})`
        end,
        function(e)
            for _, Obj in self:GetSelectionList() do
                pcall(function()
                    Obj:SetAttribute(e.Name, nil)
                end)
            end

            self:CloseModal()
            if self.SelectedInstance then
                self:RenderProperties(self.SelectedInstance)
            end
        end,
    true)
end

function Explorer:OpenEditAttributeModal()
    local Object = self.SelectedInstance
    if not Object then
        return
    end

    local Items = CollectAttributes(Object)
    if #Items == 0 then
        self:Notify("No attributes")

        return
    end

    self:OpenListModal("Edit Attribute", Items,
        function(e)
            return `{e.Name}  ({typeof(e.Value)})`
        end,
        function(e)
            self:OpenAttributeModal(`Edit Attribute {e.Name}`, e.Name, e.Value)
        end,
    true)
end

function Explorer:OpenAddTagModal()
    local Object = self.SelectedInstance
    if not Object then
        return
    end

    local Window, Body = self:CreateModalWindow("Add Tag", 280, 105)
    VexUI:AddListLayout(Body, 8, Enum.FillDirection.Vertical)

    local Box = VexUI:CreateInstance("TextBox", {
        Size = UDim2.new(1, 0, 0, 26);
        BackgroundColor3 = Theme.Field;
        BorderSizePixel = 0;
        Font = Fonts.Mono;
        PlaceholderText = "Tag name";
        PlaceholderColor3 = Theme.TextFaded;
        Text = "";
        TextColor3 = Theme.Text;
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Left;
        ClearTextOnFocus = false;
        LayoutOrder = 1;
        ZIndex = 202;
        Parent = Body;
    })
    
    VexUI:AddStroke(Box, "Border", 1)
    VexUI:AddPadding(Box, 0, 8, 0, 8)

    local BtnRow = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 28);
        BackgroundTransparency = 1;
        LayoutOrder = 2;
        ZIndex = 202;
        Parent = Body;
    })
    local L = VexUI:AddListLayout(BtnRow, 8, Enum.FillDirection.Horizontal)
    L.HorizontalAlignment = Enum.HorizontalAlignment.Right

    local function MakeBtn(Text, Accent)
        local B = VexUI:CreateInstance("TextButton", {
            Size = UDim2.fromOffset(80, 28);
            BackgroundColor3 = Accent and Theme.Accent or Theme.Field;
            BackgroundTransparency = Accent and 0.85 or 0;
            BorderSizePixel = 0;
            AutoButtonColor = false;
            Font = Fonts.SemiBold;
            Text = Text;
            TextColor3 = Accent and Theme.Accent or Theme.Text;
            TextSize = 12;
            ZIndex = 203;
            Parent = BtnRow;
        })
        
        VexUI:AddStroke(B, Accent and Theme.Accent or "Border", 1)
        return B
    end

    local Save = MakeBtn("Save", true)
    local Cancel = MakeBtn("Cancel", false)

    Cancel.MouseButton1Click:Connect(function()
        self:CloseModal()
    end)

    Save.MouseButton1Click:Connect(function()
        local Tag = (Box.Text or ""):gsub("^%s+", ""):gsub("%s+$", "")
        if Tag == "" then
            return
        end

        for _, Obj in self:GetSelectionList() do
            pcall(function()
                Services.CollectionService:AddTag(Obj, Tag)
            end)
        end

        self:CloseModal()

        if self.SelectedInstance then
            self:RenderProperties(self.SelectedInstance)
        end
    end)
end

function Explorer:OpenRemoveTagModal()
    local Object = self.SelectedInstance
    if not Object then
        return
    end

    local Tags = CollectTags(Object)
    if #Tags == 0 then
        self:Notify("No tags")

        return
    end

    self:OpenListModal("Remove Tag", Tags,
        function(Tag) return
            tostring(Tag)
        end,
        function(Tag)
            for _, Obj in self:GetSelectionList() do
                pcall(function() Services.CollectionService:RemoveTag(Obj, Tag) end)
            end

            self:CloseModal()

            if self.SelectedInstance then
                self:RenderProperties(self.SelectedInstance)
            end
        end,
    true)
end

function Explorer:Open3DPreview(Instance)
    if typeof(Instance) ~= "Instance" then
        return
    end

    local ClonedInstance
    pcall(function()
        Instance.Archivable = true
        ClonedInstance = Instance:Clone()
    end)

    if not ClonedInstance then
        self:Notify("Cannot clone instance")
        return
    end

    local PreviewWindow = VexUI:CreateWindow({
        Parent = self.ScreenGui;
        Title = `3D Preview - {Instance.Name}`;
        Size = UDim2.fromOffset(380, 380);
        Position = UDim2.fromOffset(140, 140);
    })

    PreviewWindow.Frame.ZIndex = 70

    PreviewWindow:AddTitleButton("X", 26, true, function()
        PreviewWindow.Frame:Destroy()
    end, "CloseIcon")

    local WindowBody = PreviewWindow.Body

    local PreviewConns = {}
    local function PConn(Signal, Fn)
        local C = Signal:Connect(Fn)
        table.insert(PreviewConns, C)
        Track(C)
        return C
    end

    local ViewportContainer = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, -16, 1, -16);
        Position = UDim2.new(0, 8, 0, 8);
        BackgroundColor3 = Theme.Background;
        BorderSizePixel = 0;
        ClipsDescendants = true;
        Parent = WindowBody;
    })

    local ViewportFrame = VexUI:CreateInstance("ViewportFrame", {
        Size = UDim2.fromScale(1, 1);
        BackgroundColor3 = Color3.fromRGB(0, 0, 0);
        BackgroundTransparency = 0;
        BorderSizePixel = 0;
        Ambient = Color3.fromRGB(140, 140, 140);
        LightColor = Color3.fromRGB(255, 255, 255);
        LightDirection = Vector3.new(-1, -1, -1);
        Parent = ViewportContainer;
    })

    local Camera = NewInstance("Camera")
    ViewportFrame.CurrentCamera = Camera
    Camera.Parent = ViewportFrame

    local WorldModel = NewInstance("WorldModel")
    WorldModel.Parent = ViewportFrame

    local function AnchorAllParts(Object)
        if Object:IsA("BasePart") then
            Object.Anchored = true
        end

        for _, Child in Object:GetChildren() do
            AnchorAllParts(Child)
        end
    end

    pcall(AnchorAllParts, ClonedInstance)
    ClonedInstance.Parent = WorldModel

    local CenterPosition
    local SizeVector

    if ClonedInstance:IsA("Model") then
        local Success, BoundingCFrame, BoundingSize = pcall(function()
            local ModelCFrame, ModelSize = ClonedInstance:GetBoundingBox()
            return ModelCFrame, ModelSize
        end)

        if Success then
            CenterPosition = BoundingCFrame.Position
            SizeVector = BoundingSize
        end

    elseif ClonedInstance:IsA("BasePart") then
        CenterPosition = ClonedInstance.Position
        SizeVector = ClonedInstance.Size
    end

    CenterPosition = CenterPosition or Vector3.new()
    SizeVector = SizeVector or Vector3.new(4, 4, 4)

    local MaxDimension = math.max(SizeVector.X, SizeVector.Y, SizeVector.Z, 2)
    local Distance = MaxDimension * 1.4

    local Yaw = 0
    local Pitch = math.rad(15)
    local AutoRotate = true

    local function UpdateCamera()
        local CosPitch = math.cos(Pitch)

        local OffsetX = Distance * CosPitch * math.sin(Yaw)
        local OffsetY = Distance * math.sin(Pitch)
        local OffsetZ = Distance * CosPitch * math.cos(Yaw)

        Camera.CFrame = CFrame.lookAt(
            CenterPosition + Vector3.new(OffsetX, OffsetY, OffsetZ),
            CenterPosition
        )
    end

    UpdateCamera()

    local RenderConnection = Track(Services.RunService.PreRender:Connect(function(DeltaTime)
        if AutoRotate then
            Yaw += DeltaTime * 0.5
            UpdateCamera()
        end
    end))

    PreviewWindow.Frame.AncestryChanged:Connect(function(_, Parent)
        if not Parent then
            pcall(function() RenderConnection:Disconnect() end)
            for _, C in PreviewConns do
                pcall(function() C:Disconnect() end)
            end
            table.clear(PreviewConns)
        end
    end)

    local IsDragging = false
    local LastMouseX, LastMouseY

    ViewportContainer.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch
        then
            IsDragging = true
            LastMouseX, LastMouseY = Input.Position.X, Input.Position.Y
        end
    end)

    PConn(Services.UserInputService.InputChanged, function(Input)
        if not IsDragging or not PreviewWindow.Frame.Parent then
            return
        end

        if Input.UserInputType ~= Enum.UserInputType.MouseMovement
            and Input.UserInputType ~= Enum.UserInputType.Touch
        then
            return
        end

        local DeltaX = Input.Position.X - LastMouseX
        local DeltaY = Input.Position.Y - LastMouseY

        LastMouseX, LastMouseY = Input.Position.X, Input.Position.Y

        Yaw -= DeltaX * 0.01
        Pitch = math.clamp(Pitch + DeltaY * 0.01, -math.rad(85), math.rad(85))

        UpdateCamera()
    end)

    PConn(Services.UserInputService.InputEnded, function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch
        then
            IsDragging = false
        end
    end)
end

function Explorer:OpenCallFunction()
    local Object = self.SelectedInstance
    if not Object then
        return
    end

    local Methods = CollectMethods(Object)
    if #Methods == 0 then
        self:Notify("No callable methods registered")

        return
    end

    self:OpenListModal("Call Function", Methods,
        function(Method)
            local Params = {}
            for _, Spec in Method[3] do
                table.insert(Params, `{Spec[2]} {Spec[1]}`)
            end

            return `{Method[2]} {Method[1]}({table.concat(Params, ", ")})`
        end,
        function(Method)
            self:OpenMethodCaller(Method)
        end,
        true,
        38
    )
end

function Explorer:OpenMethodCaller(Method)
    local Object = self.SelectedInstance
    if not Object then
        return
    end

    local function FormatResultForDisplay(Value, Depth, Seen)
        Depth = Depth or 0
        Seen = Seen or {}

        local T = typeof(Value)

        if Value == nil then
            return "nil"
        end

        if T == "string" then
            return string.format("%q", Value)
        end

        if T == "Instance" then
            return `{Value.ClassName}({Value:GetFullName()})`
        end

        if T == "EnumItem" or T == "number" or T == "boolean" then
            return tostring(Value)
        end

        if T ~= "table" then
            return tostring(Value)
        end

        if Seen[Value] then
            return "<cycle>"
        end
        Seen[Value] = true

        if Depth >= 5 then
            Seen[Value] = nil
            return "{...}"
        end

        local Count = 0
        for _ in Value do
            Count += 1
        end
        if Count == 0 then
            Seen[Value] = nil
            return "{}"
        end

        local Indent = string.rep("    ", Depth + 1)
        local CloseIndent = string.rep("    ", Depth)
        local Parts = {}
        local Emitted = 0
        local MaxEntries = 500

        local IsArray = true
        for K in Value do
            if type(K) ~= "number" then
                IsArray = false
                break
            end
        end

        if IsArray then
            for I, V in Value do
                Emitted += 1
                if Emitted > MaxEntries then
                    Parts[#Parts + 1] = `{Indent}... ({Count - MaxEntries} more)`
                    break
                end
                Parts[#Parts + 1] = `{Indent}{FormatResultForDisplay(V, Depth + 1, Seen)},`
            end
        else
            for K, V in Value do
                Emitted += 1
                if Emitted > MaxEntries then
                    Parts[#Parts + 1] = `{Indent}... ({Count - MaxEntries} more)`
                    break
                end
                local KeyStr
                if type(K) == "string" and K:match("^[%a_][%w_]*$") then
                    KeyStr = K
                else
                    KeyStr = `[{FormatResultForDisplay(K, Depth + 1, Seen)}]`
                end
                Parts[#Parts + 1] = `{Indent}{KeyStr} = {FormatResultForDisplay(V, Depth + 1, Seen)},`
            end
        end

        Seen[Value] = nil

        return `\{\n{table.concat(Parts, "\n")}\n{CloseIndent}\}`
    end

    local Window, Body = self:CreateModalWindow(`Call: {Method[1]}`, 360, 420)
    VexUI:AddListLayout(Body, 6, Enum.FillDirection.Vertical)

    VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18);
        BackgroundTransparency = 1;
        Font = Fonts.Mono;
        Text = `{Method[2]} {Method[1]}(...)`;
        TextColor3 = Theme.Accent;
        TextSize = 11;
        TextXAlignment = Enum.TextXAlignment.Left;
        LayoutOrder = 1;
        ZIndex = 202;
        Parent = Body;
    })

    local FieldCount = #Method[3]
    local UseGrid = FieldCount > 6
    local Columns = UseGrid and 2 or 1

    local RowHeight = 42
    local ListRowHeight = 44
    local MaxViewport = 240

    local EstimatedHeight
    if UseGrid then
        local Rows = math.ceil(FieldCount / Columns)
        EstimatedHeight = Rows * RowHeight + (Rows - 1) * 6
    else
        EstimatedHeight = FieldCount * ListRowHeight
    end
    EstimatedHeight = math.max(0, EstimatedHeight)

    local ViewportHeight = math.min(MaxViewport, EstimatedHeight)

    local FieldsScroll = VexUI:CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, 0, 0, ViewportHeight);
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        ScrollBarThickness = 4;
        ScrollBarImageColor3 = Theme.Border;
        CanvasSize = UDim2.new(0, 0, 0, 0);
        AutomaticCanvasSize = Enum.AutomaticSize.Y;
        ScrollingDirection = Enum.ScrollingDirection.Y;
        ScrollBarImageTransparency = ViewportHeight >= EstimatedHeight and 1 or 0;
        LayoutOrder = 2;
        Visible = FieldCount > 0;
        ZIndex = 202;
        Parent = Body;
    })

    if UseGrid then
        VexUI:CreateInstance("UIGridLayout", {
            CellSize = UDim2.new(0.5, -3, 0, 42);
            CellPadding = UDim2.new(0, 6, 0, 6);
            SortOrder = Enum.SortOrder.LayoutOrder;
            FillDirectionMaxCells = Columns;
            Parent = FieldsScroll;
        })
    else
        VexUI:CreateInstance("UIListLayout", {
            FillDirection = Enum.FillDirection.Vertical;
            Padding = UDim.new(0, 6);
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = FieldsScroll;
        })
    end

    local InputBoxes = {}
    for Index, Spec in Method[3] do
        local SpecName = Spec[1]
        local SpecType = Spec[2]
        local Default = Spec[3] or ""

        local Row = VexUI:CreateInstance("Frame", {
            Size = UseGrid and UDim2.fromOffset(0, 0) or UDim2.new(1, 0, 0, 38);
            BackgroundTransparency = 1;
            LayoutOrder = Index;
            ZIndex = 202;
            Parent = FieldsScroll;
        })

        VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 14);
            BackgroundTransparency = 1;
            Font = Fonts.Medium;
            Text = `{SpecName} : {SpecType}`;
            TextColor3 = Theme.TextDim;
            TextSize = 11;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextTruncate = Enum.TextTruncate.AtEnd;
            ZIndex = 203;
            Parent = Row;
        })

        local Box = VexUI:CreateInstance("TextBox", {
            Size = UDim2.new(1, 0, 0, 22);
            Position = UDim2.new(0, 0, 0, 16);
            BackgroundColor3 = Theme.Field;
            BorderSizePixel = 0;
            Font = Fonts.Mono;
            Text = Default;
            TextColor3 = Theme.Text;
            TextSize = 11;
            TextXAlignment = Enum.TextXAlignment.Left;
            ClearTextOnFocus = false;
            PlaceholderText = SpecType;
            PlaceholderColor3 = Theme.TextFaded;
            ZIndex = 203;
            Parent = Row;
        })

        VexUI:AddStroke(Box, "Border", 1)
        VexUI:AddPadding(Box, 0, 8, 0, 8)
        table.insert(InputBoxes, {Box = Box; Type = SpecType})
    end

    local function ParseArg(ArgType, Text)
        if Text == "" then
            return nil
        end

        if ArgType == "string" then
            return (Text:gsub("^['\"]", ""):gsub("['\"]$", ""))
        end

        if ArgType == "number" then
            return tonumber(Text)
        end

        if ArgType == "boolean" then
            local Lowered = Text:lower()
            if Lowered == "true" or Lowered == "1" then return true end
            if Lowered == "false" or Lowered == "0" then return false end
            return nil
        end

        if ArgType == "BasePart" or ArgType == "Instance" then
            return ResolveInstanceText(Text)
        end

        if ArgType == "RBXScriptSignal" then
            local Good, Signal = pcall(function() return Object[Text] end)
            if not Good then
                return nil, `Couldn't read Object.{Text}: {Signal}`
            end

            local Tp = typeof(Signal)
            if Tp == "RBXScriptSignal" then
                return Signal
            end

            if Tp == "userdata" and type(rawget(getmetatable(Signal) or {}, "__index")) ~= "nil" then
                return Signal
            end

            return nil, `Object.{Text} is {Tp}, not RBXScriptSignal`
        end

        if ArgType == "Vector3" then
            local Vx, Vy, Vz = Text:match("([%-%d%.]+)[,%s]+([%-%d%.]+)[,%s]+([%-%d%.]+)")
            if Vx then
                return Vector3.new(tonumber(Vx), tonumber(Vy), tonumber(Vz))
            end
        end

        if ArgType == "CFrame" then
            local Numbers = {}
            for Token in Text:gmatch("[%-%d%.]+") do
                table.insert(Numbers, tonumber(Token))
            end
            if #Numbers == 12 then return CFrame.new(table.unpack(Numbers)) end
            if #Numbers == 3  then return CFrame.new(Numbers[1], Numbers[2], Numbers[3]) end
        end

        return Text
    end

    local function ParseVariadic(Text)
        local Out = {}
        if Text == "" then return Out end

        local Tokens = {}
        for Token in Text:gmatch("[^,]+") do
            Tokens[#Tokens + 1] = (Token:gsub("^%s+", ""):gsub("%s+$", ""))
        end

        for Index, Token in Tokens do
            local Lowered = Token:lower()
            local Number = tonumber(Token)

            if Lowered == "true" then
                Out[Index] = true
            elseif Lowered == "false" then
                Out[Index] = false
            elseif Lowered == "nil" then
                Out[Index] = nil
            elseif Number ~= nil then
                Out[Index] = Number
            elseif Token:match("^['\"].*['\"]$") then
                Out[Index] = Token:sub(2, -2)
            else
                local AsInstance = ResolveInstanceText(Token)
                Out[Index] = AsInstance or Token
            end
        end

        return Out
    end

    local ResultScroll = VexUI:CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, 0, 0, 40);
        BackgroundColor3 = Theme.Field;
        BorderSizePixel = 0;
        ScrollBarThickness = 4;
        ScrollBarImageColor3 = Theme.Border;
        CanvasSize = UDim2.new(0, 0, 0, 0);
        AutomaticCanvasSize = Enum.AutomaticSize.Y;
        ScrollingDirection = Enum.ScrollingDirection.XY;
        LayoutOrder = 90;
        ZIndex = 202;
        Parent = Body;
    })
    VexUI:AddPadding(ResultScroll, 6, 8, 6, 8)

    local ResultLabel = VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, -8, 0, 0);
        AutomaticSize = Enum.AutomaticSize.Y;
        BackgroundTransparency = 1;
        Font = Fonts.Mono;
        Text = "(no result)";
        TextColor3 = Theme.TextDim;
        TextSize = 11;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextYAlignment = Enum.TextYAlignment.Top;
        TextWrapped = true;
        ZIndex = 203;
        Parent = ResultScroll;
    })
    
    VexUI:AddPadding(ResultLabel, 6, 8, 6, 8)

    local CallButton = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 0, 28);
        BackgroundColor3 = Theme.Accent;
        BackgroundTransparency = 0.85;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Font = Fonts.SemiBold;
        Text = "Call";
        TextColor3 = Theme.Accent;
        TextSize = 12;
        LayoutOrder = 91;
        ZIndex = 202;
        Parent = Body;
    })
    
    VexUI:AddStroke(CallButton, Theme.Accent, 1)

    local LastResult
    local LastResultIsError = false

    CallButton.MouseButton1Click:Connect(function()
        local Args = {}
        local ArgCount = 0
        for Index, Entry in InputBoxes do
            if Entry.Type == "Variadic" then
                for _, V in ParseVariadic(Entry.Box.Text) do
                    ArgCount += 1
                    Args[ArgCount] = V
                end
            else
                local Value, Err = ParseArg(Entry.Type, Entry.Box.Text)
                if Err then
                    ResultLabel.Text = `ERROR: {Err}`
                    ResultLabel.TextColor3 = Theme.Red
                    return
                end
                ArgCount += 1
                Args[ArgCount] = Value
            end
        end

        local Good, Result = pcall(function()
            if type(Method.Resolve) == "function" then
                local Fn, LoadErr = Method.Resolve()
                if not Fn then
                    error(LoadErr or `Resolver failed for {Method[1]}`)
                end

                if Method.BuildOptions then
                    local Options = {}
                    for Index, Spec in Method[3] do
                        Options[Spec[1]] = Args[Index]
                    end

                    if type(Method.PostBuild) == "function" then
                        Options = Method.PostBuild(Options, Object) or Options
                    end

                    return Fn(Options)
                end

                if Method.NoSelf then
                    return Fn(table.unpack(Args, 1, #Args))
                end

                local Target = ResolveSelfForGlobal(Object, Method)
                return Fn(Target, table.unpack(Args, 1, #Args))
            end

            if Method[4] == "global" then
                local Fn = GetGlobalCallable(Method[1])
                if not Fn then
                    error(`Global function not available: {Method[1]}`)
                end

                if Method.BuildOptions then
                    local Options = {}
                    for Index, Spec in Method[3] do
                        Options[Spec[1]] = Args[Index]
                    end

                    if type(Method.PostBuild) == "function" then
                        Options = Method.PostBuild(Options, Object) or Options
                    end

                    return Fn(Options)
                end

                if Method.NoSelf then
                    return Fn(table.unpack(Args, 1, #Args))
                end

                local Target = ResolveSelfForGlobal(Object, Method)
                return Fn(Target, table.unpack(Args, 1, #Args))
            end

            return Object[Method[1]](Object, table.unpack(Args, 1, #Args))
        end)

        LastResult = Result
        LastResultIsError = not Good

        if Good then
            if Method[1] == "getconnections" and type(Result) == "table" then
                self:ShowConnectionsResult(Result)
                ResultLabel.Text = `OK: {#Result} connection(s)`
            elseif type(Result) == "table" then
                local Count = 0
                for _ in Result do
                    Count += 1
                end
                ResultLabel.Text = `OK ({Count} entries):\n{FormatResultForDisplay(Result)}`
            else
                ResultLabel.Text = `OK: {FormatResultForDisplay(Result)}`
            end
            ResultLabel.TextColor3 = Theme.Green
        else
            ResultLabel.Text = `ERROR: {tostring(Result)}`
            ResultLabel.TextColor3 = Theme.Red
        end
    end)

    local CopyOutputButton = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 0, 24);
        BackgroundColor3 = Theme.Field;
        BackgroundTransparency = 0.3;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Font = Fonts.SemiBold;
        Text = "Copy Output";
        TextColor3 = Theme.Text;
        TextSize = 11;
        LayoutOrder = 92;
        ZIndex = 202;
        Parent = Body;
    })
    VexUI:AddStroke(CopyOutputButton, "Border", 1)

    local function SerializeOutput(Value)
        if Value == nil then
            return "nil"
        end

        local ValueType = typeof(Value)

        if ValueType == "string" then
            return string.format("%q", Value)
        end

        if ValueType == "number" or ValueType == "boolean" then
            return tostring(Value)
        end

        if ValueType == "Instance" then
            local Good, Path = pcall(function() return BuildLuaPath(Value) end)
            return Good and Path or Value:GetFullName()
        end

        if ValueType == "table" then
            local Lines = { "{" }
            local Count = 0
            for K, V in Value do
                Count += 1
                local Key = (type(K) == "string" and K:match("^[%a_][%w_]*$"))
                    and K
                    or `[{type(K) == "string" and string.format("%q", K) or tostring(K)}]`
                Lines[#Lines + 1] = `    {Key} = {SerializeOutput(V)};`
            end
            if Count == 0 then return "{}" end
            Lines[#Lines + 1] = "}"
            return table.concat(Lines, "\n")
        end

        local Good, Formatted = pcall(function() return self:FormatValue(Value) end)
        if Good and type(Formatted) == "string" then
            return Formatted
        end

        return tostring(Value)
    end

    CopyOutputButton.MouseButton1Click:Connect(function()
        if LastResult == nil and not LastResultIsError then
            CopyOutputButton.Text = "Nothing to copy"
            task.delay(1.2, function()
                if CopyOutputButton and CopyOutputButton.Parent then
                    CopyOutputButton.Text = "Copy Output"
                end
            end)

            return
        end

        local Text
        if LastResultIsError then
            Text = `-- ERROR: {tostring(LastResult)}`
        else
            Text = SerializeOutput(LastResult)
        end

        local Good = pcall(setclipboard, Text)
        CopyOutputButton.Text = Good and "Copied!" or "Failed"

        task.delay(1.2, function()
            if CopyOutputButton and CopyOutputButton.Parent then
                CopyOutputButton.Text = "Copy Output"
            end
        end)
    end)
end

function Explorer:ShowConnectionsResult(Connections)
    if type(Connections) ~= "table" or #Connections == 0 then
        self:Notify("No connections found")
        return
    end

    local Window, Body = self:CreateModalWindow(
        `Connections ({#Connections})`,
        540,
        math.min(560, 80 + #Connections * 68)
    )

    local Scroll = VexUI:CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0);
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        ScrollBarThickness = 4;
        ScrollBarImageColor3 = Theme.Border;
        CanvasSize = UDim2.new(0, 0, 0, 0);
        AutomaticCanvasSize = Enum.AutomaticSize.Y;
        ZIndex = 202;
        Parent = Body;
    })
    VexUI:AddListLayout(Scroll, 4, Enum.FillDirection.Vertical)

    local function SafeRead(Conn, Key)
        local Good, Value = pcall(function() return Conn[Key] end)
        if Good then return Value end
        return nil
    end

    local function FormatFunction(Fn)
        if type(Fn) ~= "function" then
            return "<function unavailable>"
        end

        local GoodInfo, Info = pcall(debug.info, Fn, "sln")
        if GoodInfo and type(Info) == "string" and Info ~= "" then
            return Info
        end

        local GoodMulti = pcall(debug.info, Fn, "s")
        if GoodMulti then
            local Src  = debug.info(Fn, "s")
            local Line = debug.info(Fn, "l")
            local Name = debug.info(Fn, "n")
            return `{Src or "?"}:{Line or "?"} {Name and `({Name})` or ""}`
        end

        return tostring(Fn)
    end

    for Index, Conn in Connections do
        local Row = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 64);
            BackgroundColor3 = Theme.Field;
            BackgroundTransparency = 0.4;
            BorderSizePixel = 0;
            LayoutOrder = Index;
            ZIndex = 202;
            Parent = Scroll;
        })
        VexUI:AddStroke(Row, "Border", 1)
        VexUI:AddPadding(Row, 6, 8, 6, 8)

        local Enabled = SafeRead(Conn, "Enabled")
        local ForeignState = SafeRead(Conn, "ForeignState")
        local LuaConnection = SafeRead(Conn, "LuaConnection")
        local Fn = SafeRead(Conn, "Function")

        local Header = VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 14);
            BackgroundTransparency = 1;
            Font = Fonts.Mono;
            Text = `[{Index}]  Enabled={tostring(Enabled)}   Foreign={tostring(ForeignState)}   Lua={tostring(LuaConnection)}`;
            TextColor3 = Theme.Text;
            TextSize = 11;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 203;
            Parent = Row;
        })

        local FnLabel = VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 14);
            Position = UDim2.new(0, 0, 0, 16);
            BackgroundTransparency = 1;
            Font = Fonts.Mono;
            Text = FormatFunction(Fn);
            TextColor3 = Theme.TextDim;
            TextSize = 10;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextTruncate = Enum.TextTruncate.AtEnd;
            ZIndex = 203;
            Parent = Row;
        })

        local function RefreshEnabled()
            local NewEnabled = SafeRead(Conn, "Enabled")
            Header.Text = `[{Index}]  Enabled={tostring(NewEnabled)}   Foreign={tostring(ForeignState)}   Lua={tostring(LuaConnection)}`
        end

        local BtnStrip = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 18);
            Position = UDim2.new(0, 0, 1, -20);
            BackgroundTransparency = 1;
            ZIndex = 203;
            Parent = Row;
        })

        VexUI:CreateInstance("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal;
            Padding = UDim.new(0, 4);
            SortOrder = Enum.SortOrder.LayoutOrder;
            VerticalAlignment = Enum.VerticalAlignment.Center;
            Parent = BtnStrip;
        })

        local BtnOrder = 0
        local function MakeBtn(LabelText, Width, OnClick)
            BtnOrder += 1
            local Btn = VexUI:CreateInstance("TextButton", {
                Size = UDim2.new(0, Width, 1, 0);
                BackgroundColor3 = Theme.Field;
                BorderSizePixel = 0;
                AutoButtonColor = false;
                Font = Fonts.SemiBold;
                Text = LabelText;
                TextColor3 = Theme.Text;
                TextSize = 10;
                LayoutOrder = BtnOrder;
                ZIndex = 203;
                Parent = BtnStrip;
            })
            VexUI:AddStroke(Btn, "Border", 1)
            Btn.MouseButton1Click:Connect(OnClick)
            Btn.MouseEnter:Connect(function()
                VexUI:Tween(Btn, {BackgroundTransparency = 0.2})
            end)
            Btn.MouseLeave:Connect(function()
                VexUI:Tween(Btn, {BackgroundTransparency = 0})
            end)
            return Btn
        end

        MakeBtn("Fire", 48, function()
            local Good, Err = pcall(function() Conn:Fire() end)
            if not Good then self:Notify(`Fire failed: {Err}`) end
        end)

        MakeBtn("Defer", 52, function()
            local Good, Err = pcall(function() Conn:Defer() end)
            if not Good then self:Notify(`Defer failed: {Err}`) end
        end)

        MakeBtn("Disable", 60, function()
            local Good, Err = pcall(function() Conn:Disable() end)
            if Good then RefreshEnabled() else self:Notify(`Disable failed: {Err}`) end
        end)

        MakeBtn("Enable", 56, function()
            local Good, Err = pcall(function() Conn:Enable() end)
            if Good then RefreshEnabled() else self:Notify(`Enable failed: {Err}`) end
        end)

        MakeBtn("Disconnect", 78, function()
            local Good, Err = pcall(function() Conn:Disconnect() end)
            if Good then
                Row.BackgroundTransparency = 0.8
                Header.TextColor3 = Theme.TextFaded
                FnLabel.TextColor3 = Theme.TextFaded
                self:Notify(`Disconnected connection [{Index}]`)
            else
                self:Notify(`Disconnect failed: {Err}`)
            end
        end)

        MakeBtn("Copy Function Info", 120, function()
            local Text = FormatFunction(Fn)
            local Good = pcall(setclipboard, Text)
            self:Notify(Good and "Copied function info" or "Copy failed")
        end)
    end
end

function Explorer:OpenCallRemote()
    local Object = self.SelectedInstance
    if not Object then
        return
    end

    local Class = Object.ClassName

    local CallName
    if Class == "RemoteEvent" or Class == "UnreliableRemoteEvent" then
        CallName = "FireServer"
    elseif Class == "RemoteFunction" then
        CallName = "InvokeServer"
    elseif Class == "BindableEvent" then
        CallName = "Fire"
    elseif Class == "BindableFunction" then
        CallName = "Invoke"
    else
        self:Notify("Selection is not a remote/bindable")

        return
    end

    local Window, Body = self:CreateModalWindow(`Call Remote :{CallName}`, 380, 360)
    VexUI:AddListLayout(Body, 6, Enum.FillDirection.Vertical)

    VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 18);
        BackgroundTransparency = 1;
        Font = Fonts.Mono;
        Text = `:{CallName}(...)`;
        TextColor3 = Theme.Accent;
        TextSize = 11;
        TextXAlignment = Enum.TextXAlignment.Left;
        LayoutOrder = 1;
        ZIndex = 202;
        Parent = Body;
    })

    VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 28);
        BackgroundTransparency = 1;
        Font = Fonts.Medium;
        Text = `Args (one per line: "hello", 42, true):`;
        TextColor3 = Theme.TextDim;
        TextSize = 11;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextWrapped = true;
        TextYAlignment = Enum.TextYAlignment.Top;
        LayoutOrder = 2;
        ZIndex = 202;
        Parent = Body;
    })

    local Box = VexUI:CreateInstance("TextBox", {
        Size = UDim2.new(1, 0, 0, 130);
        BackgroundColor3 = Theme.Field;
        BorderSizePixel = 0;
        Font = Fonts.Mono;
        Text = "";
        TextColor3 = Theme.Text;
        TextSize = 11;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextYAlignment = Enum.TextYAlignment.Top;
        ClearTextOnFocus = false;
        MultiLine = true;
        PlaceholderText = "(empty for no args)";
        PlaceholderColor3 = Theme.TextFaded;
        LayoutOrder = 3;
        ZIndex = 202;
        Parent = Body;
    })
    
    VexUI:AddStroke(Box, "Border", 1)
    VexUI:AddPadding(Box, 6, 8, 6, 8)

    local ResultLabel = VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 50);
        BackgroundColor3 = Theme.Field;
        BorderSizePixel = 0;
        Font = Fonts.Mono;
        Text = "(no result)";
        TextColor3 = Theme.TextDim;
        TextSize = 11;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextWrapped = true;
        TextYAlignment = Enum.TextYAlignment.Top;
        LayoutOrder = 4;
        ZIndex = 202;
        Parent = Body;
    })
    
    VexUI:AddPadding(ResultLabel, 6, 8, 6, 8)

    local FireButton = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 0, 28);
        BackgroundColor3 = Theme.Accent;
        BackgroundTransparency = 0.85;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Font = Fonts.SemiBold;
        Text = CallName;
        TextColor3 = Theme.Accent;
        TextSize = 12;
        LayoutOrder = 5;
        ZIndex = 202;
        Parent = Body;
    })
    
    VexUI:AddStroke(FireButton, Theme.Accent, 1)

    FireButton.MouseButton1Click:Connect(function()
        local Args = {}
        for Line in Box.Text:gmatch("[^\r\n]+") do
            local Trimmed = Line:gsub("^%s+", ""):gsub("%s+$", "")
            if Trimmed ~= "" then
                local AsNumber = tonumber(Trimmed)
                if AsNumber then
                    table.insert(Args, AsNumber)
                elseif Trimmed == "true" then
                    table.insert(Args, true)
                elseif Trimmed == "false" then
                    table.insert(Args, false)
                elseif Trimmed == "nil" then
                    table.insert(Args, nil)
                else
                    table.insert(Args, (Trimmed:gsub("^['\"]", ""):gsub("['\"]$", "")))
                end
            end
        end

        local Good, Result = pcall(function()
            return Object[CallName](Object, table.unpack(Args, 1, #Args))
        end)

        if Good then
            ResultLabel.Text = `OK: {self:FormatValue(Result)}`
            ResultLabel.TextColor3 = Theme.Green
        else
            ResultLabel.Text = `ERROR: {tostring(Result)}`
            ResultLabel.TextColor3 = Theme.Red
        end
    end)
end

local SyntaxColors = {
    Keyword = "rgb(255, 105, 117)";
    Builtin = "rgb(130, 170, 255)";
    Number = "rgb(255, 198, 109)";
    String = "rgb(195, 232, 141)";
    Comment = "rgb(99, 121, 134)";
    Function = "rgb(255, 215, 100)";
    Operator = "rgb(220, 220, 220)";
    Default = "rgb(230, 230, 230)";
    Global = "rgb(130, 170, 255)";
    Member = "rgb(130, 200, 255)";
    Type = "rgb(130, 200, 255)";
}

local KeywordSet = {
    ["and"] = true;
    ["break"] = true;
    ["continue"] = true;
    ["do"] = true;
    ["else"] = true;
    ["elseif"] = true;
    ["end"] = true;
    ["false"] = true;
    ["for"] = true;
    ["function"] = true;
    ["if"] = true;
    ["in"] = true;
    ["local"] = true;
    ["nil"] = true;
    ["not"] = true;
    ["or"] = true;
    ["repeat"] = true;
    ["return"] = true;
    ["then"] = true;
    ["true"] = true;
    ["until"] = true;
    ["while"] = true;
    ["export"] = true;
    ["type"] = true;
    ["typeof"] = true;
}

local BuiltinSet = {
    ["self"] = true;
    ["_G"] = true;
    ["_ENV"] = true;
    ["assert"] = true;
    ["error"] = true;
    ["getfenv"] = true;
    ["getmetatable"] = true;
    ["ipairs"] = true;
    ["next"] = true;
    ["pairs"] = true;
    ["pcall"] = true;
    ["print"] = true;
    ["rawequal"] = true;
    ["rawget"] = true;
    ["rawlen"] = true;
    ["rawset"] = true;
    ["select"] = true;
    ["setfenv"] = true;
    ["setmetatable"] = true;
    ["tonumber"] = true;
    ["tostring"] = true;
    ["type"] = true;
    ["unpack"] = true;
    ["xpcall"] = true;
    ["require"] = true;
    ["string"] = true;
    ["table"] = true;
    ["math"] = true;
    ["os"] = true;
    ["coroutine"] = true;
    ["bit32"] = true;
    ["buffer"] = true;
    ["debug"] = true;
    ["utf8"] = true;
    ["task"] = true;
}

local GlobalSet = {
    ["game"] = true;
    ["workspace"] = true;
    ["script"] = true;
    ["plugin"] = true;
    ["shared"] = true;
    ["Enum"] = true;
    ["Instance"] = true;
    ["CFrame"] = true;
    ["Vector3"] = true;
    ["Vector2"] = true;
    ["UDim"] = true;
    ["UDim2"] = true;
    ["Color3"] = true;
    ["BrickColor"] = true;
    ["Ray"] = true;
    ["Region3"] = true;
    ["TweenInfo"] = true;
    ["NumberRange"] = true;
    ["NumberSequence"] = true;
    ["NumberSequenceKeypoint"] = true;
    ["ColorSequence"] = true;
    ["ColorSequenceKeypoint"] = true;
    ["Rect"] = true;
    ["Faces"] = true;
    ["Axes"] = true;
    ["PhysicalProperties"] = true;
    ["Random"] = true;
    ["Vector3int16"] = true;
    ["Vector2int16"] = true;
    ["Region3int16"] = true;
    ["DateTime"] = true;
    ["RaycastParams"] = true;
    ["OverlapParams"] = true;
}

local function EscapeXml(Text)
    return (Text:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;"):gsub("\"", "&quot;"))
end

local function Wrap(Color, Text)
    if Text == "" then
        return ""
    end

    return `<font color="{Color}">{EscapeXml(Text)}</font>`
end

local function HighlightLuau(Source)
    local Out = {}
    local Pos = 1
    local StringLength = #Source

    local function Emit(Color, Text)
        Out[#Out + 1] = Wrap(Color, Text)
    end

    while Pos <= StringLength do
        local Char = Source:sub(Pos, Pos)
        local Char2 = Source:sub(Pos, Pos + 1)

        if Char2 == "--" then
            local AfterDashes = Pos + 2
            local OpenBracket = Source:match("^(%[=*%[)", AfterDashes)
            if OpenBracket then
                local Eq = #OpenBracket - 2
                local Close = "%]" .. string.rep("=", Eq) .. "%]"
                local _, CloseEnd = Source:find(Close, AfterDashes + #OpenBracket)
                local EndPos = CloseEnd or StringLength
                Emit(SyntaxColors.Comment, Source:sub(Pos, EndPos))
                Pos = EndPos + 1
            else
                local NewlinePos = Source:find("\n", Pos, true) or (StringLength + 1)
                Emit(SyntaxColors.Comment, Source:sub(Pos, NewlinePos - 1))
                Pos = NewlinePos
            end
        elseif Char == "[" and Source:match("^%[=*%[", Pos) then
            local OpenBracket = Source:match("^(%[=*%[)", Pos)
            local Eq = #OpenBracket - 2
            local Close = "%]" .. string.rep("=", Eq) .. "%]"
            local _, CloseEnd = Source:find(Close, Pos + #OpenBracket)
            local EndPos = CloseEnd or StringLength
            Emit(SyntaxColors.String, Source:sub(Pos, EndPos))
            Pos = EndPos + 1
        elseif Char == "\"" or Char == "'" then
            local Quote = Char
            local Start = Pos
            local Index = Pos + 1
            while Index <= StringLength do
                local Current = Source:sub(Index, Index)
                if Current == "\\" then
                    Index += 2
                elseif Current == Quote then
                    Index += 1
                    break
                elseif Current == "\n" then
                    break
                else
                    Index += 1
                end
            end

            Emit(SyntaxColors.String, Source:sub(Start, Index - 1))
            Pos = Index
        elseif Char == "`" then
            local Start = Pos
            local Index = Pos + 1
            while Index <= StringLength do
                local Current = Source:sub(Index, Index)
                if Current == "\\" then
                    Index += 2
                elseif Current == "`" then
                    Index += 1
                    break
                else
                    Index += 1
                end
            end

            Emit(SyntaxColors.String, Source:sub(Start, Index - 1))
            Pos = Index
        elseif Char:match("%d") or (Char == "." and Source:sub(Pos + 1, Pos + 1):match("%d")) then
            local NumStart = Pos
            local NumEnd
            local Hex = Source:sub(Pos, Pos + 1)
            if Hex == "0x" or Hex == "0X" then
                NumEnd = Source:find("[^%w]", Pos + 2) or (StringLength + 1)
            else
                NumEnd = Source:find("[^%d%.eE_]", Pos) or (StringLength + 1)
                if Source:sub(NumEnd - 1, NumEnd - 1):match("[eE]") then
                    local Sign = Source:sub(NumEnd, NumEnd)
                    if Sign == "+" or Sign == "-" then
                        NumEnd = Source:find("[^%d_]", NumEnd + 1) or (StringLength + 1)
                    end
                end
            end
            Emit(SyntaxColors.Number, Source:sub(NumStart, NumEnd - 1))
            Pos = NumEnd
        elseif Char:match("[%a_]") then
            local IdEnd = Source:find("[^%w_]", Pos) or (StringLength + 1)
            local Word = Source:sub(Pos, IdEnd - 1)
            local After = Source:sub(IdEnd, IdEnd)
            local Before = Pos > 1 and Source:sub(Pos - 1, Pos - 1) or ""

            local PeekIndex = IdEnd
            while PeekIndex <= StringLength and Source:sub(PeekIndex, PeekIndex):match("[ \t]") do
                PeekIndex += 1
            end

            local Color
            if KeywordSet[Word] then
                Color = SyntaxColors.Keyword
            elseif BuiltinSet[Word] then
                Color = SyntaxColors.Builtin
            elseif GlobalSet[Word] then
                Color = SyntaxColors.Global
            elseif Before == ":" or Before == "." then
                Color = After == "(" and SyntaxColors.Function or SyntaxColors.Member
            elseif After == "(" then
                Color = SyntaxColors.Function
            elseif (Before == ":" or Before == ",") and Word:sub(1, 1):match("%u") then
                Color = SyntaxColors.Type
            else
                Color = SyntaxColors.Default
            end

            Emit(Color, Word)
            Pos = IdEnd
        elseif Char == "\n" or Char == "\t" or Char == " " or Char == "\r" then
            local WhiteEnd = Source:find("[^ \t\r\n]", Pos) or (StringLength + 1)
            Out[#Out + 1] = EscapeXml(Source:sub(Pos, WhiteEnd - 1))
            Pos = WhiteEnd
        else
            local OpEnd = Pos + 1
            while OpEnd <= StringLength and Source:sub(OpEnd, OpEnd):match("[%+%-%*/%%%^=~<>#%(%)%{%}%[%]:;,%.]") do
                OpEnd += 1
            end

            Emit(SyntaxColors.Operator, Source:sub(Pos, OpEnd - 1))
            Pos = OpEnd
        end
    end

    return table.concat(Out)
end

function Explorer:DumpScriptFunctions(ScriptObject)
    local GetScriptClosure = GetGlobalCallable("getscriptclosure")
    local GetGc = GetGlobalCallable("getgc")

    local GetInfo = debug and debug.info
    local GetConstants = debug and debug.getconstants
    local GetUpvalues = debug and debug.getupvalues
    local GetProtos = debug and debug.getprotos

    if not (GetInfo and (GetConstants or GetUpvalues)) then
        return nil
    end

    local Seen = {}
    local Functions = {}

    local function VisitFunction(Fn)
        if type(Fn) ~= "function" or Seen[Fn] then
            return
        end

        Seen[Fn] = true
        table.insert(Functions, Fn)

        if GetProtos then
            local Success, Protos = pcall(GetProtos, Fn)

            if Success and type(Protos) == "table" then
                for _, Proto in Protos do
                    VisitFunction(Proto)
                end
            end
        end
    end

    if GetScriptClosure then
        local Success, RootFn = pcall(GetScriptClosure, ScriptObject)

        if Success and type(RootFn) == "function" then
            VisitFunction(RootFn)
        end
    end

    if GetGc then
        local Success, GcList = pcall(GetGc, true)

        if Success and type(GcList) == "table" then
            for _, Item in GcList do
                if type(Item) == "function" and not Seen[Item] then
                    local Owns = false

                    if GetUpvalues then
                        local UpvalueSuccess, Upvalues = pcall(GetUpvalues, Item)

                        if UpvalueSuccess and type(Upvalues) == "table" then
                            for _, Upvalue in Upvalues do
                                if Upvalue == ScriptObject then
                                    Owns = true
                                    break
                                end
                            end
                        end
                    end

                    if Owns then
                        VisitFunction(Item)
                    end
                end
            end
        end
    end

    if #Functions == 0 then
        return string.format(
            "-- No functions could be enumerated for %s\n-- Your executor may not support getscriptclosure / debug APIs.",
            ScriptObject:GetFullName()
        )
    end

    local Lines = {}

    local function Push(Text)
        table.insert(Lines, Text)
    end

    local function FormatValue(Value)
        local ValueType = typeof(Value)

        if ValueType == "string" then
            return string.format("%q", Value)
        end

        if ValueType == "number"
            or ValueType == "boolean"
            or ValueType == "nil"
        then
            return tostring(Value)
        end

        if ValueType == "Instance" then
            return string.format(
                "<%s> %s",
                Value.ClassName,
                Value:GetFullName()
            )
        end

        if ValueType == "function" then
            local Source = "?"
            local Line = "?"
            local Name = ""

            pcall(function()
                Source = debug.info(Value, "s") or "?"
                Line = debug.info(Value, "l") or "?"
                Name = debug.info(Value, "n") or ""
            end)

            return string.format(
                "<function %s @ %s:%s>",
                Name ~= "" and Name or "?",
                Source,
                Line
            )
        end

        if ValueType == "table" then
            return string.format("<table %s>", tostring(Value))
        end

        return string.format(
            "<%s> %s",
            ValueType,
            tostring(Value)
        )
    end

    Push(string.format(
        "-- Function dump for %s",
        ScriptObject:GetFullName()
    ))

    Push(string.format(
        "-- Functions found: %d",
        #Functions
    ))

    Push(string.rep("-", 72))

    for Index, Fn in Functions do
        local Source = "?"
        local Line = "?"
        local Name = ""

        pcall(function()
            Source = debug.info(Fn, "s") or "?"
            Line = debug.info(Fn, "l") or "?"
            Name = debug.info(Fn, "n") or ""
        end)

        Push("")
        Push(string.format(
            "[%d] %s @ %s:%s",
            Index,
            Name ~= "" and Name or "(anonymous)",
            Source,
            Line
        ))

        if GetConstants then
            local Success, Constants = pcall(GetConstants, Fn)

            if Success and type(Constants) == "table" then
                if next(Constants) == nil then
                    Push("  Constants: (none)")
                else
                    Push("  Constants:")

                    for ConstantIndex, ConstantValue in Constants do
                        Push(string.format(
                            "    [%s] = %s",
                            tostring(ConstantIndex),
                            FormatValue(ConstantValue)
                        ))
                    end
                end
            else
                Push(string.format(
                    "  Constants: <unavailable> (%s)",
                    tostring(Constants)
                ))
            end
        end

        if GetUpvalues then
            local Success, Upvalues = pcall(GetUpvalues, Fn)

            if Success and type(Upvalues) == "table" then
                if next(Upvalues) == nil then
                    Push("  Upvalues: (none)")
                else
                    Push("  Upvalues:")

                    for UpvalueIndex, UpvalueValue in Upvalues do
                        Push(string.format(
                            "    [%s] = %s",
                            tostring(UpvalueIndex),
                            FormatValue(UpvalueValue)
                        ))
                    end
                end
            else
                Push(string.format(
                    "  Upvalues: <unavailable> (%s)",
                    tostring(Upvalues)
                ))
            end
        end
    end

    return table.concat(Lines, "\n")
end

function Explorer:CollectScriptFunctions(ScriptObject)
    local GetScriptClosure = GetGlobalCallable("getscriptclosure")
    local GetProtos = debug and debug.getprotos
    local GetUpvalues = debug and debug.getupvalues
    local GetGc = GetGlobalCallable("getgc")

    local Seen = {}
    local Functions = {}

    local function Visit(Fn)
        if type(Fn) ~= "function" or Seen[Fn] then return end
        Seen[Fn] = true
        Functions[#Functions + 1] = Fn

        if GetProtos then
            local Good, Protos = pcall(GetProtos, Fn)
            if Good and type(Protos) == "table" then
                for _, Proto in Protos do Visit(Proto) end
            end
        end
    end

    local ClosureSucceeded = false
    if GetScriptClosure then
        local Good, RootFn = pcall(GetScriptClosure, ScriptObject)
        if Good and type(RootFn) == "function" then
            Visit(RootFn)
            ClosureSucceeded = true
        end
    end

    if not ClosureSucceeded and GetGc then
        local Good, GcList = pcall(GetGc, true)
        if Good and type(GcList) == "table" then
            for _, Item in GcList do
                if type(Item) == "function" and not Seen[Item] and GetUpvalues then
                    local UpGood, Ups = pcall(GetUpvalues, Item)
                    if UpGood and type(Ups) == "table" then
                        for _, UpVal in Ups do
                            if UpVal == ScriptObject then
                                Visit(Item)
                                break
                            end
                        end
                    end
                end
            end
        end
    end

    return Functions
end

function Explorer:OpenConstantUpvalueSearch(ScriptObject)
    local GetConstants = debug and debug.getconstants
    local GetUpvalues  = debug and debug.getupvalues
    local GetInfo = debug and debug.info

    if not (GetInfo and (GetConstants or GetUpvalues)) then
        self:Notify("Search: executor missing debug.getconstants / getupvalues")
        return
    end

    local Functions = self:CollectScriptFunctions(ScriptObject)
    if #Functions == 0 then
        self:Notify("Search: no functions could be enumerated")
        return
    end

    local Window, Body = self:CreateModalWindow(`Search: {ScriptObject.Name}`, 560, 460)

    local TopBar = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 26);
        Position = UDim2.new(0, 0, 0, 0);
        BackgroundTransparency = 1;
        ZIndex = 202;
        Parent = Body;
    })

    local SearchBox = VexUI:CreateInstance("TextBox", {
        Size = UDim2.new(1, -128, 1, 0);
        BackgroundColor3 = Theme.Field;
        BorderSizePixel = 0;
        Font = Fonts.Mono;
        Text = "";
        PlaceholderText = "Search constants & upvalues…";
        PlaceholderColor3 = Theme.TextFaded;
        TextColor3 = Theme.Text;
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Left;
        ClearTextOnFocus = false;
        ZIndex = 203;
        Parent = TopBar;
    })
    VexUI:AddStroke(SearchBox, "Border", 1)
    VexUI:AddPadding(SearchBox, 0, 8, 0, 8)

    local function MakeFilterToggle(Text, Width, RightOffset, InitialOn)
        local State = InitialOn ~= false
        local Btn = VexUI:CreateInstance("TextButton", {
            Size = UDim2.new(0, Width, 1, 0);
            Position = UDim2.new(1, -RightOffset, 0, 0);
            BackgroundColor3 = State and Theme.Accent or Theme.Field;
            BackgroundTransparency = State and 0 or 0.3;
            BorderSizePixel = 0;
            AutoButtonColor = false;
            Font = Fonts.SemiBold;
            Text = Text;
            TextColor3 = Theme.Text;
            TextSize = 11;
            ZIndex = 203;
            Parent = TopBar;
        })
        VexUI:AddStroke(Btn, "Border", 1)
        return Btn, function() return State end, function(NewState)
            State = NewState
            Btn.BackgroundColor3 = State and Theme.Accent or Theme.Field
            Btn.BackgroundTransparency = State and 0 or 0.3
        end
    end

    local ConstsBtn, GetConstsOn, SetConstsOn = MakeFilterToggle("Const", 56, 122, true)
    local UpsBtn, GetUpsOn, SetUpsOn = MakeFilterToggle("Upval", 56, 60,  true)

    ConstsBtn.MouseButton1Click:Connect(function() SetConstsOn(not GetConstsOn()) end)
    UpsBtn.MouseButton1Click:Connect(function() SetUpsOn(not GetUpsOn()) end)

    local CountLabel = VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 16);
        Position = UDim2.new(0, 0, 0, 32);
        BackgroundTransparency = 1;
        Font = Fonts.Medium;
        Text = "";
        TextColor3 = Theme.TextDim;
        TextSize = 11;
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = 202;
        Parent = Body;
    })

    local Results = VexUI:CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, -54);
        Position = UDim2.new(0, 0, 0, 54);
        BackgroundColor3 = Theme.Background;
        BackgroundTransparency = 0.4;
        BorderSizePixel = 0;
        ScrollBarThickness = 4;
        ScrollBarImageColor3 = Theme.Border;
        CanvasSize = UDim2.new(0, 0, 0, 0);
        AutomaticCanvasSize = Enum.AutomaticSize.Y;
        ScrollingDirection = Enum.ScrollingDirection.Y;
        ZIndex = 202;
        Parent = Body;
    })
    VexUI:AddStroke(Results, "BorderSoft", 1)

    VexUI:CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical;
        Padding = UDim.new(0, 2);
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = Results;
    })
    VexUI:AddPadding(Results, 4, 6, 4, 6)

    local function FormatValue(Value)
        local Tp = typeof(Value)
        if Tp == "string"  then return string.format("%q", Value) end
        if Tp == "number" or Tp == "boolean" or Tp == "nil" then return tostring(Value) end
        if Tp == "Instance" then return `<{Value.ClassName}> {Value:GetFullName()}` end
        if Tp == "function" then
            local Src, Line = "?", "?"
            pcall(function()
                Src  = debug.info(Value, "s") or "?"
                Line = debug.info(Value, "l") or "?"
            end)
            return `<function @ {Src}:{Line}>`
        end
        if Tp == "table" then return `<table {tostring(Value)}>` end
        return `<{Tp}> {tostring(Value)}`
    end

    local function ValueMatches(Value, Needle)
        local Formatted = FormatValue(Value):lower()
        return Formatted:find(Needle, 1, true) ~= nil
    end

    local function ClearResults()
        for _, Child in Results:GetChildren() do
            if Child:IsA("Frame") then Child:Destroy() end
        end
    end

    local ResultOrder = 0
    local function AddResultRow(Kind, FnIndex, FnLabel, EntryIdx, Value)
        ResultOrder += 1
        local Row = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 36);
            BackgroundColor3 = Theme.Field;
            BackgroundTransparency = 0.5;
            BorderSizePixel = 0;
            LayoutOrder = ResultOrder;
            ZIndex = 203;
            Parent = Results;
        })
        VexUI:AddStroke(Row, "BorderSoft", 1)

        VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, -12, 0, 14);
            Position = UDim2.new(0, 6, 0, 3);
            BackgroundTransparency = 1;
            Font = Fonts.SemiBold;
            Text = `[{Kind}] [{EntryIdx}]  ·  fn #{FnIndex}  {FnLabel}`;
            TextColor3 = Theme.PropEnum;
            TextSize = 11;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextTruncate = Enum.TextTruncate.AtEnd;
            ZIndex = 204;
            Parent = Row;
        })

        local ValueLabel = VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, -12, 0, 16);
            Position = UDim2.new(0, 6, 0, 17);
            BackgroundTransparency = 1;
            Font = Fonts.Mono;
            Text = FormatValue(Value);
            TextColor3 = Theme.Text;
            TextSize = 11;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextTruncate = Enum.TextTruncate.AtEnd;
            ZIndex = 204;
            Parent = Row;
        })

        local Catcher = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 1, 0);
            BackgroundTransparency = 1;
            ZIndex = 205;
            Parent = Row;
        })
        Catcher.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton2 then
                pcall(setclipboard, ValueLabel.Text)
                self:Notify("Copied value")
            end
        end)
    end

    local function RunSearch()
        ClearResults()
        ResultOrder = 0
        local Query = SearchBox.Text:lower()
        if Query == "" then
            CountLabel.Text = "Type to search constants & upvalues. Right-click a result to copy its value."
            return
        end

        local Hits = 0
        local Scanned = 0
        local SearchConsts = GetConstsOn()
        local SearchUps    = GetUpsOn()

        for FnIndex, Fn in Functions do
            Scanned += 1
            local Src, Line, Name = "?", "?", ""
            pcall(function()
                Src  = debug.info(Fn, "s") or "?"
                Line = debug.info(Fn, "l") or "?"
                Name = debug.info(Fn, "n") or ""
            end)
            local FnLabel = `{Name ~= "" and Name or "(anon)"} @ {Src}:{Line}`

            if SearchConsts and GetConstants then
                local Good, Consts = pcall(GetConstants, Fn)
                if Good and type(Consts) == "table" then
                    for ConstIdx, ConstVal in Consts do
                        if ValueMatches(ConstVal, Query) then
                            AddResultRow("CONST", FnIndex, FnLabel, ConstIdx, ConstVal)
                            Hits += 1
                            if Hits >= 500 then break end
                        end
                    end
                end
            end
            if Hits >= 500 then break end

            if SearchUps and GetUpvalues then
                local Good, Ups = pcall(GetUpvalues, Fn)
                if Good and type(Ups) == "table" then
                    for UpIdx, UpVal in Ups do
                        if ValueMatches(UpVal, Query) then
                            AddResultRow("UPVAL", FnIndex, FnLabel, UpIdx, UpVal)
                            Hits += 1
                            if Hits >= 500 then break end
                        end
                    end
                end
            end
            if Hits >= 500 then break end
        end

        CountLabel.Text = Hits >= 500
            and `Showing first 500 matches across {Scanned} function(s) (refine query for more)`
            or `{Hits} match(es) across {Scanned} function(s)`
    end

    local DebounceToken = 0
    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        DebounceToken += 1
        local MyToken = DebounceToken
        task.delay(0.15, function()
            if MyToken == DebounceToken then
                RunSearch()
            end
        end)
    end)

    ConstsBtn.MouseButton1Click:Connect(RunSearch)
    UpsBtn.MouseButton1Click:Connect(RunSearch)

    RunSearch()
    SearchBox:CaptureFocus()
end

function Explorer:OpenScriptViewer(ScriptObject, UseDefault)
    if not ScriptObject then
        return
    end

    self.ScriptViewerWindows = self.ScriptViewerWindows or {}

    for _, Existing in self.ScriptViewerWindows do
        if Existing.ScriptObject == ScriptObject and Existing.Window.Parent then
            Existing.Window.ZIndex = 60

            return
        end
    end

    local Source
    local DecompileFunc = UseDefault and CachedDecompile or decompile
    if DecompileFunc then
        local Good, Result = pcall(DecompileFunc, ScriptObject)
        if Good and type(Result) == "string" and Result ~= "" then
            Source = Result
        end
    end

    if not Source then
        Source = `-- Failed to decompile {ScriptObject.ClassName} "{ScriptObject.Name}"\n-- Your executor probably does not support decompile.`
    end

    local OpenCount = #self.ScriptViewerWindows
    local OffsetX = (OpenCount % 6) * 24
    local OffsetY = (OpenCount % 6) * 24

    local Window = VexUI:CreateInstance("Frame", {
        Size = UDim2.fromOffset(720, 480);
        Position = UDim2.new(0.5, -360 + OffsetX, 0.5, -240 + OffsetY);
        BackgroundColor3 = Theme.Window;
        BackgroundTransparency = UITransparency.Window or 0;
        BorderSizePixel = 0;
        ClipsDescendants = true;
        ZIndex = 50;
        Parent = self.ScreenGui;
    })
    
    BindTheme("Window", function(Color)
        Window.BackgroundColor3 = Color
    end)

    local WindowStroke = VexUI:AddStroke(Window, "Border", 1)
    BindTheme("Border", function(Color)
        WindowStroke.Color = Color
    end)

    VexUI:CreateInstance("TextButton", {
        Size = UDim2.fromScale(1, 1);
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Text = "";
        Modal = false;
        ZIndex = 50;
        Parent = Window;
    })

    if BindTransparency then
        BindTransparency("Window", function(Value)
            Window.BackgroundTransparency = Value
        end)
    end

    local Entry = {Window = Window; ScriptObject = ScriptObject}
    table.insert(self.ScriptViewerWindows, Entry)

    local TitleBar = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 32);
        BackgroundColor3 = Theme.TitleBar;
        BorderSizePixel = 0;
        ZIndex = 51;
        Parent = Window;
    })
    
    BindTheme("TitleBar", function(Color)
        TitleBar.BackgroundColor3 = Color
    end)

    VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 1);
        Position = UDim2.new(0, 0, 1, -1);
        BackgroundColor3 = Theme.Border;
        BorderSizePixel = 0;
        ZIndex = 53;
        Parent = TitleBar;
    })

    VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, -500, 1, 0);
        Position = UDim2.new(0, 12, 0, 0);
        BackgroundTransparency = 1;
        Font = Fonts.Bold;
        Text = `SCRIPT VIEW  -  ({ScriptObject.ClassName}) {ScriptObject.Parent} -> {ScriptObject.Name}`;
        TextColor3 = Theme.Text;
        TextSize = 11;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextTruncate = Enum.TextTruncate.AtEnd;
        ZIndex = 52;
        Parent = TitleBar;
    })

    local ButtonStrip = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(0, 0, 0, 20);
        AutomaticSize = Enum.AutomaticSize.X;
        Position = UDim2.new(1, -8, 0.5, -10);
        AnchorPoint = Vector2.new(1, 0);
        BackgroundTransparency = 1;
        ZIndex = 52;
        Parent = TitleBar;
    })

    VexUI:CreateInstance("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal;
        Padding = UDim.new(0, 6);
        SortOrder = Enum.SortOrder.LayoutOrder;
        VerticalAlignment = Enum.VerticalAlignment.Center;
        Parent = ButtonStrip;
    })

    local StripOrder = 0
    local function MakeStripButton(LabelText, Width, OnClick)
        StripOrder += 1
        local Btn = VexUI:CreateInstance("TextButton", {
            Size = UDim2.fromOffset(Width, 20);
            BackgroundColor3 = Theme.Field;
            BackgroundTransparency = 0.3;
            BorderSizePixel = 0;
            AutoButtonColor = false;
            Font = Fonts.SemiBold;
            Text = LabelText;
            TextColor3 = Theme.Text;
            TextSize = 11;
            LayoutOrder = StripOrder;
            ZIndex = 52;
            Parent = ButtonStrip;
        })
        VexUI:AddStroke(Btn, "Border", 1)
        Btn.MouseButton1Click:Connect(OnClick)
        return Btn
    end

    local function SafeFileBase()
        local Raw = ScriptObject:GetFullName()
        local Cleaned = Raw:gsub("[^%w%-_%.]", "_")
        return Cleaned
    end

    local function FlashButton(Btn, OkText, FailText, Good)
        local Original = Btn.Text
        Btn.Text = Good and OkText or FailText
        task.delay(1.2, function()
            if Btn and Btn.Parent then
                Btn.Text = Original
            end
        end)
    end

    local CopyButton
    CopyButton = MakeStripButton("Copy", 60, function()
        local Good = pcall(setclipboard, Source)
        FlashButton(CopyButton, "Copied!", "Failed", Good)
    end)

    local DumpScriptButton
    DumpScriptButton = MakeStripButton("Dump Script", 86, function()
        local Path = `vex_dumps/{SafeFileBase()}.luau`
        local FileOK = false
        if writefile and isfolder and makefolder then
            FileOK = pcall(function()
                if not isfolder("vex_dumps") then makefolder("vex_dumps") end
                writefile(Path, Source)
            end)
        end
        local ClipOK = pcall(setclipboard, Source)
        FlashButton(
            DumpScriptButton,
            FileOK and "Saved!" or (ClipOK and "Copied!" or "Failed"),
            "Failed",
            FileOK or ClipOK
        )
        self:Notify(FileOK and `Dumped script -> {Path}` or "Script dump failed (file)")
    end)

    local DumpFunctionsButton
    DumpFunctionsButton = MakeStripButton("Dump Functions", 108, function()
        local Result = self:DumpScriptFunctions(ScriptObject)
        if not Result then
            FlashButton(DumpFunctionsButton, "-", "Unavailable", false)
            self:Notify("Dump functions: executor missing required globals")
            return
        end

        local Path = `vex_dumps/{SafeFileBase()}.functions.txt`
        local FileOK = false
        if writefile and isfolder and makefolder then
            FileOK = pcall(function()
                if not isfolder("vex_dumps") then makefolder("vex_dumps") end
                writefile(Path, Result)
            end)
        end
        local ClipOK = pcall(setclipboard, Result)
        FlashButton(
            DumpFunctionsButton,
            FileOK and "Saved!" or (ClipOK and "Copied!" or "Failed"),
            "Failed",
            FileOK or ClipOK
        )
        self:Notify(FileOK and `Dumped functions -> {Path}` or "Functions dump failed (file)")
    end)

    local DumpBytecodeButton
    DumpBytecodeButton = MakeStripButton("Dump Bytecode", 102, function()
        local GetScriptBytecode = GetGlobalCallable("getscriptbytecode")
        if not GetScriptBytecode then
            FlashButton(DumpBytecodeButton, "-", "Unavailable", false)
            self:Notify("Dump bytecode: executor missing getscriptbytecode")

            return
        end

        local Good, Bytecode = pcall(GetScriptBytecode, ScriptObject)
        if not Good or type(Bytecode) ~= "string" or Bytecode == "" then
            FlashButton(DumpBytecodeButton, "-", "Failed", false)
            self:Notify(`Bytecode dump failed: {tostring(Bytecode)}`)

            return
        end

        local Path = `vex_dumps/{SafeFileBase()}.bytecode.bin`
        local FileOK = false
        if writefile and isfolder and makefolder then
            FileOK = pcall(function()
                if not isfolder("vex_dumps") then makefolder("vex_dumps") end
                writefile(Path, Bytecode)
            end)
        end

        local ClipOK = false
        local PreviewBytes = math.min(#Bytecode, 4096)
        local HexChunks = {}
        for I = 1, PreviewBytes do
            HexChunks[I] = string.format("%02X", string.byte(Bytecode, I))
        end

        local Preview = table.concat(HexChunks, " ")
        if #Bytecode > PreviewBytes then
            Preview ..= `\n-- truncated, full length: {#Bytecode} bytes`
        end

        ClipOK = pcall(setclipboard, Preview)

        FlashButton(
            DumpBytecodeButton,
            FileOK and "Saved!" or (ClipOK and "Copied hex" or "Failed"),
            "Failed",
            FileOK or ClipOK
        )

        self:Notify(FileOK
            and `Dumped bytecode ({#Bytecode} bytes) -> {Path}`
            or "Bytecode dump failed (file)"
        )
    end)

    local SearchButton
    SearchButton = MakeStripButton("Search", 64, function()
        self:OpenConstantUpvalueSearch(ScriptObject)
    end)

    local CloseAssetId = GetUIAssetId("CloseIcon")
    local CloseButton = VexUI:CreateInstance("TextButton", {
        Size = UDim2.fromOffset(28, 20);
        BackgroundColor3 = Theme.Accent;
        BackgroundTransparency = 0.85;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Font = Fonts.Bold;
        Text = CloseAssetId and "" or "x";
        TextColor3 = Theme.Accent;
        TextSize = 10;
        LayoutOrder = 999;
        ZIndex = 52;
        Parent = ButtonStrip;
    })

    local CloseStroke = VexUI:AddStroke(CloseButton, Theme.Accent, 1)

    local CloseIcon
    if CloseAssetId then
        CloseIcon = VexUI:CreateInstance("ImageLabel", {
            Size = UDim2.fromOffset(12, 12);
            Position = UDim2.new(0.5, -6, 0.5, -6);
            BackgroundTransparency = 1;
            Image = CloseAssetId;
            ImageColor3 = Theme.Accent;
            ScaleType = Enum.ScaleType.Fit;
            ZIndex = 53;
            Parent = CloseButton;
        })
    end

    BindTheme("Accent", function(Color)
        CloseButton.BackgroundColor3 = Color
        CloseButton.TextColor3 = Color
        CloseStroke.Color = Color
        if CloseIcon then
            CloseIcon.ImageColor3 = Color
        end
    end)

    CloseButton.MouseButton1Click:Connect(function()
        for Index, Item in self.ScriptViewerWindows do
            if Item == Entry then
                table.remove(self.ScriptViewerWindows, Index)
                break
            end
        end
        Window:Destroy()
    end)

    local Body = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, -16, 1, -42);
        Position = UDim2.new(0, 8, 0, 36);
        BackgroundColor3 = Theme.Background;
        BorderSizePixel = 0;
        ClipsDescendants = true;
        ZIndex = 51;
        Parent = Window;
    })
    
    VexUI:AddStroke(Body, Theme.BorderSoft, 1)
    BindTheme("Background", function(Color)
        Body.BackgroundColor3 = Color
    end)

    local Scroll = VexUI:CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0);
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        ScrollBarThickness = 6;
        ScrollBarImageColor3 = Theme.Border;
        CanvasSize = UDim2.new(0, 0, 0, 0);
        AutomaticCanvasSize = Enum.AutomaticSize.XY;
        ScrollingDirection = Enum.ScrollingDirection.XY;
        HorizontalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
        VerticalScrollBarInset = Enum.ScrollBarInset.ScrollBar;
        ZIndex = 51;
        Parent = Body;
    })

    local Lines = {}
    for Line in (`{Source}\n`):gmatch("([^\n]*)\n") do
        Lines[#Lines + 1] = Line
    end

    local LineCount = #Lines
    local LineDigits = #tostring(math.max(1, LineCount))
    local GutterWidth = 8 + LineDigits * 7 + 8

    local GutterHolder = VexUI:CreateInstance("Frame", {
        Size = UDim2.fromOffset(GutterWidth, 0);
        AutomaticSize = Enum.AutomaticSize.Y;
        BackgroundColor3 = Theme.TitleBar;
        BackgroundTransparency = 0.5;
        BorderSizePixel = 0;
        ZIndex = 52;
        Parent = Scroll;
    })
    VexUI:CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        Parent = GutterHolder;
    })
    VexUI:AddPadding(GutterHolder, 6, 8, 6, 0)

    local CodeHolder = VexUI:CreateInstance("Frame", {
        Size = UDim2.fromOffset(0, 0);
        AutomaticSize = Enum.AutomaticSize.XY;
        Position = UDim2.fromOffset(GutterWidth + 6, 0);
        BackgroundTransparency = 1;
        ZIndex = 52;
        Parent = Scroll;
    })
    VexUI:CreateInstance("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder;
        HorizontalAlignment = Enum.HorizontalAlignment.Left;
        Parent = CodeHolder;
    })
    VexUI:AddPadding(CodeHolder, 6, 8, 6, 4)

    local LinesPerChunk = 200
    local MaxRich = 180000
    local ChunkOrder = 0

    local function MakeCodeLabel(Text)
        ChunkOrder += 1

        return VexUI:CreateInstance("TextLabel", {
            Size = UDim2.fromOffset(0, 0);
            AutomaticSize = Enum.AutomaticSize.XY;
            BackgroundTransparency = 1;
            Font = Fonts.Code;
            Text = Text;
            TextColor3 = Theme.Text;
            TextSize = 13;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextYAlignment = Enum.TextYAlignment.Top;
            TextWrapped = false;
            RichText = true;
            ZIndex = 52;
            LayoutOrder = ChunkOrder;
            Parent = CodeHolder;
        })
    end

    local function MakeGutterLabel(StartLine, EndLine)
        local Nums = {}
        for Index = StartLine, EndLine do
            Nums[#Nums + 1] = tostring(Index)
        end

        return VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0);
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundTransparency = 1;
            Font = Fonts.Code;
            Text = table.concat(Nums, "\n");
            TextColor3 = Theme.TextFaded;
            TextSize = 13;
            TextXAlignment = Enum.TextXAlignment.Right;
            TextYAlignment = Enum.TextYAlignment.Top;
            LayoutOrder = ChunkOrder;
            ZIndex = 52;
            Parent = GutterHolder;
        })
    end

    local function HighlightSafe(Text)
        local Good, Result = pcall(HighlightLuau, Text)
        if not Good
            or type(Result) ~= "string"
        then
            return EscapeXml(Text)
        end

        return Result
    end

    local Index = 1
    while Index <= LineCount do
        local EndIdx = math.min(LineCount, Index + LinesPerChunk - 1)
        local ChunkSrc = table.concat(Lines, "\n", Index, EndIdx)
        local Highlighted = HighlightSafe(ChunkSrc)
        while #Highlighted > MaxRich and EndIdx > Index do
            EndIdx = Index + math.max(1, math.floor((EndIdx - Index) / 2))
            ChunkSrc = table.concat(Lines, "\n", Index, EndIdx)
            Highlighted = HighlightSafe(ChunkSrc)
        end

        if #Highlighted > MaxRich then
            Highlighted = `{Highlighted:sub(1, MaxRich)}...`
        end
        MakeGutterLabel(Index, EndIdx)
        MakeCodeLabel(Highlighted)
        Index = EndIdx + 1
    end

    local function BringToFront()
        local MaxZ = 50
        for _, Item in self.ScriptViewerWindows do
            if Item.Window and Item.Window.Parent and Item ~= Entry then
                Item.Window.ZIndex = 50
                if Item.Window.ZIndex > MaxZ then
                    MaxZ = Item.Window.ZIndex
                end
            end
        end
        Window.ZIndex = MaxZ + 5
        Window.Parent = Window.Parent
    end

    Window.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch
        then
            BringToFront()
        end
    end)

    local Dragging = false
    local DragStart, StartPos
    TitleBar.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch
        then
            Dragging = true
            DragStart = Input.Position
            StartPos = Window.Position
            BringToFront()
        end
    end)

    Track(Services.UserInputService.InputChanged:Connect(function(Input)
        if not Dragging or not Window.Parent then
            return
        end

        if Input.UserInputType ~= Enum.UserInputType.MouseMovement
            and Input.UserInputType ~= Enum.UserInputType.Touch
        then
            return
        end

        local Delta = Input.Position - DragStart
        Window.Position = UDim2.new(
            StartPos.X.Scale, StartPos.X.Offset + Delta.X,
            StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y
        )
    end))

    Track(Services.UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch
        then
            Dragging = false
        end
    end))

    local MinW, MinH = 360, 220
    local EdgeThickness = 6

    local function MakeEdge(Position, Size, DirX, DirY)
        local Edge = VexUI:CreateInstance("Frame", {
            Position = Position;
            Size = Size;
            BackgroundTransparency = 1;
            ZIndex = 60;
            Active = true;
            Parent = Window;
        })

        local Resizing = false
        local StartInput, StartSize, StartPosition

        Edge.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1
                or Input.UserInputType == Enum.UserInputType.Touch
            then
                Resizing = true
                StartInput = Input.Position
                StartSize = Window.AbsoluteSize
                StartPosition = Window.Position
                BringToFront()
            end
        end)

        Track(Services.UserInputService.InputChanged:Connect(function(Input)
            if not Resizing or not Window.Parent then
                return
            end

            if Input.UserInputType ~= Enum.UserInputType.MouseMovement
                and Input.UserInputType ~= Enum.UserInputType.Touch
            then
                return
            end

            local Delta = Input.Position - StartInput
            local NewW = StartSize.X
            local NewH = StartSize.Y
            local NewX = StartPosition.X.Offset
            local NewY = StartPosition.Y.Offset

            if DirX == 1 then
                NewW = math.max(MinW, StartSize.X + Delta.X)
            elseif DirX == -1 then
                local Width = math.max(MinW, StartSize.X - Delta.X)
                NewX = StartPosition.X.Offset + (StartSize.X - Width)
                NewW = Width
            end

            if DirY == 1 then
                NewH = math.max(MinH, StartSize.Y + Delta.Y)
            elseif DirY == -1 then
                local Height = math.max(MinH, StartSize.Y - Delta.Y)
                NewY = StartPosition.Y.Offset + (StartSize.Y - Height)
                NewH = Height
            end

            Window.Size = UDim2.fromOffset(NewW, NewH)
            Window.Position = UDim2.new(StartPosition.X.Scale, NewX, StartPosition.Y.Scale, NewY)
        end))

        Track(Services.UserInputService.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1
                or Input.UserInputType == Enum.UserInputType.Touch
            then
                Resizing = false
            end
        end))
    end

    MakeEdge(UDim2.new(1, -EdgeThickness, 0, EdgeThickness), UDim2.new(0, EdgeThickness, 1, -EdgeThickness * 2), 1, 0)
    MakeEdge(UDim2.new(0, 0, 0, EdgeThickness), UDim2.new(0, EdgeThickness, 1, -EdgeThickness * 2), -1, 0)
    MakeEdge(UDim2.new(0, EdgeThickness, 1, -EdgeThickness), UDim2.new(1, -EdgeThickness * 2, 0, EdgeThickness), 0, 1)
    MakeEdge(UDim2.new(0, EdgeThickness, 0, 0), UDim2.new(1, -EdgeThickness * 2, 0, EdgeThickness), 0, -1)
    MakeEdge(UDim2.new(1, -EdgeThickness, 1, -EdgeThickness), UDim2.fromOffset(EdgeThickness, EdgeThickness), 1, 1)
    MakeEdge(UDim2.new(0, 0, 1, -EdgeThickness), UDim2.fromOffset(EdgeThickness, EdgeThickness), -1, 1)
    MakeEdge(UDim2.new(1, -EdgeThickness, 0, 0), UDim2.fromOffset(EdgeThickness, EdgeThickness), 1, -1)
    MakeEdge(UDim2.new(0, 0, 0, 0), UDim2.fromOffset(EdgeThickness, EdgeThickness), -1, -1)
end

function Explorer:ToggleConsole()
    local ConsoleWindow = self.ConsoleWindow

    if ConsoleWindow and ConsoleWindow.Parent then
        ConsoleWindow:Destroy()
        self.ConsoleWindow = nil

        if self.ConsoleConnection then
            pcall(function()
                self.ConsoleConnection:Disconnect()
            end)

            self.ConsoleConnection = nil
        end

        return
    end

    self:OpenConsole()
end

local MAX_CONSOLE_ENTRIES = 2000
local CONSOLE_DROP_BATCH = 500
function Explorer:_EnsureConsoleLog()
    if self._ConsoleLogReady then return end
    self._ConsoleLogReady = true

    self.ConsoleLog = self.ConsoleLog or {}
    self._ConsoleClearedAt = self._ConsoleClearedAt or 0
    self._ConsoleSubscribers = self._ConsoleSubscribers or {}

    local function Push(Text, MessageType)
        local Entry = {
            Text = tostring(Text),
            Type = MessageType,
            Time = os.clock(),
        }
        table.insert(self.ConsoleLog, Entry)

        if #self.ConsoleLog > MAX_CONSOLE_ENTRIES then
            for I = 1, CONSOLE_DROP_BATCH do
                table.remove(self.ConsoleLog, 1)
            end
        end

        for Sub in self._ConsoleSubscribers do
            pcall(Sub, Entry)
        end
    end

    self._ConsolePush = Push

    local LogService = GetService("LogService")
    pcall(function()
        for _, Entry in LogService:GetLogHistory() do
            Push(Entry.message, Entry.messageType)
        end
    end)

    Track(LogService.MessageOut:Connect(function(Message, MessageType)
        Push(Message, MessageType)
    end))
end

function Explorer:OpenConsole()
    self:_EnsureConsoleLog()

    local ConsoleWindow = VexUI:CreateWindow({
        Parent = self.ScreenGui;
        Title = "Console";
        Size = UDim2.fromOffset(620, 400);
        Position = UDim2.fromOffset(80, 80);
    })

    self.ConsoleWindow = ConsoleWindow.Frame

    ConsoleWindow:AddTitleButton("X", 26, true, function()
        self:ToggleConsole()
    end, "CloseIcon")

    local WindowBody = ConsoleWindow.Body

    local IsAutoScrollEnabled = true
    local ConsoleTextSize = 12

    local Filters = self._ConsoleFilters or {
        [Enum.MessageType.MessageOutput]  = true;
        [Enum.MessageType.MessageInfo]    = true;
        [Enum.MessageType.MessageWarning] = true;
        [Enum.MessageType.MessageError]   = true;
    }
    self._ConsoleFilters = Filters

    local LogLabels = {}
    local SubscriberFn

    local TopBar = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, -16, 0, 26);
        Position = UDim2.new(0, 8, 0, 6);
        BackgroundTransparency = 1;
        Parent = WindowBody;
    })

    local TopBarLayout = VexUI:AddListLayout(TopBar, 6, Enum.FillDirection.Horizontal)
    TopBarLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    local function CreateTopBarButton(ButtonText, Callback)
        local Button = VexUI:CreateInstance("TextButton", {
            Size = UDim2.new(0, 0, 1, 0);
            AutomaticSize = Enum.AutomaticSize.X;
            BackgroundColor3 = Theme.Field;
            BorderSizePixel = 0;
            AutoButtonColor = false;
            Font = Fonts.SemiBold;
            Text = ButtonText;
            TextColor3 = Theme.TextDim;
            TextSize = 12;
            Parent = TopBar;
        })
        VexUI:AddStroke(Button, "Border", 1)
        VexUI:AddPadding(Button, 0, 8, 0, 8)
        Button.MouseButton1Click:Connect(Callback)
        return Button
    end

    local AutoScrollButton
    local function UpdateAutoScrollButton()
        AutoScrollButton.Text = IsAutoScrollEnabled and "Auto-Scroll: ON" or "Auto-Scroll: OFF"
        AutoScrollButton.TextColor3 = IsAutoScrollEnabled and Theme.Green or Theme.TextDim
    end
    AutoScrollButton = CreateTopBarButton("Auto-Scroll: ON", function()
        IsAutoScrollEnabled = not IsAutoScrollEnabled
        UpdateAutoScrollButton()
    end)
    UpdateAutoScrollButton()

    local function ColorForType(MessageType)
        if MessageType == Enum.MessageType.MessageError then return Theme.Red end
        if MessageType == Enum.MessageType.MessageWarning then return Theme.Yellow end
        if MessageType == Enum.MessageType.MessageInfo then return Theme.Blue end
        return Theme.Text
    end

    local function EntryVisible(Entry)
        return Filters[Entry.Type] == true
    end

    local function RefreshVisibility()
        for Entry, Label in LogLabels do
            if Label.Parent then
                Label.Visible = EntryVisible(Entry)
            end
        end
    end

    local FilterButtons = {}
    local function MakeFilterButton(LabelText, MessageType)
        local Btn = CreateTopBarButton(LabelText, function()
            Filters[MessageType] = not Filters[MessageType]
            FilterButtons[MessageType].TextColor3 =
                Filters[MessageType] and ColorForType(MessageType) or Theme.TextFaded
            RefreshVisibility()
        end)
        Btn.TextColor3 = Filters[MessageType] and ColorForType(MessageType) or Theme.TextFaded
        FilterButtons[MessageType] = Btn
    end

    MakeFilterButton("Out",  Enum.MessageType.MessageOutput)
    MakeFilterButton("Info", Enum.MessageType.MessageInfo)
    MakeFilterButton("Warn", Enum.MessageType.MessageWarning)
    MakeFilterButton("Err",  Enum.MessageType.MessageError)

    local SizeLabel = VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(0, 60, 1, 0);
        BackgroundTransparency = 1;
        Font = Fonts.Mono;
        Text = `Size: {ConsoleTextSize}`;
        TextColor3 = Theme.TextDim;
        TextSize = 12;
        Parent = TopBar;
    })

    local function ApplyConsoleTextSize()
        for _, Label in LogLabels do
            if Label.Parent then
                Label.TextSize = ConsoleTextSize
            end
        end
        SizeLabel.Text = `Size: {ConsoleTextSize}`
    end

    CreateTopBarButton("-", function()
        ConsoleTextSize = math.max(8, ConsoleTextSize - 1)
        ApplyConsoleTextSize()
    end)

    CreateTopBarButton("+", function()
        ConsoleTextSize = math.min(24, ConsoleTextSize + 1)
        ApplyConsoleTextSize()
    end)

    CreateTopBarButton("Clear", function()
        table.clear(self.ConsoleLog)
        self._ConsoleClearedAt = os.clock()
        for _, Label in LogLabels do
            if Label.Parent then Label:Destroy() end
        end
        table.clear(LogLabels)
    end)

    local LogScrollFrame = VexUI:CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, -16, 1, -78);
        Position = UDim2.new(0, 8, 0, 38);
        BackgroundColor3 = Theme.Background;
        BorderSizePixel = 0;
        ScrollBarThickness = 4;
        ScrollBarImageColor3 = Theme.Border;
        CanvasSize = UDim2.new(0, 0, 0, 0);
        AutomaticCanvasSize = Enum.AutomaticSize.Y;
        ScrollingDirection = Enum.ScrollingDirection.Y;
        Parent = WindowBody;
    })
    VexUI:AddPadding(LogScrollFrame, 4, 6, 4, 6)
    VexUI:AddListLayout(LogScrollFrame, 1, Enum.FillDirection.Vertical)

    local function RenderEntry(Entry)
        local Label = VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0);
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundTransparency = 1;
            Font = Fonts.Mono;
            Text = Entry.Text;
            TextColor3 = ColorForType(Entry.Type);
            TextSize = ConsoleTextSize;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextWrapped = true;
            Visible = EntryVisible(Entry);
            Parent = LogScrollFrame;
        })
        LogLabels[Entry] = Label

        if IsAutoScrollEnabled and Label.Visible then
            task.defer(function()
                if LogScrollFrame.Parent then
                    LogScrollFrame.CanvasPosition =
                        Vector2.new(0, LogScrollFrame.AbsoluteCanvasSize.Y)
                end
            end)
        end
    end

    for _, Entry in self.ConsoleLog do
        if Entry.Time >= (self._ConsoleClearedAt or 0) then
            RenderEntry(Entry)
        end
    end

    SubscriberFn = function(Entry)
        if LogScrollFrame.Parent then
            RenderEntry(Entry)
        end
    end
    self._ConsoleSubscribers[SubscriberFn] = true

    ConsoleWindow.Frame.AncestryChanged:Connect(function(_, Parent)
        if Parent == nil then
            self._ConsoleSubscribers[SubscriberFn] = nil
        end
    end)

    local CommandRow = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, -16, 0, 28);
        Position = UDim2.new(0, 8, 1, -36);
        BackgroundTransparency = 1;
        Parent = WindowBody;
    })
    local CommandLayout = VexUI:AddListLayout(CommandRow, 6, Enum.FillDirection.Horizontal)
    CommandLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    local CommandBox = VexUI:CreateInstance("TextBox", {
        Size = UDim2.new(1, -76, 1, 0);
        BackgroundColor3 = Theme.Field;
        BorderSizePixel = 0;
        Font = Fonts.Mono;
        PlaceholderText = "Run code (loadstring)...";
        PlaceholderColor3 = Theme.TextFaded;
        Text = "";
        TextColor3 = Theme.Text;
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Left;
        ClearTextOnFocus = false;
        Parent = CommandRow;
    })
    VexUI:AddStroke(CommandBox, "Border", 1)
    VexUI:AddPadding(CommandBox, 0, 8, 0, 8)

    local RunButton = VexUI:CreateInstance("TextButton", {
        Size = UDim2.fromOffset(70, 28);
        BackgroundColor3 = Theme.Accent;
        BackgroundTransparency = 0.85;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Font = Fonts.SemiBold;
        Text = "Run";
        TextColor3 = Theme.Accent;
        TextSize = 12;
        Parent = CommandRow;
    })
    VexUI:AddStroke(RunButton, Theme.Accent, 1)

    local function PushSynthetic(Text, MessageType)
        self._ConsolePush(Text, MessageType or Enum.MessageType.MessageOutput)
    end

    local function FormatArgument(Value)
        local ValueType = typeof(Value)
        if ValueType == "string" then return Value end
        if ValueType == "Instance" then
            return `{Value.ClassName}({Value:GetFullName()})`
        end
        if ValueType == "table" then
            local Success, Encoded = pcall(function()
                return Services.HttpService:JSONEncode(Value)
            end)
            if Success then return Encoded end
            return tostring(Value)
        end
        return tostring(Value)
    end

    local function FormatArguments(...)
        local N = select("#", ...)
        if N == 0 then return "" end
        local Parts = {}
        for I = 1, N do Parts[I] = FormatArgument(select(I, ...)) end
        return table.concat(Parts, "  ")
    end

    local function ExecuteCommand()
        local Code = CommandBox.Text
        if Code == "" then return end

        PushSynthetic(`> {Code}`, Enum.MessageType.MessageInfo)

        local function CapturedPrint(...) PushSynthetic(FormatArguments(...), Enum.MessageType.MessageOutput) end
        local function CapturedWarn(...)  PushSynthetic(FormatArguments(...), Enum.MessageType.MessageWarning) end
        local function CapturedError(Message, Level)
            PushSynthetic(`error: {tostring(Message)}`, Enum.MessageType.MessageError)
            error(Message, (Level or 1) + 1)
        end

        local OriginalLoadstring = loadstring
        local function CapturedLoadstring(Source, ChunkName)
            if type(Source) ~= "string" then
                return nil, "loadstring: source must be a string"
            end
            local Injected = "local print, warn, error, loadstring = ...\n" .. Source
            local Fn, Err = OriginalLoadstring(Injected, ChunkName or "VexConsoleChunk")
            if not Fn then return nil, Err end
            return function(...)
                return Fn(CapturedPrint, CapturedWarn, CapturedError, CapturedLoadstring, ...)
            end
        end

        local IsExpression = Code:sub(1, 1) == "="
        local Body = IsExpression and ("return " .. Code:sub(2)) or Code

        local Fn, Err = CapturedLoadstring(Body, "VexConsole")
        if not Fn then
            PushSynthetic(`compile: {Err}`, Enum.MessageType.MessageError)
            return
        end

        local Results = table.pack(pcall(Fn))
        if not Results[1] then
            PushSynthetic(`runtime: {tostring(Results[2])}`, Enum.MessageType.MessageError)
            return
        end

        if IsExpression and Results.n > 1 then
            local Parts = {}
            for I = 2, Results.n do
                Parts[#Parts + 1] = FormatArgument(Results[I])
            end
            PushSynthetic(table.concat(Parts, "  "), Enum.MessageType.MessageOutput)
        end

        CommandBox.Text = ""
    end

    RunButton.MouseButton1Click:Connect(ExecuteCommand)
    CommandBox.FocusLost:Connect(function(EnterPressed)
        if EnterPressed then ExecuteCommand() end
    end)
end

function Explorer:SetThemePresetName(Name)
    self.ThemePresetName = Name or GetDefaultPresetName()

    if self.ThemePresetButton and self.ThemePresetButton.Parent then
        self.ThemePresetButton.Text = `{self.ThemePresetName}`
    end
end

function Explorer:OpenSettings()
    local Window, Body = self:CreateModalWindow("Settings", 460, 540)
    self.SettingsWindow = Window

    local Scroll = VexUI:CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0);
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        ScrollBarThickness = 3;
        ScrollBarImageColor3 = Theme.Border;
        CanvasSize = UDim2.new(0, 0, 0, 0);
        AutomaticCanvasSize = Enum.AutomaticSize.Y;
        ZIndex = 202;
        Parent = Body;
    })

    VexUI:BindThemeColor(Scroll, "ScrollBarImageColor3", "Border")
    VexUI:AddPadding(Scroll, 8, 16, 8, 12)
    VexUI:AddListLayout(Scroll, 6, Enum.FillDirection.Vertical)

    local function CreateRow(OrderIndex)
        return VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 30);
            BackgroundTransparency = 1;
            LayoutOrder = OrderIndex;
            ZIndex = 202;
            Parent = Scroll;
        })
    end

    local function CreateHeader(Text, OrderIndex)
        VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 18);
            BackgroundTransparency = 1;
            Font = Fonts.Bold;
            Text = Text:upper();
            TextColor3 = Theme.TextHeader;
            TextSize = 11;
            TextXAlignment = Enum.TextXAlignment.Left;
            LayoutOrder = OrderIndex;
            ZIndex = 202;
            Parent = Scroll;
        })
    end

    local function CreateToggle(LabelText, InitialState, OrderIndex, OnChange)
        local Row = CreateRow(OrderIndex)
        VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, -42, 1, 0);
            BackgroundTransparency = 1;
            Font = Fonts.Medium;
            Text = LabelText;
            TextColor3 = Theme.Text;
            TextSize = 12;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 203;
            Parent = Row;
        })

        local Switch = VexUI:CreateInstance("TextButton", {
            Size = UDim2.new(0, 32, 0, 16);
            Position = UDim2.new(1, -32, 0.5, -8);
            BackgroundColor3 = InitialState and Theme.Accent or Theme.ToggleOff;
            BorderSizePixel = 0;
            AutoButtonColor = false;
            Text = "";
            ZIndex = 203;
            Parent = Row;
        })
        
        VexUI:AddStroke(Switch, "Border", 1)

        local Knob = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(0, 12, 0, 12);
            Position = InitialState and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6);
            BackgroundColor3 = Color3.fromRGB(255, 255, 255);
            BorderSizePixel = 0;
            ZIndex = 204;
            Parent = Switch;
        })
        

        local State = InitialState
        Switch.MouseButton1Click:Connect(function()
            State = not State
            VexUI:Tween(Switch, {BackgroundColor3 = State and Theme.Accent or Theme.ToggleOff})
            VexUI:Tween(Knob, {Position = State and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)})
            OnChange(State)
        end)
    end

    local function CreateSlider(LabelText, MinValue, MaxValue, Step, InitialValue, OrderIndex, OnChange, FormatValueText)
        local function FormatSliderValue(Value)
            if FormatValueText then
                return FormatValueText(Value)
            end

            return string.format("%.1fs", Value)
        end

        local Row = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 36);
            BackgroundTransparency = 1;
            LayoutOrder = OrderIndex;
            ZIndex = 202;
            Parent = Scroll;
        })
        VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, -56, 0, 14);
            BackgroundTransparency = 1;
            Font = Fonts.Medium;
            Text = LabelText;
            TextColor3 = Theme.Text;
            TextSize = 12;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 203;
            Parent = Row;
        })

        local ValueLabel = VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(0, 52, 0, 14);
            Position = UDim2.new(1, -52, 0, 0);
            BackgroundTransparency = 1;
            Font = Fonts.Mono;
            Text = FormatSliderValue(InitialValue);
            TextColor3 = Theme.Accent;
            TextSize = 11;
            TextXAlignment = Enum.TextXAlignment.Right;
            ZIndex = 203;
            Parent = Row;
        })

        local TrackFrame = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 6);
            Position = UDim2.new(0, 0, 0, 22);
            BackgroundColor3 = Theme.Field;
            BorderSizePixel = 0;
            ZIndex = 203;
            Parent = Row;
        })
        

        local Fraction = (InitialValue - MinValue) / (MaxValue - MinValue)
        local Fill = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(Fraction, 0, 1, 0);
            BackgroundColor3 = Theme.Accent;
            BorderSizePixel = 0;
            ZIndex = 204;
            Parent = TrackFrame;
        })
        

        local HitArea = VexUI:CreateInstance("TextButton", {
            Size = UDim2.new(1, 0, 1, 0);
            BackgroundTransparency = 1;
            AutoButtonColor = false;
            Text = "";
            ZIndex = 205;
            Parent = TrackFrame;
        })

        local Dragging = false
        local function Update(InputX)
            local NewFraction = math.clamp(
                (InputX - TrackFrame.AbsolutePosition.X) / TrackFrame.AbsoluteSize.X,
                0, 1
            )
            local Raw = MinValue + NewFraction * (MaxValue - MinValue)
            local Snapped = math.floor(Raw / Step + 0.5) * Step
            Snapped = math.clamp(Snapped, MinValue, MaxValue)
            local SnappedFraction = (Snapped - MinValue) / (MaxValue - MinValue)
            Fill.Size = UDim2.new(SnappedFraction, 0, 1, 0)
            ValueLabel.Text = FormatSliderValue(Snapped)
            OnChange(Snapped)
        end

        HitArea.InputBegan:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
                Update(Input.Position.X)
            end
        end)
        Services.UserInputService.InputChanged:Connect(function(Input)
            if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
                Update(Input.Position.X)
            end
        end)
        Services.UserInputService.InputEnded:Connect(function(Input)
            if Input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = false
            end
        end)
    end

    local function CreateColorRow(LabelText, ThemeKey, OrderIndex)
        local Row = CreateRow(OrderIndex)
        VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, -56, 1, 0);
            BackgroundTransparency = 1;
            Font = Fonts.Medium;
            Text = LabelText;
            TextColor3 = Theme.Text;
            TextSize = 12;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 203;
            Parent = Row;
        })
        local Swatch = VexUI:CreateInstance("TextButton", {
            Size = UDim2.new(0, 44, 0, 18);
            Position = UDim2.new(1, -44, 0.5, -9);
            BackgroundColor3 = Theme[ThemeKey];
            BorderSizePixel = 0;
            AutoButtonColor = false;
            Text = "";
            ZIndex = 203;
            Parent = Row;
        })
        
        VexUI:AddStroke(Swatch, "Border", 1)
        BindTheme(ThemeKey, function(Color)
            Swatch.BackgroundColor3 = Color
        end)

        Swatch.MouseButton1Click:Connect(function()
            self:OpenColorPicker(Theme[ThemeKey], function(NewColor)
                SetThemeColor(ThemeKey, NewColor)

                if self.SelectedInstance then
                    self:RenderProperties(self.SelectedInstance)
                end
            end, {
                Floating = true;
                AnchorWindow = self.SettingsWindow;
            })
        end)
    end

    CreateHeader("Behavior", 1)

    local KeyRow = CreateRow(2)
    VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0);
        BackgroundTransparency = 1;
        Font = Fonts.Medium;
        Text = "Toggle Keybind";
        TextColor3 = Theme.Text;
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = 203;
        Parent = KeyRow;
    })
    local KeyButton = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(0, 94, 0, 22);
        Position = UDim2.new(1, -94, 0.5, -11);
        BackgroundColor3 = Theme.Field;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Font = Fonts.Mono;
        Text = self.ToggleKey.Name;
        TextColor3 = Theme.Text;
        TextSize = 11;
        ZIndex = 203;
        Parent = KeyRow;
    })
    
    VexUI:AddStroke(KeyButton, "Border", 1)

    local Listening = false
    KeyButton.MouseButton1Click:Connect(function()
        Listening = true
        KeyButton.Text = "[ press a key... ]"
        KeyButton.TextColor3 = Theme.Accent
    end)

    Track(Services.UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if not Listening or GameProcessed then
            return
        end

        if Input.UserInputType ~= Enum.UserInputType.Keyboard then
            return
        end

        if Input.KeyCode == Enum.KeyCode.Unknown then
            return
        end

        Listening = false
        KeyButton.Text = Input.KeyCode.Name
        KeyButton.TextColor3 = Theme.Text

        task.defer(function()
            self.ToggleKey = Input.KeyCode
            self:SaveConfig()
            task.wait()
        end)
    end))

    CreateToggle("Auto-Refresh Properties", self.AutoRefreshProperties, 3, function(State)
        self.AutoRefreshProperties = State
        self:SaveConfig()
    end)

    CreateSlider("Refresh Delay", 0, 3, 0.1, self.RefreshDelay, 4, function(Value)
        self.RefreshDelay = Value
        self:SaveConfig()
    end)

    CreateToggle("Use lua.expert decompiler", self.UseLuaExpertDecompiler, 4.5, function(State)
        self.UseLuaExpertDecompiler = State
        self:SaveConfig()
    end)

    CreateHeader("Performance", 4.7)

    CreateToggle("Unlimited FPS", self.UnlimitedFPS, 4.8, function(State)
        local Good, Err = ApplyFPSCap(State)
        if not Good then
            self:Notify(`Couldn't change FPS cap: {Err}`)
            return
        end

        self.UnlimitedFPS = State
        self:SaveConfig()
    end)

    CreateHeader("Theme Preset", 5)

    local PresetRow = CreateRow(6)
    VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(0, 60, 1, 0);
        BackgroundTransparency = 1;
        Font = Fonts.Medium;
        Text = "Preset";
        TextColor3 = Theme.Text;
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = 203;
        Parent = PresetRow;
    })
    local PresetButton = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(1, -60, 0, 22);
        Position = UDim2.new(0, 60, 0.5, -11);
        BackgroundColor3 = Theme.Field;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Font = Fonts.Mono;
        Text = `{self.ThemePresetName or Presets[1].Name}`;
        TextColor3 = Theme.Accent;
        TextSize = 11;
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = 203;
        Parent = PresetRow;
    })
    
    self.ThemePresetButton = PresetButton
    VexUI:AddStroke(PresetButton, "Border", 1)
    VexUI:AddPadding(PresetButton, 0, 8, 0, 8)

    PresetButton.MouseButton1Click:Connect(function()
        self:OpenListModal("UI Presets", Presets,
            function(Preset)
                return Preset.Name
            end,
            function(Preset)
                ApplyPreset(Preset)
                self:CloseModal()
                self:OpenSettings()

                self.ThemePresetName = Preset.Name

                if self.ThemePresetButton and self.ThemePresetButton.Parent then
                    self.ThemePresetButton.Text = `{Preset.Name}`
                end

                PresetButton.Text = `{Preset.Name}`

                if self.SaveConfig then
                    self:SaveConfig()
                end

                if self.SelectedInstance then
                    self:RenderProperties(self.SelectedInstance)
                end
            end,
            false,
            nil,
            nil,
            {
                Floating = true;
                AnchorWindow = self.SettingsWindow;
                Width = 320;
                Height = 360;
            }
        )
    end)

    CreateHeader("Class Icons", 6.5)

    local ClassIconRow = CreateRow(6.6)
    VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(0, 60, 1, 0);
        BackgroundTransparency = 1;
        Font = Fonts.Medium;
        Text = "Theme";
        TextColor3 = Theme.Text;
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = 203;
        Parent = ClassIconRow;
    })

    local ClassIconButton = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(1, -60, 0, 22);
        Position = UDim2.new(0, 60, 0.5, -11);
        BackgroundColor3 = Theme.Field;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Font = Fonts.Mono;
        Text = self.ClassIcon or "NewDark";
        TextColor3 = Theme.Accent;
        TextSize = 11;
        TextXAlignment = Enum.TextXAlignment.Left;
        ZIndex = 203;
        Parent = ClassIconRow;
    })

    self.ClassIconButton = ClassIconButton
    VexUI:AddStroke(ClassIconButton, "Border", 1)
    VexUI:AddPadding(ClassIconButton, 0, 8, 0, 8)

    ClassIconButton.MouseButton1Click:Connect(function()
        local Options = {}
        for _, Name in ClassIconThemes do
            table.insert(Options, {Name = Name})
        end

        self:OpenListModal("Class Icons", Options,
            function(Item)
                return Item.Name
            end,
            function(Item)
                self:SetClassIconTheme(Item.Name)
                self:CloseModal()
                self:OpenSettings()

                if self.ClassIconButton and self.ClassIconButton.Parent then
                    self.ClassIconButton.Text = Item.Name
                end

                ClassIconButton.Text = Item.Name
            end,
            false,
            nil,
            nil,
            {
                Floating = true;
                AnchorWindow = self.SettingsWindow;
                Width = 280;
                Height = 220;
            }
        )
    end)

    CreateHeader("UI Transparency", 7)

    local function Percent(Value)
        return `{math.floor(Value * 100 + 0.5)}%`
    end

    CreateSlider("Window Transparency", 0, 0.85, 0.05, UITransparency.Window, 8, function(Value)
        SetUITransparency("Window", Value)
        self:SaveConfig()
    end, Percent)

    CreateSlider("Title Bar Transparency", 0, 0.85, 0.05, UITransparency.TitleBar, 8.1, function(Value)
        SetUITransparency("TitleBar", Value)
        self:SaveConfig()
    end, Percent)

    CreateSlider("Field Transparency", 0, 0.85, 0.05, UITransparency.Field, 8.2, function(Value)
        SetUITransparency("Field", Value)
        self:SaveConfig()
    end, Percent)

    CreateSlider("Background Transparency", 0, 0.85, 0.05, UITransparency.Background, 8.3, function(Value)
        SetUITransparency("Background", Value)
        self:SaveConfig()
    end, Percent)

    CreateSlider("Modal Overlay", 0, 0.95, 0.05, UITransparency.ModalOverlay, 8.4, function(Value)
        SetUITransparency("ModalOverlay", Value)
        self:SaveConfig()
    end, Percent)

    local ColorSections = {
        {
            Header = "Surfaces",
            BaseOrder = 10,
            Rows = {
                {
                    "Main Background",
                    "Background"
                },
                {
                    "Window Background",
                    "Window"
                },
                {
                    "Title Bar Background",
                    "TitleBar"
                },
                {
                    "Input / Button Background",
                    "Field"
                },
                {
                    "Input / Button Hover",
                    "FieldHover"
                },
            },
        },
        {
            Header = "Borders & Selection",
            BaseOrder = 11,
            Rows = {
                {
                    "Border (Strong)",
                    "Border"
                },
                {
                    "Border (Subtle)",
                    "BorderSoft"
                },
                {
                    "Selected Row Background",
                    "Selected"
                },
                {
                    "Selected Row Accent Bar",
                    "SelectionBar"
                },
            },
        },
        {
            Header = "Text",
            BaseOrder = 12,
            Rows = {
                {
                    "Text (Primary)",
                    "Text"
                },
                {
                    "Text (Dim)",
                    "TextDim"
                },
                {
                    "Text (Faded / Placeholder)",
                    "TextFaded"
                },
                {
                    "Text (Section Header)",
                    "TextHeader"
                },
            },
        },
        {
            Header = "Accents & Status",
            BaseOrder = 13,
            Rows = {
                {
                    "Accent (Highlights)",
                    "Accent"
                },
                {
                    "Toggle: On",
                    "ToggleOn"
                },
                {
                    "Toggle: Off",
                    "ToggleOff"
                },
                {
                    "Status: Success",
                    "Green"
                },
                {
                    "Status: Error",
                    "Red"
                },
                {
                    "Status: Warning",
                    "Yellow"
                },
                {
                    "Status: Info",
                    "Blue"
                },
            },
        },
        {
            Header = "Property Value Colors",
            BaseOrder = 14,
            Rows = {
                {
                    "Property: String",
                    "PropString"
                },
                {
                    "Property: Number",
                    "PropNumber"
                },
                {
                    "Property: Instance",
                    "PropInstance"
                },
                {
                    "Property: Enum",
                    "PropEnum"
                },
                {
                    "Property: Nil",
                    "PropNil"
                },
                {
                    "Property: Default",
                    "PropDefault"
                },
            },
        },
    }

    for SectionIdx, Section in ColorSections do
        local SectionBase = Section.BaseOrder * 10
        CreateHeader(Section.Header, SectionBase)
        for RowIdx, RowDef in Section.Rows do
            CreateColorRow(RowDef[1], RowDef[2], SectionBase + RowIdx * 0.1)
        end
    end

    local ResetColorsRow = CreateRow(150)
    local ResetColorsButton = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 0, 24);
        BackgroundColor3 = Theme.Field;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Font = Fonts.Medium;
        Text = "Reset Colors to Default";
        TextColor3 = Theme.TextDim;
        TextSize = 12;
        ZIndex = 203;
        Parent = ResetColorsRow;
    })
    VexUI:AddStroke(ResetColorsButton, "Border", 1)

    ResetColorsButton.MouseEnter:Connect(function()
        VexUI:Tween(ResetColorsButton, {TextColor3 = Theme.Text})
    end)
    ResetColorsButton.MouseLeave:Connect(function()
        VexUI:Tween(ResetColorsButton, {TextColor3 = Theme.TextDim})
    end)

    ResetColorsButton.MouseButton1Click:Connect(function()
        local TargetPreset
        if self.ThemePresetName then
            for _, Preset in Presets do
                if Preset.Name == self.ThemePresetName then
                    TargetPreset = Preset
                    break
                end
            end
        end

        if TargetPreset then
            ApplyPreset(TargetPreset)
        else
            InBatchSave = true
            for Key, DefaultColor in DefaultTheme do
                if Theme[Key] ~= DefaultColor then
                    SetThemeColor(Key, DefaultColor)
                end
            end
            InBatchSave = false
        end

        if self.SaveConfig then self:SaveConfig() end
        if self.SelectedInstance then self:RenderProperties(self.SelectedInstance) end

        self:CloseModal()
        self:OpenSettings()
    end)

    CreateHeader("Fonts", 30)

    local FontRoles = {
        {Key = "Bold",     Label = "Bold"},
        {Key = "SemiBold", Label = "Semi-Bold"},
        {Key = "Medium",   Label = "Medium"},
        {Key = "Regular",  Label = "Regular"},
        {Key = "Mono",     Label = "Mono"},
        {Key = "Code",     Label = "Code"},
        {Key = "Heading",  Label = "Heading"},
    }

    local AllFonts = {}
    for _, FontEnum in Enum.Font:GetEnumItems() do
        if FontEnum ~= Enum.Font.Unknown then
            AllFonts[#AllFonts + 1] = FontEnum
        end
    end
    table.sort(AllFonts, function(A, B) return A.Name < B.Name end)

    local function CreateFontRow(RoleKey, RoleLabel, OrderIndex)
        local Row = CreateRow(OrderIndex)
        VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(0.4, 0, 1, 0);
            BackgroundTransparency = 1;
            Font = Fonts.Medium;
            Text = RoleLabel;
            TextColor3 = Theme.Text;
            TextSize = 12;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 203;
            Parent = Row;
        })

        local Button = VexUI:CreateInstance("TextButton", {
            Size = UDim2.new(0.6, -4, 0, 22);
            Position = UDim2.new(0.4, 4, 0.5, -11);
            BackgroundColor3 = Theme.Field;
            BorderSizePixel = 0;
            AutoButtonColor = false;
            Font = Fonts[RoleKey];
            Text = Fonts[RoleKey].Name;
            TextColor3 = Theme.Accent;
            TextSize = 11;
            ZIndex = 203;
            Parent = Row;
        })
        VexUI:AddStroke(Button, "Border", 1)
        VexUI:AddPadding(Button, 0, 8, 0, 8)

        Button.MouseButton1Click:Connect(function()
            self:OpenListModal("Select Font", AllFonts,
                function(FontEnum) return FontEnum.Name end,
                function(FontEnum)
                    local Old = Fonts[RoleKey]
                    Fonts[RoleKey] = FontEnum
                    RebindFont(Old, FontEnum)
                    Button.Text = FontEnum.Name
                    Button.Font = FontEnum
                    self:CloseModal()
                    if self.SaveConfig then self:SaveConfig() end
                end,
                true,
                nil,
                function(FontEnum) return FontEnum.Name end,
                {
                    Floating = true;
                    AnchorWindow = self.SettingsWindow;
                    Width = 280;
                    Height = 360;
                }
            )
        end)
    end

    for I, Role in FontRoles do
        CreateFontRow(Role.Key, Role.Label, 30 + I * 0.1)
    end

    local ResetRow = CreateRow(30 + (#FontRoles + 1) * 0.1)
    local ResetButton = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 0, 24);
        BackgroundColor3 = Theme.Field;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Font = Fonts.Medium;
        Text = "Reset Fonts to Default";
        TextColor3 = Theme.TextDim;
        TextSize = 12;
        ZIndex = 203;
        Parent = ResetRow;
    })
    VexUI:AddStroke(ResetButton, "Border", 1)

    ResetButton.MouseEnter:Connect(function()
        VexUI:Tween(ResetButton, {TextColor3 = Theme.Text})
    end)
    ResetButton.MouseLeave:Connect(function()
        VexUI:Tween(ResetButton, {TextColor3 = Theme.TextDim})
    end)

    ResetButton.MouseButton1Click:Connect(function()
        for K, DefaultEnum in DefaultFonts do
            local Old = Fonts[K]
            if Old ~= DefaultEnum then
                Fonts[K] = DefaultEnum
                RebindFont(Old, DefaultEnum)
            end
        end
        if self.SaveConfig then self:SaveConfig() end
        self:CloseModal()
        self:OpenSettings()
    end)
end

function Explorer:FormatFilterValue(Value)
    local Kind = typeof(Value)
    if Kind == "string" then
        return `"{Value}"`
    elseif Kind == "EnumItem" then
        return tostring(Value)
    elseif Kind == "Instance" then
        return `<{Value.ClassName}> {Value.Name}`
    elseif Kind == "Color3" then
        return `Color3({math.floor(Value.R * 255)}, {math.floor(Value.G * 255)}, {math.floor(Value.B * 255)})`
    elseif Kind == "Vector3" or Kind == "Vector2" or Kind == "UDim2" or Kind == "UDim" or Kind == "CFrame" then
        return tostring(Value)
    elseif Kind == "boolean" or Kind == "number" then
        return tostring(Value)
    end

    return `<{Kind}>`
end

function Explorer:OpenFiltersDropdown(AnchorButton)
    if self.FiltersDropdown then
        self.FiltersDropdown:Destroy()

        if self.FiltersBlocker then
            self.FiltersBlocker:Destroy()
        end

        self.FiltersDropdown = nil
        self.FiltersBlocker = nil

        return
    end

    local Blocker = VexUI:CreateInstance("Frame", {
        Size = UDim2.fromScale(1, 1);
        BackgroundTransparency = 1;
        ZIndex = 150;
        Parent = self.ScreenGui;
    })
    local FiltersClickConn

    local Camera = workspace.CurrentCamera
    local Viewport = Camera and Camera.ViewportSize or Vector2.new(1366, 768)
    local Width = 320
    
    local AnchorFrame = self.ExplorerWindow and self.ExplorerWindow.Frame
    local AnchorX, AnchorY, Height

    if AnchorFrame then
        local AbsX = AnchorFrame.AbsolutePosition.X
        local AbsW = AnchorFrame.AbsoluteSize.X
        local AbsH = AnchorFrame.AbsoluteSize.Y
        local OffsetY = AnchorFrame.Position.Y.Offset

        local SpaceRight = Viewport.X - (AbsX + AbsW)
        local SpaceLeft = AbsX

        if SpaceRight >= Width + 4 then
            AnchorX = AbsX + AbsW + 4
        elseif SpaceLeft >= Width + 4 then
            AnchorX = AbsX - Width - 4
        else
            AnchorX = math.max(0, Viewport.X - Width)
        end

        AnchorY = OffsetY
        Height = AbsH
    else
        AnchorX = AnchorButton.AbsolutePosition.X
        AnchorY = AnchorButton.AbsolutePosition.Y + AnchorButton.AbsoluteSize.Y + 4
        Height = 420
    end

    local Window = VexUI:CreateWindow({
        Parent = self.ScreenGui;
        Title = "Filters";
        BackgroundTransparency = 1;
        Size = UDim2.fromOffset(Width, Height);
        Position = UDim2.fromOffset(AnchorX, AnchorY);
    })

    local Dropdown = Window.Frame
    Dropdown.ZIndex = 151

    for _, Descendant in WeakGetDescendants(Dropdown) do
        if Descendant:IsA("GuiObject") then
            Descendant.ZIndex = Descendant.ZIndex + 150
        end
    end

    local function Close()
        if FiltersClickConn then
            FiltersClickConn:Disconnect()
            FiltersClickConn = nil
        end

        Dropdown:Destroy()
        Blocker:Destroy()

        if self.FiltersDropdown == Dropdown then
            self.FiltersDropdown = nil
            self.FiltersBlocker = nil
        end
    end

    FiltersClickConn = Services.UserInputService.InputBegan:Connect(function(Input)
        if Input.UserInputType ~= Enum.UserInputType.MouseButton1
            and Input.UserInputType ~= Enum.UserInputType.MouseButton2
            and Input.UserInputType ~= Enum.UserInputType.Touch
        then
            return
        end

        if not Dropdown or not Dropdown.Parent then
            Close()
            return
        end

        local Pos = Input.Position
        local AbsP = Dropdown.AbsolutePosition
        local AbsS = Dropdown.AbsoluteSize
        if Pos.X >= AbsP.X and Pos.X <= AbsP.X + AbsS.X
            and Pos.Y >= AbsP.Y and Pos.Y <= AbsP.Y + AbsS.Y
        then
            return
        end

        Close()
    end)

    Window:AddTitleButton("X", 26, true, Close, "CloseIcon")

    local Scroll = VexUI:CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, -16, 1, -16);
        Position = UDim2.new(0, 8, 0, 8);
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        ScrollBarThickness = 4;
        ScrollBarImageColor3 = Color3.fromRGB(40, 40, 40);
        ScrollBarImageTransparency = 0.2;
        CanvasSize = UDim2.new(0, 0, 0, 0);
        AutomaticCanvasSize = Enum.AutomaticSize.Y;
        ZIndex = 302;
        Parent = Window.Body;
    })
    VexUI:AddListLayout(Scroll, 8, Enum.FillDirection.Vertical)
    VexUI:AddPadding(Scroll, 0, 8, 0, 0)

    self._FilterRowRefreshers = {}

    local function CreateSection(Title, OrderIndex, BuildContent)
        local Section = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 0);
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundTransparency = 1;
            LayoutOrder = OrderIndex;
            ZIndex = 152;
            Parent = Scroll;
        })
        VexUI:AddListLayout(Section, 6, Enum.FillDirection.Vertical)
        VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 16);
            BackgroundTransparency = 1;
            Font = Fonts.Bold;
            Text = Title;
            TextColor3 = Theme.Accent;
            TextSize = 11;
            TextXAlignment = Enum.TextXAlignment.Left;
            LayoutOrder = 1;
            ZIndex = 152;
            Parent = Section;
        })
        local Content = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 0);
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundTransparency = 1;
            LayoutOrder = 2;
            ZIndex = 152;
            Parent = Section;
        })
        BuildContent(Content)
    end

    local function CreateToggleRow(Parent, LabelText, FullWidth, OrderIndex, IconClassName, IsOn, OnClick)
        local Row = VexUI:CreateInstance("TextButton", {
            Size = FullWidth and UDim2.new(1, 0, 0, 22) or UDim2.new(1, 0, 1, 0);
            BackgroundColor3 = Theme.Selected;
            BackgroundTransparency = 0.7;
            BorderSizePixel = 0;
            AutoButtonColor = false;
            Text = "";
            LayoutOrder = OrderIndex or 0;
            ZIndex = 152;
            Parent = Parent;
        })
        
        VexUI:AddPadding(Row, 0, 6, 0, 6)

        local Check = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(0, 12, 0, 12);
            Position = UDim2.new(0, 0, 0.5, -6);
            BackgroundColor3 = IsOn() and Theme.Accent or Theme.Border;
            BorderSizePixel = 0;
            ZIndex = 153;
            Parent = Row;
        })
        

        local LabelOffsetX = 18
        if IconClassName then
            local Icon = VexUI:CreateClassIcon(IconClassName, Row)
            Icon.Size = UDim2.new(0, 14, 0, 14)
            Icon.Position = UDim2.new(0, 18, 0.5, -7)
            Icon.ZIndex = 153
            LabelOffsetX = 36
        end

        VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, -(LabelOffsetX + 2), 1, 0);
            Position = UDim2.new(0, LabelOffsetX, 0, 0);
            BackgroundTransparency = 1;
            Font = Fonts.Medium;
            Text = LabelText;
            TextColor3 = Theme.Text;
            TextSize = 11;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextTruncate = Enum.TextTruncate.AtEnd;
            ZIndex = 153;
            Parent = Row;
        })

        local function Refresh()
            Check.BackgroundColor3 = IsOn() and Theme.Accent or Theme.Border
        end

        Row.MouseButton1Click:Connect(function()
            OnClick()
            Refresh()
        end)

        Row.MouseEnter:Connect(function()
            VexUI:Tween(Row, {BackgroundTransparency = 0.4})
        end)

        Row.MouseLeave:Connect(function()
            VexUI:Tween(Row, {BackgroundTransparency = 0.7})
        end)

        table.insert(self._FilterRowRefreshers, function()
            if Row.Parent then
                Refresh()
            end
        end)
    end

    CreateSection("Nil Instances", 1, function(Container)
        local Inner = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 0);
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundTransparency = 1;
            ZIndex = 152;
            Parent = Container;
        })
        VexUI:AddListLayout(Inner, 4, Enum.FillDirection.Vertical)

        CreateToggleRow(Inner, "Show Nil Instances Folder", true, 1, nil,
            function()
                return not self.HideNilContainer
            end,
            function()
                self:ToggleNilContainerFilter()
            end
        )

        CreateToggleRow(Inner, "Search Nil Instances", true, 2, nil,
            function()
                return self.SearchIncludesNil == true
            end,
            function()
                self.SearchIncludesNil = not self.SearchIncludesNil
                self._FilterChangedSinceLastSearch = true
                self:SaveConfig()

                if self.SearchQuery ~= "" then
                    self:RefreshAllSearchFilters()
                end
            end
        )

        local ClassBox = VexUI:CreateInstance("TextBox", {
            Size = UDim2.new(1, 0, 0, 22);
            BackgroundColor3 = Theme.Field;
            BorderSizePixel = 0;
            Font = Fonts.Mono;
            PlaceholderText = "Filter by ClassName...";
            PlaceholderColor3 = Theme.TextFaded;
            Text = (self.NilFilterClass or ""):gsub("^%s+", ""):gsub("%s+$", "");
            TextColor3 = Theme.Text;
            TextSize = 11;
            TextXAlignment = Enum.TextXAlignment.Left;
            ClearTextOnFocus = false;
            LayoutOrder = 3;
            ZIndex = 153;
            Parent = Inner;
        })
        
        VexUI:AddStroke(ClassBox, "Border", 1)
        VexUI:AddPadding(ClassBox, 0, 6, 0, 6)
        self.FiltersClassFilterBox = ClassBox

        ClassBox:GetPropertyChangedSignal("Text"):Connect(function()
            if self._SyncingClassFilter then
                return
            end

            self:SetNilFilterClass(ClassBox.Text, ClassBox)
            self:SaveConfig()
        end)
    end)

    CreateSection("Freeze Search", 2, function(Container)
        self:InitFreezeState()

        if self.FreezeSearchMatchClass == nil then
            self.FreezeSearchMatchClass = false
        end

        local Inner = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 0);
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundTransparency = 1;
            ZIndex = 152;
            Parent = Container;
        })
        VexUI:AddListLayout(Inner, 4, Enum.FillDirection.Vertical)

        local Hint = VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 28);
            BackgroundTransparency = 1;
            Font = Fonts.Medium;
            Text = "Freezes the explorer when a descendant whose name (or ClassName) matches this term is added.";
            TextColor3 = Theme.TextFaded;
            TextSize = 10;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextYAlignment = Enum.TextYAlignment.Top;
            TextWrapped = true;
            LayoutOrder = 1;
            ZIndex = 153;
            Parent = Inner;
        })
        BindTheme("TextFaded", function(Color)
            if Hint and Hint.Parent then Hint.TextColor3 = Color end
        end)

        local Box = VexUI:CreateInstance("TextBox", {
            Size = UDim2.new(1, 0, 0, 22);
            BackgroundColor3 = Theme.Field;
            BorderSizePixel = 0;
            Font = Fonts.Mono;
            PlaceholderText = self.FreezeSearchMatchClass
                and "e.g. MeshPart"
                or  "e.g. SkibidiPartMesh";
            PlaceholderColor3 = Theme.TextFaded;
            Text = self.FreezeSearchTerm or "";
            TextColor3 = Theme.Text;
            TextSize = 11;
            TextXAlignment = Enum.TextXAlignment.Left;
            ClearTextOnFocus = false;
            LayoutOrder = 2;
            ZIndex = 153;
            Parent = Inner;
        })
        VexUI:AddStroke(Box, "Border", 1)
        VexUI:AddPadding(Box, 0, 6, 0, 6)
        BindTheme("Field", function(C) if Box.Parent then Box.BackgroundColor3 = C end end)
        BindTheme("Text",  function(C) if Box.Parent then Box.TextColor3 = C end end)
        BindTheme("TextFaded", function(C) if Box.Parent then Box.PlaceholderColor3 = C end end)

        self.FreezeSearchBox = Box

        Box.FocusLost:Connect(function()
            self:SetFreezeSearchTerm(Box.Text)
        end)

        CreateToggleRow(Inner, "Match by ClassName (instead of Name)", true, 3, nil,
            function()
                return self.FreezeSearchMatchClass == true
            end,
            function()
                self.FreezeSearchMatchClass = not self.FreezeSearchMatchClass

                if self.FreezeSearchBox and self.FreezeSearchBox.Parent then
                    self.FreezeSearchBox.PlaceholderText = self.FreezeSearchMatchClass
                        and "e.g. MeshPart"
                        or  "e.g. SkibidiPartMesh"
                end

                if self.FreezeSearchTerm and self.FreezeSearchTerm ~= "" then
                    if self._StopFreezeSearchWatcher then
                        pcall(function() self:_StopFreezeSearchWatcher() end)
                    end
                    if self._StartFreezeSearchWatcher then
                        pcall(function() self:_StartFreezeSearchWatcher() end)
                    end
                end

                pcall(function() self:SaveConfig() end)
            end
        )

        local Row = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 24);
            BackgroundTransparency = 1;
            LayoutOrder = 4;
            ZIndex = 152;
            Parent = Inner;
        })

        local Status = VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, -120, 1, 0);
            BackgroundTransparency = 1;
            Font = Fonts.SemiBold;
            Text = self.ExplorerFrozen and "Status: FROZEN" or "Status: live";
            TextColor3 = self.ExplorerFrozen and Theme.Accent or Theme.TextDim;
            TextSize = 11;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 153;
            Parent = Row;
        })

        local Toggle = VexUI:CreateInstance("TextButton", {
            Size = UDim2.new(0, 110, 1, 0);
            Position = UDim2.new(1, -110, 0, 0);
            BackgroundColor3 = Theme.Field;
            BorderSizePixel = 0;
            AutoButtonColor = false;
            Font = Fonts.SemiBold;
            Text = self.ExplorerFrozen and "Unfreeze" or "Freeze Now";
            TextColor3 = Theme.Text;
            TextSize = 11;
            ZIndex = 153;
            Parent = Row;
        })
        VexUI:AddStroke(Toggle, "Border", 1)

        local function Refresh()
            if not Status.Parent then return end
            Status.Text = self.ExplorerFrozen and "Status: FROZEN" or "Status: live"
            Status.TextColor3 = self.ExplorerFrozen and Theme.Accent or Theme.TextDim
            Toggle.Text = self.ExplorerFrozen and "Unfreeze" or "Freeze Now"
        end

        Toggle.MouseButton1Click:Connect(function()
            self:ToggleExplorerFreeze()
            Refresh()
        end)

        self._FreezeUiRefreshers = self._FreezeUiRefreshers or {}
        table.insert(self._FreezeUiRefreshers, Refresh)
    end)

    CreateSection("Search Behaviour", 3, function(Container)
        local Inner = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 0);
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundTransparency = 1;
            ZIndex = 152;
            Parent = Container;
        })
        VexUI:AddListLayout(Inner, 4, Enum.FillDirection.Vertical)

        CreateToggleRow(Inner, "Match by ClassName", true, 1, nil,
            function()
                return self.MatchByClassName == true
            end,
            function()
                self:ToggleMatchByClassName()
            end
        )

        CreateToggleRow(Inner, "Match by Property (use Prop=Value syntax)", true, 2, nil,
            function()
                return self.MatchByProperty == true
            end,
            function()
                self:ToggleMatchByProperty()
            end
        )

        CreateToggleRow(Inner, "Show only matches (flat list)", true, 3, nil,
            function()
                return self.FlatSearchResults == true
            end,
            function()
                self.FlatSearchResults = not self.FlatSearchResults
                self:SaveConfig()

                if self.SearchQuery ~= "" then
                    self:RefreshAllSearchFilters()
                end
            end
        )

        local Hint = VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 14);
            BackgroundTransparency = 1;
            Font = Fonts.Medium;
            Text = "Examples: WalkSpeed>10  Anchored=true  Name~Dio";
            TextColor3 = Theme.TextFaded;
            TextSize = 10;
            TextXAlignment = Enum.TextXAlignment.Left;
            LayoutOrder = 3;
            ZIndex = 153;
            Parent = Inner;
        })
        BindTheme("TextFaded", function(Color)
            if Hint and Hint.Parent then Hint.TextColor3 = Color end
        end)
    end)

    CreateSection("Search - ClassName Filter", 4, function(Container)
        local Grid = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 0);
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundTransparency = 1;
            ZIndex = 152;
            Parent = Container;
        })
        VexUI:CreateInstance("UIGridLayout", {
            CellSize = UDim2.new(0.5, -2, 0, 22);
            CellPadding = UDim2.new(0, 4, 0, 2);
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = Grid;
        })
        for Index, ClassName in self.FilterClassOptions do
            CreateToggleRow(Grid, ClassName, false, Index, ClassName,
                function()
                    return self.ActiveClassFilters[ClassName] == true
                end,
                function()
                    self:ToggleClassFilter(ClassName)
                end
            )
        end
    end)

    CreateSection("Hidden Services", 5, function(Container)
        local Inner = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 0);
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundTransparency = 1;
            ZIndex = 152;
            Parent = Container;
        })
        VexUI:AddListLayout(Inner, 4, Enum.FillDirection.Vertical)

        CreateToggleRow(Inner, "Hide All Services", true, 1, nil,
            function()
                return self.AllServicesHidden
            end,
            function()
                self:ToggleAllServicesHidden()
            end
        )

        local ServiceList = {}
        for _, Service in WeakGetChildren(game) do
            table.insert(ServiceList, {Name = Service.Name; ClassName = Service.ClassName})
        end

        for ServiceName in self.HiddenServices do
            local Found = false
            for _, Service in ServiceList do
                if Service.Name == ServiceName then
                    Found = true
                    
                    break
                end
            end

            if not Found then
                table.insert(ServiceList, {Name = ServiceName; ClassName = "Folder"})
            end
        end
        table.sort(ServiceList, function(Left, Right)
            return Left.Name:lower() < Right.Name:lower()
        end)

        local Grid = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 0);
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundTransparency = 1;
            LayoutOrder = 2;
            ZIndex = 152;
            Parent = Inner;
        })
        VexUI:CreateInstance("UIGridLayout", {
            CellSize = UDim2.new(0.5, -2, 0, 22);
            CellPadding = UDim2.new(0, 4, 0, 2);
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = Grid;
        })

        for Index, Service in ServiceList do
            local ServiceName = Service.Name
            CreateToggleRow(Grid, ServiceName, false, Index, Service.ClassName,
                function()
                    return self.HiddenServices[ServiceName] == true
                end,
                function()
                    self:ToggleServiceFilter(ServiceName)
                end
            )
        end
    end)

    self.FiltersDropdown = Dropdown
    self.FiltersBlocker = Blocker
end

function Explorer:InitFreezeState()
    if self._FreezeInitialized then return end
    self._FreezeInitialized = true

    self.ExplorerFrozen = false
    self.FreezeSearchTerm = ""
    self.FreezeSearchByClassName = false
    self.FrozenPendingAdds = setmetatable({}, {__mode = "k"})
    self.FrozenPendingRemoves = setmetatable({}, {__mode = "k"})
    self._FreezeUiRefreshers = self._FreezeUiRefreshers or {}
end

function Explorer:_FireFreezeUiRefreshers()
    if not self._FreezeUiRefreshers then
        return
    end

    for _, Refresh in self._FreezeUiRefreshers do
        pcall(Refresh)
    end

    if self._UpdateFreezeButtonVisual then
        self:_UpdateFreezeButtonVisual()
    end
end

function Explorer:SetExplorerFrozen(Frozen, Reason)
    self:InitFreezeState()

    if self.ExplorerFrozen == Frozen then
        return
    end

    self.ExplorerFrozen = Frozen

    if not Frozen then
        local Adds = self.FrozenPendingAdds
        local Removes = self.FrozenPendingRemoves
        self.FrozenPendingAdds = {}
        self.FrozenPendingRemoves = {}

        self:Notify("Explorer unfrozen")
    else
        local Suffix = Reason and ` ({Reason})` or ""
        self:Notify(`Explorer frozen{Suffix}`)
    end

    self:_UpdateFreezeButtonVisual()

    task.defer(function()
        if self.FreezeButton and self.FreezeButton.Parent then
            self:_UpdateFreezeButtonVisual()
        end
    end)

    self:_FireFreezeUiRefreshers()
end

function Explorer:ToggleExplorerFreeze()
    self:InitFreezeState()
    self:SetExplorerFrozen(not self.ExplorerFrozen)
end

function Explorer:_UpdateFreezeButtonVisual()
    local Button = self.FreezeButton
    if not Button or not Button.Parent then return end

    local Frozen = self.ExplorerFrozen == true
    local Icon = Button:FindFirstChildOfClass("ImageLabel")
    local Stroke = Button:FindFirstChildOfClass("UIStroke")

    if Frozen then
        Button.BackgroundColor3 = Theme.Accent
        Button.BackgroundTransparency = 0.15
        Button.TextColor3 = Theme.Text
        if Icon then Icon.ImageColor3 = Theme.Text end
        if Stroke then Stroke.Color = Theme.Accent end
        Button.Text = (Icon and Icon.Image ~= "") and "" or "F*"
    else
        Button.BackgroundColor3 = Theme.Border
        Button.BackgroundTransparency = math.clamp((UITransparency.TitleBar or 0) + 0.12, 0, 1)
        Button.TextColor3 = Theme.TextDim
        if Icon then Icon.ImageColor3 = Theme.TextDim end
        if Stroke then Stroke.Color = Theme.Border end
        Button.Text = (Icon and Icon.Image ~= "") and "" or "F"
    end
end

function Explorer:_StartFreezeSearchWatcher()
    self:_StopFreezeSearchWatcher()

    local Good, Conn = pcall(function()
        return game.DescendantAdded:Connect(function(RawDescendant)
            if typeof(RawDescendant) ~= "Instance" then return end
            if self.ExplorerFrozen then return end

            local Term = self.FreezeSearchTerm
            if not Term or Term == "" then return end

            local MatchByClass = self.FreezeSearchByClassName == true

            local TargetField
            if MatchByClass then
                local GoodClass, ClassName = pcall(function()
                    return RawDescendant.ClassName
                end)
                if not GoodClass or type(ClassName) ~= "string" then return end
                TargetField = ClassName
            else
                local GoodName, Name = pcall(function()
                    return RawDescendant.Name
                end)
                if not GoodName or type(Name) ~= "string" then return end
                TargetField = Name
            end

            if not string.find(string.lower(TargetField), string.lower(Term), 1, true) then
                return
            end

            local Cloned = ClonerefInstance(RawDescendant)

            pcall(function()
                if self._VTreeRevealInstance then
                    self:_VTreeRevealInstance(Cloned, {
                        Select = false;
                        Scroll = false;
                        Expand = true;
                    })
                end
            end)

            task.defer(function()
                if KillScript then return end
                if self.ExplorerFrozen then return end

                local Reason = MatchByClass
                    and `matched class "{TargetField}"`
                    or  `matched "{TargetField}"`

                self:SetExplorerFrozen(true, Reason)

                pcall(function()
                    self:JumpToInstance(Cloned)
                end)
            end)
        end)
    end)

    if Good and Conn then
        self._FreezeSearchConn = Conn
        Track(Conn)
    end
end

function Explorer:_StopFreezeSearchWatcher()
    if self._FreezeSearchConn then
        pcall(function()
            self._FreezeSearchConn:Disconnect()
        end)

        self._FreezeSearchConn = nil
    end
end

function Explorer:SetFreezeSearchTerm(Term)
    self:InitFreezeState()

    Term = tostring(Term or ""):gsub("^%s+", ""):gsub("%s+$", "")
    self.FreezeSearchTerm = Term

    if self.FreezeSearchBox
        and self.FreezeSearchBox.Parent
        and self.FreezeSearchBox.Text ~= Term
    then
        self.FreezeSearchBox.Text = Term
    end

    if Term == "" then
        self:_StopFreezeSearchWatcher()
    else
        self:_StartFreezeSearchWatcher()
    end

    if self.SaveConfig then
        pcall(function() self:SaveConfig() end)
    end
end

function Explorer:_StartFreezeWatcher()
    local Term = (self.FreezeSearchTerm or ""):lower()
    if Term == "" then return end

    self._FreezeWatcherConnection = Track(game.DescendantAdded:Connect(function(Descendant)
        if self.ExplorerFrozen then return end
        if typeof(Descendant) ~= "Instance" then return end

        local Good, Name = pcall(function() return Descendant.Name end)
        if not Good or type(Name) ~= "string" then return end

        if Name:lower():find(Term, 1, true) then
            self:SetExplorerFrozen(true, `matched "{Name}"`)
        end
    end))
end

function Explorer:CreateSearchBar()
    local Holder = self.ExplorerHeader
    if not Holder then
        return
    end

    local SearchIconAsset = GetUIAssetId("SearchIcon")
    local LeftPad = SearchIconAsset and 28 or 8
    local RightPad = 64

    local SearchBox = VexUI:CreateInstance("TextBox", {
        Size = UDim2.new(1, -16, 0, 24);
        Position = UDim2.new(0, 8, 0.5, -12);
        BackgroundColor3 = Theme.Field;
        BorderSizePixel = 0;
        Font = Fonts.Mono;
        PlaceholderText = "Search instances...";
        PlaceholderColor3 = Theme.TextFaded;
        Text = "";
        TextColor3 = Theme.Text;
        TextSize = 11;
        TextXAlignment = Enum.TextXAlignment.Left;
        ClearTextOnFocus = false;
        Parent = Holder;
    })
    
    VexUI:AddStroke(SearchBox, "Border", 1)
    VexUI:AddPadding(SearchBox, 0, RightPad, 0, LeftPad)
    BindTheme("Field", function(Color)
        SearchBox.BackgroundColor3 = Color
    end)

    BindTheme("Text", function(Color)
        if SearchBox and SearchBox.Parent then
            SearchBox.TextColor3 = Color
        end
    end)

    BindTheme("TextFaded", function(Color)
        if SearchBox and SearchBox.Parent then
            SearchBox.PlaceholderColor3 = Color
        end
    end)

    if SearchIconAsset then
        local SearchIcon = VexUI:CreateInstance("ImageLabel", {
            Size = UDim2.new(0, 14, 0, 14);
            Position = UDim2.new(0, 7 - LeftPad, 0.5, -7);
            BackgroundTransparency = 1;
            Image = SearchIconAsset;
            ImageColor3 = Theme.TextFaded;
            ScaleType = Enum.ScaleType.Fit;
            Active = false;
            Parent = SearchBox;
        })

        BindTheme("TextFaded", function(Color)
            if SearchIcon and SearchIcon.Parent then
                SearchIcon.ImageColor3 = Color
            end
        end)
    end

    local FiltersButton = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(0, 56, 0, 18);
        Position = UDim2.new(1, -68, 0.5, -9);
        BackgroundColor3 = Theme.Border;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Font = Fonts.Bold;
        Text = "FILTERS";
        TextColor3 = Theme.TextDim;
        TextSize = 10;
        ZIndex = 3;
        Parent = Holder;
    })
    
    VexUI:AddStroke(FiltersButton, "Border", 1)
    BindTheme("Border", function(Color)
        FiltersButton.BackgroundColor3 = Color
    end)

    BindTheme("TextDim", function(Color)
        FiltersButton.TextColor3 = Color
    end)

    FiltersButton.MouseEnter:Connect(function()
        VexUI:Tween(FiltersButton, {BackgroundColor3 = Theme.Selected; TextColor3 = Theme.Text})
    end)

    FiltersButton.MouseLeave:Connect(function()
        VexUI:Tween(FiltersButton, {BackgroundColor3 = Theme.Border; TextColor3 = Theme.TextDim})
    end)

    self.SearchBox = SearchBox
    self.FiltersButton = FiltersButton

    self._SearchTextToken = self._SearchTextToken or 0
    self._LastAppliedSearchQuery = self.SearchQuery or ""

    local function RequestSearchRefresh(Immediate)
        if self._SuppressSearchBoxChanged then
            return
        end

        self._SearchTextToken += 1
        local MyToken = self._SearchTextToken

        local NewQuery = (SearchBox.Text or ""):lower()
        self.SearchQuery = NewQuery

        local function Apply()
            if MyToken ~= self._SearchTextToken or KillScript then
                return
            end

            if self._SuppressSearchBoxChanged then
                return
            end

            if self._LastAppliedSearchQuery == NewQuery then
                return
            end

            self._LastAppliedSearchQuery = NewQuery
            self:RefreshAllSearchFilters()
        end

        if Immediate then
            Apply()
        else
            task.delay(0.18, Apply)
        end
    end

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        RequestSearchRefresh(false)
    end)

    SearchBox.FocusLost:Connect(function(EnterPressed)
        if self._SuppressSearchBoxChanged then
            return
        end

        self._SearchTextToken += 1

        local NewQuery = (SearchBox.Text or ""):lower()
        self.SearchQuery = NewQuery

        if self._LastAppliedSearchQuery ~= NewQuery then
            self._LastAppliedSearchQuery = NewQuery
            self:RefreshAllSearchFilters()
        end

        if EnterPressed then
            self:HandleSearchSubmit()
        end
    end)

    FiltersButton.MouseButton1Click:Connect(function()
        if self.FiltersDropdown then
            self.FiltersDropdown:Destroy()

            if self.FiltersBlocker then
                self.FiltersBlocker:Destroy()
            end

            self.FiltersDropdown = nil
            self.FiltersBlocker = nil

            return
        end

        self:OpenFiltersDropdown(FiltersButton)
    end)
end

function Explorer:CreatePropertyFilterBar()
    local Holder = self.PropertiesHeader
    if not Holder then
        return
    end

    local FilterBox = VexUI:CreateInstance("TextBox", {
        Size = UDim2.new(1, -16, 0, 24);
        Position = UDim2.new(0, 8, 0.5, -12);
        BackgroundColor3 = Theme.Field;
        BorderSizePixel = 0;
        Font = Fonts.Mono;
        PlaceholderText = "Filter properties...";
        PlaceholderColor3 = Theme.TextFaded;
        Text = "";
        TextColor3 = Theme.Text;
        TextSize = 11;
        TextXAlignment = Enum.TextXAlignment.Left;
        ClearTextOnFocus = false;
        Parent = Holder;
    })
    
    VexUI:AddStroke(FilterBox, "Border", 1)
    VexUI:AddPadding(FilterBox, 0, 8, 0, 8)

    BindTheme("Field", function(Color)
        if FilterBox and FilterBox.Parent then
            FilterBox.BackgroundColor3 = Color
        end
    end)

    BindTheme("Text", function(Color)
        if FilterBox and FilterBox.Parent then
            FilterBox.TextColor3 = Color
        end
    end)

    BindTheme("TextFaded", function(Color)
        if FilterBox and FilterBox.Parent then
            FilterBox.PlaceholderColor3 = Color
        end
    end)

    self.PropertiesFilterBox = FilterBox

    FilterBox:GetPropertyChangedSignal("Text"):Connect(function()
        self.PropertyFilter = FilterBox.Text

        if self.SelectedInstance then
            self:RenderProperties(self.SelectedInstance)
        end
    end)
end

function Explorer:BuildQuickAccessBar()
    local ButtonWidth = 82
    local ButtonHeight = 26

    local QuickButton = VexUI:CreateInstance("TextButton", {
        Size = UDim2.fromOffset(ButtonWidth, ButtonHeight);
        Position = UDim2.new(0.5, -ButtonWidth / 2, 0, 6);
        BackgroundColor3 = Theme.TitleBar;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Font = Fonts.Bold;
        Text = "VEX";
        TextColor3 = Theme.Text;
        TextSize = 13;
        ZIndex = 300;
        Parent = self.ScreenGui;
    })
    VexUI:AddStroke(QuickButton, "Border", 1)

    BindTheme("TitleBar", function(Color)
        if QuickButton.Parent then
            QuickButton.BackgroundColor3 = Color
        end
    end)

    BindTheme("Text", function(Color)
        if QuickButton.Parent then
            QuickButton.TextColor3 = Color
        end
    end)

    self.QuickButton = QuickButton

    local function CloseDropdown()
        if self._QuickDropdown and self._QuickDropdown.Parent then
            self._QuickDropdown:Destroy()
        end
        self._QuickDropdown = nil
    end

    local ActiveTiles = {}

    local TileData = setmetatable({}, {__mode = "k"})

    local function ApplyTileVisual(Tile, IsActive, Hovering)
        local TargetBg = IsActive and Theme.Selected or Theme.Field
        local BaseTransparency = IsActive and 0.15 or (UITransparency.Field or 0)
        local TargetTransparency = Hovering
            and math.clamp(BaseTransparency - 0.1, 0, 1)
            or BaseTransparency

        Tile.BackgroundColor3 = TargetBg
        Tile.BackgroundTransparency = TargetTransparency

        local Data = TileData[Tile]
        if Data then
            if Data.Stroke then
                Data.Stroke.Color = IsActive and Theme.SelectionBar or Theme.Border
            end

            if Data.Label then
                Data.Label.TextColor3 = IsActive and Theme.Accent or Theme.TextDim
            end
        end
    end

    local function MakeTile(GridParent, LabelText, GetActive, Order, Callback)
        local IsActive = GetActive()

        local Tile = VexUI:CreateInstance("TextButton", {
            BackgroundColor3 = IsActive and Theme.Selected or Theme.Field;
            BackgroundTransparency = IsActive and 0.15 or (UITransparency.Field or 0);
            BorderSizePixel = 0;
            AutoButtonColor = false;
            Text = "";
            LayoutOrder = Order;
            ZIndex = 302;
            Parent = GridParent;
        })

        local Stroke = VexUI:AddStroke(Tile, IsActive and "SelectionBar" or "Border", 1)

        local InnerFrame = VexUI:CreateInstance("Frame", {
            Size = UDim2.fromScale(1, 1);
            BackgroundTransparency = 1;
            ZIndex = 302;
            Parent = Tile;
        })
        local InnerLayout = VexUI:AddListLayout(InnerFrame, 4, Enum.FillDirection.Vertical)
        InnerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        InnerLayout.VerticalAlignment = Enum.VerticalAlignment.Center

        local Label = VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, -4, 0, 0);
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundTransparency = 1;
            Font = Fonts.SemiBold;
            Text = LabelText;
            TextColor3 = IsActive and Theme.Accent or Theme.TextDim;
            TextSize = 11;
            TextXAlignment = Enum.TextXAlignment.Center;
            TextWrapped = true;
            ZIndex = 303;
            Parent = InnerFrame;
        })

        TileData[Tile] = {Stroke = Stroke, Label = Label}

        local Hovering = false

        Tile.MouseEnter:Connect(function()
            Hovering = true
            ApplyTileVisual(Tile, GetActive(), true)
        end)

        Tile.MouseLeave:Connect(function()
            Hovering = false
            ApplyTileVisual(Tile, GetActive(), false)
        end)

        Tile.MouseButton1Click:Connect(function()
            Callback()
            for _, Entry in ActiveTiles do
                ApplyTileVisual(Entry.Tile, Entry.GetActive(), false)
            end
        end)

        table.insert(ActiveTiles, {Tile = Tile; GetActive = GetActive})

        return Tile
    end

    local function OpenDropdown()
        CloseDropdown()
        ActiveTiles = {}

        local PanelWidth = 220

        local Panel = VexUI:CreateInstance("Frame", {
            Size = UDim2.fromOffset(PanelWidth, 0);
            AutomaticSize = Enum.AutomaticSize.Y;
            AnchorPoint = Vector2.new(0.5, 0);
            BackgroundColor3 = Theme.Window;
            BackgroundTransparency = UITransparency.Window or 0;
            BorderSizePixel = 0;
            ZIndex = 301;
            Parent = self.ScreenGui;
        })

        local PanelStroke = VexUI:AddStroke(Panel, "Border", 1)
        VexUI:AddPadding(Panel, 4, 10, 12, 10)
        VexUI:AddListLayout(Panel, 8, Enum.FillDirection.Vertical)

        BindTheme("Window", function(Color)
            if Panel and Panel.Parent then
                Panel.BackgroundColor3 = Color
            end
        end)

        BindTransparency("Window", function(Value)
            if Panel and Panel.Parent then
                Panel.BackgroundTransparency = Value
            end
        end)

        BindTheme("Border", function(Color)
            if PanelStroke and PanelStroke.Parent then
                PanelStroke.Color = Color
            end
        end)

        self._QuickDropdown = Panel

        local function ReposPanel()
            if not Panel.Parent or not QuickButton.Parent then
                return
            end

            local ButtonAbsPos = QuickButton.AbsolutePosition
            local ButtonAbsSize = QuickButton.AbsoluteSize
            local GuiAbsPos = self.ScreenGui.AbsolutePosition

            local CenterX = ButtonAbsPos.X + ButtonAbsSize.X / 2 - GuiAbsPos.X
            local TopY = ButtonAbsPos.Y + ButtonAbsSize.Y + 6 - GuiAbsPos.Y

            Panel.Position = UDim2.fromOffset(CenterX, TopY)
        end

        ReposPanel()
        task.defer(ReposPanel)

        local Header = VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 14);
            BackgroundTransparency = 1;
            Font = Fonts.Bold;
            Text = "QUICK ACCESS";
            TextColor3 = Theme.TextHeader;
            TextSize = 10;
            TextXAlignment = Enum.TextXAlignment.Left;
            LayoutOrder = 0;
            ZIndex = 302;
            Parent = Panel;
        })
        BindTheme("TextHeader", function(Color)
            if Header and Header.Parent then
                Header.TextColor3 = Color
            end
        end)

        local Grid = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 0);
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundTransparency = 1;
            LayoutOrder = 1;
            ZIndex = 301;
            Parent = Panel;
        })
        VexUI:CreateInstance("UIGridLayout", {
            CellSize = UDim2.fromOffset(94, 60);
            CellPadding = UDim2.fromOffset(6, 6);
            FillDirection = Enum.FillDirection.Horizontal;
            HorizontalAlignment = Enum.HorizontalAlignment.Center;
            SortOrder = Enum.SortOrder.LayoutOrder;
            Parent = Grid;
        })

        MakeTile(Grid, "Explorer",
            function()
                return self.ExplorerWindow
                    and self.ExplorerWindow.Frame
                    and self.ExplorerWindow.Frame.Visible ~= false
            end,
            1,
            function()
                if self.ExplorerWindow and self.ExplorerWindow.Frame then
                    local NewVisible = not self.ExplorerWindow.Frame.Visible
                    self.ExplorerWindow.Frame.Visible = NewVisible
                    self.WindowVisible = NewVisible
                end
            end
        )

        MakeTile(Grid, "Properties",
            function()
                return self.PropertiesWindow
                    and self.PropertiesWindow.Frame
                    and self.PropertiesWindow.Frame.Visible ~= false
            end,
            2,
            function()
                if self.PropertiesWindow and self.PropertiesWindow.Frame then
                    self.PropertiesWindow.Frame.Visible = not self.PropertiesWindow.Frame.Visible
                end
            end
        )

        MakeTile(Grid, "Console",
            function()
                return self.ConsoleWindow ~= nil and self.ConsoleWindow.Parent ~= nil
            end,
            3,
            function()
                if self.ToggleConsole then
                    self:ToggleConsole()
                end
            end
        )

        MakeTile(Grid, "Click Part\nto Select",
            function()
                return self.ClickPartToSelect == true
            end,
            4,
            function()
                self:ToggleClickPartToSelect()
            end
        )

        MakeTile(Grid, "Click UI\nto Select",
            function()
                return self.ClickUiToSelect == true
            end,
            5,
            function()
                self:ToggleClickUiToSelect()
            end
        )

        task.spawn(function()
            task.wait(0.05)

            local OutsideClickConnection
            OutsideClickConnection = Services.UserInputService.InputBegan:Connect(function(Input)
                if Input.UserInputType ~= Enum.UserInputType.MouseButton1
                    and Input.UserInputType ~= Enum.UserInputType.MouseButton2
                then
                    return
                end

                if not Panel or not Panel.Parent then
                    OutsideClickConnection:Disconnect()
                    return
                end

                local MouseX = Input.Position.X
                local MouseY = Input.Position.Y
                local PanelAbsolutePosition = Panel.AbsolutePosition
                local PanelAbsoluteSize = Panel.AbsoluteSize
                local ButtonAbsPos = QuickButton.AbsolutePosition
                local ButtonAbsSize = QuickButton.AbsoluteSize

                local InPanel = MouseX >= PanelAbsolutePosition.X
                    and MouseX <= PanelAbsolutePosition.X + PanelAbsoluteSize.X
                    and MouseY >= PanelAbsolutePosition.Y
                    and MouseY <= PanelAbsolutePosition.Y + PanelAbsoluteSize.Y

                local InButton = MouseX >= ButtonAbsPos.X
                    and MouseX <= ButtonAbsPos.X + ButtonAbsSize.X
                    and MouseY >= ButtonAbsPos.Y
                    and MouseY <= ButtonAbsPos.Y + ButtonAbsSize.Y

                if not InPanel and not InButton then
                    CloseDropdown()
                    OutsideClickConnection:Disconnect()
                end
            end)
        end)
    end

    QuickButton.MouseButton1Click:Connect(function()
        if self._QuickDropdown and self._QuickDropdown.Parent then
            CloseDropdown()
        else
            OpenDropdown()
        end
    end)
end

function Explorer:ToggleClickPartToSelect()
    self.ClickPartToSelect = not self.ClickPartToSelect

    if self.ClickPartToSelect then
        self:_StartClickPartToSelect()
        self:Notify("Click Part to Select: ON")
    else
        self:_StopClickPartToSelect()
        self:Notify("Click Part to Select: OFF")
    end
end

function Explorer:ToggleClickUiToSelect()
    self.ClickUiToSelect = not self.ClickUiToSelect

    if self.ClickUiToSelect then
        self:_StartClickUiToSelect()
        self:Notify("Click UI to Select: ON")
    else
        self:_StopClickUiToSelect()
        self:Notify("Click UI to Select: OFF")
    end
end

function Explorer:_StartClickUiToSelect()
    self:_StopClickUiToSelect()

    local Mouse = self.LocalPlayer:GetMouse()

    local function GatherHits(X, Y)
        local Hits = {}

        local PlayerGui = self.LocalPlayer:FindFirstChildOfClass("PlayerGui")
        if PlayerGui then
            local Good, Result = pcall(function()
                return PlayerGui:GetGuiObjectsAtPosition(X, Y)
            end)
            if Good and type(Result) == "table" then
                for _, Obj in Result do
                    table.insert(Hits, Obj)
                end
            end
        end

        local Good2, Result2 = pcall(function()
            return Services.CoreGui:GetGuiObjectsAtPosition(X, Y)
        end)
        if Good2 and type(Result2) == "table" then
            for _, Obj in Result2 do
                table.insert(Hits, Obj)
            end
        end

        return Hits
    end

    self._ClickUiConnection = Track(Mouse.Button1Down:Connect(function()
        local Hits = GatherHits(Mouse.X, Mouse.Y)
        if #Hits == 0 then
            return
        end

        local Target
        for _, Object in Hits do
            if self.ScreenGui and Object:IsDescendantOf(self.ScreenGui) then
                continue
            end
            Target = Object
            break
        end

        if not Target then
            return
        end

        if self:IsPointOverVexUi(Mouse.X, Mouse.Y) then
            return
        end

        self:JumpToInstance(ClonerefInstance(Target))
    end))
end

function Explorer:_StopClickUiToSelect()
    if self._ClickUiConnection then
        pcall(function()
            self._ClickUiConnection:Disconnect()
        end)
        self._ClickUiConnection = nil
    end
end

function Explorer:IsPointOverVexUi(X, Y)
    if not self.ScreenGui then
        return false
    end

    local Good, Hits = pcall(function()
        return self.ScreenGui:GetGuiObjectsAtPosition(X, Y)
    end)

    if not Good or type(Hits) ~= "table" then
        return false
    end

    return #Hits > 0
end

function Explorer:_StartClickPartToSelect()
    self:_StopClickPartToSelect()

    self._ClickPartConnection = Track(Services.UserInputService.InputBegan:Connect(function(Input, GameProcessed)
        if Input.UserInputType ~= Enum.UserInputType.MouseButton1 then
            return
        end

        if GameProcessed then
            return
        end

        local Mouse = self.LocalPlayer:GetMouse()
        if self:IsPointOverVexUi(Mouse.X, Mouse.Y) then
            return
        end

        local Target = Mouse.Target
        if not Target then
            return
        end

        local GoodIsA, IsPart = pcall(function()
            return Target:IsA("BasePart")
        end)

        if not (GoodIsA and IsPart) then
            return
        end

        local GoodDescendant, IsInGui = pcall(function()
            return self.ScreenGui ~= nil and Target:IsDescendantOf(self.ScreenGui)
        end)

        if GoodDescendant and IsInGui then
            return
        end

        local Cloned = ClonerefInstance(Target)
        self:JumpToInstance(Cloned)
    end))
end

function Explorer:_StopClickPartToSelect()
    if self._ClickPartConnection then
        pcall(function()
            self._ClickPartConnection:Disconnect()
        end)
        self._ClickPartConnection = nil
    end
end

function Explorer:_PinPath(Inst)
    if not Inst then return nil end
    local Good, Path = pcall(function() return Inst:GetFullName() end)
    if Good and type(Path) == "string" and Path ~= "" then
        return Path
    end
    return nil
end

function Explorer:_ResolvePinPath(Path)
    if type(Path) ~= "string" or Path == "" then return nil end
    local Segments = string.split(Path, ".")
    local Cur = game
    for I, Seg in Segments do
        if I == 1 and Seg == "game" then
            continue
        end
        local Good, Next = pcall(function() return Cur:FindFirstChild(Seg) end)
        if not Good or not Next then return nil end
        Cur = Next
    end
    return Cur
end

function Explorer:IsPinned(Inst)
    local Path = self:_PinPath(Inst)
    if not Path then return false end
    self.PinnedPaths = self.PinnedPaths or {}
    for _, P in self.PinnedPaths do
        if P == Path then return true end
    end
    return false
end

function Explorer:PinInstance(Inst)
    local Path = self:_PinPath(Inst)
    if not Path then return end
    self.PinnedPaths = self.PinnedPaths or {}
    for _, P in self.PinnedPaths do
        if P == Path then return end
    end
    table.insert(self.PinnedPaths, Path)
    if self.SaveConfig then self:SaveConfig() end
    if self._RebuildPinBar then self:_RebuildPinBar() end
end

function Explorer:UnpinInstance(Inst)
    local Path = self:_PinPath(Inst)
    if not Path then return end
    self.PinnedPaths = self.PinnedPaths or {}
    for I, P in self.PinnedPaths do
        if P == Path then
            table.remove(self.PinnedPaths, I)
            if self.SaveConfig then self:SaveConfig() end
            if self._RebuildPinBar then self:_RebuildPinBar() end
            return
        end
    end
end

function Explorer:_RebuildPinBar()
    local Bar = self.PinBar
    if not Bar then return end

    for _, Child in Bar:GetChildren() do
        if Child:IsA("GuiObject") then
            Child:Destroy()
        end
    end

    self.PinnedPaths = self.PinnedPaths or {}
    self:_ApplyExplorerLayout()
    if #self.PinnedPaths == 0 then
        return
    end

    for I, Path in self.PinnedPaths do
        local Inst = self:_ResolvePinPath(Path)
        local DisplayName
        local ClassName
        if Inst then
            local GN, N = pcall(function() return Inst.Name end)
            DisplayName = GN and N or "?"
            local GC, C = pcall(function() return Inst.ClassName end)
            ClassName = GC and C or "Instance"
        else
            local Segments = string.split(Path, ".")
            DisplayName = Segments[#Segments] or "?"
            ClassName = "Instance"
        end

        local Pill = VexUI:CreateInstance("TextButton", {
            Size = UDim2.new(0, 0, 1, 0);
            AutomaticSize = Enum.AutomaticSize.X;
            BackgroundColor3 = Theme.Field;
            BorderSizePixel = 0;
            AutoButtonColor = false;
            Font = Fonts.Medium;
            Text = "";
            LayoutOrder = I;
            Parent = Bar;
        })
        VexUI:AddStroke(Pill, "Border", 1)
        VexUI:AddPadding(Pill, 0, 6, 0, 6)

        local Icon = VexUI:CreateInstance("ImageLabel", {
            Size = UDim2.new(0, 14, 0, 14);
            Position = UDim2.new(0, 0, 0.5, -7);
            BackgroundTransparency = 1;
            Parent = Pill;
        })
        VexUI:ApplyClassIcon(Icon, ClassName)

        local Label = VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(0, 0, 1, 0);
            Position = UDim2.new(0, 18, 0, 0);
            AutomaticSize = Enum.AutomaticSize.X;
            BackgroundTransparency = 1;
            Font = Fonts.Medium;
            Text = DisplayName;
            TextColor3 = Inst and Theme.Text or Theme.TextFaded;
            TextSize = 11;
            TextXAlignment = Enum.TextXAlignment.Left;
            Parent = Pill;
        })

        Pill.MouseButton1Click:Connect(function()
            local Target = self:_ResolvePinPath(Path)
            if not Target then
                self:Notify("Pinned instance no longer exists")
                return
            end
            self:JumpToInstance(Target)
        end)

        Pill.MouseButton2Click:Connect(function()
            local Target = self:_ResolvePinPath(Path)
            self:UnpinInstance(Target or {GetFullName = function() return Path end})

            if not Target then
                for J, P in self.PinnedPaths do
                    if P == Path then
                        table.remove(self.PinnedPaths, J)
                        if self.SaveConfig then self:SaveConfig() end
                        self:_RebuildPinBar()
                        break
                    end
                end
            end
        end)
    end
end

function Explorer:_ApplyExplorerLayout()
    local HasPins = self.PinnedPaths and #self.PinnedPaths > 0
    local PinBarHeight = HasPins and 22 or 0
    local PinBarGap = HasPins and 4 or 0

    if self._PinBar then
        self._PinBar.Visible = HasPins
    end

    if self._SearchHolder then
        self._SearchHolder.Position = UDim2.new(0, 0, 0, 38 + PinBarHeight + PinBarGap)
    end

    if self._TreeHolder then
        local Offset = 74 + PinBarHeight + PinBarGap
        self._TreeHolder.Position = UDim2.new(0, 0, 0, Offset)
        self._TreeHolder.Size = UDim2.new(1, 0, 1, -Offset)
    end
end

function Explorer:BuildExplorerWindow()
    local Camera = workspace.CurrentCamera
    local Viewport = Camera and Camera.ViewportSize or Vector2.new(1366, 768)
    local Width = 360
    local Height = math.min(580, math.floor((Viewport.Y - 40) / 2))

    local Window = VexUI:CreateWindow({
        Parent = self.ScreenGui;
        Title = "Explorer";
        BackgroundTransparency = 1;
        Brand = true;
        Size = UDim2.fromOffset(Width, Height);
        Position = UDim2.fromOffset(Viewport.X - Width, 0);
    })
    self.ExplorerWindow = Window

    local FreezeButton = self.ExplorerWindow:AddTitleButton(
        "",
        24,
        false,
        function()
            self:ToggleExplorerFreeze()
        end,
        "FreezeIcon",
        10,
        18
    )
    self.FreezeButton = FreezeButton
    self:InitFreezeState()

    local function ReapplyIfFrozen()
        if self.ExplorerFrozen then
            task.defer(function()
                if FreezeButton and FreezeButton.Parent then
                    self:_UpdateFreezeButtonVisual()
                end
            end)
        end
    end

    Track(FreezeButton.MouseEnter:Connect(ReapplyIfFrozen))
    Track(FreezeButton.MouseLeave:Connect(ReapplyIfFrozen))
    Track(FreezeButton.MouseButton1Click:Connect(ReapplyIfFrozen))

    BindTheme("Border", ReapplyIfFrozen)
    BindTheme("Selected", ReapplyIfFrozen)
    BindTheme("Text", ReapplyIfFrozen)
    BindTheme("TextDim", ReapplyIfFrozen)
    BindTheme("Accent", ReapplyIfFrozen)
    BindTransparency("TitleBar", ReapplyIfFrozen)

    self._ReapplyFreezeVisual = ReapplyIfFrozen
    self:_UpdateFreezeButtonVisual()

    Window:AddTitleButton("C", 26, false, function()
        self:ToggleConsole()
    end, "ConsoleIcon", nil, 16)

    Window:AddTitleButton("...", 26, false, function()
        self:OpenSettings()
    end, "SettingsIcon", nil, 14)

    Window:AddTitleButton("X", 26, true, function()
        self:Kill()
    end, "CloseIcon", nil, 14)

    self:InitFreezeState()
    self:_UpdateFreezeButtonVisual()

    local ActionStrip = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, -16, 0, 26);
        Position = UDim2.new(0, 8, 0, 6);
        BackgroundTransparency = 1;
        Parent = Window.Body;
    })

    local ActionLayout = VexUI:AddListLayout(ActionStrip, 6, Enum.FillDirection.Horizontal)
    ActionLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    local function MakeAction(LabelText, OrderIndex, Callback)
        local Button = VexUI:CreateInstance("TextButton", {
            Size = UDim2.new(0, 0, 1, -4);
            AutomaticSize = Enum.AutomaticSize.X;
            BackgroundColor3 = Theme.Field;
            BorderSizePixel = 0;
            AutoButtonColor = false;
            Font = Fonts.SemiBold;
            Text = LabelText;
            TextColor3 = Theme.TextDim;
            TextSize = 11;
            LayoutOrder = OrderIndex;
            Parent = ActionStrip;
        })

        VexUI:AddStroke(Button, "Border", 1)
        VexUI:AddPadding(Button, 0, 10, 0, 10)

        local IsHovering = false

        local function ApplyActionVisual(UseTween)
            local Target = {
                BackgroundColor3 = IsHovering and Theme.FieldHover or Theme.Field;
                TextColor3 = IsHovering and Theme.Text or Theme.TextDim;
            }

            if UseTween then
                VexUI:Tween(Button, Target)
            else
                Button.BackgroundColor3 = Target.BackgroundColor3
                Button.TextColor3 = Target.TextColor3
            end
        end

        BindTheme("Field", function()
            ApplyActionVisual(false)
        end)

        BindTheme("FieldHover", function()
            ApplyActionVisual(false)
        end)

        BindTheme("Text", function()
            ApplyActionVisual(false)
        end)

        BindTheme("TextDim", function()
            ApplyActionVisual(false)
        end)

        Track(Button.MouseEnter:Connect(function()
            IsHovering = true
            ApplyActionVisual(true)
        end))

        Track(Button.MouseLeave:Connect(function()
            IsHovering = false
            ApplyActionVisual(true)
        end))

        Track(Button.MouseButton1Click:Connect(Callback))
        return Button
    end

    MakeAction("TP - PlaceId", 1, function()
        pcall(function()
            Services.TeleportService:Teleport(game.PlaceId, self.LocalPlayer)
        end)
    end)

    MakeAction("TP - JobId", 2, function()
        pcall(function()
            Services.TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, self.LocalPlayer)
        end)
    end)

    MakeAction("Kick Self", 3, function()
        pcall(function()
            self.LocalPlayer:Kick("Kicked via VEX Explorer")
        end)
    end)

    local PinBar = VexUI:CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, -16, 0, 22);
        Position = UDim2.new(0, 8, 0, 36);
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        ScrollBarThickness = 0;
        ScrollingDirection = Enum.ScrollingDirection.X;
        CanvasSize = UDim2.new(0, 0, 0, 0);
        AutomaticCanvasSize = Enum.AutomaticSize.X;
        Visible = false;
        Parent = Window.Body;
    })

    local PinLayout = VexUI:AddListLayout(PinBar, 4, Enum.FillDirection.Horizontal)
    PinLayout.VerticalAlignment = Enum.VerticalAlignment.Center

    self.PinBar = PinBar

    local SearchHolder = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 36);
        Position = UDim2.new(0, 0, 0, 62);
        BackgroundTransparency = 1;
        Parent = Window.Body;
    })
    self.ExplorerHeader = SearchHolder

    local TreeHolder = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, -98);
        Position = UDim2.new(0, 0, 0, 98);
        BackgroundTransparency = 1;
        Parent = Window.Body;
    })

    self._PinBar = PinBar
    self._SearchHolder = SearchHolder
    self._TreeHolder = TreeHolder

    local Tree = VexUI:CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0);
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        ScrollBarThickness = 6;
        ScrollBarImageColor3 = Theme.Border;
        CanvasSize = UDim2.new(0, 0, 0, 0);
        AutomaticCanvasSize = Enum.AutomaticSize.Y;
        ScrollingDirection = Enum.ScrollingDirection.Y;
        Parent = TreeHolder;
    })

    VexUI:BindThemeColor(Tree, "ScrollBarImageColor3", "Border")
    VexUI:AddPadding(Tree, 4, 8, 8, 8)
    VexUI:AddListLayout(Tree, 1, Enum.FillDirection.Vertical)

    local StickyHeader = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(1, -8, 0, 22);
        Position = UDim2.new(0, 4, 0, 0);
        BackgroundColor3 = Theme.Window;
        BackgroundTransparency = UITransparency.Window;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Text = "";
        Visible = false;
        ZIndex = 10;
        Parent = TreeHolder;
    })

    BindTheme("Window", function(Color)
        StickyHeader.BackgroundColor3 = Color
    end)

    BindTransparency("Window", function(Value)
        StickyHeader.BackgroundTransparency = Value
    end)
    
    StickyHeader.MouseButton1Click:Connect(function()
        local Target = self._StickyHeaderTarget
        if not Target then return end

        local Idx = self._VTreeRowsByInstance[Target]
        if Idx then
            local RowH = self._VTreeRowHeight or 22
            local TargetY = math.max(0, (Idx - 1) * RowH)
            Tree.CanvasPosition = Vector2.new(Tree.CanvasPosition.X, TargetY)
        end
    end)

    local StickyDivider = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 1);
        Position = UDim2.new(0, 0, 1, 0);
        BackgroundColor3 = Theme.BorderSoft;
        BorderSizePixel = 0;
        ZIndex = 10;
        Parent = StickyHeader;
    })
    BindTheme("BorderSoft", function(Color)
        StickyDivider.BackgroundColor3 = Color
    end)

    local StickyIcon = VexUI:CreateInstance("ImageLabel", {
        Size = UDim2.new(0, 16, 0, 16);
        Position = UDim2.new(0, 8, 0.5, -8);
        BackgroundTransparency = 1;
        Image = "";
        ScaleType = Enum.ScaleType.Fit;
        ZIndex = 12;
        Parent = StickyHeader;
    })

    local StickyLabel = VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0);
        Position = UDim2.new(0, 32, 0, 0);
        BackgroundTransparency = 1;
        Font = Fonts.SemiBold;
        Text = "";
        TextColor3 = Theme.TextDim;
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextTruncate = Enum.TextTruncate.AtEnd;
        ZIndex = 11;
        Parent = StickyHeader;
    })
    BindTheme("TextDim", function(Color)
        StickyLabel.TextColor3 = Color
    end)

    self.StickyHeader = StickyHeader
    self.StickyHeaderIcon = StickyIcon
    self.StickyHeaderLabel = StickyLabel

    local function UpdateStickyHeader()
        local Rows = self._VTreeFilterActive and self._VTreeFilteredRows or self._VTreeRows
        if not Rows or #Rows == 0 then
            StickyHeader.Visible = false
            return
        end

        local RowH = self._VTreeRowHeight or 22
        local ScrollY = Tree.CanvasPosition.Y
        if ScrollY <= 0 then
            StickyHeader.Visible = false
            return
        end

        local TopIdx = math.floor(ScrollY / RowH) + 1
        if TopIdx > #Rows then TopIdx = #Rows end

        local AnchorIdx
        for I = TopIdx, 1, -1 do
            local R = Rows[I]
            if R and R.Depth == 0 and not R.IsTruncationNotice and not R.IsNilContainer then
                Anchor = R
                AnchorIdx = I
                break
            end
        end

        if not Anchor or not Anchor.Instance or not AnchorIdx then
            StickyHeader.Visible = false
            return
        end

        local AnchorTopY = (AnchorIdx - 1) * RowH
        if AnchorTopY >= ScrollY then
            StickyHeader.Visible = false
            return
        end

        StickyHeader.Visible = true
        StickyLabel.Text = Anchor.RawName or "?"

        VexUI:ApplyClassIcon(StickyIcon, Anchor.ClassName)
        StickyIcon.Visible = true

        self._StickyHeaderTarget = Anchor.Instance

        return
    end

    self.UpdateStickyHeader = UpdateStickyHeader

    self.ExplorerColumn = {
        Content = Tree;
        Clear = function()
            for _, Child in Tree:GetChildren() do
                if Child:IsA("GuiObject") then
                    Child:Destroy()
                end
            end
        end;
        AddLabel = function(_, Text)
            local Label = VexUI:CreateInstance("TextLabel", {
                Size = UDim2.new(1, 0, 0, 22);
                BackgroundTransparency = 1;
                Font = Fonts.Medium;
                Text = Text;
                TextColor3 = Theme.TextDim;
                TextSize = 12;
                TextXAlignment = Enum.TextXAlignment.Left;
                Parent = Tree;
            })

            VexUI:BindThemeColor(Label, "TextColor3", "TextDim")

            return Label
        end;
    }

    self.ReparentIndicator = VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, -16, 0, 22);
        Position = UDim2.new(0, 8, 1, -28);
        BackgroundColor3 = Theme.Accent;
        BackgroundTransparency = 0.3;
        BorderSizePixel = 0;
        Font = Fonts.Bold;
        Text = "";
        TextColor3 = Color3.fromRGB(255, 255, 255);
        TextSize = 11;
        Visible = false;
        ZIndex = 5;
        Parent = Window.Body;
    })

    VexUI:BindThemeColor(self.ReparentIndicator, "BackgroundColor3", "Accent")

    Track(Tree:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
        if self.UpdateStickyHeader then
            self.UpdateStickyHeader()
        end
    end))

    self:_RebuildPinBar()
end

function Explorer:SetupDragHandlers()
    if self.DragHandlersInstalled then
        return
    end

    self.DragHandlersInstalled = true

    Track(Services.UserInputService.InputChanged:Connect(function(Input)
        local DragOperation = self.DragOperation
        if not DragOperation then
            return
        end

        if Input.UserInputType ~= Enum.UserInputType.MouseMovement
            and Input.UserInputType ~= Enum.UserInputType.Touch
        then
            return
        end

        local DeltaX = Input.Position.X - DragOperation.StartX
        local DeltaY = Input.Position.Y - DragOperation.StartY

        if not DragOperation.HasStarted and (DeltaX * DeltaX + DeltaY * DeltaY) > 64 then
            DragOperation.HasStarted = true

            DragOperation.GhostLabel = VexUI:CreateInstance("TextLabel", {
                Size = UDim2.fromOffset(200, 22);
                BackgroundColor3 = Theme.Window;
                BackgroundTransparency = 0.05;
                BorderSizePixel = 0;
                Font = Fonts.SemiBold;
                Text = `  ⇄ {DragOperation.SourceName}`;
                TextColor3 = Theme.Accent;
                TextSize = 12;
                TextXAlignment = Enum.TextXAlignment.Left;
                ZIndex = 500;
                Parent = self.ScreenGui;
            })

            
            VexUI:AddStroke(DragOperation.GhostLabel, Theme.Accent, 1)
        end

        if DragOperation.HasStarted and DragOperation.GhostLabel then
            DragOperation.GhostLabel.Position =
                UDim2.fromOffset(Input.Position.X + 12, Input.Position.Y + 8)
        end
    end))

    Track(Services.UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType ~= Enum.UserInputType.MouseButton1
            and Input.UserInputType ~= Enum.UserInputType.Touch
        then
            return
        end

        local DragOperation = self.DragOperation
        if not DragOperation then
            return
        end

        self.DragOperation = nil

        if DragOperation.GhostLabel then
            DragOperation.GhostLabel:Destroy()
        end

        if not DragOperation.HasStarted then
            return
        end

        self.JustDragged = true
        task.delay(0.15, function()
            self.JustDragged = false
        end)

        local MouseX, MouseY = Input.Position.X, Input.Position.Y
        local TargetInstance

        if self._VTreePool then
            for _, PoolEntry in self._VTreePool do
                local Row = PoolEntry.Row
                local RowData = PoolEntry.Bound
                if Row and Row.Visible and RowData and RowData.Instance and not RowData.IsNilContainer then
                    local AP = Row.AbsolutePosition
                    local AS = Row.AbsoluteSize
                    if AS.Y > 0
                        and MouseX >= AP.X and MouseX <= AP.X + AS.X
                        and MouseY >= AP.Y and MouseY <= AP.Y + AS.Y
                    then
                        TargetInstance = RowData.Instance
                        break
                    end
                end
            end
        end

        if TargetInstance == nil then
            return
        end

        if TargetInstance == DragOperation.Source then
            return
        end

        local SourceInstances

        if self.SelectedSet[DragOperation.Source] then
            SourceInstances = self:GetSelectionList()
        else
            SourceInstances = { DragOperation.Source }
        end

        local SuccessfulReparents = 0

        for _, SourceInstance in SourceInstances do
            local Success = pcall(function()
                if SourceInstance ~= TargetInstance
                    and not TargetInstance:IsDescendantOf(SourceInstance)
                then
                    SourceInstance.Parent = TargetInstance
                    SuccessfulReparents += 1
                end
            end)
        end

        if SuccessfulReparents > 0 then
            self:Notify(`Reparented {SuccessfulReparents} into {TargetInstance.Name}`)
        end
    end))
end

function Explorer:BuildPropertiesWindow()
    local Camera = workspace.CurrentCamera
    local Viewport = Camera and Camera.ViewportSize or Vector2.new(1366, 768)
    local Width = 360

    local ExplorerFrame = self.ExplorerWindow and self.ExplorerWindow.Frame
    local TopY = 0
    if ExplorerFrame then
        TopY = ExplorerFrame.Position.Y.Offset + ExplorerFrame.Size.Y.Offset
    end

    local Height = math.max(280, Viewport.Y - TopY)

    local Window = VexUI:CreateWindow({
        Parent = self.ScreenGui;
        Title = "Properties";
        BackgroundTransparency = 1;
        Size = UDim2.fromOffset(Width, Height);
        Position = UDim2.fromOffset(Viewport.X - Width, TopY);
    })
    self.PropertiesWindow = Window

    local TitleStrip = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, -16, 0, 22);
        Position = UDim2.new(0, 8, 0, 8);
        BackgroundTransparency = 1;
        Parent = Window.Body;
    })

    self.PropertiesTitleLabel = VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 1, 0);
        BackgroundTransparency = 1;
        Font = Fonts.Mono;
        Text = "(no selection)";
        TextColor3 = Theme.Accent;
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Center;
        TextYAlignment = Enum.TextYAlignment.Center;
        TextTruncate = Enum.TextTruncate.AtEnd;
        Parent = TitleStrip;
    })
    BindTheme("Accent", function(Color)
        self.PropertiesTitleLabel.TextColor3 = Color
    end)

    local FilterHolder = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, -16, 0, 28);
        Position = UDim2.new(0, 8, 0, 30);
        BackgroundTransparency = 1;
        Parent = Window.Body;
    })
    self.PropertiesHeader = FilterHolder

    local ContentHolder = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, -64);
        Position = UDim2.new(0, 0, 0, 64);
        BackgroundTransparency = 1;
        Parent = Window.Body;
    })

    local Content = VexUI:CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, 0, 1, 0);
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        ScrollBarThickness = 3;
        ScrollBarImageColor3 = Theme.Border;
        CanvasSize = UDim2.new(0, 0, 0, 0);
        AutomaticCanvasSize = Enum.AutomaticSize.Y;
        ScrollingDirection = Enum.ScrollingDirection.Y;
        Parent = ContentHolder;
    })

    VexUI:BindThemeColor(Content, "ScrollBarImageColor3", "Border")
    VexUI:AddPadding(Content, 4, 8, 8, 8)
    VexUI:AddListLayout(Content, 0, Enum.FillDirection.Vertical)
    self.PropertiesContent = Content
end

function Explorer:CloseContextMenu()
    self._ContextMenuToken = nil

    if self.ContextMenuBlocker and self.ContextMenuBlocker.Parent then
        self.ContextMenuBlocker:Destroy()
    end

    self.ContextMenuBlocker = nil

    if self.ContextMenuFrame and self.ContextMenuFrame.Parent then
        self.ContextMenuFrame:Destroy()
    end

    self.ContextMenuFrame = nil
end

function Explorer:_GetReadableProperties(Inst)
    local Result = {}
    if not Inst then return Result end

    local Props
    if getproperties then
        local Good, List = pcall(getproperties, Inst)
        if Good and type(List) == "table" then
            Props = List
        end
    end

    if not Props and gethiddenproperties then
        local Good, List = pcall(gethiddenproperties, Inst)
        if Good and type(List) == "table" then
            Props = List
        end
    end

    if not Props then
        Props = {
            "Name", "ClassName", "Parent", "Archivable",
        }
    end

    for _, PropName in Props do
        local Good, Value = pcall(function() return Inst[PropName] end)
        if Good then
            Result[PropName] = Value
        end
    end

    return Result
end

function Explorer:SnapshotForDiff(Inst)
    if not Inst then return end
    self._DiffSnapshots = self._DiffSnapshots or setmetatable({}, {__mode = "k"})
    self._DiffSnapshots[Inst] = {
        Time = os.clock();
        Props = self:_GetReadableProperties(Inst);
    }
    self:Notify(`Snapshot saved for {Inst.Name}`)
end

function Explorer:HasSnapshot(Inst)
    return self._DiffSnapshots and self._DiffSnapshots[Inst] ~= nil
end

function Explorer:_FormatDiffValue(Value)
    local T = typeof(Value)
    if T == "string" then
        return `"{Value}"`
    elseif T == "Instance" then
        local Good, Path = pcall(function() return Value:GetFullName() end)
        return Good and Path or "Instance"
    elseif T == "nil" then
        return "nil"
    elseif T == "Color3" then
        return string.format("Color3(%.2f, %.2f, %.2f)", Value.R, Value.G, Value.B)
    elseif T == "Vector3" or T == "Vector2" or T == "UDim2" or T == "UDim" or T == "CFrame" then
        return tostring(Value)
    elseif T == "EnumItem" then
        return tostring(Value)
    elseif T == "boolean" or T == "number" then
        return tostring(Value)
    end
    return `<{T}>`
end

function Explorer:_ValuesEqual(A, B)
    if A == B then return true end
    if typeof(A) ~= typeof(B) then return false end
    local T = typeof(A)
    if T == "Color3" or T == "Vector3" or T == "Vector2"
        or T == "UDim2" or T == "UDim" or T == "CFrame"
    then
        return tostring(A) == tostring(B)
    end
    return false
end

function Explorer:OpenDiffViewer(Inst)
    if not Inst then return end
    local Snap = self._DiffSnapshots and self._DiffSnapshots[Inst]
    if not Snap then
        self:Notify("No snapshot for this instance")
        return
    end

    local Window, Body = self:CreateModalWindow(`Diff: {Inst.Name}`, 540, 480, {
        Resizable = true;
        MinWidth = 360;
        MinHeight = 260;
    })

    local Header = VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, -16, 0, 22);
        Position = UDim2.new(0, 8, 0, 4);
        BackgroundTransparency = 1;
        Font = Fonts.Medium;
        Text = string.format("Snapshot taken %.1fs ago", os.clock() - Snap.Time);
        TextColor3 = Theme.TextDim;
        TextSize = 11;
        TextXAlignment = Enum.TextXAlignment.Left;
        Parent = Body;
    })

    local List = VexUI:CreateInstance("ScrollingFrame", {
        Size = UDim2.new(1, -16, 1, -34);
        Position = UDim2.new(0, 8, 0, 30);
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        ScrollBarThickness = 4;
        ScrollBarImageColor3 = Theme.Border;
        CanvasSize = UDim2.new(0, 0, 0, 0);
        AutomaticCanvasSize = Enum.AutomaticSize.Y;
        ScrollingDirection = Enum.ScrollingDirection.Y;
        Parent = Body;
    })
    VexUI:AddListLayout(List, 2, Enum.FillDirection.Vertical)
    VexUI:AddPadding(List, 4, 4, 4, 4)

    local Current = self:_GetReadableProperties(Inst)
    local Changes = {}

    for PropName, OldValue in Snap.Props do
        local NewValue = Current[PropName]
        if not self:_ValuesEqual(OldValue, NewValue) then
            table.insert(Changes, {
                Name = PropName;
                Old = OldValue;
                New = NewValue;
                Type = "changed";
            })
        end
    end

    for PropName, NewValue in Current do
        if Snap.Props[PropName] == nil then
            table.insert(Changes, {
                Name = PropName;
                Old = nil;
                New = NewValue;
                Type = "added";
            })
        end
    end

    table.sort(Changes, function(A, B)
        if A.Type ~= B.Type then return A.Type < B.Type end
        return A.Name < B.Name
    end)

    if #Changes == 0 then
        VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 32);
            BackgroundTransparency = 1;
            Font = Fonts.Medium;
            Text = "No changes detected";
            TextColor3 = Theme.TextDim;
            TextSize = 12;
            Parent = List;
        })
        return
    end

    Header.Text = string.format("%d change(s) - snapshot %.1fs ago", #Changes, os.clock() - Snap.Time)

    for _, Change in Changes do
        local Row = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 42);
            BackgroundColor3 = Theme.Field;
            BackgroundTransparency = 0.6;
            BorderSizePixel = 0;
            Parent = List;
        })
        VexUI:AddPadding(Row, 4, 8, 4, 8)

        local TypeTag = VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(0, 60, 0, 14);
            Position = UDim2.new(0, 0, 0, 0);
            BackgroundTransparency = 1;
            Font = Fonts.Bold;
            Text = Change.Type:upper();
            TextColor3 = Change.Type == "added" and Theme.PropNumber or Theme.Accent;
            TextSize = 10;
            TextXAlignment = Enum.TextXAlignment.Left;
            Parent = Row;
        })

        VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, -68, 0, 14);
            Position = UDim2.new(0, 64, 0, 0);
            BackgroundTransparency = 1;
            Font = Fonts.SemiBold;
            Text = Change.Name;
            TextColor3 = Theme.Text;
            TextSize = 12;
            TextXAlignment = Enum.TextXAlignment.Left;
            Parent = Row;
        })

        local DiffText
        if Change.Type == "added" then
            DiffText = `+ {self:_FormatDiffValue(Change.New)}`
        else
            DiffText = `{self:_FormatDiffValue(Change.Old)}  ->  {self:_FormatDiffValue(Change.New)}`
        end

        VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 16);
            Position = UDim2.new(0, 0, 0, 18);
            BackgroundTransparency = 1;
            Font = Fonts.Mono;
            Text = DiffText;
            TextColor3 = Theme.TextDim;
            TextSize = 11;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextTruncate = Enum.TextTruncate.AtEnd;
            Parent = Row;
        })
    end
end

function Explorer:OpenContextMenu(AnchorX, AnchorY)
    self:CloseContextMenu()

    local Selection = self:GetSelectionList()
    if #Selection == 0 then
        return
    end

    local PrimaryClass = self.SelectedInstance and self.SelectedInstance.ClassName or ""

    local CloseToken = {}
    self._ContextMenuToken = CloseToken

    local Menu
    local InputConnection

    local function Close()
        if self._ContextMenuToken ~= CloseToken then
            return
        end

        self._ContextMenuToken = nil

        if InputConnection then
            InputConnection:Disconnect()
            InputConnection = nil
        end

        if Menu and Menu.Parent then
            Menu:Destroy()
        end

        self.ContextMenuFrame = nil
    end

    Menu = VexUI:CreateInstance("Frame", {
        Size = UDim2.fromOffset(220, 0);
        AutomaticSize = Enum.AutomaticSize.Y;
        Position = UDim2.fromOffset(AnchorX, AnchorY);
        BackgroundColor3 = Theme.Window;
        BorderSizePixel = 0;
        ZIndex = 201;
        Parent = self.ScreenGui;
    })
    
    VexUI:AddStroke(Menu, "Border", 1)
    VexUI:AddPadding(Menu, 6, 6, 6, 6)
    VexUI:AddListLayout(Menu, 2, Enum.FillDirection.Vertical)
    BindTheme("Window", function(Color)
        Menu.BackgroundColor3 = Color
    end)

    self.ContextMenuFrame = Menu

    InputConnection = Services.UserInputService.InputBegan:Connect(function(Input)
        if Input.UserInputType ~= Enum.UserInputType.MouseButton1
            and Input.UserInputType ~= Enum.UserInputType.MouseButton2
            and Input.UserInputType ~= Enum.UserInputType.Touch
        then
            return
        end

        if not Menu or not Menu.Parent then
            Close()

            return
        end

        local MouseX = Input.Position.X
        local MouseY = Input.Position.Y
        local AbsPos = Menu.AbsolutePosition
        local AbsSize = Menu.AbsoluteSize

        if MouseX >= AbsPos.X
            and MouseX <= AbsPos.X + AbsSize.X
            and MouseY >= AbsPos.Y
            and MouseY <= AbsPos.Y + AbsSize.Y
        then
            return
        end

        Close()
    end)

    local function MakeItem(LabelText, Disabled, Callback)
        local Item = VexUI:CreateInstance("TextButton", {
            Size = UDim2.new(1, 0, 0, 24);
            BackgroundColor3 = Theme.Field;
            BackgroundTransparency = 1;
            BorderSizePixel = 0;
            AutoButtonColor = false;
            Font = Fonts.SemiBold;
            Text = LabelText;
            TextColor3 = Disabled and Theme.TextFaded or Theme.Text;
            TextSize = 12;
            TextXAlignment = Enum.TextXAlignment.Left;
            ZIndex = 202;
            Parent = Menu;
        })
        
        VexUI:AddPadding(Item, 0, 10, 0, 10)
        if Disabled then
            return Item
        end

        Track(Item.MouseEnter:Connect(function()
            VexUI:Tween(Item, {
                BackgroundTransparency = 0;
                BackgroundColor3 = Theme.FieldHover;
            })
        end))

        Track(Item.MouseLeave:Connect(function()
            VexUI:Tween(Item, {BackgroundTransparency = 1})
        end))

        Track(Item.MouseButton1Click:Connect(function()
            Close()
            Callback()
        end))

        return Item
    end

    local function MakeSeparator()
        VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 1);
            BackgroundColor3 = Theme.BorderSoft;
            BorderSizePixel = 0;
            Parent = Menu;
        })
    end

    MakeItem("Insert Object", false, function()
        self:OpenInsertObject()
    end)

    MakeItem("Duplicate", false, function()
        local Count = self:DuplicateSelection()
        self:Notify(`Duplicated {Count} instance(s)`)
    end)

    MakeItem("Copy", false, function()
        self:CopySelection()
        self:Notify(`Copied {self.Clipboard and #self.Clipboard or 0} instance(s)`)
    end)

    MakeItem("Paste Into", not (self.Clipboard and #self.Clipboard > 0), function()
        local Count = self.Clipboard and #self.Clipboard or 0
        self:PasteIntoSelection()
        self:Notify(`Pasted {Count} clone(s)`)
    end)

    MakeSeparator()

    MakeItem("Reparent", false, function()
        self:BeginReparent()
    end)

    local FocusedInst = self.SelectedInstance
    local IsPinnedNow = FocusedInst and self:IsPinned(FocusedInst)
    MakeItem(IsPinnedNow and "Unpin" or "Pin", not FocusedInst, function()
        if IsPinnedNow then
            self:UnpinInstance(FocusedInst)
            self:Notify("Unpinned")
        else
            self:PinInstance(FocusedInst)
            self:Notify("Pinned")
        end
    end)

    MakeItem("Snapshot for Differences", not FocusedInst, function()
        self:SnapshotForDiff(FocusedInst)
    end)

    local HasSnap = FocusedInst and self:HasSnapshot(FocusedInst)
    MakeItem("Show Differences", not HasSnap, function()
        self:OpenDiffViewer(FocusedInst)
    end)

    MakeItem("Select Children", false, function()
        self:SelectChildrenOfSelection()
    end)

    local HasSearch = (self._LastAppliedSearchQuery or "") ~= ""
        or (self.SearchBox and self.SearchBox.Text ~= "")
    local HasSelection = typeof(self.SelectedInstance) == "Instance"

    MakeItem("Clear Search & Jump", not (HasSearch and HasSelection), function()
        self:ClearSearchAndJumpTo()
    end)

    local Target = self.SelectedInstance
    local IsPlayer = false
    if Target then
        local Good, Result = pcall(function()
            return Target:IsA("Player")
        end)

        IsPlayer = Good and Result
    end

    if IsPlayer then
        MakeItem("Jump to Character", false, function()
            self:JumpToCharacter(Target)
            self:CloseContextMenu()
        end)
    end

    local Target = self.SelectedInstance
    local IsCharacter = false
    if Target then
        local Good, Result = pcall(function()
            return Services.Players[Target.Name]
        end)

        IsCharacter = Good and Result
    end

    if Target:IsA("Model") and IsCharacter then
        MakeItem("Jump to Player", false, function()
            self:JumpToPlayer(Target)
            self:CloseContextMenu()
        end)
    end

    MakeSeparator()

    local SelectionCount = #Selection
    local NameLabel = SelectionCount > 1 and "Copy Names" or "Copy Name"
    local PathLabel = SelectionCount > 1 and "Copy Paths" or "Copy Path"
    local ClassLabel = SelectionCount > 1 and "Copy ClassNames" or "Copy ClassName"
    local PropsLabel = SelectionCount > 1 and "Copy All Properties" or "Copy All Properties"

    MakeItem(NameLabel, false, function()
        self:CopySelectionField(
            function(Inst) return Inst.Name end,
            "Name copied",
            "Names copied"
        )
    end)

    MakeItem(PathLabel, false, function()
        self:CopySelectionField(
            function(Inst) return self:FullPathFor(Inst) end,
            "Path copied",
            "Paths copied"
        )
    end)

    MakeItem(ClassLabel, false, function()
        self:CopySelectionField(
            function(Inst) return Inst.ClassName end,
            "ClassName copied",
            "ClassNames copied"
        )
    end)

    MakeItem(PropsLabel, false, function()
        if SelectionCount == 1 then
            local Code = SerializeInstance(Selection[1])
            pcall(setclipboard, Code)
            self:Notify("All properties copied")
        else
            local Blocks = {}
            for _, Inst in Selection do
                table.insert(Blocks, SerializeInstance(Inst))
            end
            pcall(setclipboard, table.concat(Blocks, "\n\n"))
            self:Notify(`Properties copied ({SelectionCount})`)
        end
    end)

    MakeSeparator()

    local CanView = false
    if Target then
        pcall(function()
            CanView = Target:IsA("BasePart") or Target:IsA("Model")
        end)
    end

    local ViewLabel = "View Object"
    if self.ViewedObject == Target then
        ViewLabel = "View Object  (middle-click to reset)"
    end

    MakeItem(ViewLabel, not CanView, function()
        self:ToggleViewObject(Target)
    end)

    MakeItem("3D Preview Object", not CanView, function()
        self:Open3DPreview(Target)
    end)

    MakeSeparator()

    MakeItem("Anchor", false, function()
        local Count = self:SetAnchorOnSelection(true)
        self:Notify(`Anchored {Count} part(s)`)
    end)

    MakeItem("Unanchor", false, function()
        local Count = self:SetAnchorOnSelection(false)
        self:Notify(`Unanchored {Count} part(s)`)
    end)

    local CanTeleport = self.SelectedInstance and (self.SelectedInstance:IsA("BasePart") or self.SelectedInstance:IsA("Model") or self.SelectedInstance:IsA("Tool") or self.SelectedInstance:IsA("Attachment"))
    MakeItem("Teleport Here", not CanTeleport, function()
        local Good, Reason = self:TeleportSelfTo(self.SelectedInstance)
        self:Notify(Good and `Teleported to {self.SelectedInstance.Name}` or `Teleport failed: {Reason}`)
    end)

    MakeSeparator()

    MakeItem("Call Function", false, function()
        self:OpenCallFunction()
    end)

    local IsRemote = (
        PrimaryClass == "RemoteEvent"
        or PrimaryClass == "UnreliableRemoteEvent"
        or PrimaryClass == "RemoteFunction"
        or PrimaryClass == "BindableEvent"
        or PrimaryClass == "BindableFunction"
    )

    MakeItem("Call Remote", not IsRemote, function()
        self:OpenCallRemote()
    end)

    local IsScript = PrimaryClass == "LocalScript" or PrimaryClass == "ModuleScript"

    if not IsScript
        and PrimaryClass == "Script"
        and self.SelectedInstance
    then
        local Success, RunContext = pcall(function()
            return self.SelectedInstance.RunContext
        end)

        if Success and RunContext == Enum.RunContext.Client then
            IsScript = true
        end
    end

    MakeItem("Script View (Default)", not IsScript, function()
        self:OpenScriptViewer(self.SelectedInstance, true)
    end)

    MakeItem("Script View (lua.expert)", not IsScript, function()
        self:OpenScriptViewer(self.SelectedInstance)
    end)

    MakeSeparator()

    local ExpandTargets = self:GetSelectionList()
    local HasTargets = #ExpandTargets > 0

    MakeItem("Collapse All Under Selection", not HasTargets, function()
        local Collapsed = self:CollapseAllUnder(ExpandTargets)
        self:Notify(`Collapsed {Collapsed} node(s)`)
    end)

    MakeItem("Collapse Entire Tree", false, function()
        local Collapsed = self:CollapseAllRoots()
        self:Notify(`Collapsed {Collapsed} node(s)`)
    end)

    MakeItem("Refresh Properties", false, function()
        if self.SelectedInstance then
            self:RenderProperties(self.SelectedInstance)
        end
    end)

    MakeItem("Destroy", false, function()
        local Count = #self:GetSelectionList()
        self:DestroySelection()
        self:Notify(`Destroyed {Count} instance(s)`)
    end)

    task.defer(function()
        local MenuHeight = Menu.AbsoluteSize.Y
        local MenuWidth = Menu.AbsoluteSize.X
        local Cam = workspace.CurrentCamera
        if not Cam then
            return
        end

        local View = Cam.ViewportSize
        local NewX = AnchorX
        local NewY = AnchorY
        if NewX + MenuWidth > View.X then
            NewX = View.X - MenuWidth - 4
        end

        if NewY + MenuHeight > View.Y then
            NewY = View.Y - MenuHeight - 4
        end

        Menu.Position = UDim2.fromOffset(NewX, NewY)
    end)
end

function Explorer:CollapseAllUnder(Targets)
    if typeof(Targets) == "Instance" then
        Targets = {Targets}
    end
    if type(Targets) ~= "table" or #Targets == 0 then
        return 0
    end

    local TargetSet = {}
    for _, Inst in Targets do
        if typeof(Inst) == "Instance" then
            TargetSet[Inst] = true
        end
    end

    for Inst in self._VTreeExpanded do
        if not TargetSet[Inst] then
            local Cursor = Inst
            local Safety = 0
            while Cursor and Safety < 128 do
                local Good, Parent = pcall(function() return Cursor.Parent end)
                Cursor = Good and Parent or nil
                if Cursor and TargetSet[Cursor] then
                    self._VTreeExpanded[Inst] = nil
                    break
                end
                Safety += 1
            end
        end
    end

    self._VTreeSuppressFilterRebuild = true

    local Collapsed = 0
    for _, Inst in Targets do
        local Idx = self._VTreeRowsByInstance[Inst]
        if Idx then
            local Row = self._VTreeRows[Idx]
            if Row and Row.Expanded then
                self:_VTreeCollapse(Row)
                Collapsed += 1
            end
        end
    end

    self._VTreeSuppressFilterRebuild = false

    if self._VTreeFilterActive then
        self:_VTreeBuildFiltered()
    end

    self:_VTreeUpdateCanvasSize()
    self:_VTreeInvalidateVisibleCache()
    self:_VTreeScheduleRebuild()

    return Collapsed
end

function Explorer:CollapseAllRoots()
    local Collapsed = 0
    self._VTreeSuppressFilterRebuild = true

    local TopLevel = {}
    for _, Row in self._VTreeRows do
        if Row.Depth == 0 and Row.Expanded and Row.Instance then
            TopLevel[#TopLevel + 1] = Row.Instance
        end
    end

    for _, Inst in TopLevel do
        local Idx = self._VTreeRowsByInstance[Inst]
        if Idx then
            local Row = self._VTreeRows[Idx]
            if Row and Row.Expanded then
                self:_VTreeCollapse(Row)
                Collapsed += 1
            end
        end
    end

    self._VTreeExpanded = {}
    self._VTreeSuppressFilterRebuild = false

    if self._VTreeFilterActive then
        self:_VTreeBuildFiltered()
    end

    self:_VTreeUpdateCanvasSize()
    self:_VTreeInvalidateVisibleCache()
    self:_VTreeScheduleRebuild()

    return Collapsed
end

function Explorer:ShowNotification(Title, Message, Variant)
    if not self.ScreenGui then
        return
    end

    Variant = Variant or "info"

    local AccentColor = Variant == "error" and Color3.fromRGB(255, 70, 70) or Theme.Accent

    if not self.NotificationHolder then
        self.NotificationHolder = VexUI:CreateInstance("Frame", {
            Name = "Notifications";
            Size = UDim2.new(0, 320, 1, -20);
            Position = UDim2.new(1, -330, 0, 10);
            BackgroundTransparency = 1;
            ZIndex = 300;
            Parent = self.ScreenGui;
        })
        local Layout = VexUI:AddListLayout(self.NotificationHolder, 6, Enum.FillDirection.Vertical)
        Layout.HorizontalAlignment = Enum.HorizontalAlignment.Right
        Layout.VerticalAlignment = Enum.VerticalAlignment.Bottom
    end

    local Card = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 0);
        AutomaticSize = Enum.AutomaticSize.Y;
        BackgroundColor3 = Theme.Window;
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        ZIndex = 300;
        Parent = self.NotificationHolder;
    })
    
    local CardStroke = VexUI:AddStroke(Card, AccentColor, 1)
    CardStroke.Transparency = 1
    VexUI:AddPadding(Card, 9, 12, 9, 12)
    VexUI:AddListLayout(Card, 3, Enum.FillDirection.Vertical)

    local TitleLabel = VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 14);
        BackgroundTransparency = 1;
        Font = Fonts.Bold;
        Text = (Title or "VEX"):upper();
        TextColor3 = AccentColor;
        TextSize = 11;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextTransparency = 1;
        ZIndex = 301;
        LayoutOrder = 1;
        Parent = Card;
    })

    local Detail = VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 0);
        AutomaticSize = Enum.AutomaticSize.Y;
        BackgroundTransparency = 1;
        Font = Fonts.Medium;
        Text = Message or "";
        TextColor3 = Theme.Text;
        TextSize = 11;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextYAlignment = Enum.TextYAlignment.Top;
        TextWrapped = true;
        TextTransparency = 1;
        ZIndex = 301;
        LayoutOrder = 2;
        Parent = Card;
    })

    VexUI:Tween(Card, {BackgroundTransparency = 0.05})
    VexUI:Tween(CardStroke, {Transparency = 0})
    VexUI:Tween(TitleLabel, {TextTransparency = 0})
    VexUI:Tween(Detail, {TextTransparency = 0})

    local Lifetime = Variant == "error" and 5 or 2.2
    task.delay(Lifetime, function()
        if not Card or not Card.Parent then
            return
        end

        local FadeInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        VexUI:Tween(Card, {BackgroundTransparency = 1}, FadeInfo)
        VexUI:Tween(CardStroke, {Transparency = 1}, FadeInfo)
        VexUI:Tween(TitleLabel, {TextTransparency = 1}, FadeInfo)
        VexUI:Tween(Detail, {TextTransparency = 1}, FadeInfo)

        task.wait(0.3)

        if Card and Card.Parent then
            Card:Destroy()
        end
    end)
end

function Explorer:ShowErrorNotification(Message)
    self:ShowNotification("VEX ERROR", Message or "Unknown error", "error")
end

function Explorer:Notify(Message)
    self:ShowNotification("VEX", Message, "success")
    --print(`VEX {Message} success`)
end

function Explorer:SerializeColor(Color)
    return {
        math.floor(Color.R * 255 + 0.5);
        math.floor(Color.G * 255 + 0.5);
        math.floor(Color.B * 255 + 0.5);
    }
end

function Explorer:DeserializeColor(Data)
    if typeof(Data) ~= "table" or #Data < 3 then
        return nil
    end

    return Color3.fromRGB(Data[1], Data[2], Data[3])
end

function Explorer:BuildConfigData()
    local ThemeData = {}
    for Key, Value in Theme do
        if typeof(Value) == "Color3" then
            ThemeData[Key] = self:SerializeColor(Value)
        end
    end

    local ClassFilterList = {}
    for Class in self.ActiveClassFilters do
        table.insert(ClassFilterList, Class)
    end

    local HiddenServiceList = {}
    for HiddenService in self.HiddenServices do
        table.insert(HiddenServiceList, HiddenService)
    end

    local TransparencyData = {}
    for Key, Value in UITransparency do
        TransparencyData[Key] = Value
    end

    local FontData = {}
    for K, V in Fonts do
        FontData[K] = V.Name
    end

    return {
        Version = self.Version;
        ToggleKey = self.ToggleKey.Name;
        AutoRefreshProperties = self.AutoRefreshProperties;
        RefreshDelay = self.RefreshDelay;
        UseLuaExpertDecompiler = self.UseLuaExpertDecompiler;
        NilFilterClass = (self.NilFilterClass or ""):gsub("^%s+", ""):gsub("%s+$", "");
        ActiveClassFilters = ClassFilterList;
        HiddenServices = HiddenServiceList;
        HideNilContainer = self.HideNilContainer;
        SearchIncludesNil = self.SearchIncludesNil ~= false;
        ThemePresetName = self.ThemePresetName or "Custom";
        Theme = ThemeData;
        UITransparency = TransparencyData;
        UnlimitedFPS = self.UnlimitedFPS;
        MatchByClassName = self.MatchByClassName == true;
        MatchByProperty = self.MatchByProperty == true;
        FlatSearchResults = self.FlatSearchResults == true;
        ClassIcon = self.ClassIcon or "NewDark";
        PinnedPaths = self.PinnedPaths or {};
    }
end

function Explorer:ApplyConfigData(Data)
    if typeof(Data) ~= "table" then
        return
    end

    if typeof(Data.ToggleKey) == "string" then
        local KeyCode = Enum.KeyCode[Data.ToggleKey]
        if KeyCode then
            self.ToggleKey = KeyCode
        end
    end

    if typeof(Data.UnlimitedFPS) == "boolean" then
        self.UnlimitedFPS = Data.UnlimitedFPS
    end

    ApplyFPSCap(self.UnlimitedFPS)

    if typeof(Data.AutoRefreshProperties) == "boolean" then
        self.AutoRefreshProperties = Data.AutoRefreshProperties
    end

    if typeof(Data.RefreshDelay) == "number" then
        self.RefreshDelay = math.clamp(Data.RefreshDelay, 0, 3)
    end

    if typeof(Data.NilFilterClass) == "string" then
        self.NilFilterClass = Data.NilFilterClass:gsub("^%s+", ""):gsub("%s+$", "")
    end

    if typeof(Data.ActiveClassFilters) == "table" then
        self.ActiveClassFilters = {}
        for _, Class in Data.ActiveClassFilters do
            if typeof(Class) == "string" then
                self.ActiveClassFilters[Class] = true
            end
        end
    end

    if typeof(Data.HiddenServices) == "table" then
        self.HiddenServices = {}
        for _, HiddenService in Data.HiddenServices do
            if typeof(HiddenService) == "string" then
                self.HiddenServices[HiddenService] = true
            end
        end
    end

    if typeof(Data.Fonts) == "table" then
        for Key, Name in Data.Fonts do
            if Fonts[Key] and typeof(Name) == "string" then
                local Good, FontEnum = pcall(function() return Enum.Font[Name] end)
                if Good and FontEnum then
                    Fonts[Key] = FontEnum
                end
            end
        end
    end

    if typeof(Data.PinnedPaths) == "table" then
        self.PinnedPaths = {}
        for _, P in Data.PinnedPaths do
            if typeof(P) == "string" then
                table.insert(self.PinnedPaths, P)
            end
        end
    end

    if typeof(Data.MatchByClassName) == "boolean" then
        self.MatchByClassName = Data.MatchByClassName
    end

    if typeof(Data.FlatSearchResults) == "boolean" then
        self.FlatSearchResults = Data.FlatSearchResults
    end

    if typeof(Data.ClassIcon) == "string" and table.find(ClassIconThemes, Data.ClassIcon) then
        self.ClassIcon = Data.ClassIcon
    end

    if typeof(Data.MatchByProperty) == "boolean" then
        self.MatchByProperty = Data.MatchByProperty
    end

    if typeof(Data.HideNilContainer) == "boolean" then
        self.HideNilContainer = Data.HideNilContainer
    end

    if typeof(Data.SearchIncludesNil) == "boolean" then
        self.SearchIncludesNil = Data.SearchIncludesNil
    else
        self.SearchIncludesNil = true
    end

    if typeof(Data.UseLuaExpertDecompiler) == "boolean" then
        self.UseLuaExpertDecompiler = Data.UseLuaExpertDecompiler
    end

    if typeof(Data.Theme) == "table" then
        InBatchSave = true

        for Key, Encoded in Data.Theme do
            local Color = self:DeserializeColor(Encoded)
            if Color then
                SetThemeColor(Key, Color)
            end
        end

        InBatchSave = false
    end

    if typeof(Data.ThemePresetName) == "string" then
        self.ThemePresetName = Data.ThemePresetName
    else
        self.ThemePresetName = "Custom"
    end

    if typeof(Data.UITransparency) == "table" then
        InBatchSave = true

        for Key, Value in Data.UITransparency do
            if UITransparency[Key] ~= nil and typeof(Value) == "number" then
                SetUITransparency(Key, Value)
            end
        end

        InBatchSave = false
    end
end

function Explorer:SaveConfig()
    if not self.ConfigLoaded then
        return
    end

    Handle(function()
        if not (writefile and isfolder and makefolder) then
            return
        end

        if not isfolder(self.ConfigFolder) then
            makefolder(self.ConfigFolder)
        end

        local Encoded = Services.HttpService:JSONEncode(self:BuildConfigData())
        writefile(self.ConfigPath, BeautifyJson(Encoded))
    end, "SaveConfig")
end

SaveConfigDeferred = function()
    if Explorer.ConfigLoaded then
        Explorer:SaveConfig()
    end
end

function Explorer:FetchVersion()
    local Good, Result = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Vezise/2026/main/Vez/VexExplorer/VexVersion.lua"))()
    end)

    if not Good or typeof(Result) ~= "string" then
        return nil
    end

    local Cleaned = Result:gsub("%s+", "")

    return Cleaned ~= "" and Cleaned or nil
end

function Explorer:InitConfig()
    Handle(function()
        local RemoteVersion = self:FetchVersion()
        self.Version = RemoteVersion or "unknown"

        local Info = {Version = self.Version}
        local Data = nil

        if not (isfile and writefile and readfile and isfolder and makefolder) then
            self.ConfigLoaded = true

            return
        end

        if not isfolder(self.ConfigFolder) then
            makefolder(self.ConfigFolder)
        end

        if not isfile(self.ConfigPath) then
            writefile(self.ConfigPath, BeautifyJson(Services.HttpService:JSONEncode(Info)))
        else
            local ReadGood, RawText = pcall(readfile, self.ConfigPath)
            if ReadGood then
                local DecodeGood, Decoded = pcall(function()
                    return Services.HttpService:JSONDecode(RawText)
                end)

                if DecodeGood then
                    Data = Decoded
                end
            end

            if Data and Data.Version ~= self.Version then
                local OldVersion = Data.Version
                Data.Version = self.Version
                task.delay(3, function()
                    self:ShowNotification(`NEW UPDATE!`, `VEX has updated to {Data.Version}`, "info")
                end)

                pcall(writefile, self.ConfigPath, BeautifyJson(Services.HttpService:JSONEncode(Data)))
            end
        end

        if Data then
            self:ApplyConfigData(Data)
        end

        self.HideNilContainer = true

        for _, Name in RiskyServices do
            self.HiddenServices[Name] = true
        end

        self.ConfigLoaded = true
        ApplyFPSCap(self.UnlimitedFPS)
        self:SaveConfig()
    end, "InitConfig")
end

function Explorer:Kill()
    KillScript = true
    VexExecutedCheck = true

    for _, Connection in Connections do
        pcall(function()
            Connection:Disconnect()
        end)
    end
    Connections = {}

    CompactConnections()
    self:_StopClickPartToSelect()
    self:_StopClickUiToSelect()
    self:ClearPropertyConnections()
    self:ResetTasks()

    self:StopViewObject()

    for _, Highlight in self.SelectionHighlights or {} do
        pcall(function()
            Highlight:Destroy()
        end)
    end
    self.SelectionHighlights = setmetatable({}, {__mode = "k"})

    if self.ScriptViewerWindows then
        for _, Item in self.ScriptViewerWindows do
            if Item.Window and Item.Window.Parent then
                Item.Window:Destroy()
            end
        end
        self.ScriptViewerWindows = {}
    end


    pcall(function()
        if self.NotificationHolder then
            self.NotificationHolder:Destroy()
        end
    end)

    pcall(function()
        if self.ScreenGui then
            self.ScreenGui:Destroy()
        end
    end)

    self.SelectedSet = setmetatable({}, {__mode = "k"})
    self.SelectedOrder = {}
    self.SelectedInstance = nil
end

function Explorer:SetWindowsVisible(Visible)
    if self.ExplorerWindow then
        self.ExplorerWindow:SetVisible(Visible)
    end

    if self.PropertiesWindow then
        self.PropertiesWindow:SetVisible(Visible)
    end
end

function ExplorerClass:Create()
    Handle(function()
        self:InitConfig()
        self:InitClassIcons()
        self.ScreenGui = VexUI:CreateScreenGui()

        self.MatchSet = {}
        self.SubtreeMatchSet = {}
        self.SelectedSet = setmetatable({}, {__mode = "k"})

        self:BuildQuickAccessBar()
        self:BuildExplorerWindow()
        self:BuildPropertiesWindow()

        self:CreateSearchBar()
        self:CreatePropertyFilterBar()

        self:RebuildExplorer()
        self:AddPropertiesLabel("Select an instance.")

        self:_EnsureConsoleLog()

        BindTheme("Accent", function(Color)
            for _, Highlight in Explorer.SelectionHighlights or {} do
                if Highlight and Highlight.Parent then
                    Highlight.OutlineColor = Color
                end
            end
        end)

        self:SetupDragHandlers()
    end, "Function Explorer.Create")
end

Explorer:Create()

Track(Services.UserInputService.InputBegan:Connect(function(Input, GameProcessed)
    local Focused = Services.UserInputService:GetFocusedTextBox()

    if Focused then
        return
    end

    if Input.KeyCode == Enum.KeyCode.LeftControl
        or Input.KeyCode == Enum.KeyCode.RightControl
    then
        Explorer.CtrlHeld = true
    end

    if Input.KeyCode == Enum.KeyCode.LeftShift
        or Input.KeyCode == Enum.KeyCode.RightShift
    then
        Explorer.ShiftHeld = true
    end

    if Input.KeyCode == Enum.KeyCode.Escape and Explorer.ReparentMode then
        Explorer:CancelReparent()

        return
    end

    if GameProcessed then
        return
    end

    if Input.UserInputType ~= Enum.UserInputType.Keyboard then
        return
    end

    if Input.KeyCode ~= Explorer.ToggleKey then
        return
    end

    Explorer.WindowVisible = not Explorer.WindowVisible
    Explorer:SetWindowsVisible(Explorer.WindowVisible)
end))

Track(Services.UserInputService.InputEnded:Connect(function(Input)
    local Focused = Services.UserInputService:GetFocusedTextBox()

    if Focused then
        return
    end

    if Input.KeyCode == Enum.KeyCode.LeftControl
        or Input.KeyCode == Enum.KeyCode.RightControl
    then
        Explorer.CtrlHeld = false
    end

    if Input.KeyCode == Enum.KeyCode.LeftShift
        or Input.KeyCode == Enum.KeyCode.RightShift
    then
        Explorer.ShiftHeld = false
    end
end))

Explorer:SpawnTask("AutoRefreshProperties", function()
    while true do
        if KillScript then
            break
        end

        if Explorer.RefreshDelay <= 0 then
            Services.RunService.Heartbeat:Wait()
        else
            task.wait(Explorer.RefreshDelay)
        end

        if KillScript then
            break
        end

        if Explorer.AutoRefreshProperties and Explorer.SelectedInstance then
            Handle(function()
                Explorer:RefreshPropertyValues()
            end, "AutoRefreshProperties Tick")
        end
    end
end)

Explorer:SpawnTask("ConnectionsCompact", function()
    while not KillScript do
        task.wait(600)

        if KillScript then
            break
        end

        CompactConnections()
    end
end)

Explorer:SpawnTask("ScriptExecutedAgainCheck", function()
    VexExecutedCheck = true
    while not KillScript do
        task.wait()

        if KillScript then
            break
        end

        if VexExecutedCheck == false then
            Explorer:Kill()
            
            break
        end
    end
end)