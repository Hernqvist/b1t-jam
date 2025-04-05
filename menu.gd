extends Node2D
class_name Menu

static var menu : Menu

const GAME_SCENE := preload("res://game.tscn")
const WIN_SCENE := preload("res://win.tscn")

func on_win_done(win : Win) -> void:
	remove_child(win)
	win.queue_free()
	start_game()

func start_win_screen(score : int) -> void:
	var win := WIN_SCENE.instantiate()
	win.new_score = score
	win.play_again.connect(on_win_done.bind(win))
	add_child(win)
	

func on_game_done(score: int, game : Game) -> void:
	remove_child(game)
	game.queue_free()
	start_win_screen(score)

func start_game() -> void:
	modulate = Color.WHITE
	var game := GAME_SCENE.instantiate()
	game.complete.connect(on_game_done.bind(game))
	add_child(game)
	

func _ready() -> void:
	menu = self
	start_game()
