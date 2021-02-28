extends AnimatedSprite


export(float, 0.1, 10000) var speed_in_one_second = 60

var path_to_follow := PoolVector2Array() setget path_setter
var current_rotation = 0

onready var root = get_tree().get_root()
onready var scene_root = root.get_child(root.get_child_count()-1)
onready var tween = scene_root.get_node("Tween") as Tween
onready var line = scene_root.get_node("Line2D")


# Gets called everytime the variable `path_to_follow` is set to a new value
func path_setter(new_val) -> void:
	path_to_follow = new_val
	if new_val.size() == 0:
		return
	tween.stop_all()
	animate_player()


func animate_player() -> void:
	tween_player_position()
	rotate_player()
		

func rotate_player() -> void:
	var final_angle = rad2deg(get_angle_to(path_to_follow[0]))
	current_rotation += final_angle - current_rotation
	if current_rotation < 45 and current_rotation > -45:
		play("right")
		flip_h = false
	elif current_rotation > 135 or current_rotation < -135:
		play("right")
		flip_h = true
	elif current_rotation < 135 and current_rotation > 45:
		play("down")
	elif current_rotation < -45 or current_rotation > -135:
		play("up")


func tween_player_position() -> void:
	var duration = path_to_follow[0].distance_to(get_global_position())/speed_in_one_second
	tween.interpolate_property(self, "position",
		get_global_position(),path_to_follow[0], duration,Tween.TRANS_LINEAR)
	tween.start()


func _on_Tween_tween_completed(obj, key) -> void:
	if obj == self and "position" in str(key):
		if path_to_follow.size() != 0:
			path_to_follow.remove(0)
		if path_to_follow.size() == 0: # Checks if array is empty after removing
			stop()
			return
		animate_player()
