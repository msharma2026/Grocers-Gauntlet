class_name Game
extends Node2D

const PLAYER_SCENE: PackedScene = preload("res://scenes/player.tscn")
const UI_BARS_SCENE: PackedScene = preload("res://scenes/user interface/ui_bars.tscn")
const AISLE_NAVIGATION_SCENE: PackedScene = preload("res://scenes/aisle_navigation.tscn")
# [New] Preload the boss scene
const BOSS_SCENE: PackedScene = preload("res://scenes/boss_fight.tscn")

@export var screens: Dictionary[String, PackedScene]
@export var pause_menu_scene: PackedScene
@export var starting_budget: float = 100.0

var current_screen: Screen
var pause_menu_instance: PauseMenu = null
var current_screen_ref
var previous_screen_ref
var inventory_overlay: Screen = null
var inventory_layer: CanvasLayer = null
var _gameplay_was_visible: bool = true
var _disabled_layers: Array[CanvasLayer] = []
var default_camera_values : Dictionary = {
	'pos': Vector2(0,0),
	'zoom': Vector2(0,0),
	'set':false
}


@onready var player: Player
@onready var ui_bar: UIBars
@onready var health_bar: ProgressBar

func _ready() -> void:
	# [New] Manually register the boss scene so "boss_fight" is a valid key
	if not screens.has("boss_fight"):
		screens["boss_fight"] = BOSS_SCENE

	systems.audio = $Audio
	systems.camera = $Camera
	
	default_camera_values['pos'] = $Camera.position
	default_camera_values['zoom'] = $Camera.zoom
	default_camera_values['set'] = true
	
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	game_data.reset()
	
	player = PLAYER_SCENE.instantiate()
	player.name = "GlobalPlayer"
	add_child(player)
	
	ui_bar = UI_BARS_SCENE.instantiate()
	add_child(ui_bar)
	
	if ui_bar.has_node("HealthBar"):
		health_bar = ui_bar.get_node("HealthBar")
		player.health_updated.connect(health_bar.update_health_bar)
		health_bar.update_health_bar(game_data.health_percentage, 100)
	
	_change_screen("main_menu")
	
func _process(_delta: float) -> void:
	# [Updated] Add boss_fight to visibility check so UI/Player show up during boss
	var show_gameplay_objects := current_screen is Aisles or current_screen is AisleNavigation or current_screen is BossFight
	_toggle_gameplay_object_visibility(show_gameplay_objects)
	
	
func _unhandled_input(event: InputEvent) -> void:
	# Block pause/inventory toggles if an inventory overlay is already open (except to close it)
	if inventory_overlay != null and event.is_action_pressed("pause_menu"):
		return
	# Block inventory if pause menu is up
	if pause_menu_instance != null and event.is_action_pressed("inventory"):
		return
	if event.is_action_pressed("pause_menu") and \
			(current_screen is Aisles or \
			current_screen is AisleNavigation):
		if pause_menu_instance != null:
			_resume_game()
		else:
			get_tree().paused = true
			pause_menu_instance = pause_menu_scene.instantiate()
			pause_menu_instance.resume_game.connect(_resume_game)
			pause_menu_instance.quit_to_main_menu.connect(_quit_to_main_menu)
			pause_menu_instance.quit_game.connect(_quit_game)
			pause_menu_instance.change_screen.connect(_change_screen_from_pause)
			add_child(pause_menu_instance)
	elif event.is_action_pressed("inventory") and \
			(current_screen is Aisles or \
			 current_screen is AisleNavigation):
		if inventory_overlay != null:
			_close_inventory_overlay()
		else:
			_open_inventory_overlay()
	elif event.is_action_pressed("inventory") and inventory_overlay != null:
		_close_inventory_overlay()
			

func _resume_game() -> void:
	if pause_menu_instance != null:
		get_tree().paused = false
		pause_menu_instance.queue_free()
		pause_menu_instance = null

func _quit_to_main_menu() -> void:
	get_tree().paused = false
	if pause_menu_instance != null:
		pause_menu_instance.queue_free()
		pause_menu_instance = null
	_change_screen("main_menu")

func _quit_game() -> void:
	get_tree().paused = false
	if pause_menu_instance != null:
		pause_menu_instance.queue_free()
		pause_menu_instance = null
	_change_screen("exit")

