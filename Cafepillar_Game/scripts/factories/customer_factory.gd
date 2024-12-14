class_name CustomerFactory
extends Node

var customer_path := "res://scenes/characters/customer.tscn"
var dish_path := "res://data/cards/dishes/"





func create_customer(customer: CustomerBasicSpec) -> Customer:
	var new_customer = load(str(customer_path)).instantiate() as Customer
	
	new_customer.order = customer.current_order
	new_customer.wait_time = customer.order_timer
	return new_customer


func generate_rand_customer() -> Customer:
	var dishes : Array[String]= [
	"beef_leaf_stew",
	"burger",
	"coffee",
	"fruity_salad",
	"honey_roasted_coffee",
	"nutty_salad",
	"omelette",
	"peanut_pastry",
	"rose_cake",
	"rose_tea",
	"strawberry_milkshake",
	"strawberry_tea",
	"sunny_side_up",
	"tea"
	]
	# open up the list of dishes
	#var dish_files:Array = DirAccess.get_files_at(dish_path)
	#var random_gen = RandomNumberGenerator.new()
	#var random_int = randi_range(0, len(dishes)-1)
	var random_dish : String = dishes.pick_random() # name of dish!!!
	var dish_obj = "res://data/cards/dishes/%s" % random_dish + ".tres"
	#var dish_obj = load(dish_path + random_dish) # load it up
	var loaded_dish = load(dish_obj)
	var dish_wait = loaded_dish.cook_time + 60.0 # grab the dish's wait time
	
	# create and return
	var new_customer = create_customer(CustomerBasicSpec.new(random_dish, dish_wait))
	return new_customer
