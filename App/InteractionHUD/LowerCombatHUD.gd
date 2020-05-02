extends Node2D

##### VARIABLES #####

onready var Main = get_tree().get_root().get_node("Main")

onready var Abilities = {}

onready var Combat_HUD = get_parent()
onready var Enemies = Combat_HUD.Enemies
onready var Selected_Enemy

##### PROCESS #####

func _ready():
	var basic_attack = load("res://InteractionHUD/Ability.gd").new()
	basic_attack.init("basic",$Attack/Charge)
	Abilities["basic_attack"] = basic_attack
	
	var heavy_attack = load("res://InteractionHUD/Ability.gd").new()
	heavy_attack.init("heavy",$SingleAbility/Charge)
	Abilities["heavy_attack"] = heavy_attack
	
	Main.connect("Observer_Tick", self, "charge_tick")


##### FUNCTIONS #####

func print_type(args):
	for i in args:
		print (i)

func attack(ability):
	ability.attack(Selected_Enemy)

func charge(instance,progress,time):
	instance.charge(time)
	progress.value = instance.Charge_Time_Current

func charge_tick():
	var time = Main.get_node("Ticker").wait_time
	for ability in Abilities:
		charge(Abilities[ability],Abilities[ability].Progress,time)

func set_bar_color(instance, progress):
	var style = progress.get("custom_styles/fg")
	var green = Color(0, 255, 0)
	var red = Color(255, 0, 0)
	
	#print (instance.ability_type + " " + str(instance.is_charged()))
	
	if instance.is_charged():
		style.bg_color = green
	else:
		style.bg_color = red

##### EVENTS #####

func _on_Attack_Charge_value_changed(_value):
	set_bar_color(Abilities["basic_attack"],Abilities["basic_attack"].Progress)

func _on_Single_Ability_Charge_value_changed(_value):
	set_bar_color(Abilities["heavy_attack"],Abilities["heavy_attack"].Progress)

func _on_Attack_Button_pressed():
	attack(Abilities["basic_attack"])

func _on_Single_Ability_Button_pressed():
	attack(Abilities["heavy_attack"])
