extends Node2D

var Pad = 15
onready var Enemy_Rect

func _ready():
	reset()

func reset():
	Enemy_Rect = get_parent().rect_size
	size_sprites()
	position_sprites()
	size_label()
	position_label()

func size_sprites():
	size_sprite()
	size_card()

func position_label():
	$Label.rect_position.x = Pad
	$Label.rect_position.y = Enemy_Rect.y - Pad - $Label.rect_size.y

func size_label():
	var height = (Enemy_Rect.y * 0.20) - Pad
	var width = Enemy_Rect.x - (Pad * 2)
	
	var s = Vector2()
	s.x = width
	s.y = height
	$Label.rect_size = s

func size_sprite():
	var height = (Enemy_Rect.y * 0.60) - Pad
	var width = Enemy_Rect.x - (Pad * 2)
	
	var s = Vector2()
	s.x = width/$Sprite.get_rect().size.x
	s.y = height/$Sprite.get_rect().size.y
	$Sprite.scale = s

func size_card():
	var s = Vector2()
	s.x = Enemy_Rect.x/$Card.get_rect().size.x
	s.y = Enemy_Rect.y/$Card.get_rect().size.y
	$Card.scale = s

func position_sprites():
	$Sprite.position.x = Pad
	$Sprite.position.y = Pad
