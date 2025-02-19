extends Node
class_name ItemType
 
var item: Item
var itemtype_type: String
var activate_text: String

var action_types = {
	TAKE = "take",
	ACTIVATE = "activate",
	PRESS = "press"
}

func _ready():
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

# Called when the item is to be held by a character
func equip(actor: Character) -> bool:
	reveal_item()
	# Free all attachments from r-hand
	var right_hand_att =  actor.right_hand_attachment
	# Add to characters r-hand
	item.position = -item.attachment_point.position
	item.rotation = Vector3.ZERO
	return true

func hide_item():
	item.freeze = true
	item.hide()

func reveal_item():
	item.show()
	item.freeze = false
