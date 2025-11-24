# entrance.gd

class_name Entrance
extends Screen

const SHOPPING_CARTS_SCENE: PackedScene = preload("res://scenes/shopping_carts.tscn")
const BUTTON_START: Vector2 = Vector2(50, 50)
const BUTTON_SPACING: float = 50.0

var cart_options: ShoppingCarts


func _ready() -> void:
	cart_options = SHOPPING_CARTS_SCENE.instantiate()
	add_child(cart_options)
	_build_cart_menu()


func _build_cart_menu() -> void:
	var y_offset := 0.0
	for cart_id in cart_options.Carts.keys():
		var stats: Dictionary = cart_options.Carts[cart_id]
		var button := Button.new()
		button.position = BUTTON_START + Vector2(0, y_offset)
		button.text = _format_cart_label(cart_id, stats)
		button.pressed.connect(_on_cart_selected.bind(cart_id))
		add_child(button)
		y_offset += BUTTON_SPACING


func _format_cart_label(cart_id: String, stats: Dictionary) -> String:
	return "%s (Cha %d / Dex %d / Def %d)" % [
		_prettify_name(cart_id),
		int(stats.get("charisma", 0)),
		int(stats.get("dexterity", 0)),
		int(stats.get("defense", 0))
	]


func _prettify_name(name: String) -> String:
	return name.capitalize()


func _on_cart_selected(cart_id: String) -> void:
	cart_options.set_cart(cart_id)
	change_screen.emit("aisles")
