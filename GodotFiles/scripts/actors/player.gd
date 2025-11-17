#player.gd

class_name Player
extends Character

signal health_updated(new_health, max_health)

@onready var game_state: GameState = get_node("/root/game_data")

var max_health: int 
var start_position: Vector2

# Commented out so that healthbar works in current state
#func _init(position: Vector2) -> void:
	##start_position = position

func _ready() -> void:
	max_health = game_state.MAX_HEALTH
	game_state.is_dead = false
	
	if game_state.is_first_run:
		game_state.health_percentage = game_state.MAX_HEALTH
		game_state.current_status = game_state.IS_NAVIGATING
		game_state.is_first_run = false
	
	bind_player_inputs()
	#global_position = start_position
	
	
func _process(delta: float) -> void:
	if game_state.is_dead:
		return
	
	super(delta)
	
	
func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("move_left"):
		move_left.execute(self)
	elif Input.is_action_just_pressed("move_right"):
		move_right.execute(self)
	elif Input.is_action_just_pressed("move_up"):
		move_up.execute(self)
	elif Input.is_action_just_pressed("move_down"):
		move_down.execute(self)
	
	super(delta)
	

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
