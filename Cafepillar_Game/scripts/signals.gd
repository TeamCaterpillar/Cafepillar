extends Node

@warning_ignore("unused_signal")
signal button_pressed
@warning_ignore("unused_signal")
signal day_ended
@warning_ignore("unused_signal")
signal next_day_started
@warning_ignore("unused_signal")
signal customer_added
@warning_ignore("unused_signal")
signal item_selected(shop_item)
@warning_ignore("unused_signal")
signal item_deselected(shop_item)
@warning_ignore("unused_signal")
signal player_moving
@warning_ignore("unused_signal")
signal waiter_moving
@warning_ignore("unused_signal")
signal player_finished_delivery
@warning_ignore("unused_signal")
signal dish_selected(dish_card)
@warning_ignore("unused_signal")
signal customer_selected(customer_card)
@warning_ignore("unused_signal")
signal customer_can_move(customer : Customer)
@warning_ignore("unused_signal")
signal food_delivered(dish_card : DishCard)
@warning_ignore("unused_signal")
signal kill_customer(customer : Customer)
@warning_ignore("unused_signal")
signal change_to_kitchen
@warning_ignore("unused_signal")
signal change_to_cafe
@warning_ignore("unused_signal")
signal start_game
@warning_ignore("unused_signal")
signal start_game_intro
@warning_ignore("unused_signal")
signal pause_game
