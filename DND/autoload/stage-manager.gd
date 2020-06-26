extends Node

signal bossDied

onready var root = get_tree().get_root()
onready var game = get_tree().get_root().get_node("Game")
var hud

var currentStage
var levelSuccess = preload("res://stages/level_success.tscn")
var levelFailed = preload("res://stages/level-failed.tscn")
var hud_resource = preload("res://common/HUD.tscn")

func load_stage(_stage_name):
	hud = hud_resource.instance()
	game.add_child(hud)
	
	var stage = load("res://stages/village-field/village-field.tscn").instance()
	currentStage = stage
	root.call_deferred("add_child",stage)

func end_stage(is_win):
	get_tree().paused = true
	
	var _completion_canvas
	if is_win:
		_completion_canvas = levelSuccess.instance()
	else:
		_completion_canvas = levelFailed.instance()
	
	hud.queue_free()
	game.add_child(_completion_canvas)
