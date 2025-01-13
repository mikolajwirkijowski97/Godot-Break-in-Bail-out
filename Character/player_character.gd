extends Character
class_name PlayerCharacter
@export_flags("Everyone", "Workers", "Vip", "Target") var area_access: int
 
var not_trespassing_timer: float
const trespassing_buffer_time: float = 2.

func is_trespassing(delta: float):
	var all_areas = get_tree().get_nodes_in_group("Areas")
	
	var trespassing_areas = all_areas.filter(
	func (x: RestrictedArea) -> bool: 
		return (x.area_access & area_access) == 0
	)
	
	# If character is overlapping an area he has no access to then true
	var in_trespassing_area = not trespassing_areas.filter(
	func (x: RestrictedArea) -> bool: 
		return self in x.get_overlapping_bodies()
		).is_empty()

	if not in_trespassing_area:
		not_trespassing_timer += delta
		not_trespassing_timer = max(not_trespassing_timer, trespassing_buffer_time*2)
	else:
		not_trespassing_timer = 0

	return in_trespassing_area and not_trespassing_timer < trespassing_buffer_time
		
	
	
