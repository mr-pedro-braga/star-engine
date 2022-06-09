tool
extends Node
class_name Menu

signal on_index_changed(index)
signal on_selected(index)
signal on_updated()
signal on_cancel

var is_active : bool # Whether this menu is being used (should be visible) at the moment.
var is_current : bool # Whether this menu is supposed to be interacted with.
var has_open_submenu : bool # If this menu is waiting for the response of a submenu.

export var current_index := 1:
	set(v):
		current_index = clamp(v, 0, max_index)
export var wrap_index := false
export var choices := [Choice1, Choice2, Choice3]
export var choices_count := 3
var _open_submenu : Menu

func select(index):
	current_index = clamp(index, 0, max_index)

func ok():
	if choices[current_index] is Menu:
		pass
	print("Selected ", choices[current_index])

func cancel():
	print("Cancel")

func accept():
	print("Accept")

func from_array(array):
	choices = array
	max_index = array.size()
	current_index =0

func insert(node, position):
	choices.insert(node, position)
	max_index = choices.size() - 1

func remove(index):
	choices.remove(choices[index])
	max_index = choices.size() - 1
