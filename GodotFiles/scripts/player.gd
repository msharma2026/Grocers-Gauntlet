#player.gd
class_name Player
extends CharacterBody2D

@export var max_health: int = 100.0

signal health_updated(new_health, max_health)

@onready var _player: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_state: GameState = get_node("/root/game_data")

func _ready() -> void:
	pass
	
	
func _process(delta: float) -> void:
	pass
	
	
func _physics_process(delta: float) -> void:
	pass
	

func take_damage(amount: float) -> void:
	game_state.health_percentage -= amount
	# Prevents health being negative
	game_state.health_percentage = clampf(game_state.health_percentage, 0, max_health)
	health_updated.emit(game_state.health_percentage, max_health)
