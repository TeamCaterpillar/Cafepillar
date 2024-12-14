class_name CustomerFactory
extends Node

var customer_path := "res://scenes/characters/customer.tscn"
var dish_path := "res://data/cards/dishes/"
var dish_files:Array = ["beef_leaf_stew.tres", "burger.tres", "coffee.tres", "fruity_salad.tres", "honey_roasted_coffee.tres", "nutty_salad.tres", "omelette.tres", "peanut_pastry.tres", "rose_cake.tres", "rose_tea.tres", "strawberry_milkshake.tres", "strawberry_tea.tres", "sunny_side_up.tres", "tea.tres"]

func create_customer(customer: CustomerBasicSpec) -> Customer:
	var new_customer = load(str(customer_path)).instantiate() as Customer
	new_customer.order = customer.current_order
	new_customer.wait_time = customer.order_timer
	return new_customer


func generate_rand_customer() -> Customer:
	# open up the list of dishes
	# var dish_files:Array = DirAccess.get_files_at(dish_path)
	# print(dish_files)
	var random_dish = dish_files.pick_random() # name of dish!!!
	var dish_obj = load(dish_path + random_dish) # load it up
	print(dish_obj)
	var dish_wait = dish_obj.cook_time + 60.0 # grab the dish's wait time
	
	# create and return
	var new_customer = create_customer(CustomerBasicSpec.new(random_dish, dish_wait))
	return new_customer
