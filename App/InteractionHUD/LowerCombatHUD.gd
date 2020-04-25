extends Node2D

var normal = load("res://InteractionHUD/images/attack_button_normal.png")
var hover = load("res://InteractionHUD/images/attack_button_hover.png")
onready var Observer = get_parent().get_parent().Observer

var isBool = true
var flash_count = 0

func _ready():
	Observer.register("attack",self)

func tick():
	if flash_count == 10:
		unregister()
	
	if isBool:
		$Attack/TextureButton.set_normal_texture(normal)
	else:
		$Attack/TextureButton.set_normal_texture(hover)
	
	isBool = !isBool
	flash_count = flash_count + 1

func unregister():
	#Observer.unregister("attack")
	queue_free()
