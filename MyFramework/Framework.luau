--[[
A lightweight framework around the Starlight UI library
If youre new to starlight, the docs are at: https://docs.nebulasoftworks.xyz

Also check my Github README for more information or just DM me on discord if you have any questions or need help with something!
Discord: 8zsk
Github: 

- LICENSE & DISCLAIMER -
This script is free to use, modify, and redistribute however
you like. No credit required, do whatever you want with it.
By using this script you agree that I (plasma / 8zsk) is not responsible
for any consequences that result from its use, including but
not limited to account bans, data loss, or violations of any
platforms terms of service. Please use at your own risk.

Thank you for using this framework
--]]

local CONFIG = {
    Name = "Plasma", -- Shows in the window with the title
    Version = "1.0.0", -- Just for display
    Subtitle = "by you", -- Shows under the title
    Theme = "Nebula", -- Starlight | Hollywood Dark | Hollywood Light | Orca | Glacier | Pacific | Crimson | Neo | Neo (dark) | Nebula - Check docs for more
    Keybind = "RightShift", -- Keybind to toggle the UI, set to nil to disable
    ConfigFolder = "Plasma", -- Folder name used for saving configs, created inside your executors config directory
    Dashboard = true, -- Set to false if you dont want the dashboard tab
}

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local lp = Players.LocalPlayer

local Starlight = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/starlight"))() -- Starlight is the UI library
local Icons = loadstring(game:HttpGet("https://raw.nebulasoftworks.xyz/nebula-icon-library-loader"))() -- Starlight has a icon API with many cool icons

local Framework = {
    Window = nil,
    Tabs = {},
    Groups = {},
    Elements = {},  -- Every element you create gets stored here by there id, lets you get/set values later
}

--[[
icon() is just a shorthand so you dont have to write Icons:GetIcon() everywhere
available icon packs: Lucide (default), Material, Phosphor, Phosphor-Filled, SF, Symbols, Symbols-Filled, Lab, Fluency - Check the API docs for more
--]]

local function icon(name, pack)
    return Icons:GetIcon(name, pack or "Lucide") or 0
end

local function notify(title, desc, duration)
    if not Framework.Window then return end
    Framework.Window:Notify({
        Title = title,
        Content = desc or "",
        Time = duration or 3,
    })
end

Framework.Notify = notify -- expose notify function so you can call it from your features without needing to refrence the whole framework

local function initWindow() -- Call this before creating any tabs or element
    Framework.Window = Starlight:CreateWindow({
        Name = CONFIG.Name,
        Subtitle = CONFIG.Subtitle,
        Icon = icon("sparkles"), -- You can use any icon from the API here
        LoadingSettings = {
            Title = CONFIG.Name,
            Subtitle = "Loading...",
        },
        FileSettings = {
            ConfigFolder = CONFIG.ConfigFolder,
        },
    })

    if CONFIG.Theme ~= "Starlight" then
        Starlight:SetTheme(CONFIG.Theme)
    end
end

--[[
Framework:Tab(sectionName, tabName, tabIcon, columns, visible)
    sectionName = the collapsible section this tab lives under (can group multiple tabs under one section)
    tabName = label on the tab button
    tabIcon = lucide icon name (string), check the API docs for more icons
    columns = how many columns of groupboxes the tab has, usually 2
    visible = whether the section starts expanded (true) or collapsed (false)
--]]

function Framework:Tab(sectionName, tabName, tabIcon, columns, visible)
    local section = self.Window:CreateTabSection(sectionName, visible ~= false)
    local tab = section:CreateTab({
        Name = tabName,
        Columns = columns or 2,
        Icon = icon(tabIcon or "folder"),
    }, tabName:lower():gsub("%s+", "_") .. "_tab")
    self.Tabs[tabName] = tab
    return tab
end

