extends Control
class_name GameInstance, "res://core/scripts/icons/icon_Game.svg"

@export var audio_core : Node
@export var dialog_cutscene_core : Node
@export var data_core : Node
@export var battle_core : Node

@export_file("*.ssh") var test_dialog

func _ready():
	Game.Audio = (audio_core)
	Game.Data = (data_core)
	Game.DC = (dialog_cutscene_core)
	Game.Battle = (battle_core)

	print(Game.Battle)
