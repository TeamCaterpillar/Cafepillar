class_name MoreSounds
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameSignals.button_pressed.connect(_on_start_button_pressed)
	GameSignals.button_pressed.connect(_on_done_button_pressed)
	GameSignals.button_pressed.connect(_on_remove_button_pressed)

func _on_start_button_pressed() -> void:
	$ButtonClick.play()

func _on_done_button_pressed() -> void:
	$ButtonClick.play()


func _on_remove_button_pressed() -> void:
	$ButtonClick.play()
