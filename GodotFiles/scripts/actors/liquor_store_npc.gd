# liquor_store_npc.gd
# Liquor Store Employee - chill/neutral, sells alcohol/charisma items

class_name LiquorStoreNPC
extends NPC

# Liquor store employee-specific properties
@export var merchant_name: String = "Liquor Store Clerk"
@export var default_mood: String = "neutral"
@export var base_patience: int = 3
@export var price_modifier: float = 1.15  # Alcohol markup

# Dialogue lines specific to the liquor store employee
var greeting_lines: Array[String] = [
	"Yo, what's up? Need something to take the edge off?",
	"Welcome to the store. ID please... just kidding. What do you need?",
	"Hey there. Looking for anything specific?"
]

var haggle_success_lines: Array[String] = [
	"Aight, I feel you. Times are tough. Here's a deal.",
	"You know what? Sure. Just don't tell my boss.",
	"Fine, but you're buying me a drink next time."
]

var haggle_fail_lines: Array[String] = [
	"Nah man, I can't do that. The margins on booze are already thin.",
	"Sorry dude, no can do. Gotta pay the bills.",
	"Look, I get it, but the price is the price."
]

var buy_lines: Array[String] = [
	"Cheers! Drink responsibly... or don't, I'm not your mom.",
	"Here you go. Party on!",
	"Nice choice. That's the good stuff."
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
