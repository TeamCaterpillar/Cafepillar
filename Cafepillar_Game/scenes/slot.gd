extends TextureRect
class_name Slot

var card_resource

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("child_entered_tree", _on_child_entered_tree)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	

func _on_child_entered_tree() -> void:
	card_resource = get_children()[0].card_resource
	print(card_resource.name)
