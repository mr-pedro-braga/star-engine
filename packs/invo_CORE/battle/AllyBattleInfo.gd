extends TextureRect
class_name AllyBattleInfo

var stats : CharacterStats

func _ready():
	if not stats:
		print("(!) Stats not set for AllyBattleInfo")
		return
	stats.changed.connect(update_gauges)

func update_gauges():
	$HPLabel.text = str(stats.HP).pad_zeros(2)
	$EPLabel.text = str(stats.EP).pad_zeros(2)
	$HPGauge.max_value = stats.MHP
	$EPGauge.max_value = stats.MEP
	$HPLabel.value = stats.HP
	$EPLabel.value = stats.EP