--[[
Framework:Group(tab, name, column, groupIcon)
    tab = the tab returned from Framework:Tab()
    name = label on the groupbox
    column = which column to place it in (1 = left, 2 = right)
    groupIcon = lucide icon name
--]]

function Framework:Group(tab, name, column, groupIcon)
    local group = tab:CreateGroupbox({
        Name = name,
        Column = column or 1,
        Icon = icon(groupIcon or "box"),
    }, name:lower():gsub("%s+", "_") .. "_group")
    self.Groups[name] = group
    return group
end

--[[
Framework:Button(group, id, name, btnIcon, callback)
    id = unique string used to reference this element later
    callback = function that runs when the button is clicked
--]]

function Framework:Button(group, id, name, btnIcon, callback)
    local btn = group:CreateButton({
        Name = name,
        Icon = btnIcon and icon(btnIcon),
        Callback = callback or function() end,
    }, id)
    self.Elements[id] = btn
    return btn
end

--[[
Framework:Toggle(group, id, name, default, callback)
    id = unique string used to reference this element later
    default = starting state, true = on / false = off
    callback = function(val) where val is the new boolean state
--]]

function Framework:Toggle(group, id, name, default, callback)
    local toggle = group:CreateToggle({
        Name = name,
        CurrentValue = default or false,
        Style = 2,
        Callback = callback or function() end,
    }, id)
    self.Elements[id] = toggle
    return toggle
end

--[[
Framework:Slider(group, id, name, min, max, default, suffix, callback)
    suffix = unit label shown after the number, e.g. " studs/s" or " ms"
    callback = function(val) where val is the current number
    note: default increment is set to 1, change it inside this function if you need decimals
--]]

function Framework:Slider(group, id, name, min, max, default, suffix, callback)
    local slider = group:CreateSlider({
        Name = name,
        Range = { min or 0, max or 100 },
        Increment = 1,
        CurrentValue = default or min or 0,
        Suffix = suffix or "",
        Callback = callback or function() end,
    }, id)
    self.Elements[id] = slider
    return slider
end

--[[
Framework:Dropdown(group, id, name, options, default, multiple, callback)
    options = table of strings, e.g. {"Option A", "Option B"}
    default = table of pre-selected options, e.g. {"Option A"}
    multiple = true if the user can pick more than one option at a time
    callback = function(selected) where selected is a table of chosen options
--]]

function Framework:Dropdown(group, id, name, options, default, multiple, callback)
    local dd = group:AddDropdown({
        Options = options or {},
        CurrentOption = default or {},
        MultipleOptions = multiple or false,
        Placeholder = "Select " .. name,
        Callback = callback or function() end,
    }, id)
    self.Elements[id] = dd
    return dd
end

--[[
Framework:Label(group, id, name, labelIcon)
    just a static text line, useful for status readouts or section labels
--]]

function Framework:Label(group, id, name, labelIcon)
    local lbl = group:CreateLabel({
        Name = name,
        Icon = labelIcon and icon(labelIcon),
    }, id)
    self.Elements[id] = lbl
    return lbl
end

--[[
Framework:Paragraph(group, id, name, content)
    like a label but with a title + body, good for descriptions or multi-line info
--]]

function Framework:Paragraph(group, id, name, content)
    local para = group:CreateParagraph({
        Name    = name,
        Content = content or "",
    }, id)
    self.Elements[id] = para
    return para
end

--[[
Framework:Get(id) / Framework:Set(id, value)
    lets you read or change an elements value from anywhere in your script
    e.g.  Framework:Get("my_toggle")  returns true/false
          Framework:Set("my_toggle", true)  turns it on programmatically
--]]

function Framework:Get(id)
    local el = self.Elements[id]
    return el and el.Values and el.Values.CurrentValue
end

function Framework:Set(id, value)
    local el = self.Elements[id]
    if el and el.Set then
        el:Set({ CurrentValue = value }, id)
    end
end

