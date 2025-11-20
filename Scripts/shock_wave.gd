class_name Shock_Wave
extends Node3D

@onready var csg_torus: CSGTorus3D = $CSGTorus
@export var ring_growth: float = 0.05
@export var random_colors: Array[Color]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	AudioManager.audio_tick.connect(change_color)
	change_color()

func _physics_process(delta: float) -> void:
	
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
