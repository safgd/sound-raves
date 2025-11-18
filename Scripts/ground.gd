class_name Ground
extends StaticBody3D
## Floor tiles randomly change to these colors
@export var random_colors: Array[Color]
## The color of marked floor tiles, the mode is 'MARKING_WHITE'
@export var marking_color: Color = Color(1.0, 1.0, 1.0, 1.0)
@export var marked_duration: float = 0.3
@export var mesh: Mesh
## If an uneven number is entered, it will be increased by one to become even.
@export var width: int = 18
# Called when the node enters the scene tree for the first time.
var multimesh: MultiMesh

var marked_tiles: Dictionary = {}

enum Mode{
	MARKING_WHITE,
	ACTIVATING
}

## MARKING_WHITE has no gameplay effect: All floor tiles are colored. ACTIVATING has gameplay impact, the player has to mark floor tiles to win.
@export var mode: Mode = Mode.ACTIVATING
## When mode is ACTIVATING, this option decides if the borders of the ground tiles should be pre-colored.
@export var colored_borders: bool = true
## When mode is ACTIVATING, this option decides if floor tiles around shock wave spawners should be pre-colored.
@export var pre_color_around_spawners: bool = true
## When mode is ACTIVATING, this option decides if how many floor tiles around shock wave spawners should be pre-colored.
@export var pre_color_extended: bool = true

func _ready():
	if width % 2 == 1:
		width += 1
	
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
			
			if mode == Mode.ACTIVATING:
				if not (x == 0 or x == width -1 or z == 0 or z == width -1) or not colored_borders:
					marked_tiles[counter] = 0
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
	#var x: int = floor(pos.x + 0.5 + width/2.0)
	#var z: int = floor(pos.z + 0.5 + width/2.0)
	#var i: int = x * width + z
	var i: int = pos_to_index(pos)
	
	match mode:
		Mode.MARKING_WHITE:
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
		
		Mode.ACTIVATING:
			if marked_tiles.has(i):
				marked_tiles.erase(i)
				
				var color: Color = random_colors[randi() % random_colors.size()]
				multimesh.set_instance_color(i, color)
				
				if marked_tiles.size() <= 0:
					print("won")
					$"../UI/Pause Menu"._on_home_button_pressed()
					get_tree().paused = true
			else:
				pass
	
	
func _on_marked_tile_timer_timeout(i: int):
	var timer: Timer = marked_tiles[i]
	marked_tiles.erase(i)
	timer.call_deferred("queue_free")

func notify_shock_wave_spawner_placement(pos: Vector3):
	if mode == Mode.ACTIVATING and pre_color_around_spawners:
		marked_tiles.erase(pos_to_index(pos))
		if pre_color_extended:
			marked_tiles.erase(pos_to_index(Vector3(pos.x-1, 0, pos.z)))
			marked_tiles.erase(pos_to_index(Vector3(pos.x+1, 0, pos.z)))
			marked_tiles.erase(pos_to_index(Vector3(pos.x, 0, pos.z-1)))
			marked_tiles.erase(pos_to_index(Vector3(pos.x, 0, pos.z+1)))

func pos_to_index(pos: Vector3) -> int:
	var x: int = floor(pos.x + 0.5 + width/2.0)
	var z: int = floor(pos.z + 0.5 + width/2.0)
	return x * width + z
