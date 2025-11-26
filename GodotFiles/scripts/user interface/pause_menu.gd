# pause_menu.gd

class_name PauseMenu
extends Screen

signal resume_game
signal quit_to_main_menu
signal quit_game

@export var button_map: Array[ButtonConfig]
@export var button_spacing: int = 10

var event: InputEvent
var main_menu_container: Control
var options_container: Control
var confirm_canvas: CanvasLayer

func _ready() -> void:
	_build_main_menu()

func _build_main_menu() -> void:
	if options_container:
		options_container.queue_free()
		options_container = null
	if confirm_canvas:
		confirm_canvas.queue_free()
		confirm_canvas = null
	if main_menu_container:
		main_menu_container.queue_free()
		main_menu_container = null

	var canvas_layer_node := CanvasLayer.new()
	var container_node := VBoxContainer.new()
	var message := Label.new()

	add_child(canvas_layer_node)
	canvas_layer_node.add_child(container_node)
	main_menu_container = container_node

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

	_center_container(container_node)
	container_node.add_theme_constant_override("separation", button_spacing)

func _on_button_pressed(action_ref) -> void:
	if action_ref is PackedScene:
		if action_ref.resource_path.ends_with("exit.tscn"):
			_are_you_sure_message("exit game")
			return
		change_screen.emit(action_ref)
		return

	match action_ref:
		"resume":
			resume_game.emit()
		"main menu":
			_are_you_sure_message("main menu")
		"options":
			_open_options_menu()
		"options_back":
			_close_sub_menus()
		"exit game":
			_are_you_sure_message("exit game")
		"quit_confirm_yes":
			quit_game.emit()
		"quit_confirm_no":
			_close_sub_menus()
		_:
			change_screen.emit(action_ref)

func _are_you_sure_message(action_ref: String) -> void:
	if main_menu_container:
		main_menu_container.visible = false

	confirm_canvas = CanvasLayer.new()
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

	_center_container(confirm_container)

func _open_options_menu() -> void:
	if main_menu_container:
		main_menu_container.visible = false

	options_container = VBoxContainer.new()
	options_container.add_theme_constant_override("separation", 15)

	var canvas: CanvasLayer = main_menu_container.get_parent()
	canvas.add_child(options_container)

	var title := Label.new()
	title.text = "Options"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	options_container.add_child(title)

	var fullscreen_check := CheckButton.new()
	fullscreen_check.text = "Fullscreen"
	var current_mode = DisplayServer.window_get_mode()
	fullscreen_check.button_pressed = (current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN or current_mode == DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	fullscreen_check.toggled.connect(_fullscreen_toggle)
	options_container.add_child(fullscreen_check)

	var vol_label := Label.new()
	vol_label.text = "Volume"
	options_container.add_child(vol_label)

	var vol_slider := HSlider.new()
	vol_slider.min_value = 0.0
	vol_slider.max_value = 1.0
	vol_slider.step = 0.05
	vol_slider.custom_minimum_size = Vector2(200, 0)
	var bus_idx = AudioServer.get_bus_index("Master")
	if bus_idx != -1:
		vol_slider.value = db_to_linear(AudioServer.get_bus_volume_db(bus_idx))
	vol_slider.value_changed.connect(_volume_change)
	options_container.add_child(vol_slider)

	var back_button := Button.new()
	back_button.text = "Back"
	back_button.pressed.connect(_on_button_pressed.bind("options_back"))
	options_container.add_child(back_button)

	_center_container(options_container)

func _fullscreen_toggle(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _volume_change(value: float) -> void:
	var bus_idx = AudioServer.get_bus_index("Master")
	if bus_idx != -1:
		AudioServer.set_bus_volume_db(bus_idx, linear_to_db(value))
		AudioServer.set_bus_mute(bus_idx, value < 0.01)

func _close_sub_menus() -> void:
	if options_container:
		options_container.queue_free()
		options_container = null
	if confirm_canvas:
		confirm_canvas.queue_free()
		confirm_canvas = null
	if main_menu_container:
		main_menu_container.visible = true

func _center_container(container: Control) -> void:
	await get_tree().process_frame
	if container == null:
		return
	var container_size: Vector2 = container.size
	if container_size == Vector2.ZERO:
		container_size = container.get_combined_minimum_size()
	var viewport_size = get_viewport_rect().size
	container.position = (viewport_size - container_size) * 0.5
