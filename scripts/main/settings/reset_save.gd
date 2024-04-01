extends Button


func _on_pressed():
	var save_dir = DirAccess.open("user://")
	save_dir.remove("savedata.json")
	get_tree().quit()
