extends Node2D

onready var Main = get_parent().get_parent()
onready var TickObserver = Main.TickObserver
onready var AbilityTypeObserver = Main.AbilityTypeObserver
onready var CombatHUD = get_parent()
onready var Attack = load("res://InteractionHUD/Attack.gd").new()

onready var Enemies = CombatHUD.Enemies
onready var SelectedEnemy

var attack_recharge_delay = 0

func _ready():
	Attack.init("basic")
	$Attack/Charge.max_value = Attack.charge_time
	
	TickObserver.subscribe("player_attack",self,"charge_tick",{})
	
	#get first enemy
	for enemy in Enemies:
		SelectedEnemy = Enemies[enemy]
		break

func _on_Attack_Button_pressed():
	Attack.attack(SelectedEnemy)

func charge(time):
	Attack.charge(time)
	$Attack/Charge.value = Attack.current_charge_time

func charge_tick():
	var time = Main.get_node("Ticker").wait_time
	charge(time)
