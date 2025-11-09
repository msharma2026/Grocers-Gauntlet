# main_menu.gd

class_name MainMenu
extends Screen

# Button map holds the button's display name (Key) and the destination screen ID (Value).
@export var button_map: Dictionary[String, String]

var button: Array[Button]
var current_y: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for button_id in button_map.keys():
		var button_instance = Button.new()
		button_instance.position.y = current_y
		button_instance.text = button_id
		button_instance.pressed.connect(_on_button_pressed.bind(button_map[button_id]))
		add_child(button_instance)
		
		current_y += 20
	
	
func _on_button_pressed(screen_id: String) -> void:
	change_screen.emit(screen_id)
	
