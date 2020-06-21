extends Area2D

var damage : float = 0

func hit(enemy):
	if enemy.has_method("hurt"):
		enemy.call_deferred("hurt",damage)
