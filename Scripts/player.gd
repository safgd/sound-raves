class_name Player
extends CharacterBody3D

signal damaged

@export_category("Stats")
@export var max_health: int = 3
@export var start_health: int = -1
@export var speed: float = 5.0
@export var jump_velocity: float = 4.5
@export var orientation_speed: float = 20.0
@onready var invulnerability_timer: Timer = $"Invulnerability Timer"

@export_category("Game Juice")
@export var shake_ammount: float = 0.2
@export var shake_duration: float = 0.2

@export_category("Setup")
@export var game_ui: Game_UI

var original_scale: Vector3

var current_health: int:
	set(value):
		current_health = value
		game_ui.update_health_label(value)
	get():
		return current_health

var coin_count: int = 0:
	set(value):
		coin_count = value
		game_ui.update_coin_count_label(value)
	get():
		return coin_count

var touching_shockwave: bool = false:
	set(value):
		if value and not touching_shockwave:
			hurt_player()
			invulnerability_timer.start()
		touching_shockwave = value
	get():
		return touching_shockwave

func _ready() -> void:
	if start_health > 0:
		current_health = start_health
	else:
		current_health = max_health
	original_scale = $MeshInstance3D.scale

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		$"Ground Check Raycast".enabled = true
		$"Ground Check Raycast".force_raycast_update()
		var collider = $"Ground Check Raycast".get_collider()
		if collider and collider is Ground:
			collider.overwrite_tile_color(global_position, true)
		$"Ground Check Raycast".enabled = false

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		perform_jump(jump_velocity)

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

	# orient player mesh torwards input direction
	if direction != Vector3.ZERO:
		var target_rotation_y: float = atan2(direction.x, direction.z)
		$MeshInstance3D.rotation.y = lerp_angle($MeshInstance3D.rotation.y, target_rotation_y, orientation_speed * delta)

	move_and_slide()
	
	if touching_shockwave and invulnerability_timer.is_stopped():
		hurt_player()
		invulnerability_timer.start()
	
	if global_position.y < -5.0:
		hurt_player(5)

func perform_jump(jump_vel: float, mute_player_jump_sound: bool = false):
	velocity.y = jump_vel
	shake_player_mesh(4.0)
	if not mute_player_jump_sound:
		AudioManager.play_jump_sound()

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

func get_collected(type: Collectable.Type):
	match type:
		Collectable.Type.COIN:
			pass
		Collectable.Type.HEALTH:
			heal_player(1)

func shake_player_mesh(factor: float = 1.0):
	var mesh: MeshInstance3D = $MeshInstance3D
	var tween: Tween = create_tween().set_ease(Tween.EaseType.EASE_IN_OUT)
	tween.tween_property(mesh, "scale:y", original_scale.y + shake_ammount * factor, shake_duration / 4.0)
	tween.tween_property(mesh, "scale:y", original_scale.y - shake_ammount * factor, shake_duration / 2.0)
	tween.tween_property(mesh, "scale:y", original_scale.y, shake_duration / 4.0)

func _on_steps_timer_timeout() -> void:
	if is_on_floor() and Vector3(velocity.x, 0.0, velocity.z).length() > 0.0:
		shake_player_mesh()
		AudioManager.play_step_sound()

func add_hat(hat: Shop_Item):
	hat.call_deferred("reparent",$Hats, false)
	hat.position = Vector3.ZERO
