extends Control

# Signals for card interactions
signal card_hovered(card: Node)
signal card_selected(card: Node)
signal card_deselected(card: Node)
signal card_dragged(card: Node)

# Card properties
@export var card_name: String = "Default Card"
@export var card_value: int = 0
@export var card_type: String = "Generic"

# Internal state
var _is_selected: bool = false

# Called when the card is hovered
func hover_card():
	emit_signal("card_hovered", self)

# Called when the card is clicked/selected
func select_card():
	if not _is_selected:
		_is_selected = true
		emit_signal("card_selected", self)

# Called to deselect the card
func deselect_card():
	if _is_selected:
		_is_selected = false
		emit_signal("card_deselected", self)

# Toggles the card's selection state
func toggle_selection():
	if _is_selected:
		deselect_card()
	else:
		select_card()

# Called when the card is dragged
func drag_card():
	emit_signal("card_dragged", self)

# Provides card data as a dictionary
func get_card_data() -> Dictionary:
	return {
		"name": card_name,
		"value": card_value,
		"type": card_type
	}
