class_name Customer
extends Character

@export var wait_time:float = 25.0
@export var order:String

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
# @onready var order_sprite: Sprite2D = $OrderSprite
@onready var dish_inventory: CompletedDishInventory = $"../../../CompletedDishInventory"
# @onready var button: Button = $Control/Button
@onready var texture_button: TextureButton = $TextureButton

var _timer:Timer
var food_name : String

func _ready(): 
	texture_button.connect("pressed", Callable(self, "_on_DeliverButton_pressed"))
	# GameSignals.customer_clicked.connect(_on_customer_clicked)
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)
	_timer.start(wait_time)
	# temporary position change so we can see them!!!
	position.x += randi_range(-50, 50)
	
	# get the food name from the order file
	food_name = order.replace(".tres", "")
	var food_icon_path = "res://assets/cards/" + str(food_name) + ".png"
	
	# omelette is spelled differently for (idk if I should change it or not)
	# for now, use check statement for omelette image
	# same for beef and leaf stew
	if food_name == "omelette":
		food_icon_path =  "res://assets/cards/omelet.png"
	elif food_name == "beef_leaf_stew":
		food_icon_path = "res://assets/cards/beefnleaf_stew.png"

	# gets the corresponding image of the food name
	if ResourceLoader.exists(food_icon_path):
		var food_icon = load(food_icon_path)
		texture_button.visible = true
		texture_button.texture_normal = food_icon


func _process(_delta):
	if _timer.is_stopped():
		queue_free() # customer death when theyre sick of waiting lmfao

#func _input(event):
#	# problem is that when you click on it, it affects all customers instead of individual ones
#	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
#		if collision_shape_2d.get_shape().get_size().has_point(to_local(event.position)):
#			GameSignals.emit_signal("customer_clicked", food_name)


func _on_customer_clicked(order: String):
	print("Customer's order: ", order)


func _on_DeliverButton_pressed() -> void:
	print("Clicked button!")
