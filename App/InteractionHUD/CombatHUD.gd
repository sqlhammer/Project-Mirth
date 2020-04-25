extends Node

var Enemies = {}

func _ready():
	pass

#necessary so it will initialize prior to child nodes
#need to understand this recursive logic more because I am setting a pointer
#to a child but want it set prior to another child calling the Enemies var
#how does this timing work successfully?
func _enter_tree():
	Enemies = {"Enemy1":$Enemy1}
