extends TextEdit
class_name ShellInput, "res://core/scripts/icons/icon_console.svg"

func _ready():
	var colour_keyword = Color(0.8125, 0.161865, 0.283859)
	var colour_string  = Color(0.871094, 0.66826, 0.129303)
	var keywords = [
		"await", "item", "give", "take",
		"sfx", "bgm", "load", "resume", "restart", "pause", "stop",
		"with", "mvto", "-", "*", "quit", "menu", "choice",
		"shell", "call", "gdexec", "print", "speak",
		
		"mvadd", "mvto", "face", "action", "angle", "wait",
	]
	
	for keyword in keywords:
		add_keyword_color(keyword, colour_keyword)
	
	# Item keys
	add_color_region("--", "", colour_keyword, true)
	
	# Strings
	add_color_region("\"", "\"", colour_string, false)
	add_color_region("'", "'", colour_string, false)

func _input(ev):
	if ev is InputEventKey:
		if ev.scancode == KEY_F10:
			visible = true
			grab_focus()
		if has_focus():
			# If pressing return but not shift
			if ev.scancode == KEY_ENTER and not Input.is_key_pressed(KEY_SHIFT):
				print(text)
				get_parent().write(text)
				text = ""
				release_focus()
			# Leave the shell if you press ESCAPE
			if ev.scancode == KEY_ESCAPE:
				release_focus()

func _on_focus_exited():
	visible = false
