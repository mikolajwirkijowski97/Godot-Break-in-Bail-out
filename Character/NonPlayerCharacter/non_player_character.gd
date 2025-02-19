extends Character
class_name NonPlayerCharacter

@export var action_plan: ActionPlan
@export var state_chart: StateChart
@export var npc_type: NpcType
@export var character_detector: CharacterDetector
var current_action: Action

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D
var navigation_cooldown: Timer
var SPEED: float = 2.5

func _physics_process(_delta: float) -> void:
	# set the velocity in the animation tree, so it can blend between animations
	if _animation_tree:
		_animation_tree["parameters/Movement/blend_position"] = \
		velocity.length() / SPEED - 1
	move_and_slide()


func _on_busy_state_entered():
	npc_type.on_busy_started(self)


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

func start_current_action() -> void:
	if current_action:
		current_action.start_action(self)
	else:
		print_debug("Starting an inexistent action!")
	
func start_next_action() -> void:
	state_chart.send_event(Transitions.GET_BUSY)
	current_action = action_plan.get_next_action() 
	current_action.start_action(self)

func stop(delta: float) -> void:
	const stop_speed = 10
	velocity = velocity.move_toward(Vector3.ZERO, delta * stop_speed)

func refresh_navigation_target() -> void:
	set_navigation_target(navigation_agent.target_position)

func walk_towards_target(delta: float) -> void:
	# Get the next path position, needed for pathfinding to work
	var next_path_position: Vector3 = navigation_agent.get_next_path_position()

	if is_target_reached():
		# TODO: Consider redoing stuff using final position reached, just
		# leaving a reminder.
		if navigation_agent.distance_to_target() > navigation_agent.target_desired_distance:
			refresh_navigation_target()
		stop(delta)
		return

	var direction: Vector3 = (next_path_position - global_position).normalized()
	velocity.x = direction.x * SPEED
	velocity.z = direction.z * SPEED
	
	rotate_towards_velocity(delta)


func is_target_reached() -> bool:
	return navigation_agent.is_target_reached()

func set_navigation_target_with_cooldown(target: Vector3):
	if not navigation_cooldown:
		navigation_cooldown = Timer.new()
		navigation_cooldown.wait_time = 0.25
		navigation_cooldown.one_shot = true
		add_child(navigation_cooldown)
		navigation_cooldown.start()
	
	if navigation_cooldown.is_stopped():
		set_navigation_target(target)
		navigation_cooldown.start()
	
func set_navigation_target(target: Vector3) -> void:
	print_debug("navigation updated")
	navigation_agent.target_position = target

func setup_navigation(nav_setup: NavigationSetup):
	navigation_agent.target_desired_distance = nav_setup.desired_distance
	set_navigation_target(nav_setup.navigation_target)

func setup_navigation_with_cooldown(nav_setup: NavigationSetup):
	navigation_agent.target_desired_distance = nav_setup.desired_distance
	set_navigation_target_with_cooldown(nav_setup.navigation_target)
	
func guard_area(delta: float) -> void:
	# Cant really guard shit with no eyes or ears can you?
	if not character_detector:
		return
	
	# Check if anyone is trespassing
	for player in character_detector.detection_status:
		var detection: bool = character_detector.b_is_visible(player)
		var trespassing: bool = character_detector.is_trespassing(player)
		if detection and trespassing:
			state_chart.send_event(Transitions.GET_SUS)

func conditionally_reset_trespassing_status(player: PlayerCharacter, cutoff: float) -> void:
	if character_detector.get_not_trespassing_time(player) >= cutoff:
		character_detector.reset_red_handed_status(player)

#TODO: Definitely, refactor this later on please, and maybe the whole 
# of trespassing code while you're at it. 
func follow_trespassers(delta: float, how_long: float) -> void:
	if not character_detector:
		return

	var closest_player: PlayerCharacter
	var closest_distance: float
	
	for player in character_detector.get_caught_players():
		conditionally_reset_trespassing_status(player, how_long)
	
	for player: PlayerCharacter in character_detector.get_caught_players():
		var detection_location: Vector3 = character_detector.detection_status[player].last_seen_location
		var distance = (global_position - detection_location).length()
		
		if closest_player and closest_distance < distance:
			continue
		
		closest_player = player
		closest_distance = distance
	
	if closest_player:
		var last_seen_loc: Vector3 = character_detector.detection_status[closest_player].last_seen_location
		var nav_config = NavigationSetup.new()
		nav_config.desired_distance = 2.5
		nav_config.navigation_target = last_seen_loc
		
		walk_towards_target(delta)
		setup_navigation_with_cooldown(nav_config)
	# If no players to follow, get back to normal business
	else:
		state_chart.send_event(Transitions.GET_BUSY)
			
