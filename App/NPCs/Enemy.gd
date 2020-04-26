extends "NPC.gd"

var Health = 10
var Health_Max = 10
var Defense = 0.2

func _ready():
	display_health()
	$Portrait.reset()

func hit(unadjusted_damage):
	Health = Health - (unadjusted_damage * (1-Defense))
	display_health()

func display_health():
	$Portrait/Label.text =  Name + " Health = " + str(round(Health*100)/100)


