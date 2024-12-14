extends Control

@onready var recipes = Recipes.recipes

@onready var recipe_list_container = $MainContainer/ScrollContainer/RecipeListContainer

func _ready():
	show_main_page()
	$BackButton.connect("pressed", Callable(self, "_on_BackButton_pressed"))


func show_main_page():
	$MainContainer.visible = true
	$RecipeDetailContainer.visible = false
	$BackButton.visible = false
	populate_recipe_list()


func show_recipe_detail(recipe_index):
	$MainContainer.visible = false
	$RecipeDetailContainer.visible = true
	$BackButton.visible = true
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
