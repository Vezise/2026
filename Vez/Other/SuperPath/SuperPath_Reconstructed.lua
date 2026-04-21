--!optimize 2
--[[
    SuperPath — consolidated into a single LocalScript.
    Contains: Types, Config, Signal (SignalPlus v3.7.2 by Alexander Lindholt, MIT),
              PathUtils, and SuperPath.

    Usage example (at the bottom of this script):
        local path = SuperPath.Agent(myAgentModel, agentParams, pathSettings)
        path:Run(targetPosition)
]]

local PFS    = game:GetService("PathfindingService")
local CS     = game:GetService("CollectionService")
local Debris = game:GetService("Debris")

--==============================================================--
-- TYPES
--==============================================================--
-- (Lua runtime has no effect from `export type`, but kept for Luau)
export type ErrorType =
	"CompError" |
	"RateLimit" |
	"AgentStuck" |
	"TargetUnreachable" |
	"MaxDistExceeded"
export type ToVector = Vector3 | CFrame | Model | BasePart | vector
export type AgentParams = {
	AgentRadius: number?,
	AgentHeight: number?,
	AgentCanJump: boolean?,
	AgentCanClimb: boolean?,
	Costs: {[string]: number}?,
	PathSettings: {SupportPartialPath: boolean}?
}?
export type RaycastSettings = {
	FilterType: Enum.RaycastFilterType?,
	FilteredTags: {string?} | string?,
	FilteredInstances: {Instance}? | Instance?,
	Cooldown: number?,
	MaxYOffset: number?
}?
export type PathSettings = {
	RateLimit: number?,
	UseHumanoid: boolean?,

	DoStuckChecks: boolean?,
	StuckChecks: number?,

	RetryOnBlocked: boolean?,

	DeleteUnneededWaypoints: boolean?,
	MinimumSpacing: number?,
	OnFallNoJump: boolean?,
	OnStepupNoJump: boolean?,

	RaycastPreRun: boolean?,
	RaycastSettings: RaycastSettings?,

	Visualize: boolean?,
	VisualizerParent: Instance,
}?

--==============================================================--
-- CONFIG
--==============================================================--
local Config = {
	RATE_LIMIT = 0.1,

	DO_STUCK_CHECKS = true,
	STUCK_CHECKS = 1,

	RETRY_ON_BLOCKED = false,

	DELETE_UNNEEDED_WAYPOINTS = true,
	MINIMUM_SPACING = 1,
	ON_FALL_NO_JUMP = false,
	ON_STEPUP_NO_JUMP = false,

	RAYCAST_PRE_RUN = false,
	RAYCAST_SETTINGS = {
		FilterType = Enum.RaycastFilterType.Exclude,
		FilteredTags = {},
		FilteredInstances = {},
		Cooldown = 0,
		MaxYOffset = 2
	},

	WAYPOINT_TIMEOUT = 8,

	VISUALIZE = false,
	VISUALIZER_COLOURS = {
		REGULAR = Color3.new(1, 0.36, 0),
		GOAL = Color3.new(0.28, 1, 0.02),
		JUMP = Color3.new(0.48, 0.42, 1),
		SPECIAL = Color3.new(0, 0.01, 1)
	},
	VISUALIZER_PARENT = workspace
}

