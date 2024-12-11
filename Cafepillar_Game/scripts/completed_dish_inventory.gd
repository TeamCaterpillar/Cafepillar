extends Control
class_name CompletedDishInventory

@onready var grid_container: GridContainer = $GridContainer
@onready var list_button: TextureButton = $ListButton
@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $Label
@onready var label_2: Label = $Label2

var dish_card_size : Vector2 = Vector2(160.0, 200.0)

func _ready() -> void:
	list_button.connect("pressed", Callable(self, "_on_ListButton_pressed"))
	color_rect.visible = false
	grid_container.visible = false
	label.visible = false


func _process(delta: float) -> void:
	pass

func _on_ListButton_pressed() -> void:
	# display inventory
	if color_rect.visible == false:
		color_rect.visible = true
		grid_container.visible = true
		label.visible = true
	else:
		color_rect.visible = false
		grid_container.visible = false
		label.visible = false

	# show foods in the inventory
	for food in GameManager.finished_dishes:
		if _contains_food(food) == false:
			grid_container.add_child(food)
			food.size = dish_card_size

	# display message that no foods are in the inventory
	if GameManager.finished_dishes.size() == 0 and color_rect.visible == true:
		label_2.visible = true
	else:
		label_2.visible = false


# function to check if food is already in the grid container
func _contains_food(food: Variant) -> bool:
	for child in grid_container.get_children():
		if food == child:
			return true
	return false
