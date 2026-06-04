# Starlight Framework made by plasma

A lightweight framework around the [Starlight UI Library](https://docs.nebulasoftworks.xyz). Instead of writing full Starlight table syntax every time, this framework gives you short one-line calls that handle everything for you.

> **Disclaimer:** By using this framework you agree that I (plasma / 8zsk) is not responsible for any consequences resulting from its use — including account bans, data loss, or violations of Robloxs Terms of Service. Use at your own risk.

---

## Getting Started

Edit the `CONFIG` table at the top to set your scripts name, theme, keybind, and config folder before loading.

---

## Adding a Feature

Each feature gets its own tab. Here's a full example:

```lua
local myTab   = Framework:Tab("Main", "My Feature", "star", 2, true)
local myGroup = Framework:Group(myTab, "Controls", 1, "sliders")

Framework:Toggle(myGroup, "my_toggle", "Enable", false, function(val)
    print("enabled:", val)
end)

Framework:Slider(myGroup, "my_speed", "Walk Speed", 0, 200, 16, " studs/s", function(val)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = val
end)

Framework:Dropdown(myGroup, "my_mode", "Mode", {"Fast", "Slow", "Auto"}, {"Fast"}, false, function(selected)
    print("mode:", selected[1])
end)

Framework:Button(myGroup, "my_btn", "Do Something", "play", function()
    print("clicked")
end)
```

---

## API

**`Framework:Tab(sectionName, tabName, tabIcon, columns, visible)`**
Creates a new tab inside a collapsible section. `columns` is usually `2`. `visible` controls whether the section starts expanded.
```lua
local myTab = Framework:Tab("Main", "My Feature", "star", 2, true)
```

**`Framework:Group(tab, name, column, groupIcon)`**
Creates a groupbox inside a tab. `column` is `1` for left, `2` for right.
```lua
local myGroup = Framework:Group(myTab, "Controls", 1, "sliders")
```

**`Framework:Toggle(group, id, name, default, callback)`**
On/off switch. `default` is `true` or `false`. Callback receives the new boolean.
```lua
Framework:Toggle(myGroup, "my_toggle", "Enable", false, function(val)
    print("enabled:", val)
end)
```

**`Framework:Slider(group, id, name, min, max, default, suffix, callback)`**
Number slider. `suffix` is the unit shown after the value, e.g. `" studs/s"`. Callback receives the current number.
```lua
Framework:Slider(myGroup, "my_speed", "Walk Speed", 0, 200, 16, " studs/s", function(val)
    print("speed:", val)
end)
```

**`Framework:Dropdown(group, id, name, options, default, multiple, callback)`**
Select menu. `options` is a table of strings. `multiple` allows picking more than one. Callback receives a table of selected strings.
```lua
Framework:Dropdown(myGroup, "my_mode", "Mode", {"Fast", "Slow", "Auto"}, {"Fast"}, false, function(selected)
    print("mode:", selected[1])
end)
```

**`Framework:Button(group, id, name, btnIcon, callback)`**
Clickable button. Callback fires on click.
```lua
Framework:Button(myGroup, "my_btn", "Do Something", "play", function()
    print("clicked")
end)
```

**`Framework:Label(group, id, name, labelIcon)`**
Static single-line text. Good for status readouts.
```lua
Framework:Label(myGroup, "my_label", "Status: Active", "activity")
```

**`Framework:Paragraph(group, id, name, content)`**
Title + body text block. Good for descriptions or multi-line info.
```lua
Framework:Paragraph(myGroup, "my_para", "About", "This feature does something cool.")
```

**`Framework:Get(id)` / `Framework:Set(id, value)`**
Read or write any element's value from anywhere in your script.
```lua
Framework:Get("my_toggle")       -- returns true or false
Framework:Set("my_toggle", true) -- turns it on programmatically
```

**`Framework:Notify(title, desc, duration)`**
Pops a toast notification in the corner of the UI. `duration` is in seconds, defaults to `3`.
```lua
Framework:Notify("Done!", "Something finished.", 5)
```

---

## Themes

`Starlight` `Hollywood Dark` `Hollywood Light` `Orca` `Glacier` `Pacific` `Crimson` `Neo` `Neo (dark)` `Nebula`

Set via `CONFIG.Theme` at the top of the script.
Check the [Starlight UI Library](https://docs.nebulasoftworks.xyz) for more.

---

## Icons

Default pack is **Lucide**. Browse icons at [lucide.dev](https://lucide.dev) or [phosphoricons.com](https://phosphoricons.com).

Other available packs: `Material` `Phosphor` `Phosphor-Filled` `SF` `Symbols` `Symbols-Filled` `Lab` `Fluency`

Check the [Nebula Icons Library](https://docs.nebulasoftworks.xyz/nebula-icons) for more.

---

## Questions / Support

Discord: **8zsk**
