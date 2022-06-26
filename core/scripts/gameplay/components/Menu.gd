@tool
extends Component
class_name Menu

@export var is_open := false
@export var is_current := false
@export var is_menu_array := false

@export var options : Array = ["First"]
@export var selected_index := 0

@export var wrap_selection := true
@export var allows_cancel := false

@export var parent: NodePath
var parent_node = get_node(parent)
var level = 0

signal selection_changed(index)
signal ok_pressed(index)
signal back_pressed()
signal choice_made(type)

enum {CHOICE_OK, CHOICE_BACK}

func _ready():
	set_process(false)

func choose():
	var m = get_selected()
	if m is NodePath:
		m = get_node(m)
	if m is Menu:
		is_current = false
		m.open(self, level+1)
		await m.choice_made
		choice_made.emit(CHOICE_OK)
		ok_pressed.emit()
		return
	
	var indent = ""; for i in range(level): indent += "\t"
	print(indent, "- ", name, " : ", m)
	
	if parent_node:
		close()
		choice_made.emit(CHOICE_OK)
		ok_pressed.emit()

func select_next():
	var cache = selected_index
	selected_index += 1
	if wrap_selection:
		selected_index = posmod(selected_index, options.size())
	else:
		selected_index = clamp(selected_index, 0, options.size() - 1)
	if cache != selected_index:
		emit_signal("selection_changed", selected_index)

func select_previous():
	var cache = selected_index
	selected_index -= 1
	if wrap_selection:
		selected_index = posmod(selected_index, options.size())
	else:
		selected_index = clamp(selected_index, 0, options.size() - 1)
	if cache != selected_index:
		emit_signal("selection_changed", selected_index)

func get_selected():
	return options[selected_index]

func open(parent_=null, level_=0):
	if is_open:
		printerr("Cyclical/Redundant Menu Reference is discouraged.")
	is_open = true
	is_current = true
	if parent_:
		parent_node = parent_
	level = level_
	set_process(true)
	if is_menu_array:
		iterate()

func iterate():
	var index = 0
	while index < options.size():
		var m = options[index]
		var indent = ""; for i in range(level): indent += "\t"
		print(indent, "- ", index, " : ", m)
		if m is NodePath:
			m = get_node(m)
		if m is Menu:
			is_current = false
			m.open(self, level+1)
			var status = await m.choice_made
			if status == CHOICE_BACK:
				index -= 2
		index += 1
	print("Iterated through all!")
	close()
	choice_made.emit(CHOICE_OK)

func close():
	is_open = false
	is_current=false
	set_process(false)

func back():
	if parent_node:
		close()
		parent_node.is_current = true
		choice_made.emit(CHOICE_BACK)
		back_pressed.emit()
