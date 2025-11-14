extends CharacterBody3D

signal damaged

@export var max_health: int = 3
@export var speed = 5.0
@export var jump_velocity = 4.5
@onready var invulnerability_timer: Timer = $"Invulnerability Timer"

var current_health: int

var touching_shockwave: bool = false:
	set(value):
		if value and not touching_shockwave:
			hurt_player()
			invulnerability_timer.start()
		touching_shockwave = value
	get():
		return touching_shockwave

func _ready() -> void:
	current_health = max_health

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_velocity
		AudioManager.play_jump_sound()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()
	
	if touching_shockwave and invulnerability_timer.is_stopped():
		hurt_player()
		invulnerability_timer.start()
		
func hurt_player(damage: int = 1):
	AudioManager.play_damaged_sound()
	damaged.emit()
	current_health -= damage
	if current_health <= 0:
		AudioManager.play_loose_sound()
		get_tree().call_deferred("reload_current_scene")

func heal_player(ammount: int = 1):
	current_health = clampi(current_health+ammount, 0, max_health)

func _on_shockwave_entered(_body: Node3D) -> void:
	touching_shockwave = true

func _on_shockwave_exited(_body: Node3D) -> void:
	touching_shockwave = false
