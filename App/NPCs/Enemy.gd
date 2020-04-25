extends "NPC.gd"

var health = 10
var max_health = 10
var defense = 0.2

func _ready():
	$Label.text = "Health = " + str(health)

func hit(unadjusted_damage):
	health = health - (unadjusted_damage * (1-defense))
	$Label.text = "Health = " + str(health)
