extends Control
class_name GameInstance, "res://core/scripts/icons/icon_Game.svg"

@export_node_path var audio_core
@export_node_path var dialog_cutscene_core
@export_node_path var data_core

@export_file("*.ssh") var test_dialog

func _ready():
	Game.Audio = get_node(audio_core)
	Game.Data = get_node(data_core)
	Game.DC = get_node(dialog_cutscene_core)
