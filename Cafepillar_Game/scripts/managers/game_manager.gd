extends Node

# Game state variables
var current_day : int 					= 1
var amount_gained : int					= 0
var golden_seeds : int 					= 100
var kitchen_inventory: Array[Variant] 	= []
var active_orders: Array[Variant]     	= []
var waiter_queue: Array[Variant]      	= []
var finished_dishes: Array[Variant]   	= []
var customer_ids : Array 				= [10, 9, 8, 7, 6, 5, 4, 3, 2, 1]
var customers_waiting : Array[Variant] 	= []
var filled_seats : Array[Variant] 		= []

# Scene references
var current_scene  = null
const SCENE_KITCHEN: String = "res://scenes/world/kitchen.tscn"
const SCENE_DINER: String   = "res://scenes/world/diner.tscn"


# Called when the game starts
func _ready():
	filled_seats.fill(0)
	
	# initialize inventory to have starter ingredients
	initialize_inventory()
	
	# connect signals
	GameSignals.next_day_started.connect(_on_next_day_started)
	GameSignals.food_delivered.connect(update_currency)


func _on_next_day_started() -> void:
	current_day += 1
	print("moving onto day " + str(current_day))


# Function to change scenes
func change_scene(scene_path: String):
	if current_scene:
		current_scene.queue_free()
	
	var new_scene = load(scene_path).instantiate()
	get_tree().root.add_child(new_scene)
	current_scene = new_scene
	emit_signal("scene_changed", scene_path)


# Track golden seeds
func update_score(new_seeds: int):
	golden_seeds += new_seeds
	print("Total Golden Seeds updated:", golden_seeds)


# MANAGE ORDER QUEUE
func add_order_to_queue() -> void:
	pass


func remove_order_from_queue() -> void:
	pass


# HANDLE CURRENCY

func update_currency(dish_card: DishCard):
	#var _food_name = dish_card.food_name
	var food_condition: String = dish_card.food_condition
	var base_payment: int      = 10
	var base_multiplier: float = 1.0
	if food_condition == "Underdone":
		base_multiplier = 0.5
	elif food_condition == "Overdone":
		base_multiplier = 0.5
	elif food_condition == "Satisfactory":
		base_multiplier = 1.0
	elif food_condition == "Perfect":
		base_multiplier = 2.0
	
	@warning_ignore("narrowing_conversion")
	add_currency(base_payment * base_multiplier)

func add_currency(_amount: int) -> void:
	amount_gained = _amount
	golden_seeds += _amount


func remove_currency(_amount: int) -> void:
	golden_seeds -= _amount


# Manage kitchen ingrediants storage
func add_to_storage(item: String): # ADD CARD OBJECT USING FACTORY TO INVENTORY
	kitchen_inventory.append(item)
	print("Added to inventory:"  + item)


func remove_from_storage(item: String):
	if item in kitchen_inventory:
		kitchen_inventory.erase(item)
		print("Removed from inventory:", item)


# Handle waiter actions
func assign_order_to_waiter(order):
	if waiter_queue:
		var waiter = waiter_queue.pop_front()
		waiter.take_order(order)
		print("Order assigned to waiter:", order)
	else:
		print("No waiters available!")


func add_waiter_to_queue(waiter):
	waiter_queue.append(waiter)
	print("Waiter added to queue:", waiter)


# Timer utilities for gameplay
func start_cooking_timer(duration: float, callback: Callable):
	var timer = Timer.new()
	timer.wait_time = duration
	timer.one_shot = true
	timer.connect("timeout", callback)
	add_child(timer)
	timer.start()


# inventory management methods
func initialize_inventory() -> void:
	add_to_storage("nut")
	add_to_storage("egg")
	add_to_storage("tea_leave")
	add_to_storage("lettuce")
	add_to_storage("coffee_bean")
	add_to_storage("cheese")
	

######### SEAT MANAGEMENT #########
func get_empty_seat() -> Marker2D:
	var empty_seat = filled_seats[-1]
	if empty_seat:
		filled_seats[empty_seat] = 1
		return empty_seat
	else:
		print("No empty seats available!")
		return null
