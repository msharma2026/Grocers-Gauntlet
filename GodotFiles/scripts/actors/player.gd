class_name Player
extends Character

signal health_updated(new_health, max_health)

var max_health: int 
# Bottom-center of screen
@export var start_position: Vector2 = Vector2(576, 500) 
@export var frames: SpriteFrames
@export var texture: Texture2D 

func _ready() -> void:
	max_health = game_data.MAX_HEALTH
	character_facing = Facing.IS_FACING_UP
	
	if game_data.is_first_run:
		game_data.health_percentage = game_data.MAX_HEALTH
		game_data.current_status = game_data.IS_NAVIGATING
		game_data.is_first_run = false
	
	# On top of every scene
	z_index = 10 
	global_position = start_position
	
	sprite.scale = Vector2(0.5, 0.5)
		
	frames = SpriteFrames.new()
			
	if ResourceLoader.exists("res://assets/sprites/placeholders/player.png"):
		texture = load("res://assets/sprites/placeholders/player.png")
		print("DEBUG: Loaded res://assets/sprites/placeholders/player.png")
	elif ResourceLoader.exists("res://icon.svg"):
		texture = load("res://icon.svg")
		print("DEBUG: player.png not found, using icon.svg fallback.")
	else:
		print("DEBUG: No textures found for player.")
	
	if texture:
		frames.add_animation("idle")
		frames.add_frame("idle", texture)
		frames.add_animation("move_horizontal")
		frames.add_frame("move_horizontal", texture)
		frames.add_animation("move_vertical")
		frames.add_frame("move_vertical", texture)
				
	sprite.sprite_frames = frames
	sprite.play("idle")
	
func _process(delta: float) -> void:
	if game_data.current_status == GAME_OVER:
		return
	
	super(delta)
	
	
func _physics_process(_delta: float) -> void:
	var direction := Input.get_vector("move_left", "move_right", "move_up", "move_down")
	
	if direction == Vector2.ZERO:
		direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	
	if direction:
		velocity = direction * DEFAULT_VELOCITY
		if direction.x != 0:
			sprite.play("move_horizontal")
			sprite.flip_h = direction.x < 0
		elif direction.y != 0:
			sprite.play("move_vertical")
	else:
		velocity = Vector2.ZERO
		sprite.play("idle")

	move_and_slide()
	

func take_damage(amount: float) -> void:
	game_data.health_percentage -= amount
	# Prevents health being negative
	game_data.health_percentage = clampf(game_data.health_percentage, 0, max_health)
	health_updated.emit(game_data.health_percentage, max_health)
	
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
