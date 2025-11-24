# MainMenu.gd

class_name MainMenu
extends Screen

@export var button_map: Array[ButtonConfig]
@export var button_spacing: int = 10


func _ready() -> void:
	_ensure_default_buttons()
	_build_main_menu()


func _build_main_menu() -> void:
	var canvas_layer_node := CanvasLayer.new()
	var container_node := VBoxContainer.new()
	var container_size: Vector2
	var viewport_size: Vector2
	
	add_child(canvas_layer_node)
	canvas_layer_node.add_child(container_node)
	
	for button_config in button_map:
		var menu_button := Button.new()
		menu_button.text = button_config.button_id
		menu_button.icon = button_config.icon
		menu_button.pressed.connect(_on_button_pressed.bind(button_config.nav_screen))
		container_node.add_child(menu_button)
		
	container_size = container_node.size
	if container_size == Vector2.ZERO:
		container_size = container_node.get_combined_minimum_size()
	
	viewport_size = get_viewport_rect().size
	
	# Centers container in viewport
	container_node.position = (viewport_size - container_size) * 0.5
	container_node.add_theme_constant_override("separation", button_spacing)  # set spacing
	
	
func _on_button_pressed(screen_ref) -> void:
	change_screen.emit(screen_ref)
	

func _ensure_default_buttons() -> void:
	if button_map.size() > 0:
		return
	
	var start_game := ButtonConfig.new()
	start_game.button_id = "Start Game"
	start_game.nav_screen = load("res://scenes/screens/entrance.tscn")
	start_game.icon = null
	button_map.append(start_game)
