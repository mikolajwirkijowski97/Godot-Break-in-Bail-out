extends CSGSphere3D

@export var nav: NavigationAgent3D

func _init() -> void:
	if not OS.is_debug_build():
		queue_free()
		return
	var red_material = StandardMaterial3D.new()
	red_material.albedo_color = Color.RED
	material = red_material
	
func _process(_delta: float) -> void:
	global_position = nav.get_next_path_position()
