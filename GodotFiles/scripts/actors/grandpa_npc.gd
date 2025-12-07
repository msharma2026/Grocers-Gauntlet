# grandpa_npc.gd
# Grandpa merchant - grumpy but fair, tells stories

class_name GrandpaNPC
extends NPC

# Grandpa-specific properties
@export var merchant_name: String = "Grandpa"
@export var default_mood: String = "grumpy"
@export var base_patience: int = 2  # Gets annoyed easily
@export var price_modifier: float = 1.0  # Fair prices

# Dialogue lines specific to grandpa
var greeting_lines: Array[String] = [
	"Eh? What do you want? Speak up!",
	"Back in my day, we didn't dawdle! What'll it be?",
	"Another customer... fine, what do you need?"
]

var haggle_success_lines: Array[String] = [
	"Bah! You remind me of myself when I was young. Fine, take it.",
	"Alright, alright! Just stop talking my ear off!",
	"You've got moxie, kid. I respect that. Deal."
]

var haggle_fail_lines: Array[String] = [
	"In my day, we paid full price and liked it!",
	"You think I was born yesterday? Price is price!",
	"Bah! Kids these days always want a handout!"
]

var buy_lines: Array[String] = [
	"Now get out of here before I tell you another war story.",
	"Good. Now scram, I've got napping to do.",
	"Finally! A customer who knows what they want!"
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
