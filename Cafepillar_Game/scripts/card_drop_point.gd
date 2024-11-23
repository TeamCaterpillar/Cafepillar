class_name CardDropPoint
extends Marker2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _draw() -> void:
	draw_circle(Vector2.ZERO, 25.0, Color.WHITE)


func select() -> void:
	for child in get_tree().get_nodes_in_group("CardZone"):
		child.deselect()
	modulate = Color.RED


func deselect() -> void:
	modulate = Color.WHITE
