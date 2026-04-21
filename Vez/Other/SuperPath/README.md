# SuperPath — Single-File Build

A standalone, `loadstring`-friendly rebuild of the SuperPath pathfinding library, combining **SuperPath**, **Config**, **PathUtils**, **Signal** (SignalPlus), and **Types** into one script.

---

## Table of Contents

1. [Quick Start](#quick-start)
2. [Loading the Library](#loading-the-library)
3. [Creating an Agent](#creating-an-agent)
4. [AgentParams Reference](#agentparams-reference)
5. [PathSettings Reference](#pathsettings-reference)
6. [RaycastSettings Reference](#raycastsettings-reference)
7. [Methods](#methods)
8. [Signals (Events)](#signals-events)
9. [Public Properties](#public-properties)
10. [Error Types](#error-types)
11. [Recipes / Patterns](#recipes--patterns)
12. [Known Limitations](#known-limitations)

---

## Quick Start

```lua
local SuperPath = loadstring(game:HttpGet("<raw-url-to-SuperPath_Reconstructed.lua>"))()

local char = game.Players.LocalPlayer.Character
local pather = SuperPath.Agent(char, {
    AgentRadius = 2, AgentHeight = 5, AgentCanJump = true,
})

pather.GoalReached:Connect(function() print("Arrived!") end)
pather:Run(Vector3.new(0, 5, 0))
```

---

## Loading the Library

```lua
local SuperPath = loadstring(game:HttpGet("<raw-url>"))()
```

Alternatively, if stored as a ModuleScript, `require(path.to.SuperPath)` works the same way.

The returned table exposes:

| Member | Purpose |
|---|---|
| `SuperPath.Agent(agent, agentParams, pathSettings)` | Creates a new pather object. |
| `SuperPath.ErrorType` | Table of string constants for error comparison. |

---

## Creating an Agent

```lua
local pather = SuperPath.Agent(agent: Model, agentParams: table?, pathSettings: table?)
```

| Arg | Type | Required | Description |
|---|---|---|---|
| `agent` | `Model` | ✅ | The model to move. Must have a valid pivot. If it contains a `Humanoid`, it will be used unless `UseHumanoid = false`. |
| `agentParams` | `table?` | ❌ | Passed directly to `PathfindingService:CreatePath()`. See [AgentParams Reference](#agentparams-reference). |
| `pathSettings` | `table?` | ❌ | Behavioral tuning (timeouts, visualization, stuck detection, etc.). See [PathSettings Reference](#pathsettings-reference). |

---

## AgentParams Reference

Passed into `PathfindingService:CreatePath()`. All fields optional; these are Roblox-defined, not SuperPath-defined.

| Field | Type | Default | Description |
|---|---|---|---|
| `AgentRadius` | `number` | `2` | Horizontal space the agent requires. Lower = fits through tighter gaps. |
| `AgentHeight` | `number` | `5` | Vertical space required. Must be ≥ your agent's height. |
| `AgentCanJump` | `boolean` | `true` | Whether the pathfinder may produce `Jump` waypoints. |
| `AgentCanClimb` | `boolean` | `false` | Whether the pathfinder may produce climb waypoints on trusses. |
| `Costs` | `{[string]: number}` | `{}` | Cost multipliers by material or `PathfindingModifier` label. `math.huge` = impassable. |
| `PathSettings` | `{SupportPartialPath: boolean}` | `nil` | If `SupportPartialPath = true`, returns partial paths when the goal is unreachable. |

Example:
```lua
{
    AgentRadius = 2, AgentHeight = 5,
    AgentCanJump = true, AgentCanClimb = false,
    Costs = { Water = math.huge, Grass = 1, DangerZone = 50 },
    PathSettings = { SupportPartialPath = true },
}
```

---

## PathSettings Reference

SuperPath-specific behavior. Any field omitted falls back to the internal `Config` defaults.

| Field | Type | Default | Description |
|---|---|---|---|
| `RateLimit` | `number` | `0.1` | Minimum seconds between `:Run()` calls. Calls made sooner fire a `RateLimit` error and are ignored. |
| `UseHumanoid` | `boolean` | `true` | If `true`, uses the agent's Humanoid for movement. If `false`, expects the agent's `WorldPivot` to be updated externally. |
| `DoStuckChecks` | `boolean` | `true` | If `true`, periodically samples the agent's position and fires `AgentStuck` when it hasn't moved. |
| `StuckChecks` | `number` | `1` | Number of samples before declaring stuck. Higher = more tolerant. |
| `RetryOnBlocked` | `boolean` | `false` | If the path becomes `Blocked` during traversal, auto-recompute and continue. |
| `DeleteUnneededWaypoints` | `boolean` | `true` | Optimizer: removes waypoints that are too close together. |
| `MinimumSpacing` | `number` | `1` | Minimum stud distance between kept waypoints (only used when `DeleteUnneededWaypoints = true`). |
| `OnFallNoJump` | `boolean` | `false` | If `true`, replaces `Jump` waypoints with `Walk` when the next waypoint is lower than the current one. |
| `OnStepupNoJump` | `boolean` | `false` | If `true`, replaces `Jump` with `Walk` on small elevation changes (Y difference < 1). |
| `RaycastPreRun` | `boolean` | `false` | If `true`, performs a raycast before computing a path — if line-of-sight to the goal exists, walks directly and skips pathfinding entirely. |
| `RaycastSettings` | `table` | see below | Configuration for the pre-run raycast. |
| `WaypointTimeout` | `number` | `8` | Max seconds allowed between two waypoints before firing `TargetUnreachable`. |
| `Visualize` | `boolean` | `false` | If `true`, spawns colored debug spheres along the current path. |
| `VisualizerParent` | `Instance` | `workspace` | Parent for visualization parts. |

---

## RaycastSettings Reference

Only used when `RaycastPreRun = true`.

| Field | Type | Default | Description |
|---|---|---|---|
| `FilterType` | `Enum.RaycastFilterType` | `Exclude` | Whether the filter list includes or excludes matches. |
| `FilteredTags` | `{string}` or `string` | `{}` | CollectionService tags. Future-tagged instances are counted automatically. |
| `FilteredInstances` | `{Instance}` | `{}` | Instances (and their descendants) to filter. |
| `Cooldown` | `number` | `0` | Minimum seconds between consecutive pre-run raycasts. |
| `MaxYOffset` | `number` | `2` | If `goal.Y - origin.Y > MaxYOffset`, the raycast is skipped and normal pathfinding is used. |

---

## Methods

### `pather:Run(goal, origin?)`

Computes a path and starts moving.

| Arg | Type | Required | Description |
|---|---|---|---|
| `goal` | `Vector3`, `CFrame`, `BasePart`, or `Model` | ✅ | Destination. Automatically converted to `Vector3`. |
| `origin` | same types | ❌ | Starting position. Defaults to the agent's current pivot position. |

Returns `true` on a successful compute, `false`/`nil` on failure. Fires `StartRun`, then either `DirectRun` (if LOS skip) or begins normal waypoint traversal.

```lua
pather:Run(workspace.Target)                   -- BasePart
pather:Run(Vector3.new(0, 5, 0))               -- Vector3
pather:Run(otherNPC)                           -- Model
pather:Run(workspace.Target, Vector3.new(0,5,0)) -- custom origin
```

### `pather:TravelToWaypoint(index, shouldContinue?, _sF?)`

Moves to a specific waypoint in the current route **without recomputing**. Used internally, rarely called directly.

### `pather:Pause()`

Freezes the agent in place. Keeps the route intact. Fires `Paused`.

### `pather:Resume()`

Continues from where the agent paused. Fires `Resumed`.

### `pather:Halt()`

Stops movement **and** clears the route. Fires `Halted`.

### `pather:GetDistanceSum(startIndex?, endIndex?)`

Returns the summed stud distance between two waypoint indices in the current route. Defaults: `WaypointIndex → #PathWaypoints`.

```lua
local remaining = pather:GetDistanceSum() -- distance remaining to goal
```

### `pather:ChangeAgentParams(newParams)`

Rebuilds the internal `Path` object with new agent parameters at runtime. Fires `AgentParamsChanged`. Returns `true/false`.

```lua
pather:ChangeAgentParams({ AgentCanJump = false })
```

### `pather:Destroy()`

Cleans up all connections, clears signals, and stops the agent. Fires `Destroying`.

```lua
pather:Destroy()
pather = nil
```

---

## Signals (Events)

Every signal supports `:Connect(fn)`, `:Once(fn)`, `:Wait()`, `:DisconnectAll()`, and `:Destroy()`.

| Signal | Args | Description |
|---|---|---|
| `StartRun` | `goal: Vector3` | Fires at the start of any successful `:Run()`. |
| `DirectRun` | `goal: Vector3` | Fires instead of starting pathfinding when `RaycastPreRun` succeeds. |
| `WaypointReached` | `waypoint: PathWaypoint, index: number` | Fires each time the agent finishes a waypoint. |
| `GoalReached` | `waypoint: PathWaypoint` | Fires when the final waypoint is reached. The route is cleared afterward. |
| `Blocked` | `waypoint: PathWaypoint, index: number` | Fires if the path is blocked by an environment change. |
| `Paused` | — | Fires from `:Pause()`. |
| `Resumed` | — | Fires from `:Resume()`. |
| `Halted` | — | Fires from `:Halt()`. |
| `Error` | `errType: string` | Fires on any failure. See [Error Types](#error-types). |
| `AgentParamsChanged` | `newParams` | Fires on successful `:ChangeAgentParams()`. |
| `OnJump` | — | Reserved for future use; not fired by default. |
| `Destroying` | — | Fires just before `:Destroy()` tears down. |

Example:
```lua
pather.WaypointReached:Connect(function(wp, i)
    print("Reached", i, "/", #pather.PathWaypoints)
end)
```

---

## Public Properties

Read these freely; write only if you know what you're doing.

| Property | Type | Description |
|---|---|---|
| `Agent` | `Model` | The model being moved. |
| `Humanoid` | `Humanoid?` | Cached Humanoid reference (if any). |
| `Path` | `Path` | Underlying Roblox `Path` object. |
| `Idle` | `boolean` | `true` when not pathfinding. |
| `IsPathfinding` | `boolean` | `true` if moving via waypoints. `false` during a `DirectRun`. |
| `IsPartial` | `boolean` | `true` if the current path is a partial path. |
| `IsDestroying` | `boolean` | `true` after `:Destroy()` is called. |
| `LastError` | `string?` | The last error type fired. |
| `WaypointIndex` | `number` | Index of the waypoint currently being traveled to. |
| `LastWaypoint` | `PathWaypoint?` | Two waypoints ago. |
| `LatestWaypoint` | `PathWaypoint?` | The most recently reached waypoint. |
| `NextWaypoint` | `PathWaypoint?` | The waypoint the agent is heading to. |
| `PathWaypoints` | `{PathWaypoint}` | Full list of waypoints in the current route. |
| `Goal` | `Vector3?` | Current goal. |
| `AgentInAir` | `boolean` | Updated from `Humanoid.FloorMaterial`. |

---

## Error Types

Stable string constants available via `SuperPath.ErrorType`:

| Constant | Meaning | Typical Cause |
|---|---|---|
| `"CompError"` | Path compute failed | `NoPath` status, goal unreachable, internal failure. |
| `"RateLimit"` | `:Run()` called too soon | Respect `RateLimit` or debounce your calls. |
| `"AgentStuck"` | Agent hasn't moved within `StuckChecks` samples | Physics stuck, obstacle, fallen off. |
| `"TargetUnreachable"` | Waypoint not reached within `WaypointTimeout` | Path was valid but the agent could not physically complete it. |
| `"MaxDistExceeded"` | Goal > 3000 studs from origin | Roblox's hard pathfinding limit. |

Pattern:
```lua
pather.Error:Connect(function(err)
    if err == SuperPath.ErrorType.AgentStuck then
        pather:Run(pather.Goal)
    elseif err == "RateLimit" then
        -- never retry on ratelimit
    elseif err == "MaxDistExceeded" then
        warn("Goal too far; choose a closer point")
    end
end)
```

---

## Recipes / Patterns

### Follow a moving target

```lua
task.spawn(function()
    while pather and not pather.IsDestroying do
        pather:Run(target) -- accepts Model/BasePart/CFrame/Vector3
        task.wait(0.5)     -- respect RateLimit
    end
end)
```

### Rebind the pather to a new agent

```lua
pather.Agent    = newModel
pather.Humanoid = newModel:FindFirstChildOfClass("Humanoid")
pather:Run(goal)
```

### Safe retry on error

```lua
pather.Error:Connect(function(err)
    if err == "RateLimit" then return end         -- never retry ratelimit
    if err == "MaxDistExceeded" then return end   -- retrying won't help
    task.wait(1)
    if pather.Goal then pather:Run(pather.Goal) end
end)
```

### Debug with visualization

```lua
local pather = SuperPath.Agent(char, agentParams, {
    Visualize        = true,
    VisualizerParent = workspace,
})
```

Waypoint colors:
- 🟠 **Orange** — regular walk waypoint
- 🟣 **Purple** — jump waypoint
- 🔵 **Blue** — special-labeled (PathfindingModifier) waypoint
- 🟢 **Green** — final goal

### Wait synchronously for arrival

```lua
pather:Run(goal)
pather.GoalReached:Wait()
print("Done.")
```

### Cleanup

```lua
pather:Destroy()
pather = nil
```

---

## Known Limitations

- **3000 stud hard cap** on path length (enforced by Roblox / `MaxDistExceeded`).
- **No dynamic obstacle avoidance.** Use the `Blocked` signal or `RetryOnBlocked`.
- **`RaycastPreRun` skips pathfinding entirely** when LOS to the goal is clear. If there is passable geometry between origin and goal but no walkable ground (e.g. open air), the agent may move into unsafe areas. Leave disabled when unsure.
- **Agents without a Humanoid** rely on `WorldPivot` changes to detect waypoint arrival; their pivot must be updated externally.

---

## Credits

- **SuperPath** — original modular library, here consolidated into a single file.
- **SignalPlus v3.7.2** — © 2025 Alexander Lindholt, MIT. https://github.com/AlexanderLindholt/SignalPlus

## License

MIT.
