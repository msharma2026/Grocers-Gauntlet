# Entrance.gd

class_name Entrance
extends Screen

@export var carts: Array[CartConfig]
@export var button_spacing: int = 10


func _ready() -> void:
	_ensure_default_carts()
	_build_cart_menu()
	_create_back_button()

func _create_back_button() -> void:
	var canvas_layer_node := CanvasLayer.new()
	var container_node := VBoxContainer.new()
	var back_button := Button.new()
	
	add_child(canvas_layer_node)
	canvas_layer_node.add_child(container_node)
	container_node.add_child(back_button)
	
	back_button.text = "Go Back"
	back_button.icon = null
	back_button.pressed.connect(_on_back_selected.bind("main_menu"))
	
	container_node.position = Vector2(5, 5)
	

func _build_cart_menu() -> void:
	var canvas_layer_node := CanvasLayer.new()
	var container_node := VBoxContainer.new()
	var message := Label.new()
	var container_size: Vector2
	var viewport_size: Vector2
	
	add_child(canvas_layer_node)
	canvas_layer_node.add_child(container_node)
	
	message.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	message.text = "Choose a Cart Configuration:"
	container_node.add_child(message)
	
	for cart_config in carts:
		var button := Button.new()
		button.text = _format_cart_label(cart_config)
		button.pressed.connect(_on_cart_selected.bind(cart_config.cart_id))
		container_node.add_child(button)
	
	container_size = container_node.size
	if container_size == Vector2.ZERO:
		container_size = container_node.get_combined_minimum_size()
	
	viewport_size = get_viewport_rect().size
	
	# Centers container in viewport
	container_node.position = (viewport_size - container_size) * 0.5
	container_node.add_theme_constant_override("separation", button_spacing)  # set spacing
	
	
func _format_cart_label(cart_config: CartConfig) -> String:
	return "%s (Cha %d / Dex %d / Def %d)" % [
		_prettify_name(cart_config.cart_id),
		cart_config.charisma,
		cart_config.dexterity,
		cart_config.defense
	]


func _prettify_name(name: String) -> String:
	return name.capitalize()


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
	change_screen.emit("aisles")

func _on_back_selected(screen_ref) -> void:
	change_screen.emit(screen_ref)
	
func _find_cart_config(cart_id: String) -> CartConfig:
	for cart in carts:
		if cart.cart_id == cart_id:
			return cart
	return null


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
