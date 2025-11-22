extends Sprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$GPUParticles2D.process_material.scale_min *= transform.get_scale().x
	$GPUParticles2D.process_material.scale_max *= transform.get_scale().x
