# character.gd

class_name Character
extends CharacterBody2D

signal CharacterDirectionChange(facing:Facing)

enum Facing {
	IS_FACING_LEFT,
	IS_FACING_RIGHT,
	IS_FACING_UP,
	IS_FACING_DOWN,
}

const DEFAULT_VELOCITY: float = 100

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var character_facing: Facing

var move_left: Command
var move_right: Command
var move_up: Command
var move_down: Command


func _ready() -> void:
	character_facing = Facing.IS_FACING_UP
	

func _process(delta: float) -> void:
	pass
		
		
func _physics_process(delta: float) -> void:
	pass
	
	
func change_facing(facing: Facing) -> void:
	character_facing = facing
	CharacterDirectionChange.emit(facing)
		
	
		
		

	
