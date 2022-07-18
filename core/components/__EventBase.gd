extends Area2D
class_name __EventBase
@icon("res://addons/builtin/star_events/icon_event.png")

enum TriggerCondition {
	ON_TOUCH, ON_INTERACT, ON_SCENE_START, EVERY_TICK
}

@export var trigger_condition : TriggerCondition

func _ready():
	area_entered.connect(on_area_enter)
	area_exited.connect(on_area_exit)

var areas : Array[EventProber] = []

func on_area_enter(area):
	if area is EventProber:
		areas.push_back(area)
		
		if trigger_condition == TriggerCondition.ON_TOUCH:
			_trigger()

func _input(ev):
	if not trigger_condition == TriggerCondition.ON_INTERACT:
		return
	if Input.is_action_just_pressed("OK") and areas.size() > 0:
		_trigger()

func on_area_exit(area):
	if area is EventProber:
		areas.erase(area)

func _trigger():
	print("aaaaaaaaaaa")
	pass
