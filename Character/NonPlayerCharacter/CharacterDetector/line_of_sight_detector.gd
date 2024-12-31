extends Node3D
signal character_in_line_of_sight(char: Character)

func _on_line_of_sight_body_entered(body: Node3D) -> void:
	if body is Character:
		var ray: RayCast3D = RayCast3D.new()
		ray.look_at_from_position(global_position, \
		body.global_position + Vector3.UP * body.detection_height)
		ray.force_raycast_update()

		if ray.get_collider() == body:
			character_in_line_of_sight.emit(body)