--==============================================================--
-- SIGNAL (SignalPlus v3.7.2 — MIT © 2025 Alexander Lindholt)
-- https://github.com/AlexanderLindholt/SignalPlus
--==============================================================--
local Signal
do
	-- Types.
	export type SignalConnection = {
		Signal: any,
		Connected: boolean,
		Disconnect: (self: SignalConnection) -> ()
	}

	-- Spawn function (no attribute support on a LocalScript body — default to task.spawn).
	local spawnThread = task.spawn

	-- Reusable callback threads.
	local threads = {}

	local function reusableThreadCall(callback, thread, ...)
		local items = {...}
		pcall(function()
			callback(unpack(items))
			table.insert(threads, thread)
		end)
	end
	local function reusableThread()
		while true do
			reusableThreadCall(coroutine.yield())
		end
	end

	-- Connection disconnect.
	local function disconnect(connection)
		if not connection.Connected then return end
		connection.Connected = nil

		local signal = connection.Signal
		local previous = connection.Previous
		local next = connection.Next
		if previous then
			previous.Next = next
		else
			signal.Tail = next
		end
		if next then
			next.Previous = previous
		else
			signal.Head = previous
		end
	end

	-- Signal methods.
	local SignalProto = {}
	SignalProto.__index = SignalProto

	SignalProto.Connect = function(signal, callback)
		local head = signal.Head
		local connection = {
			Signal = signal,
			Previous = head,
			Callback = callback,
			Connected = true,
			Disconnect = disconnect
		}
		if head then
			head.Next = connection
		else
			signal.Tail = connection
		end
		signal.Head = connection
		return connection
	end

	SignalProto.Once = function(signal, callback)
		local head = signal.Head
		local connection
		connection = {
			Signal = signal,
			Previous = head,
			Callback = function(...)
				if not connection.Connected then return end
				connection.Connected = false

				local previous = connection.Previous
				local next = connection.Next
				if previous then
					previous.Next = next
				else
					signal.Tail = next
				end
				if next then
					next.Previous = previous
				else
					signal.Head = previous
				end

				callback(...)
			end,
			Connected = true,
			Disconnect = disconnect
		}
		if head then
			head.Next = connection
		else
			signal.Tail = connection
		end
		signal.Head = connection
		return connection
	end

	SignalProto.Wait = function(signal)
		local thread = coroutine.running()
		local head = signal.Head
		local connection
		connection = {
			Previous = head,
			Callback = function(...)
				connection.Connected = false
				local previous = connection.Previous
				local next = connection.Next
				if previous then
					previous.Next = next
				else
					signal.Tail = next
				end
				if next then
					next.Previous = previous
				else
					signal.Head = previous
				end
				if coroutine.status(thread) == "suspended" then
					task.spawn(thread, ...)
				end
			end
		}
		if head then
			head.Next = connection
		else
			signal.Tail = connection
		end
		signal.Head = connection
		return coroutine.yield()
	end

	SignalProto.Fire = function(signal, ...)
		local connection = signal.Tail
		while connection do
			local length = #threads
			if length == 0 then
				local thread = coroutine.create(reusableThread)
				coroutine.resume(thread)
				spawnThread(thread, connection.Callback, thread, ...)
			else
				local thread = threads[length]
				threads[length] = nil
				spawnThread(thread, connection.Callback, thread, ...)
			end
			connection = connection.Next
		end
	end

	SignalProto.DisconnectAll = function(signal)
		local connection = signal.Tail
		while connection do
			local nextConnection = connection.Next
			connection.Connected = nil
			connection.Next = nil
			connection.Previous = nil
			connection = nextConnection
		end
		signal.Tail = nil
		signal.Head = nil
	end

	SignalProto.Destroy = function(signal)
		local connection = signal.Tail
		while connection do
			local nextConnection = connection.Next
			connection.Connected = nil
			connection.Next = nil
			connection.Previous = nil
			connection = nextConnection
		end
		signal.Tail = nil
		signal.Head = nil
		setmetatable(signal, nil)
	end

	-- Constructor.
	Signal = function()
		return setmetatable({}, SignalProto)
	end
end

