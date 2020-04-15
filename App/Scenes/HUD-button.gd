extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var combat_vars = get_node("/root/CombatVariables")
onready var dummy = get_parent().get_node("Target Dummy")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_TextureButton_pressed():
	if dummy.is_dead():
		dummy.revive()
		return
	
	var scene = load("res://scenes/MagicMissile.tscn")
	var scene_instance = scene.instance()
	scene_instance.set_name("Magic Missile 1")
	
	combat_vars.source_position = get_parent().get_node("Male").global_position
	combat_vars.target_position = get_parent().get_node("Target Dummy").global_position
	
	scene_instance.position = combat_vars.source_position
	scene_instance.visible = true
	get_parent().add_child(scene_instance)
