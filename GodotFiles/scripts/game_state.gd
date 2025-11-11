# game_state.gd

class_name GameState
extends Node

enum PlayerStatus {
	IS_NAVIGATING,   # Player is moving between aisles (value 0)
	IS_HAGGLING,     # Player is in the Haggling minigame (value 1)
	IS_HEISTING,     # Player is in the Heisting minigame (value 2)
	IS_CHECKOUT      # Player is in the Kiosk final boss (value 3)
}

# Player stats
var current_status: int
var health_percentage: int
var charisma: int
var dexterity: int
var defense: int
var current_markup_rate: float
var budget: float
var map_depth: int = 0

# Cart information
var inventory: Array[Item]
var max_capacity: int
