getgenv().VexExecutedCheck = false

local RiskyServices = {
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
    "EncodingService";
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
    CollectionService = GetService("CollectionService");
    GuiService = GetService("GuiService");
}

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
    Flag = true; FlagStand = true; Folder = true; Frame = true; Highlight = true;
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

local ClassToAsset = {
    Workspace = "Workspace"; Terrain = "Terrain";
    Players = "Players"; Player = "Player";
    Lighting = "Lighting";
    ReplicatedFirst = "ReplicatedFirst"; ReplicatedStorage = "ReplicatedStorage";
    StarterPlayer = "StarterPlayer";
    StarterPlayerScripts = "Folder"; StarterCharacterScripts = "Folder";
    StarterPack = "Backpack"; StarterGui = "StarterGui";
    CoreGui = "CoreGui"; PlayerGui = "ScreenGui";
    ServerScriptService = "Folder"; ServerStorage = "Folder";
    SoundService = "Sound";
    Chat = "Chat"; TextChatService = "TextChatService";
    Teams = "Teams"; Team = "Team";
    TestService = "TestService";
    InsertService = "InsertService"; JointsService = "JointsService";
    NetworkClient = "NetworkClient";
    Folder = "Folder"; Configuration = "Configuration";
    Backpack = "Backpack"; Model = "Model";
    Part = "Part"; MeshPart = "MeshPart"; UnionOperation = "UnionOperation";
    WedgePart = "Part"; CornerWedgePart = "Part"; TrussPart = "Part";
    SpawnLocation = "SpawnLocation";
    Seat = "Seat"; VehicleSeat = "Seat";
    Script = "Script"; LocalScript = "LocalScript"; ModuleScript = "ModuleScript";
    Camera = "Camera";
    Humanoid = "Humanoid"; HumanoidDescription = "Humanoid";
    HumanoidRootPart = "Part";
    Animation = "AnimationTrack"; AnimationTrack = "AnimationTrack";
    Animator = "AnimationTrack"; AnimationController = "AnimationTrack";
    KeyframeSequence = "AnimationTrack"; Keyframe = "AnimationTrack";
    Tool = "Tool"; HopperBin = "Tool";
    Accessory = "Accessory"; Hat = "Accessory";
    Shirt = "Shirt"; Pants = "Pants";
    ShirtGraphic = "TShirt"; TShirt = "TShirt";
    BodyColors = "Configuration"; CharacterMesh = "MeshPart";
    Decal = "Texture"; Texture = "Texture";
    SurfaceGui = "SurfaceGui"; ScreenGui = "ScreenGui"; BillboardGui = "ScreenGui";
    Frame = "Frame"; ScrollingFrame = "Frame";
    TextLabel = "TextLabel"; TextButton = "TextButton"; TextBox = "TextLabel";
    ImageLabel = "ImageLabel"; ImageButton = "ImageButton";
    VideoFrame = "ImageFrame";
    UICorner = "Frame"; UIStroke = "Frame"; UIPadding = "Frame";
    UIListLayout = "UIListLayout"; UIGridLayout = "UIListLayout";
    UIScale = "Frame"; UIAspectRatioConstraint = "Frame";
    Sound = "Sound"; SoundGroup = "Sound";
    Attachment = "Attachment";
    Weld = "Weld"; WeldConstraint = "Weld"; Snap = "Weld";
    Motor6D = "Motor6D";
    BallSocketConstraint = "HingeConstraint"; HingeConstraint = "HingeConstraint";
    RopeConstraint = "HingeConstraint"; SpringConstraint = "HingeConstraint";
    RodConstraint = "HingeConstraint"; PrismaticConstraint = "HingeConstraint";
    RemoteEvent = "RemoteEvent"; RemoteFunction = "RemoteFunction";
    UnreliableRemoteEvent = "RemoteEvent";
    BindableEvent = "BindableEvent"; BindableFunction = "BindableFunction";
    StringValue = "StringValue";
    IntValue = "NumberValue"; NumberValue = "NumberValue";
    BoolValue = "NumberValue"; ObjectValue = "NumberValue";
    CFrameValue = "NumberValue"; Vector3Value = "NumberValue";
    Color3Value = "NumberValue"; BrickColorValue = "NumberValue";
    RayValue = "NumberValue";
    ParticleEmitter = "ParticleEffect"; Beam = "ParticleEffect";
    Trail = "ParticleEffect"; Sparkles = "ParticleEffect";
    Fire = "Fire"; Smoke = "Smoke"; Explosion = "Explosion";
    PointLight = "Lighting"; SpotLight = "Lighting"; SurfaceLight = "Lighting";
    Atmosphere = "Sky"; Sky = "Sky"; Clouds = "Sky";
    BloomEffect = "ColorCorrectionEffect"; BlurEffect = "ColorCorrectionEffect";
    ColorCorrectionEffect = "ColorCorrectionEffect";
    DepthOfFieldEffect = "ColorCorrectionEffect";
    SunRaysEffect = "ColorCorrectionEffect";
    BodyVelocity = "BodyVelocity"; BodyPosition = "BodyVelocity";
    BodyGyro = "BodyVelocity"; BodyAngularVelocity = "BodyVelocity";
    BodyForce = "BodyVelocity"; BodyThrust = "BodyVelocity";
    AlignPosition = "BodyVelocity"; AlignOrientation = "BodyVelocity";
    VectorForce = "BodyVelocity"; Torque = "BodyVelocity"; LineForce = "BodyVelocity";
    Dialog = "Chat"; DialogChoice = "Chat";
    ClickDetector = "ClickDetector"; ProximityPrompt = "ClickDetector";
    Highlight = "Highlight"; SelectionBox = "Selection";
    BoxHandleAdornment = "BoxHandleAdornment";
    ConeHandleAdornment = "ConeHandleAdornment";
    CylinderHandleAdornment = "CylinderHandleAdornment";
    SphereHandleAdornment = "SphereHandleAdornment";
    LineHandleAdornment = "LineHandleAdornment";
    ImageHandleAdornment = "ImageHandleAdornment";
    TouchInterest = "TouchInterest";
    FlagStand = "FlagStand"; Flag = "Flag";
}

local AssetCache = {}
local AssetsEnabled =
    (getcustomasset or false)
    and (writefile or false)
    and (readfile or false)
    and (isfile or false)
    and (makefolder or false)
    and (isfolder or false)

local function EnsureAssetFolders()
    if not AssetsEnabled then
        return
    end

    if not isfolder(AssetFolder) then
        makefolder(AssetFolder)
    end

    if not isfolder(AssetsSubFolder) then
        makefolder(AssetsSubFolder)
    end
end

local function DownloadAsset(AssetName)
    if not AssetsEnabled then
        return nil
    end

    local Path = `{AssetsSubFolder}/{AssetName}.png`
    if isfile(Path) then
        return Path
    end

    local Good, Result = pcall(function()
        if request then
            local Response = request({
                Url = `{AssetBaseURL}/{AssetName}.png`;
                Method = "GET";
            })

            if Response and Response.StatusCode == 200 and Response.Body then
                return Response.Body
            end

            return nil
        end

        -- why does your exec not support request :rofl:
    end)

    if not Good
        or #Result == 0
    then
        return nil
    end

    local WriteGood = pcall(writefile, Path, Result)
    if not WriteGood then
        return nil
    end

    return Path
end

local function GetClassAssetId(ClassName)
    if not AssetsEnabled then
        return nil
    end

    if type(ClassName) ~= "string" or ClassName == "" then
        ClassName = "Instance"
    end

    if AssetCache[ClassName] ~= nil then
        return AssetCache[ClassName] or nil
    end

    local AssetName = ClassToAsset[ClassName]
    if not AssetName or not AvailableAssets[AssetName] then
        AssetName = "Unspecified"
    end

    EnsureAssetFolders()

    local Path = DownloadAsset(AssetName)
    if not Path then
        AssetCache[ClassName] = false
        return nil
    end

    local Good, AssetId = pcall(getcustomasset, Path)
    if Good and AssetId ~= "" then
        AssetCache[ClassName] = AssetId
        return AssetId
    end

    AssetCache[ClassName] = false
    return nil
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

        local Seen = {}
        for _, AssetName in ClassToAsset do
            if not Seen[AssetName] and AvailableAssets[AssetName] then
                Seen[AssetName] = true
                pcall(DownloadAsset, AssetName)
            end
        end

        pcall(DownloadAsset, "CloseIcon")
        pcall(DownloadAsset, "Console Icon")
        pcall(DownloadAsset, "SearchIcon")
        pcall(DownloadAsset, "SettingsIcon")
        pcall(DownloadAsset, "Unspecified")
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

local function CollectProperties(Object)
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

local function GetGlobalCallable(Name)
    local Env = nil

    pcall(function()
        if getgenv then
            Env = getgenv()
        end
    end)

    Env = Env or _G

    local Fn = Env and Env[Name]
    if type(Fn) == "function" then
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
        return self.SelectedInstance
    end

    return nil
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
                    };
                };
            };
            {
                "Move";
                "void";
                {
                    {
                        "direction";
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
                };
            };
            {
                "UnequipTools";
                "void";
                {};
            };
            {
                "GetState";
                "EnumItem";
                {};
            };
            {
                "BuildRigFromAttachments";
                "void";
                {};
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

                if IsGlobal and not GetGlobalCallable(MethodName) then
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
    table.insert(ThemeBindings[ThemeKey], Apply)
    Apply(Theme[ThemeKey])
end

local function SetThemeColor(ThemeKey, NewColor)
    Theme[ThemeKey] = NewColor

    local Bindings = ThemeBindings[ThemeKey]
    if Bindings then
        for _, Apply in Bindings do
            pcall(Apply, NewColor)
        end
    end

    if not InBatchSave then
        MarkThemeCustom()
    end

    if SaveConfigDeferred and not InBatchSave then
        pcall(SaveConfigDeferred)
    end
end

local function ClampTransparency(Value)
    return math.clamp(tonumber(Value) or 0, 0, 0.95)
end

local function BindTransparency(Key, Apply)
    TransparencyBindings[Key] = TransparencyBindings[Key] or {}
    table.insert(TransparencyBindings[Key], Apply)
    Apply(UITransparency[Key] or 0)
end

local ApplyingPreset = false

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

local function SetUITransparency(Key, Value)
    UITransparency[Key] = ClampTransparency(Value)

    local Bindings = TransparencyBindings[Key]
    if Bindings then
        for _, Apply in Bindings do
            pcall(Apply, UITransparency[Key])
        end
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

local Fonts = {
    Bold = Enum.Font.GothamBold;
    SemiBold = Enum.Font.GothamSemibold;
    Medium = Enum.Font.GothamMedium;
    Regular = Enum.Font.Gotham;
    Mono = Enum.Font.RobotoMono;
    Code = Enum.Font.Code;
    Heading = Enum.Font.Ubuntu;
}

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
    local AssetId = GetClassAssetId(ClassName)
    if AssetId then
        return self:CreateInstance("ImageLabel", {
            Size = UDim2.new(0, 16, 0, 16);
            BackgroundTransparency = 1;
            Image = AssetId;
            ScaleType = Enum.ScaleType.Fit;
            ImageColor3 = Color3.fromRGB(255, 255, 255);
            Parent = Parent;
        })
    end

    return self:CreateInstance("TextLabel", {
        Size = UDim2.new(0, 16, 0, 16);
        BackgroundTransparency = 1;
        Font = Fonts.Mono;
        Text = "?";
        TextColor3 = Theme.TextDim;
        TextSize = 11;
        Parent = Parent;
    })
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

    NodesByInstance = {};
    RootNodes = {};

    SearchQuery = "";
    PropertyFilter = "";
    ForcedExpanded = {};

    ToggleKey = Enum.KeyCode.RightAlt;
    WindowVisible = true;
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
}, ExplorerClass)

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

function Explorer:FullPath()
    local Target = self.SelectedInstance
    if not Target then
        return
    end

    local Path = self:GetInstancePath(Target)
    if Path == "" then
        return
    end

    return Path
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

