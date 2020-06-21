extends Node2D

onready var spawnPoints = $SpawnPoints.get_children()

func _ready():
	_spawn_enemies()

func _spawn_enemies():
	var _bat = preload("res://enemies/bat.tscn")
	for point in spawnPoints:
		var _object = _bat.instance()
		_object.position = point.spawnPoint
		$YSort.add_child(_object)
