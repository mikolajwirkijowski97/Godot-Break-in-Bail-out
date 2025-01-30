extends CharacterBody3D
class_name Character

@onready var _state_chart: StateChart = $StateChart
@onready var _animation_tree: AnimationTree = $AnimationTree
@onready var _animation_state_machine: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/playback")
# Should the character handle the game controls initialisation(use only if no game object does it)
@export var call_handle_input: bool = true

# The height at which this character receives detection raycasts
@export var detection_height: float = 1

func _ready():
	_animation_tree.active = true
	
func _physics_process(_delta: float) -> void:
	move_and_slide()

func _process(_delta: float) -> void:
	if call_handle_input:
		PlayerDeviceManager.handle_join_input()

func rotate_towards_velocity(delta: float, rotation_speed: float = 1.0) -> void:
	var min_velocity_rotation_cutoff: float = 0.3
	if velocity.length() > min_velocity_rotation_cutoff:
		rotate_towards_direction(velocity, rotation_speed*delta)


func rotate_towards_direction(direction: Vector3, delta: float) -> void:
	const look_towards_speed = 4
	var flat_direction = Vector2(direction.z, direction.x) 
	rotation.y = rotate_toward(rotation.y, \
		flat_direction.angle(), delta*look_towards_speed)