function Explorer:CreateNodeRow(Node, RowParent)
    local IndentOffset = 6 + Node.Depth * 14

    local Row = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 0, 22);
        BackgroundColor3 = Theme.Selected;
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Text = "";
        Parent = RowParent;
    })
    BindTheme("Selected", function(Color)
        Row.BackgroundColor3 = Color
    end)

    local SelectionAccent = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(0, 2, 1, -6);
        Position = UDim2.new(0, 0, 0, 3);
        BackgroundColor3 = Theme.SelectionBar;
        BorderSizePixel = 0;
        Visible = false;
        Parent = Row;
    })
    BindTheme("SelectionBar", function(Color)
        SelectionAccent.BackgroundColor3 = Color
    end)

    local Arrow = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(0, 16, 1, 0);
        Position = UDim2.new(0, IndentOffset, 0, 0);
        BackgroundTransparency = 1;
        AutoButtonColor = false;
        Font = Fonts.Bold;
        Text = "";
        TextColor3 = Theme.TextDim;
        TextSize = 11;
        Parent = Row;
    })

    BindTheme("TextDim", function(Color)
        if Arrow and Arrow.Parent then
            Arrow.TextColor3 = Color
        end
    end)

    local GoodClass, ClassName = pcall(function()
        return Node.Instance.ClassName
    end)

    if not GoodClass or type(ClassName) ~= "string" or ClassName == "" then
        ClassName = "Instance"
    end

    local GoodName, InstanceName = pcall(function()
        return Node.Instance.Name
    end)

    if not GoodName or type(InstanceName) ~= "string" or InstanceName == "" then
        InstanceName = "?"
    end

    local Icon = VexUI:CreateClassIcon(ClassName, Row)
    Icon.Position = UDim2.new(0, IndentOffset + 18, 0.5, -8)

    local Label = VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, -(IndentOffset + 42), 1, 0);
        Position = UDim2.new(0, IndentOffset + 40, 0, 0);
        BackgroundTransparency = 1;
        Font = Node.Depth == 0 and Fonts.SemiBold or Fonts.Medium;
        Text = InstanceName;
        TextColor3 = Theme.Text;
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextTruncate = Enum.TextTruncate.AtEnd;
        Parent = Row;
    })

    BindTheme("Text", function(Color)
        if Label and Label.Parent then
            Label.TextColor3 = Color
        end
    end)

    Node.Row = Row
    Node.Arrow = Arrow
    Node.Icon = Icon
    Node.Label = Label
    Node.SelectionAccent = SelectionAccent

    local function RefreshNodeTheme()
        if Arrow and Arrow.Parent then
            Arrow.TextColor3 = Theme.TextDim
        end

        if Label and Label.Parent then
            Label.TextColor3 = Theme.Text
        end

        if Row and Row.Parent then
            Row.BackgroundColor3 = Theme.Selected
        end

        if SelectionAccent and SelectionAccent.Parent then
            SelectionAccent.BackgroundColor3 = Theme.SelectionBar
        end

        if Node and Node.Instance then
            self:UpdateNodeVisual(Node.Instance)
        end
    end

    BindTheme("Text", RefreshNodeTheme)
    BindTheme("TextDim", RefreshNodeTheme)
    BindTheme("Selected", RefreshNodeTheme)
    BindTheme("SelectionBar", RefreshNodeTheme)
    BindTheme("Accent", RefreshNodeTheme)

    self:UpdateArrow(Node)
    self:UpdateNodeVisual(Node.Instance)

    Node.Connections = Node.Connections or {}

    table.insert(Node.Connections, Track(Row.MouseEnter:Connect(function()
        if self.SelectedSet[Node.Instance] then
            return
        end

        VexUI:Tween(Row, {BackgroundTransparency = 0.7})
    end)))

    table.insert(Node.Connections, Track(Row.MouseLeave:Connect(function()
        if self.SelectedSet[Node.Instance] then
            return
        end

        VexUI:Tween(Row, {BackgroundTransparency = 1})
    end)))

    local LastClickAt = 0
    table.insert(Node.Connections, Track(Row.MouseButton1Click:Connect(function()
        if self._JustDragged then
            return
        end

        if self.ReparentMode then
            self:CommitReparent(Node.Instance)

            return
        end

        local Now = os.clock()
        if Now - LastClickAt < 0.35 then
            LastClickAt = 0
            self:HandleDoubleClick(Node)

            return
        end
        LastClickAt = Now

        if self.ShiftHeld and self.SelectionAnchor then
            self:RangeSelect(self.SelectionAnchor, Node.Instance)
        elseif self.CtrlHeld then
            self:ToggleInSelection(Node.Instance)
            self.SelectionAnchor = Node.Instance
        else
            self:SetSelection({Node.Instance})
            self.SelectionAnchor = Node.Instance
        end
    end)))

    table.insert(Node.Connections, Track(Arrow.MouseButton1Click:Connect(function()
        if self._JustDragged then
            return
        end

        self:ToggleNode(Node)
    end)))

    table.insert(Node.Connections, Track(Row.MouseButton2Click:Connect(function()
        if not self.SelectedSet[Node.Instance] then
            self:SetSelection({Node.Instance})
            self.SelectionAnchor = Node.Instance
        end

        local Mouse = self.LocalPlayer:GetMouse()
        self:OpenContextMenu(Mouse.X, Mouse.Y)
    end)))

    table.insert(Node.Connections, Track(Row.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            self.DragOperation = {
                StartX = Input.Position.X;
                StartY = Input.Position.Y;
                Started = false;
                Source = Node.Instance;
                SourceName = SafeGet(Node.Instance, "Name") or "?";
            }
        end
    end)))

    table.insert(Node.Connections, Track(Row.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton3 then
            self:ToggleViewObject(Node.Instance)
        end
    end)))

    local function ScheduleSearchRefresh()
        if self.SearchQuery == "" then
            return
        end

        self._RefreshDebounceToken = (self._RefreshDebounceToken or 0) + 1
        local Token = self._RefreshDebounceToken

        task.delay(0.4, function()
            if Token ~= self._RefreshDebounceToken then
                return
            end

            if KillScript then
                return
            end

            self:RefreshAllSearchFilters()
        end)
    end

    local NameSignalGood, NameSignal = pcall(function()
        return Node.Instance:GetPropertyChangedSignal("Name")
    end)

    if NameSignalGood and NameSignal then
        table.insert(Node.Connections, Track(NameSignal:Connect(function()
            local GoodNewName, NewName = pcall(function()
                return Node.Instance.Name
            end)

            if not GoodNewName or type(NewName) ~= "string" then
                NewName = "?"
            end

            if Node.Label and Node.Label.Parent then
                Node.Label.Text = NewName
            end

            if self.SearchQuery ~= ""
                and NewName:lower():find(self.SearchQuery, 1, true)
            then
                ScheduleSearchRefresh()
            end
        end)))
    end

    Node._ConnectChildSignals = function()
        if Node._ChildAddedConn then
            return
        end

        local Good, Connection = pcall(function()
            return Node.Instance.ChildAdded:Connect(function(RawChild)
                if typeof(RawChild) ~= "Instance" then
                    return
                end

                local Child = ClonerefInstance(RawChild)

                self:UpdateArrow(Node)

                if Node.Expanded then
                    if self.SearchQuery == ""
                        or self.MatchSet[Child]
                        or self.SubtreeMatchSet[Child]
                    then
                        self:CreateChildNode(Node, Child, self:GetNextChildLayoutOrder(Node))
                    end
                end

                if self.SearchQuery ~= "" then
                    local GoodChildName, ChildName = pcall(function()
                        return Child.Name
                    end)

                    if GoodChildName
                        and type(ChildName) == "string"
                        and ChildName:lower():find(self.SearchQuery, 1, true)
                    then
                        ScheduleSearchRefresh()
                    end
                end
            end)
        end)

        if Good and Connection then
            Node._ChildAddedConn = Connection
            table.insert(Node.Connections, Track(Connection))
        end
        
        local Good2, Connection2 = pcall(function()
            return Node.Instance.ChildRemoved:Connect(function(RawChild)
                if typeof(RawChild) ~= "Instance" then
                    return
                end

                local Child = ClonerefInstance(RawChild)

                self:UpdateArrow(Node)

                local ChildNode = self.NodesByInstance[Child]
                if ChildNode and ChildNode.Parent == Node then
                    self:DestroyNode(ChildNode)
                end
            end)
        end)

        if Good2 and Connection2 then
            Node._ChildRemovedConn = Connection2
            table.insert(Node.Connections, Track(Connection2))
        end
    end

    Node._DisconnectChildSignals = function()
        if Node._ChildAddedConn then
            pcall(function()
                Node._ChildAddedConn:Disconnect()
            end)

            Node._ChildAddedConn = nil
        end
        if Node._ChildRemovedConn then
            pcall(function()
                Node._ChildRemovedConn:Disconnect()
            end)

            Node._ChildRemovedConn = nil
        end
    end
end

function Explorer:UpdateArrow(Node)
    if not Node.Arrow then
        return
    end

    local HasChildren
    if Node.IsNilContainer then
        HasChildren = true
    else
        local Good, Children = pcall(function()
            return Node.Instance:GetChildren()
        end)

        HasChildren = Good and #Children > 0
    end

    if HasChildren then
        Node.Arrow.Text = Node.Expanded and "-" or "+"
        Node.Arrow.TextSize = 14
        Node.Arrow.TextColor3 = Theme.TextDim
    else
        Node.Arrow.Text = ""
    end
end

function Explorer:BuildNodeContainer(ParentFrame, Order)
    local Container = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 0);
        AutomaticSize = Enum.AutomaticSize.Y;
        BackgroundTransparency = 1;
        LayoutOrder = Order or 0;
        Parent = ParentFrame;
    })
    VexUI:AddListLayout(Container, 1, Enum.FillDirection.Vertical)

    local RowHolder = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 22);
        BackgroundTransparency = 1;
        LayoutOrder = 1;
        Parent = Container;
    })

    local ChildContainer = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 0);
        AutomaticSize = Enum.AutomaticSize.Y;
        BackgroundTransparency = 1;
        Visible = false;
        LayoutOrder = 2;
        Parent = Container;
    })
    VexUI:AddListLayout(ChildContainer, 1, Enum.FillDirection.Vertical)

    return Container, RowHolder, ChildContainer
end

function Explorer:GetNextChildLayoutOrder(ParentNode)
    local Highest = 0

    if ParentNode.Children then
        for _, ChildNode in ParentNode.Children do
            if ChildNode and ChildNode.NodeFrame then
                Highest = math.max(Highest, ChildNode.NodeFrame.LayoutOrder or 0)
            end
        end
    end

    if ParentNode.PendingChildren then
        for _, Pending in ParentNode.PendingChildren do
            local Order = 0

            if type(Pending) == "table" then
                Order = Pending.Order or 0
            end

            Highest = math.max(Highest, Order)
        end
    end

    return Highest + 1
end

function Explorer:CreateChildNode(ParentNode, Object, Order)
    if not ParentNode or typeof(Object) ~= "Instance" then
        return nil
    end

    if self.NodesByInstance[Object] then
        return self.NodesByInstance[Object]
    end

    if Order == nil then
        Order = self:GetNextChildLayoutOrder(ParentNode)
    end

    local Node = {
        Instance = Object;
        Depth = ParentNode.Depth + 1;
        Expanded = false;
        Children = {};
        Parent = ParentNode;
    }

    local Container, RowHolder, ChildContainer = self:BuildNodeContainer(ParentNode.ChildContainer, Order)
    Node.NodeFrame = Container
    Node.ChildContainer = ChildContainer

    self:CreateNodeRow(Node, RowHolder)
    self.NodesByInstance[Object] = Node
    table.insert(ParentNode.Children, Node)
    self:ApplySearchFilterToNode(Node)

    if self.ExpandedInstances and self.ExpandedInstances[Object] then
        task.defer(function()
            if KillScript then
                return
            end

            if Node.NodeFrame and Node.NodeFrame.Parent then
                self:ExpandNode(Node)
            end
        end)
    end

    return Node
end

