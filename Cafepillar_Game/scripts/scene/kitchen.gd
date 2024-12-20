extends Control

@export var cafe_button : Button

func _ready():
	visible = true
	cafe_button.pressed.connect(_cafe_button_pressed)

func _cafe_button_pressed() -> void:
	GameSignals.change_to_kitchen.emit()
