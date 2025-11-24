# pause_menu.gd

class_name PauseMenu
extends Screen

signal resume_game
signal quit_to_main_menu
signal quit_game

@export var button_map: Array[ButtonConfig]
# Creates buttons for Resume, Main Menu, and Exit Game
func _ready() -> void:
	var container := VBoxContainer.new()
	container.position = Vector2(25, 25)
	container.add_theme_constant_override("separation", 10)
	add_child(container)
	
	for config in button_map:
		var button_instance := Button.new()
		button_instance.text = config.button_id
		button_instance.icon = config.icon

		var target = config.nav_screen
		if target == null:
			target = config.button_id.strip_edges().to_lower()
		
		button_instance.pressed.connect(_on_button_pressed.bind(target))
		container.add_child(button_instance)

# Emits signal for _unhandled_input() in game.gd to listen to
func _on_button_pressed(action_ref) -> void:
	if action_ref is PackedScene:
		change_screen.emit(action_ref)
		return
	
	if action_ref == "resume":
		resume_game.emit()
	elif action_ref == "main menu":
		quit_to_main_menu.emit()
	elif action_ref == "quit":
		quit_game.emit()
	else:
		change_screen.emit(action_ref)
