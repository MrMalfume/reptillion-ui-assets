-- Example: loading Reptillion UI + icons hosted on GitHub

local REPO_RAW = "https://raw.githubusercontent.com/<your-username>/reptillion-ui-assets/main/"

local IconLoader = loadstring(game:HttpGet(REPO_RAW .. "examples/IconLoader.lua"))()
local Library = loadstring(game:HttpGet("<url-to-your-Ui.lua>"))()

local Window = Library:Window({
    Name = "Reptillion",
    Version = "1.0.0",
    Logo = IconLoader.Get("logo", "135215559087473"), -- falls back to the library's default logo
    Size = UDim2.fromOffset(650, 450),
    ToggleKey = "RightShift",
})

local Home = Window:Page({
    Name = "Home",
    Icon = IconLoader.Get("home"),
})

local Settings = Window:SettingsPage({
    Name = "Settings",
    Icon = IconLoader.Get("settings"),
})

local Section = Home:Section({ Name = "Welcome", Icon = IconLoader.Get("star") })

Section:Button({
    Name = "Reload icons",
    Callback = function()
        IconLoader.Refresh()
        Library:Notification({
            Name = "Icons",
            Description = "Manifest reloaded from GitHub.",
            Icon = IconLoader.Get("star"),
            Duration = 3,
        })
    end,
})
