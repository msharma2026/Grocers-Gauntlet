class_name ShoppingCarts
extends Node

var Carts = {
	"rogues_basket": {
		"charisma": 40,
		"dexterity": 80,
		"defense": 30,
	},
	"paladins_chariot": {
		"charisma": 40,
		"dexterity": 30,
		"defense": 80,
	},
}

func set_cart(cart_id: String) -> String:
	game_data.cart_type = cart_id
	game_data.charisma = Carts[cart_id]["charisma"]
	game_data.dexterity = Carts[cart_id]["dexterity"]
	game_data.defense = Carts[cart_id]["defense"]
	return cart_id

	
