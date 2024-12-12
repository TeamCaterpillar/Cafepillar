class_name Customer
extends Character

@export var wait_time:float = 25.0
@export var order:String

@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D
# @onready var order_sprite: Sprite2D = $OrderSprite
@onready var dish_inventory: CompletedDishInventory = $"../../../CompletedDishInventory"
@onready var customer_queue: GridContainer = $"../../../CompletedDishInventory/ColorRect/GridContainer"
# @onready var button: Button = $Control/Button
@onready var texture_button: TextureButton = $TextureButton
@onready var label: Label = $TextureButton/Label

var _timer:Timer
var food_name : String
var customer_id: int = 1


func _ready(): 
	assign_id()
	label.text = "Customer " + str(customer_id)
	# texture_button.connect("pressed", Callable(self, "_on_DeliverButton_pressed"))
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
	
	dish_inventory.add_customer_to_queue(food_name, customer_id)
	GameManager.customers_waiting.append(self)


func _process(_delta):
	if _timer.is_stopped():
		remove_customer()


func _on_customer_clicked(order: String):
	print("Customer's order: ", order)


func _on_DeliverButton_pressed() -> void:
	print("Clicked button!")


func assign_id():
	# assign an id to customer
	customer_id = GameManager.customer_ids.pop_back()


func remove_customer():
	for person in GameManager.customers_waiting:
		if person == self:
			GameManager.customers_waiting.erase(self)
			queue_free() # customer death when theyre sick of waiting lmfao
			dish_inventory.remove_customer_from_queue(customer_id)
