# Crimson | Animation Logger & Spy

An animation logging/spying tool made by vez. Effortlessly log animations and their properties, find a use for them!

---

## Script

Execute this script in your executor:

```lua
-------------// SETTINGS \\-------------
getgenv().SafeMode = true
-- Anti-Detection kick (if applicable)
getgenv().AutoClearLogsDelay = 99999
-- How many seconds to wait before logs are automatically cleared
getgenv().BlockedAnimations = {"Animation1", "Animation2", "RunAnim", "WalkAnim"}
-- Animations to block from logging

getgenv().ChosenTargetFolder = nil
--[[
    In ChosenTargetFolder, change nil to destination folder
    to start logging the animations of all models with a
    humanoid within that folder when using 'Log: Others' option
    Otherwise it will not allow you to select 'Log: Others'
]]--

local ScriptDev = "Vez"
local ScriptName = "Crimson"

loadstring(game:HttpGet(("https://raw.githubusercontent.com/%sise/2026/main/%s/%s.lua"):format(ScriptDev, ScriptDev, ScriptName)))("Animation Spy")
```

---

## Key Features

- **Instantaneous Logging** - Instantly log animations
- **Animation Blocking** - Block specific animations that may be useless or annoying (by name via the config, AnimId support not added yet)
- **Choose Your Targets** - Log animations from your LocalPlayer, all Players or from a path of your own
- **Auto Clear Logs** - Automatically clear logs on a customisable interval
- **'As Simple As Possible'** - Extremely simple to use, even for people who lack knowledge in Luau

## Why Would I Use This?

- **Game Development** - Steal animations for your own use
- **Exploit Research** - Discover exploits (Invisibility, Auto Parry, etc.) using this tool
- **Script Logging** - Some obfuscated scripts use animations for exploits, such as mentioned above; use this tool to figure what animations & properties they are using 
- **Animation Replication** - Animations played on your client replicate to the server.. show off?
- **Do It Yourself (DIY)** - Figure out why you want to use this!

---

## Configuration

### Auto Clear Logs Delay
Controls how often (in seconds) logged animations are automatically deleted to clear clutter and save some performance.

```lua
getgenv().AutoClearLogsDelay = 99999
```

### Animation Blacklist
Specify the names of animations you want to exclude from logging to avoid clutter of useless animations like 'Idle' or 'WalkAnim'

```lua
getgenv().BlockedAnimations = {"Animation1", "Animation2", "RunAnim", "WalkAnim"}
```

### Target Folder For Specific Logging
Set a specific path (paired with 'Others' target option) to log animations from all the Humanoid/AnimationController within it. Leave it as `nil` if you won't be using this feature.

```lua
getgenv().ChosenTargetFolder = nil
```

> **Tip:** You can use Dex Explorer scripts such as [BypassedDarkDexV3](https://github.com/Babyhamsta/RBLX_Scripts/blob/main/Universal/BypassedDarkDexV3.lua) to find the path for logging descendants with Humanoid/AnimationController (could for example be a specific NPC or folder of NPC's).

---

# Crimson | Animation Logger/Spy

**Release Thread:** [v3rm.net Release](https://v3rm.net/threads/release-crimson-animation-logger.27858/)

**Owner & Developer of Crimson**
- @vezagain (1387876110246609127) on Discord
- [vez's Discord Server](https://discord.com/invite/6e7mm8xbbb)
- [v3rm.net Profile](https://v3rm.net/members/vez.976/)
- [vez's Website](https://vezzy.cc/)

**UI Developer:**
- @moonroon (287338370932277258) on Discord
- [v3rm.net Profile](https://v3rm.net/members/moonroon.58444/)

---

# Crimson Features
<img width="476" height="235" alt="image" src="https://github.com/user-attachments/assets/b967ba5a-1dd3-4be0-837c-a627e58c67eb" />

## Animation Preview
**Loop Preview, Delay Loop** - Previews the selected animation on a viewmodel with a delay option to give it a little timeout before playing again
<img width="126" height="187" alt="image" src="https://github.com/user-attachments/assets/f696b9f0-d5c7-478e-a4f5-c950b5d7938d" />


## Delay Settings
**0s / 1s / 2s / 3s** - Delay the logging of animations, I don't know why you'd want this.. but I made it a feature anyways.

## Logging Targets
Select what animations to log:
- **LocalPlayer** - Log only your own animations
- **All Players** - Log animations from all players except yourself
- **Other** - Log animations from a custom path (model, folder, etc.) you specify
<img width="348" height="234" alt="image" src="https://github.com/user-attachments/assets/77f792ea-485b-46f0-b16e-87c944043ed5" />

## Copy AnimId
Copy the AnimationId of the selected animation to your clipboard.

## Copy Properties
Generates a script with all the animations' properties so you can run it yourself or implement it into your script.
<img width="243" height="150" alt="image" src="https://github.com/user-attachments/assets/8d885bc3-5b9f-49c1-8ac2-0af8ced373ec" />


## Play Anim
Replicates the selected animation on to your character (replicated to the server, meaning anyone can see).
<img width="102" height="190" alt="image" src="https://github.com/user-attachments/assets/f490f778-421e-4f15-acf3-c0339f4e1d58" />


## Property Display
When an animation is selected, the UI displays the properties of the animation to provide you with more information, these same properties get copied when using 'Copy Properties'.
<img width="350" height="239" alt="image" src="https://github.com/user-attachments/assets/6f0688be-c52e-40f7-8132-780e67a46835" />

## Logging Toggle
Toggle logging on & off, self explanatory.

## Stacking Toggle
Stacks animations with the same AnimationId to avoid clutter; recommended to use this for performance and for your own sanity.

---

# License

## Terms of Use

### Use at Your Own Risk
This script is provided as-is without any warranty. Users assume full responsibility for any consequences resulting from its use.

### Educational & Experimental Purposes Only
This script is intended for educational and experimental use only. Users are responsible for ensuring their usage complies with all applicable terms of service and local laws.

### Modification & Attribution
You are free to modify and redistribute this script. However, credit to the original developer is appreciated and preferred.

### Disclaimer of Liability
The developer will not be held accountable for any issues, damages, or troubles caused directly or indirectly by this script. This includes but is not limited to account bans, data loss, or any other adverse effects.

---

**By using this script, you acknowledge and agree to all terms stated above.**
