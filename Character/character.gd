extends CharacterBody3D
class_name Character

@onready var _state_chart: StateChart = $StateChart
@onready var _animation_tree: AnimationTree = $AnimationTree
@onready var _animation_state_machine: AnimationNodeStateMachinePlayback = _animation_tree.get("parameters/playback")
# Should the character handle the game controls initialisation(use only if no game object does it)
@export var call_handle_input: bool = true

# The height at which this character receives detection raycasts
@export var detection_height: float = 4.5

signal main_char_position_updated(position)

func _physics_process(delta):
	if(velocity):
		main_char_position_updated.emit(global_position)
	move_and_slide()

func _process(delta):
	if call_handle_input:
		PlayerDeviceManager.handle_join_input()

func _on_ledge_detector_bump_encountered():
	position.y += 0.03
