extends Control

var recipes = [
	{
		"title": "Cake",
		"ingredients": ["Flour", "Egg", "Sugar"],
	},
	{
		"title": "Coffee",
		"ingredients": ["Coffee Bean", "Water"],
	},
	{
		"title": "Smoothie",
		"ingredients": ["Strawberry", "Ice"],
	}
]

var current_recipe_index = 0

func _ready():
	# Called when the node is added to the scene
	show_recipe(current_recipe_index)
	# Corrected connect calls
	$"../HBoxContainer/NextButton".connect("pressed", Callable(self, "_on_NextButton_pressed"))
	$"../HBoxContainer/PreviousButton".connect("pressed", Callable(self, "_on_PreviousButton_pressed"))

func show_recipe(index):
	# Update the UI with the current recipe data
	var recipe_title = $RecipeTitle
	var recipe_ingredients = $RecipeIngredients

	recipe_title.text = recipes[index]["title"]
	recipe_ingredients.text = "Ingredients: \n" + "\n".join(recipes[index]["ingredients"])


func _on_NextButton_pressed():
	current_recipe_index = (current_recipe_index + 1) % recipes.size()  # Wrap around when reaching the end
	show_recipe(current_recipe_index)

func _on_PreviousButton_pressed():
	current_recipe_index = (current_recipe_index - 1 + recipes.size()) % recipes.size()  # Wrap around when reaching the beginning
	show_recipe(current_recipe_index)
