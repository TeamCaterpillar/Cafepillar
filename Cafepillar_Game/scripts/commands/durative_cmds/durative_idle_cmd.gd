class_name DurativeIdleCmd
extends DurativeAnimationCmd

var _duration:float
var _direction:String
var _character: NPC

func _init(character: NPC, duration: float = 0.1, direction: String = "left"):
	_duration = duration
	_direction = direction
	_character = character
	
	
func execute() -> Command.Status:
	if _direction == "right":
		_character.char_sprite.flip_h = false
	else:
		_character.char_sprite.flip_h = true
	return _manage_durative_animation_cmd(_character, "idle", _duration)
