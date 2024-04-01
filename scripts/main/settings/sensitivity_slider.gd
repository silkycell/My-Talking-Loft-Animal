extends HSlider

@export var audio_stream_record:AudioStreamRecord

func _ready():
	value = audio_stream_record.MIN_SILENCE_VOLUME

func _on_drag_ended(has_value_changed):
	if has_value_changed:
		audio_stream_record.MIN_SILENCE_VOLUME = value
		Save.data.min_silence_volume = audio_stream_record.MIN_SILENCE_VOLUME
