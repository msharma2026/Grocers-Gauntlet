#player.gd
class_name Player
extends CharacterBody2D

@export var health: float = 100.0
@export var max_health: float = 100.0

signal health_updated(new_health, max_health)

@onready var _player: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	pass
	
	
func _process(delta: float) -> void:
	pass
	
	
func _physics_process(delta: float) -> void:
	pass
	

func take_damage(amount: float) -> void:
	health -= amount
	# Prevents health being negative
	health = clampf(health, 0, max_health)
	health_updated.emit(health, max_health)
