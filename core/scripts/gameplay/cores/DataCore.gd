extends __GameplayCoreBase
class_name DataCore, "res://core/scripts/icons/icon_event_pathway.svg"

signal on_saved(file)
signal on_loaded(file)

var data : GameSaveData

func save_game(file: String) -> int:
	ResourceSaver.save("user://saves/"+file+".sav", data)
	return OK

func load_game(file: String) -> int:
	var path ="user://saves/"+file+".sav"
	var f = File.new()
	if not f.file_exists(path):
		Shell.print_err(
			"Missing Save File",
			"No save file "+file+" at the save directiory.",
			{"suggestions":""}
		); return ERR_FILE_NOT_FOUND
	
	data = load(path)
	
	return OK
	
