extends __GameplayCoreBase
class_name BattleCore, "res://core/scripts/icons/icon_event_pathway.svg"

var battle_instance : BattleInstance

func battle_loop():
	#await ask_ally_choices()
	#await do_ally_turns()
	#await do_opponent_turns()
	pass


# key -> A string containing the choice's type, is it an attack or an item use?
# val -> The selected choice (the attack, item or skill)
# target -> An array with all the targets of this choice
class AllyBattleChoice:
	var type : String = "unknown"
	var val
	var targets : Array[Character] = []

func ask_ally_choices():
	await get_tree().process_frame

func do_ally_turns():
	await get_tree().process_frame

func do_opponent_turns():
	await get_tree().process_frame

func end_battle():
	pass
