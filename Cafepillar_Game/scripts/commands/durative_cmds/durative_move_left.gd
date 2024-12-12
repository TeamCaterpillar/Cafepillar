class_name DurativeMoveLeft
extends DurativeAnimationCmd

var _duration:float

func _init(duration: float = 1.0):
	_duration = duration
	
	
func execute(character: Character) -> Status:
	character.velocity.x = -1 * character.movement_speed
	var status:Command.Status = _manage_durative_animation_cmd(character, "walk", _duration)
	if status == Status.DONE:
		character.velocity.x = 0
	return status