function Explorer:DestroyNode(Node)
    if not Node then
        return
    end

    for _, ChildNode in {table.unpack(Node.Children)} do
        self:DestroyNode(ChildNode)
    end
    Node.Children = {}

    if Node.Connections then
        for _, Connection in Node.Connections do
            pcall(function()
                Connection:Disconnect()
            end)
        end
    end

    if Node.NodeFrame then
        Node.NodeFrame:Destroy()
    end

    if Node.Parent and Node.Parent.Children then
        for Index, Child in Node.Parent.Children do
            if Child == Node then
                table.remove(Node.Parent.Children, Index)

                break
            end
        end
    end
    if self.SelectedSet[Node.Instance] then
        self.SelectedSet[Node.Instance] = nil

        for Index, Value in self.SelectedOrder do
            if Value == Node.Instance then
                table.remove(self.SelectedOrder, Index)

                break
            end
        end

        if self.SelectedInstance == Node.Instance then
            self.SelectedInstance = self.SelectedOrder[#self.SelectedOrder]
            self:OnSelectionChanged()
        end
    end

    self.NodesByInstance[Node.Instance] = nil
    self.ForcedExpanded[Node.Instance] = nil
end

function Explorer:ExpandNode(Node)
    if Node.Expanded then
        return
    end

    Node.Expanded = true

    if not Node.IsNilContainer then
        self.ExpandedInstances[Node.Instance] = true
    end

    self:UpdateArrow(Node)
    Node.ChildContainer.Visible = true

    if Node._ConnectChildSignals then
        Node._ConnectChildSignals()
    end

    if Node.IsNilContainer then
        self:MountNilVirtualList()

        return
    end

    local Children = WeakGetChildren(Node.Instance)
    SortExplorerChildren(Children)

    Node.PendingChildren = Node.PendingChildren or {}
    local Searching = self.SearchQuery ~= ""

    for Index, Child in Children do
        if self.NodesByInstance[Child] then
            continue
        end

        if Searching
            and not (self.MatchSet[Child] or self.SubtreeMatchSet[Child])
        then
            continue
        end

        table.insert(Node.PendingChildren, {
            Instance = Child;
            Order = Index;
        })
    end

    if #Node.PendingChildren > 0 then
        self.PendingNodesSet = self.PendingNodesSet or {}
        self.PendingNodesSet[Node] = true
    end

    self:ScheduleNodeRealiser()
end

function Explorer:CancelPendingNodeRealiser()
    self.NodeRealiserToken = (self.NodeRealiserToken or 0) + 1
    self.NodeRealiserRunning = false
    self.PendingNodesSet = {}

    for _, Node in self.NodesByInstance do
        if Node then
            Node.PendingChildren = nil
        end
    end
end

function Explorer:ScheduleNodeRealiser()
    if self.NodeRealiserRunning then
        return
    end

    self.NodeRealiserRunning = true
    self.PendingNodesSet = self.PendingNodesSet or {}

    local RealiserToken = self.NodeRealiserToken or 0

    task.spawn(function()
        while not KillScript and RealiserToken == (self.NodeRealiserToken or 0) do
            local Budgets = self:GetSearchBudgets(self.SearchQuery)
            local Budget = self.SearchQuery ~= "" and Budgets.RealiserBudget or 8
            local Created = 0

            local ScrollFrame = self.ExplorerColumn and self.ExplorerColumn.Content
            if not ScrollFrame then
                break
            end

            local ViewTop = ScrollFrame.CanvasPosition.Y
            local ViewBottom = ViewTop + ScrollFrame.AbsoluteSize.Y
            local ScrollAbsTop = ScrollFrame.AbsolutePosition.Y
            local Overscan = self.SearchQuery ~= "" and Budgets.Overscan or 250

            local ToProcess = {}
            for Node in self.PendingNodesSet do
                table.insert(ToProcess, Node)
            end

            for _, Node in ToProcess do
                if Created >= Budget then
                    break
                end

                local Pending = Node.PendingChildren
                if not Pending or #Pending == 0 then
                    self.PendingNodesSet[Node] = nil

                    continue
                end

                local Container = Node.ChildContainer
                if not Container or not Container.Parent then
                    self.PendingNodesSet[Node] = nil

                    continue
                end

                local AbsTop = Container.AbsolutePosition.Y - ScrollAbsTop + ViewTop
                local AbsBottom = AbsTop + Container.AbsoluteSize.Y
                if AbsBottom < (ViewTop - Overscan) or AbsTop > (ViewBottom + Overscan) then
                    continue
                end

                while #Pending > 0 and Created < Budget do
                    local PendingEntry = table.remove(Pending, 1)
                    local Child = PendingEntry
                    local Order = 0

                    if type(PendingEntry) == "table" then
                        Child = PendingEntry.Instance
                        Order = PendingEntry.Order or 0
                    end

                    if Child and not self.NodesByInstance[Child] then
                        if self.SearchQuery ~= ""
                            and not (self.MatchSet[Child] or self.SubtreeMatchSet[Child])
                        then
                            continue
                        end

                        self:CreateChildNode(Node, Child, Order)

                        if self.SearchQuery ~= "" then
                            local NewNode = self.NodesByInstance[Child]
                            if NewNode then
                                self:ApplySearchFilterToNode(NewNode)
                            end
                        end

                        Created += 1
                    end
                end

                if #Pending == 0 then
                    Node.PendingChildren = nil
                    self.PendingNodesSet[Node] = nil
                end
            end

            if Created == 0 then
                if self.SearchQuery ~= ""
                    and self.SearchExpansionQueue
                    and #self.SearchExpansionQueue > 0
                then
                    self:ProcessSearchExpansionQueue(self.SearchToken, 1)
                end

                break
            else
                task.wait()

                if RealiserToken ~= (self.NodeRealiserToken or 0) then
                    break
                end
            end
        end

        if RealiserToken == (self.NodeRealiserToken or 0) then
            self.NodeRealiserRunning = false
        end
    end)
end

function Explorer:CollapseNode(Node)
    if Node.IsNilContainer then
        self:UnmountNilVirtualList()
    end

    if not Node.Expanded then
        return
    end

    Node.Expanded = false

    if not Node.IsNilContainer then
        self.ExpandedInstances[Node.Instance] = nil
    end

    self:UpdateArrow(Node)
    Node.ChildContainer.Visible = false

    if Node._DisconnectChildSignals then
        Node._DisconnectChildSignals()
    end

    Node.PendingChildren = nil
    if self.PendingNodesSet then
        self.PendingNodesSet[Node] = nil
    end

    for _, ChildNode in {table.unpack(Node.Children)} do
        self:DestroyNode(ChildNode)
    end

    Node.Children = {}
end

function Explorer:ToggleNode(Node)
    if Node.Expanded then
        self:CollapseNode(Node)
    else
        self:ExpandNode(Node)
    end
end

function Explorer:UpdateSelectionHighlights()
    self.SelectionHighlights = self.SelectionHighlights or setmetatable({}, {__mode = "k"})

    for Inst, Hl in self.SelectionHighlights do
        if not self.SelectedSet[Inst] then
            pcall(function() Hl:Destroy() end)
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
                local Good, Hl = pcall(function()
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
                if Good and Hl then
                    self.SelectionHighlights[Inst] = Hl
                end
            end
        end
    end
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

    Character = ClonerefInstance(Character)

    self.SearchQuery = ""
    if self.SearchBox then
        self.SearchBox.Text = ""
    end
    self:RefreshAllSearchFilters()

    local Chain = {}
    local Cursor = ClonerefInstance(Character)
    while Cursor and Cursor.Parent ~= nil do
        table.insert(Chain, 1, Cursor)
        Cursor = ClonerefInstance(Cursor.Parent)
    end

    if #Chain == 0 then
        return
    end

    local PreviousNode
    for Index, Ancestor in Chain do
        local IsLeaf = Index == #Chain
        local Node = self.NodesByInstance[Ancestor]

        if not Node and PreviousNode then
            if not PreviousNode.Expanded then
                self:ExpandNode(PreviousNode)
            end

            if PreviousNode.PendingChildren then
                for I, Pending in PreviousNode.PendingChildren do
                    if Pending == Ancestor then
                        table.remove(PreviousNode.PendingChildren, I)

                        break
                    end
                end

                if #PreviousNode.PendingChildren == 0 then
                    PreviousNode.PendingChildren = nil
                    if self.PendingNodesSet then
                        self.PendingNodesSet[PreviousNode] = nil
                    end
                end
            end

            Node = self:CreateChildNode(PreviousNode, Ancestor)
        end

        if not Node then
            return
        end

        if not IsLeaf and not Node.Expanded then
            self:ExpandNode(Node)
        end

        PreviousNode = Node
    end

    self:SetSelection({Character})
    self.SelectionAnchor = Character

    local Scroll = self.ExplorerColumn and self.ExplorerColumn.Content
    if not Scroll or not Scroll:IsA("ScrollingFrame") then
        return
    end

    task.defer(function()
        if KillScript then
            return
        end

        for _ = 1, 30 do
            task.wait()

            local Node = self.NodesByInstance[Character]
            if Node and Node.Row and Node.Row.Parent and Node.Row.AbsoluteSize.Y > 0 then
                local RowAbsY = Node.Row.AbsolutePosition.Y
                local FrameAbsY = Scroll.AbsolutePosition.Y
                local Offset = (RowAbsY - FrameAbsY) + Scroll.CanvasPosition.Y
                local TargetY = math.max(0, Offset - Scroll.AbsoluteSize.Y / 2 + 11)
                Scroll.CanvasPosition = Vector2.new(Scroll.CanvasPosition.X, TargetY)

                return
            end
        end
    end)
end

function Explorer:EnsureNodeVisible(Object)
    local Chain = {}
    local Cursor = Object
    while Cursor and Cursor ~= game do
        table.insert(Chain, 1, Cursor)
        Cursor = Cursor.Parent
    end

    for _, Ancestor in Chain do
        local Node = self.NodesByInstance[Ancestor]
        if not Node then
            return
        end

        if Ancestor ~= Object
            and not Node.Expanded
        then
            self:ExpandNode(Node)
        end
    end
end

function Explorer:CreateRootNode(Object, Order)
    if self.NodesByInstance[Object] then
        return
    end

    local Node = {
        Instance = Object;
        Depth = 0;
        Expanded = false;
        Children = {};
        Parent = nil;
    }

    local Container, RowHolder, ChildContainer = self:BuildNodeContainer(self.ExplorerColumn.Content, Order)
    Node.NodeFrame = Container
    Node.ChildContainer = ChildContainer

    self:CreateNodeRow(Node, RowHolder)
    self.NodesByInstance[Object] = Node
    table.insert(self.RootNodes, Node)
    self:ApplySearchFilterToNode(Node)

    return Node
end

function Explorer:ComputeOrderForService(Object)
    local Pinned = PinnedRank[Object.Name]
    if Pinned then
        return Pinned
    end

    local Unpinned = {}
    for _, Child in WeakGetChildren(game) do
        if not PinnedRank[Child.Name] then
            table.insert(Unpinned, Child)
        end
    end

    table.sort(Unpinned, function(Left, Right)
        return Left.Name:lower() < Right.Name:lower()
    end)

    for Index, Child in Unpinned do
        if Child == Object then
            return #PinnedServices + Index
        end
    end

    return #PinnedServices + 100
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

function Explorer:CountNilInstancesLite()
    local GNI = getnilinstances
    if not GNI then
        return 0
    end

    local Good, List = pcall(GNI)
    if not Good or type(List) ~= "table" then
        return 0
    end

    local OwnGui = self.ScreenGui
    local NilSet = {}
    for _, Inst in List do
        if typeof(Inst) == "Instance" then
            NilSet[Inst] = true
        end
    end

    local Total = 0
    local Walked = 0

    for Index = 1, #List do
        local NilInstance = List[Index]
        if typeof(NilInstance) ~= "Instance" then
            continue
        end
        if NilInstance == self.NilContainerPlaceholder then
            continue
        end
        if OwnGui and NilInstance == OwnGui then
            continue
        end

        local GoodParent, Parent = pcall(function()
            return NilInstance.Parent
        end)
        if not GoodParent then
            continue
        end

        local TopLevel = false
        if Parent == nil then
            TopLevel = true
        elseif not NilSet[Parent] then
            local GoodGame, InGame = pcall(function()
                return Parent:IsDescendantOf(game)
            end)
            if not (GoodGame and InGame) then
                TopLevel = Parent == nil
            end
        end

        if not TopLevel then
            continue
        end

        Total += 1

        local Descendants = WeakGetDescendants(NilInstance)
        local GoodDesc = type(Descendants) == "table"
        if GoodDesc and type(Descendants) == "table" then
            Total += #Descendants
        end

        Walked += 1
        if Walked % 25 == 0 then
            task.wait()
            if KillScript then
                return Total
            end
        end
    end

    return Total
end

function Explorer:CollectNilInstances(SearchFilter, ClassFilter)
    local Result = {}
    local Total = 0

    local GNI = getnilinstances
    if not GNI then
        return Result, 0
    end

    local Good, List = pcall(GNI)
    if not Good or type(List) ~= "table" then
        return Result, 0
    end

    local LowerSearch = (SearchFilter or ""):lower()
    local OwnGui = self.ScreenGui

    local NilSet = {}
    for _, NilInstance in List do
        if typeof(NilInstance) == "Instance" then
            NilSet[NilInstance] = true
        end
    end

    local function IsTopLevelNil(NilInstance)
        local GoodParent, Parent = pcall(function()
            return NilInstance.Parent
        end)

        if not GoodParent then
            return false
        end

        if Parent == nil then
            return true
        end

        if NilSet[Parent] then
            return false
        end

        local GoodGame, InGame = pcall(function()
            return Parent:IsDescendantOf(game)
        end)

        if GoodGame and InGame then
            return false
        end

        return Parent == nil
    end

    local function PassesClass(Instance)
        if not ClassFilter or ClassFilter == "" then
            return true
        end

        local GoodClass, IsMatch = pcall(function()
            return Instance:IsA(ClassFilter)
        end)

        return GoodClass and IsMatch
    end

    local function PassesSearch(Instance)
        if LowerSearch == "" then
            return true
        end

        local GoodName, Name = pcall(function()
            return Instance.Name
        end)

        if not GoodName or typeof(Name) ~= "string" then
            return false
        end

        return Name:lower():find(LowerSearch, 1, true) ~= nil
    end

    local Seen = {}
    local Walked = 0
    local function Consider(Instance)
        if Seen[Instance] then
            return
        end
        Seen[Instance] = true

        if Instance == self.NilContainerPlaceholder then
            return
        end

        if OwnGui and Instance == OwnGui then
            return
        end

        Total += 1

        if PassesClass(Instance) and PassesSearch(Instance) then
            table.insert(Result, Instance)
        end
        local Children = WeakGetDescendants(Instance)
        if type(Children) ~= "table" then
            return
        end

        for _, Child in Children do
            if typeof(Child) == "Instance" and not Seen[Child] then
                Seen[Child] = true

                if Child == self.NilContainerPlaceholder then
                    continue
                end

                if OwnGui and Child == OwnGui then
                    continue
                end

                Total += 1

                if PassesClass(Child) and PassesSearch(Child) then
                    table.insert(Result, Child)
                end

                Walked += 1
                if Walked % 2000 == 0 then
                    task.wait()
                end
            end
        end
    end

    for Index = #List, 1, -1 do
        local NilInstance = List[Index]
        if typeof(NilInstance) ~= "Instance" then
            continue
        end

        if not IsTopLevelNil(NilInstance) then
            continue
        end

        Consider(NilInstance)
    end

    return Result, Total
end

function Explorer:NilUpdateRowSelection(Row, Item)
    if not Row
        or not Row.Parent
    then
        return
    end

    if self.SelectedSet[Item] then
        Row.BackgroundColor3 = Theme.Selected
        Row.BackgroundTransparency = 0.4
    else
        Row.BackgroundColor3 = Theme.Field
        Row.BackgroundTransparency = 1
    end
end

function Explorer:NilCreateRow(Item, IndexY, Container)
    local Row = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(1, 0, 0, self.NilRowHeight);
        Position = UDim2.new(0, 0, 0, IndexY);
        BackgroundColor3 = Theme.Field;
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Text = "";
        Parent = Container.NilVirtualInner;
    })

    local IndentPx = (Container.Depth + 1) * 16 + 6
    local Icon = VexUI:CreateClassIcon(Item.ClassName, Row)
    Icon.Position = UDim2.new(0, IndentPx, 0.5, -8)

    local GoodName, Name = pcall(function()
        return Item.Name
    end)

    VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, -(IndentPx + 24), 1, 0);
        Position = UDim2.new(0, IndentPx + 22, 0, 0);
        BackgroundTransparency = 1;
        Font = Fonts.Medium;
        Text = (GoodName and Name) or "?";
        TextColor3 = Theme.Text;
        TextSize = 12;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextTruncate = Enum.TextTruncate.AtEnd;
        Parent = Row;
    })

    Row.MouseEnter:Connect(function()
        if not self.SelectedSet[Item] then
            Row.BackgroundTransparency = 0.85
        end
    end)

    Row.MouseLeave:Connect(function()
        if not self.SelectedSet[Item] then
            Row.BackgroundTransparency = 1
        end
    end)

    Row.MouseButton1Click:Connect(function()
        if self.CtrlHeld then
            local New = {}
            for _, Existing in self.SelectedOrder do
                table.insert(New, Existing)
            end

            if self.SelectedSet[Item] then
                for Index, Value in New do
                    if Value == Item then
                        table.remove(New, Index)
                        
                        break
                    end
                end
            else
                table.insert(New, Item)
            end

            self:SetSelection(New)
        else
            self:SetSelection({Item})
        end

        self:NilRefreshVisibleSelection()
    end)

    Row.MouseButton2Click:Connect(function()
        if not self.SelectedSet[Item] then
            self:SetSelection({Item})
            self.SelectionAnchor = Item
        end

        local Mouse = self.LocalPlayer:GetMouse()
        self:OpenContextMenu(Mouse.X, Mouse.Y)
        self:NilRefreshVisibleSelection()
    end)

    self:NilUpdateRowSelection(Row, Item)

    return Row
