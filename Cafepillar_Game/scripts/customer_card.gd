extends Button
class_name CustomerCard

@export var food_name: String
@export var customer_id : int
@onready var food_sprite: Sprite2D = $FoodIcon
@onready var customer_label: Label = $CustomerLabel
@onready var food_color: ColorRect = $FoodColor
@onready var completed_dish_inventory: CompletedDishInventory = $"../../../"

func _ready() -> void:
	self.connect("pressed", Callable(self, "_on_Dish_pressed"))
	customer_label.text = ""
	food_sprite.visible = false
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
		food_sprite.visible = true
		food_sprite.texture = food_icon
		customer_label.text = "Customer " + str(customer_id)


func _process(_delta: float) -> void:
	pass


func format_string(input: String) -> String:
	var words = input.split("_")  # Split the string by underscores
	for i in range(words.size()):
		# Capitalize the first letter of each word and make the rest lowercase
		words[i] = words[i].capitalize()
	return " ".join(words)  # Join the words with spaces


func _on_Dish_pressed() -> void:
	# completed_dish_inventory.close_inventory()
	# delivering_food.emit()
	# completed_dish_inventory.selected_customer = self
	GameSignals.customer_selected.emit(self)
	print("clicked on customer ", str(customer_id), " who ordered ", food_name)
	
	# Logic:
	# click card to deliver
	# idk: maybe send another signal that allows player to click on customer?
	# click customer
	# sends a signal only if customer.current_order == dish_card.food_name
	# drop currency based on dish_card.food_condition
	# remove item from the inventory array in Game Manager and queue_free() it from grid container
	# reset selected food in completed_dish_inventory to null
