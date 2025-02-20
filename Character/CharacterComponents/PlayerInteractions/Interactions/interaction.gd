extends Node3D
class_name Interaction

var raycast: RayCast3D
var receiver: PlayerCharacter
var initiator: PlayerCharacter

func _init(initiator_: PlayerCharacter):
	initiator = initiator_
	receiver = PlayerDeviceManager.get_other_player(initiator)
	raycast = RayCast3D.new()
	add_child(raycast)

func _condition_filled() -> bool:
	return false

func do() -> void:
	if _condition_filled():
		_action()

func _action() -> void:
	pass

func sightline_clear_between_players() -> bool:
	raycast.position = to_local(initiator.global_position)
	raycast.add_exception(initiator)
	raycast.set_collision_mask_value(1, false)
	raycast.set_collision_mask_value(2, true)
	raycast.target_position = to_local(receiver.global_position)
	raycast.force_raycast_update()
	var raycast_collider = raycast.get_collider()
	return raycast_collider == receiver