--==============================================================--
-- PATH UTILS
--==============================================================--
local Util = {}
do
	local VisualizerColours = Config.VISUALIZER_COLOURS

	local function isSpecialWaypoint(wp)
		if not wp then return false end
		local uniqueLabel = not Enum.Material:FromName(wp.Label)
		local uniqueAction = wp.Action == Enum.PathWaypointAction.Jump
		return uniqueLabel or uniqueAction
	end

	local function hasUniqueLabel(wp)
		return not Enum.Material:FromName(wp.Label) and wp.Label ~= "Jump"
	end

	local function doWarn(message)
		warn("[SuperPath]: "..message)
	end

	local function declareError(self, errorType)
		self.LastError = errorType
		self.Error:Fire(errorType)
	end

	function Util.Compute(pathObj, origin, goal)
		local path = pathObj.Path

		local DeleteUnneededWaypoints = pathObj.DeleteUnneededWaypoints
		local OnStepupNoJump = pathObj.OnStepupNoJump
		local OnFallNoJump = pathObj.OnFallNoJump

		local ok, err = pcall(function()
			path:ComputeAsync(origin, goal)
		end)
		if not ok then
			doWarn("Failed to compute route due to error: "..err)
			return false, {}, false
		end
		if path.Status == Enum.PathStatus.NoPath then
			return false, {}, false
		end

		local waypoints = path:GetWaypoints()
		local keptWaypoints = nil

		if DeleteUnneededWaypoints or OnFallNoJump or OnStepupNoJump then
			keptWaypoints = {}
			for i = 1, #waypoints, 1 do
				local thisWp = waypoints[i]
				local lastWp = waypoints[i - 1]
				local nextWp = waypoints[i + 1]

				if not thisWp then continue end

				if DeleteUnneededWaypoints then
					local thisIsSpecial = isSpecialWaypoint(thisWp)
					local nextIsSpecial = isSpecialWaypoint(nextWp)

					if not (thisIsSpecial or nextIsSpecial) and lastWp then
						if (thisWp.Position - lastWp.Position).Magnitude < pathObj.MinimumSpacing then
							continue
						end
					end
				end
				table.insert(keptWaypoints, thisWp)

				if thisWp.Action.Name == "Jump" then
					local yDiff = thisWp.Position.Y - lastWp.Position.Y
					if (OnFallNoJump and yDiff < 0) or (OnStepupNoJump and yDiff < 1) then
						keptWaypoints[i] = PathWaypoint.new(thisWp.Position, Enum.PathWaypointAction.Walk)
					end
				end
			end
		end

		return true, keptWaypoints or waypoints, path.Status.Name == "ClosestNoPath"
	end

	function Util.Visualize(pathObj)
		if not pathObj.Visualize then return end

		pathObj._wpParts = pathObj._wpParts or {}
		for wp in pathObj._wpParts do
			wp:Destroy()
		end
		local pathWaypoints = pathObj.PathWaypoints
		for i, waypoint in pathWaypoints do
			local part = Instance.new("Part")
			part.Size = Vector3.new(1,1,1)
			part.Anchored = true
			part.CanCollide = false
			part.Material = Enum.Material.Neon
			part.Position = waypoint.Position
			part.Shape = Enum.PartType.Ball
			part.Transparency = 0.35
			if i == #pathWaypoints then
				part.Color = VisualizerColours.GOAL
			elseif waypoint.Label and hasUniqueLabel(waypoint) then
				part.Color = VisualizerColours.SPECIAL
			else
				if waypoint.Action ~= Enum.PathWaypointAction.Walk then
					part.Color = VisualizerColours.JUMP
				else
					part.Color = VisualizerColours.REGULAR
				end
			end
			part.Parent = pathObj.VisualizerParent
			pathObj._wpParts[part] = true
			Debris:AddItem(part, 10)
		end
	end

	function Util.ComparePosition(pathObj)
		local posChecks = pathObj.StuckChecks
		local positions = pathObj.PositionRecords

		table.insert(positions, pathObj.Agent:GetPivot().Position)

		if #positions >= 1 + posChecks then
			local pos1 = positions[1]
			local pos2 = positions[#positions]
			if pos1:FuzzyEq(pos2, 0.1) then
				declareError(pathObj, "AgentStuck")
			end
			table.remove(positions, 1)
		end
	end

	function Util.GetDistance(pathObj, startWp, endWp)
		local waypoints = pathObj.PathWaypoints
		local totalDist = 0
		for i = startWp, endWp do
			local thisWp = waypoints[i]
			local lastWp = waypoints[i - 1]
			if lastWp then
				totalDist += (lastWp.Position - thisWp.Position).Magnitude
			end
		end
		return totalDist
	end

	function Util.RaycastCheck(pathObj, origin, goal)
		local rcSettings = pathObj.RaycastSettings
		if goal.Y - origin.Y > rcSettings.MaxYOffset then return false end

		local tags = rcSettings.FilteredTags
		tags = typeof(tags) == "string" and {tags} or tags

		local rcParams = RaycastParams.new()
		rcParams.FilterType = rcSettings.FilterType
		rcParams:AddToFilter(rcSettings.FilteredInstances)
		for i, tag in tags do
			rcParams:AddToFilter(CS:GetTagged(tag))
		end

		local result = workspace:Raycast(origin, (goal - origin) * 1.005, rcParams)
		if result and result.Instance then
			if result.Position:FuzzyEq(goal, 0.2) then
				return true
			end
			return false
		else
			return true
		end
	end
end

--==============================================================--
-- SUPERPATH
--==============================================================--
local function clearRoute(path)
	path.WaypointIndex = 0
	path.LastWaypoint = nil
	path.LatestWaypoint = nil
	path.NextWaypoint = nil
	path.CurrentlyPartial = false
	path.PathWaypoints = {}
	path.Goal = nil
	path.Idle = true
end

local function reconcile(default, fallback)
	if typeof(default) == "table" then
		for k, v in pairs(fallback) do
			if default[k] == nil then
				default[k] = v
			end
		end
		return default
	end
	return if default ~= nil then default else fallback
end

local function toVector3(item)
	local typeofItem = typeof(item)
	local isInstance = typeofItem == "Instance"
	if typeofItem == "Vector3" or typeofItem == "vector" then
		return item
	elseif typeofItem == "CFrame" or (isInstance and item:IsA("BasePart")) then
		return item.Position
	elseif isInstance and item:IsA("Model") then
		return item:GetPivot().Position
	end
	return item
end

local function doWarn(message)
	warn("[SuperPath]: "..message)
end

local function declareError(self, errorType)
	self.LastError = errorType
	self.Error:Fire(errorType)
end

local function safeCleanUp(self, itemName)
	local item = self[itemName]
	if typeof(item) == "thread" then
		task.cancel(item)
		self[itemName] = nil
	elseif typeof(item) == "RBXScriptConnection" then
		item:Disconnect()
		self[itemName] = nil
	end
end

local function getAgentPos(self)
	return self.Agent:GetPivot().Position
end

local function freezeAgent(agent)
	local hum = agent:FindFirstChild("Humanoid")
	if hum then
		hum:MoveTo(agent:GetPivot().Position)
	end
end

-----------------------------------------------------
local Path = {}
Path.__index = Path

function Path:Run(goal, origin)
	if not self or self.IsDestroying then return end
	if os.clock() - self.LastRun < self.RateLimit then
		declareError(self, "RateLimit")
		return
	end
	self.RateLimit = os.clock()

	local customOrigin = true
	origin = reconcile(toVector3(origin), (function()
		customOrigin = false
		return getAgentPos(self)
	end)())
	goal = toVector3(goal)

	clearRoute(self)
	safeCleanUp(self, "_blockCon")

	if self.DoStuckChecks then
		task.spawn(Util.ComparePosition, self)
	end

	if self.Humanoid and self.RaycastPreRun then
		if os.clock() - (self._lastRc or 0) >= self.RaycastSettings.Cooldown then
			self._lastRc = os.clock()
			if Util.RaycastCheck(self, self.Agent:GetPivot().Position, goal) then
				self.Idle = false
				self.IsPathfinding = false
				self.Goal = goal
				self.StartRun:Fire(goal)
				self.DirectRun:Fire(goal)
				self.Humanoid:MoveTo(goal)
				return true
			end
		end
	end

	if (goal - origin).Magnitude > 3000 then
		declareError(self, "MaxDistExceeded")
		return false
	end

	local ok, waypoints, isPartial = Util.Compute(self, origin, goal)
	if not ok then
		declareError(self, "CompError")
		return false
	else
		self.IsPathfinding = true
		self.IsPartial = isPartial
		self.PathWaypoints = waypoints
		self.NextWaypoint = waypoints[1]
		self.Goal = goal

		self.StartRun:Fire(goal)

		Util.Visualize(self)

		self._blockCon = self.Path.Blocked:Connect(function(wpIndex)
			if wpIndex >= self.WaypointIndex then
				safeCleanUp(self, "_blockCon")
				self.Blocked:Fire(self.PathWaypoints[wpIndex], wpIndex)
				if self.RetryOnBlocked then
					self:Run(goal, origin)
				end
			end
		end)
		task.spawn(function()
			self:TravelToWaypoint(1, true, not customOrigin)
		end)
		return true
	end
end

function Path:TravelToWaypoint(index, shouldContinue, _sF)
	if not self or self.IsDestroying then return end
	safeCleanUp(self, "_observer")
	safeCleanUp(self, "_moveCon")

	local thisWaypoint = self.PathWaypoints[index]
	if not thisWaypoint then return end

	self.WaypointIndex = index
	self.LastWaypoint = self.PathWaypoints[index - 2]
	self.LatestWaypoint = self.PathWaypoints[index - 1]
	self.NextWaypoint = thisWaypoint

	self.Idle = false

	local function done(reached)
		if self.Idle then return end
		if reached then
			self.WaypointReached:Fire(thisWaypoint, index)
			if not self.PathWaypoints[index + 1] then
				clearRoute(self)
				self.GoalReached:Fire(thisWaypoint)
			else
				if not self.Idle and shouldContinue then
					self:TravelToWaypoint(index + 1, true)
				end
			end
		else
			freezeAgent(self.Agent)
			declareError(self, "TargetUnreachable")
		end
	end
	self._observer = task.delay(self.WaypointTimeout, function()
		safeCleanUp(self, "_moveCon")
		done(false)
	end)

	local hum = self.Humanoid
	if hum then
		hum:MoveTo(thisWaypoint.Position)

		if not (_sF and index == 1) then
			if thisWaypoint.Action == Enum.PathWaypointAction.Jump then
				if not self.AgentInAir then
					hum.Jump = true
				end
			end
		else
			done(true)
		end

		self._moveCon = hum.MoveToFinished:Once(function(reached)
			safeCleanUp(self, "_observer")
			safeCleanUp(self, "_moveCon")
			done(reached)
		end)
	else
		local agent = self.Agent
		self._moveCon = agent:GetPropertyChangedSignal("WorldPivot"):Connect(function()
			local newPivot = agent:GetPivot()
			if newPivot.Position:FuzzyEq(thisWaypoint.Position) then
				safeCleanUp(self, "_observer")
				safeCleanUp(self, "_moveCon")
				done(true)
			end
		end)
	end
end

function Path:Pause()
	if not self or self.IsDestroying then return end
	if self.Idle then return end
	self.Idle = true
	freezeAgent(self.Agent)
	self.Paused:Fire()
end

function Path:Resume()
	if not self or self.IsDestroying then return end
	if not self.Idle then return end
	self.Idle = false
	self.Resumed:Fire()
	if self.IsPathfinding then
		self:TravelToWaypoint(self.WaypointIndex, true)
	else
		self.Humanoid:MoveTo(self.Goal)
	end
end

function Path:Halt()
	if not self or self.IsDestroying then return end
	if self.Idle then return end
	self.Idle = true
	freezeAgent(self.Agent)
	clearRoute(self)
	self.Halted:Fire()
end

function Path:GetDistanceSum(startWpIndex, endWpIndex)
	if not self or self.IsDestroying then return end
	if self.Idle then return 0 end
	startWpIndex = startWpIndex or self.WaypointIndex
	endWpIndex = endWpIndex or #self.PathWaypoints
	return Util.GetDistance(self, startWpIndex, endWpIndex)
end

function Path:ChangeAgentParams(newParams)
	if not self or self.IsDestroying then return end
	local s, err = pcall(function()
		self.Path = PFS:CreatePath(newParams)
	end)
	if not s then
		doWarn("Failed to create path with new Agent Params, path remains unchanged. Error: "..err)
		return false
	end
	self.AgentParamsChanged:Fire(newParams)
	return true
end

function Path:Destroy()
	if not self or self.IsDestroying then return end
	freezeAgent(self.Agent)
	self.Destroying:Fire()
	self.IsDestroying = true
	task.spawn(function()
		task.wait()
		setmetatable(self, nil)
		for i, v in self do
			pcall(function()
				v:Disconnect()
				v:Destroy()
			end)
			self[i] = nil
		end
		self = nil
	end)
end

-----------------------------------------------------
local SuperPath = {
	ErrorType = {
		TargetUnreachable = "TargetUnreachable",
		AgentStuck = "AgentStuck",
		CompError = "CompError",
		MaxDistExceeded = "MaxDistExceeded",
	}
}

function SuperPath.Agent(agent, agentParams, pathSettings)
	pathSettings = pathSettings or {}

	local useHum = reconcile(pathSettings.UseHumanoid, true)

	local path
	local s, err = pcall(function()
		path = PFS:CreatePath(agentParams)
	end)
	if not s then
		doWarn("Failed to create path when calling .Agent(). Error: "..err)
	end

	local self = setmetatable({
		-- CONFIGURATION
		WaypointTimeout = reconcile(pathSettings.WaypointTimeout, Config.WAYPOINT_TIMEOUT),
		Visualize = reconcile(pathSettings.Visualize, Config.VISUALIZE),
		VisualizerParent = reconcile(pathSettings.VisualizerParent, Config.VISUALIZER_PARENT),
		DeleteUnneededWaypoints = reconcile(pathSettings.DeleteUnneededWaypoints, Config.DELETE_UNNEEDED_WAYPOINTS),
		MinimumSpacing = reconcile(pathSettings.MinimumSpacing, Config.MINIMUM_SPACING),
		OnFallNoJump = reconcile(pathSettings.OnFallNoJump, Config.ON_FALL_NO_JUMP),
		OnStepupNoJump = reconcile(pathSettings.OnStepupNoJump, Config.ON_STEPUP_NO_JUMP),
		DoStuckChecks = reconcile(pathSettings.DoStuckChecks, Config.DO_STUCK_CHECKS),
		StuckChecks = reconcile(pathSettings.StuckChecks, Config.STUCK_CHECKS),
		RetryOnBlocked = reconcile(pathSettings.RetryOnBlocked, Config.RETRY_ON_BLOCKED),
		RaycastPreRun = reconcile(pathSettings.RaycastPreRun, Config.RAYCAST_PRE_RUN),
		RaycastSettings = reconcile(pathSettings.RaycastSettings, Config.RAYCAST_SETTINGS),
		RateLimit = reconcile(pathSettings.RateLimit, Config.RATE_LIMIT),

		-- PUBLIC MEMBERS
		Agent = agent,
		Humanoid = (useHum and agent:FindFirstChild("Humanoid")) or nil,
		Path = path,
		Idle = true,
		LastError = nil,
		WaypointIndex = 0,
		LastWaypoint = nil,
		LatestWaypoint = nil,
		NextWaypoint = nil,
		IsPartial = false,
		PathWaypoints = {},
		Goal = nil,
		PositionRecords = {},
		AgentInAir = false,
		IsPathfinding = true,
		IsDestroying = false,
		LastRun = 0,

		-- SIGNALS
		Error = Signal(),
		Blocked = Signal(),
		Paused = Signal(),
		Resumed = Signal(),
		Halted = Signal(),
		AgentParamsChanged = Signal(),
		WaypointReached = Signal(),
		GoalReached = Signal(),
		StartRun = Signal(),
		DirectRun = Signal(),
		OnJump = Signal(),
		Destroying = Signal(),
	}, Path)

	local hum = self.Humanoid
	if hum then
		self._airCon = hum:GetPropertyChangedSignal("FloorMaterial"):Connect(function()
			self.AgentInAir = hum.FloorMaterial.Name == "Air"
		end)
	end

	return self
end

return SuperPath
