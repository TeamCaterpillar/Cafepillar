class_name Player
extends Character

var can_move : bool = false
var moving : bool = false
var tile
var selected_tile
var movement_progress : float = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super()
	position = Vector2(206, 9)

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("click") and can_move and !moving:
		var move_command = MoveCommand.new()
		var status:Command.Status = move_command.execute(self)
		if status == Command.Status.ACTIVE:
			moving = true
		if status == Command.Status.DONE:
			moving = false
			
