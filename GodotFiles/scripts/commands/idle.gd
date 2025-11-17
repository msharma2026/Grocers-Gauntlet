# idle.gd

class_name Idle
extends Command

func execute(_character: Character) -> Status:
	_character.velocity.x = 0
	if _character.sprite.animation != "idle":
		_character.sprite.play("idle")
	return Status.DONE
