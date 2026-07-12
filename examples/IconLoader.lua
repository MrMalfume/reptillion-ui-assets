--[[
    IconLoader — pulls the icons.json manifest from this repo on GitHub
    and hands back ids that Reptillion's Window/Page/Section "Icon"/"Logo"
    fields already understand (they run every icon through FormatImage,
    which only accepts a plain numeric id or "rbxassetid://...").

    Why not just hotlink the PNGs from GitHub? Roblox's ImageLabel.Image
    only ever loads rbxassetid:// content — it can't fetch an arbitrary
    https:// URL at draw time. So the PNGs in icons/ are the *source*
    files: upload each one to Roblox once (Studio > bulk import, or the
    Open Cloud API), drop the resulting numeric id into icons.json, push
    that file back to GitHub. This loader then just downloads that tiny
    JSON manifest at runtime, so you can swap/add icons without touching
    the UI script itself.
]]

local HttpService = game:GetService("HttpService")

local RAW_BASE = "https://raw.githubusercontent.com/<your-username>/reptillion-ui-assets/main/"

local IconLoader = {}
local cache = nil

local function fetchManifest()
    if cache then
        return cache
    end

    local ok, body = pcall(function()
        return game:HttpGet(RAW_BASE .. "icons.json")
    end)

    if not ok then
        warn("[IconLoader] failed to fetch icons.json:", body)
        cache = {}
        return cache
    end

    local decodeOk, decoded = pcall(HttpService.JSONDecode, HttpService, body)
    cache = decodeOk and decoded or {}
    return cache
end

-- Returns a value ready to pass straight into Logo/Icon/Cursor fields.
-- Falls back to a Reptillion-supplied default id if the manifest entry
-- is missing or still the "0" placeholder.
function IconLoader.Get(name, fallbackId)
    local manifest = fetchManifest()
    local id = manifest[name]

    if not id or id == "0" or id == 0 then
        return fallbackId or "0"
    end

    return id
end

function IconLoader.Refresh()
    cache = nil
    return fetchManifest()
end

return IconLoader
