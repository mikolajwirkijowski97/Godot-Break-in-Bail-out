extends Label3D
class_name ItemLabel

var _parent_item: Item
const LABEL_OFFSET: Vector3 = Vector3.UP * 0.3
var characters_near: int

func _init(parent_item: Item, label_text: String):
	top_level = true
	text = label_text
	billboard = BaseMaterial3D.BILLBOARD_ENABLED
	_parent_item = parent_item
	font_size = 40
	pixel_size = 0.001
	fixed_size = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	global_position = _parent_item.global_position + LABEL_OFFSET
	visible = characters_near and not _parent_item.equipped()
	
