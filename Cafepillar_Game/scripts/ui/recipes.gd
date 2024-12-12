extends Control

var recipes = [
	# Foods
	{
		"use": "Stove",
		"title": "Omelette",
		"ingredients": ["Eggs x2", "Cheese x2"]
	},
	{
		"use": "Stove",
		"title": "Sunny Side Up",
		"ingredients": ["Eggs x2"]
	},
	{
		"use": "Counter",
		"title": "Nutty Salad",
		"ingredients": ["Nuts x1", "Lettuce x1"]
	},
	{
		"use": "Counter",
		"title": "Peanut Pastry",
		"ingredients": ["Nuts x1", "Flour x1"]
	},
	{
		"use": "Counter",
		"title": "Fruity Salad",
		"ingredients": ["Strawberry x2", "Lettuce x1"]
	},
	{
		"use": "Stove",
		"title": "Beef n Leaf Stew",
		"ingredients": ["Lettuce x2", "Beef x1"]
	},
	{
		"use": "Oven",
		"title": "Rose Cake",
		"ingredients": ["Rose Petals x1", "Flour x1", "Eggs x1", "Milk x1"]
	},
	{
		"use": "Stove",
		"title": "Burger :D",
		"ingredients": ["Beef x1", "Cheese x1", "Lettuce x1", "Flour x1"]
	},

	# Drinks
	{
		"use": "Counter",
		"title": "Tea",
		"ingredients": ["Tea Leaves x2"]
	},
	{
		"use": "Counter",
		"title": "Strawberry Tea",
		"ingredients": ["Strawberry x1", "Tea Leaves x1"]
	},
	{
		"use": "Blender",
		"title": "Coffee",
		"ingredients": ["Coffee Beans x2"]
	},
	{
		"use": "Blender",
		"title": "Strawberry Milkshake",
		"ingredients": ["Strawberry x1", "Milk x1"]
	},
	{
		"use": "Blender",
		"title": "Honey Roasted Coffee",
		"ingredients": ["Coffee Beans x1", "Honey x1", "Nuts x1"]
	},
	{
		"use": "Counter",
		"title": "Rose Tea",
		"ingredients": ["Rose Petals x2", "Tea Leaves x1"]
	}
]


@onready var recipe_list_container = $MainContainer/ScrollContainer/RecipeListContainer

func _ready():
	show_main_page()
	$RecipeDetailContainer/BackButton.connect("pressed", Callable(self, "_on_BackButton_pressed"))


func show_main_page():
	$MainContainer.visible = true
	$RecipeDetailContainer.visible = false
	populate_recipe_list()


func show_recipe_detail(recipe_index):
	$MainContainer.visible = false
	$RecipeDetailContainer.visible = true
	display_recipe(recipes[recipe_index])


func populate_recipe_list():
	for child in recipe_list_container.get_children():
		child.queue_free()
	
	for i in recipes.size():
		var recipe_button = Button.new()
		recipe_button.text = recipes[i]["title"]
		recipe_button.connect("pressed", Callable(self, "_on_recipe_button_pressed").bind(i))
		recipe_list_container.add_child(recipe_button)
	
	for i in recipes.size():
		recipe_list_container.get_child(i).scale = Vector2(2.0, 2.0)


func _on_recipe_button_pressed(recipe_index):
	show_recipe_detail(recipe_index)


func display_recipe(recipe):
	$RecipeDetailContainer/RecipeTitle.text = recipe["title"]
	$RecipeDetailContainer/RecipeTool.text = "Use: " + recipe["use"]
	$RecipeDetailContainer/RecipeIngredients.text = "Ingredients:\n" + "\n".join(recipe["ingredients"])


func _on_BackButton_pressed():
	show_main_page()
