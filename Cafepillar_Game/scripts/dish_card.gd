class_name DishCard
extends Button


@export var food_name: String
@export var food_condition: String
@onready var food_sprite: Sprite2D = $FoodIcon
@onready var food_label: Label = $FoodNameLabel
@onready var food_color: ColorRect = $FoodColor
@onready var completed_dish_inventory: CompletedDishInventory = $"../../"

var selected = false

func _ready() -> void:
	self.connect("pressed", Callable(self, "_on_Dish_pressed"))
	food_label.text = ""
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
	# if there is no image, just show the word name
	else:
		food_label.text = format_string(food_name)
		
	if food_condition == "Underdone":
		food_color.color = Color("yellow")
	elif food_condition == "Satisfactory":
		food_color.color =Color("blue")
	elif food_condition == "Perfect":
		food_color.color = Color("green")
	elif food_condition == "Overdone":
		food_color.color = Color("red")


func _process(_delta: float) -> void:
	var style = StyleBoxFlat.new()
	if selected:
		style.bg_color = Color(0.25, 0.25, 0.25)
		self.add_theme_stylebox_override("normal", style) 
	else:
		style.bg_color = Color(0.831, 0.878, 0.792, 1)
		self.add_theme_stylebox_override("normal", style)


func format_string(input: String) -> String:
	var words = input.split("_")  # Split the string by underscores
	for i in range(words.size()):
		# Capitalize the first letter of each word and make the rest lowercase
		words[i] = words[i].capitalize()
	return " ".join(words)  # Join the words with spaces


func _on_Dish_pressed() -> void:
	# completed_dish_inventory.close_inventory()
	# delivering_food.emit()
	# completed_dish_inventory.selected_food_to_deliver = self
	GameSignals.dish_selected.emit(self)
	print("clicked on ", food_name, " ", food_condition)
	
	# Logic:
	# click card to deliver
	# idk: maybe send another signal that allows player to click on customer?
	# click customer
	# sends a signal only if customer.current_order == dish_card.food_name
	# drop currency based on dish_card.food_condition
	# remove item from the inventory array in Game Manager and queue_free() it from grid container
	# reset selected food in completed_dish_inventory to null
