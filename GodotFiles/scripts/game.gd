# game.gd

class_name Game
extends Node2D

# Note 1: For the 'screens' dictionary, the Key (string) MUST exactly match the 
# destination screen_id in 'main_menu.gd' you plan to emit via a button signal.
# Note 2: The 'change_screen' signal must be manually updated in the 
# Inspector panel for 'main_menu.tscn' under button_map dictionary.

@export var screens : Dictionary[String, PackedScene]

var current_screen : Screen


func _ready() -> void:
	_change_screen("main_menu")
	

func _change_screen(screen_id: String) -> void:
	
	if !screens.has(screen_id):
		push_warning("Unknown screen_id: %s" % screen_id)
		return
	
	if current_screen != null:
		remove_child(current_screen)
		current_screen.queue_free()

	print_debug(screens[screen_id])
	var new_screen : Screen = screens[screen_id].instantiate()
	add_child(new_screen)
	current_screen = new_screen
	current_screen.change_screen.connect(_change_screen)
	
	

	
