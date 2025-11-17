# shopping_carts.gd

class_name ShoppingCarts
extends Node

@onready var game_state: GameState = get_node("/root/game_data")

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
	game_state.cart_type = cart_id
	game_state.charisma = Carts[cart_id]["charisma"]
	game_state.dexterity = Carts[cart_id]["dexterity"]
	game_state.defense = Carts[cart_id]["defense"]
	return cart_id

	
