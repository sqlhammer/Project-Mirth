extends Node

onready var game = get_tree().get_root()

func _ready():
	#_load_stage("village-field")
	pass

func load_stage(_stage_name):
	var stage = load("res://stages/village-field/village-field.tscn").instance()
	game.call_deferred("add_child",stage)
