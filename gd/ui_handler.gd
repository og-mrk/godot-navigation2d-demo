extends CanvasLayer


onready var root = get_tree().get_root() as Viewport
onready var scene_root = root.get_child(root.get_child_count()-1)
onready var world_cam = scene_root.get_node("Camera2D")
onready var player = scene_root.get_node("Player")
onready var player_cam = player.get_node("Camera2D")
onready var ui_tween = $UITween
onready var info_label = $Info


func _ready() -> void:
	world_cam._set_current(false)
	player_cam._set_current(true)
	tween_label()


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventMouseMotion:
		if event.is_action_pressed("ui_focus_next"):
			_on_SwitchView_pressed()


func tween_label() -> void:
	ui_tween.interpolate_property(info_label, "modulate:a",
			null, 0.3, 3.0, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	yield(get_tree().create_timer(5.0), "timeout")
	ui_tween.start()
	yield(get_tree().create_timer(ui_tween.get_runtime()), "timeout")
	info_label.hide()



func _on_SwitchView_pressed() -> void:
	if player_cam.is_current():
		player_cam._set_current(false)
		world_cam.position = player.global_position
		world_cam._set_current(true)
		get_node("SwitchView").text = "Switch to player view"
	else:
		player_cam._set_current(true)
		world_cam._set_current(false)
		get_node("SwitchView").text = "Switch to world view"
