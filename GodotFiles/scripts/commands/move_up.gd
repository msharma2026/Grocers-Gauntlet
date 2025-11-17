# move_up.gd

class_name MoveUp
extends Command

func execute(_character: Character) -> Status:
	var speed := _character.DEFAULT_VELOCITY * -1
	_character.velocity.y = speed
	
	# Sprite flip logic
	_character.sprite.flip_h = true
	if _character.sprite.animation != "move_vertical":
		_character.sprite.play("move_vertical")
		
	_character.change_facing(_character.Facing.IS_FACING_UP)
	
	return Status.DONE
