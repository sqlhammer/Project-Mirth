extends Node2D

var normal = load("res://InteractionHUD/images/attack_button_normal.png")
var hover = load("res://InteractionHUD/images/attack_button_hover.png")
onready var TickObserver = get_parent().get_parent().TickObserver
onready var SingleAbilityObserver = get_parent().get_parent().SingleAbilityObserver

var isBool = true
var flash_count = 0

func _ready():
	TickObserver.register("attack",self,"tick")
	SingleAbilityObserver.register("lowerHUD",self,"toggle_placeholder")

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
	TickObserver.unregister("attack")












func toggle_placeholder():
	var is_visible = get_parent().get_node("PlaceHolderImage").visible
	get_parent().get_node("PlaceHolderImage").visible = not is_visible

func _on_SingleAbilityButton_pressed():
	SingleAbilityObserver.trigger()
