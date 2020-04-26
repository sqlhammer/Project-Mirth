extends Node

var Rand = RandomNumberGenerator.new()
var Damage_Min
var Damage_Max
var Charge_Time
var Charge_Time_Current
var Ability_Type

func init(type,_progress):
	Rand.randomize()
	set_vars(type)

func attack(enemy):
	if is_instance_valid(enemy) and is_charged():
		enemy.hit(get_unadjusted_damage())
		Charge_Time_Current = 0

func get_unadjusted_damage():
	var damage = Rand.randf_range(Damage_Min, Damage_Max)
	return damage

func charge(time):
	if Charge_Time_Current < Charge_Time:
		Charge_Time_Current = Charge_Time_Current + time

func is_charged():
	var is_charged = false
	if Charge_Time_Current >= Charge_Time:
		is_charged = true
	return is_charged

#TODO: Make this enternal to the attack script
func set_vars(type):
	Ability_Type = type
	
	match type:
		"basic":
			Damage_Min = 1
			Damage_Max = 5
			Charge_Time = 2
			Charge_Time_Current = 2
		"heavy":
			Damage_Min = 4
			Damage_Max = 10
			Charge_Time = 10
			Charge_Time_Current = 10
		_: #default
			Damage_Min = 1
			Damage_Max = 5
			Charge_Time = 2
			Charge_Time_Current = 2
