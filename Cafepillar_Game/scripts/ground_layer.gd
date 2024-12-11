class_name GroundLayer
extends TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func external_map_to_local(coor : Vector2i) -> Vector2:
	return map_to_local(coor)

func change_color(id : Vector2i) -> void:
	var data = get_cell_tile_data(id)
	data.modulate = Vector4(0, 0, 0, 0.5) 
