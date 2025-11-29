class_name Shock_Wave
extends Node3D

@onready var csg_torus: CSGTorus3D = $CSGTorus
@export var ring_growth: float = 0.05
@export var random_colors: Array[Color]
@export var no_time_out: bool = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.audio_tick.connect(change_color)
	change_color()
	
	# instancing a shockwave, to avoid lag when it's instanced later (shader compilation)
	if no_time_out:
		$CSGTorus.use_collision = false
		$Timer.stop()
		hide()

func _physics_process(delta: float) -> void:
	if not no_time_out:
		csg_torus.inner_radius += ring_growth * delta
		csg_torus.outer_radius += ring_growth * delta

func change_color():
	var color: Color = random_colors[randi() % random_colors.size()]
	var material = $CSGTorus.material
	if not material:
		material = Material.new()
		$CSGTorus.material  = material
	material.albedo_color = color

func _on_timer_timeout() -> void:
	call_deferred("queue_free")
