extends Control
class_name CompletedDishInventory

@onready var grid_container: GridContainer = $GridContainer
@onready var list_button: TextureButton = $ListButton
@onready var color_rect: ColorRect = $ColorRect
@onready var label: Label = $Label

var card_size : Vector2 = Vector2(80.0, 100.0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	list_button.connect("pressed", Callable(self, "_on_ListButton_pressed"))
	color_rect.visible = false
	grid_container.visible = false
	label.visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# remove food cards from tray to dish inventory
	for food in GameManager.finished_dishes:
		var parent = food.get_parent()
		if parent.name != "GridContainer":
			parent.remove_child(food)
			grid_container.add_child(food)

	# resize cards to fit within inventory
	for child in grid_container.get_children():
		child.size = card_size

func _on_ListButton_pressed() -> void:
	if color_rect.visible == false:
		color_rect.visible = true
		grid_container.visible = true
		label.visible = true
	else:
		color_rect.visible = false
		grid_container.visible = false
		label.visible = false
