#########################################
#										#
#		SSON Utility Class 1.0.0		#
#			by Pedro Braga				#
#										#
#	Loads and parses .ssh files into 	#
#	usable Dictionaries.				#
#										#
#########################################

tool
class_name SSON

# Some cool RegExs for parsing things
const regex_sobj_text = "(?m)^(?<colon>--)?(?<key>\\w+) *(?<colon>:)? *(?<params>.*)?(?<block>(?:\\n\\t.*)*)?"

# Loads 
static func load_sson(path):
	var file = File.new()
	var err = file.open(path, File.READ)
	if err != OK:
		return err
	var raw = file.get_as_text()
	file.close()
	
	return parse_object(raw)

# Parses an object according to the following specification
#
#	#key1
#		instruction1 params
#		instruction2
#		value1: 0
#		value2: 0
#
#	An SObject is generated with the KEY as the name,
#	space separated parameters (with " support) under "params",
#	a set of instructions (SObjects) under "content" and
#	arbitrary values under "data". See SObject below.
#
#	An SObject is a dictionary with this scheme:
#		{
#			"params": ["param1", "param2"],		# An array of parameters!
#			"content": [SObject1, SObject2],	# An array containing a sequence of SObjects.
#			"data1": {...}						# A dictionary containing arbitrary data (can be SObjects, but not necessarily!).
#		}
#

static func parse_object(raw, top_level=true):
	var regex_sobj   := RegEx.new()
	regex_sobj.compile(regex_sobj_text)
	
	# Match the entire raw file for SObject entries
	var results = {
		"content": [],
		"data": {}
	}
	
	for result in regex_sobj.search_all(raw):
		var r
		
		var names = result.get_names();
		
		if names.has("colon"):
			r = {}
			var is_dict = false
			if names.has("block"):
				var block = parse_object(remove_indentation(result.get_string("block")), false)
				if block.content:
					r["content"] = block.content; is_dict = true
				if block.data:
					r["data"] = block.data; is_dict = true
			elif not names.has("params"):
				return ERR_PARSE_ERROR
			results.data[result.get_string("key")] = r if is_dict else result.get_string("params")
		else:
			r = {}
			r["key"] = result.get_string("key")
			if names.has("params"):
				if result.get_string("params"):
					r["params"] = result.get_string("params")
			if names.has("block"):
				var block = parse_object(remove_indentation(result.get_string("block")), false)
				if block.content:
					r["content"] = block.content
				if block.data:
					r["data"]    = block.data
			results.content.push_back(r)
	#if top_level:
	#	print("RAW:\n", raw, "\n---------------------------\n\n")
	#	print(JSON.print(results, "\t"))
	return results

static func remove_indentation(string, indentation_character="\t"):
	var r = RegEx.new()
	r.compile("(?m)^"+indentation_character)
	return r.sub(string, "", true)

static func split_params(params) -> Array:
	if not params:
		return []
	var r := RegEx.new()
	r.compile('[^\\s"\']+|"([^"]*)"|\'([^\']*)\'')
	var result = []
	for m in r.search_all(params):
		var mn = m.get_names()
		if mn.has('b'):
			result.push_back(m.get_string('b'))
		elif mn.has('a'):
			result.push_back(m.get_string('a'))
		else:
			result.push_back(m.get_string(0))
	return result
