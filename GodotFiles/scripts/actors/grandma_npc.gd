# grandma_npc.gd
# Grandma merchant - very friendly, kind, gives good deals

class_name GrandmaNPC
extends NPC

# Grandma-specific properties
@export var merchant_name: String = "Grandma"
@export var default_mood: String = "friendly"
@export var base_patience: int = 5  # Very patient
@export var price_modifier: float = 0.8  # Gives good deals

# Dialogue lines specific to grandma
var greeting_lines: Array[String] = [
	"Oh hello dear! Come in, come in!",
	"Well aren't you a sweet thing! What can I get you?",
	"Oh my, you look just like my grandchild! What do you need, honey?"
]

var haggle_success_lines: Array[String] = [
	"Oh of course dear, anything for you!",
	"You remind me of my grandkids. Take it for less, sweetheart.",
	"Oh stop, you're making me blush! Fine, fine, take the discount!"
]

var haggle_fail_lines: Array[String] = [
	"Oh honey, I wish I could, but my pension only goes so far...",
	"I'm sorry dear, but even grandma has limits.",
	"Oh sweetheart, you're breaking my heart, but I can't go lower."
]

var buy_lines: Array[String] = [
	"Take care now, dear! Don't forget to eat!",
	"Such a polite young person! Come back anytime!",
	"Bless your heart! Stay safe out there!"
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
