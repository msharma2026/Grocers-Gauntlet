# entrance.gd

class_name Entrance
extends Screen


@export var carts: Array[CartConfig]


func _ready() -> void:
	_ensure_default_carts()
	_build_cart_menu()


func _build_cart_menu() -> void:
	var container := VBoxContainer.new()
	container.position = Vector2(50, 50)
	container.add_theme_constant_override("separation", 10)
	add_child(container)
	
	for cart_config in carts:
		var button := Button.new()
		button.text = _format_cart_label(cart_config)
		button.pressed.connect(_on_cart_selected.bind(cart_config.cart_id))
		container.add_child(button)


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
