# Entrance.gd

class_name Entrance
extends Screen

const ITEM_LIBRARY_SCENE: PackedScene = preload("res://scenes/item_library.tscn")
const PRICE_TAG_TEXTURE: CompressedTexture2D = preload("res://assets/sprites/price_tag.png")
const RECEIPT_FONT: FontFile = preload("res://assets/fonts/Merchant_Copy.ttf")

# for transition animation
@export var transition_curve: Curve
@export var slide_distance: float = 400.0  
@export var anim_duration : float = 0.25


@export var carts: Array[CartConfig]
@export var button_spacing: int = 10
@export var background_texture: Texture2D
@export var background_color: Color = Color(0.12, 0.12, 0.12, 1.0)

# for transition animation
var main_cart: Sprite2D        
var next_cart: Sprite2D        
var is_animating := false
var anim_time : float

var main_start: Vector2
var main_end: Vector2
var next_start: Vector2
var next_end: Vector2

var selected_cart_index: int = 0
var cart_label: Label
var stats_label: Label
var ui_root: Control

# for transition animation 
@onready var rogue_cart: Sprite2D = %RogueCartSprite
@onready var paladin_cart: Sprite2D = %PaladinCartSprite

@onready var player_start_inventory: ItemLibrary

func _ready() -> void:
	_ensure_default_carts()
	_build_cart_menu()
	_create_back_button()
	
	player_start_inventory = ITEM_LIBRARY_SCENE.instantiate()
	add_child(player_start_inventory)
	
	# for cart animation
	main_cart = rogue_cart
	next_cart = paladin_cart

	main_cart.position = Vector2(100, 100)
	next_cart.position = Vector2(slide_distance + 100, 100)


func _process(delta: float) -> void:
	
	# Below for animating transition
	if not is_animating:
		return

	anim_time += delta
	var t := anim_time / anim_duration
	if t > 1.0:
		t = 1.0

	var curved_t := transition_curve.sample(t)

	main_cart.position = main_start.lerp(main_end, curved_t)
	next_cart.position = next_start.lerp(next_end, curved_t)

	if t >= 1.0:
		_finish_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_left"):
		_cycle_cart(-1)
	elif event.is_action_pressed("ui_right"):
		_cycle_cart(1)
	

func _create_back_button() -> void:
	var canvas_layer_node := CanvasLayer.new()
	var container_node := VBoxContainer.new()
	var back_button := Button.new()
	var back_button_style := StyleBoxTexture.new()
	
	add_child(canvas_layer_node)
	canvas_layer_node.add_child(container_node)
	container_node.add_child(back_button)
	
	back_button_style.texture = PRICE_TAG_TEXTURE
	back_button_style.texture_margin_left = 20
	back_button_style.texture_margin_right = 50
	back_button_style.texture_margin_top = 5
	back_button_style.texture_margin_bottom = 5
	
	back_button.text = "Go Back"
	back_button.icon = null
	back_button.custom_minimum_size = Vector2(200, 50)
	# Back button styling
	back_button.alignment = HORIZONTAL_ALIGNMENT_LEFT
	back_button.add_theme_stylebox_override("normal", back_button_style)
	back_button.add_theme_stylebox_override("hover", back_button_style)
	back_button.add_theme_stylebox_override("pressed", back_button_style)
	back_button.add_theme_stylebox_override("focus", back_button_style)
	
	back_button.add_theme_color_override("font_color", Color.BLACK)
	back_button.add_theme_color_override("font_pressed_color", Color.BLACK)
	back_button.add_theme_color_override("font_hover_color", Color.CORNFLOWER_BLUE)
	back_button.add_theme_color_override("font_focus_color", Color.BLACK)
	back_button.add_theme_font_override("font", RECEIPT_FONT)
	back_button.add_theme_font_size_override("font_size", 36)
	
	back_button.pressed.connect(_on_back_selected.bind("main_menu"))
	
	container_node.position = Vector2(5, 5)
	

