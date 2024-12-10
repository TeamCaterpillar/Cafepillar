class_name Player
extends Character

var moving : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:

	if Input.is_action_just_pressed("left_click") and true:#.scene_ref == Diner:
		var move_command = MoveCommand.new()
		var status:Command.Status = move_command.execute(self)
		if status == Command.Status.ACTIVE:
			moving = true
		if status == Command.Status.DONE:
			moving = false
