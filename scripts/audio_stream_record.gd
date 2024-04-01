extends AudioStreamPlayer

class_name AudioStreamRecord

const QUIET_TIMER_RESET:float = 1.3
var MIN_SILENCE_VOLUME:float = 30

@onready var audio_stream_player = $"../AudioStreamPlayer"

var record_effect:AudioEffectRecord
var spectrum_effect:AudioEffectSpectrumAnalyzerInstance
var recording:AudioStreamWAV

var can_record:bool = true:
	set(value):
		if can_record == value: return
		
		if !value && is_recording:
			_stop_recording(false)
		
		can_record = value

var is_recording:bool = false

var quiet_timer:float = QUIET_TIMER_RESET
var loud_timer:float

func _ready():
	var idx = AudioServer.get_bus_index("Record")
	record_effect = AudioServer.get_bus_effect(idx, 0)
	spectrum_effect = AudioServer.get_bus_effect_instance(idx, 1)
	
	MIN_SILENCE_VOLUME = Save.data.get("min_silence_volume", 18)

func _process(delta):
	if !can_record: return
	var microphone_volume = spectrum_effect.get_magnitude_for_frequency_range(0, 10000).length() * 1000
	
	if quiet_timer < 0 && is_recording:
		is_recording = false
		_stop_recording()
		quiet_timer = QUIET_TIMER_RESET
	else:
		if is_recording:
			if microphone_volume < MIN_SILENCE_VOLUME:
				quiet_timer -= delta
		elif microphone_volume > MIN_SILENCE_VOLUME && !audio_stream_player.playing:
			is_recording = true
			record_effect.set_recording_active(true)

func _stop_recording(play_recording:bool = true):
	recording = record_effect.get_recording()
	record_effect.set_recording_active(false)
	
	if play_recording:
		audio_stream_player.stream = trim_audio(recording, QUIET_TIMER_RESET / 2)
		audio_stream_player.play()

func trim_audio(original: AudioStreamWAV, trim_duration: float) -> AudioStreamWAV:
	# Get original WAV data
	var original_data:PackedByteArray = original.get_data()

	# Calculate the new size of the WAV data after trimming
	var sample_rate: int = original.get_mix_rate()
	var bytes_per_sample: int = original.get_format() * 2
	var bytes_per_second: int = sample_rate * bytes_per_sample
	var trim_bytes: int = int(trim_duration * bytes_per_second)
	var new_size: int = original_data.size() - trim_bytes

	# Create a new PoolByteArray for the trimmed WAV data
	var trimmed_data:PackedByteArray = PackedByteArray()
	trimmed_data.resize(new_size)

	# Copy the trimmed audio data
	for i in range(new_size):
		trimmed_data[i] = original_data[i]

	# Create a new AudioStreamWAV with the trimmed data
	var trimmed_wav = AudioStreamWAV.new()
	trimmed_wav.set_data(trimmed_data)
	trimmed_wav.set_mix_rate(sample_rate)
	trimmed_wav.set_format(original.get_format())
	trimmed_wav.set_stereo(original.stereo)

	return trimmed_wav
