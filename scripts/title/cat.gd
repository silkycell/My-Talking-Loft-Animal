extends TextureRect

@onready var audio_stream_player = $AudioStreamPlayer
@onready var speech_bubble = $SpeechBubble

signal finished_animation

func _ready():
	position = Vector2(144, 262)
	hide()

func _on_title_tapped_screen():
	await get_tree().create_timer(1.5).timeout
	show()
	
	audio_stream_player.stream = preload("res://sounds/jump.mp3")
	audio_stream_player.volume_db = -10
	audio_stream_player.play()
	
	var jump_time:float = 1
	
	var scale_tween = create_tween()
	scale_tween.tween_property(self, "scale", Vector2(5, 5), jump_time)
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", Vector2(144, 100), jump_time / 2)
	await tween.finished
	
	reparent($"../..", false)
	
	tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_SINE)
	tween.tween_property(self, "position", Vector2(186, 550), jump_time / 2)
	await tween.finished
	
	var base_pos = position
	
	tween = create_tween()
	tween.tween_method(func(val):
		position = base_pos + Vector2(randf_range(-val, val), randf_range(-val, val))
	, 5.0, 0.0, 0.25)
	
	audio_stream_player.stream = preload("res://sounds/snd_impact_ch1.wav")
	audio_stream_player.volume_db = 0
	audio_stream_player.play()
	
	await get_tree().create_timer(1).timeout
	
	speech_bubble.i_say.connect(func():
		position = base_pos + Vector2(0, -2)
	)
	speech_bubble.i_no_say.connect(func():
		position = base_pos
	)
	
	speech_bubble.say("It's Lofty Time")
	
	await get_tree().create_timer(1).timeout
	
	finished_animation.emit()
