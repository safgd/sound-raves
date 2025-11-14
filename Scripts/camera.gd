extends Camera3D

@export var shake_ammount: float = 0.2
@export var shake_duration: float = 0.2

var original_position: Vector3

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	original_position = position

func shake():
	var tween: Tween = create_tween().set_ease(Tween.EaseType.EASE_IN_OUT)
	tween.tween_property(self, "position:y", original_position.y + shake_ammount, shake_duration / 4.0)
	tween.tween_property(self, "position:y", original_position.y - shake_ammount, shake_duration / 2.0)
	tween.tween_property(self, "position:y", original_position.y, shake_duration / 4.0)
