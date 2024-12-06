extends Node

signal card_dragging_started(card:Control, index:int)
signal card_dragging_finished(card:Control, index:int)

var _dragging_card:Control = null
var _dragging_index:int = -100
var _dragging_mouse_position:Vector2

func _ready():
	# This script expects card_manager.gd to connect card gui_input signals here.
	pass

func _on_card_gui_input(card:Control, event:InputEvent):
	# This method is connected by card_manager.gd passing 'card' as an argument.
	if event is InputEventMouseButton:
		var mouse_event = event as InputEventMouseButton
		var deck = card.get_parent()  # deck is parent of the card

		if mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT:
			_start_drag(card, deck)
		elif !mouse_event.pressed and mouse_event.button_index == MOUSE_BUTTON_LEFT and _dragging_card == card:
			_end_drag()

func _process(delta):
	if _dragging_card:
		# Follow mouse
		_dragging_card.global_position = get_viewport().get_mouse_position() - _dragging_mouse_position

func _start_drag(card:Control, deck:Node):
	_dragging_card = card
	_dragging_index = deck.get_children().find(card)
	_dragging_mouse_position = card.get_local_mouse_position()
	card.z_index = 1
	emit_signal("card_dragging_started", _dragging_card, _dragging_index)

func _end_drag():
	if !_dragging_card:
		return
	var global_pos = get_viewport().get_mouse_position()
	var slot_under_mouse = _get_slot_under_point(global_pos)
	if slot_under_mouse:
		_place_card_in_slot(_dragging_card, slot_under_mouse)
	_dragging_card.z_index = 0
	emit_signal("card_dragging_finished", _dragging_card, _dragging_index)
	_dragging_card = null
	_dragging_index = -100

func _get_slot_under_point(global_pos:Vector2) -> Control:
	var slots = get_tree().get_nodes_in_group("CardSlot")
	for slot in slots:
		if slot.is_inside_tree():
			if Rect2(slot.global_position, slot.size).has_point(global_pos):
				return slot
	return null

func _place_card_in_slot(card:Control, slot:Control):
	if card.get_parent():
		card.get_parent().remove_child(card)
	slot.add_child(card)
	if slot.get_child_count() == 1:
		card.global_position = slot.global_position
	else:
		var random_offset = Vector2(
			randi_range(-15, 15),
			(slot.get_child_count() - 1) * 20 + randi_range(-10, 10)
		)
		card.position = random_offset
