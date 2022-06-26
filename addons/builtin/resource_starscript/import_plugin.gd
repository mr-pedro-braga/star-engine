@tool
extends EditorImportPlugin

enum Presets { CUTSCENE, BATTLE_PATTERN }

func _get_importer_name():
	return "star.sson"

func _get_visible_name():
	return "StarScript"

func _get_recognized_extensions():
	return ["ssh", "sson", "sc", "sdialog", "spattern"]

func _get_save_extension():
	return "res"

func _get_resource_type():
	return "Resource"

func _get_preset_count():
	return Presets.size()

func _get_preset_name(preset):
	match preset:
		Presets.CUTSCENE:
			return "Cutscene"
		Presets.BATTLE_PATTERN:
			return "Battle Pattern"
		_:
			return "Unknown"

func _get_import_options(preset, v):
	match preset:
		Presets.CUTSCENE:
			return [
				{"name": "tts_compatible", "default_value": false}
			]
		_:
			return []

func _get_option_visibility(option, option2, options):
	return true

func _import(source_file, save_path, options, r_platform_variants, r_gen_files):
	var sraw = StarScriptParser.load_sson(source_file)
	var sdictionary = StarScriptParser.parse(sraw)
	
	# Check if some error ocurred when parsing! (Should never happen...)
	if not sdictionary is Dictionary:
		return ERR_PARSE_ERROR
	
	var sobject = StarScript.new()
	sobject.data = sdictionary.data
	sobject.source_code = sraw
	
	print(JSON.new().stringify(sobject.data, "\t"))
	
	var r = ResourceSaver.save("%s.%s" % [save_path, _get_save_extension()], sobject)
	return r
