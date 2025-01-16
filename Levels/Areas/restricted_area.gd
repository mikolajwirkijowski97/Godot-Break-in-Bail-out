extends Area3D
class_name RestrictedArea
@export_flags("Everyone", "Workers", "Vip", "Target") var area_access: int 


func _init():
	add_to_group("Areas")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta) -> void:
	pass
