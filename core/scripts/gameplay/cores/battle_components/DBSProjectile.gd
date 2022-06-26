#########################################
#										#
#		Projectile Class				#
#			by Pedro Braga				#
#										#
#	Spawned from a Pattern, a bullet 	#
#	that moves on the board.			#
#										#
#########################################

extends Node2D
class_name DBSProjectile

signal on_destroy()

var active := false

var initial_position = Vector2.ZERO
var battle_board_center : Vector2 = Vector2.ZERO
var battle_board_size : Vector2 = Vector2(128, 128)

var velocity := Vector2.ZERO
var acceleration := Vector2.ZERO
var maximum_speed := 2048
var lifetime := 4.0

var pattern_parent
var dt := 0.0

var tick_index : int = 0
var time : float = 0.0
var index : int = 0

func start():
	active = true

func _physics_process(delta):
	dt = delta
	
	if active:
		_tick()
		time += delta
		tick_index += 1

# OVERRIDE this function with the particle's behaviour.
func _tick():
	pass

func _draw():
	draw_rect(
		Rect2(
			Vector2(-16, -16),
			Vector2(32, 32)
		),
		Color.WHITE,
		true,
		1.0
	)

#
#	Useful API Methods for quickly arranging a behaviour!
#

func do_velocity(delta=dt*pattern_parent.time_scale):
	position += velocity * delta
	velocity = velocity.limit_length(maximum_speed)

func do_acceleration(delta=dt*pattern_parent.time_scale):
	velocity += acceleration * delta

func do_lifetime():
	if (time > lifetime):
		on_destroy.emit()
		queue_free()

func accelerate(vector, delta=dt*pattern_parent.time_scale):
	velocity += vector * delta

func circ(angle): return Vector2(cos(angle), sin(angle))
