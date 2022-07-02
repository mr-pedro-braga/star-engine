#########################################
#										#
#		Pattern Class					#
#			by Pedro Braga				#
#										#
#	Handles a generic battle pattern 	#
#	for the battles.					#
#										#
#########################################

extends Node2D
class_name DBSPattern

var has_timeout := false
var timeout := 6

signal finished

@export var tick_index := 0
@export_range(0.1, 0.5, 0.1) var tick_rate  := 0.2
@export_range(0.0, 2.0, 0.1) var time_scale := 1
var projectile_count := 0

@onready var _tick_timer = _make_tick_timer()
@onready var _timeout_timer = _make_timeout_timer()

@export var autostart := true

func _ready(): if autostart: start()

func start():
	_tick_timer.start()
	if has_timeout:
		_timeout_timer.start()

func stop():
	_tick_timer.stop()
	finished.emit()
	visible = false
	queue_free()

func spawn (_what, where:Vector2):
	var object = _what
	
	# If object is a Packed Scene, unpack it first!
	if object is PackedScene: object = object.instantiate()

	# Spawn Projectile
	if object is DBSProjectile:
		object.index = projectile_count
		projectile_count += 1
		object.initial_position = where
		object.global_position = where
		object.pattern_parent = self
		object.start()
		add_child(object)
	
	return object

func tick() -> void:
	tick_index += 1
	_tick()

# Virtual tick function to be implemented
func _tick() -> void:
	pass

func _make_tick_timer():
	var timer = Timer.new()
	
	timer.wait_time = tick_rate
	timer.timeout.connect(tick)
	add_child(timer)
	
	return timer
	
func _make_timeout_timer():
	var timer = Timer.new()
	
	timer.wait_time = timeout
	timer.timeout.connect(stop)
	add_child(timer)
	
	return timer
