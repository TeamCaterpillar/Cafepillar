class_name RecipeBookSounds
extends Node


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameSignals.button_pressed.connect(_on_previous_button_pressed)
	GameSignals.button_pressed.connect(_on_next_button_pressed)


func _on_previous_button_pressed() -> void:
	$ButtonClick.play()


func _on_next_button_pressed() -> void:
	$ButtonClick.play()
