class_name GameState
extends Node

enum PlayerStatus {
	IS_NAVIGATING,   # Player is moving between aisles (value 0)
	IS_HAGGLING,     # Player is in the Haggling minigame (value 1)
	IS_HEISTING,     # Player is in the Heisting minigame (value 2)
	IS_CHECKOUT,     # Player is in the Kiosk final boss (value 3)
	IS_DEAD,         # Player is in dead state (value 4)
}

const MAX_HEALTH: int = 100
const MAX_CHARISMA: int = 100
const MAX_DEXTERITY: int = 100
const MAX_DEFENSE: int = 100
const MAX_MARKUP_RATE: float = 2.0
const START_BUDGET: float = 100.0

# Game stats
var is_first_run: bool
var current_status: PlayerStatus
var map_depth: int  #set to 0 in game.gd _ready()

# Player stats
var health_percentage: int = 100
var charisma: int
var dexterity: int
var defense: int
var current_markup_rate: float
var budget: float = START_BUDGET

# Cart information
var cart_type: String
var inventory: Array[Item]
var max_capacity: int