func _build_cart_menu() -> void:
	if ui_root:
		ui_root.queue_free()

	var canvas_layer_node := CanvasLayer.new()
	add_child(canvas_layer_node)
	ui_root = Control.new()
	ui_root.set_anchors_preset(Control.PRESET_FULL_RECT)
	canvas_layer_node.add_child(ui_root)

	if background_texture:
		var bg := TextureRect.new()
		bg.texture = background_texture
		bg.set_anchors_preset(Control.PRESET_FULL_RECT)
		bg.stretch_mode = TextureRect.STRETCH_SCALE
		bg.mouse_filter = Control.MOUSE_FILTER_IGNORE
		ui_root.add_child(bg)
	else:
		var bg_color := ColorRect.new()
		bg_color.color = background_color
		bg_color.set_anchors_preset(Control.PRESET_FULL_RECT)
		bg_color.mouse_filter = Control.MOUSE_FILTER_IGNORE
		ui_root.add_child(bg_color)

	var center := CenterContainer.new()
	center.set_anchors_preset(Control.PRESET_FULL_RECT)
	ui_root.add_child(center)

	var container_node := VBoxContainer.new()
	container_node.add_theme_constant_override("separation", button_spacing)
	container_node.alignment = BoxContainer.ALIGNMENT_CENTER
	center.add_child(container_node)

	var message := Label.new()
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.text = "Choose a Cart Configuration:"
	message.add_theme_font_override("font", RECEIPT_FONT)
	message.add_theme_font_size_override("font_size", 36)
	container_node.add_child(message)
	
	var slider_row := HBoxContainer.new()
	slider_row.alignment = BoxContainer.ALIGNMENT_CENTER
	slider_row.add_theme_constant_override("separation", button_spacing)
	container_node.add_child(slider_row)

	var prev_button := Button.new()
	prev_button.text = "<"
	prev_button.pressed.connect(func(): _cycle_cart(-1))
	slider_row.add_child(prev_button)

	var info_column := VBoxContainer.new()
	info_column.alignment = BoxContainer.ALIGNMENT_CENTER
	info_column.add_theme_constant_override("separation", 6)
	slider_row.add_child(info_column)

	cart_label = Label.new()
	cart_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	cart_label.add_theme_font_override("font", RECEIPT_FONT)
	cart_label.add_theme_font_size_override("font_size", 24)
	info_column.add_child(cart_label)

	stats_label = Label.new()
	stats_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	stats_label.autowrap_mode = TextServer.AUTOWRAP_WORD
	stats_label.add_theme_font_override("font", RECEIPT_FONT)
	stats_label.add_theme_font_size_override("font_size", 24)
	info_column.add_child(stats_label)

	var next_button := Button.new()
	next_button.text = ">"
	next_button.pressed.connect(func(): _cycle_cart(1))
	slider_row.add_child(next_button)

	var select_button := Button.new()
	select_button.text = "Select Cart"
	select_button.add_theme_font_override("font", RECEIPT_FONT)
	select_button.add_theme_font_size_override("font_size", 36)
	select_button.pressed.connect(func(): _on_cart_selected(_current_cart().cart_id))
	container_node.add_child(select_button)
	
	_update_cart_display()
	
	
func _format_cart_label(cart_config: CartConfig) -> String:
	return "%s (Cha %d / Dex %d / Def %d)" % [
		_prettify_name(cart_config.cart_id),
		cart_config.charisma,
		cart_config.dexterity,
		cart_config.defense
	]


func _prettify_name(new_name: String) -> String:
	return new_name.capitalize()


func _on_cart_selected(cart_id: String) -> void:
	var config := _find_cart_config(cart_id)
	if config == null:
		push_warning("Unknown cart_id: %s" % cart_id)
		return
	
	game_data.cart_type = cart_id
	game_data.charisma = config.charisma
	game_data.dexterity = config.dexterity
	game_data.defense = config.defense
	game_data.max_capacity = config.max_capacity
	
	player_start_inventory.assign_starter_items()
	
	change_screen.emit("aisles")

func _on_back_selected(screen_ref) -> void:
	change_screen.emit(screen_ref)
	
func _find_cart_config(cart_id: String) -> CartConfig:
	for cart in carts:
		if cart.cart_id == cart_id:
			return cart
	return null


func _cycle_cart(direction: int) -> void:
	if carts.is_empty():
		return
	selected_cart_index = (selected_cart_index + direction) % carts.size()
	if selected_cart_index < 0:
		selected_cart_index = carts.size() - 1
	_update_cart_display()
	_start_slide()


func _current_cart() -> CartConfig:
	if carts.is_empty():
		return null
	if selected_cart_index < 0 or selected_cart_index >= carts.size():
		selected_cart_index = clamp(selected_cart_index, 0, carts.size() - 1)
	return carts[selected_cart_index]


func _update_cart_display() -> void:
	var cart := _current_cart()
	if cart == null:
		return
	if cart_label:
		cart_label.text = _format_cart_label(cart)
	if stats_label:
		stats_label.text = "Capacity: %d" % cart.max_capacity


func _ensure_default_carts() -> void:
	if carts.size() > 0:
		return
	
	var rogue := CartConfig.new()
	rogue.cart_id = "rogues_basket"
	rogue.charisma = 40
	rogue.dexterity = 80
	rogue.defense = 30
	carts.append(rogue)
	
	var paladin := CartConfig.new()
	paladin.cart_id = "paladins_chariot"
	paladin.charisma = 40
	paladin.dexterity = 30
	paladin.defense = 80
	carts.append(paladin)
	
func _start_slide() -> void:
	is_animating = true
	anim_time = 0.0

	main_start = main_cart.position
	main_end = Vector2(-slide_distance + 100, 100)

	next_start = next_cart.position
	next_end = Vector2(100, 100)

func _finish_slide() -> void:
	is_animating = false

	main_cart.position = Vector2(slide_distance + 100, 100)

	var temp = main_cart
	main_cart = next_cart
	next_cart = temp
