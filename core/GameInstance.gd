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

var window_mode_before_fullscreen := Window.MODE_MINIMIZED

func _input(ev):
	if Input.is_action_just_pressed("ui_fullscreen"):
		var w := get_tree().root
		if w.mode == Window.MODE_FULLSCREEN:
			w.mode = window_mode_before_fullscreen
		else:
			window_mode_before_fullscreen = w.mode
			w.mode = Window.MODE_FULLSCREEN