func _change_screen_from_pause(screen_ref) -> void:
	_resume_game()
	_change_screen(screen_ref)

func _change_screen(screen_ref) -> void:
	# If inventory overlay is open and we request previous, just close it
	if screen_ref is String and screen_ref == "previous_screen" and inventory_overlay != null:
		_close_inventory_overlay()
		return
	
	reset_camera()
	#var requested_previous := false
	if screen_ref is String and screen_ref == "previous_screen":
	#	requested_previous = true
		screen_ref = previous_screen_ref
	
	var next_ref = screen_ref
	var active_ref = current_screen_ref
	previous_screen_ref = active_ref
	current_screen_ref = next_ref

	if screen_ref is String:
		var screen_id: String = screen_ref
		
		# Opening inventory: overlay it instead of swapping screens
		if screen_id == "inventory" and (current_screen is Aisles or current_screen is AisleNavigation):
			_open_inventory_overlay()
			return
		
		if screen_id == "pause_menu":
			get_tree().paused = true
			if pause_menu_instance == null:
				pause_menu_instance = pause_menu_scene.instantiate()
				pause_menu_instance.resume_game.connect(_resume_game)
				pause_menu_instance.quit_to_main_menu.connect(_quit_to_main_menu)
				pause_menu_instance.quit_game.connect(_quit_game)
				pause_menu_instance.change_screen.connect(_change_screen_from_pause)
				add_child(pause_menu_instance)
			return
		
		if _is_item_encounter(screen_id):
			_load_encounter(screen_id)
			return
		
		if !screens.has(screen_id):
			push_warning("Unknown screen_id: %s" % screen_id)
			return
		
		_load_screen(screens[screen_id])
		
		# FIX: Check specifically for "aisles" to make player visible
		if screen_id == "aisles":
			_reset_player_position()
			_update_player_visibility(true)
		elif screen_id == "boss_fight":
			# [New] Handle player visibility for boss fight specifically if needed
			_update_player_visibility(true)
		else:
			# Hide player on main_menu, entrance, etc.
			_update_player_visibility(false)
		return
	
	if screen_ref is PackedScene:
		_load_screen(screen_ref)
		_update_player_visibility(false)
		return

func _is_item_encounter(id: String) -> bool:
	return id in ["bread", "meat", "milk", "candy", "alcohol", "Black_Market"]

func _load_encounter(item_id: String) -> void:
	reset_camera()
	var scene_path = "res://scenes/aisle_navigation.tscn"
	
	# Map item IDs to specific scenes if they exist
	match item_id:
		"bread": scene_path = "res://scenes/aisles/bread_aisle.tscn"
		"meat": scene_path = "res://scenes/aisles/meat_aisle.tscn"
		"milk": scene_path = "res://scenes/aisles/milk_aisle.tscn"
		"candy": scene_path = "res://scenes/aisles/candy_aisle.tscn"
		"alcohol": scene_path = "res://scenes/aisles/alcohol_aisle.tscn"
		"Black_Market": scene_path = "res://scenes/aisles/black_market.tscn"
		
	var encounter_scene = load(scene_path)
	var encounter_screen = encounter_scene.instantiate()
	
	if encounter_screen.has_method("setup_encounter"):
		encounter_screen.setup_encounter(item_id)
		
	
	_clear_current_screen()
	
	reset_camera()
	add_child(encounter_screen)
	current_screen = encounter_screen
	current_screen.change_screen.connect(_change_screen)
	systems.audio.play_music(item_id)
	
	_update_player_visibility(true)

func _load_screen(screen_scene: PackedScene) -> void:
	if screen_scene == null:
		return
	if screen_scene.resource_path.ends_with("boss_fight.tscn"):
		await _burn_transition_start()
	else:
		await _play_transition()
	var new_screen : Screen = _swap_screen(screen_scene)
	if screen_scene.resource_path.ends_with("boss_fight.tscn"):
		await _burn_detransition()
	else:
		await _play_detransition()
	new_screen._start_on_transition_end()
	
	

func _update_player_visibility(_visible: bool) -> void:
	var global_player = get_node_or_null("GlobalPlayer")
	if global_player:
		global_player.visible = _visible
		global_player.process_mode = Node.PROCESS_MODE_INHERIT if _visible else Node.PROCESS_MODE_DISABLED
	
