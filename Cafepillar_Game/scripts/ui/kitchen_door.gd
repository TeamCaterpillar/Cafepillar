class_name KitchenDoor
extends Area2D

@onready var indicator = $KitchenDoorIndicator

func _ready() -> void:
	indicator.visible = false


func _on_mouse_entered() -> void:
	indicator.visible = true


func _on_mouse_exited() -> void:
	indicator.visible = false
