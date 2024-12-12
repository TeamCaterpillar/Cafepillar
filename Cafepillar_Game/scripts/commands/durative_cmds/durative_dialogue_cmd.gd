class_name DurativeDialogueCmd
extends DurativeAnimationCmd

var _script:String = ""
var _duration:float
@onready var dialogue: TextureRect = $Dialogue
@onready var label: Label = $Dialogue/Label

func _init(script: String, duration: float = 1.0):
	_script = script
	_duration = duration
	
	
func execute(character: Character) -> Command.Status:
	if _timer == null:
		label.text = _script
		dialogue.visible = true
		_timer = Timer.new()
		character.add_child(_timer)
		_timer.one_shot = true
		_timer.start(_duration)
		return Status.ACTIVE
	
	if !_timer.is_stopped():
		return Status.ACTIVE
	else:
		return Status.DONE
