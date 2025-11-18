class_name Collectable
extends Area3D

signal collected

enum Type{
	COIN,
	HEALTH
}

@export var type: Type

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		collected.emit()
		body.get_collected(type)
		match type:
			Type.COIN:
				AudioManager.play_coin_sound()
			Type.HEALTH:
				pass # add sound later
		call_deferred("queue_free")
