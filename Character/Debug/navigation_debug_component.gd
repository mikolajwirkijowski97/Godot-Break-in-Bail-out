extends CSGSphere3D

@export var nav: NavigationAgent3D

func _init() -> void:
	var red_material = StandardMaterial3D.new()
	red_material.albedo_color = Color.RED
	material = red_material
	
func _process(delta: float) -> void:
	global_position = nav.get_next_path_position()
