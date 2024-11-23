class_name CardDropPoint
extends Marker2D

var slot_dimensions:Vector2 = Vector2(25.0, 35.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _draw() -> void:
	#draw_circle(Vector2.ZERO, 25.0, Color.WHITE)
	draw_rect(Rect2(-slot_dimensions / 2, slot_dimensions),Color.WHITE)


func select() -> void:
	for child in get_tree().get_nodes_in_group("CardZone"):
		child.deselect()
	#modulate = Color.RED
	modulate = Color8(211, 131, 114, 170)


func deselect() -> void:
	#modulate = Color.WHITE
	modulate =  Color8(211, 131, 114, 255)
