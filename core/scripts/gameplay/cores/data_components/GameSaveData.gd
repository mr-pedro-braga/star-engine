extends Resource
class_name GameSaveData

# GAME PROPERTIES
@export var game_name := "Inner Voices"
@export var game_version := "BETA Feature Test 02"

# RESUME HOTSPOT
@export var resume_hotspot_scene_path = "__tests/scenes/_stest_battle_patterns.tscn"
@export var resume_hotspot_anchor = "reload_point"

# Character PROPERTIES
@export var current_vessel := "unknown"
@export var party : Array[Resource] = []

# SWITCHES / GAME PROGRESSION
@export var switches := {}

# OTHER GAME DATA
@export var inventories : Dictionary = {}

func _to_string():
	return str(game_name) + "\n" + "Version: " + str(game_version) + "\n\n"
