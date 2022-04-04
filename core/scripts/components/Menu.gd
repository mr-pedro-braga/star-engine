tool
extends Node
class_name Menu

export var current := false
export var active := false

export var options = ["First", "Second", "Third"]
export var selected_option := 0

export var wrap_selection := true

export(NodePath) var parent
onready var parent_node = get_node(parent)

signal selection_changed(index)
signal ok_pressed(index)
signal back_pressed()

func _ready():
	set_process(false)

func select_next():
	selected_option += 1
	if wrap_selection:
		selected_option = posmod(selected_option, options.size())
	else:
		selected_option = clamp(selected_option, 0, options.size())
	emit_signal("selection_changed", selected_option)

func select_previous():
	selected_option -= 1
	if wrap_selection:
		selected_option = posmod(selected_option, options.size())
	else:
		selected_option = clamp(selected_option, 0, options.size())
	emit_signal("selection_changed", selected_option)

func get_selected():
	return options[selected_option]

func open():
	active = true
	set_process(active)

func close():
	active = false
	set_process(active)

func back():
	pass
