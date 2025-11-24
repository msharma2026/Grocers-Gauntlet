class_name ShoppingCarts
extends Node

@export var Carts: Array[CartConfig]

func set_cart(cart_id: String) -> String:
	var config := _find_cart_config(cart_id)
	if config == null:
		push_warning("Unknown cart_id: %s" % cart_id)
		return cart_id

	game_data.cart_type = cart_id
	game_data.charisma = config.charisma
	game_data.dexterity = config.dexterity
	game_data.defense = config.defense
	game_data.max_capacity = config.max_capacity
	return cart_id


func _find_cart_config(cart_id: String) -> CartConfig:
	for cart in Carts:
		if cart.cart_id == cart_id:
			return cart
	return null
