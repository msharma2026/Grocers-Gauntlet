# Code Documentation

## Main Node
### Game
- **Script:** On transition, dequeue the current screen, instantiate and add to the tree the next screen.

## AutoLoads
### game_data
- **Description:** Persistent script accessible from anywhere.  
  Stores persistent game data such as inventory, current map position, stats, etc.

## Screen List
Each screen has its own script that inherits from `Screen`.  
**Note:** Each must at some point emit a `screen_change` signal.

- **Main Menu**
  - Populates buttons at runtime based on the exported `button_map` dictionary, then wires each button's `pressed` signal to emit `change_screen` with the matching screen id.
- **Entrance**
- **Aisles**
  - On `_ready` it increments `game_data.map_depth`, samples the weighted aisle table, then instantiates an `Aisle` scene at each `AisleMarker` so only a few randomized haggle/black-market destinations appear per floor; choosing a sign emits `change_screen` with that aisle's id.
  - Each spawned `Aisle` (see `scenes/Aisle.tscn`) is an `Area2D` that highlights on hover via an outline shader and emits `aisle_clicked` when left-clicked, which the parent forwards to `Game`.
- **Inventory**
- **Battle?**
- **Map**
- **Event**
  - (Maybe inherit from another `Event` class?)

## Shaders
All shader sources live under `GodotFiles/assets/shaders`. To use one, add a `ShaderMaterial` to any CanvasItem (Sprite2D, ColorRect, etc.), assign the shader, and then set/animate uniforms via the Inspector, `AnimationPlayer`, or code. Ready-made references: `scripts/aisle.gd` builds an outline material on hover, and `scenes/FX/fog.tscn` ships with a noise texture wired to the fog shader.

Some shaders require you add a noise texture. Just click on the field and select... I think it's called simplenoise2d or something like that, then go through the properties of the noise resource and tune it until it looks good. (disintegrate for example requires this)

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
- `disintegrate.gdshader`: Dissolves sprites using a supplied `NOISE_TEX`; animate `disintegration_depth` (0-1) and offset the pattern with `set_random` (not sure if I have the set_random variable working yet. I'll get back to you on that).
- `dirty.gdshader`: Multiplies the sprite with `noise_tex` where alpha exists for a grime overlay; Ignore the properties for now, they ended up not panning out, will go back and fix later.
- `fog.gdshader`: Alpha-only scrolling fog from a noise texture; plug in `noise_texture` (repeat enabled) and adjust `speed`. `scenes/FX/fog.tscn` is a drop-in version with FastNoise configured.
- `weird.gdshader`: Horizontal wobble driven by alpha and time; `speed` sets the wave frequency.

