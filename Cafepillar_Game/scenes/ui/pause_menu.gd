class_name PauseMenu
extends TextureRect

@export var restart_button : Button
@onready var back_button : Button = $BackButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	back_button.pressed.connect(_unpause)
	restart_button.pressed.connect(_restart)

func _unpause() -> void:
	GameSignals.pause_game.emit()

func _restart() -> void:
	AudioController.stop_music()
	get_tree().reload_current_scene()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
