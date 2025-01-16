extends Node
class_name CharacterDetectionStatus

var is_visible: bool

var last_seen_location: Vector3
var last_seen_timer: float

var is_trespassing: bool
var not_trespassing_timer: float
const trespassing_buffer_time: float = 2.

var caught_red_handed: bool 

func _init():
	self.is_visible = false
	self.last_seen_location = Vector3.ZERO
	self.last_seen_timer = INF
	self.not_trespassing_timer = INF
	self.caught_red_handed = false
	self.is_trespassing = false
	
