extends TextureRect

@onready var audio_stream_player = $AudioStreamPlayer
@onready var color_rect = $"../ColorRect"

func _ready():
	Save.load_data()
	OS.request_permissions()
	
	hide()
	await get_tree().create_timer(1).timeout
	show()
	audio_stream_player.play()
	await get_tree().create_timer(1).timeout
	hide()
	color_rect.color = Color.BLACK
	color_rect.modulate = Color.TRANSPARENT
	
	var tween = create_tween()
	tween.tween_property(color_rect, "modulate", Color.WHITE, 0.3)
	await tween.finished
	await get_tree().create_timer(0.3).timeout
	
	if !Save.data.get("has_played", false):
		get_tree().change_scene_to_file("res://main_scenes/title.tscn")
	else:
		get_tree().change_scene_to_file("res://main_scenes/main.tscn")
