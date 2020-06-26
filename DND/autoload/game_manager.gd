extends Node

signal enemyDied(stage, pos)
signal playerDied

var player
var rand = RandomNumberGenerator.new()

var killsSinceLastOrb = 0
const ORB_CHANCE = 1 # 1 = no modification (50/50)
const ORB_KILL_THRESHOLD = 2

func _ready():
	var _result = connect("enemyDied",self,"drop_orb")

func drop_orb(stage_YSort, pos):
	killsSinceLastOrb += 1
	
	if killsSinceLastOrb >= ORB_KILL_THRESHOLD:
		rand.randomize()
		var _rnd = rand.randf_range(0,100) / 100
		var _int = round(_rnd * ORB_CHANCE)
		var _drop_orb : bool = bool(_int)
		if _drop_orb:
			var orb = load("res://common/health_orb.tscn").instance()
			orb.position = pos
			stage_YSort.add_child(orb)
			killsSinceLastOrb = 0

