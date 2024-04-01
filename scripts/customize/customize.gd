extends Control

@onready var cat = $Cat
@onready var audio_stream_player = $AudioStreamPlayer
@onready var color_picker = $ColorPicker
@onready var label = $Label
@onready var music = $Music

func _ready():
	var base_position = cat.position
	cat.position.y -= 500
	
	audio_stream_player.play()
	
	var tween = create_tween()
	tween.set_ease(Tween.EASE_OUT)
	tween.set_trans(Tween.TRANS_BOUNCE)
	tween.tween_property(cat, "position", base_position, 1)
	
	await get_tree().create_timer(1.4).timeout
	color_picker.show()
	
	tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(color_picker, "modulate", Color.WHITE, 0.6)
	tween.tween_property(label, "modulate", Color.WHITE, 0.6)
	
	music.play()

func _on_color_picker_color_changed(color):
	cat.modulate = color

func _on_cat_pressed():
	if color_picker.visible:
		Save.data.color = color_picker.color.to_html(false)
		Save.data.has_played = true
		Save.save_data()
		FallApart.screenshot = ImageTexture.create_from_image(get_viewport().get_texture().get_image())
		get_tree().change_scene_to_packed(preload("res://main_scenes/main.tscn"))
