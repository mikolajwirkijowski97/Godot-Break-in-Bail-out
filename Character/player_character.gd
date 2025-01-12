extends Character
class_name PlayerCharacter
@export_flags("Everyone", "Workers", "Vip", "Target") var area_access: int
 

func is_trespassing():
	var all_areas = get_tree().get_nodes_in_group("Areas")
	
	var trespassing_areas = all_areas.filter(
	func (x: RestrictedArea) -> bool: 
		return (x.area_access & area_access) == 0
	)
	# If character is overlapping an area he has no access to, return true
	return not trespassing_areas.filter(
	func (x: RestrictedArea) -> bool: 
		return self in x.get_overlapping_bodies()
		).is_empty()
		
	
	
