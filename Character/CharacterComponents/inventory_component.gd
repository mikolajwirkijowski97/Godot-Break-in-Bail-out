extends Node
class_name InventoryComponent

@export_flags(
		CharacterEnums.OBJECT_TYPES.WEAPONS,
		CharacterEnums.OBJECT_TYPES.HOLDABLES,
		CharacterEnums.OBJECT_TYPES.THROWABLES
		) var accepted_object_types: int

const INVENTORY_SIZE: int = 6
var curr_selection: int = 0
var inventory: Array[Item]


func add_item(item: Item) -> void:
	inventory[curr_selection] = item
