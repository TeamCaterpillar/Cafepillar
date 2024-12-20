class_name PauseMenu
extends TextureRect

@onready var back_button : Button = $BackButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back_button.pressed.connect(_unpause)

func _unpause() -> void:
	GameSignals.pause_game.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
