extends RigidBody3D
class_name Item

@export var type: ItemType
var label: ItemLabel

func _init():
	# TODO: just why though
	if not type:
		type = WeaponType.new()
		add_child(type)

func _ready():
	label = ItemLabel.new(self, type.activate_text)
	add_child(label)

# Current heurestic for is_equipped is just checking if it has a character parent
func equipped() -> bool:
	var parent = get_parent()
	while parent:
		if parent is Character:
			return true
		parent = parent.get_parent()
	return false
	
