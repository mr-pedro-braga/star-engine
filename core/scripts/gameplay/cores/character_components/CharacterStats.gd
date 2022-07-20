extends Resource
class_name CharacterStats

@export var soul_color_fg := Color.WHITE
@export var soul_color_bg := Color.GRAY

@export var HP = 10
@export var EP = 10
@export var MHP = 10
@export var MEP = 10
@export var AT = 1
@export var DF = 1
@export var AG = 1

#-----------------------------------------#

func deplete_HP(amount):
	if HP > 0:
		HP = clamp(HP - amount, 0, MHP)

func deplete_EP(amount):
	if EP > 0:
		EP = clamp(EP - amount, 0, MEP)

func healHP(amount):
	if HP > 0:
		HP = clamp(HP - amount, 0, MHP)

func heal_EP(amount):
	if EP > 0:
		EP = clamp(EP - amount, 0, MEP)
