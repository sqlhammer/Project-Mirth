extends KinematicBody2D

signal playerDied

enum PLAYER_FACING {
	UNKNOWN,
	UP,
	DOWN,
	LEFT,
	RIGHT,
}

var velocity = Vector2()
export var isAttacking : bool = false
export var playerFacing : int = PLAYER_FACING.DOWN
export var isInvincible : bool = false

export var damage : float
export var maxHealth : float
var stunned = false

const WALK_SPEED : int = 100

# Walk Sprite frame numbers
const STOPPED_FACING_UP : int = 0
const STOPPED_FACING_LEFT : int = 9
const STOPPED_FACING_DOWN : int = 18
const STOPPED_FACING_RIGHT : int = 27

onready var health : float = maxHealth

func _ready():
	GameManager.player = self
	var _result = connect("playerDied",StageManager,"end_stage",[false])
	
	$Walk.visible = true
	$Slash.visible = false
	$HitPivot/HitBox.damage = damage
	$HealthBar.max_value = maxHealth
	$HealthBar.value = maxHealth

func _physics_process(delta):
	# disallow movement and the movement animations during an attack
	if isAttacking:
		return
	
	if stunned:
		return
	
	_move(delta)
	_attack()
	_stand_still()

func _attack():
	if Input.is_action_pressed("attack_basic"):
		_play_animation()

func hurt(_damage):
	if not isInvincible:
		isInvincible = true
		$HurtSprite.visible = true
		$HurtTimer.start()
		health -= _damage
		$HealthBar.value = health
		if health <= 0:
			die()

func _move(delta):
	var _left = int(Input.is_action_pressed("move_left"))
	var _right = int(Input.is_action_pressed("move_right"))
	var _up = int(Input.is_action_pressed("move_up"))
	var _down = int(Input.is_action_pressed("move_down"))
	
	velocity.x = _right - _left
	velocity.y = _down - _up
	velocity = velocity.normalized() * WALK_SPEED * delta
	
	if velocity != Vector2(0,0):
		_play_animation()
		var _collision = move_and_collide(velocity)
#		if collision:
#			velocity = velocity.slide(collision.normal)
#			var _velocity = move_and_slide(velocity)
#			pass

func _play_animation():
	if Input.is_action_pressed("move_left"):
		$AnimationPlayer.play("WalkLeft")
	elif Input.is_action_pressed("move_right"):
		$AnimationPlayer.play("WalkRight")
	elif Input.is_action_pressed("move_down"):
		$AnimationPlayer.play("WalkDown")
	elif Input.is_action_pressed("move_up"):
		$AnimationPlayer.play("WalkUp")
	
	if Input.is_action_pressed("attack_basic"):
		isAttacking = true # necessary to set this outside of animation
		match playerFacing:
			PLAYER_FACING.DOWN:
				$AnimationPlayer.play("SlashDown")
			PLAYER_FACING.UP:
				$AnimationPlayer.play("SlashUp")
			PLAYER_FACING.RIGHT:
				$AnimationPlayer.play("SlashRight")
			PLAYER_FACING.LEFT:
				$AnimationPlayer.play("SlashLeft")

func _is_moving() -> bool:
	var _is_moving = false
	
	if Input.is_action_pressed("move_left"):
		_is_moving = true
	elif Input.is_action_pressed("move_right"):
		_is_moving = true
	elif Input.is_action_pressed("move_down"):
		_is_moving = true
	elif Input.is_action_pressed("move_up"):
		_is_moving = true
	
	return _is_moving

func _stop_animation():
	if $AnimationPlayer.is_playing() and not isAttacking:
		$AnimationPlayer.stop(true)

func _stand_still():
	if not _is_moving() and not isAttacking:
		_stop_animation()
		match playerFacing:
			PLAYER_FACING.UP:
				$Walk.frame = STOPPED_FACING_UP
			PLAYER_FACING.DOWN:
				$Walk.frame = STOPPED_FACING_DOWN
			PLAYER_FACING.LEFT:
				$Walk.frame = STOPPED_FACING_LEFT
			PLAYER_FACING.RIGHT:
				$Walk.frame = STOPPED_FACING_RIGHT

func _on_HurtTimer_timeout():
	$HurtSprite.visible = false
	isInvincible = false

func heal(_health) -> bool:
	var _accepted = false
	
	if health < maxHealth:
		health += _health
		health = clamp(health,0,maxHealth)
		$HealthBar.value = health
		_accepted = true
	
	return _accepted

func die():
	stunned = true
	$AnimationPlayer.play("Die")

func _death_complete():
	GameManager.emit_signal("playerDied")


