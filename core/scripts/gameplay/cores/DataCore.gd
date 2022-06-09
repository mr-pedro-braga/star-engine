extends __GameplayCoreBase
class_name DataCore, "res://core/scripts/icons/icon_event_pathway.svg"

signal on_saved(file)
signal on_loaded(file)

var data = {
	"game_name": "Inner Voices",
	"game_version": "BETA FT 02",
	"characters": {
		"vessel": "claire",
		"party": ["claire", "andy", "bruno", "rodrick"],
		"status_effects": {
			"andy": {"frost":3, "fire": 2, "necrosis": 4},
			"bruno": {"recovery":2, "protection": 2}
		},
		"inventory": {
			"claire": {Vector2(1, 2): {"name":"pepperoni_pizza", "amount":2}}
		},
	},
	"resuming_hotspot": {
		"scene_path": "__tests/scenes/_stest/battle_patterns.tscn",
		"anchor": "reload_point",
	}
}

func save_game(file: String) -> int:
	var d := Directory.new()
	if d.open("user://saves") == OK:
		print("Opened")
	else:
		d.make_dir("user://saves")
		save_game(file)
		return OK
	var f := File.new()
	
	f.open("user://saves/"+file+".sav", File.WRITE)
	f.store_var(data)
	f.flush()
	f.close()
	return OK

func load_game(file: String) -> int:
	var f := File.new()
	var path ="user://saves/"+file+".sav"
	if not f.file_exists(path):
		Shell.print_err(
			"Missing Save File",
			"No save file "+file+" at the save directiory.",
			{"suggestions":""}
		); return ERR_FILE_NOT_FOUND
	f.open(path, File.READ)
	data = f.get_var()
	print(data)
	f.close()
	
	return OK
	
