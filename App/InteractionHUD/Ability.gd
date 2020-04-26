extends "Attack.gd"

var Progress
var Type

func init(type,progress):
	set_ability_type(type)
	
	Progress = progress
	Progress.max_value = Charge_Time

func attack(enemy):
	var observer = Resources.Observers["Observer_Ability_Type"]
	if observer != null:
		observer.set_ability_type(Type)
	
	.attack(enemy)

func set_ability_type(type):
	Type = type
	set_vars(type)
