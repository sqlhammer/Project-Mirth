extends KinematicBody2D

enum ENEMY_FACING {
	UNKNOWN,
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

export var enemyFacing : int = ENEMY_FACING.DOWN
export var isInvincible : bool = false
export var isAggressive : bool = true

const SPEED : int = 60
const START_FRAME = 6
const START_ANIMATION = "FlyDown"
const MAX_HEALTH = 10

var health : float = MAX_HEALTH
var aggressionTarget : Node = null
var rand = RandomNumberGenerator.new()
var velocity = Vector2(0,0)

func _ready():
	var _result = GameManager.connect("playerDied",self,"_player_died")
	_fly_in_place()
	$HealthBar.max_value = MAX_HEALTH
	$HealthBar.value = MAX_HEALTH

func _on_HurtBox_area_shape_entered(_area_id, area, _area_shape, _self_shape):
	if area.has_method("hit"):
		area.hit(self)

func hurt(damage):
	if not isInvincible:
		$AnimationPlayer.play("Hurt")
		health -= damage
		$HealthBar.value = health
		if health <= 0:
			$AnimationPlayer.play("Die")

func die():
	isAggressive = false
	GameManager.emit_signal("enemyDied",self.get_parent(),self.position)
	queue_free()

func _fly_in_place():
	$Sprite.visible = true
	$HealthBar.visible = true
	$HurtSprite.visible = false
	$DeathSprite.visible = false
	$Sprite.frame = START_FRAME
	$AnimationPlayer.play(START_ANIMATION)

func aggro(target):
	aggressionTarget = target

func _physics_process(delta):
	if isAggressive and aggressionTarget:
		var _distance_to_target = aggressionTarget.global_position.distance_to(self.global_position)
		if _distance_to_target > 35:
			velocity = global_position.direction_to(aggressionTarget.global_position)
			var _collision = move_and_collide(velocity * SPEED * delta)
			_fly()

func _fly():
	if isInvincible:
		# necessary to prevent animation conflicts between Hurt and Fly
		return 
	
	var degrees : float = rad2deg(velocity.angle_to(Vector2(1,0)))
	
	if (degrees >= 0 and degrees <= 45) or (degrees > -45 and degrees <= 0):
		$AnimationPlayer.play("FlyRight")
	elif degrees > 45 and degrees < 135:
		$AnimationPlayer.play("FlyUp")
	elif degrees <= -135 or degrees > 135:
		$AnimationPlayer.play("FlyLeft")
	elif degrees > -135 and degrees <= -45:
		$AnimationPlayer.play("FlyDown")

func _player_died():
	aggressionTarget = null


