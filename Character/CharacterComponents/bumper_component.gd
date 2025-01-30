extends RayCast3D
class_name BumperComponent
# The character that owns the component
@export var character: NonPlayerCharacter
@export var sliding_speed: float

func _ready():
		
	
func _process(delta):
	if is_colliding():
		character.velocity += get_collision_normal() * sliding_speed * delta
 
