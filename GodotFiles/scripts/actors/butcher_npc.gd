# butcher_npc.gd
# Butcher merchant - neutral/grumpy, sells meat products

class_name ButcherNPC
extends NPC

# Butcher-specific properties
@export var merchant_name: String = "Butcher"
@export var default_mood: String = "neutral"
@export var base_patience: int = 3
@export var price_modifier: float = 1.1  # Meat is expensive

# Dialogue lines specific to the butcher
var greeting_lines: Array[String] = [
	"What'll it be? I've got fresh cuts today.",
	"You want meat? You came to the right place.",
	"Best cuts in town. Don't waste my time if you're not buying."
]

var haggle_success_lines: Array[String] = [
	"Ugh, fine. But only because I need to clear inventory.",
	"You're killing me here... but alright.",
	"Don't tell anyone I gave you this price."
]

var haggle_fail_lines: Array[String] = [
	"You think meat grows on trees? Price is firm.",
	"I don't haggle. Take it or leave it.",
	"That's insulting. The price just went up."
]

var buy_lines: Array[String] = [
	"Good choice. That's prime cut right there.",
	"Pleasure. Come back when you need more.",
	"You won't regret it. Best meat in the store."
]


func _ready() -> void:
	super()


func get_greeting() -> String:
	return greeting_lines[randi() % greeting_lines.size()]


func get_haggle_success() -> String:
	return haggle_success_lines[randi() % haggle_success_lines.size()]


func get_haggle_fail() -> String:
	return haggle_fail_lines[randi() % haggle_fail_lines.size()]


func get_buy_dialogue() -> String:
	return buy_lines[randi() % buy_lines.size()]
