extends Node

# Load and parse the JSON
func _ready():
	var json_path = "res://data/data.json"
	var json_file = FileAccess.open(json_path, FileAccess.READ)
	if json_file:
		var json_data = JSON.parse_string(json_file.get_as_text())
		create_resources(json_data)
	else:
		print("Error opening JSON file:", json_path)

# Create resources from JSON
func create_resources(data: Dictionary):
	# Process categories
	for category_name in data["categories"]:
		var category_data = data["categories"][category_name]
		var category_res = Category.new()
		category_res.description = category_data["description"]
		category_res.default_cook_time = category_data["default_cook_time"]
		category_res.default_quality_thresholds = category_data["default_quality_thresholds"]
		category_res.sprite_path = category_data["sprite_path"]
		save_resource(category_res, "res://data/cards/categories/%s.tres" % category_name)

	# Process dishes
	for dish_name in data["dishes"]:
		var dish_data = data["dishes"][dish_name]
		var dish_res = Dish.new()
		dish_res.category = dish_data["category"]
		dish_res.appliances = dish_data["appliance"]
		dish_res.cook_time = dish_data["cook_time"]
		dish_res.quality_thresholds = dish_data["quality_thresholds"]
		dish_res.sprite_path = dish_data["sprite_path"]
		dish_res.ingredients = dish_data["ingredients"]
		dish_res.cookware = dish_data["cookware"]
		save_resource(dish_res, "res://data/cards/dishes/%s.tres" % dish_name)

	# Process ingredients
	for ingredient_name in data["ingredients"]["day_one_default"]:
		var ingredient_res = Ingredient.new()
		ingredient_res.name = ingredient_name
		ingredient_res.availability = "day_1"
		save_resource(ingredient_res, "res://data/cards/ingredients/%s.tres" % ingredient_name)

	for ingredient_name in data["ingredients"]["day_two_unlockable"]:
		var ingredient_res = Ingredient.new()
		ingredient_res.name = ingredient_name
		ingredient_res.availability = "day_2"
		save_resource(ingredient_res, "res://data/cards/ingredients/%s.tres" % ingredient_name)

	for ingredient_name in data["ingredients"]["day_three_unlockable"]:
		var ingredient_res = Ingredient.new()
		ingredient_res.name = ingredient_name
		ingredient_res.availability = "day_3"
		save_resource(ingredient_res, "res://data/cards/ingredients/%s.tres" % ingredient_name)

# Save resources to files
func save_resource(resource: Resource, path: String):
	ResourceSaver.save(resource, path)
