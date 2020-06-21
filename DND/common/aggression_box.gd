extends Area2D

onready var enemy = get_parent()

func _on_AggressionBox_area_shape_entered(_area_id, area, _area_shape, _self_shape):
	enemy.aggro(area.get_parent().get_parent())
