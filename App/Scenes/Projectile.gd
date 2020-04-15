extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var combat_vars = get_node("/root/CombatVariables")
onready var speed = 500
onready var velocity = Vector2()
onready var dummy = get_parent().get_node("Target Dummy")

func _process(_delta):
	velocity = (combat_vars.target_position - position).normalized() * speed
	# rotation = velocity.angle()
	if (combat_vars.target_position - position).length() > 5:
		velocity = move_and_slide(velocity)
	else:
		dummy.hit()
		queue_free()
