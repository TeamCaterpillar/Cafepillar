class_name Sounds
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameSignals.button_pressed.connect(_on_skip_day_pressed)
	GameSignals.button_pressed.connect(_on_next_day_pressed)

func _on_skip_day_pressed() -> void:
	$ButtonClick.play()


func _on_next_day_pressed() -> void:
	$ButtonClick.play()
