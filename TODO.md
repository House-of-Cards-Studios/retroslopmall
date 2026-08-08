# Retroslop Mall — TODO

> **Status:** 🚧 Unfinished — using AI agents to complete the game from barebones code and existing world builds.

## ✅ Completed

### Server
- [x] **ServerTime** — DistributedGameTime clock display (Days/Hours/Minutes/Seconds) via `RunService.Heartbeat`
- [x] **TycoonSetup: Player data init** — Creates `leaderstats` (Cash, Rebirths), `SaveData` (MusicVolume, SFXVolume, ClassicMode), and `TycoonData` (TycoonName, TycoonProgression, per-store Rebirths) on `PlayerAdded`
- [x] **TycoonSetup: Metadata loading** — Reads `ReplicatedStorage.TycoonMetadata` for each store's Facade and FactoryOffset
- [x] **TycoonSetup: resetTycoon()** — Clones template, sets store facade, positions on floor, creates "Become [Store] Owner" door
- [x] **TycoonSetup: Upgrade buttons** — 21 model buttons generated per store in 3-column snake layout, priced `$0`–`$100` (`5 × (i-1)`)
- [x] **TycoonSetup: Store reset on init** — All 9 stores reset on server start

### Client
- [x] **MallMainUI (HUD)** — Slide-in/out panel with animated tween, money display (K/M/B/T formatting), tycoon name + progression status (`"X/21 (Y rebirths)"`), responsive stat change listeners
- [x] **Roof toggle** — `StarterPlayer.LocalScript` manages `RoofContainer` for map view system
- [x] **ScreenGui** — Plays background music on join

### Easter eggs
- [x] **BackdoorGiver (banana peel)** — `BananaScript` detects player touch, plays `SlipSound`, forces Jump + Sit to slip the player. Old reference script removed from ServerStorage.

### Laser tag arena
- [x] **Teleport pads** — Red/Blue team teleporters with weapon givers (`RedLazerGun`/`BlueLazerGun` from Lighting)
- [x] **Kill scripts** — Red/Blue spawn kill zones reset Humanoid health to 0
- [x] **Team color scripts** — Touching spawn parts applies team color

### Shared assets
- [x] **Sounds ModuleScript** — Structure and asset validation setup (incomplete: `playSound` doesn't actually play)
- [x] **PlaySound / StopSound RemoteEvents** — Wired in ReplicatedStorage
- [x] **TopbarPlus library** — Full icon UI library present (icons, themes, gamepad, dropdowns, menus, widgets)

---

## ❌ To Do

### 🔴 Critical — Core gameplay loop
- [ ] **Store claiming** — Wire "Become [Store] Owner" door touch to assign store to player (set `TycoonName`, `Owner` in config)
- [ ] **Money earning (droppers/conveyors)** — Implement dropper → conveyor → collector pipeline for cash generation
- [ ] **Upgrade purchasing** — Button click handlers: deduct cash, reveal next model/upgrade, update `TycoonProgression`
- [ ] **Store opening** — When upgrade 21 is purchased (item giver), show "OPEN" sign on storefront

### 🟠 High — Featured systems
- [ ] **Item giver (ShopGUI)** — Implement 11 item purchase scripts (currently empty stubs); touch-triggered UI for visiting players
- [ ] **Rebirth system** — Purchase rebirth for large cash amount → reset store → increase earn rate → unlock more gear
- [ ] **VIP room** — VIP purchase, door access, money-giver button mechanics (buttons exist, no scripts)
- [ ] **Laser tag scoring** — Money reward on tag, respawn at mall entrance on death
- [ ] **Player count display** — Dynamic update of "In this Server is X People online" and "In this Server were X people" models

### 🟡 Medium — UI & polish
- [ ] **Map toggle** — Wire `MallMapButton` to orthographic top-down view + store logo markers + player dots
- [ ] **Run button** — Wire `RunButton` to toggle sprint/speed boost
- [ ] **Rewards system** — Periodic reward redemption + daily quests (visit store, buy from completed store)
- [ ] **Badges** — Per-store basic badge (own store), per-store golden badge (rebirth store), Mall-wide basic (open all stores), Mall-wide golden (rebirth all stores)
- [ ] **Finish Sounds module** — Complete `playSound()` to actually play sounds with volume/speed modifiers

### 🟢 Low — Nice to have
- [ ] **TopbarPlus integration** — Wire icon library into HUD (map, settings, rewards buttons)
- [ ] **Segways** — Implement segway vehicles with `/regen1-4` commands (deferred per README)
- [ ] **ClassicMode toggle** — Use existing `ClassicMode` BoolValue for retro visual/audio mode
- [ ] **SaveData persistence** — Music/SFX volume preferences, ClassicMode setting
- [ ] **LaserTagArena modernization** — Update deprecated patterns (old `findFirstChild`, Lighting weapon storage references)

### 🔵 Tooling & infrastructure
- [ ] **Rojo integration** — Sync scripts from filesystem to `.rbxlx` for version-controlled code review
- [ ] **Expand `index.luau`** — Add build tasks, asset validation, script linting via Lune
- [ ] **`.luaurc`** — Add Luau type-checking config for LSP strict mode
- [ ] **Unit tests** — ModuleScript-based tests for core systems (tycoon logic, store claiming, rebirth math)

---

## Store status matrix

| # | Store | Facade | FactoryOffset | Claim logic | Upgrades | Item Giver |
|---|-------|--------|---------------|-------------|----------|------------|
| 1 | Blank | Facade1 | `0,190,0` | ❌ | ❌ | ❌ |
| 2 | Burger Mart | Facade2 | `0,30,0` | ❌ | ❌ | ❌ |
| 3 | Game Shop | Facade1 | `0,70,0` | ❌ | ❌ | ❌ |
| 4 | Good Sports | Facade1 | `0,110,0` | ❌ | ❌ | ❌ |
| 5 | TacoTime | Facade1 | `0,90,0` | ❌ | ❌ | ❌ |
| 6 | The Body Shop | Facade1 | `0,50,0` | ❌ | ❌ | ❌ |
| 7 | The Music Shop | Facade1 | `0,130,0` | ❌ | ❌ | ❌ |
| 8 | Toy Shop | Facade1 | `0,170,0` | ❌ | ❌ | ❌ |
| 9 | Gun Shop | Facade1 | `0,150,0` | ❌ | ❌ | ❌ |

> Note: Only Burger Mart uses Facade2. All others use Facade1. Facades control which storefront mesh/appearance is shown.
