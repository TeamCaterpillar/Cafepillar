class_name DurativeIdleCmd
extends DurativeAnimationCmd

var _duration:float
var _direction:String

func _init(duration: float = 1.0, direction: String = "left"):
	_duration = duration
	_direction = direction
	
	
func execute(character: Character) -> Command.Status:
	if _direction == "right":
		character.sprite.flip_h = true
	else:
		character.sprite.flip_h = false
	return _manage_durative_animation_cmd(character, "idle", _duration)
