extends Node

var deck:Node
var drag_drop_manager:Node

func _ready():
	deck = $Deck
	drag_drop_manager = $DragDropManager

	# Connect card dragging finished signal to reset the deck’s layout after dropping a card
	drag_drop_manager.connect("card_dragging_finished", Callable(self, "_on_card_dropped"))

	# Connect each card’s gui_input signal to drag_drop_manager
	for i in range(deck.get_child_count()):
		var card = deck.get_child(i)
		if card is Control:
			if not card.gui_input.is_connected(drag_drop_manager._on_card_gui_input):
				card.gui_input.connect(drag_drop_manager._on_card_gui_input.bind(card))

func _on_card_dropped(card:Control, index:int):
	# After a card is dropped, we can tell the deck to reset positions
	if deck.has_method("_reset_positions_if_in_tree"):
		deck._reset_positions_if_in_tree()
