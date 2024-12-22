extends Character
class_name NonPlayerCharacter

@export var action_plan: ActionPlan
@export var state_chart: StateChart
var current_action: Action

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
var SPEED: float = 5.0

func _ready():
	_animation_tree = $AnimationTree
	call_deferred("start_next_action")


func _physics_process(delta: float):
	# set the velocity in the animation tree, so it can blend between animations
	if _animation_tree:
		_animation_tree["parameters/Movement/blend_position"] = \
		velocity.length() / SPEED - 1

	move_and_slide()

func _on_busy_state_physics_processing(delta):
	if navigation_agent.is_target_reached():
		if not current_action.is_wait_over():
			current_action.inc_timer(delta)
		else:
			start_next_action()
	
	# Get the next path position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var direction: Vector3 = (next_path_position - global_position).normalized()
	_walk_in_direction(direction)
	$DebugBallXD.global_position = next_path_position
	
	_rotate_towards_direction(delta)

	
func _walk_in_direction(direction: Vector3):
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
func _rotate_towards_direction(delta: float):
	const look_towards_speed = 14
	var min_velocity_rotation_cutoff: float = 0.2
	if velocity.length() > min_velocity_rotation_cutoff:
		var look_direction = Vector2(velocity.z, velocity.x)
		rotation.y = rotate_toward(rotation.y, \
		look_direction.angle(), delta*look_towards_speed)
	
func start_next_action():
	state_chart.send_event("busy")
	current_action = action_plan.get_next_action()
	navigation_agent.target_position = current_action.global_position
	
func _on_ledge_detector_bump_encountered():
	velocity.y += 1
