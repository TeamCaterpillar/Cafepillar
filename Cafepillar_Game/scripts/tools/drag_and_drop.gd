extends Node

# Signals for drag-and-drop events
signal card_dragging_started(card: Control, index: int)
signal card_dragging_finished(card: Control, index: int)

# Internal state for drag-and-drop
var _dragging_card: Control = null
var _dragging_index: int = -1
var _dragging_mouse_position: Vector2 = Vector2()

# Starts dragging a card
func start_drag(card: Control, index: int, mouse_position: Vector2):
	_dragging_card = card
	_dragging_index = index
	_dragging_mouse_position = mouse_position
	_dragging_card.z_index = 1  # Bring card to the front
	emit_signal("card_dragging_started", card, index)

# Stops dragging a card
func stop_drag(global_mouse_position: Vector2, slots_group: String):
	if not _dragging_card:
		return

	var slot_under_mouse = _get_slot_under_point(global_mouse_position, slots_group)
	if slot_under_mouse:
		_place_card_in_slot(_dragging_card, slot_under_mouse)
	else:
		print("No valid slot under mouse. Reset card.")

	_dragging_card.z_index = 0
	emit_signal("card_dragging_finished", _dragging_card, _dragging_index)
	_dragging_card = null
	_dragging_index = -1


# Processes dragging of a card
func process_drag(global_mouse_position: Vector2):
	if _dragging_card:
		_dragging_card.global_position = global_mouse_position - _dragging_mouse_position


# Finds a slot under the given global position
func _get_slot_under_point(global_pos: Vector2, slots_group: String) -> Control:
	var slots = get_tree().get_nodes_in_group(slots_group)
	for slot in slots:
		if slot.is_inside_tree() and Rect2(slot.global_position, slot.size).has_point(global_pos):
			return slot
	return null

# Places a card into a slot
func _place_card_in_slot(card: Control, slot: Control):
	if card.get_parent():
		card.get_parent().remove_child(card)
	slot.add_child(card)
	card.global_position = slot.global_position
