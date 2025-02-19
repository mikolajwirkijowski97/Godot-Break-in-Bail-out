extends Node
class_name InventoryComponent

@export_flags(
		CharacterEnums.OBJECT_TYPES.WEAPONS,
		CharacterEnums.OBJECT_TYPES.HOLDABLES,
		CharacterEnums.OBJECT_TYPES.THROWABLES,
		) var accepted_object_types: int

const INVENTORY_SIZE: int = 6
var curr_selection: int = -1
var inventory: Array[Item] 
var component_owner: Character

func _ready():
	component_owner = get_parent()

func _init():
	inventory.resize(INVENTORY_SIZE)
	inventory.fill(null)

func add_item(item: Item) -> void:
	if curr_selection == -1:
		curr_selection = 0
	inventory[curr_selection] = item
	select_item(curr_selection)

func remove_item(index: int) -> Item:
	if not inventory[index]:
		return null

	var ret = inventory[index]
	inventory[index] = null
	return ret

func remove_current_item() -> Item:
	return remove_item(curr_selection)

func get_current_item() -> Item:
	return inventory[curr_selection]

func select_item(index: int) -> Item:
	if inventory[index]:
		curr_selection = index
	var selected_item = get_current_item()

	selected_item.type.equip(component_owner)
	return selected_item


func next_item() -> Item:
	select_item((curr_selection + 1) % INVENTORY_SIZE)
	return inventory[curr_selection]


func _input(event):
	pass
