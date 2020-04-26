extends "Observer.gd"

var Ability_Type = ""

func trigger():
	for key in Subscribers:
		Subscribers[key]["args"] = Ability_Type
	
	.trigger()

func set_ability_type(type):
	Ability_Type = type
