# MainMenu.gd

class_name MainMenu
extends Screen

@export var button_map: Array[ButtonConfig]
@export var button_spacing: int = 10

var canvas_layer_node: CanvasLayer

func _ready() -> void:
	_ensure_default_buttons()
	_build_main_menu()


func _build_main_menu() -> void:
	if canvas_layer_node:
		canvas_layer_node.queue_free()
	canvas_layer_node = CanvasLayer.new()
	var container_node := VBoxContainer.new()
	var message := Label.new()
	var container_size: Vector2
	var viewport_size: Vector2
	
	add_child(canvas_layer_node)
	canvas_layer_node.add_child(container_node)
	
	message.text = "Main Menu:"
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	container_node.add_child(message)
	
	for button_config in button_map:
		var menu_button := Button.new()
		menu_button.text = button_config.button_id
		menu_button.icon = button_config.icon
		var target = button_config.nav_screen
		if target == null:
			target = button_config.button_id.strip_edges().to_lower()
		menu_button.pressed.connect(_on_button_pressed.bind(target))
		container_node.add_child(menu_button)
		
	container_size = container_node.size
	if container_size == Vector2.ZERO:
		container_size = container_node.get_combined_minimum_size()
	
	viewport_size = get_viewport_rect().size
	
	# Centers container in viewport
	container_node.position = (viewport_size - container_size) * 0.5
	container_node.add_theme_constant_override("separation", button_spacing)  # set spacing
	
	
func _on_button_pressed(screen_ref) -> void:
	if screen_ref is PackedScene:
		if screen_ref.resource_path.ends_with("exit.tscn"):
			_are_you_sure_message()
			return
		change_screen.emit(screen_ref)
		return
	
	if screen_ref == "exit game":
		_are_you_sure_message()
		return
	elif screen_ref == "quit_confirm_yes":
		change_screen.emit("exit")
		return
	elif screen_ref == "quit_confirm_no":
		_build_main_menu()
		return
	
	change_screen.emit(screen_ref)
	

func _ensure_default_buttons() -> void:
	if button_map.size() > 0:
		return
	
	var canvas_layer_node := CanvasLayer.new()
	var container_node := VBoxContainer.new()
	container_node.add_theme_constant_override("separation", button_spacing)
	add_child(canvas_layer_node)
	canvas_layer_node.add_child(container_node)
	
	var main_menu_button := Button.new()
	main_menu_button.text = "Main Menu"
	main_menu_button.pressed.connect(_on_button_pressed.bind(load("res://scenes/screens/main_menu.tscn")))
	container_node.add_child(main_menu_button)
	
	var exit_button := Button.new()
	exit_button.text = "Exit Game"
	exit_button.pressed.connect(_on_button_pressed.bind(load("res://scenes/exit.tscn")))
	container_node.add_child(exit_button)


func _are_you_sure_message() -> void:
	if canvas_layer_node:
		canvas_layer_node.queue_free()
	canvas_layer_node = CanvasLayer.new()
	add_child(canvas_layer_node)
	
	var confirm_container := VBoxContainer.new()
	canvas_layer_node.add_child(confirm_container)
	confirm_container.add_theme_constant_override("separation", button_spacing)

	var message := Label.new()
	message.text = "Are you sure?"
	confirm_container.add_child(message)
	
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", button_spacing)
	confirm_container.add_child(row)
	
	var yes_button := Button.new()
	yes_button.text = "Yes"
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
