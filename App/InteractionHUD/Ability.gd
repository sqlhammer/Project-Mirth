extends "Attack.gd"

var Progress
var Type

func init(type,progress):
	set_ability_type(type)
	
	Progress = progress
	Progress.max_value = Charge_Time

func attack(enemy):
	#used to be to set ability type
	.attack(enemy)

func set_ability_type(type):
	Type = type
	set_vars(type)
