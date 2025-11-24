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
	var message = Label.new()
	var container_size: Vector2
	var viewport_size: Vector2
	
	add_child(canvas_layer_node)
	canvas_layer_node.add_child(container_node)
	
	message.text = "Game Paused"
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	container_node.add_child(message)
	
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
		_are_you_sure_message("main menu")
	elif action_ref == "exit game":
		_are_you_sure_message("exit game")
	elif action_ref == "quit_confirm_yes":
		quit_game.emit()
	elif action_ref == "quit_confirm_no":
		resume_game.emit()
	else:
		change_screen.emit(action_ref)


func _are_you_sure_message(action_ref: String) -> void:
	for child in get_children():
		child.queue_free()
	
	var confirm_canvas := CanvasLayer.new()
	add_child(confirm_canvas)
	
	var confirm_container := VBoxContainer.new()
	confirm_canvas.add_child(confirm_container)
	confirm_container.add_theme_constant_override("separation", button_spacing)

	var message := Label.new()
	message.text = "Are you sure?"
	confirm_container.add_child(message)
	
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", button_spacing)
	confirm_container.add_child(row)
	
	var yes_button := Button.new()
	yes_button.text = "Yes"
	if action_ref == "main menu":
		yes_button.pressed.connect(func(): quit_to_main_menu.emit())
	else:
		yes_button.pressed.connect(_on_button_pressed.bind("quit_confirm_yes"))
	row.add_child(yes_button)
	
	var no_button := Button.new()
	no_button.text = "No"
	no_button.pressed.connect(_on_button_pressed.bind("quit_confirm_no"))
	row.add_child(no_button)
	
	var viewport_size = get_viewport_rect().size
	var container_size = confirm_container.size
	
	if container_size == Vector2.ZERO:
		container_size = confirm_container.get_combined_minimum_size()
	
	confirm_container.position = (viewport_size - container_size) * 0.5
