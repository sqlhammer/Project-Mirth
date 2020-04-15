extends Node


onready var dummy_hp = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func die():
	get_node("Alive").visible = false
	get_node("Dead").visible = true
	get_node("DeadAnimation").play("Die")

func revive():
	get_node("Alive").visible = true
	get_node("Dead").visible = false
	dummy_hp = 5
	
func hit():
	dummy_hp = dummy_hp - 1
	if is_dead():
		die()

func is_dead():
	if dummy_hp <= 0:
		return true
	else:
		return false
