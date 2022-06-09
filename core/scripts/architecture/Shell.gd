extends Node
class_name __Shell, "res://core/scripts/icons/icon_console.svg"

##################### The SHELL #####################

# The environment variables for the shell.
export var PATH := {}

var input : TextEdit
var output : RichTextLabel

signal command_finished
signal sequence_finished

func execute_block(commands):
	if commands is String:
		commands = SSON.parse_object(commands).content
	for command in commands:
		execute(command)
		yield(self, "command_finished")
	emit_signal("sequence_finished")

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
			output.bbcode_text = ""
		"sh":
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
		# Save the game's state into a file
		"save":
			printx("(<<) ❤F❤ile Saved to " + command.params + ".sav !")
			Game.Data.save_game(command.params)
		# Load the game's state from a file
		"load":
			printx("(>>) ❤F❤ile Loaded from " + command.params + ".sav !")
			Game.Data.load_game(command.params)
		# Say something using the dialog box
		"say":
			Game.DC.dialog_box.write(command.params)
			input.release_focus()
		# Say something as the narrator
		"*":
			Game.DC.dialog_box.write("* " + command.params)
			input.release_focus()
			yield(Game.DC.dialog_box, "finished")
		# Say something as a character
		"-":
			Game.DC.dialog_box.write("- " + command.params)
			input.release_focus()
		_:
			print_err("Invalid Command Error", "The command '"+command.key+"' is not recognized by this shell.", {suggestion="Check the orthography."})
	emit_signal("command_finished")

func printx(message, _options={}):
	output.bbcode_text += message + "\n"
	print(message)

func print_err(error, message, options={}):
	var text = "[color=#ff0000][b](!) "+error+":[/b] "+message
	if options.has("suggestion"):
		text += '\n[center]' + options.suggestion + '[/center]'
	text += "[/color]"
	
	output.bbcode_text += text + "\n"
	printerr("(!) " + error + ": " + message)
