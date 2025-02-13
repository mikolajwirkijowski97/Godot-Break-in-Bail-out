extends ItemType
class_name WeaponType

func _init():
	activate_text = "Take"

# Called when object is interacted with.
# Returns whether the function is implemented for this item type.
func activate(actor: Character) -> bool:
	return pick_up(actor)

# Called when object is supposed to be picked up.
# Returns whether the function is implemented for this item type.
func pick_up(actor: Character) -> bool:
	actor.add_to_inventory(item)
	item.freeze = true
	item.hide()
	return true
 
# Called when object is supposed to be picked up.
# Returns whether the function is implemented for this item type.
func throw(actor: Character) -> bool:
	return false

# Called when object is used for an attack.
# Returns whether the function is implemented for this item type.
func attack(actor: Character) -> bool:
	return false
