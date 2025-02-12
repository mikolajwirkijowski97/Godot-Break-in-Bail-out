extends Node
class_name ItemType
 
var item: Item
var activate_text: String

var action_types = {
	TAKE = "take",
	ACTIVATE = "activate",
	PRESS = "press"
}

func _init():
	item = get_parent() 
	
# Called when object is interacted with.
# Returns whether the function is implemented for this item type.
func activate(actor: Character) -> bool:
	return false

# Called when object is supposed to be picked up.
# Returns whether the function is implemented for this item type.
func pick_up(actor: Character) -> bool:
	return false

# Called when object is supposed to be picked up.
# Returns whether the function is implemented for this item type.
func throw(actor: Character) -> bool:
	return false

# Called when object is used for an attack.
# Returns whether the function is implemented for this item type.
func attack(actor: Character) -> bool:
	return false
