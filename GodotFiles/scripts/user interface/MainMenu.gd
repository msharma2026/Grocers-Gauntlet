# main_menu.gd

class_name MainMenu
extends Screen

# Button map holds the button's display name (Key) and the destination screen ID (Value).
@export var button_map: Array[ButtonConfig]

var current_y: int = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var container := VBoxContainer.new()
	container.position = Vector2(25, 25)
	container.add_theme_constant_override("separation", 10)  # set spacing
	add_child(container)
	
	for config in button_map:
		var button_instance := Button.new()
		button_instance.position.y = current_y
		button_instance.text = config.button_id
		button_instance.icon = config.icon
		
		button_instance.pressed.connect(_on_button_pressed.bind(config.nav_screen))
		container.add_child(button_instance)
	
	
func _on_button_pressed(screen_ref) -> void:
	change_screen.emit(screen_ref)
	
