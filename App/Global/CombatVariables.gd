extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var target_position : Vector2
onready var source_position : Vector2
onready var dummy_hp = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func hit():
	dummy_hp = dummy_hp - 1

func is_dead():
	if dummy_hp <= 0:
		return true
	else:
		return false
