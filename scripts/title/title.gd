extends Control

var has_tapped:bool = false

signal tapped_screen

func _on_gui_input(event):
	if has_tapped: return
	if event is InputEventMouseButton:
		if event.button_index == 1 && event.pressed == true:
			has_tapped = true
			tapped_screen.emit()

func _on_cat_finished_animation():
	var tween = create_tween()
	tween.set_ease(Tween.EASE_IN)
	tween.set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self, "position", position - Vector2(0, size.y), 2)
	await tween.finished
	await get_tree().create_timer(1).timeout
	
	get_tree().change_scene_to_file("res://main_scenes/customize.tscn")
