extends Node
class_name __Shell, "res://core/scripts/icons/icon_console.svg"

##################### The SHELL #####################

# The environment variables for the shell.
@export var PATH := {}

var input : TextEdit
var output : RichTextLabel

signal command_finished
signal sequence_finished

func execute_block(commands):
	if commands is String:
		commands = StarScriptParser.parse(commands).content
	for command in commands:
		execute(command)
		await command_finished
	sequence_finished.emit()

func execute(command):
	match command.key:
		# The print command prints the parameters to the output.
		"print":
			if command.params == null:
				print_err("SyntaxError", "No arguments supplied for 'print'.", {suggestion="Try writing something after 'print' so there is something to be printed."})
				return
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
			output.text = ""
		"sh":
			var params := StarScriptParser.split_params(command.params)
			var path = params.pop_front()
			var output := []
			var error := OS.execute(path, params, output)
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
			printx("(<<) File Saved to " + command.params + ".sav !")
			Game.Data.save_game(command.params)
		# Load the game's state from a file
		"load":
			printx("(>>) File Loaded from " + command.params + ".sav !")
			Game.Data.load_game(command.params)
		# Say something using the dialog box
		"say":
			Game.DC.dialog_box.write(command.params)
			input.release_focus()
		# Say something as the narrator
		"*":
			Game.DC.dialog_box.write("* " + command.params)
			input.release_focus()
			await Game.DC.dialog_box.completed
		# Say something as a character
		"-":
			Game.DC.dialog_box.write("- " + command.params)
			print(" :: ", command.params)
			input.release_focus()
		# Item management
		"item":
			pass
		"bgm":
			pass
		"sfx":
			pass
		"vfx":
			pass
		"exit":
			get_tree().quit()
		_:
			print_err("Invalid Command Error", "The command '"+command.key+"' is not recognized by this shell.", {suggestion="Check the orthography."})
	emit_signal("command_finished")

func printx(message, _options={}):
	output.text += message + "\n"
	print_rich(message)

func print_err(error, message, options={}):
	var text = "[color=red][b](!) "+error+":[/b] "+message
	if options.has("suggestion"):
		text += '\n[center]' + options.suggestion + '[/center]'
	text += "[color=white]"
	
	output.text += text + "\n"
	print_rich(text)
