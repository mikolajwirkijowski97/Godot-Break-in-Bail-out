# A label displayed on top of items and activatables
extends Label3D
class_name ItemLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	billboard = BaseMaterial3D.BILLBOARD_ENABLED
	fixed_size = true
	font_size = 40
	pixel_size = 0.001

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
