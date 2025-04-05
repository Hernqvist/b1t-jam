extends Node2D
class_name BoardEntity

@export var width : int = 1
@export var height : int = 1

var system : BloodSystem
var coords : Vector2i

func init(p_system : BloodSystem) -> void:
	system = p_system
	coords = system.to_tile(global_position)
	for x in range(width):
		for y in range(height):
			system.protected[coords + Vector2i(x, y)] = null
