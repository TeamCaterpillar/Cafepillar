extends TextureRect
class_name Slot

@export var deck : GCardHandLayout

@onready var recipes: Array = $"../../RecipesBook".recipes
# @onready var yes_button: TextureButton = $"../../Tray/YesButton"

var card_resources: Array = []
var dishes: Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("child_entered_tree", _on_child_entered_tree)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	# uncomment this when we have a food card
	# only let yes button be visible if a food card is in slot
	# if name == "TraySlot":
		# check if food card is in slot
	#	if get_child_count() > 0:
	#		var food_card = get_child(0)
			# only allow player to send a food card and not smt else
	#		if food_card.is_in_group("Food"):
	#			yes_button.visible = true
	#		else:
	#			yes_button.visible = false
	#	else:
	#		yes_button.visible = false


func _on_child_entered_tree(node: Node) -> void:
	# shrink card size when dropped to fit slot
	if node.is_in_group("Ingredient"):
		card_resources.append(node.card_resource.name)
		print("Dropped " , card_resources.back(), " into " , get_parent().name , " slot.")
	
	if node.is_in_group("Dish"):
		print("Dish added")


func check_recipe() -> String:
	var cookware = get_parent().name.to_lower()  # Get the cookware the slot is on
	for recipe in recipes:
		# Ensure the recipe's cookware matches the current cookware
		if recipe["use"].to_lower() == cookware:
			var normalized_recipe_ingredients = normalize_ingredients(recipe["ingredients"])
			var normalized_stove_ingredients = normalize_ingredients(card_resources)

			# Match ingredients
			if ingredients_match(normalized_recipe_ingredients, normalized_stove_ingredients):
				print("Matched Recipe: ", recipe["title"])
				return recipe["title"]
	print("No matching recipe found.")
	return "Null"

# ************************************ 
# Updated Parser for Normalizing Recipes with Cookware Check
#
func normalize_ingredient(ingredient: String) -> Array:
	var parts = ingredient.split(" x")
	var ingredient_name = parts[0].to_lower().replace(" ", "_")
	
	# Remove trailing 's' to singularize
	if ingredient_name.ends_with("s") and !ingredient_name.ends_with(" x2"):  
		ingredient_name = ingredient_name.substr(0, ingredient_name.length() - 1)
	
	# Handle quantities
	var quantity = int(parts[1]) if parts.size() > 1 else 1
	
	# Create an array with the ingredient repeated `quantity` times
	var result = []
	for i in range(quantity):
		result.append(ingredient_name)
	
	return result

func normalize_ingredients(ingredients: Array) -> Array:
	var normalized_list = []
	for ingredient in ingredients:
		normalized_list += normalize_ingredient(ingredient)
	return normalized_list

func ingredients_match(recipe_ingredients: Array, stove_ingredients: Array) -> bool:
	var normalized_recipe = normalize_ingredients(recipe_ingredients)
	var normalized_stove = normalize_ingredients(stove_ingredients)
	normalized_recipe.sort()
	normalized_stove.sort()
	return normalized_recipe == normalized_stove
#
# END OF PARSER
# ************************************ 
