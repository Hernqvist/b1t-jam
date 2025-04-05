extends BoardEntity
class_name Organ

@export var score_value : int = 1

func evaluate() -> void:
	var has_blood = system.gc(coords) == BloodSystem.Tile.BLOOD
	if has_blood:
		Game.game.score += score_value
