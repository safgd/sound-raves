extends Node

@export var shift: Vector3 = Vector3(0.0, 0.02, 0.0)
@export var duration: float = 12.0

var tween: Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tween = get_tree().create_tween().set_loops().set_ease(Tween.EaseType.EASE_IN_OUT)
	var spawn_pos: Vector3 = get_parent().global_position
	tween.tween_property(get_parent(), "global_position", spawn_pos + shift/4.0, duration/4.0)
	tween.tween_property(get_parent(), "global_position", spawn_pos - shift/4.0, duration/2.0)
	tween.tween_property(get_parent(), "global_position", spawn_pos, duration/4.0)

func _exit_tree() -> void:
	if tween:
		tween.stop()
