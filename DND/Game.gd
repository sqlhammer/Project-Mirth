extends Node

func _ready():
	StageManager.load_stage("village-field")

func _process(_delta):
	if Input.is_action_pressed("ui_exit"):
		get_tree().quit()
