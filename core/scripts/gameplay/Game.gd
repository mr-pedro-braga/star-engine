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

func set_state( state : String ) -> void:
	_current_state = state
	emit_signal("state_changed", state)

func get_state() -> String:
	return _current_state

func process_states() -> void:
	(States[_current_state] as __GameplayStateBase)._update()

##################### MAIN FUNCTIONS #####################

func _input(ev) -> void:
	# Handle fullscreen in desktops!
	if ev is InputEventKey:
		if ev.pressed and (ev.keycode == KEY_F4 or ev.keycode == KEY_F11):
			pass
			#OS.window_fullscreen = not OS.window_fullscreen

##################### CUTE UNICODE ART #####################

func get_party() -> Array[Character]:
	return Data.data.party

func add_to_party(character : Character) -> void:
	if not Data.data.party.has(character):
		Data.data.party.append(character)

func remove_from_party(character : Character) -> void:
	Data.data.party.erase(character)

##################### CUTE UNICODE ART #####################

#░░░░░░░▀▄░░░▄▀░░░░░░░░
#░░░░░░▄█▀███▀█▄░░░░░░░
#░░░░░█▀███████▀█░░░░░░
#░░░░░█░█▀▀▀▀▀█░█░░░░░░
#░░░░░░░░▀▀░▀▀░░░░░░░░░
