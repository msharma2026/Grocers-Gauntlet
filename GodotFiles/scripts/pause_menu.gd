# pause_menu.gd

class_name PauseMenu
extends Screen

signal resume_game
signal quit_to_main_menu
signal quit_game

var button: Array[Button]
var current_y: int = 100

@export var button_map: Dictionary[String, String]
# Creates buttons for Resume, Main Menu, and Exit Game
func _ready() -> void:
	for button_id in button_map.keys():
		var button_instance = Button.new()
		button_instance.position.y = current_y
		button_instance.text = button_id
		button_instance.pressed.connect(_on_button_pressed.bind(button_map[button_id]))
		add_child(button_instance)
		
		current_y += 50

# Emits signal for _unhandled_input() in game.gd to listen to
func _on_button_pressed(action_id: String) -> void:
	if action_id == "resume":
		resume_game.emit()
	elif action_id == "main_menu":
		quit_to_main_menu.emit()
	elif action_id == "quit":
		quit_game.emit()
