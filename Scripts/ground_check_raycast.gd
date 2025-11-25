extends RayCast3D

@export var pre_color_extended: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enabled = true
	force_raycast_update()
	var collider = get_collider()
	if collider and collider is Ground:
		collider.notify_pre_marking(global_position, pre_color_extended)
	else:
		print("no ground detected")
	enabled = false
	call_deferred("queue_free")
