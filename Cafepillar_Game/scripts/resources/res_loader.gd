class_name FoodResFormatLoader
extends ResourceFormatLoader

var dish_path := "res://data/cards/dishes/"
var category_path := "res://data/cards/categories/"
var ingredient_path := "res://data/cards/ingredients/"

func _exists(path: String) -> bool:
	if path != dish_path or path != category_path or path != ingredient_path: # add ingredient and category 
		return false
	return true

func _get_resource_script_class(path: String) -> String:
	if path == "Ingredient" or "Dish" or "Category":
		return path
	else:
		return "error_string("
