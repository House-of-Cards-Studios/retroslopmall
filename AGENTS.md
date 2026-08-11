# AGENTS

## Agent rules (read first)

- **Never run `Remove-Item` or destructive shell commands** unless the user explicitly asks
- **Don't apply fixes in Play mode then stop to re-apply** — Play mode changes are not persistent. Only edit in Play mode if the user asks for a "live update", and don't exit Play mode after
- **Edit in Edit mode → user tests in Play mode** — this is the correct workflow, use the Roblox Studio MCP server to exit play mode if the user is currently inside of it unless they asked for a "live update"
- **`rojo build` to validate**, don't delete the build artifact (it's gitignored)
- **Pre-modeled buttons in the template are at correct positions** — don't try to reposition them with code, just rename them
- **Don't read `retroslopmall.rbxlx` directly unless it's necessary to** — it's a massive XML file. Use MCP tools or `lune` if the MCP server is unavailable (instruct the user to re-open the place file if Lune is used)
- **Ignore non-Luau-specific problems/linting** - The user may have extensions installed for different kinds of Lua language syntax, such as GLua (Garry's Mod), only notice problems if those problems are specific to the Luau language (Roblox)

## Project overview

Retroslop Mall is a **Roblox tycoon game** - a retro-styled recreation of the original *Roblox Mall* (2010) by Nightcaller, with modern features added. Each tycoon is a different store in a mall. Players claim an unowned store, buy upgrades, and eventually open their store for other players to visit and purchase items.

- **Platform:** Roblox (Luau scripting)
- **Toolchain:** [Rokit](https://github.com/rojo-rbx/rokit) - manages `lune`
- **Scripting utilities:** [Lune](https://lune-org.github.io) (Luau runtime for tooling - not for in-game code)
- **Place file:** `retroslopmall.rbxlx` (XML-format Roblox place; the actual game lives here)
- **License:** MIT
- **Status:** 🚧 **Unfinished** — The project goal is to complete the game using AI agents (DeepSeek, Copilot). Barebones code and world builds are in place; gameplay systems need implementation. See [`TODO.md`](TODO.md) for progress tracking.

## Project goal

The game is being built by AI agents from the existing foundation:
- **World:** Mall building, stores, VIP room, laser tag arena are all physically built
- **Scaffolding:** Player data structures, tycoon metadata, HUD framework, and store templates are in place
- **What's missing:** The actual gameplay loop — item givers, rebirths, VIP room mechanics, laser tag scoring, badges, and reward systems

When implementing features, follow the game design in [`README.md`](README.md) and track completion in [`TODO.md`](TODO.md).

## Technology stack

| Tool | Purpose |
|------|---------|
| **Luau** | All game scripting (Scripts, LocalScripts, ModuleScripts inside the place file) |
| **Lune** | Dev-tool scripting outside Roblox (`index.luau` uses `@lune/roblox` to deserialize the place) |
| **Rokit** | Toolchain version manager (locks Lune to v0.10.5, Rojo to v7.7.0) |
| **Rojo** | Syncs scripts between `src/` filesystem and Roblox place file |
| **Roblox Studio** | Visual editor; MCP server available for programmatic inspection |

## How to work with this project

### The place file is the source of truth

All game code, assets, and configuration live inside `retroslopmall.rbxlx`. This is a **gigantic** XML file - avoid reading it directly. Instead:

- **Use Roblox Studio** to view/edit the game tree visually
- **Use the Roblox Studio MCP server** (`mcp_robloxstudio_*` tools) to inspect instances, read scripts, and search the game tree programmatically
- **Use `lune run index.luau`** to deserialize the place and run tooling scripts against it

### Roblox Studio MCP

When Studio is open with the MCP server enabled, you can:
- `get_studio_state` - check if Edit/Play mode, available DataModels
- `search_game_tree` - find instances by name/class
- `inspect_instance` - read properties of any instance
- `script_read` / `script_search` / `script_grep` - read and search Luau source
- `execute_luau` - run arbitrary Luau in Edit/Client/Server context

### Lune scripts

`index.luau` is the Lune entry point. Today it runs the pure-Luau test suite: discovers every `tests/*.spec.luau` file, runs each returned `{ [name] = testFn }` table, and exits non-zero on failure so CI can gate on it. Run with:
```bash
lune run index.luau
```

Extend it (or add sibling scripts under `tools/`) for future build tasks, asset validation, data migration, or `@lune/roblox`-based place deserialization.

Add a test by dropping a spec file under `tests/`:
```lua
-- tests/Example.spec.luau
local Mod = require("../src/ServerScriptService/YourModule")
return {
    ["does the thing"] = function()
        assert(Mod.thing() == 42, "expected 42")
    end,
}
```

**Throwaway Lune scripts:** When writing one-off `.luau` scripts (e.g., to patch the place file), place them in the `temp/` directory. This directory is gitignored, so cleanup (`Remove-Item`) is unnecessary — the scripts are automatically excluded from version control.

### Rojo (script syncing)

Scripts are authored in `src/` and synced into the place file. The directory structure mirrors Roblox services:

```
src/
├── ServerScriptService/    # .server.lua → Script
│   ├── ServerTime.server.lua
│   └── TycoonSetup.server.lua
├── ReplicatedStorage/      # .lua → ModuleScript
│   └── Sounds.lua
├── StarterGui/             # .client.lua → LocalScript
│   ├── ScreenGui/
│   ├── MallMainUI/
│   └── ShopGUI/
├── StarterPlayer/
│   └── StarterPlayerScripts/
├── ServerStorage/
└── Workspace/
    ├── BackdoorGiver/
    └── RobloxMall/
        └── LaserTagArena/
```

**File naming conventions:**
- `.server.lua` → `Script` (runs on server)
- `.client.lua` → `LocalScript` (runs on client)
- `.lua` / `.luau` → `ModuleScript` (shared, require-able)

**Commands:**
```bash
rojo build --output build.rbxlx   # Build standalone place from src/
rojo serve                         # Start live-sync server for Studio plugin
```

**Workflow for editing scripts:**
1. Edit `.lua` files in `src/` with your editor
2. Use the Rojo Studio plugin to sync changes into `retroslopmall.rbxlx`
3. Or use MCP `execute_luau` / `multi_edit` for direct in-Studio edits

> **⚠️ Safety:** `default.project.json` only syncs `ServerScriptService` and `StarterPlayer/StarterPlayerScripts`. These services contain **only scripts** — syncing them won't destroy models, UI, or assets. The following are **excluded from Rojo** to protect the world:
>
> | Service | Why excluded |
> |---------|-------------|
> | `Workspace` | Contains the mall building, stores, VIP room, laser tag arena, BackdoorGiver part |
> | `StarterGui` | Contains UI layouts (ScreenGui, MallMainUI, ShopGUI) — syncing wipes the UI elements |
> | `ReplicatedStorage` | Contains TopbarPlus library, RemoteEvents, TycoonMetadata, Roof model |
> | `ServerStorage` | Contains Objects, TycoonAssets, OldSign — Configuration instances, not scripts |
>
> Scripts in excluded services are kept in `src/` as reference copies. Edit them via **Studio MCP** (`multi_edit`, `execute_luau`) instead.

> **Note:** Non-script assets (models, parts, UI layouts, sounds) still live in `retroslopmall.rbxlx`. Rojo only manages scripts. The place file remains the source of truth for everything else.

> **TopbarPlus** (third-party icon library in `ReplicatedStorage`) is not extracted to `src/` — it stays in the place file. Extract it later if needed.

## Game architecture

### Mall layout (`Workspace.RobloxMall`)

The mall is a large Model with these top-level areas:

| Area | Description |
|------|-------------|
| **MallBuilding** | Main indoor mall structure with storefronts |
| **FrontEntrance** | Mall entrance where players spawn |
| **Outdoors** | ParkingLot and exterior areas |
| **VIPRoom** | VIP lounge with 2x 1K Money Givers, Bar (Counter + Stools), LoungeArea (Sofas + TV), VIPDoor |
| **LaserTagArena** | Red vs Blue laser tag arena |
| **MockStores** | Example/display store models |
| **Restrooms** | Bathroom area |
| **StaffRooms** | Staff-only back areas |
| **PlanterBoxes** | Decorative planters |

### Store (tycoon) system (`Workspace.Tycoons`)

There are **9 stores**, each an independent tycoon:

| # | Store Name |
|---|------------|
| 1 | Blank (unused) |
| 2 | Burger Mart |
| 3 | Game Shop |
| 4 | Good Sports |
| 5 | Gun Shop |
| 6 | TacoTime |
| 7 | The Body Shop |
| 8 | The Music Shop |
| 9 | Toy Shop |

**Tycoon structure:**
- `TycoonFloors/` - Floor parts (one per store) where tycoons are placed
- `TycoonFactories/` - Store-specific models containing upgrade items, droppers, conveyors, and the item giver
- `TycoonTemplate/` - Base template cloned when resetting a tycoon (Floor + Configuration + Store folder)
- `PlayerTycoons/` - Backpack containing active player-owned tycoon instances

**Tycoon mechanics (from `TycoonSetup` script):**
- Each store has a `Facade` (storefront appearance) and `FactoryOffset` defined in `ReplicatedStorage.TycoonMetadata`
- **21 upgrade buttons** per store, laid out in a 3-column snake pattern
- Button pricing: Model i costs `5 * (i - 1)` dollars (free → $100)
- "Become [Store] Owner" door lets players claim an unowned store
- Store title shows owner name or "No one's store"
- `resetTycoon()` handles store reset on claim and rebirth

**Player data (per player):**
- `leaderstats` → Cash (IntValue), Rebirths (IntValue)
- `SaveData` → MusicVolume, SFXVolume, ClassicMode (BoolValue)
- `TycoonData` → TycoonName, TycoonProgression, per-store Rebirths

### Server scripts (`ServerScriptService`)

| Script | Purpose |
|--------|---------|
| `ServerTime` | Updates workspace DistributedGameTime display (Days/Hours/Minutes/Seconds) via RunService.Heartbeat |
| `TycoonSetup` | Main initialization: player stats, tycoon metadata, store reset/claim logic, income/speed upgrade system, purchase button handlers, collect button, run toggle |

### Client UI (`StarterGui`)

| GUI | Contents |
|-----|----------|
| `ScreenGui` | Top-level UI container with LocalScript |
| `MallMainUI` | HUD script (`MallMainUIScript`) - handles money display, run button, map toggle, etc. |
| `ShopGUI` | Item giver shop with Show/Hide toggle + 11 item purchase scripts (Item1–Item11) |

### Client scripts (`StarterPlayer`)

| Path | Purpose |
|------|---------|
| `StarterPlayerScripts.LocalScript` | Main client-side initialization |
| `StarterCharacterScripts` | Character-specific behavior |

### Shared assets (`ReplicatedStorage`)

| Asset | Type | Purpose |
|-------|------|---------|
| `TopbarPlus` | Folder | Topbar icon UI library (themes, gamepad, dropdown, menu, selection, notice, indicator, caption, widget) |
| `Sounds` | ModuleScript | Sound effect management |
| `PlaySound` / `StopSound` | RemoteEvent | Client→server sound triggers |
| `IncomeEvent` / `RunEvent` | RemoteEvent | Created at runtime by TycoonSetup — income/purchase notifications and run toggle |
| `Roof` | Model | Roof model for map toggle visibility |
| `TycoonMetadata` | Configuration | Per-store Facade and FactoryOffset settings |

### Server storage (`ServerStorage`)

| Asset | Type | Purpose |
|-------|------|---------|
| `Objects` | Configuration | Server-time display objects (Days/Hours/Minutes/Seconds values) |
| `TycoonAssets` | Configuration | Stored tycoon factories and template (moved here at runtime) |
| `OldSign` | Model | Legacy reference sign (kept for posterity) |

### Easter eggs

- **BackdoorGiver** (Part in Workspace): The old "backdoor giver" hidden button now slips you like a banana peel instead. The original script was previously stored in ServerStorage for reference and has been removed.
- **Segway regen commands:** `/regen1`, `/regen2`, `/regen3`, `/regen4` hinted via a Workspace model
  - The segway is not actually implemented, it will be added in a post-launch update.

### Other workspace items

- **RoofContainer** - Folder for roof parts (used with the map toggle system)
- **Player count models** - "In this Server is 0 People online" and "In this Server were 0 people" - dynamic display models

### Core systems (from README design)

- ✅ **Store claiming:** Players touch the "Become [Store] Owner" door to claim an unowned store. One store per player.
- ✅ **Income system:** Upgradeable income (+$0→+$50 per tick, free→$2,450) and speed (6s→1s per tick, $5→$25). Collect button to claim accumulated cash.
- ✅ **Purchase buttons:** 21 model buttons per store, sequential purchasing ($0→$100). Factory models revealed at button position on purchase. Model21 shows "OPEN" on store.
- ✅ **HUD:** Money display, progression percentage, rebirth count, run button (WalkSpeed 16↔32, server-side). Gold notification toasts for purchases/upgrades.
- ✅ **Run button:** Server-side WalkSpeed toggle (16↔32) via RunEvent RemoteEvent — safe from anti-cheat.
- [ ] **Item giver:** A touch-triggered UI (ShopGUI) that lets visiting players buy items from a completed store.
- [ ] **VIP room:** Purchase VIP, enter the room, press buttons to earn money.
- [ ] **Laser tag arena:** Red vs Blue teams. Tagging earns money; getting tagged respawns you at mall entrance.
- [ ] **Rebirth system:** Per-store rebirths (not global). Costs money, resets the store, increases earn rate, unlocks more gear.
- [ ] **Badges:** Basic + golden badges per store; Mall-wide badges for completing/rebirthing all stores.
- [ ] **Rewards & quests:** Periodic rewards, daily quests (visit a store, buy from a completed store).
- [ ] **Map:** Translucent ceilings, top-down orthographic view toggle showing players and store logos.

## Code conventions

- **Language:** Luau (strict typing preferred where practical)
- **Script organization:** Uses Roblox idiomatic patterns (Scripts for server, LocalScripts for client, ModuleScripts for shared logic)
- **Naming:** PascalCase for modules/services, camelCase for variables/functions
- **Comments:** Explain *why*, not *what* - the Luau is self-documenting for what

## AI assistance disclaimer

Portions of this codebase and gameplay design were assisted with GitHub Copilot, ChatGPT, and DeepSeek. When contributing as an AI, read the README first for gameplay design intent and keep changes aligned with the retro aesthetic + modern features vision.

## Relevant documentation

- [Luau documentation](https://luau-lang.org/)
- [Lune documentation](https://lune-org.github.io) (local copy in sibling `lune-org.github.io/` workspace for agents to utilize)
- [Roblox Engine API](https://create.roblox.com/docs/reference/engine)
