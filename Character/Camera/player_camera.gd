extends Node3D
class_name PlayerCamera

@export var target: PlayerCharacter
@export var spring_arm: SpringArm3D

var position_target_offset: Vector3
var player_controller: PlayerControllerComponent
const camera_rotation_speed = 0.2


func _ready():
	top_level = true
	player_controller = get_parent().get_children().filter(
		func (x): 
			return x is PlayerControllerComponent)[0]

	spring_arm.add_excluded_object(target.get_rid())

func _process(delta):
	global_position = target.global_position

# Handle mouse
func _unhandled_input(event):
		if player_controller and player_controller.has_device:
			var device = player_controller.device
			var direction: float

			if device != -1 or event is not InputEventMouseMotion:
				return

			var yaw_dir = (event as InputEventMouseMotion).relative[0] / get_viewport().size[0]
			var pitch_dir = (event as InputEventMouseMotion).relative[1] / get_viewport().size[1]

			
			rotate_camera(yaw_dir, pitch_dir)

func rotate_camera(yaw_delta: float, pitch_delta: float) -> void:
	spring_arm.rotation.y -= yaw_delta
	spring_arm.rotation.y = wrapf(spring_arm.rotation.y, 0, TAU)
	
	spring_arm.rotation.x -= pitch_delta
	spring_arm.rotation.x = clamp(spring_arm.rotation.x, -PI/2, 0)


func _physics_process(delta):
	print(spring_arm.get_hit_length())
	if player_controller and player_controller.has_device:
		var device = player_controller.device
		if device == -1:
			return
		var yaw_dir: float = MultiplayerInput.get_axis(player_controller.device, "camera_left", "camera_right")
		var pitch_dir: float = MultiplayerInput.get_axis(player_controller.device, "camera_down", "camera_up")
		
		rotate_camera(yaw_dir*delta, pitch_dir*delta)

func get_y_rotation():
	return $SpringArm3D.rotation.y
