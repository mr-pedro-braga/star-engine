extends RichTextLabel
class_name SmartRichTextLabel

##################################################################
#
#	Chroma RPG SmartRichTextLabel 
#
#	A Label that supports BBCode and simple prosody typewriting.
#	Version Inner Voices 1.0
#
##################################################################
#
#	Use ¢ to introduce a slight pause.
#	Use ¬ to just skip typewriting entirely.
#	Use _ to wait for input mid text.
#
##################################################################

# Triggered when a character is written.
signal char_written
# Triggered when a character is processed (there are non written characters).
signal char_tick
# Triggered when the writing is paused midtext AND when the text ends.
signal paused
# Triggered when the writing is resumed after being paused, or after finishing.
signal resumed
# The text completed writing and is ready to move on to the next.
# Use this to control the flow of dialog in your dialog sequence.
signal completed

signal ok_pressed
signal cancel_pressed

# Whether this label is currently writing.
var is_typing := false
var is_emitting_physical_sound := false

@export var text_delay:float = 0.05
@export var text_wait_action = "ui_accept"
@export var text_cancel_action = "ui_cancel"

func _ready():
	cancel_pressed.connect(cancel_write)

func _process(delta):
	if Input.is_action_just_pressed(text_wait_action):
		emit_signal("ok_pressed")
	if Input.is_action_just_pressed(text_cancel_action):
		emit_signal("cancel_pressed")

func write(_text):
	is_typing = true
	is_emitting_physical_sound = true
	
	text = _text
	visible_characters = 0
	
	var old_text = text
	
	text = text.replace("¢", "")
	text = text.replace("¬", "")
	text = text.replace("_", "")
	
	resumed.emit()
	
	for character in old_text:
		if not is_typing:
			break
		match character:
			",":
				visible_characters += 1
				await get_tree().create_timer(0.1).timeout
				char_written.emit()
			";":
				visible_characters += 1
				await get_tree().create_timer(0.1).timeout
				char_written.emit()
			":":
				visible_characters += 1
				await get_tree().create_timer(0.1).timeout
				char_written.emit()
			".":
				visible_characters += 1
				beep()
				await get_tree().create_timer(0.1).timeout
				char_written.emit()
			"¢":
				await get_tree().create_timer(text_delay * 4.0).timeout
			"_":
				paused.emit()
				is_emitting_physical_sound = false
				is_typing = false
				await self.ok_pressed
				is_emitting_physical_sound = true
				resumed.emit()
				is_typing = true
			" ":
				visible_characters += 1
			"	":
				visible_characters += 1
			"¬":
				visible_characters = -1
				break
			"¹":
				clear()
				resumed.emit()
				completed.emit()
				is_emitting_physical_sound = false
				return
			_:
				beep()
				char_written.emit()
				await get_tree().create_timer(text_delay).timeout
				visible_characters += 1
		char_tick.emit()
		update()
	paused.emit()
	is_typing = false
	is_emitting_physical_sound = false
	await ok_pressed
	resumed.emit()
	completed.emit()

func beep():
	if has_node("beep"):
		get_node(^"beep").play()

func clear ():
	text = ""

func cancel_write ():
	if is_typing:
		is_typing = false
		percent_visible = 0.99999
