extends Panel

@export var food_name: String
@export var food_condition: String
@onready var food_sprite: Sprite2D = $FoodIcon
@onready var food_label: Label = $FoodNameLabel
@onready var food_color: ColorRect = $FoodColor

func _ready() -> void:
	food_label.text = ""
	food_sprite.visible = false
	var food_icon_path = "res://assets/cards/" + str(food_name) + ".png"
	
	# omelette is spelled differently for (idk if I should change it or not)
	# for now, use check statement for omelette image
	if food_name == "omelette":
		food_icon_path =  "res://assets/cards/omelet.png"

	# gets the corresponding image of the food name
	if ResourceLoader.exists(food_icon_path):
		var food_icon = load(food_icon_path)
		food_sprite.visible = true
		food_sprite.texture = food_icon
	# if there is no image, just show the word name
	else:
		food_label.text = format_string(food_name)
		
	if food_condition == "Undercooked":
		food_color.color = Color("yellow")
	elif food_condition == "Satisfactory":
		food_color.color =Color("blue")
	elif food_condition == "Perfect":
		food_color.color = Color("green")
	elif food_condition == "Burnt":
		food_color.color = Color("red")


func _process(delta: float) -> void:
	pass


func format_string(input: String) -> String:
	var words = input.split("_")  # Split the string by underscores
	for i in range(words.size()):
		# Capitalize the first letter of each word and make the rest lowercase
		words[i] = words[i].capitalize()
	return " ".join(words)  # Join the words with spaces
