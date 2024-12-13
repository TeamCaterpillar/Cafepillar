class_name DurativeDialogueCmd
extends DurativeAnimationCmd

var _script:String = ""
var _duration:float
var _color:Color
var _dialogue: DialogueBox

func _init(script: String, dialogue: DialogueBox, color: Color = Color.BLACK, duration: float = 0.1):
	_script = script
	_duration = duration
	_dialogue = dialogue
	_color = color
	
	
func execute() -> Command.Status:
	if _timer == null:
		_dialogue.label.text = _script
		_dialogue.label.add_theme_color_override("font_color", _color)
		_timer = Timer.new()
		_dialogue.add_child(_timer)
		_timer.one_shot = true
		_timer.start(_duration)
		return Status.ACTIVE
	
	if !_timer.is_stopped():
		return Status.ACTIVE
	else:
		return Status.DONE
