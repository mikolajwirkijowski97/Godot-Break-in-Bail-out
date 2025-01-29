extends Node3D
class_name PlayerControllerComponent

@export var player: CharacterBody3D
@export var animation_tree: AnimationTree
@export var state_chart: StateChart

# Player device members
var device: int
@export var p_id: int
var has_device: bool = false

# physics related
@export var SPEED = 10.0

func get_camera_y_rotation():
	return %PlayerCamera.get_y_rotation()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerDeviceManager.player_joined.connect(on_player_joined)
	PlayerDeviceManager.player_left.connect(on_player_left)
	
func _get_direction_from_input() -> Vector3:
	var dir_x: float = 0.0 if not has_device else \
	MultiplayerInput.get_axis(device, "move_left","move_right") 
	
	var dir_z: float = 0.0 if not has_device else \
	MultiplayerInput.get_axis(device, "move_backwards", "move_forward")
	
	var direction = Vector3(-dir_x, 0, dir_z).normalized()

	return direction.rotated(Vector3.UP, get_camera_y_rotation()-PI)

func _physics_process(_delta: float) -> void: 
	# set the velocity in the animation tree, so it can blend between animations
	if animation_tree:
		animation_tree["parameters/Movement/blend_position"] = \
		player.velocity.length() / SPEED - 1

func walk(direction: Vector3, _delta: float) -> void:
	const look_towards_speed = 14
	const slow_down_speed = 40
	# Set velocity to walk or slow down
	# TODO: this can be more neat by using multiplication instead of this weird iteration
	# TODO: Break up into functions
	# FIX: Character gets stuck walking sometimes when receiving diagonal input(forward|backward + left|right)
	for i in 3:
		if direction[i]:
			player.velocity[i] = direction[i] * SPEED
		else:
			player.velocity[i] = move_toward(player.velocity[i], 0, slow_down_speed*_delta)

	var min_velocity_rotation_cutoff: float = 0.2

	if player.velocity.length() > min_velocity_rotation_cutoff:
		var look_direction = Vector2(player.velocity.z, player.velocity.x)
		player.rotation.y = rotate_toward(player.rotation.y, \
		look_direction.angle(), _delta*look_towards_speed)
		
func on_player_joined(_player: int) -> void:
	if not has_device and _player == p_id:
		print_debug("Device: "+str(_player)+" joined")
		has_device = true
		device = PlayerDeviceManager.get_player_device(_player)

func on_player_left(_player: int) -> void:
	print_debug("Device: "+str(_player)+" left")
	if _player == p_id:
		has_device = false

# TODO: Create an enumaration for events, they cant just be loose strings like that, that's atrocious
func _on_walk_state_physics_processing(delta: float) -> void:
	var direction: Vector3 = _get_direction_from_input()
	walk(direction, delta)	
	if not direction and is_zero_approx(player.velocity.x + player.velocity.z)\
		and state_chart:
		state_chart.send_event("idle")

func _on_idle_state_physics_processing(_delta: float) -> void:
	if _get_direction_from_input() != Vector3.ZERO:
		state_chart.send_event("walk")
		
