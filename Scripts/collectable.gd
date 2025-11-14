class_name Collectable
extends Area3D

enum Type{
	COIN
}

@export var type: Type

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		body.get_collected(type)
		match type:
			Type.COIN:
				AudioManager.play_coin_sound()
		call_deferred("queue_free")
