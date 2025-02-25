extends Node3D
class_name Interaction

# Interactions need to be in tree. They should clean themselve up when finished
var raycast: RayCast3D
var receiver: PlayerCharacter
var initiator: PlayerCharacter
var started: bool

func _init(initiator_: PlayerCharacter):
	initiator = initiator_
	receiver = PlayerDeviceManager.get_other_player(initiator)
	raycast = RayCast3D.new()
	add_child(raycast)
	started = false

func _condition_filled() -> bool:
	return false

func do() -> void:
	if _condition_filled():
		started = true

func _action() -> void:
	pass

func is_finished() -> bool:
	return true
	
func sightline_clear_between_players() -> bool:
	raycast.position = to_local(initiator.global_position)
	raycast.add_exception(initiator)
	raycast.set_collision_mask_value(1, true)
	raycast.set_collision_mask_value(2, true)
	raycast.target_position = to_local(receiver.global_position)
	raycast.force_raycast_update()
	var raycast_collider = raycast.get_collider()
	print("Raycast Collider")
	print(raycast_collider)
	return raycast_collider == receiver