local function buildDashboard()
    local tab = Framework:Tab("Dashboard", "Dashboard", "layout-dashboard", 2, false)

    local welcome = Framework:Group(tab, "Welcome", 1, "user")
    Framework:Label(welcome, "dash_name", lp.Name, "user")
    Framework:Paragraph(welcome, "dash_status", "Status",
        CONFIG.Name .. " v" .. CONFIG.Version .. " loaded.\nAll features active.")

    local info = Framework:Group(tab, "Info", 2, "activity")
    Framework:Label(info, "dash_version", "Version: " .. CONFIG.Version, "cpu")
    Framework:Label(info, "dash_tier", "Tier: Free", "shield-check")

    local actions = Framework:Group(tab, "Quick Actions", 1, "zap")
    Framework:Button(actions, "btn_discord", "Copy Discord", "message-circle", function()
        -- setclipboard is an executor global that works with most executors
        -- setclipboard("your discord link here")
        notify("Copied!", "Discord link copied to clipboard.")
    end)
    Framework:Button(actions, "btn_reload", "Reload Script", "refresh-cw", function()
        notify("Reloading", "Script will reload shortly.")
        -- loadstring(game:HttpGet("your raw github url here"))()
    end)
end

local function buildSettings()
    local tab = Framework:Tab("Settings", "Settings", "settings", 2, true)
    local keyGroup = Framework:Group(tab, "Keybinds", 1, "keyboard")

    -- the label element supports AddBind which turns it into a keybind picker
    local lbl = Framework:Label(keyGroup, "keybind_label", "UI Toggle: " .. CONFIG.Keybind)
    lbl:AddBind({
        HoldToInteract = false,
        CurrentValue   = CONFIG.Keybind,
        Callback = function(active)
            if active then
                Framework.Window.Instance.Visible = not Framework.Window.Instance.Visible
            end
        end,
    }, "ui_bind")

    -- these two calls add the built-in config saver and theme switcher panels
    -- they live in column 2 of the settings tab automatically
    tab:BuildConfigGroupbox(2)
    tab:BuildThemeGroupbox(2)
    Starlight:LoadAutoloadConfig()
    Starlight:LoadAutoloadTheme()
end

-- resets anything that features might have changed when the ui gets closed/destroyed
local function setupCleanup()
    Starlight:OnDestroy(function()
        local char = lp.Character
        if char then
            local hum = char:FindFirstChild("Humanoid")
            if hum then
                hum.WalkSpeed = 16
                hum.JumpPower = 50
            end
        end
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        Lighting.OutdoorAmbient = Color3.fromRGB(0, 0, 0)
        Lighting.FogEnd = 1000
    end)
end

-- dashboard has to be built before settings or the tab order gets weird
initWindow()
if CONFIG.Dashboard then buildDashboard() end
buildSettings()
setupCleanup()

notify(CONFIG.Name, "v" .. CONFIG.Version .. " loaded! Press " .. CONFIG.Keybind .. " to toggle.", 4)

--[[
 - YOUR FEATURES GO BELOW HERE -
each feature should have its own Tab so things stay organized
heres a full example showing every element type:

local myTab = Framework:Tab("Main", "My Feature", "star", 2, true)
local myGroup = Framework:Group(myTab, "Controls", 1, "sliders")

Framework:Toggle(myGroup, "my_toggle", "Enable Feature", false, function(val)
     print("toggled:", val)
  end)

  Framework:Slider(myGroup, "my_speed", "Walk Speed", 0, 200, 16, " studs/s", function(val)
      if lp.Character then
          lp.Character.Humanoid.WalkSpeed = val
      end
  end)

  Framework:Dropdown(myGroup, "my_drop", "Mode", {"Fast", "Slow", "Auto"}, {"Fast"}, false, function(selected)
      print("picked:", selected[1])
  end)

  Framework:Button(myGroup, "my_btn", "Do Something", "play", function()
      print("clicked!")
  end)
--]]

return Framework