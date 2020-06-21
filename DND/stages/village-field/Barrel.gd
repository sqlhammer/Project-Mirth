extends RigidBody2D

func die():
	queue_free()

func _on_HurtBox_area_shape_entered(_area_id, area, _area_shape, _self_shape):
	if area.has_method("hit"):
		area.hit(self)

func hurt(_damage):
	$AnimationPlayer.play("Die")
