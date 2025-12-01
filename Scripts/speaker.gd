extends MeshInstance3D

var default_cylinder_pos: Vector3
var default_cylinder_2_pos: Vector3
@export var cylinder_distance: float = 0.2
@export var disable_automated_animation: bool = false
@export var alternative_material: StandardMaterial3D
var default_cylinder_material: StandardMaterial3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	default_cylinder_pos = $Cylinder.position 
	default_cylinder_2_pos = $"Cylinder 2".position
	if not disable_automated_animation:
		AudioManager.audio_tick.connect(_on_audio_tick)
	else:
		default_cylinder_material = $Cylinder.get_surface_override_material(0)

func _on_audio_tick():
	
	if disable_automated_animation:
		$Cylinder.set_surface_override_material(0, alternative_material)
		$"Cylinder 2".set_surface_override_material(0, alternative_material)
	else:
		$Cylinder.position += Vector3(cylinder_distance, 0.0, 0.0)
		$"Cylinder 2".position += Vector3(cylinder_distance, 0.0, 0.0)
	$Timer.start()


func _on_timer_timeout() -> void:
	
	if disable_automated_animation:
		$Cylinder.set_surface_override_material(0, default_cylinder_material)
		$"Cylinder 2".set_surface_override_material(0, default_cylinder_material)
	else:
		$Cylinder.position = default_cylinder_pos
		$"Cylinder 2".position = default_cylinder_2_pos
