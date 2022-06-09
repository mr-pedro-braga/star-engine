#########################################
#										#
#		Game Core Class 1.0.0			#
#			by Pedro Braga				#
#										#
#	Handles the states and singletons 	#
#	for the engine.						#
#										#
#########################################

extends Node

##################### SINGLETONS #####################

var Audio : AudioCore
var DC : DialogCutsceneCore
var Data : DataCore

##################### STATES #####################

var States = {
	"Overworld" 	: null,
	"Battle" 		: null,
	"Minigame" 		: null,
}

var _current_state : String
signal state_changed(state)

func set_state( state : String ):
	_current_state = state
	emit_signal("state_changed", state)

func get_state() -> String:
	return _current_state

func process_states():
	(States[_current_state] as __GameplayStateBase)._update()

##################### MAIN FUNCTIONS #####################

func _input(ev):
	# Handle fullscreen in desktops!
	if ev is InputEventKey:
		if ev.pressed and (ev.scancode == KEY_F4 or ev.scancode == KEY_F11):
			OS.window_fullscreen = not OS.window_fullscreen

##################### CUTE UNICODE ART #####################

#░░░░░░░▀▄░░░▄▀░░░░░░░░
#░░░░░░▄█▀███▀█▄░░░░░░░
#░░░░░█▀███████▀█░░░░░░
#░░░░░█░█▀▀▀▀▀█░█░░░░░░
#░░░░░░░░▀▀░▀▀░░░░░░░░░
