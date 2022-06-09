extends Control
class_name GameInstance, "res://core/scripts/icons/icon_Game.svg"

export(NodePath) var audio_core
export(NodePath) var dialog_cutscene_core
export(NodePath) var data_core

export(String, FILE, "*.ssh") var test_dialog

func _ready():
	Game.Audio = get_node(audio_core)
	Game.Data = get_node(data_core)
	Game.DC = get_node(dialog_cutscene_core)
