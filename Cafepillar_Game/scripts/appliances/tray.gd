extends Control
class_name Tray

# Tray Logic:
# To only allow the player to send food cards and not ingredient cards or smt else
# I made it so that the Yes button only appears if the card in the slot is a food card

@onready var order_queue: OrderQueue = $"../OrderQueue"
@onready var tray_slot: Slot = $TraySlot

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	pass


func _on_YesButton_pressed():
	pass
	# uncomment when we have a food card
	# var food_card = tray_slot.get_child(0)
	# order_queue.remove_order(food_card.food_name)
