# Illusion ScaleManager

A simple replacement for `TextScaled` that uses viewport width to control text size.
---

## Overview

This module applies a `UIScale` to a `TextLabel` and updates it based on the camera’s viewport width.
The result is consistent, predictable scaling across different resolutions.

Using ISM, The Point of a TextLabel is **uniquely to display text**. It will have **NO** other purposes.
The Original Wish was that we could set a proper TextSize (pixels) on a Text, and it would scale for any screen resolutions.
A TextLabel is **required** to be **placed** inside a **GuiObject container** with some properties set.
**See Recommended Setup for more informations**

---

## Installation

* Place the module in a `ModuleScript` (e.g. `ReplicatedStorage.Modules`)
* Require it from a **LocalScript**/**ClientScript**

```luau
local ISM = require("@game/ReplicatedStorage/IllusionScaleManager")
```

---

## Usage

```luau
local ISM = require("@game/ReplicatedStorage/IllusionScaleManager")

local label = script.Parent:WaitForChild("TextLabel")
local scaledText = ScaleManager.new(label)
```

---

## Base Width

Default is `1920`. use the BaseWidth property when calling the constructor to change it.

```luau
local scaledText = ScaleManager.new(label, 1366)
```

Scaling is calculated as:

```luau
scale = viewportWidth / baseWidth
```

---

## Cleanup

Handled automatically when the `TextLabel` is destroyed.

Manual cleanup:

```luau
manager:Destroy()
```

---

## Notes

* Client-only (uses `workspace.CurrentCamera`)
* If a `UIScale` already exists, it will be reused but not destroyed
* This module should be the only thing modifying `UIScale.Scale` on the label

---

## Recommended Setup For a TextLabel

IMPORTANT: Make sure the TextLabel is Inside: A Frame, A TextButton...
Also (for TextButtons), you may remove the Text already set and put it to the Label.
You may use TextWrapped. Adjust TextSize as you wish, it will scale !
```lua
Size = UDim2.new(0.5, 0, 0.5, 0)
Position = UDim2.new(0.5, 0, 0.5, 0)
AnchorPoint = Vector2.new(0.5, 0.5)
TextScaled = false
BackgroundTransparency = 1
```
