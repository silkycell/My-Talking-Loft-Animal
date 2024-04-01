extends NinePatchRect

@onready var label = $Label
@onready var audio_stream_player = $AudioStreamPlayer

signal i_say
signal i_no_say

func _ready():
	hide()

func say(text:String):
	show()
	
	label.visible_characters = 0
	label.text = text
	
	for i in range(0, label.text.length()):
		label.visible_characters += 1
		audio_stream_player.play()
		i_say.emit()
		await get_tree().create_timer(0.02).timeout
		i_no_say.emit()
		await get_tree().create_timer(0.015).timeout
