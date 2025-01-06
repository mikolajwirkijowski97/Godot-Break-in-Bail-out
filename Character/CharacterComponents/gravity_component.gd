extends Node3D

@export var player: PhysicsBody3D
var time_in_air: float = 0.0 
const FALLING_SPEED_MULTIPLIER: float = 20.0
func _physics_process(delta) -> void:
	# Right now assuming gravity always applies
	coyote_time_gravity(delta)
	
func should_be_falling() -> bool:
	var coyote_time: float = 0.1
	return time_in_air > coyote_time
	
func coyote_time_gravity(delta: float) -> void:
	# Add to the midair timer
	if not player.is_on_floor():
		time_in_air += delta
	else:
		time_in_air = 0.0
	# handle the falling
	if should_be_falling():
		player.velocity += player.get_gravity() * FALLING_SPEED_MULTIPLIER * delta
