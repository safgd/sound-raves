extends Node

@export var disabled: bool = false
@export var axis: Vector3i = Vector3(0, 1, 0)
@export var duration: float = 1.0

var tween: Tween
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if disabled:
		return
	tween = get_tree().create_tween().set_loops()
	tween.tween_property(get_parent(), "global_rotation_degrees", get_parent().global_rotation_degrees + axis * 360.0, duration).as_relative()

func _exit_tree() -> void:
	if tween:
		tween.stop()
