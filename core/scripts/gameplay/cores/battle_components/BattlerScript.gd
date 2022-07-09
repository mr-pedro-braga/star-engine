extends Component
class_name BattlerScript

@export var is_ally := false
var battle : BattleInstance

######### FIGHTER ACTIONS

func do_turn(turn_index : int) -> void:
	# Inherit with the response for character's action in this turn.
	await get_tree().process_frame

func attack(characters : Array[Character]):
	BattleCore.battle_instance.current_targets = characters
	await get_tree().process_frame

######### RESPONSES TO ALLY ACTIONS

func do_ACT(character : Character, act_name : String) -> void:
	# Inherit with the result of the used ACT.
	await get_tree().process_frame

func get_ACTs(character_name : String) -> Array[String]:
	# Inherit with the currently available ACTs
	# for the given character.
	return ['wait']
