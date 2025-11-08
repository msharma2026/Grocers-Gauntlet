extends Node2D


@export var main_menu : PackedScene
@export var entrance : PackedScene

var current_screen : Screen = null


var screens = {}

func _ready() -> void:
	screens = {
			"main_menu": main_menu,
			"entrance": entrance
	}
	_change_screen("main_menu")
	
	
func _change_screen(screen : String) -> void:
	if current_screen != null:
		remove_child(current_screen)
		current_screen.queue_free()
	
	print_debug(screens[screen])
	var new_screen : Screen = screens[screen].instantiate()
	add_child(new_screen)
	current_screen = new_screen
	current_screen.change_screen.connect(_change_screen)
	
	

	
