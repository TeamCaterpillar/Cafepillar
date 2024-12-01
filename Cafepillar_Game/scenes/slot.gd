extends TextureRect
class_name Slot

@export var deck : GCardHandLayout

var card_resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("child_entered_tree", _on_child_entered_tree)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

func _on_child_entered_tree(node: Node) -> void:
	if node.is_in_group("Ingredient"):
		card_resource = node.card_resource
		print(card_resource.name)
	else:
		print("ERROR WHY IS ", node, " BEING ADDED!!")
		_move_card_back_to_deck(node)
		
func _move_card_back_to_deck(child : Node) -> void:
	remove_child(child)
	deck.add_child(child)
	 
