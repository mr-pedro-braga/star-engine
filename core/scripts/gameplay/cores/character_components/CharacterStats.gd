extends Resource
class_name CharacterStats

@export var soul_color_fg := Color.WHITE
@export var soul_color_bg := Color.GRAY

@export var HP = 10
@export var SP = 10
@export var MHP = 10
@export var MSP = 10
@export var AT = 1
@export var DF = 1
@export var AG = 1

#-----------------------------------------#

func deplete_HP(amount):
	if HP > 0:
		HP = clamp(HP - amount, 0, MHP)

func deplete_SP(amount):
	if SP > 0:
		SP = clamp(SP - amount, 0, MSP)

func healHP(amount):
	if HP > 0:
		HP = clamp(HP - amount, 0, MHP)

func heal_SP(amount):
	if SP > 0:
		SP = clamp(SP - amount, 0, MSP)
