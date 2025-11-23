# game.gd

class_name Game
extends Node2D

# Note 1: For the 'screens' dictionary, the Key (string) MUST exactly match the 
# destination screen_id in 'main_menu.gd' you plan to emit via a button signal.
# Note 2: The 'change_screen' signal must be manually updated in the 
# Inspector panel for 'main_menu.tscn' under button_map dictionary.

const PLAYER_SCENE: PackedScene = preload("res://scenes/Player.tscn")
const UI_BARS_SCENE: PackedScene = preload("res://scenes/user interface/UIBars.tscn")

@export var screens: Dictionary[String, PackedScene]
@export var pause_menu_scene: PackedScene

var current_screen: Screen
var pause_menu_instance: PauseMenu = null

@onready var health_bar: ProgressBar = $UI/HealthBar


func _ready() -> void:
	game_data.map_depth = 0
	var player = PLAYER_SCENE.instantiate()
	player.name = "GlobalPlayer"
	var ui_bar = UI_BARS_SCENE.instantiate()
	add_child(player)
	add_child(ui_bar)
	
	#health_bar = ui_bar.get_node("HealthBar")
	
	player.health_updated.connect(health_bar.update_health_bar)
	health_bar.update_health_bar(game_data.health_percentage, 100)
	_change_screen("main_menu")
	
# Checks if 'Escape' key was pressed to bring up the pause menu
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause_menu"):
		if pause_menu_instance != null:
			_resume_game()
		else:
			get_tree().paused = true
			pause_menu_instance = pause_menu_scene.instantiate()
			pause_menu_instance.resume_game.connect(_resume_game)
			pause_menu_instance.quit_to_main_menu.connect(_quit_to_main_menu)
			pause_menu_instance.quit_game.connect(_quit_game)
			add_child(pause_menu_instance)


func _resume_game() -> void:
	# Unpauses the game
	if pause_menu_instance != null:
		get_tree().paused = false
		pause_menu_instance.queue_free()
		pause_menu_instance = null
		

func _quit_to_main_menu() -> void:
	# Returns to main menu
	get_tree().paused = false
	
	if pause_menu_instance != null:
		pause_menu_instance.queue_free()
		pause_menu_instance = null
		
	_change_screen("main_menu")


func _quit_game() -> void:
	# Closes the game
	get_tree().quit()


const AISLE_NAVIGATION_SCENE: PackedScene = preload("res://scenes/AisleNavigation.tscn")

func _change_screen(screen_id: String) -> void:
	# Makes clicking the 'Exit Game' button quit the game
	if screen_id == "quit":
		_quit_game()
		return
	
	var new_scene_resource: PackedScene
	var is_haggle_screen = false
	
	if screen_id.begins_with("Haggle"):
		new_scene_resource = AISLE_NAVIGATION_SCENE
		is_haggle_screen = true
	elif screens.has(screen_id):
		new_scene_resource = screens[screen_id]
	else:
		push_warning("Unknown screen_id: %s" % screen_id)
		return
	
	if current_screen != null:
		remove_child(current_screen)
		current_screen.queue_free()
		
	print_debug(new_scene_resource)
	var new_screen : Screen = new_scene_resource.instantiate()
	add_child(new_screen)
	current_screen = new_screen
	current_screen.change_screen.connect(_change_screen)
	
	# Manage Global Player Visibility
	var global_player = get_node_or_null("GlobalPlayer")
	if global_player:
		global_player.visible = !is_haggle_screen
		global_player.process_mode = Node.PROCESS_MODE_INHERIT if !is_haggle_screen else Node.PROCESS_MODE_DISABLED

	
	

	
