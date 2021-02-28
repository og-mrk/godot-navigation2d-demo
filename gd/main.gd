extends Node2D


onready var nav_2d = $Navigation2D as Navigation2D
onready var player = $Player as AnimatedSprite
onready var line_2d = $Line2D as Line2D


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseButton:
		return
	elif event.button_index == BUTTON_LEFT and event.is_pressed():
		# Both Player and Mouse are in global coordinates
		var mouse_pos = self.get_global_mouse_position()
		var player_pos = player.get_global_position()
		var new_path = nav_2d.get_simple_path(player_pos, mouse_pos)
		line_2d.points = new_path
		player.path_to_follow = new_path
		
