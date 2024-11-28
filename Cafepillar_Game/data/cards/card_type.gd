class_name CardType
extends Node

enum Meals {
	OMELET,
	SUNNY_SIDE_UP,
	NUTTY_SALAD,
	PEANUT_PASTRY,
	FRUITY_SALAD,
	BEEF_LEAF_STEW,
	ROSE_CAKE,
	BURGER,
	TEA,
	STRAWBERRY_TEA,
	COFFEE,
	STRAWBERRY_MILKSHAKE,
	HONEY_ROAST_COFFEE,
	ROSE_TEA
}

enum Ingredients {
	NUTS,
	EGGS,
	TEA_LEAVES,
	LETTUCE,
	COFFEE_BEANS,
	HONEY,
	STRAWBERRY,
	MILK,
	FLOUR,
	ROSE_PETALS,
	BEEF,
	CHEESE
}

enum Cookware {
	PAN,
	CUP
}

var _card_resources:Array[CardResource]


func _ready() -> void:
	pass
	
