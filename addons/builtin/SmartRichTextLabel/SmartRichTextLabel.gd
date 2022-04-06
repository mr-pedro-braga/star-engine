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
# The text finished writing and is ready to move on to the next.
# Use this to control the flow of dialog in your dialog sequence.
signal finished

# Whether this label is currently writing.
var is_typing := false
var is_emitting_physical_sound := false

export var text_delay:float = 0.05
export var text_wait_action = "ui_accept"
export var text_cancel_action = "ui_cancel"

func _ready():
	add_user_signal("ok_pressed")
	add_user_signal("cancel_pressed")
	connect("cancel_pressed", self, "cancel_write")

func _input(_ev):
	if Input.is_action_just_pressed(text_wait_action):
		emit_signal("ok_pressed")
	if Input.is_action_just_pressed(text_cancel_action):
		emit_signal("cancel_pressed")

func write(_text):
	is_typing = true
	is_emitting_physical_sound = true
	
	bbcode_text = _text
	visible_characters = 0
	
	var old_text = text
	
	bbcode_text = bbcode_text.replace("¢", "")
	bbcode_text = bbcode_text.replace("¬", "")
	bbcode_text = bbcode_text.replace("_", "")
	
	emit_signal("resumed")
	
	for character in old_text:
		if not is_typing:
			break
		match character:
			",":
				visible_characters += 1
				yield(get_tree().create_timer(0.1), "timeout")
				emit_signal("char_written")
			";":
				visible_characters += 1
				yield(get_tree().create_timer(0.1), "timeout")
				emit_signal("char_written")
			":":
				visible_characters += 1
				yield(get_tree().create_timer(0.1), "timeout")
				emit_signal("char_written")
			".":
				visible_characters += 1
				beep()
				yield(get_tree().create_timer(0.1), "timeout")
				emit_signal("char_written")
			"¢":
				yield(get_tree().create_timer(text_delay * 4.0), "timeout")
			"_":
				emit_signal("paused")
				is_emitting_physical_sound = false
				is_typing = false
				yield(self, "ok_pressed")
				is_emitting_physical_sound = true
				emit_signal("resumed")
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
				emit_signal("resumed")
				emit_signal("finished")
				is_emitting_physical_sound = false
				return
			_:
				beep()
				emit_signal("char_written")
				yield(get_tree().create_timer(text_delay), "timeout")
				visible_characters += 1
		emit_signal("char_tick")
		update()
	emit_signal("paused")
	is_typing = false
	is_emitting_physical_sound = false
	yield(self, "ok_pressed")
	emit_signal("resumed")
	emit_signal("finished")

func beep():
	if has_node("beep"):
		get_node("beep").play()

func clear ():
	text = ""
	bbcode_text = ""

func cancel_write ():
	if is_typing:
		is_typing = false
		percent_visible = 0.99999
