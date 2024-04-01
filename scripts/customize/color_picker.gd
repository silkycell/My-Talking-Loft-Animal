extends ColorPicker

@onready var loop_sfx = $LoopSFX

var last_color:Color
var mouse_is_down:bool = false

func _ready():
	last_color = color
	modulate = Color.TRANSPARENT
	hide()

func _process(_delta):
	if color.s == 0:
		color.s = 0.0001
	
	if mouse_is_down:
		if color.v - last_color.v != 0 || color.s - last_color.s != 0:
			if !loop_sfx.playing || loop_sfx.stream != preload("res://sounds/change_value.wav"):
				loop_sfx.stream = preload("res://sounds/change_value.wav")
				loop_sfx.volume_db = 0
				loop_sfx.play()
		elif color.h - last_color.h != 0:
			if !loop_sfx.playing || loop_sfx.stream != preload("res://sounds/change_hue.wav"):
				loop_sfx.stream = preload("res://sounds/change_hue.wav")
				loop_sfx.volume_db = -3
				loop_sfx.play()
	
	last_color = color

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 && event.pressed == false:
			mouse_is_down = false
			loop_sfx.stop()
		else:
			mouse_is_down = true
