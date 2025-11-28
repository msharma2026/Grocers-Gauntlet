# MainMenu.gd

class_name MainMenu
extends Screen

const RECEIPT_TEXTURE = preload("res://assets/sprites/receipt.png")
const RECEIPT_FONT = preload("res://assets/fonts/Merchant_Copy.ttf")

@export var button_map: Array[ButtonConfig]
@export var button_spacing: int = 10

var canvas_layer_node: CanvasLayer
var patch_spacing: int = -50

func _ready() -> void:
	_ensure_default_buttons()
	_build_main_menu()


func _build_main_menu() -> void:
	if canvas_layer_node:
		canvas_layer_node.queue_free()
	canvas_layer_node = CanvasLayer.new()
	
	var container_node := VBoxContainer.new()
	var container_size: Vector2
	var viewport_size: Vector2
	
	add_child(canvas_layer_node)
	
	# Creates receipt pause menu background
	var receipt := TextureRect.new()
	receipt.texture = RECEIPT_TEXTURE
	
	canvas_layer_node.add_child(receipt)
	_center_container(receipt)
	
	receipt.add_child(container_node)
	
	# Container fills receipt with padding to avoid text touching edges
	container_node.set_anchors_preset(Control.PRESET_FULL_RECT)
	container_node.add_theme_constant_override("margin_left", 50)
	container_node.add_theme_constant_override("margin_right", 50)
	container_node.add_theme_constant_override("margin_top", 80)
	container_node.add_theme_constant_override("margin_bottom", 80)
	container_node.add_theme_constant_override("separation", 12)
	
	var message := Label.new()
	message.text = "Main Menu"
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.add_theme_color_override("font_color", Color.BLACK)
	message.add_theme_font_override("font", RECEIPT_FONT)
	message.add_theme_font_size_override("font_size", 48)
	container_node.add_child(message)
	
	for button_config in button_map:
		var menu_button := Button.new()
		menu_button.text = button_config.button_id
		menu_button.flat = true
		menu_button.add_theme_font_override("font", RECEIPT_FONT)
		menu_button.add_theme_font_size_override("font_size", 36)
		menu_button.add_theme_color_override("font_color", Color.BLACK)
		menu_button.add_theme_color_override("font_hover_color", Color.CORNFLOWER_BLUE)
		menu_button.add_theme_color_override("font_focus_color", Color.BLACK)
		menu_button.add_theme_color_override("font_pressed_color", Color.BLACK)
		menu_button.alignment = HORIZONTAL_ALIGNMENT_CENTER
		
		var target = button_config.nav_screen
		if target == null:
			target = button_config.button_id.strip_edges().to_lower()
		menu_button.pressed.connect(_on_button_pressed.bind(target))
		container_node.add_child(menu_button)
	
	await _center_container(container_node)
	container_node.add_theme_constant_override("separation", button_spacing)
	
	# Temporary patch to Main Menu title appearing artificially low
	# Due to _center_container centering a container with less buttons
	container_node.position.y += patch_spacing
	
	
func _on_button_pressed(screen_ref) -> void:
	if screen_ref is PackedScene:
		if screen_ref.resource_path.ends_with("exit.tscn"):
			_are_you_sure_message()
			return
		change_screen.emit(screen_ref)
		return
		
	if screen_ref is String:
		if screen_ref == "exit_confirm_yes":
			change_screen.emit("exit")
			return
		elif screen_ref == "exit_confirm_no":
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
	yes_button.pressed.connect(_on_button_pressed.bind("exit_confirm_yes"))
	row.add_child(yes_button)
	
	var no_button := Button.new()
	no_button.text = "No"
	no_button.pressed.connect(_on_button_pressed.bind("exit_confirm_no"))
	row.add_child(no_button)
	
	var viewport_size = get_viewport_rect().size
	var container_size = confirm_container.size
	
	if container_size == Vector2.ZERO:
		container_size = confirm_container.get_combined_minimum_size()
	
	confirm_container.position = (viewport_size - container_size) * 0.5
	
func _center_container(container: Control) -> void:
	await get_tree().process_frame
	var offset: Vector2 = Vector2(-10, 50)
	
	if container == null:
		return
	
	var container_size: Vector2 = container.size
	
	if container_size == Vector2.ZERO:
		container_size = container.get_combined_minimum_size()
	var parent_size: Vector2 = Vector2.ZERO
	var parent := container.get_parent()
	
	if parent is Control:
		parent_size = parent.size
	else:
		parent_size = get_viewport_rect().size
		
	container.position = (parent_size - container_size) * 0.5 + offset
