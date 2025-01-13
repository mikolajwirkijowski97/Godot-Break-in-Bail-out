extends Node
class_name CharacterDetectionStatus

var is_visible: bool
var last_seen_location: Vector3
var last_seen_timer: float

func _init():
	self.is_visible = false
	self.last_seen_location = Vector3.ZERO
	self.last_seen_timer = INF
