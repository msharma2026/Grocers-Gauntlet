# baker_npc.gd
# Baker merchant - friendly, sells bread/baked goods

class_name BakerNPC
extends NPC

# Baker-specific properties
@export var merchant_name: String = "Baker"
@export var default_mood: String = "friendly"
@export var base_patience: int = 4
@export var price_modifier: float = 0.9  # Slightly cheaper prices

# Dialogue lines specific to the baker
var greeting_lines: Array[String] = [
	"Welcome to the bakery! Fresh bread, just out of the oven!",
	"Ah, a customer! You look like you could use some carbs.",
	"The smell of fresh bread always brings people in!"
]

var haggle_success_lines: Array[String] = [
	"Alright, for a bread lover like you, I'll make an exception!",
	"You drive a hard bargain! But I appreciate the enthusiasm.",
	"Fine, fine! Take it before I change my mind!"
]

var haggle_fail_lines: Array[String] = [
	"Sorry friend, I can't go that low. Flour isn't free!",
	"I've got a family to feed too, you know.",
	"That's barely enough to cover the yeast!"
]

var buy_lines: Array[String] = [
	"Pleasure doing business! Enjoy the bread!",
	"Come back anytime! I'll save you a fresh loaf!",
	"Thank you kindly! Nothing beats fresh bread!"
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
