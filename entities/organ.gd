extends BoardEntity
class_name Organ

@export var score_value : int = 1

func evaluate() -> void:
	var has_blood = system.gc(coords) == BloodSystem.Tile.BLOOD
	if has_blood:
		var screen_pos = get_canvas_transform() * global_position
		Game.game.ui.add_score_mover(screen_pos, score_value)
