extends Resource
class_name GameSaveData

# GAME PROPERTIES
var game_name := "Inner Voices"
var game_version := "BETA Feature Test 02"

# RESUME HOTSPOT
var resume_hotspot_scene_path = "__tests/scenes/_stest_battle_patterns.tscn"
var resume_hotspot_anchor = "reload_point"

# Character PROPERTIES
var current_vessel := "claire"
var party : Array[Resource] = []

# SWITCHES / GAME PROGRESSION
var switches := {}
