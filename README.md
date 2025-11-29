# Documentation

## Main Node
### Game
- Registers `$Audio` and `$Camera` into the `systems` autoload, resets `game_data.map_depth`, seeds `budget` from `starting_budget`, and spawns the persistent `GlobalPlayer` plus HUD (`UIBars`), wiring `HealthBar` updates.
- Drives screen changes with pixelate transition animations, keeps a `previous_screen` pointer, and loads either mapped screens or item encounters (`AisleNavigation`) when aisle ids demand it.
- Handles `pause_menu`/`inventory` input while in `Aisles`: spawns `PauseMenu` (resume/options/main menu/exit) or opens `Inventory`; toggles player/HUD visibility outside gameplay screens.

### AutoLoads
- **game_data:** Persistent store for map depth, budget, player stats (health/charisma/dexterity/defense/markup), cart selection (`cart_type`, `max_capacity`), and `inventory` items.
- **systems:** Lightweight global container for shared scene systems (audio, camera, etc.).

## Screens
- **Main Menu:** Populates buttons from exported `button_map`, styled with receipt font/price tag; plays `theme` music; exit path shows confirmation.
- **Entrance (Cart Select):** Slider UI to preview cart builds; sets `game_data` cart id/stats/capacity; instantiates `ItemLibrary` and seeds starter inventory based on capacity; includes back to main menu.
- **Aisles:** On `_ready` increments `map_depth`, plays `fun` music, builds weighted aisle pool, instantiates `Aisle` signs at `AisleMarker`s with textures/outlines, and connects clicks to emit `change_screen` with the aisle id.
- **Aisle Navigation (Haggle Encounter):** Top-down movement using the persistent player; proximity to the NPC triggers `DialogueOverlay` showing the offer plus Budget; choices allow Buy (budget check and deduction), Haggle via `HaggleMinigame` (adjusts price/patience, can force buy/leave), or Leave; returns to aisles when finished.
- **Inventory:** Grid-based UI sized to the viewport; pulls unique items from `game_data.inventory`, shows icons/tooltips and badge counts; `Back to Game` returns to the previous screen; opened via the `inventory` input from aisles.
- **Pause Menu:** Receipt-themed overlay from the `pause_menu` input; actions for resume, inventory/main menu, and exit with confirmation; Options submenu toggles fullscreen and adjusts master volume.
- **How To Play:** Overlay of quick tips with a back button to the main menu.
- **Exit:** Screen that exits the game

## UI Components
- **UIBars:** Persistent HUD showing the Budget label each frame; hooks `HealthBar` updates via the `Player.health_updated` signal.
- **DialogueOverlay:** `CanvasLayer` for RPG-style text interactions with branching choices used by encounters.
- **HaggleMinigame:** Timing-based success-zone minigame replacing RNG checks; success discounts, failure raises price and reduces patience.
- **HealthBar:** ProgressBar wrapper that updates max/value from emitted health changes.

## Systems and Data
- **Audio (`scripts/audio.gd`):** Central music manager with tracks `theme`/`fun`; fades the current track out before playing the new one; referenced via `systems.audio`.
- **Items & Inventory:** `ItemConfig` resources hold item stats/price/icon/type; `ItemLibrary` seeds starter loot up to `MAX_ITEMS`, respecting cart `max_capacity`; `CartConfig` defines cart stats/defense/charisma/dexterity.
- **Player & Camera:** Persistent `Player` handles movement/animations and emits health updates; `camera_2d.gd` provides noise-based shake and is exposed through `systems.camera`.

## Shaders
All shader sources live under `GodotFiles/assets/shaders`. To use one, add a `ShaderMaterial` to any CanvasItem (Sprite2D, ColorRect, etc.), assign the shader, and then set/animate uniforms via the Inspector, `AnimationPlayer`, or code. Ready-made references: `scripts/aisle.gd` builds an outline material on hover, and `scenes/FX/fog.tscn` ships with a noise texture wired to the fog shader.

Some shaders require you add a noise texture. Just click on the field and select a noise resource, then tweak its properties until it looks right (e.g., `disintegrate` needs this).

Example to do it in code instead of the editor (outline on a sprite):

```gdscript
var mat := ShaderMaterial.new()
mat.shader = load("res://assets/shaders/outline.gdshader")
mat.set_shader_parameter("outline_thickness", 3.0)
$Sprite2D.material = mat
```

- `outline.gdshader`: Adds a border where alpha transitions; tune `outline_color` and `outline_thickness` (0-5).
- `collapse.gdshader`: Makes a texture (sprite) collapse in on itself; animate `collapse_depth` (0-30) if you want the sprite to appear from nothing (see `scenes/screens/aisles.tscn`).
- `blur.gdshader`: Box blur; increase `blur_amount` (0-5) to widen the radius.
- `pixelate.gdshader`: Pixelates by snapping UVs; `block_size` (1-20) sets pixel block size.
- `pulsate_red.gdshader`: Pulsing red tint; `speed` controls the flash rate. Used in `scenes/FX/lighting/basic_light.tscn`.
- `rainbow.gdshader`: Sliding rainbow overlay; adjust `speed` and `intensity` to change motion/strength.
- `silhouette.gdshader`: Blends toward black or white; positive `darkened_rate` darkens, negative values lighten.
- `flip.gdshader`: Card-flip between two textures; assign `front_tex`/`back_tex` and drive `flip` from 0 (front) to 1 (back), with 0.5 edge-on invisible.
- `disintegrate.gdshader`: Dissolves sprites using a supplied `NOISE_TEX`; animate `disintegration_depth` (0-1) and offset the pattern with `set_random` if desired.
- `dirty.gdshader`: Multiplies the sprite with `noise_tex` where alpha exists for a grime overlay.
- `fog.gdshader`: Alpha-only scrolling fog from a noise texture; plug in `noise_texture` (repeat enabled) and adjust `speed`. `scenes/FX/fog.tscn` is a drop-in version with FastNoise configured.
- `weird.gdshader`: Horizontal wobble driven by alpha and time; `speed` sets the wave frequency.

## Recent Changes
- Added cart selection with starter inventory seeding plus a viewport-scaling Inventory screen.
- Introduced pause menu with options/resume/exit confirmations and hotkey access from aisles.
- Hooked a global audio manager with themed tracks and fades between songs.
- Global player/HUD now persist across screens with visibility toggling and health/budget wiring.
- Aisle encounters reuse player movement and include the haggle minigame with patience/force-buy flows.