end

function Explorer:NilRebuildVisible()
    local Container = self.NilContainerNode
    if not Container
        or not Container.NilVirtualInner
    then
        return
    end

    local Scroll = self.ExplorerColumn and self.ExplorerColumn.Content
    if not Scroll
        or not Scroll:IsA("ScrollingFrame")
    then
        return
    end

    local Inner = Container.NilVirtualInner
    local Items = Container.NilFilteredItems or {}
    local Slot = self.NilRowHeight + self.NilRowGap

    local InnerTopOnScreen = Inner.AbsolutePosition.Y
    local ViewTopOnScreen = Scroll.AbsolutePosition.Y
    local ViewHeight = Scroll.AbsoluteSize.Y
    local OffsetIntoInner = ViewTopOnScreen - InnerTopOnScreen
    local FirstIndex = math.max(1, math.floor(OffsetIntoInner / Slot) + 1 - self.NilBufferRows)
    local LastIndex = math.min(#Items, FirstIndex + math.ceil(ViewHeight / Slot) + self.NilBufferRows * 2)

    Container.NilRowItems = Container.NilRowItems or {}
    local Rows = Container.NilCurrentRows
    local RowItems = Container.NilRowItems

    for Index, Row in Rows do
        if Index < FirstIndex or Index > LastIndex or Items[Index] ~= RowItems[Index] then
            Row:Destroy()
            Rows[Index] = nil
            RowItems[Index] = nil
        end
    end

    for Index = FirstIndex, LastIndex do
        if not Rows[Index] then
            local Item = Items[Index]
            if Item then
                Rows[Index] = self:NilCreateRow(Item, (Index - 1) * Slot, Container)
                RowItems[Index] = Item
            end
        end
    end
end

function Explorer:NilRefreshVisibleSelection()
    local Container = self.NilContainerNode
    if not Container or not Container.NilCurrentRows then
        return
    end

    local RowItems = Container.NilRowItems or {}
    for Index, Row in Container.NilCurrentRows do
        self:NilUpdateRowSelection(Row, RowItems[Index])
    end
end

function Explorer:RefreshNilVirtualList()
    local Container = self.NilContainerNode
    if not Container then
        return
    end

    local Search = self.SearchQuery or ""
    local Filtered, Total = self:CollectNilInstances(Search, self.NilFilterClass)
    Container.NilFilteredItems = Filtered
    Container.NilTotalCount = Total

    if Container.Label and Container.Label.Parent then
        local Suffix = (Search ~= "" or self.NilFilterClass ~= "") and ` ({#Filtered}/{Total})` or ` ({Total})`
        Container.Label.Text = `"Nil Instances"{Suffix}`
    end

    if not Container.NilVirtualInner then
        return
    end

    local Slot = self.NilRowHeight + self.NilRowGap
    local TotalHeight = math.max(0, #Filtered * Slot)
    Container.NilVirtualInner.Size = UDim2.new(1, 0, 0, TotalHeight)
    Container.ChildContainer.Size = UDim2.new(1, 0, 0, TotalHeight)

    for Index, Row in Container.NilCurrentRows do
        Row:Destroy()
        Container.NilCurrentRows[Index] = nil
    end

    if Container.NilRowItems then
        for Index in Container.NilRowItems do
            Container.NilRowItems[Index] = nil
        end
    end

    self:NilRebuildVisible()
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

    if self.NilContainerNode and self.NilContainerNode.Expanded then
        self:RefreshNilVirtualList()
    end
end

function Explorer:MountNilVirtualList()
    local Container = self.NilContainerNode
    if not Container then
        return
    end

    for _, Child in WeakGetChildren(Container.ChildContainer) do
        Child:Destroy()
    end

    Container.ChildContainer.AutomaticSize = Enum.AutomaticSize.None
    Container.ChildContainer.Size = UDim2.new(1, 0, 0, 0)
    Container.ChildContainer.ClipsDescendants = false

    local Inner = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 0);
        BackgroundTransparency = 1;
        ClipsDescendants = false;
        Parent = Container.ChildContainer;
    })
    Container.NilVirtualInner = Inner
    Container.NilCurrentRows = {}
    Container.NilRowItems = {}

    local Scroll = self.ExplorerColumn and self.ExplorerColumn.Content
    if Scroll then
        Container.NilScrollConnection = Scroll:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
            self:NilRebuildVisible()
        end)

        Container.NilSizeConnection = Scroll:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            self:NilRebuildVisible()
        end)
    end

    self:RefreshNilVirtualList()
end

function Explorer:UnmountNilVirtualList()
    local Container = self.NilContainerNode
    if not Container then
        return
    end

    if Container.NilScrollConnection then
        Container.NilScrollConnection:Disconnect()
    end

    if Container.NilSizeConnection then
        Container.NilSizeConnection:Disconnect()
    end
    Container.NilScrollConnection = nil
    Container.NilSizeConnection = nil

    if Container.NilCurrentRows then
        for Index, Row in Container.NilCurrentRows do
            Row:Destroy()
            Container.NilCurrentRows[Index] = nil
        end
    end

    Container.NilCurrentRows = nil
    Container.NilRowItems = nil

    if Container.NilVirtualInner then
        Container.NilVirtualInner:Destroy()
    end
    Container.NilVirtualInner = nil
    Container.NilFilteredItems = nil

    Container.ChildContainer.AutomaticSize = Enum.AutomaticSize.Y
    Container.ChildContainer.Size = UDim2.new(1, 0, 0, 0)
end

