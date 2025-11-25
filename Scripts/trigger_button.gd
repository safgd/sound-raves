extends StaticBody3D

signal trigger(active: bool)

enum Type{
	ONE_WAY,
	TEMPORARY,
	ON_STAY
}

@export var type: Type = Type.ONE_WAY
@export var timer_wait_time: float = 2.0
var pushed: bool = false

func reset():
	pushed = false
	$Area3D/MeshInstance3D.global_position.y += 0.2
	# play sound
	trigger.emit(pushed)
	print("untrigger")

func _on_area_3d_body_entered(body: Node3D) -> void:
	if pushed:
		return
	if body.is_in_group("Player"):
		pushed = true
		$Area3D/MeshInstance3D.global_position.y -= 0.2
		AudioManager.play_ingame_button_click_sound()
		trigger.emit(pushed)
		print("trigger")
		
		match type:
			Type.ONE_WAY:
				pass
			Type.TEMPORARY:
				pass 
			Type.ON_STAY:
				pass
		
func _on_area_3d_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		match type:
			Type.ONE_WAY:
				pass
			Type.TEMPORARY:
				$Timer.wait_time = timer_wait_time
				$Timer.start()
			Type.ON_STAY:
				reset()


func _on_timer_timeout() -> void:
	reset()
