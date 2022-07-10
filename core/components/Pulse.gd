@tool
extends Node2D
class_name Pulse

func _process(delta):
	update()
	
	var max_radius = 128.
	if radius < max_radius:
		radius += 64. * delta
		modulate.a = 1. - radius / max_radius
	else:
		queue_free()

@export_range(0, 1024) var radius = 8.0

func _draw():
	draw_arc(Vector2.ZERO, radius, 0, TAU, 64, Color.CORNFLOWER_BLUE, 1)
