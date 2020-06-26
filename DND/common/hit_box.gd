extends Area2D

onready var parent = get_parent()

export var damage : float
export var isCharged : bool = true

func hit(enemy):
	if isCharged:
		if enemy.has_method("hurt"):
			enemy.call_deferred("hurt",damage)
			_reset_cooldown()
			
			if parent.has_method("hit"):
				parent.call_deferred("hit")

func _reset_cooldown():
	isCharged = false
	$CooldownTimer.start()

func _on_CooldownTimer_timeout():
	isCharged = true
	var _areas = get_overlapping_areas()
	for _area in _areas:
		if "parent" in _area:
			hit(_area.parent)

func _on_HitBox_area_shape_entered(_area_id, area, _area_shape, _self_shape):
	hit(area.parent)



