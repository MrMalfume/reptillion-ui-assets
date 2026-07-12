# reptillion-ui-assets

Icon assets for the **Reptillion UI** Roblox library, hosted on GitHub so they
can be versioned like any other asset and swapped out without touching the UI
script.

```
icons/            source PNGs (128x128, white silhouette, transparent bg)
  logo.png
  home.png
  settings.png
  star.png
icons.json        name -> rbxassetid manifest, fetched at runtime
examples/
  IconLoader.lua   downloads icons.json and hands back ready-to-use ids
  Example.lua      wires IconLoader into Library:Window / Page / Section
```

## Why not just hotlink the PNGs?

Roblox's `ImageLabel.Image` only ever loads `rbxassetid://…` content — the
engine never fetches an arbitrary `https://` URL at draw time, so a raw
`raw.githubusercontent.com/...png` link will not render. `Ui/Ui.lua`'s
`FormatImage` helper (used by every `Logo`/`Icon` field) confirms this: it
only accepts a plain numeric id or an already-prefixed `rbxassetid://` string.

So the actual workflow is:

1. Design/update an icon, drop the PNG in `icons/`, commit & push.
2. Upload that PNG to Roblox **once** (Studio's asset manager, or the Open
   Cloud API) to get a numeric asset id.
3. Put that id in `icons.json` and push.
4. Your script calls `IconLoader.Get("home")`, which fetches `icons.json`
   from GitHub at runtime and returns the id — no redeploy of the UI script
   needed to swap an icon later, just edit `icons.json`.

This is the part that's actually dynamic/GitHub-driven; the pixels
themselves always end up going through Roblox's own asset CDN because that's
the only thing the engine will render.

## Usage

```lua
local RAW = "https://raw.githubusercontent.com/<you>/reptillion-ui-assets/main/"
local IconLoader = loadstring(game:HttpGet(RAW .. "examples/IconLoader.lua"))()

local Library = loadstring(game:HttpGet("<url to Ui.lua>"))()
local Window = Library:Window({
    Name = "Reptillion",
    Logo = IconLoader.Get("logo", "135215559087473"),
    Size = UDim2.fromOffset(650, 450),
})

local Home = Window:Page({ Name = "Home", Icon = IconLoader.Get("home") })
```

See `examples/Example.lua` for a fuller example.
