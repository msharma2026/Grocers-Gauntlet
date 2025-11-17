#player.gd

class_name Player
extends Character

signal health_updated(new_health, max_health)

@onready var _sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var game_state: GameState = get_node("/root/game_data")

var max_health: int = game_state.MAX_HEALTH
var is_first_run: bool = true
var start_pos := Vector2(0,0)

func _ready() -> void:
	if is_first_run:
		game_state.health_percentage = game_state.MAX_HEALTH
		is_first_run = false
	
	global_position = start_pos
	
	
func _process(delta: float) -> void:
	pass
	
	
func _physics_process(delta: float) -> void:
	pass
	

func take_damage(amount: float) -> void:
	game_state.health_percentage -= amount
	# Prevents health being negative
	game_state.health_percentage = clampf(game_state.health_percentage, 0, max_health)
	health_updated.emit(game_state.health_percentage, max_health)
	
func bind_player_inputs():
	move_left = MoveLeft.new()
	move_right = MoveRight.new()
	move_up = MoveUp.new()
	move_down = MoveDown.new()
	
func unbind_player_inputs():
	move_left = null
	move_right = null
	move_up = null
	move_down = null
