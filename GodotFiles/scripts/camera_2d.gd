extends Camera2D

var anchor_pos: Vector2

var shaking: bool = false 
var shake_time: float
var noise: FastNoiseLite
var shake_intensity: float
var total_time: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anchor_pos = position 
	noise = FastNoiseLite.new()
	noise.noise_type = FastNoiseLite.TYPE_SIMPLEX
	noise.frequency = 8
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if shaking:
		total_time += delta
		position = anchor_pos + Vector2(noise.get_noise_1d(total_time),noise.get_noise_1d(total_time * 2)) * shake_intensity
		shake_time -= delta
		if(shake_time <= 0.0):
			shaking = false
			position = anchor_pos

	
	
	
func shake(time: float, intensity: float) -> void:
	shaking = true
	shake_time = time
	shake_intensity = intensity
	
	
	
	
	
	
	
