tool
extends VBoxContainer

func _ready():
	
	var tedit = $"%TextEdit"
	
	var keywords = [
	
	]
	
	add_syntax_highlighting(tedit)

func add_syntax_highlighting(target=self):
	var colour_keyword = Color(1, 0.351562, 0.472657)
	var colour_string  = Color(1, 0.809875, 0.304688)
	var keywords = [
		"await", "item", "give", "take", "list",
		"sfx", "bgm", "load", "resume", "restart", "pause", "stop",
		"with", "mvto", "-", "*", "quit", "menu", "choice",
		"sh", "call", "gdexec", "print", "speak", "clear", "cls",
		
		"save", "load", "quit", "*", "-",
		
		"say", "cutscene", "mvadd", "mvto", "face", "action", "wait",
		"help", "from", "to", "if", "elif", "else", "unless",
		"while", "repeat", "once", "every", "seconds", "frames",
		
		"battle", "request",
		
		"true", "false", "on", "off", "yes", "no",
	]
	
	for keyword in keywords:
		target.add_keyword_color(keyword, colour_keyword)
	
	# Item keys
	target.add_color_region("--", "", colour_keyword, true)
	
	# Strings
	target.add_color_region("\"", "\"", colour_string, false)
	target.add_color_region("'", "'", colour_string, false)
