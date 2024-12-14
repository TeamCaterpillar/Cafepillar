class_name KitchenDoor
extends Area2D

@onready var indicator = $KitchenDoorIndicator

func _ready() -> void:
	indicator.visible = false
