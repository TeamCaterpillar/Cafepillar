extends TextureRect
class_name Slot

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if mouse_entered and card_is_dropped:
	pass
		

func _can_drop_data(at_position: Vector2, data: Variant) -> bool:
	return data.has("card_resource")

func _drop_data(at_position: Vector2, data: Variant) -> void:
	# access cards resource
	var card_resource = data["card_resource"]
	# process card
	process_card(card_resource)
	# attach
	var card_node = data["card_node"]
	if card_node:
		if card_node.get_parent():
			card_node.get_parent().remove_child(card_node)
		add_child(card_node)
		card_node.position = Vector2.ZERO
		
		if card_node.original_parent and card_node.original_parent.has_method("_on_card_dragging_finished"):
			card_node.original_parent._on_card_dragging_finished(card_node)
			card_node.original_parent = null
	
	
		
func process_card(card_resource : Resource) -> void:
	print("Card resource received:", card_resource)
