extends Node

var data:Dictionary = {
	"color": "#FFFFFF",
	"has_played": false,
	"min_silence_volume": 30
}

func _ready():
	load_data()

func load_data():
	var save_json = FileAccess.open("user://savedata.json", FileAccess.READ)
	if save_json == null: return
	data = JSON.parse_string(save_json.get_as_text())

func save_data():
	var save_json = FileAccess.open("user://savedata.json", FileAccess.WRITE)
	save_json.store_line(JSON.stringify(data))
