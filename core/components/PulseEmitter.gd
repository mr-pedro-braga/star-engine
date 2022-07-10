extends Node2D
class_name PulseEmitter

func _input(event):
	if Input.is_action_just_pressed("sightless_scan"):
		var ear = get_viewport().get_camera_2d().global_position - global_position
		var p = Pulse.new()
		add_child(p)
		p.global_position = get_viewport().get_camera_2d().global_position
