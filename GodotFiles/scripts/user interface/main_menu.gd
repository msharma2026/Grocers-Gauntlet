# MainMenu.gd

class_name MainMenu
extends Screen

const RECEIPT_FONT = preload("res://assets/fonts/Merchant_Copy.ttf")
const LOGO_TEXTURE = preload("res://assets/sprites/logo.png")
const PRICE_TAG_TEXTURE = preload("res://assets/sprites/price_tag.png")

@export var button_map: Array[ButtonConfig]
@export var button_spacing: int = 15

var canvas_layer_node: CanvasLayer
var patch_spacing: int = -50

func _ready() -> void:
	_ensure_default_buttons()
	_build_main_menu()
	systems.audio.play_music("theme")


func _build_main_menu() -> void:
	if canvas_layer_node:
		canvas_layer_node.queue_free()
	canvas_layer_node = CanvasLayer.new()
	
	var container_node := VBoxContainer.new()
	var offset: Vector2 = Vector2(0, 0)
	
	add_child(canvas_layer_node)
	canvas_layer_node.add_child(container_node)
	
	#container_node.add_theme_constant_override("separation", button_spacing)
	
	var logo: TextureRect = TextureRect.new()
	logo.texture = LOGO_TEXTURE
	canvas_layer_node.add_child(logo)
	offset = Vector2(-100, -140)
	_center_container(logo, offset)
	container_node.add_child(logo)
	'''
	var message := Label.new()
	message.text = "Main Menu"
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.add_theme_color_override("font_color", Color.ORANGE_RED)
	message.add_theme_font_override("font", RECEIPT_FONT)
	message.add_theme_font_size_override("font_size", 48)
	offset = Vector2(0, 150)
	_center_container(message, offset)
	container_node.add_child(message)
	'''
	
	var price_tag := StyleBoxTexture.new()
	price_tag.texture = PRICE_TAG_TEXTURE
	price_tag.texture_margin_left = 20
	price_tag.texture_margin_right = 20
	price_tag.texture_margin_top = 10
	price_tag.texture_margin_bottom = 10
	
	for button_config in button_map:
		var menu_button := Button.new()
		menu_button.text = button_config.button_id
		menu_button.icon = button_config.icon
		menu_button.flat = false
		
		menu_button.add_theme_stylebox_override("normal", price_tag)
		menu_button.add_theme_stylebox_override("hover", price_tag)
		menu_button.add_theme_stylebox_override("pressed", price_tag)
		menu_button.add_theme_stylebox_override("focus", price_tag)
		
		menu_button.add_theme_font_override("font", RECEIPT_FONT)
		menu_button.add_theme_font_size_override("font_size", 60)
		menu_button.add_theme_color_override("font_color", Color.BLACK)
		menu_button.add_theme_color_override("font_hover_color", Color.CORNFLOWER_BLUE)
		menu_button.add_theme_color_override("font_focus_color", Color.BLACK)
		menu_button.add_theme_color_override("font_pressed_color", Color.BLACK)
		
		menu_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		menu_button.custom_minimum_size = Vector2(400, 20)
		
		var target = button_config.nav_screen
		if target == null:
			target = button_config.button_id.strip_edges().to_lower()
		menu_button.pressed.connect(_on_button_pressed.bind(target))
		container_node.add_child(menu_button)
		
	offset = Vector2(0,150)
	await _center_container(container_node, offset)
	container_node.add_theme_constant_override("separation", button_spacing)
	
	# Temporary patch to Main Menu title appearing artificially low
	# Due to _center_container centering a container with less buttons
	#container_node.position.y += patch_spacing
	
	
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
	
	var container_node := VBoxContainer.new()
	container_node.add_theme_constant_override("separation", button_spacing)
	add_child(canvas_layer_node)
	canvas_layer_node.add_child(container_node)
	
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
	message.add_theme_font_override("font", RECEIPT_FONT)
	message.add_theme_color_override("font_hover_color", Color.CORNFLOWER_BLUE)
	message.add_theme_color_override("font_focus_color", Color.BLACK)
	message.add_theme_color_override("font_pressed_color", Color.BLACK)
	message.add_theme_font_size_override("font_size", 60)
	confirm_container.add_child(message)
	
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", button_spacing)
	confirm_container.add_child(row)
	
	var yes_button := Button.new()
	yes_button.text = "Yes"
	yes_button.flat = true
	yes_button.add_theme_font_override("font", RECEIPT_FONT)
	yes_button.add_theme_color_override("font_hover_color", Color.CORNFLOWER_BLUE)
	yes_button.add_theme_color_override("font_focus_color", Color.BLACK)
	yes_button.add_theme_color_override("font_pressed_color", Color.BLACK)
	yes_button.add_theme_font_size_override("font_size", 60)
	yes_button.pressed.connect(_on_button_pressed.bind("exit_confirm_yes"))
	row.add_child(yes_button)
	
	var no_button := Button.new()
	no_button.text = "No"
	no_button.flat = true
	no_button.add_theme_font_override("font", RECEIPT_FONT)
	no_button.add_theme_color_override("font_hover_color", Color.CORNFLOWER_BLUE)
	no_button.add_theme_color_override("font_focus_color", Color.BLACK)
	no_button.add_theme_color_override("font_pressed_color", Color.BLACK)
	no_button.add_theme_font_size_override("font_size", 60)
	no_button.pressed.connect(_on_button_pressed.bind("exit_confirm_no"))
	row.add_child(no_button)
	
	var viewport_size = get_viewport_rect().size
	var container_size = confirm_container.size
	
	if container_size == Vector2.ZERO:
		container_size = confirm_container.get_combined_minimum_size()
	
	confirm_container.position = (viewport_size - container_size) * 0.5
	
func _center_container(container: Control, offset: Vector2) -> void:
	await get_tree().process_frame
	
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
