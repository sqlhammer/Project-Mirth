# Variable naming convention
#
# script scope vars :: Proper-case with underscores - Tick_Observer
#
# local scope var :: lower-case with underscores - tick_observer
#
# const :: casing based on scope, all caps - TICK_OBSERVER


#var Main = get_tree().get_root().get_node("Main")

extends Node

var Observer_Tick = load("res://Global/Observer.gd").new()
var Observer_Ability_Type = load("res://Global/ObserverAbilityType.gd").new()

# Called when the node enters the scene tree for the first time.
func _ready():
	Resources.Observers["Observer_Tick"] = Observer_Tick
	Resources.Observers["Observer_Ability_Type"] = Observer_Ability_Type
	Observer_Ability_Type.set_ability_type("punch")
	$Ticker.start()

func _on_Ticker_timeout():
	Resources.Run_Time = Resources.Run_Time + $Ticker.wait_time
	Observer_Tick.trigger()

