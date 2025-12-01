extends StaticBody3D


@export var initial_wait_time: float = 1.0
@export var interval: float = 8.0
@export var ring_growth_speed: float = 0.6
# should be changed to preload perhaps
@export var shock_wave_scene: PackedScene

@export var alternative_material: StandardMaterial3D
var default_speaker_box_material: StandardMaterial3D
signal shock_wave_spawning

func _ready() -> void:
	$"Repating Shock Wave Timer".wait_time = interval
	$"Initial Wait Timer".wait_time = initial_wait_time
	default_speaker_box_material = $CollisionShape3D2/Speaker.get_surface_override_material(0)
	$"Initial Wait Timer".start()
	
	
	

func _on_repating_shock_wave_timer_timeout() -> void:
	spawn_shock_wave()

func spawn_shock_wave():
	shock_wave_spawning.emit()
	var shock_wave: Shock_Wave = shock_wave_scene.instantiate()
	add_child(shock_wave)
	shock_wave.ring_growth = ring_growth_speed
	shock_wave.global_position = global_position
	shock_wave.global_rotation = global_rotation


func _on_initial_wait_timer_timeout() -> void:
	spawn_shock_wave()
	$"Repating Shock Wave Timer".start()

func _on_trigger(active: bool):
	if active:
		$"Repating Shock Wave Timer".stop()
		$"Initial Wait Timer".stop()
		$MeshInstance3D.set_surface_override_material(0, alternative_material)
		$CollisionShape3D2/Speaker.set_surface_override_material(0, alternative_material)
	else:
		$"Repating Shock Wave Timer".start()
		$MeshInstance3D.set_surface_override_material(0, null)
		$CollisionShape3D2/Speaker.set_surface_override_material(0, default_speaker_box_material)
