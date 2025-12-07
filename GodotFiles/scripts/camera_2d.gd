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

	
	
	
func shake(time: float = 0.15, intensity: float = 10) -> void:
	shaking = true
	shake_time = time
	shake_intensity = intensity
	
	
	
func start_camera_pan() -> void:
	$AnimationPlayer.play("pan_animation")
	await $AnimationPlayer.animation_finished
	

func ease_to_new_location(new_pos:Vector2,new_zoom:Vector2) -> void:
	var new_tween : Tween = get_tree().create_tween()
	var tween_two : Tween = get_tree().create_tween()
	new_tween.tween_property(systems.camera,'zoom',new_zoom,1)
	tween_two.tween_property(systems.camera,'position',new_pos,1)
	systems.camera.anchor_pos = new_pos
	await new_tween.finished
	await tween_two.finished

func set_new_location(new_pos:Vector2,new_zoom:Vector2) -> void:
		systems.camera.position = new_pos
		systems.camera.zoom = new_zoom	
		systems.camera.anchor_pos = new_pos
	
