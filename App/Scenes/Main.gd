# Variable naming convention
#
# script scope vars :: Proper-case with underscores - Tick_Observer
#
# local scope var :: lower-case with underscores - tick_observer
#
# const :: casing based on scope, all caps - TICK_OBSERVER


#var Main = get_tree().get_root().get_node("Main")

extends Node

signal Tick

# Called when the node enters the scene tree for the first time.
func _ready():
	$Ticker.wait_time = Resources.TickTime
	$Ticker.start()

func _on_Ticker_timeout():
	Resources.Run_Time = Resources.Run_Time + Resources.TickTime
	emit_signal("Tick")

