class_name ShopItem
extends TextureButton

const UNCHECKED_BOX_SPRITE_PATH = "res://assets/ui/shop_item_checkbox.png"
const CHECKED_BOX_SPRITE_PATH = "res://assets/ui/shop_item_checkbox_checked.png"

@export var shop_item_name : String
@onready var item_label = $ItemLabel
@onready var item_icon = $ItemIcon
@onready var cost_label = $CostLabel
@onready var checkbox = $Checkbox


# state variables
var is_selected:bool = false


func _ready() -> void:
	# load shop item graphics
	load_shop_item()
	checkbox.texture = load(UNCHECKED_BOX_SPRITE_PATH)
	
	# connect signals
	self.pressed.connect(_on_item_clicked)


func _on_item_clicked():
	is_selected = !is_selected
	
	if is_selected:
		GameSignals.item_selected.emit(shop_item_name)
		checkbox.texture = load(CHECKED_BOX_SPRITE_PATH)
	else:
		GameSignals.item_deselected.emit(shop_item_name)
		checkbox.texture = load(UNCHECKED_BOX_SPRITE_PATH)
	
	
func load_shop_item() -> void:
	# construct file path to resource file
	var item_res_path = "res://data/cards/ingredients/" \
						+ str(shop_item_name) \
						+ ".tres"
	
	# load item's info if a corresponding resource file exists
	if ResourceLoader.exists(item_res_path):
		var item_info = load(item_res_path)
		item_icon.texture = load(item_info.sprite_path)
		item_label.text = format_string(shop_item_name)
	
	cost_label.text = "20 golden seeds"


func format_string(input: String) -> String:
	var words = input.split("_")  # Split the string by underscores
	for i in range(words.size()):
		# Capitalize the first letter of each word and make the rest lowercase
		words[i] = words[i].capitalize()
	return " ".join(words)  # Join the words with spaces
