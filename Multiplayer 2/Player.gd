extends KinematicBody2D

const WALK_SPEED = 200
var velocity = Vector2()
var rand = RandomNumberGenerator.new()
var alias : String setget _alias_set, _alias_get
var master_id : int = 0

func _alias_set(new_value):
	alias = new_value
	_set_alias_label()

func _alias_get() -> String:
	return alias

func _set_alias_label():
	$Sprite/Label.text = alias

func _ready():
	pass

func sync_player(id : int, _position : Vector2, _alias : String, _frame : int, _flip_h : bool):
	Resources.player_info[id]["frame"] = _frame
	_set_sprite_frame(_get_sprite_region(_frame))
	alias = _alias
	self.position = _position
	$Sprite.set_flip_h(_flip_h)
	_set_alias_label()

func init_player(id : int):
	rand.randomize()
	var _frame : int = rand.randf_range(0,9)
	Resources.player_info[id]["frame"] = _frame
	_set_sprite_frame(_get_sprite_region(_frame))
	
	var screenSize = get_viewport().get_visible_rect().size
	var position_x = rand.randi_range(0, screenSize.x)
	var position_y = rand.randi_range(0, screenSize.y)
	self.position = Vector2(position_x,position_y)
	Resources.player_info[id]["position"] = self.position
	Resources.player_info[id]["flip_h"] = $Sprite.flip_h
	
	_set_alias_label()

func _physics_process(_delta):
	if master_id == get_tree().get_network_unique_id():
		var previous_flip_h = $Sprite.flip_h
		
		if Input.is_action_pressed("ui_left"):
			velocity.x = -WALK_SPEED
			$Sprite.set_flip_h( true )
			Resources.player_info[master_id]["flip_h"] = $Sprite.flip_h
		elif Input.is_action_pressed("ui_right"):
			velocity.x =  WALK_SPEED
			$Sprite.set_flip_h( false )
			Resources.player_info[master_id]["flip_h"] = $Sprite.flip_h
		else:
			velocity.x = 0
	
		if Input.is_action_pressed("ui_up"):
			velocity.y = -WALK_SPEED
		elif Input.is_action_pressed("ui_down"):
			velocity.y =  WALK_SPEED
		else:
			velocity.y = 0
		
		if velocity == Vector2(0,0) and previous_flip_h == $Sprite.flip_h:
			return
		
		var _result = move_and_slide(velocity)
		Resources.player_info[master_id]["position"] = self.position
		
		for player in Resources.player_info:
			if not player == get_tree().get_network_unique_id():
				rpc_unreliable_id(player
						,"sync_player_position"
						,master_id
						,self.position
						,$Sprite.flip_h)

remote func sync_player_position(id : int, _position : Vector2, _flip_h : bool):
	if master_id == id:
		Resources.player_info[master_id]["position"] = self.position
		self.position = _position
		$Sprite.set_flip_h(_flip_h)

func _set_sprite_frame(rect):
	$Sprite.set_region_rect(rect)

func _get_sprite_region(frame) -> Rect2:
	match frame:
		0:
			return Rect2(17,16,30,24)
		1:
			return Rect2(56,9,26,31)
		2:
			return Rect2(9,52,37,34)
		3:
			return Rect2(55,51,28,45)
		4:
			return Rect2(18,10,33,32)
		5:
			return Rect2(61,10,19,27)
		6:
			return Rect2(17,15,32,33)
		7:
			return Rect2(56,15,29,35)
		8:
			return Rect2(15,19,41,22)
		9:
			return Rect2(64,20,24,19)
	
	return Rect2(17,16,30,24)
