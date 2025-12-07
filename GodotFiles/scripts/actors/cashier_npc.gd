# cashier_npc.gd
# Cashier/Clerk merchant - neutral, handles candy/dex items

class_name CashierNPC
extends NPC

# Cashier-specific properties
@export var merchant_name: String = "Cashier"
@export var default_mood: String = "neutral"
@export var base_patience: int = 3
@export var price_modifier: float = 1.0  # Standard prices

# Dialogue lines specific to the cashier
var greeting_lines: Array[String] = [
	"Hey there. You need something from the front?",
	"Welcome. Let me know if you need help finding anything.",
	"Just browsing or are you ready to check out?"
]

var haggle_success_lines: Array[String] = [
	"Alright, I can give you the employee discount... just this once.",
	"Fine, but don't tell my manager.",
	"You got lucky. I'm feeling generous today."
]

var haggle_fail_lines: Array[String] = [
	"Sorry, I don't set the prices. Take it up with corporate.",
	"Can't do it. The register would flag it.",
	"Nice try, but that's not how this works."
]

var buy_lines: Array[String] = [
	"Thanks for shopping with us!",
	"Receipt's in the bag. Have a nice day!",
	"Come back soon!"
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
