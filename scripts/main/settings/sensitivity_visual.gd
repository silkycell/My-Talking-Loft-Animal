extends HSlider

@export var audio_stream_record:AudioStreamRecord

func _process(_delta):
	value = audio_stream_record.spectrum_effect.get_magnitude_for_frequency_range(0, 10000).length() * 1000
