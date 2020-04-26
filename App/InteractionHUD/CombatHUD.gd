extends Node

var Enemies = {}

#necessary so it will initialize prior to child nodes
#need to understand this recursive logic more because I am setting a pointer
#to a child but want it set prior to another child calling the Enemies var
#how does this timing work successfully?
func _enter_tree():
	spawn_enemy()

func spawn_enemy():
	var scene = load("res://NPCs/Enemy.tscn")
	var scene_instance = scene.instance()
	scene_instance.set_name("Enemy1")
	scene_instance.visible = true
	self.add_child(scene_instance)
	Enemies = {"Enemy1":scene_instance}
	$LowerCombatHUD.Selected_Enemy = scene_instance
