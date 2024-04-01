extends Button

@onready var settings_menu = $"../SettingsMenu"

func _on_pressed():
	settings_menu.visible = !settings_menu.visible
	
	if !settings_menu.visible:
		Save.save_data()
