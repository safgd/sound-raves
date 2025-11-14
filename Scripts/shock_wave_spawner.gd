extends StaticBody3D


@export var initial_wait_time: float = 0.0
# should be changed to preload perhaps
@export var shock_wave_scene: PackedScene

func _ready() -> void:
	if initial_wait_time <= 0.0:
		spawn_shock_wave()
	else:
		$"Repating Shock Wave Timer".stop()
		$"Initial Wait Timer".wait_time = initial_wait_time
		$"Initial Wait Timer".start()

func _on_repating_shock_wave_timer_timeout() -> void:
	spawn_shock_wave()

func spawn_shock_wave():
	var shock_wave: Shock_Wave = shock_wave_scene.instantiate()
	add_child(shock_wave)
	shock_wave.global_position = global_position


func _on_initial_wait_timer_timeout() -> void:
	spawn_shock_wave()
	$"Repating Shock Wave Timer".start()
