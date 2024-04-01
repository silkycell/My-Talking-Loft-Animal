extends Sprite2D

const IDLE_LONG_TIMER_RESET:float = 10

@onready var animation_player = $AnimationPlayer
@onready var audio_stream_record = $AudioStreamRecord
@onready var hit_sfx = $HitSFX

var spectrum_effect:AudioEffectSpectrumAnalyzerInstance

var idle_long_timer:float = IDLE_LONG_TIMER_RESET

var can_play_normal_idle:bool = true
var is_being_hit:bool = false:
	set(value):
		audio_stream_record.can_record = value
		is_being_hit = value

func _ready():
	modulate = Color.from_string(Save.data.color, Color.WHITE)
	
	var idx = AudioServer.get_bus_index("Voice")
	spectrum_effect = AudioServer.get_bus_effect_instance(idx, 1)
	
	animation_player.get_animation("IdleLong").loop_mode = 0
	animation_player.get_animation("FaceHit").loop_mode = 0
	animation_player.get_animation("BellyHit").loop_mode = 0
	animation_player.get_animation("LegHit").loop_mode = 0
	
	animation_player.get_animation("IdleLong").length = 0.85
	
	animation_player.animation_finished.connect(func(anim_name):
		if anim_name == "IdleLong":
			can_play_normal_idle = true
			animation_player.play("Idle")
		elif anim_name.find("Hit") != -1:
			is_being_hit = false
			audio_stream_record.can_record = true
	)

func _process(delta):
	if is_being_hit: return
	
	if audio_stream_record.is_recording:
		animation_player.play("Listen")
	elif audio_stream_record.audio_stream_player.playing:
		var volume = spectrum_effect.get_magnitude_for_frequency_range(0, 10000).length() * 150
		animation_player.play("Talk" + str(clampi(round(volume), 0, 3)))
	else:
		if idle_long_timer <= 0:
			animation_player.play("IdleLong")
			idle_long_timer = IDLE_LONG_TIMER_RESET
			can_play_normal_idle = false
		elif can_play_normal_idle:
			idle_long_timer -= delta
			animation_player.play("Idle")

func _input(event):
	if event is InputEventMouseButton && event.button_index == 1 && event.pressed:
		var mouse_pos = get_viewport().get_mouse_position()
		var is_inside_sprite = get_rect().has_point(to_local(mouse_pos))
		
		if is_inside_sprite:
			animation_player.stop()
			if mouse_pos.y >= 543:
				hit_sfx.stream = preload("res://sounds/leg_hit.wav")
				animation_player.play("LegHit")
			elif mouse_pos.y >= 487:
				hit_sfx.stream = preload("res://sounds/belly_hit.wav")
				animation_player.play("BellyHit")
			else:
				hit_sfx.stream = preload("res://sounds/face_hit.wav")
				animation_player.play("FaceHit")
			
			hit_sfx.play()
			is_being_hit = true
