extends Control
class_name CompletedDishInventory

@onready var grid_container: GridContainer = $GridContainer
@onready var list_button: TextureButton = $ListButton
@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $Label
@onready var label_2: Label = $Label2
@onready var customer_queue: GridContainer = $ColorRect/GridContainer
@onready var yes_button: TextureButton = $YesButton

var dish_card_size : Vector2 = Vector2(160.0, 200.0)

var selected_food_to_deliver : DishCard = null
var selected_customer : CustomerCard = null

func _ready() -> void:
	list_button.connect("pressed", Callable(self, "_on_ListButton_pressed"))
	yes_button.connect("pressed", Callable(self, "_on_YesButton_pressed"))
	color_rect.visible = false
	grid_container.visible = false
	label.visible = false
	yes_button.visible = false
	GameSignals.dish_selected.connect(set_dish)
	GameSignals.customer_selected.connect(set_customer)

func _process(_delta: float) -> void:
	pass


func _on_YesButton_pressed() -> void:
	if selected_food_to_deliver != null and selected_customer != null:
		# successfully delivered order to customer
		print("attempting to deliver ", selected_food_to_deliver.food_name, " to customer ", selected_customer.customer_id, " who ordered ", selected_customer.food_name)
		if selected_food_to_deliver.food_name == selected_customer.food_name:
			var satisfied_customer = get_customer_by_id(selected_customer.customer_id) 
			satisfied_customer.remove_customer()
			remove_customer_from_queue(selected_customer.customer_id)
			print("Successfully gave ", selected_food_to_deliver.food_condition, " ", selected_food_to_deliver.food_name, " to Customer ", selected_customer.customer_id)
			remove_dish_from_inventory(selected_food_to_deliver)
			
			# Success! Send a signal or smt.
			# Distribute money here

func get_customer_by_id(id: int) -> Customer:
	for customer in GameManager.customers_waiting:
		if customer.customer_id == id:
			return customer
	return null


func _on_ListButton_pressed() -> void:
	# display inventory
	if color_rect.visible == false:
		color_rect.visible = true
		grid_container.visible = true
		label.visible = true
		yes_button.visible = true
	else:
		close_inventory()

	# show foods in the inventory
	for food in GameManager.finished_dishes:
		if _contains_food(food) == false:
			grid_container.add_child(food)
			food.size = dish_card_size

	# display message that no foods are in the inventory
	if GameManager.finished_dishes.size() == 0 and color_rect.visible == true:
		label_2.visible = true
	else:
		label_2.visible = false


# function to check if food is already in the grid container
func _contains_food(food: Variant) -> bool:
	for child in grid_container.get_children():
		if food == child:
			return true
	return false


func close_inventory() -> void:
	color_rect.visible = false
	grid_container.visible = false
	label.visible = false
	label_2.visible = false
	yes_button.visible = false


func return_id(id: int):
	if id not in GameManager.customer_ids:
		GameManager.customer_ids.append(id)


func add_customer_to_queue(food_name: String, customer_id: int):
	# add food order to queue
	var customer_card_scene = load("res://scenes/ui/customer_card.tscn")
	var customer_card = customer_card_scene.instantiate()
	customer_card.food_name = food_name
	customer_card.customer_id = customer_id
	customer_queue.add_child(customer_card)


func remove_customer_from_queue(id: int):
	# removes customer card
	for child in customer_queue.get_children():
		if child.customer_id == id:
			return_id(id)
			child.queue_free()
	# selected_food_to_deliver = null
	# selected_customer = null


func set_dish(dish_item: DishCard):
	selected_food_to_deliver = dish_item
	print("setting ", dish_item)
	

func set_customer(customer_item: CustomerCard):
	selected_customer = customer_item
	print("setting ", customer_item)


func remove_dish_from_inventory(food_to_remove: DishCard):
	for dish in GameManager.finished_dishes:
		if dish == food_to_remove:
			GameManager.finished_dishes.erase(dish)
			dish.queue_free()
