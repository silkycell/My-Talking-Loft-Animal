extends TextureRect

@onready var audio_stream_player = $AudioStreamPlayer

func _ready():
	hide()

func _on_title_tapped_screen():
	show()
	audio_stream_player.play()
