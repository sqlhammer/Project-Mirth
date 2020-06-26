extends Area2D

var health = 10

func _on_HealthOrb_area_shape_entered(_area_id, area, _area_shape, _self_shape):
	var target = area.get_parent()
	if target.has_method("heal"):
		heal(target)

func heal(target):
	var accepted_orb = target.heal(health)
	if accepted_orb:
		queue_free()
