extends ColorRect

func _ready():
	show()
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.TRANSPARENT, 0.3)
	tween.finished.connect(queue_free)
