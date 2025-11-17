class_name Ground
extends StaticBody3D

@export var random_colors: Array[Color]
@export var marking_color: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var marked_duration: float = 0.3
@export var mesh: Mesh
@export var width: int = 18
# Called when the node enters the scene tree for the first time.
var multimesh: MultiMesh

var marked_tiles: Dictionary[int, Timer] = {}

func _ready():
	
	AudioManager.audio_tick.connect(change_tile_color)
	
	# MultiMesh erstellen
	multimesh = MultiMesh.new()
	multimesh.use_colors = true
	multimesh.mesh = mesh  # Mesh zuweisen
	multimesh.transform_format = MultiMesh.TRANSFORM_3D
	multimesh.instance_count = width * width
	multimesh.visible_instance_count = -1
	
	# Transformationsdaten setzen
	var counter: int = 0
	for x in range(width):
		for z in range(width):
			var mesh_transform = Transform3D(Basis(), Vector3(x-(width)/2.0, -0.49, z-(width)/2.0))  # Setze Position
			multimesh.set_instance_transform(counter, mesh_transform)
			counter += 1

	# MultiMeshInstance3D erstellen und zur Szene hinzufügen
	var multimesh_instance = MultiMeshInstance3D.new()
	multimesh_instance.multimesh = multimesh
	add_child(multimesh_instance)
	
	change_tile_color()
	
	$CollisionShape3D.shape.size = Vector3(width, 1.0, width)
	$CollisionShape3D/MeshInstance3D.mesh.size = Vector2(width, width)

func change_tile_color():
	for i in range(width*width):
		if not marked_tiles.has(i):
			var color: Color = random_colors[randi() % random_colors.size()]
			multimesh.set_instance_color(i, color)

func overwrite_tile_color(pos: Vector3):
	var x: int = floor(pos.x + 0.5 + width/2.0)
	var z: int = floor(pos.z + 0.5 + width/2.0)
	var i: int = x * width + z
	multimesh.set_instance_color(i, marking_color)
	if marked_tiles.has(i):
		marked_tiles[i].stop()
		marked_tiles[i].start()
	else:
		var timer: Timer = Timer.new()
		timer.name = "Timer " + str(i)
		add_child(timer)
		timer.wait_time = marked_duration
		timer.start()
		timer.timeout.connect(_on_marked_tile_timer_timeout.bind(i))
		marked_tiles[i] = timer

func _on_marked_tile_timer_timeout(i: int):
	var timer: Timer = marked_tiles[i]
	marked_tiles.erase(i)
	timer.call_deferred("queue_free")
