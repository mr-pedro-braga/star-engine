extends __GameplayCoreBase
class_name DialogCutsceneCore, "res://core/scripts/icons/icon_event_dialogue.svg"

var is_in_cutscene
signal cutscene_started
signal cutscene_finished

var is_in_dialog
signal dialog_requested
signal dialog_finished

export(NodePath) var dialog_box_path
onready var dialog_box: SmartRichTextLabel = get_node(dialog_box_path)

func dialog( pool : SSObject, key : String ):
	var pd = pool.data
	if pd.data.has(key):
		_dialog_from_SSON(pd.data[key])
	else:
		Shell.print_err("Invalid Dialog Key", "The provided key \""+key+"\" does not exist within the given dialog pool.")

func _dialog_from_SSON( ssobj ):
	Shell.execute_block( ssobj.content )
