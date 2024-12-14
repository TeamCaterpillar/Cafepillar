extends Control
class_name OrderQueue

@onready var queue_container = $VBoxContainer
@onready var recipes: Array = Recipes.recipes
# @onready var recipes: Array = $Recipes.recipes

# timer to randomly add food items every second
# remove later
#var _timer: float = 0.0

#var food_items = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	##_add_order("burger")
	#for recipe in recipes:
		#var title = recipe["title"].to_lower().replace(" ", "_")
		#food_items.append(title)
	#_add_order(food_items[0])
	GameSignals.connect("customer_added", _add_order)

#
#
#func _process(delta: float) -> void:
	## randomly add a food item every second for testing
	#_timer += delta
	#if _timer >= 1.0:
		#_add_order(food_items[randi() % food_items.size()])
		#_timer = 0.0


func _add_order(curr_order: Customer):
	# add food order to queue
	var order_card_scene = load("res://scenes/ui/order_card.tscn")
	var order_card = order_card_scene.instantiate()
	
	var order_name = curr_order.order
	order_name = order_name.replace(" ", "_")
	order_name = order_name.trim_suffix(".tres")
	
	order_card.food_name = order_name
	order_card._timer_duration = curr_order.wait_time
	
	queue_container.add_child(order_card) 


# removes closest food order in queue with matching name
func remove_order(food_name: String):
	for child in queue_container.get_children():
		if child.food_name == food_name:
			child.queue_free()
			break
