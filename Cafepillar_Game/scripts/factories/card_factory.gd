extends Node
class_name CardFactory

const SLOT_SIZE_OFFSET : Vector2 = Vector2(5.0, 5.0)
const HAND_SIZE: int = 5

@export var base_path: String = "res://data/cards/"
# @export var card_scene: PackedScene # Card scene to instantiate
@export var card_deck: GCardHandLayout # Reference to the card deck

@export var stove_output: GCardHandLayout

@onready var inventory_deck: TextureButton = $"../InventoryDeck/TextureButton"
@onready var stove_slot: Slot = $"../Stove/StoveSlot"

var card_size : Vector2 = Vector2(160.0, 200.0) # replace with whatever size needed, must have ratio 4/5 - x/y
var card_pivot : Vector2 = Vector2(card_size.x/2, 0.0) # must be half the x size value
var cur_subset_num: int = 0


# testing factory methods
func _ready() -> void:
	inventory_deck.pressed.connect(_on_deck_click)
	transfer_cards_into_hand()


func _on_deck_click() -> void:
	cur_subset_num += 1
	
	if cur_subset_num >= GameManager.kitchen_inventory.size() / HAND_SIZE:
		cur_subset_num = 0
	print("currently on subset " + str(cur_subset_num))
	
	clear_hand()
	transfer_cards_into_hand()

# Create a single card
func create_card(card_name: String, card_type: String) -> void:
	var resource_path: String = "%s%s/%s.tres" % [base_path, card_type, card_name] # Build resource path
	var card_resource = load(resource_path)
	if not card_resource:
		push_error("Failed to load resource path: %s" % resource_path)
		return

	var card_instance: CardInstance = CardInstance.new()
	card_instance.card_resource = card_resource # Assign the resource to the card
	card_instance.texture = load(card_resource.sprite_path)
	card_instance.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	card_instance.size = card_size
	card_instance.pivot_offset = card_pivot 
	card_instance.scale = Vector2(0.08, 0.1)
	card_instance.add_to_group("Ingredient", false)
	card_instance.food_name = card_name
	card_deck.add_child(card_instance)
	# Print the card's state
	print("Created card: ", card_name, " of type: ", card_type, " from resource path: ", resource_path)


func create_card_for_stove(card_name: String, card_type: String, food_quality: String) -> void:
	var resource_path: String = "%s%s/%s.tres" % [base_path, card_type, card_name] # Build resource path
	var card_resource = load(resource_path)
	if not card_resource:
		push_error("Failed to load resource path: %s" % resource_path)
		return

	var card_instance: CardInstance = CardInstance.new()
	card_instance.card_resource = card_resource # Assign the resource to the card
	card_instance.texture = load(card_resource.sprite_path)
	card_instance.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	card_instance.size = card_size
	card_instance.pivot_offset = card_pivot 
	card_instance.scale = Vector2(0.08, 0.1)
	card_instance.add_to_group("Dish", false)
	card_instance.food_name = card_name
	card_instance.food_condition = food_quality
	stove_output.add_child(card_instance)
	# Print the card's state
	print("Created card: ", card_name, " of type: ", card_type, " from resource path: ", resource_path)


func clear_hand() -> void:
	for card in card_deck.get_children():
		card_deck.remove_child(card)


func transfer_cards_into_hand() -> void:
	var subset_start = cur_subset_num * HAND_SIZE
	var subset_end = (cur_subset_num * HAND_SIZE) + HAND_SIZE
	var subset = GameManager.kitchen_inventory.slice(subset_start, subset_end)
	for item in subset:
		create_card(item, "ingredients")
