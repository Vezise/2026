<div align="center">

# VEX Explorer
**This README was made with AI, who cares.**
**A full-featured in-game Roblox Explorer + Properties window for executors.**

Built from scratch with a custom UI framework, virtualized trees, live property editing, syntax-highlighted script viewer, and persistent configuration.

</div>

---

## Table of Contents

- [Overview](#overview)
- [Installation](#installation)
- [Default Keybinds](#default-keybinds)
- [Features](#features)
  - [Core Explorer](#core-explorer)
  - [Nil Instances](#nil-instances)
  - [Selection](#selection)
  - [Search](#search)
  - [Properties Panel](#properties-panel)
  - [Context Menu](#context-menu-right-click)
  - [Insert Object](#insert-object)
  - [Call Function](#call-function)
  - [Call Remote](#call-remote)
  - [Script Viewer](#script-viewer)
  - [Modals](#modals)
  - [Settings](#settings)
  - [Filters Dropdown](#filters-dropdown)
  - [Title Bar Buttons](#title-bar-buttons)
  - [Window System](#window-system)
  - [Notifications](#notifications)
  - [Configuration / Persistence](#configuration--persistence)
  - [Asset System](#asset-system)
  - [Error Handling](#error-handling)
  - [Lifecycle](#lifecycle)
  - [Auto-Update / Version Check](#auto-update--version-check)
- [Configuration](#configuration)
- [Credits](#credits)

---

## Overview

VEX Explorer is a Roblox developer-style Explorer/Properties tool designed for executors. It mirrors the look and feel of Roblox Studio's Explorer + Properties panes, with deep integration features tailored for live game inspection: nil instance discovery, remote calling, script decompilation viewing, and reparenting — all from a clean, themeable UI.

## Installation

Get the script here:
[vez's Discord Server](https://discord.com/invite/6e7mm8xbbb)

## Default Keybinds

| Key | Action |
|-----|--------|
| `Right Alt` | Toggle UI visibility (rebindable in Settings) |
| `Ctrl` + click | Toggle item in selection |
| `Shift` + click | Range-select between anchor and target |
| `Esc` | Cancel reparent mode |
| `Right Click` | Open context menu on a node |
| `Enter` (in search) | Jump to first match |

---

## Features

### Core Explorer

- Tree view of `game` with all services as root nodes
- Pinned service ordering (Workspace, Players, Lighting, ReplicatedFirst, ReplicatedStorage, StarterPlayer, StarterPack, StarterGui, CoreGui), then alphabetical
- Per-class icons downloaded from a GitHub asset repo and cached to disk
- Lazy/virtualized child node creation with a budgeted realizer based on scroll viewport + overscan
- Auto-updating tree on `ChildAdded` / `ChildRemoved` / `Name` changes
- Sticky service header pinned to top of tree while scrolling
- Expand/collapse arrows per node with child indicator

### Nil Instances

- Top-level **Nil Instances** virtual folder using `getnilinstances`
- Recursive descendant collection so children of nil objects are searchable
- Virtualized scrolling list — only visible rows are rendered
- Live count label `Nil Instances (X)` or `(filtered/total)`
- Background polling every 3s with a lightweight counter when collapsed (no lag spikes)
- Yielding walks so large trees don't freeze the frame
- Toggle to show/hide the nil folder
- Toggle to include/exclude nil instances in search
- ClassName filter for nil contents (synced between Filters dropdown and Settings)

### Selection

- Single click select
- `Ctrl` + click to toggle in selection
- `Shift` + click range-select based on visible flat order
- Multi-select with order tracking
- Selection accent bar + row highlight
- Auto-expand ancestors of selected instances
- **Select Children** action

### Search

- Live search box with 250ms debounce
- Case-insensitive substring match on `Name`
- Auto-expand ancestors of all matches (capped at 800)
- Color coding: matches in accent, ancestors in dim, non-matches faded
- Token-based cancellation when query changes mid-walk
- ClassName filter set with a large preset list of common classes
- Auto-collapse all services + nil folder when search box is cleared
- `Enter` to jump to first match
- **Clear Search & Jump** action to reset and scroll to selection

### Properties Panel

- Auto-populated from category groups for the matched class hierarchy
- Categorized headers (BasePart, Model, Humanoid, GuiObject, etc.)
- Filter properties box
- Per-property type-aware editors:
  - Text input for strings, numbers, `Vector2`, `Vector3`, `CFrame`, `UDim`, `UDim2`
  - Boolean toggle switch
  - `Color3` / `BrickColor` swatch + color picker
  - Enum dropdown (modal list)
- Read-only properties dimmed/non-editable (`ClassName`, `AccountAge`, `UserId`, `Occupant`, etc.)
- Property change signal hooks for live updates
- Auto-refresh task with configurable interval (0–3s)
- Manual **Refresh Properties** action
- Apply edits to entire selection (multi-edit)
- Color coding by type (string, number, instance, enum, nil, default)
- Title shows `ClassName - Name` and selection count when multi-selected

### Context Menu (Right-Click)

- **Insert Object**
- **Duplicate**
- **Copy** / **Paste Into**
- **Reparent** (click-target mode with indicator banner, `Esc` to cancel)
- **Select Children**
- **Clear Search & Jump**
- **Copy Name** / **Copy Path** / **Copy ClassName**
- **Anchor** / **Unanchor** (recurses descendants)
- **Teleport Here** (`BasePart` / `Model`)
- **Call Function**
- **Call Remote**
- **Script View**
- **Refresh Properties**
- **Destroy**
- Auto-repositions to stay on screen

### Insert Object

- Modal list of insertable classes (filterable, with class icons)
- Inserts into all selected parents

### Call Function

- Modal list of callable methods (`Instance` / `Model` / `BasePart` / `Humanoid` / `Player` / `Sound` / `Tool`)
- Per-arg parser with type hints (`string`, `number`, `boolean`, `Vector3`, `CFrame`)
- Result preview with `OK` / `ERROR` formatted return

### Call Remote

- Auto-detects `RemoteEvent` / `UnreliableRemoteEvent` / `RemoteFunction` / `BindableEvent` / `BindableFunction`
- Multi-line argument editor (one per line, auto-typed)
- `FireServer` / `InvokeServer` / `Fire` / `Invoke`

### Script Viewer

- `decompile`-based source view (graceful fallback message when unavailable)
- Luau syntax highlighting:
  - Keywords, builtins, globals
  - Numbers, strings, comments
  - Functions, members, types, operators
- Line numbers gutter
- Chunked rendering with rich text size cap to handle huge scripts
- **Copy** source button
- Multiple windows stackable, draggable, click-to-front

### Modals

- Reusable modal window with blocker, drag, close
- List modal with search, item icons, multi-line option
- Color picker with R/G/B sliders and live preview

### Settings

- Toggle keybind rebinder (listen for any key)
- Auto-refresh properties toggle
- Refresh delay slider (0–3s, 0.1 step)
- Theme preset selector:
  - Crimson (default)
  - Studio
  - Discord
  - Ocean
  - Forest
  - Midnight
  - Eye Cancer (light)
- Per-key theme color overrides:
  - Window, Title Bar, Field, Text, Border, Selection, Selection Bar, Accent
  - `PropString`, `PropNumber`, `PropInstance`, `PropEnum`, `PropNil`, `PropDefault`

### Filters Dropdown

Anchored to the Explorer window:

- **Nil Instances** section (show folder, search nil, class filter)
- **Search ClassName Filter** (grid of common classes with icons)
- **Hidden Services** section (per-service toggles + Hide All Services)
- Live refresh of all toggle states

### Title Bar Buttons

- Custom icon support (`SettingsIcon`, `CloseIcon` from GitHub assets)
- **TP - PlaceId** — rejoin same place
- **TP - JobId** — rejoin same server
- **Kick Self**
- **Settings** (gear icon)
- **Close / Kill** (X icon)

### Window System

- Custom window with title bar, brand label, accent dot, draggable
- 8-way edge resizing (corners + sides) with min size clamp
- Edge snap (top / left / right / bottom of viewport)
- Window-to-window snap with auto-resize to match width
- Smooth tween-back when snapped
- Side-by-side Explorer + Properties windows
- Visibility toggle via keybind
- Reparent mode indicator overlay

### Notifications

- Stacked toast system bottom-right
- Info / success / error variants
- Auto-fade with timed lifetime (2.2s normal, 5s error)
- Used for action confirmations and error reporting

### Configuration / Persistence

JSON config at `Vex/Vex.lua`. Saves:

- `ToggleKey`
- `AutoRefreshProperties`
- `RefreshDelay`
- `NilFilterClass`
- `ActiveClassFilters`
- `HiddenServices`
- `HideNilContainer`
- `SearchIncludesNil`
- Full theme color overrides

Additional behavior:

- Version-pinned (fetched from GitHub) — auto-resets on version change
- Debounced/batched theme saves
- Auto-creates `Vex/` folder structure

### Asset System

- Downloads PNG icons from GitHub on first use
- Caches to `Vex/Assets/`
- Uses `getcustomasset` for runtime IDs
- Prefetches on startup (background task)
- Graceful fallback to text glyph (`?`) when assets are unavailable
- Supports class icons and UI icons (Search, Settings, Filter, Collapse, Close)

### Error Handling

- `Handle()` wrapper with `xpcall` + line number extraction
- Persistent error log at `Vex/ErrorLogs/ErrorLog_N.txt` (rotates per session, max 100)
- In-game error notifications with function name + line
- `pcall`-wrapped instance access throughout (handles destroyed/protected instances)

### Lifecycle

- Single-instance enforcement — kills previous `VexExplorer` GUIs on load
- `getgenv().VexExecutedCheck` watchdog — auto-kills on re-execution
- Clean shutdown: disconnects all tracked connections, cancels tasks, destroys placeholders, GUIs, notifications

### Auto-Update / Version Check

- Pulls remote version string from GitHub on init
- Wipes config on version mismatch

---

## Configuration

Configuration is stored as JSON at:

```
workspace/Vex/Vex.lua
```

Errors are logged to:

```
workspace/Vex/ErrorLogs/ErrorLog_N.txt
```

Cached assets:

```
workspace/Vex/Assets/
```

> Paths are relative to your executor's workspace root.

## Credits

- **Author:** Vez
- **UI:** custom `VexUI` framework built into the script
- **Icons:** hosted at [`VexExplorer/Assets`](https://github.com/Vezise/2026/tree/main/Vez/Libraries/VexExplorer/Assets)

- **Owner & Developer of VEX Explorer**
- @vezagain (1387876110246609127) on Discord
- [vez's Discord Server](https://discord.com/invite/6e7mm8xbbb)
- [v3rm.net Profile](https://v3rm.net/members/vez.976/)
- [vez's Website](https://vezzy.cc/)
