extends Control
class_name GameUI

const mover_scene := preload("res://score_mover.tscn")

func add_game_score(score : int) -> void:
	Game.game.score += score

func add_score_mover(from : Vector2, score : int) -> void:
	var mover := mover_scene.instantiate()
	add_child(mover)
	mover.text = "+%d" % score
	mover.position = from
	var tween := mover.create_tween()
	tween.tween_interval(0.3)
	tween.tween_property(mover, "position", $ScoreLabel.position, 1.5)
	tween.tween_callback(add_game_score.bind(score))
	tween.tween_callback(mover.queue_free)
	
