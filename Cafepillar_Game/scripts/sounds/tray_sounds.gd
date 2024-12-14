class_name TraySounds
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameSignals.button_pressed.connect(_on_yes_button_pressed)

func _on_yes_button_pressed() -> void:
	$ButtonClick.play()
