extends Node

var Observer = load("res://Global/Observer.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Ticker.start()

func _process(delta):
	pass

func _on_Ticker_timeout():
	Observer.tick()
