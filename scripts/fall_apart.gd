extends TextureRect
class_name FallApart

static var screenshot:Texture2D
@onready var wall = $SubViewport/wall
@onready var audio_stream_player = $AudioStreamPlayer
@onready var fade = $"../Fade"

func _ready():
	if screenshot != null:
		fade.modulate = Color.TRANSPARENT
		show()
		var wall_material:BaseMaterial3D = wall.get_child(1).mesh.surface_get_material(0)
		wall_material.albedo_texture = screenshot
		
		wall.get_node("AnimationPlayer").play("Scene")
		audio_stream_player.play()
		await get_tree().create_timer(3).timeout
	
	queue_free()
