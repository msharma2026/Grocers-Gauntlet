# pause_menu.gd

class_name PauseMenu
extends Screen

signal resume_game
signal quit_to_main_menu
signal quit_game

@export var button_map: Array[ButtonConfig]
@export var button_spacing: int = 10

var event: InputEvent

# Creates buttons for Resume, Main Menu, and Exit Game
func _ready() -> void:
	var canvas_layer_node := CanvasLayer.new()
	var container_node := VBoxContainer.new()
	var container_size: Vector2
	var viewport_size: Vector2
	
	add_child(canvas_layer_node)
	canvas_layer_node.add_child(container_node)
	
	for config in button_map:
		var menu_button := Button.new()
		menu_button.text = config.button_id
		menu_button.icon = config.icon

		var target = config.nav_screen
		if target == null:
			target = config.button_id.strip_edges().to_lower()
		
		menu_button.pressed.connect(_on_button_pressed.bind(target))
		container_node.add_child(menu_button)
		
	container_size = container_node.size
	if container_size == Vector2.ZERO:
		container_size = container_node.get_combined_minimum_size()
	
	viewport_size = get_viewport_rect().size
	
	# Centers container in viewport
	container_node.position = (viewport_size - container_size) * 0.5
	container_node.add_theme_constant_override("separation", 10)

		
# Emits signal for _unhandled_input() in game.gd to listen to
func _on_button_pressed(action_ref) -> void:
	if action_ref is PackedScene:
		change_screen.emit(action_ref)
		return
	
	if action_ref == "resume":
		resume_game.emit()
	elif action_ref == "main menu":
		quit_to_main_menu.emit()
	elif action_ref == "exit game":
		quit_game.emit()
	else:
		change_screen.emit(action_ref)
