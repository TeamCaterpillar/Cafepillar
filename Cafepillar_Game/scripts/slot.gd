extends TextureRect
class_name Slot

@export var deck : GCardHandLayout

# @onready var yes_button: TextureButton = $"../../Tray/YesButton"

var card_resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("child_entered_tree", _on_child_entered_tree)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	# uncomment this when we have a food card
	# only let yes button be visible if a food card is in slot
	#if name == "TraySlot":
		# check if food card is in slot
	#	if get_child_count() > 0:
	#		var food_card = get_child(0)
			# only allow player to send a food card and not smt else
	#		if food_card.is_in_group("Food"):
	#			yes_button.visible = true
	#		else:
	#			yes_button.visible = false
	#	else:
	#		yes_button.visible = false


func _on_child_entered_tree(node: Node) -> void:
	if node.is_in_group("Ingredient"):
		card_resource = node.card_resource
		print("Dropped " , card_resource.name, " into " , get_parent().name , " slot.")
	else:
		print("ERROR WHY IS ", node, " BEING ADDED!!")
		_move_card_back_to_deck(node)


func _move_card_back_to_deck(child : Node) -> void:
	remove_child(child)
	deck.add_child(child)
	 
