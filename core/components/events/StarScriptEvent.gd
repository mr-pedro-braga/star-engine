extends __EventBase
class_name StarScriptEvent

@export var event_pool : Resource
@export var event_key : String = ""

func _input(event):
	if Input.is_action_just_pressed("ui_fullscreen"):
		await get_tree().process_frame
		await Shell.execute_block(event_pool.data[event_key].content)
