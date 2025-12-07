# character.gd

class_name Character
extends CharacterBody2D

signal CharacterDirectionChange(facing:Facing)

const GAME_OVER := game_data.PlayerStatus.IS_DEAD
const DEFAULT_VELOCITY: float = 100.0

enum Facing {
	IS_FACING_LEFT,
	IS_FACING_RIGHT,
	IS_FACING_UP,
	IS_FACING_DOWN,
}

@onready var sprite: Node2D = _find_sprite()

func _find_sprite() -> Node2D:
	if has_node("AnimatedSprite2D"):
		return $AnimatedSprite2D
	elif has_node("Sprite2D"):
		return $Sprite2D
	return null

var character_facing: Facing

var move_left: Command
var move_right: Command
var move_up: Command
var move_down: Command


func _ready() -> void:
	pass 
	

func _process(_delta: float) -> void:
	pass
		
		
func _physics_process(_delta: float) -> void:
	pass
	
	
func change_facing(facing: Facing) -> void:
	character_facing = facing
	CharacterDirectionChange.emit(facing)
		
	
		
		

	
