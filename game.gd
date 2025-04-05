extends Node2D
class_name Game

@onready var score_label : Label = %ScoreLabel
@onready var next_button : Button = %NextButton
@onready var system : BloodSystem = $BloodSystem
@onready var camera : Camera2D = $Camera2D

static var game : Game

var score : int = 0

enum State {INITIAL, BLOOD_FLOWING, SCORE_ADDING, VIRUSES_APPEARING, PLAYING}
var state : State = State.INITIAL:
	set(value):
		state = value
		on_transition()


func set_state(p_state : State) -> void:
	state = p_state

func on_transition() -> void:
	print(state)
	match state:
		State.BLOOD_FLOWING:
			system.modulate = Color("red")
			system.begin_adding_blood(system.heart.coords)
			var tween := create_tween()
			tween.tween_interval(1)
			tween.tween_callback(set_state.bind(State.SCORE_ADDING))
		State.SCORE_ADDING:
			system.evaluate()
			var tween := create_tween()
			tween.tween_interval(2)
			tween.tween_callback(set_state.bind(State.VIRUSES_APPEARING))
		State.VIRUSES_APPEARING:
			system.clear_blood()
			var tween := create_tween()
			system.add_viruses(4)
			tween.tween_callback(set_state.bind(State.PLAYING))
		State.PLAYING:
			system.modulate = Color("white")
			system.clear_blood()
			system.actions_left = 3

func _process(_delta: float) -> void:
	score_label.text = "Health score: %d" % score
	next_button.disabled = state not in [State.PLAYING, State.INITIAL]
	%RemoveLabel.text = "Remove %d more obstacles" % system.actions_left \
		if state == State.PLAYING else ""
		

func _ready() -> void:
	game = self
	camera.position = Vector2(system.WIDTH / 2.0, system.HEIGHT / 2.0) * system.TILE_SCALE
	next_button.pressed.connect(_on_next_button_pressed)

func _on_next_button_pressed() -> void:
	state = State.BLOOD_FLOWING
	
