extends Control
class_name Tray

# Tray Logic:
# To only allow the player to send food cards and not ingredient cards or smt else
# I made it so that the Yes button only appears if the card in the slot is a food card

@onready var order_queue: OrderQueue = $"../OrderQueue"
@onready var tray_slot: Slot = $TraySlot
@onready var send_button: TextureButton = $SendButton


func _ready() -> void:
	send_button.connect("pressed", Callable(self, "_on_SendButton_pressed"))
	send_button.visible = false


func _process(_delta: float) -> void:
	# only let button appear if there is food to be sent
	if tray_slot.get_child_count() > 0:
		send_button.visible = true
	else:
		send_button.visible = false


func _on_SendButton_pressed():
	var food_cards = tray_slot.get_children()
	# remove most recent order from queue
	for food_card in food_cards:
		order_queue.remove_order(food_card.food_name)
		# appends the whole card
		# not sure if we want to have an array of just names or cards
		GameManager.finished_dishes.append(food_card)


func format_string(input: String) -> String:
	var words = input.split("_")  # Split the string by underscores
	for i in range(words.size()):
		# Capitalize the first letter of each word and make the rest lowercase
		words[i] = words[i].capitalize()
	return " ".join(words)  # Join the words with spaces
