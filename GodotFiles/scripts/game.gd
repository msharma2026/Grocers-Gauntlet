class_name Game
extends Node2D

const PLAYER_SCENE: PackedScene = preload("res://scenes/player.tscn")
const UI_BARS_SCENE: PackedScene = preload("res://scenes/user interface/ui_bars.tscn")
const AISLE_NAVIGATION_SCENE: PackedScene = preload("res://scenes/aisle_navigation.tscn")

@export var screens: Dictionary[String, PackedScene]
@export var pause_menu_scene: PackedScene
@export var starting_budget: float = 100.0

var current_screen: Screen
var pause_menu_instance: PauseMenu = null
var current_screen_ref
var previous_screen_ref

@onready var player: Player
@onready var ui_bar: UIBars
@onready var health_bar: ProgressBar

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	game_data.map_depth = 0
	game_data.budget = starting_budget
	
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
	
func _process(delta: float) -> void:
	if current_screen is Aisles:
		_toggle_gameplay_object_visibility(true)
	else:
		_toggle_gameplay_object_visibility(false)
	
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_menu") and \
			current_screen is not MainMenu and \
			current_screen is not Entrance and \
			current_screen is not Inventory:
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
	var requested_previous := false
	if screen_ref is String and screen_ref == "previous_screen":
		requested_previous = true
		screen_ref = previous_screen_ref
	
	var next_ref = screen_ref
	var active_ref = current_screen_ref
	previous_screen_ref = active_ref
	current_screen_ref = next_ref

	if screen_ref is String:
		var screen_id: String = screen_ref
		
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
	return id in ["H_item", "A_item", "Def_item", "Dex_item", "C_Item", "Black_Market"]

func _load_encounter(item_id: String) -> void:
	var encounter_screen = AISLE_NAVIGATION_SCENE.instantiate()
	
	if encounter_screen.has_method("setup_encounter"):
		encounter_screen.setup_encounter(item_id)
		
	if current_screen != null:
		remove_child(current_screen)
		current_screen.queue_free()
	
	add_child(encounter_screen)
	current_screen = encounter_screen
	current_screen.change_screen.connect(_change_screen)
	
	_update_player_visibility(true)

func _load_screen(screen_scene: PackedScene) -> void:
	if screen_scene == null:
		return
	
	if current_screen != null:
		remove_child(current_screen)
		current_screen.queue_free()
	
	var new_screen : Screen = screen_scene.instantiate()
	add_child(new_screen)
	current_screen = new_screen
	current_screen.change_screen.connect(_change_screen)

func _update_player_visibility(visible: bool) -> void:
	var global_player = get_node_or_null("GlobalPlayer")
	if global_player:
		global_player.visible = visible
		global_player.process_mode = Node.PROCESS_MODE_INHERIT if visible else Node.PROCESS_MODE_DISABLED
	
func _toggle_gameplay_object_visibility(visibility: bool) -> void:
	health_bar.visible = visibility
	player.visible = visibility
	ui_bar.visible = visibility
	
		
