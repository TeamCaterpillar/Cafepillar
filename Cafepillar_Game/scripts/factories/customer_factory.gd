class_name CustomerFactory
extends Node

var customer_path = "res://scenes/customer.tscn"


# customer creation,,, soon to be randomized 
func create_customer(customer: CustomerBasicSpec) -> Customer:
	var new_customer = (load(str(customer_path)) as PackedScene).instantiate() as Customer
	
	new_customer.order = customer.current_order
	new_customer.wait_time = customer.order_timer
	return new_customer
