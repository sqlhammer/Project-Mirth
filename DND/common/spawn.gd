extends Area2D

var rand = RandomNumberGenerator.new()
var spawnPoint

func _ready():
	rand.randomize()
	var _radius = $approved_spawn_area.shape.radius
	var _x = rand.randf_range(-_radius, _radius)
	var _y = rand.randf_range(-_radius, _radius)
	
	$spawn_point.position = Vector2(_x,_y)
	spawnPoint = $spawn_point.global_position

# TODO: Need to solve for when parts of the spawn zone are over unauthorized areas.
