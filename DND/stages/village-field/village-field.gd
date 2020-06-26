extends Node2D

signal bossDied

onready var spawnPoints = $SpawnPoints.get_children()

var rand = RandomNumberGenerator.new()
var boss = preload("res://enemies/pumpkin_king.tscn")

func _ready():
	var _result = GameManager.connect("enemyDied",self,"_spawn_boss")
	_result = connect("bossDied",StageManager,"end_stage",[true])
	_result = GameManager.connect("playerDied",StageManager,"end_stage",[false])
	_spawn_enemies()

func _spawn_enemies():
	var _bat = preload("res://enemies/bat.tscn")
	for point in spawnPoints:
		var _object = _bat.instance()
		_object.position = point.spawnPoint
		$YSort.add_child(_object)

func _spawn_boss(_stage, _pos):
	# Have to compare to 1, not 0, because the last enemy hasn't freed yet.
	if get_tree().get_nodes_in_group("enemy").size() == 1:
		rand.randomize()
		var n = rand.randi_range(0,spawnPoints.size()-1)
		
		var _boss = boss.instance()
		_boss.position = spawnPoints[n].position
		$YSort.add_child(_boss)