function Explorer:RebuildExplorer()
    Handle(function()
        for _, Node in {table.unpack(self.RootNodes)} do
            self:DestroyNode(Node)
        end

        self.RootNodes = {}
        self.NodesByInstance = setmetatable({}, {__mode = "k"})

        self.ExplorerColumn:Clear()

        if typeof(self.HiddenServices) ~= "table" then
            self.HiddenServices = {}
        end

        local Sorted = SortServices(WeakGetChildren(game))
        local HiddenCount = 0
        for ServiceName in self.HiddenServices do
            HiddenCount += 1
        end

        local Created = 0
        for Index, Service in Sorted do
            if self.HiddenServices[Service.Name] then
                continue
            end

            local Good, ClassName = pcall(function()
                return Service.ClassName
            end)

            if not Good or type(ClassName) ~= "string" then
                continue
            end

            local NameGood, NodeName = pcall(function()
                return Service.Name
            end)

            if not NameGood or type(NodeName) ~= "string" or NodeName == "" then
                continue
            end

            self:CreateRootNode(Service, Index)
            Created += 1
        end

        if not self.HideNilContainer and getnilinstances then
            if not self.NilContainerPlaceholder then
                self.NilContainerPlaceholder = Instance.new("Folder")
                self.NilContainerPlaceholder.Name = "Nil Instances"
            end

            local Placeholder = self.NilContainerPlaceholder
            local Node = {
                Instance = Placeholder;
                Depth = 0;
                Expanded = false;
                Children = {};
                Parent = nil;
                IsNilContainer = true;
            }

            local Container, RowHolder, ChildContainer = self:BuildNodeContainer(self.ExplorerColumn.Content, #Sorted + 1)
            Node.NodeFrame = Container
            Node.ChildContainer = ChildContainer
            self:CreateNodeRow(Node, RowHolder)
            self.NodesByInstance[Placeholder] = Node
            table.insert(self.RootNodes, Node)
            self.NilContainerNode = Node

            local _, Initial = self:CollectNilInstances("", "")
            if Node.Label then
                Node.Label.Text = `Nil Instances ({Initial})`
            end
        end

        Track(game.ChildAdded:Connect(function(Child)
            if typeof(Child) ~= "Instance" then
                return
            end

            if self.HiddenServices[Child.Name] then
                return
            end

            self:CreateRootNode(Child, self:ComputeOrderForService(Child))
        end))

        Track(game.ChildRemoved:Connect(function(Child)
            if typeof(Child) ~= "Instance" then
                return
            end

            local Node = self.NodesByInstance[Child]
            if not Node then
                return
            end

            self:DestroyNode(Node)

            for Index, Root in self.RootNodes do
                if Root == Node then
                    table.remove(self.RootNodes, Index)

                    break
                end
            end
        end))
    end, "Function Explorer.RebuildExplorer")
end

function Explorer:ToggleClassFilter(ClassName)
    if self.ActiveClassFilters[ClassName] then
        self.ActiveClassFilters[ClassName] = nil
    else
        self.ActiveClassFilters[ClassName] = true
    end

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

function Explorer:BuildMatchSets(Query, Token)
    local Matches = {}
    local Subtree = {}
    local Count = 0
    local LowerQuery = Query
    local Filters = self.ActiveClassFilters
    local FilterActive = next(Filters) ~= nil

    local NodesWalked = 0
    local function Walk(Object)
        local HasMatchInside = false
        local Good, Children = pcall(WeakGetChildren, Object)
        if Good and type(Children) == "table" then
            for Index = 1, #Children do
                local Child = ClonerefInstance(Children[Index])

                if Child and Walk(Child) then
                    HasMatchInside = true
                end
            end
        end

        if Object ~= game then
            local Name = Object.Name
            local PassesClass = (not FilterActive) or Filters[Object.ClassName]
            if PassesClass and #Name > 0 and string.find(string.lower(Name), LowerQuery, 1, true) then
                Matches[Object] = true
                HasMatchInside = true
                Count += 1
            end
        end

        if HasMatchInside then
            Subtree[Object] = true
        end

        NodesWalked += 1
        if NodesWalked % 4000 == 0 then
            task.wait()
            if Token ~= self.SearchToken or KillScript then
                return false
            end
        end

        return HasMatchInside
    end

    Walk(game)
    if Token ~= self.SearchToken
        or KillScript
    then
        return nil
    end

    return Matches, Subtree, Count
end

function Explorer:StartProgressiveSearch(Query)
    self.SearchToken = (self.SearchToken or 0) + 1
    local Token = self.SearchToken

    self.MatchSet = {}
    self.SubtreeMatchSet = {}
    self.ForcedExpanded = {}

    for _, Node in self.NodesByInstance do
        self:ApplySearchFilterToNode(Node)
    end

    task.spawn(function()
        self:RunProgressiveSearch(Query, Token)
    end)
end

function Explorer:ApplySearchFilterToNode(Node)
    if not Node then
        return
    end

    local Query = self.SearchQuery or ""

    if Query == "" then
        local Visible = true

        if Node.IsNilContainer then
            Visible = not self.HideNilContainer
        end

        if Node.NodeFrame then
            Node.NodeFrame.Visible = Visible
        end

        if Node.Row then
            Node.Row.Visible = Visible

            local Holder = Node.Row.Parent
            if Holder then
                Holder.Visible = Visible
            end
        end

        if Node.ChildContainer then
            Node.ChildContainer.Visible = Visible and Node.Expanded == true
        end

        if Node.Label and Node.Label.TextColor3 ~= Theme.Text then
            Node.Label.TextColor3 = Theme.Text
        end

        return
    end

    if not Node.Row then
        return
    end

    local Visible
    local NewColor

    if Node.IsNilContainer then
        local IncludeNil = self.SearchIncludesNil ~= false
        local Filtered = Node.NilFilteredItems
        local HasResults = Filtered and #Filtered > 0

        Visible = IncludeNil and HasResults == true
        NewColor = Theme.Accent
    else
        local Object = Node.Instance

        if self.MatchSet[Object] then
            Visible = true
            NewColor = Theme.Accent
        elseif self.SubtreeMatchSet[Object] then
            Visible = true
            NewColor = Theme.TextDim
        else
            Visible = false
            NewColor = Theme.TextFaded
        end
    end

    if Node.NodeFrame then
        Node.NodeFrame.Visible = Visible
    end

    local Holder = Node.Row.Parent
    if Holder then
        Holder.Visible = Visible
    end

    Node.Row.Visible = Visible

    if Node.ChildContainer then
        Node.ChildContainer.Visible = Visible and Node.Expanded == true
    end

    if Node.Label and Node.Label.TextColor3 ~= NewColor then
        Node.Label.TextColor3 = NewColor
    end
end

function Explorer:EnsureNodeRealised(Object)
    if not Object or Object == game then
        return nil
    end

    local Existing = self.NodesByInstance[Object]
    if Existing then
        return Existing
    end

    local Parent = ClonerefInstance(Object.Parent)
    if not Parent or Parent == game then
        return nil
    end

    local ParentNode = self:EnsureNodeRealised(Parent)
    if not ParentNode then
        return nil
    end

    if ParentNode.PendingChildren then
        for Index, Pending in ParentNode.PendingChildren do
            local PendingObject = Pending
            local PendingOrder = 0

            if type(Pending) == "table" then
                PendingObject = Pending.Instance
                PendingOrder = Pending.Order or 0
            end

            if PendingObject == Object then
                table.remove(ParentNode.PendingChildren, Index)
                self:CreateChildNode(ParentNode, Object, PendingOrder)

                if #ParentNode.PendingChildren == 0 then
                    ParentNode.PendingChildren = nil

                    if self.PendingNodesSet then
                        self.PendingNodesSet[ParentNode] = nil
                    end
                end

                return self.NodesByInstance[Object]
            end
        end
    end

    return nil
end

function Explorer:ExpandAncestorsOf(Object)
    local Chain = {}

    local Cursor = ClonerefInstance(Object)
    while Cursor and Cursor.Parent ~= nil and Cursor ~= game do
        table.insert(Chain, 1, Cursor)
        Cursor = ClonerefInstance(Cursor.Parent)
    end

    if #Chain == 0 then
        return false
    end

    local PreviousNode = nil
    local DidWork = false

    for Index, Ancestor in Chain do
        local IsLeaf = Index == #Chain
        local Node = self.NodesByInstance[Ancestor]

        if not Node and PreviousNode then
            if not PreviousNode.Expanded then
                self.ForcedExpanded[PreviousNode.Instance] = true
                self:ExpandNode(PreviousNode)
                DidWork = true
            end

            local PendingOrder = 0

            if PreviousNode.PendingChildren then
                for I, Pending in PreviousNode.PendingChildren do
                    local PendingObject = Pending
                    local Order = 0

                    if type(Pending) == "table" then
                        PendingObject = Pending.Instance
                        Order = Pending.Order or 0
                    end

                    if PendingObject == Ancestor then
                        PendingOrder = Order
                        table.remove(PreviousNode.PendingChildren, I)
                        break
                    end
                end

                if #PreviousNode.PendingChildren == 0 then
                    PreviousNode.PendingChildren = nil

                    if self.PendingNodesSet then
                        self.PendingNodesSet[PreviousNode] = nil
                    end
                end
            end

            Node = self:CreateChildNode(PreviousNode, Ancestor, PendingOrder)
            DidWork = true
        end

        if not Node then
            return DidWork
        end

        if not IsLeaf and not Node.Expanded then
            self.ForcedExpanded[Ancestor] = true
            self:ExpandNode(Node)
            DidWork = true
        end

        PreviousNode = Node
    end

    return DidWork
end

function Explorer:ClearSearchVisualState()
    self.SearchQuery = ""
    self.MatchSet = {}
    self.SubtreeMatchSet = {}

    self.SearchExpansionQueue = {}
    self.SearchExpansionQueued = {}
    self._SearchExpansionQueueIndex = 1

    self.SearchToken = (self.SearchToken or 0) + 1
    self.NodeRealiserToken = (self.NodeRealiserToken or 0) + 1
    self.NodeRealiserRunning = false

    self._RefreshDebounceToken = (self._RefreshDebounceToken or 0) + 1
    self._SearchTextToken = (self._SearchTextToken or 0) + 1
    self._LastAppliedSearchQuery = ""

    for _, Node in self.NodesByInstance do
        if Node.NodeFrame then
            Node.NodeFrame.Visible = true
        end

        if Node.Row then
            Node.Row.Visible = true
        end

        if Node.ChildContainer then
            Node.ChildContainer.Visible = Node.Expanded == true
        end
    end

    for _, Root in self.RootNodes or {} do
        if Root.NodeFrame then
            Root.NodeFrame.Visible = true
        end

        if Root.Row then
            Root.Row.Visible = true
        end

        if Root.ChildContainer then
            Root.ChildContainer.Visible = Root.Expanded == true
        end
    end
end

function Explorer:ClearSearchExpansionState()
    local ToCollapse = {}

    for Object in self.ForcedExpanded or {} do
        local Node = self.NodesByInstance[Object]
        if Node and Node.Expanded then
            table.insert(ToCollapse, Node)
        end
    end

    self.ForcedExpanded = {}

    table.sort(ToCollapse, function(A, B)
        return (A.Depth or 0) > (B.Depth or 0)
    end)

    for _, Node in ToCollapse do
        if Node and Node.Row and Node.Expanded then
            self:CollapseNode(Node)
        end
    end
end

function Explorer:QueueSearchExpansion(Object)
    if not Object then
        return
    end

    self.SearchExpansionQueue = self.SearchExpansionQueue or {}
    self.SearchExpansionQueued = self.SearchExpansionQueued or {}

    if self.SearchExpansionQueued[Object] then
        return
    end

    local Budgets = self:GetSearchBudgets(self.SearchQuery)
    local MaxQueued = Budgets.MaxQueuedMatches or 300

    if #self.SearchExpansionQueue >= MaxQueued then
        return
    end

    self.SearchExpansionQueued[Object] = true
    table.insert(self.SearchExpansionQueue, Object)
end

function Explorer:IsNodeNearExplorerViewport(Node, Overscan)
    if not Node or not Node.NodeFrame or not Node.NodeFrame.Parent then
        return false
    end

    local ScrollFrame = self.ExplorerColumn and self.ExplorerColumn.Content
    if not ScrollFrame then
        return true
    end

    Overscan = Overscan or 300

    local ViewTop = ScrollFrame.AbsolutePosition.Y
    local ViewBottom = ViewTop + ScrollFrame.AbsoluteSize.Y

    local NodeTop = Node.NodeFrame.AbsolutePosition.Y
    local NodeBottom = NodeTop + Node.NodeFrame.AbsoluteSize.Y

    return NodeBottom >= ViewTop - Overscan and NodeTop <= ViewBottom + Overscan
end

function Explorer:GetBestExistingAncestorNode(Object)
    local BestNode = nil
    local Cursor = ClonerefInstance(Object)

    while Cursor and Cursor ~= game do
        local Node = self.NodesByInstance[Cursor]
        if Node then
            BestNode = Node
            break
        end

        Cursor = ClonerefInstance(Cursor.Parent)
    end

    return BestNode
end

function Explorer:ProcessSearchExpansionQueue(Token, Budget)
    if Token ~= self.SearchToken or KillScript then
        return
    end

    local Queue = self.SearchExpansionQueue
    if not Queue or #Queue == 0 then
        return
    end

    Budget = Budget or 2

    local DidExpand = false
    local Processed = 0
    local Checked = 0
    local MaxChecks = math.max(20, Budget * 20)

    local Index = self._SearchExpansionQueueIndex or 1
    if Index > #Queue then
        Index = 1
    end

    while #Queue > 0 and Processed < Budget and Checked < MaxChecks do
        if Token ~= self.SearchToken or KillScript then
            return
        end

        if Index > #Queue then
            Index = 1
        end

        local Object = Queue[Index]
        Checked += 1

        if not Object
            or not self.MatchSet
            or not self.MatchSet[Object]
        then
            if Object and self.SearchExpansionQueued then
                self.SearchExpansionQueued[Object] = nil
            end

            table.remove(Queue, Index)
        else
            local AnchorNode = self:GetBestExistingAncestorNode(Object)

            if AnchorNode and self:IsNodeNearExplorerViewport(AnchorNode, 350) then
                self:ExpandAncestorsOf(Object)
                DidExpand = true

                if self.SearchExpansionQueued then
                    self.SearchExpansionQueued[Object] = nil
                end

                table.remove(Queue, Index)
                Processed += 1
            else
                Index += 1
            end
        end
    end

    self._SearchExpansionQueueIndex = Index

    if DidExpand then
        self:ScheduleNodeRealiser()
    end
end

function Explorer:GetSearchBudgets(Query)
    local Length = #(Query or "")

    if Length <= 1 then
        return {
            ProcessBatchSize = 50;
            VisualFlushDelay = 0.35;
            QueueBudget = 1;
            RealiserBudget = 1;
            Overscan = 10;
            MaxQueuedMatches = 60;
        }
    elseif Length == 2 then
        return {
            ProcessBatchSize = 80;
            VisualFlushDelay = 0.3;
            QueueBudget = 1;
            RealiserBudget = 1;
            Overscan = 20;
            MaxQueuedMatches = 120;
        }
    elseif Length == 3 then
        return {
            ProcessBatchSize = 150;
            VisualFlushDelay = 0.22;
            QueueBudget = 2;
            RealiserBudget = 2;
            Overscan = 45;
            MaxQueuedMatches = 300;
        }
    else
        return {
            ProcessBatchSize = 300;
            VisualFlushDelay = 0.15;
            QueueBudget = 4;
            RealiserBudget = 3;
            Overscan = 80;
            MaxQueuedMatches = 800;
        }
    end
end

function Explorer:RefreshAllSearchFilters()
    local Query = self.SearchQuery

    if Query ~= "" and #Query < 1 then
        self.SearchToken = (self.SearchToken or 0) + 1

        self:CancelPendingNodeRealiser()
        self:ClearSearchExpansionState()

        self.MatchSet = {}
        self.SubtreeMatchSet = {}
        self._SearchExpansionQueueIndex = 1
        self.SearchExpansionQueue = {}
        self.SearchExpansionQueued = {}

        for _, Node in self.NodesByInstance do
            self:ApplySearchFilterToNode(Node)
        end

        return
    end

    self.SearchToken = (self.SearchToken or 0) + 1
    local Token = self.SearchToken

    self:CancelPendingNodeRealiser()
    self:ClearSearchExpansionState()

    if Query == "" then
        self.MatchSet = {}
        self.SubtreeMatchSet = {}

        for _, Node in self.NodesByInstance do
            self:ApplySearchFilterToNode(Node)
        end

        return
    end

    self.MatchSet = {}
    self.SubtreeMatchSet = {}
    self.ForcedExpanded = {}
    self.SearchExpansionQueue = {}
    self.SearchExpansionQueued = {}

    for _, Node in self.NodesByInstance do
        self:ApplySearchFilterToNode(Node)
    end

    task.spawn(function()
        self:RunProgressiveSearch(Query, Token)
    end)
end

function Explorer:RunProgressiveSearch(Query, Token)
    local LowerQuery = Query:lower()
    local Filters = self.ActiveClassFilters or {}
    local FilterActive = next(Filters) ~= nil

    local Queue = {}
    local QueueRead = 1
    local QueueWrite = 0

    local function PushQueue(Object)
        if not Object then
            return
        end

        QueueWrite += 1
        Queue[QueueWrite] = Object
    end

    local Root = ClonerefInstance(game)

    local Good, Children = pcall(WeakGetChildren, Root)
    if Good and type(Children) == "table" then
        for _, Child in Children do
            PushQueue(ClonerefInstance(Child))
        end
    end

    local Budgets = self:GetSearchBudgets(Query)
    local ProcessBatchSize = Budgets.ProcessBatchSize
    local VisualFlushDelay = Budgets.VisualFlushDelay
    local MaxQueuedMatches = Budgets.MaxQueuedMatches
    local QueueBudget = Budgets.QueueBudget

    local Processed = 0
    local MatchesFound = 0
    local LastVisualFlush = os.clock()

    local function MarkAncestors(Object)
        local Cursor = ClonerefInstance(Object)

        while Cursor and Cursor ~= game do
            self.SubtreeMatchSet[Cursor] = true
            Cursor = ClonerefInstance(Cursor.Parent)
        end
    end

    local function PassesClassFilter(Object)
        if not FilterActive then
            return true
        end

        local GoodClass, ClassName = pcall(function()
            return Object.ClassName
        end)

        return GoodClass and Filters[ClassName] == true
    end

    local function AddChildren(Object)
        local GoodChildren, Children = pcall(WeakGetChildren, Object)
        if not GoodChildren or type(Children) ~= "table" then
            return
        end

        for _, Child in Children do
            PushQueue(ClonerefInstance(Child))
        end
    end

    while QueueRead <= QueueWrite do
        if Token ~= self.SearchToken or KillScript then
            return
        end

        local Object = Queue[QueueRead]
        Queue[QueueRead] = nil
        QueueRead += 1

        if Object and Object ~= game then
            AddChildren(Object)

            local GoodName, Name = pcall(function()
                return Object.Name
            end)

            if GoodName
                and type(Name) == "string"
                and Name:lower():find(LowerQuery, 1, true)
                and PassesClassFilter(Object)
            then
                self.MatchSet[Object] = true
                MarkAncestors(Object)

                MatchesFound += 1

                if MatchesFound <= MaxQueuedMatches then
                    self:QueueSearchExpansion(Object)
                end

                if MatchesFound <= 12 then
                    self:ProcessSearchExpansionQueue(Token, QueueBudget)
                end
            end
        end

        Processed += 1

        if Processed % ProcessBatchSize == 0 then
            for _, Node in self.NodesByInstance do
                self:ApplySearchFilterToNode(Node)
            end

            self:ProcessSearchExpansionQueue(Token, QueueBudget)
            self:ScheduleNodeRealiser()

            task.wait()

            if Token ~= self.SearchToken or KillScript then
                return
            end
        elseif os.clock() - LastVisualFlush > VisualFlushDelay then
            LastVisualFlush = os.clock()

            for _, Node in self.NodesByInstance do
                self:ApplySearchFilterToNode(Node)
            end

            self:ProcessSearchExpansionQueue(Token, QueueBudget)
            self:ScheduleNodeRealiser()
        end
    end

    if Token ~= self.SearchToken or KillScript then
        return
    end

    for _, Node in self.NodesByInstance do
        self:ApplySearchFilterToNode(Node)
    end

    self:ProcessSearchExpansionQueue(Token, QueueBudget)
    self:ScheduleNodeRealiser()
end

function Explorer:CollapseAllExceptJumpPath(Target)
    if typeof(Target) ~= "Instance" then
        return
    end

    local PathSet = setmetatable({}, {__mode = "k"})
    local ExpandSet = setmetatable({}, {__mode = "k"})

    local Cursor = ClonerefInstance(Target)

    while Cursor and Cursor ~= game do
        PathSet[Cursor] = true

        local Parent = ClonerefInstance(Cursor.Parent)
        if Parent and Parent ~= game then
            ExpandSet[Parent] = true
        end

        Cursor = Parent
    end

    for _, Node in self.NodesByInstance do
        if not Node or not Node.Instance then
            continue
        end

        local Object = Node.Instance
        local ShouldExpand = ExpandSet[Object] == true

        if Node.IsNilContainer then
            ShouldExpand = false
        end

        Node.Expanded = ShouldExpand

        if self.ExpandedInstances then
            if ShouldExpand then
                self.ExpandedInstances[Object] = true
            else
                self.ExpandedInstances[Object] = nil
            end
        end

        if self.ForcedExpanded then
            if ShouldExpand then
                self.ForcedExpanded[Object] = true
            else
                self.ForcedExpanded[Object] = nil
            end
        end

        if Node.NodeFrame then
            Node.NodeFrame.Visible = true
        end

        if Node.Row then
            Node.Row.Visible = true

            local Holder = Node.Row.Parent
            if Holder then
                Holder.Visible = true
            end
        end

        if Node.ChildContainer then
            Node.ChildContainer.Visible = ShouldExpand
        end

        self:UpdateArrow(Node)
    end
end

function Explorer:ClearSearchStateWithoutRebuild()
    self.SearchQuery = ""

    self.MatchSet = {}
    self.SubtreeMatchSet = {}

    self.SearchExpansionQueue = {}
    self.SearchExpansionQueued = {}
    self._SearchExpansionQueueIndex = 1

    self.SearchToken = (self.SearchToken or 0) + 1
    self.NodeRealiserToken = (self.NodeRealiserToken or 0) + 1
    self.NodeRealiserRunning = false

    self._RefreshDebounceToken = (self._RefreshDebounceToken or 0) + 1
    self._SearchTextToken = (self._SearchTextToken or 0) + 1
    self._LastAppliedSearchQuery = ""

    for _, Node in self.NodesByInstance do
        self:ApplySearchFilterToNode(Node)

        if Node.NodeFrame then
            Node.NodeFrame.Visible = true
        end

        if Node.Row then
            Node.Row.Visible = true

            local Holder = Node.Row.Parent
            if Holder then
                Holder.Visible = true
            end
        end

        if Node.ChildContainer then
            Node.ChildContainer.Visible = Node.Expanded == true
        end

        if Node.Label then
            Node.Label.TextColor3 = Theme.Text
        end
    end

    for _, Root in self.RootNodes or {} do
        if Root.NodeFrame then
            Root.NodeFrame.Visible = true
        end

        if Root.Row then
            Root.Row.Visible = true

            local Holder = Root.Row.Parent
            if Holder then
                Holder.Visible = true
            end
        end

        if Root.ChildContainer then
            Root.ChildContainer.Visible = Root.Expanded == true
        end

        if Root.Label then
            Root.Label.TextColor3 = Theme.Text
        end
    end
end

function Explorer:ClearSearchAndJumpTo()
    local Target = self.SelectedInstance
    if typeof(Target) ~= "Instance" then
        return
    end

    self._SearchTextToken = (self._SearchTextToken or 0) + 1
    self._SuppressSearchBoxChanged = true

    if self.SearchBox then
        self.SearchBox.Text = ""
    end

    self._SuppressSearchBoxChanged = false
    self._SearchTextToken += 1
    self._LastAppliedSearchQuery = ""

    self:ClearSearchStateWithoutRebuild()

    task.defer(function()
        if KillScript then
            return
        end

        local function UnpackPending(Pending)
            if type(Pending) == "table" then
                return Pending.Instance, Pending.Order or 0
            end

            return Pending, 0
        end

        local function GetChildOrder(ParentObject, ChildObject)
            local Good, Children = pcall(WeakGetChildren, ParentObject)
            if not Good or type(Children) ~= "table" then
                return 0
            end

            SortExplorerChildren(Children)

            for Index, Child in Children do
                if Child == ChildObject then
                    return Index
                end
            end

            return 0
        end

        local function ForceExpandNode(Node)
            if not Node or Node.IsNilContainer then
                return
            end

            if Node.NodeFrame then
                Node.NodeFrame.Visible = true
            end

            if Node.Row then
                Node.Row.Visible = true

                local Holder = Node.Row.Parent
                if Holder then
                    Holder.Visible = true
                end
            end

            self.ForcedExpanded[Node.Instance] = true

            if not Node.Expanded then
                self:ExpandNode(Node)
            end

            Node.Expanded = true

            if Node.ChildContainer then
                Node.ChildContainer.Visible = true
            end

            self:UpdateArrow(Node)
        end

        local function RealiseDirectChild(ParentNode, ChildObject)
            if typeof(ChildObject) ~= "Instance" then
                return nil
            end

            if self.NodesByInstance[ChildObject] then
                return self.NodesByInstance[ChildObject]
            end

            ForceExpandNode(ParentNode)

            local PendingOrder = nil

            if ParentNode.PendingChildren then
                for Index, Pending in ParentNode.PendingChildren do
                    local PendingObject, Order = UnpackPending(Pending)

                    if PendingObject == ChildObject then
                        PendingOrder = Order
                        table.remove(ParentNode.PendingChildren, Index)
                        break
                    end
                end

                if #ParentNode.PendingChildren == 0 then
                    ParentNode.PendingChildren = nil

                    if self.PendingNodesSet then
                        self.PendingNodesSet[ParentNode] = nil
                    end
                end
            end

            if not self.NodesByInstance[ChildObject] then
                local Order = PendingOrder or GetChildOrder(ParentNode.Instance, ChildObject)
                return self:CreateChildNode(ParentNode, ChildObject, Order)
            end

            return self.NodesByInstance[ChildObject]
        end

        local Chain = {}
        local Cursor = ClonerefInstance(Target)

        while Cursor and Cursor ~= game do
            table.insert(Chain, 1, Cursor)
            Cursor = ClonerefInstance(Cursor.Parent)
        end

        if #Chain == 0 then
            return
        end

        for Index, Ancestor in Chain do
            local Node = self.NodesByInstance[Ancestor]

            if not Node then
                local Parent = ClonerefInstance(Ancestor.Parent)
                local ParentNode = Parent and self.NodesByInstance[Parent]

                if not ParentNode then
                    break
                end

                Node = RealiseDirectChild(ParentNode, Ancestor)
            end

            if not Node then
                break
            end

            if Index < #Chain then
                ForceExpandNode(Node)
            end
        end

        self:CollapseAllExceptJumpPath(Target)

        for Index, Ancestor in Chain do
            local Node = self.NodesByInstance[Ancestor]

            if Node and Index < #Chain then
                ForceExpandNode(Node)
            end
        end

        self:SetSelection({Target})

        local ScrollFrame = self.ExplorerColumn and self.ExplorerColumn.Content
        if not ScrollFrame or not ScrollFrame:IsA("ScrollingFrame") then
            return
        end

        for Attempt = 1, 12 do
            task.wait()

            local Node = self.NodesByInstance[Target]

            if not Node then
                for Index, Ancestor in Chain do
                    local ExistingNode = self.NodesByInstance[Ancestor]

                    if ExistingNode and Index < #Chain then
                        ForceExpandNode(ExistingNode)
                    elseif not ExistingNode then
                        local Parent = ClonerefInstance(Ancestor.Parent)
                        local ParentNode = Parent and self.NodesByInstance[Parent]

                        if ParentNode then
                            RealiseDirectChild(ParentNode, Ancestor)
                        end
                    end
                end

                Node = self.NodesByInstance[Target]
            end

            if Node and Node.Row and Node.Row.Parent and Node.Row.AbsoluteSize.Y > 0 then
                local RowAbsY = Node.Row.AbsolutePosition.Y
                local FrameAbsY = ScrollFrame.AbsolutePosition.Y
                local Offset = (RowAbsY - FrameAbsY) + ScrollFrame.CanvasPosition.Y
                local TargetY = math.max(0, Offset - ScrollFrame.AbsoluteSize.Y / 2 + 11)

                ScrollFrame.CanvasPosition = Vector2.new(0, TargetY)

                if self.UpdateStickyHeader then
                    self.UpdateStickyHeader()
                end

                return
            end
        end
    end)
end

function Explorer:HandleSearchSubmit()
    local Query = self.SearchQuery
    if Query == "" then
        return
    end

    local Now = os.clock()

    if self._LastSearchSubmitQuery == Query
        and self._LastSearchSubmitTime
        and Now - self._LastSearchSubmitTime < 0.4
    then
        return
    end

    self._LastSearchSubmitQuery = Query
    self._LastSearchSubmitTime = Now

    self:ProcessSearchExpansionQueue(self.SearchToken, 1)
    self:ScheduleNodeRealiser()
end

function Explorer:UpdateNodeVisual(Object)
    local Node = self.NodesByInstance[Object]
    if not Node or not Node.Row then
        return
    end

    local InSelection = self.SelectedSet[Object] == true
    Node.SelectionAccent.Visible = InSelection
    Node.Row.BackgroundTransparency = InSelection and 0.3 or 1
end

function Explorer:RefreshAllNodeVisuals()
    for Object in self.NodesByInstance do
        self:UpdateNodeVisual(Object)
    end
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
    local Order, Index = self:CollectVisibleFlatOrder()
    local AnchorPosition = Index[AnchorInstance]
    local EndPosition = Index[EndInstance]
    if not AnchorPosition
        or not EndPosition
    then
        self:SetSelection({EndInstance})
        self.SelectionAnchor = EndInstance

        return
    end
    local Low = math.min(AnchorPosition, EndPosition)
    local High = math.max(AnchorPosition, EndPosition)
    local Range = {}
    for Position = Low, High do
        table.insert(Range, Order[Position])
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
            self:EnsureNodeVisible(Object)
        end
    end

    self.SelectedInstance = self.SelectedOrder[#self.SelectedOrder]
    for Object in Old do
        self:UpdateNodeVisual(Object)
    end

    for Object in self.SelectedSet do
        self:UpdateNodeVisual(Object)
    end

    self:OnSelectionChanged()
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
        self:EnsureNodeVisible(Object)
    end

    self:UpdateNodeVisual(Object)
    self:OnSelectionChanged()
end

function Explorer:GetSelectionList()
    return {table.unpack(self.SelectedOrder)}
end

function Explorer:OnSelectionChanged()
    if self.SelectedInstance then
        self:RenderProperties(self.SelectedInstance)
        self:UpdateSelectionHighlights()

        if self.PropertiesTitleLabel then
            self.PropertiesTitleLabel.Text = `{self.SelectedInstance.ClassName}  -  {self.SelectedInstance.Name}`
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
                    Size = UDim2.new(1 / 3, -3, 1, 0);
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
                Size = UDim2.new(0.5, -3, 1, 0);
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

    Services.UserInputService.InputChanged:Connect(function(Input)
        if SVDrag and (Input.UserInputType == Enum.UserInputType.MouseMovement
            or Input.UserInputType == Enum.UserInputType.Touch)
        then
            UpdateSV(Input.Position.X, Input.Position.Y)
        end
    end)

    Services.UserInputService.InputEnded:Connect(function(Input)
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

    Services.UserInputService.InputChanged:Connect(function(Input)
        if HueDrag and (Input.UserInputType == Enum.UserInputType.MouseMovement
            or Input.UserInputType == Enum.UserInputType.Touch)
        then
            UpdateHue(Input.Position.X)
        end
    end)

    Services.UserInputService.InputEnded:Connect(function(Input)
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

        Services.UserInputService.InputChanged:Connect(function(I)
            if Drag
                and (I.UserInputType == Enum.UserInputType.MouseMovement or I.UserInputType == Enum.UserInputType.Touch)
            then
                Up(I.Position.X)
            end
        end)

        Services.UserInputService.InputEnded:Connect(function(I)
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
                    local IconAsset = GetClassAssetId(IconAssetName)
                    if IconAsset then
                        VexUI:CreateInstance("ImageLabel", {
                            Size = UDim2.new(0, 14, 0, 14);
                            Position = UDim2.new(0, 6 - LeftPad, 0.5, -7);
                            BackgroundTransparency = 1;
                            Image = IconAsset;
                            ScaleType = Enum.ScaleType.Fit;
                            Active = false;
                            ZIndex = 204;
                            Parent = Button;
                        })
                    end
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

    if #Sources == 0 then
        return
    end

    local Collected = {}
    local Seen = setmetatable({}, {__mode = "k"})

    local function UnpackPending(Pending)
        if type(Pending) == "table" then
            return Pending.Instance, Pending.Order or 0
        end

        return Pending, 0
    end

    for _, Parent in Sources do
        if typeof(Parent) ~= "Instance" then
            continue
        end

        local ParentNode = self.NodesByInstance[Parent]

        if ParentNode then
            if not ParentNode.Expanded then
                self:ExpandNode(ParentNode)
            end

            if ParentNode.PendingChildren then
                local PendingCopy = {table.unpack(ParentNode.PendingChildren)}

                for _, Pending in PendingCopy do
                    local Child, Order = UnpackPending(Pending)

                    if typeof(Child) == "Instance" and not self.NodesByInstance[Child] then
                        self:CreateChildNode(ParentNode, Child, Order)
                    end
                end

                ParentNode.PendingChildren = nil

                if self.PendingNodesSet then
                    self.PendingNodesSet[ParentNode] = nil
                end
            end
        end

        local Good, Children = pcall(function()
            return WeakGetChildren(Parent)
        end)

        if not Good or type(Children) ~= "table" then
            continue
        end

        SortExplorerChildren(Children)

        for _, Child in Children do
            if typeof(Child) == "Instance" and not Seen[Child] then
                Seen[Child] = true
                table.insert(Collected, Child)
            end
        end
    end

    if #Collected == 0 then
        return
    end

    for _, Child in Collected do
        self:EnsureNodeVisible(Child)
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
            Target = Object:GetPivot()
        end)

        if not Target then
            pcall(function()
                Target = Object.WorldPivot
            end)
        end
    elseif Object:IsA("BasePart") then
        Target = Object.CFrame
    end

    if not Target then
        return false, "no position"
    end

    local Character = self.LocalPlayer.Character
    local PrimaryPart = Character and Character:FindFirstChild("HumanoidRootPart")
    if not PrimaryPart then
        return false, "no HumanoidRootPart"
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

    self.ViewConnection = Track(Services.RunService.RenderStepped:Connect(function()
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
            local Count = 0
            for _, Object in Selection do
                local NewObject
                local Good = pcall(function()
                    NewObject = Instance.new(ClassName)
                    NewObject.Parent = Object
                end)

                if Good and NewObject then
                    Count += 1

                    local ParentNode = self.NodesByInstance[Object]
                    if ParentNode then
                        self:UpdateArrow(ParentNode)

                        if ParentNode.Expanded
                            and not self.NodesByInstance[NewObject]
                        then
                            if self.SearchQuery == ""
                                or (self.MatchSet and self.MatchSet[NewObject])
                                or (self.SubtreeMatchSet and self.SubtreeMatchSet[NewObject])
                            then
                                self:CreateChildNode(ParentNode, NewObject)
                            end
                        end
                    end
                end
            end

            self:Notify(`Inserted {ClassName} into {Count} target(s)`)
            self:CloseModal()
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

        DropdownFollowConnection = Services.RunService.RenderStepped:Connect(function()
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

    local RenderConnection = Track(Services.RunService.RenderStepped:Connect(function(DeltaTime)
        if AutoRotate then
            Yaw += DeltaTime * 0.5
            UpdateCamera()
        end
    end))

    PreviewWindow.Frame.AncestryChanged:Connect(function(_, Parent)
        if not Parent then
            pcall(function()
                RenderConnection:Disconnect()
            end)
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

    Track(Services.UserInputService.InputChanged:Connect(function(Input)
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
    end))

    Track(Services.UserInputService.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1
            or Input.UserInputType == Enum.UserInputType.Touch
        then
            IsDragging = false
        end
    end))
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

    local InputBoxes = {}
    for Index, Spec in Method[3] do
        local SpecName = Spec[1]
        local SpecType = Spec[2]
        local Default = Spec[3] or ""

        local Row = VexUI:CreateInstance("Frame", {
            Size = UDim2.new(1, 0, 0, 38);
            BackgroundTransparency = 1;
            LayoutOrder = 1 + Index;
            ZIndex = 202;
            Parent = Body;
        })

        VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 14);
            BackgroundTransparency = 1;
            Font = Fonts.Medium;
            Text = `{SpecName} : {SpecType}`;
            TextColor3 = Theme.TextDim;
            TextSize = 11;
            TextXAlignment = Enum.TextXAlignment.Left;
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
            if Lowered == "true" or Lowered == "1" then
                return true
            end

            if Lowered == "false" or Lowered == "0" then
                return false
            end

            return nil
        end

        if ArgType == "BasePart" or ArgType == "Instance" then
            return ResolveInstanceText(Text)
        end

        if ArgType == "Vector3" then
            local VectorX, VectorY, VectorZ = Text:match("([%-%d%.]+)[,%s]+([%-%d%.]+)[,%s]+([%-%d%.]+)")
            if VectorX then
                return Vector3.new(tonumber(VectorX), tonumber(VectorY), tonumber(VectorZ))
            end
        end

        if ArgType == "CFrame" then
            local Numbers = {}
            for Token in Text:gmatch("[%-%d%.]+") do
                table.insert(Numbers, tonumber(Token))
            end

            if #Numbers == 12 then
                return CFrame.new(table.unpack(Numbers))
            end

            if #Numbers == 3 then
                return CFrame.new(Numbers[1], Numbers[2], Numbers[3])
            end
        end

        return Text
    end

    local ResultLabel = VexUI:CreateInstance("TextLabel", {
        Size = UDim2.new(1, 0, 0, 40);
        BackgroundColor3 = Theme.Field;
        BorderSizePixel = 0;
        Font = Fonts.Mono;
        Text = "(no result)";
        TextColor3 = Theme.TextDim;
        TextSize = 11;
        TextXAlignment = Enum.TextXAlignment.Left;
        TextWrapped = true;
        TextYAlignment = Enum.TextYAlignment.Top;
        LayoutOrder = 90;
        ZIndex = 202;
        Parent = Body;
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

    CallButton.MouseButton1Click:Connect(function()
        local Args = {}
        for Index, Entry in InputBoxes do
            Args[Index] = ParseArg(Entry.Type, Entry.Box.Text)
        end

        local Good, Result = pcall(function()
            if Method[4] == "global" then
                local Fn = GetGlobalCallable(Method[1])
                if not Fn then
                    error(`Global function not available: {Method[1]}`)
                end

                return Fn(Object, table.unpack(Args, 1, #InputBoxes))
            end

            return Object[Method[1]](Object, table.unpack(Args, 1, #InputBoxes))
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
        BackgroundTransparency = 1;
        BorderSizePixel = 0;
        ClipsDescendants = true;
        ZIndex = 50;
        Parent = self.ScreenGui;
    })
    
    local WindowStroke = VexUI:AddStroke(Window, "Border", 1)
    BindTheme("Window", function(Color)
        Window.BackgroundColor3 = Color
    end)

    BindTheme("Border", function(Color)
        WindowStroke.Color = Color
    end)

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
        Size = UDim2.new(1, -180, 1, 0);
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

    local CopyButton = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(0, 60, 0, 20);
        Position = UDim2.new(1, -98, 0.5, -10);
        BackgroundColor3 = Theme.Field;
        BackgroundTransparency = 0.3;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Font = Fonts.SemiBold;
        Text = "Copy";
        TextColor3 = Theme.Text;
        TextSize = 11;
        ZIndex = 52;
        Parent = TitleBar;
    })
    
    VexUI:AddStroke(CopyButton, "Border", 1)

    CopyButton.MouseButton1Click:Connect(function()
        local Good = pcall(setclipboard, Source)
        CopyButton.Text = Good and "Copied!" or "Failed"

        task.delay(1.2, function()
            if CopyButton and CopyButton.Parent then
                CopyButton.Text = "Copy"
            end
        end)
    end)

    local CloseAssetId = GetUIAssetId("CloseIcon")
    local CloseButton = VexUI:CreateInstance("TextButton", {
        Size = UDim2.new(0, 28, 0, 20);
        Position = UDim2.new(1, -32, 0.5, -10);
        BackgroundColor3 = Theme.Accent;
        BackgroundTransparency = 0.85;
        BorderSizePixel = 0;
        AutoButtonColor = false;
        Font = Fonts.Bold;
        Text = CloseAssetId and "" or "x";
        TextColor3 = Theme.Accent;
        TextSize = 10;
        ZIndex = 52;
        Parent = TitleBar;
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
        for _, Item in self.ScriptViewerWindows do
            if Item.Window and Item.Window.Parent then Item.Window.ZIndex = 50 end
        end

        Window.ZIndex = 55
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

function Explorer:OpenConsole()
    local ConsoleWindow = VexUI:CreateWindow({
        Parent = self.ScreenGui;
        Title = "Console";
        Size = UDim2.fromOffset(560, 380);
        Position = UDim2.fromOffset(80, 80);
    })

    self.ConsoleWindow = ConsoleWindow.Frame

    ConsoleWindow:AddTitleButton("X", 26, true, function()
        self:ToggleConsole()
    end, "CloseIcon")

    local WindowBody = ConsoleWindow.Body

    local IsAutoScrollEnabled = true
    local ConsoleTextSize = 12
    local LogEntries = {}

    local TopBar = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, -16, 0, 26);
        Position = UDim2.new(0, 8, 0, 6);
        BackgroundTransparency = 1;
        Parent = WindowBody;
    })

    local TopBarLayout = VexUI:AddListLayout(
        TopBar,
        6,
        Enum.FillDirection.Horizontal
    )

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
            TextSize = 14;
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
        AutoScrollButton.TextSize = 12

        AutoScrollButton.TextColor3 = IsAutoScrollEnabled and Theme.Green or Theme.TextDim
    end

    AutoScrollButton = CreateTopBarButton("Auto-Scroll: ON", function()
        IsAutoScrollEnabled = not IsAutoScrollEnabled
        UpdateAutoScrollButton()
    end)

    UpdateAutoScrollButton()

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
        for _, LogLabel in LogEntries do
            if LogLabel.Parent then
                LogLabel.TextSize = ConsoleTextSize
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
        for _, LogLabel in LogEntries do
            if LogLabel.Parent then
                LogLabel:Destroy()
            end
        end

        LogEntries = {}
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

    local function AppendLog(LogText, LogColor)
        local LogLabel = VexUI:CreateInstance("TextLabel", {
            Size = UDim2.new(1, 0, 0, 0);
            AutomaticSize = Enum.AutomaticSize.Y;
            BackgroundTransparency = 1;
            Font = Fonts.Mono;
            Text = tostring(LogText);
            TextColor3 = LogColor or Theme.Text;
            TextSize = ConsoleTextSize;
            TextXAlignment = Enum.TextXAlignment.Left;
            TextWrapped = true;
            Parent = LogScrollFrame;
        })

        table.insert(LogEntries, LogLabel)

        if IsAutoScrollEnabled then
            task.defer(function()
                if LogScrollFrame.Parent then
                    LogScrollFrame.CanvasPosition =
                        Vector2.new(0, LogScrollFrame.AbsoluteCanvasSize.Y)
                end
            end)
        end
    end

    local LogService = GetService("LogService")

    pcall(function()
        for _, Entry in LogService:GetLogHistory() do
            local Color

            if Entry.messageType == Enum.MessageType.MessageError then
                Color = Theme.Red
            elseif Entry.messageType == Enum.MessageType.MessageWarning then
                Color = Theme.Yellow
            elseif Entry.messageType == Enum.MessageType.MessageInfo then
                Color = Theme.Blue
            else
                Color = Theme.Text
            end

            AppendLog(Entry.message, Color)
        end
    end)

    self.ConsoleConnection = Track(LogService.MessageOut:Connect(function(Message, MessageType)
        local Color

        if MessageType == Enum.MessageType.MessageError then
            Color = Theme.Red
        elseif MessageType == Enum.MessageType.MessageWarning then
            Color = Theme.Yellow
        elseif MessageType == Enum.MessageType.MessageInfo then
            Color = Theme.Blue
        else
            Color = Theme.Text
        end

        AppendLog(Message, Color)
    end))

    local CommandRow = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, -16, 0, 28);
        Position = UDim2.new(0, 8, 1, -36);
        BackgroundTransparency = 1;
        Parent = WindowBody;
    })

    local CommandLayout = VexUI:AddListLayout(
        CommandRow,
        6,
        Enum.FillDirection.Horizontal
    )

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

    local function FormatArgument(Value)
        local ValueType = typeof(Value)

        if ValueType == "string" then
            return Value
        end

        if ValueType == "Instance" then
            return `{Value.ClassName}({Value:GetFullName()})`
        end

        if ValueType == "table" then
            local Success, EncodedJson = pcall(function()
                return Services.HttpService:JSONEncode(Value)
            end)

            if Success then
                return EncodedJson
            end

            return tostring(Value)
        end

        return tostring(Value)
    end

    local function FormatArguments(...)
        local ArgumentCount = select("#", ...)

        if ArgumentCount == 0 then
            return ""
        end

        local FormattedParts = {}

        for Index = 1, ArgumentCount do
            FormattedParts[Index] = FormatArgument(select(Index, ...))
        end

        return table.concat(FormattedParts, "  ")
    end

        local function ExecuteCommand()
            local Code = CommandBox.Text
            if Code == "" then
                return
            end

            AppendLog(`> {Code}`, Theme.Accent)

            local function CapturedPrint(...)
                AppendLog(FormatArguments(...), Theme.Text)
            end

            local function CapturedWarn(...)
                AppendLog(FormatArguments(...), Theme.Yellow)
            end

            local function CapturedError(Message, Level)
                AppendLog(`error: {tostring(Message)}`, Theme.Red)
                error(Message, (Level or 1) + 1)
            end

            local OriginalLoadstring = loadstring

            local function CapturedLoadstring(Source, ChunkName)
                if type(Source) ~= "string" then
                    return nil, "loadstring: source must be a string"
                end

                local InjectedSource =
                    "local print, warn, error, loadstring = ...\n" .. Source

                local CompiledFunction, CompileError =
                    OriginalLoadstring(InjectedSource, ChunkName or "VexConsoleChunk")

                if not CompiledFunction then
                    return nil, CompileError
                end

                return function(...)
                    return CompiledFunction(
                        CapturedPrint,
                        CapturedWarn,
                        CapturedError,
                        CapturedLoadstring,
                        ...
                    )
                end
            end

            local IsExpression = Code:sub(1, 1) == "="
            local Body = IsExpression and ("return " .. Code:sub(2)) or Code

            local CompiledFunction, CompileError = CapturedLoadstring(Body, "VexConsole")

            if not CompiledFunction then
                AppendLog(`compile: {CompileError}`, Theme.Red)
                return
            end

            local Results = table.pack(pcall(CompiledFunction))
            local Success = Results[1]

            if not Success then
                AppendLog(`runtime: {tostring(Results[2])}`, Theme.Red)
                return
            end

            if IsExpression and Results.n > 1 then
                local OutputParts = {}

                for Index = 2, Results.n do
                    OutputParts[#OutputParts + 1] =
                        FormatArgument(Results[Index])
                end

                AppendLog(table.concat(OutputParts, "  "), Theme.Green)
            end

            CommandBox.Text = ""
        end

    RunButton.MouseButton1Click:Connect(ExecuteCommand)

    CommandBox.FocusLost:Connect(function(EnterPressed)
        if EnterPressed then
            ExecuteCommand()
        end
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
                self:RefreshAllNodeVisuals()

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

                self:RefreshAllNodeVisuals()

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

    CreateHeader("Theme Colors", 10)
    CreateColorRow("Accent", "Accent", 11)
    CreateColorRow("Window", "Window", 12)
    CreateColorRow("Title Bar", "TitleBar", 13)
    CreateColorRow("Field", "Field", 14)
    CreateColorRow("Text", "Text", 15)
    CreateColorRow("Border", "Border", 16)
    CreateColorRow("Selection", "Selected", 17)
    CreateColorRow("Selection Bar", "SelectionBar", 18)

    CreateHeader("Property Value Colors", 20)
    CreateColorRow("String", "PropString", 21)
    CreateColorRow("Number", "PropNumber", 22)
    CreateColorRow("Instance", "PropInstance", 23)
    CreateColorRow("Enum", "PropEnum", 24)
    CreateColorRow("Nil", "PropNil", 25)
    CreateColorRow("Default", "PropDefault", 26)
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

    CreateSection("Search - ClassName Filter", 2, function(Container)
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

    CreateSection("Hidden Services", 3, function(Container)
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

    Window:AddTitleButton("C", 26, false, function()
        self:ToggleConsole()
    end, "ConsoleIcon", nil, 16)

    Window:AddTitleButton("...", 26, false, function()
        self:OpenSettings()
    end, "SettingsIcon", nil, 14)

    Window:AddTitleButton("X", 26, true, function()
        self:Kill()
    end, "CloseIcon", nil, 14)

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

    local SearchHolder = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 0, 36);
        Position = UDim2.new(0, 0, 0, 38);
        BackgroundTransparency = 1;
        Parent = Window.Body;
    })
    self.ExplorerHeader = SearchHolder

    local TreeHolder = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, 0, 1, -74);
        Position = UDim2.new(0, 0, 0, 74);
        BackgroundTransparency = 1;
        Parent = Window.Body;
    })

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

    local StickyHeader = VexUI:CreateInstance("Frame", {
        Size = UDim2.new(1, -8, 0, 22);
        Position = UDim2.new(0, 4, 0, 0);
        BackgroundColor3 = Theme.Window;
        BackgroundTransparency = UITransparency.Window;
        BorderSizePixel = 0;
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
        if not self.RootNodes or #self.RootNodes == 0 then
            StickyHeader.Visible = false

            return
        end

        local ScrollY = Tree.AbsolutePosition.Y
        local CurrentTop
        for _, Root in self.RootNodes do
            if Root.NodeFrame and Root.NodeFrame.Visible and Root.Expanded then
                local FrameTop = Root.NodeFrame.AbsolutePosition.Y
                local FrameBottom = FrameTop + Root.NodeFrame.AbsoluteSize.Y
                if FrameTop < ScrollY and FrameBottom > ScrollY + 22 then
                    CurrentTop = Root

                    break
                end
            end
        end

        if not CurrentTop then
            StickyHeader.Visible = false

            return
        end

        StickyHeader.Visible = true
        local GoodName, Name = pcall(function()
            return CurrentTop.Instance.Name
        end)
        StickyLabel.Text = GoodName and Name or "?"

        if CurrentTop.Icon and CurrentTop.Icon:IsA("ImageLabel") then
            StickyIcon.Image = CurrentTop.Icon.Image
            StickyIcon.ImageRectOffset = CurrentTop.Icon.ImageRectOffset
            StickyIcon.ImageRectSize = CurrentTop.Icon.ImageRectSize
            StickyIcon.Visible = true
        else
            StickyIcon.Visible = false
        end
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
        if self.SearchQuery ~= "" then
            if not self._SearchScrollWorkQueued then
                self._SearchScrollWorkQueued = true

                task.delay(0.08, function()
                    self._SearchScrollWorkQueued = false

                    if KillScript then
                        return
                    end

                    if self.SearchQuery ~= "" then
                        self:ProcessSearchExpansionQueue(self.SearchToken, 1)
                        self:ScheduleNodeRealiser()
                    end
                end)
            end
        else
            self:ScheduleNodeRealiser()
        end

        if self.UpdateStickyHeader then
            self.UpdateStickyHeader()
        end
    end))
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

        for Instance, Node in self.NodesByInstance do
            if Node.Row
                and Node.Row.Parent
                and Node.Row.Visible
                and Node.Row.AbsoluteSize.Y > 0
            then
                local AbsolutePosition = Node.Row.AbsolutePosition
                local AbsoluteSize = Node.Row.AbsoluteSize

                if MouseX >= AbsolutePosition.X
                    and MouseX <= AbsolutePosition.X + AbsoluteSize.X
                    and MouseY >= AbsolutePosition.Y
                    and MouseY <= AbsolutePosition.Y + AbsoluteSize.Y
                then
                    TargetInstance = Instance
                    break
                end
            end
        end

        if not TargetInstance then
            return
        end

        if TargetInstance == self.NilContainerPlaceholder then
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

    MakeItem("Select Children", false, function()
        self:SelectChildrenOfSelection()
    end)

    MakeItem("Clear Search & Jump", false, function()
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

    MakeSeparator()

    MakeItem("Copy Name", false, function()
        if self.SelectedInstance then
            pcall(setclipboard, self.SelectedInstance.Name)
            self:Notify("Name copied")
        end
    end)

    MakeItem("Copy Path", false, function()
        if self.SelectedInstance then
            pcall(setclipboard, self:FullPath(self.SelectedInstance))
            self:Notify("Path copied")
        end
    end)

    MakeItem("Copy ClassName", false, function()
        if self.SelectedInstance then
            pcall(setclipboard, self.SelectedInstance.ClassName)
            self:Notify("ClassName copied")
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

    local CanTeleport = self.SelectedInstance and (self.SelectedInstance:IsA("BasePart") or self.SelectedInstance:IsA("Model"))
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
        writefile(self.ConfigPath, Encoded)
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
            writefile(self.ConfigPath, Services.HttpService:JSONEncode(Info))
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
                writefile(self.ConfigPath, Services.HttpService:JSONEncode(Info))
                Data = nil
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

    self:ClearPropertyConnections()
    self:ResetTasks()

    self:StopViewObject()

    for _, Highlight in self.SelectionHighlights or {} do
        pcall(function()
            Highlight:Destroy()
        end)
    end
    self.SelectionHighlights = setmetatable({}, {__mode = "k"})

    for _, Node in {table.unpack(self.RootNodes)} do
        pcall(function()
            self:DestroyNode(Node)
        end)
    end

    if self.ScriptViewerWindows then
        for _, Item in self.ScriptViewerWindows do
            if Item.Window and Item.Window.Parent then
                Item.Window:Destroy()
            end
        end
        self.ScriptViewerWindows = {}
    end

    pcall(function()
        if self.NilContainerPlaceholder then
            self.NilContainerPlaceholder:Destroy()
            self.NilContainerPlaceholder = nil
        end
    end)

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

    self.NodesByInstance = setmetatable({}, {__mode = "k"})
    self.RootNodes = {}
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
        self.ScreenGui = VexUI:CreateScreenGui()

        self.NodesByInstance = setmetatable({}, {__mode = "k"})
        self.MatchSet = {}
        self.SubtreeMatchSet = {}
        self.ForcedExpanded = setmetatable({}, {__mode = "k"})
        self.SelectedSet = setmetatable({}, {__mode = "k"})

        self:BuildExplorerWindow()
        self:BuildPropertiesWindow()

        self:CreateSearchBar()
        self:CreatePropertyFilterBar()

        self:RebuildExplorer()
        self:AddPropertiesLabel("Select an instance.")

        BindTheme("Accent", function(Color)
            for _, Hl in Explorer.SelectionHighlights or {} do
                if Hl and Hl.Parent then
                    Hl.OutlineColor = Color
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

Explorer:SpawnTask("NilInstancesPoll", function()
    while true do
        if KillScript then
            break
        end

        task.wait(3)

        if KillScript then
            break
        end

        Handle(function()
            local Node = Explorer.NilContainerNode
            if not Node then
                return
            end

            if Node.Expanded and Node.NilVirtualInner then
                Explorer:RefreshNilVirtualList()
            else
                local Total = Explorer:CountNilInstancesLite()

                if Node.Label and Node.Label.Parent then
                    Node.Label.Text = `Nil Instances ({Total})`
                end
            end
        end, "NilInstancesPoll")
    end
end)

Explorer:SpawnTask("ScriptExecutedAgainCheck", function()
    VexExecutedCheck = true
    while task.wait(0.1) do
        if KillScript then
            break
        end

        if VexExecutedCheck == false then
            Explorer:Kill()
            
            break
        end
    end
end)
