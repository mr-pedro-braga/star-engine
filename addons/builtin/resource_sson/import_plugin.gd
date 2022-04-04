tool
extends EditorImportPlugin

enum Presets { CUTSCENE, BATTLE_PATTERN }

func get_importer_name():
	return "star.sson"

func get_visible_name():
	return "SSON"

func get_recognized_extensions():
	return ["ssh", "sson", "sc", "sdialog", "spattern"]

func get_save_extension():
	return "res"

func get_resource_type():
	return "Resource"

func get_preset_count():
	return Presets.size()

func get_preset_name(preset):
	match preset:
		Presets.CUTSCENE:
			return "Cutscene"
		Presets.BATTLE_PATTERN:
			return "Battle Pattern"
		_:
			return "Unknown"

func get_import_options(preset):
	match preset:
		Presets.CUTSCENE:
			return [
				{"name": "tts_compatible", "default_value": false}
			]
		_:
			return []

func get_option_visibility(option, options):
	return true

func import(source_file, save_path, options, r_platform_variants, r_gen_files):
	var sdictionary = SSON.load_sson(source_file)
	
	# Check if some error ocurred when parsing! (Should never happen...)
	if not sdictionary is Dictionary:
		return ERR_PARSE_ERROR
	
	var sobject = SSObject.new()
	sobject.data = sdictionary.data
	
	var r = ResourceSaver.save("%s.%s" % [save_path, get_save_extension()], sobject)
	return r
