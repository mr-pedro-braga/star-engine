extends Node

# The environment variables for the shell.
export var PATH := {}

func _input(ev):
	# Handle fullscreen in desktops!
	if ev is InputEventKey:
		if ev.pressed and (ev.scancode == KEY_F4 or ev.scancode == KEY_F11):
			OS.window_fullscreen = not OS.window_fullscreen

##################### The SHELL #####################

var shell_input : TextEdit
var shell_output : RichTextLabel

func execute_block(commands):
	if commands is String:
		commands = SSON.parse_object(commands).content
	for command in commands:
		execute(command)

func execute(command):
	match command.key:
		# The print command prints the parameters to the output.
		"print":
			if command.has("data"):
				printx(command.params, command.data)
			else:
				printx(command.params)
		"error":
			if command.has("data"):
				var type = "Error"
				var sugg = "Try something"
				if command.data.has("type"):
					type = command.data.type
				if command.data.has("suggestion"):
					type = command.data.suggestion
				print_err(type, command.params, {suggestion=sugg})
			else:
				print_err("Error", command.params, {suggestion="Try something else"})
		"clear", "cls":
			shell_output.bbcode_text = ""
		"shell":
			var params := SSON.split_params(command.params)
			var path = params.pop_front()
			var output := []
			var error := OS.execute(path, params, true, output)
			var output_message := ""
			
			for i in range(output.size()):
				output_message += output[i]
				if not i == output.size() - 1:
					output_message += "\n"
			
			if error:
				print_err("Shell Error", str(output_message))
			else:
				printx(str(output_message))
		_:
			print_err("Invalid Command Error", "The command '"+command.key+"' is not recognized by this shell.", {suggestion="Check the orthography."})

func printx(message, options={}):
	shell_output.bbcode_text += message + "\n"
	print(message)

func print_err(error, message, options={}):
	var text = "[color=#ff0000][b](!) "+error+":[/b] "+message
	if options.has("suggestion"):
		text += '\n[center]' + options.suggestion + '[/center]'
	text += "[/color]"
	
	shell_output.bbcode_text += text + "\n"
	print("(!) " + error + ": " + message)
