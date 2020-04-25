extends Object

var rand = RandomNumberGenerator.new()
var min_damage
var max_damage
var charge_time
var current_charge_time

func init(type):
	set_vars(type)

func attack(enemy):
	if is_instance_valid(enemy) and is_charged():
		enemy.hit(get_unadjusted_damage())
		current_charge_time = 0

func get_unadjusted_damage():
	rand.randomize()
	var damage = rand.randf_range(min_damage, max_damage)
	return damage

func charge(time):
	if current_charge_time < charge_time:
		current_charge_time = current_charge_time + time

func is_charged():
	var is_charged = false
	if current_charge_time >= charge_time:
		is_charged = true
	return is_charged

#TODO: Make this enternal to the attack script
func set_vars(type):
	match type:
		"basic":
			min_damage = 1
			max_damage = 5
			charge_time = 2
			current_charge_time = 2
		_: #default
			min_damage = 1
			max_damage = 5
			charge_time = 2
			current_charge_time = 2
