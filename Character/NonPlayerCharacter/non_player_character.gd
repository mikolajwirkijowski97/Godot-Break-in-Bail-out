extends Character
class_name NonPlayerCharacter

@export var action_plan: ActionPlan
@export var state_chart: StateChart
@export var npc_type: NpcType
@export var character_detector: CharacterDetector
var current_action: Action

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
var SPEED: float = 2.5

func _physics_process(_delta: float) -> void:
	# set the velocity in the animation tree, so it can blend between animations
	#TODO: If animations get more complex, this CANNOT be the default approach
	if _animation_tree:
		_animation_tree["parameters/Movement/blend_position"] = \
		velocity.length() / SPEED - 1
	move_and_slide()


func _on_busy_state_processing(delta: float) -> void:
	if npc_type:
		npc_type.on_busy_update(self, delta)


func _on_suspicious_state_processing(delta: float) -> void:
	if npc_type:
		npc_type.on_suspicious_update(self, delta)


func process_actions(delta: float) -> void:
	if current_action and not current_action.is_finished(self):
		current_action.on_update(self, delta)
	else:
		start_next_action()


func start_next_action() -> void:
	state_chart.send_event("busy")
	current_action = action_plan.get_next_action() 
	current_action.start_action(self)


func walk_towards_target(delta: float) -> void:
	# Get the next path position
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()
	var direction: Vector3 = (next_path_position - global_position).normalized()
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	_rotate_towards_velocity(delta)


func is_target_reached() -> bool:
	return navigation_agent.is_target_reached()


func _rotate_towards_velocity(delta: float) -> void:
	var min_velocity_rotation_cutoff: float = 0.3
	if velocity.length() > min_velocity_rotation_cutoff:
		rotate_towards_direction(velocity, delta)


func rotate_towards_direction(direction: Vector3, delta: float) -> void:
	const look_towards_speed = 4
	var flat_direction = Vector2(direction.z, direction.x) 
	rotation.y = rotate_toward(rotation.y, \
		flat_direction.angle(), delta*look_towards_speed)


func set_navigation_target(target: Vector3) -> void:
	navigation_agent.target_position = target


func guard_area(delta: float) -> void:
	# Cant really guard shit with no eyes or ears can you?
	if not character_detector:
		return
	
	# Check if anyone is trespassing
	for player in character_detector.detection_status:
		var detection: bool = character_detector.b_is_visible(player)
		var trespassing: bool = character_detector.is_trespassing(player, delta)
		if detection and trespassing:
			state_chart.send_event("get_suspicious")

func follow_trespassers(delta: float) -> void:
	if not character_detector:
		return

	var closest_player: PlayerCharacter
	var closest_distance: float

	for player: PlayerCharacter in character_detector.get_caught_players():
		var detection_location: Vector3 = character_detector.detection_status[player].last_seen_location
		var distance = (global_position - detection_location).length()
		
		if closest_player and closest_distance < distance:
			continue
		
		closest_player = player
		closest_distance = distance
	
	if closest_player:
		set_navigation_target(character_detector.detection_status[closest_player].last_seen_location)

func _on_ledge_detector_bump_encountered() -> void:
	position.y += 0.3

	
	
