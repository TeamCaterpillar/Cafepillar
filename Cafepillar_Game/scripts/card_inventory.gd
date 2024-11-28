class_name CardInventory
extends Node2D

const DISPLAY_COUNT:int = 5

@onready var card_scene = preload("res://scenes/card.tscn")

var card_display = []
var screen_center_x = get_viewport().size.x / 2
var card_width:float = card_scene.size.x
var inventory_y_pos = self.global_position.y

func _ready() -> void:
	for i in range(DISPLAY_COUNT):
		var card = card_scene.instantiate()
		$"../CardInventory".add_child(card)
		add_card_to_display(card)


func _process(delta: float) -> void:
	pass


func add_card_to_display(card:CardTemplate):
	card_display.push_front(card)
	update_display_positions()


func update_display_positions():
	for i in range(card_display.size()):
		var new_position = Vector2(calculate_card_position(i), inventory_y_pos)
		var card = card_display[i]
		animate_card_to_position(card, new_position)


func calculate_card_position(index:int) -> float:
	var display_width = (card_display.size() - 1) * card_width
	var x_offset = screen_center_x + (index * card_width) - (display_width / 2)
	return x_offset


func animate_card_to_position(card:CardTemplate, new_position:Vector2):
	var tween = get_tree().create_tween()
	tween.tween_property(card, "position", new_position, 0.1)
