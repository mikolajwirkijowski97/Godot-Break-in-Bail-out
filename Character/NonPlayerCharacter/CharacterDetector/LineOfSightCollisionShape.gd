@tool
extends CollisionShape3D

@export var angle: float = 95.0:
	set(value):
		angle = deg_to_rad(value)
		_update_los()
	get:
		return angle

@export var distance: float = 25.0:
	set(value):
		distance = value
		_update_los()
	get:
		return distance

var height: float = 2.0

func _update_los():
	var new_los_mesh_shape: ConvexPolygonShape3D = ConvexPolygonShape3D.new()
	new_los_mesh_shape.points =_construct_los_mesh_points()
	shape = new_los_mesh_shape

func _construct_los_mesh_points() -> Array:
	var lower_triangle = _get_los_triangle()
	var upper_triangle = lower_triangle.map(\
	func(n): return n + Vector3.UP*height)
	
	var mesh_points: Array = []
	mesh_points.append_array(lower_triangle)
	mesh_points.append_array(upper_triangle)
	return mesh_points
	
# Get an LOS triangle with origin at (0,0)
func _get_los_triangle() -> Array:
	var los_x_offset = distance * tan(angle/2)
	return [Vector3.ZERO, \
	Vector3(distance, 0, -los_x_offset),\
	Vector3(distance, 0, los_x_offset)]
	
	
