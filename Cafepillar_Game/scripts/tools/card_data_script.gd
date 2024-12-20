extends TextureRect
class_name CardInstance

var shader_perfect : ShaderMaterial = preload("res://themes/perfect_glow.tres")
var card_resource : Resource
var food_name : String
var food_condition : String

func _ready() -> void:
	z_index = 5
	if food_condition == "Perfect":
		var backing : TextureRect = TextureRect.new()
		backing = duplicate() as TextureRect
		backing.size = Vector2(200, 215)
		backing.scale = Vector2(0.8, 1)
		backing.position = Vector2(-16, -8)
		backing.pivot_offset = Vector2(80, 0)
		backing.z_index = -1
		backing.add_to_group("Dish", false)
		#(0.08, 0.1)
		backing.material = shader_perfect
		add_child(backing)
		#backing.position = Vector2(0, 0)
		
