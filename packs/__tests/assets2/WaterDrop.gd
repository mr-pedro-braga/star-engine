extends DBSProjectile
class_name ProjectileWaterDroplet

func _ready():
	velocity = Vector2.DOWN * 0
	acceleration = Vector2.DOWN * 2048
	lifetime = 1.0

func _tick():
	do_velocity(dt)
	do_acceleration(dt)
	do_lifetime()
