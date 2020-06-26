extends KinematicBody2D

enum ENEMY_FACING {
	UNKNOWN,
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

const SPEED : int = 45
const START_FRAME = 6

export var maxHealth : float
export var enemyFacing : int = ENEMY_FACING.DOWN
export var isInvincible : bool = false
export var isAggressive : bool = true
export var isAttacking : bool = false

var velocity = Vector2(0,0)
var health : float
var aggressionTarget : Node = null
var stage : Node = null

func _ready():
	var _result = GameManager.connect("playerDied",self,"_player_died")
	$Sprite.frame = START_FRAME
	health = maxHealth
	$HealthBar.max_value = maxHealth
	$HealthBar.value = health

func aggro(target):
	aggressionTarget = target

func _physics_process(delta):
	if isAggressive and aggressionTarget and not isAttacking:
		var _distance_to_target = aggressionTarget.global_position.distance_to(self.global_position)
		if _distance_to_target > 50:
			velocity = global_position.direction_to(aggressionTarget.global_position)
			var _collision = move_and_collide(velocity * SPEED * delta)
			_move()

func hurt(damage):
	if not isInvincible:
		$AnimationPlayer.play("Hurt")
		health -= damage
		$HealthBar.value = health
		if health <= 0:
			$AnimationPlayer.play("Die")

func die():
	GameManager.emit_signal("enemyDied",self.get_parent(),self.position)
	stage.emit_signal("bossDied")
	queue_free()

func _on_PumpkinKing_tree_entered():
	stage = self.get_parent().get_parent()

func _player_died():
	aggressionTarget = null

func _move():
	if isInvincible:
		# necessary to prevent animation conflicts between Hurt and Fly
		return 
	
	var degrees : float = rad2deg(velocity.angle_to(Vector2(1,0)))
	
	if (degrees >= 0 and degrees <= 45) or (degrees > -45 and degrees <= 0):
		$AnimationPlayer.play("WalkRight")
	elif degrees > 45 and degrees < 135:
		$AnimationPlayer.play("WalkUp")
	elif degrees <= -135 or degrees > 135:
		$AnimationPlayer.play("WalkLeft")
	elif degrees > -135 and degrees <= -45:
		$AnimationPlayer.play("WalkDown")

func hit():
	isAttacking = true
	$HitPlayer.play("Hit")
