extends StaticBody3D


@export var initial_wait_time: float = 1.0
@export var interval: float = 8.0
@export var ring_growth_speed: float = 0.6
# should be changed to preload perhaps
@export var shock_wave_scene: PackedScene

func _ready() -> void:
	$"Repating Shock Wave Timer".wait_time = interval
	$"Initial Wait Timer".wait_time = initial_wait_time
	$"Initial Wait Timer".start()
	#if initial_wait_time <= 0.0:
		#spawn_shock_wave()
	#else:
		#$"Repating Shock Wave Timer".stop()
		#$"Initial Wait Timer".wait_time = initial_wait_time
		#$"Initial Wait Timer".start()
	
	
	
	$"../../Ground".notify_shock_wave_spawner_placement(global_position)
	print("init timer started")

func _on_repating_shock_wave_timer_timeout() -> void:
	spawn_shock_wave()

func spawn_shock_wave():
	var shock_wave: Shock_Wave = shock_wave_scene.instantiate()
	add_child(shock_wave)
	shock_wave.ring_growth = ring_growth_speed
	shock_wave.global_position = global_position
	shock_wave.global_rotation = global_rotation
	print("repeating timer started")


func _on_initial_wait_timer_timeout() -> void:
	spawn_shock_wave()
	$"Repating Shock Wave Timer".start()
	print("init timer ended")

func _on_trigger(active: bool):
	if active:
		$"Repating Shock Wave Timer".stop()
	else:
		$"Repating Shock Wave Timer".start()
