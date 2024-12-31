@tool
extends CollisionShape3D

const semi_circle_point_count = 5
var angle_rad: float = PI
@export var angle_deg: float = 95.0:
	set(value):
		const max_deg_value = 170
		angle_deg = min(value, max_deg_value) 
		angle_rad = deg_to_rad(value)
		_update_los()
	get:
		return angle_deg

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
	var lower_points= _get_los_semi_circle(semi_circle_point_count)
	var upper_points = lower_points.map(\
	func(n): return n + Vector3.UP*height)

	var mesh_points: Array = []
	mesh_points.append_array(lower_points)
	mesh_points.append_array(upper_points)
	return mesh_points

func circumference_point(point_angle_rad:float) -> Vector3:
	var los_y_offset: float = distance * sin(point_angle_rad)
	var los_x_offset: float = distance * cos(point_angle_rad)
	return Vector3(los_y_offset, 0, los_x_offset)

func _get_los_semi_circle(circumference_points: int) -> Array:
	# First point is the origin
	var semi_circle_points: Array = [Vector3.ZERO]
	# The other n points are the circumference
	for n in circumference_points:
		var weight: float = float(n)/(circumference_points - 1.)
		var angle: float = lerp_angle(-angle_rad/2, angle_rad/2, weight)
		semi_circle_points.append(circumference_point(angle))

	return semi_circle_points
	