func _toggle_gameplay_object_visibility(visibility: bool) -> void:
	health_bar.visible = visibility
	player.visible = visibility
	ui_bar.visible = visibility
	
func _play_transition() -> void:
	var ap := $TransitionPlayer
	ap.play("transition_animation")
	await ap.animation_finished
	
func _play_detransition() -> void:
	var ap := $TransitionPlayer
	ap.play("detransition_animation")
	await ap.animation_finished

func _reset_player_position() -> void:
	if player:
		player.global_position = player.start_position
		player.velocity = Vector2.ZERO

func reset_camera() -> void:
	if(default_camera_values['set']):
			$Camera.position = default_camera_values['pos'] 
			$Camera.zoom = default_camera_values['zoom']
			$Camera.anchor_pos = default_camera_values['pos'] 

func _clear_current_screen():
	if current_screen:
		remove_child(current_screen)
		current_screen.queue_free()
		current_screen = null

func _swap_screen(scene: PackedScene):
	_clear_current_screen()
	reset_camera()
	var s: Screen = scene.instantiate()
	add_child(s)
	current_screen = s
	current_screen.change_screen.connect(_change_screen)
	return s

func _open_inventory_overlay() -> void:
	if inventory_overlay != null:
		return
	if not screens.has("inventory"):
		return
	var inv_scene: PackedScene = screens["inventory"]
	# Create a dedicated top-level canvas layer and put the inventory inside it
	inventory_layer = CanvasLayer.new()
	inventory_layer.layer = 5000
	add_child(inventory_layer)
	inventory_overlay = inv_scene.instantiate()
	inventory_layer.add_child(inventory_overlay)
	inventory_overlay.change_screen.connect(_change_screen)
	get_tree().paused = true
	# Hide current screen visuals while inventory is open
	if current_screen:
		current_screen.visible = false
	# Hide gameplay UI while overlay is open
	_gameplay_was_visible = ui_bar.visible if ui_bar else true
	_toggle_gameplay_object_visibility(false)
	# Disable other CanvasLayers (fog, dialogue, ui) so overlay sits on top
	_disabled_layers.clear()
	# Explicitly hide known overlay layers
	var fog := get_node_or_null("PixelateLayer") as CanvasLayer
	var burn := get_node_or_null("BurnLayer") as CanvasLayer
	if fog and fog.visible:
		_disabled_layers.append(fog)
		fog.visible = false
	if burn and burn.visible:
		_disabled_layers.append(burn)
		burn.visible = false
	# Hide any dialogue overlay instances attached to the root
	for child in get_children():
		if child is DialogueOverlay or child is CanvasLayer:
			var layer := child as CanvasLayer
			if layer and layer != inventory_layer and layer.visible:
				_disabled_layers.append(layer)
				layer.visible = false
	# Hide any CanvasLayers under the current screen (dialogue overlays in aisles, etc.)
	if current_screen:
		for child in current_screen.get_children():
			if child is CanvasLayer:
				var layer := child as CanvasLayer
				if layer.visible:
					_disabled_layers.append(layer)
					layer.visible = false

func _close_inventory_overlay() -> void:
	if inventory_overlay != null:
		if inventory_overlay.change_screen.is_connected(_change_screen):
			inventory_overlay.change_screen.disconnect(_change_screen)
		inventory_overlay.queue_free()
		inventory_overlay = null
	if inventory_layer != null:
		inventory_layer.queue_free()
		inventory_layer = null
	# Restore current screen visibility
	if current_screen:
		current_screen.visible = true
	# Restore gameplay UI visibility
	_toggle_gameplay_object_visibility(_gameplay_was_visible)
	# Re-enable previously disabled layers
	for layer in _disabled_layers:
		if is_instance_valid(layer):
			layer.visible = true
	_disabled_layers.clear()
	get_tree().paused = false

func _burn_transition_start() -> void:
	await get_tree().create_timer(1.0).timeout
	await get_tree().process_frame
	$BurnLayer/FakeScreen.texture = ImageTexture.create_from_image(get_viewport().get_texture().get_image())
	

func _burn_detransition() -> void:
	$TransitionPlayer.play("burn_transition")
	await $TransitionPlayer.animation_finished
	$BurnLayer/FakeScreen.texture = null
