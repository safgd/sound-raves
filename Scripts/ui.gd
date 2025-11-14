extends CanvasLayer

@onready var fps_label: Label = $"FPS Label"

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	fps_label.text = str(Engine.get_frames_per_second()) + " fps"
