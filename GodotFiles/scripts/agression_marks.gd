extends Sprite2D
@export var anim_curve: Curve
var anim_time = 2
var current_time = 0
var base_scale : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	base_scale = scale


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_time += delta
	var quotient : float = anim_curve.sample(current_time/anim_time)
	scale = base_scale * quotient
	if current_time >= anim_time:
		current_time = 0
		await get_tree().create_timer(0.5).timeout
