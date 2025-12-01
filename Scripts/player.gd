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
@export var stomp_speed: float = 12.0

@export_category("Game Juice")
@export var shake_ammount: float = 0.2
@export var shake_duration: float = 0.2
@export var hurt_material: StandardMaterial3D
@export var squash_duration: float = 0.05
## 0.5 equals dividing the player height by 2
@export var squash_ammount: float = 0.6
@export var expand_ammount: float = 1.2
var squash_tween: Tween

@export_category("Setup")
@export var game_ui: Game_UI

@export_category("Mouth Symbols")
@export var mouth_default: String = "__"
@export var mouth_happy: String = "U"
@export var mouth_surprised: String = "M"
@export var mouth_jump: String = "O"

var original_scale: Vector3

enum State{
	DEFAULT,
	STOMPING,
	STOMP_ENDLAG
}

var state: State = State.DEFAULT

var current_health: int:
	set(value):
		current_health = value
		game_ui.update_health_label(value)
	get():
		return current_health

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
		if state == State.DEFAULT:
			velocity += get_gravity() * delta
		elif state == State.STOMPING:
			velocity.y = -stomp_speed
	else:
		$"Ground Check Raycast".enabled = true
		$"Ground Check Raycast".force_raycast_update()
		var collider = $"Ground Check Raycast".get_collider()
		if collider:
			if collider is Ground:
				if state == State.DEFAULT:
					collider.overwrite_tile_color(global_position, true)
				elif state == State.STOMPING:
					collider.notify_circle_marking(global_position)
			#elif collider is Jump_Pad:
				#if state == State.DEFAULT:
					#pass
				#elif state == State.STOMPING:
					#pass
		$"Ground Check Raycast".enabled = false
		if state == State.STOMPING:
			#state = State.DEFAULT
			state = State.STOMP_ENDLAG
			squash_player_size()
			$"Stomp Endlag Timer".start()
			$"Spark Particles".global_position = Vector3(global_position.x, global_position.y-0.5, global_position.z)
			$"Spark Particles".emitting = true
			AudioManager.stop_stomp_sound()
			AudioManager.play_stomp_landing_sound()

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor():
			perform_jump(jump_velocity)
		else:
			perform_stomp()
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if state == State.DEFAULT and direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
		$"Smoke Particles".emitting = is_on_floor()
			
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		$"Smoke Particles".emitting = false

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
	$"MeshInstance3D/Mouth Label".text = mouth_jump
	$"Mouth Reset Timer".start()
	velocity.y = jump_vel
	shake_player_mesh(4.0)
	if not mute_player_jump_sound:
		AudioManager.play_jump_sound()

func perform_stomp():
	state = State.STOMPING
	AudioManager.play_stomp_sound()
	thin_out_player_size()
	pass

func hurt_player(damage: int = 1):
	AudioManager.play_damaged_sound()
	damaged.emit()
	current_health -= damage
	$MeshInstance3D.set_surface_override_material(0, hurt_material)
	$"MeshInstance3D/Mouth Label".text = mouth_surprised
	$"Mouth Reset Timer".start()
	if current_health <= 0:
		AudioManager.play_loose_sound()
		get_tree().call_deferred("reload_current_scene")

func heal_player(ammount: int = 1):
	current_health = clampi(current_health+ammount, 0, max_health)

func _on_shockwave_entered(_body: Node3D) -> void:
	touching_shockwave = true

func _on_shockwave_exited(_body: Node3D) -> void:
	touching_shockwave = false

func get_collected(type: Collectable.Type, ammount: float):
	$"MeshInstance3D/Mouth Label".text = mouth_happy
	$"Mouth Reset Timer".start()
	match type:
		Collectable.Type.COIN:
			pass
		Collectable.Type.HEALTH:
			heal_player(int(ammount))

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


func _on_invulnerability_timer_timeout() -> void:
	$MeshInstance3D.set_surface_override_material(0, null)

func thin_out_player_size():
	if squash_tween:
		squash_tween.stop()
	squash_tween = get_tree().create_tween()
	squash_tween.tween_property($MeshInstance3D, "scale", Vector3(squash_ammount, expand_ammount, squash_ammount), squash_duration)
	
func squash_player_size():
	squash_tween.stop()
	squash_tween = get_tree().create_tween()
	squash_tween.tween_property($MeshInstance3D, "scale", Vector3(expand_ammount, squash_ammount, expand_ammount), squash_duration)

func _on_stomp_endlag_timer_timeout() -> void:
	$"Stomp Endlag Timer".stop()
	state = State.DEFAULT
	squash_tween.stop()
	var reset_size_tween: Tween = get_tree().create_tween()
	reset_size_tween.tween_property($MeshInstance3D, "scale", Vector3(1.0, 1.0, 1.0), squash_duration)


func _on_mouth_reset_timer_timeout() -> void:
	$"MeshInstance3D/Mouth Label".text = mouth_default
