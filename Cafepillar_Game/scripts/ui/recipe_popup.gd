extends Control

@onready var recipes_book = $RecipesBook
@onready var popup_button = $PopUpButton
@onready var is_recipe_open: bool = false

func _ready() -> void:
	recipes_book.visible = false
	popup_button.text = "Show Recipes"
	popup_button.connect("pressed", Callable(self, "_on_PopUpButton_pressed"))

func _on_PopUpButton_pressed() -> void:
	if is_recipe_open:
		recipes_book.visible = false
		popup_button.text = "Show Recipes"
	else:
		recipes_book.visible = true
		popup_button.text = "Hide Recipes"
	
	is_recipe_open = !is_recipe_open
