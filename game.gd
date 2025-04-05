extends Node2D
class_name Game

@onready var score_label : Label = %ScoreLabel
@onready var next_button : Button = %NextButton
@onready var system : BloodSystem = $BloodSystem
@onready var camera : Camera2D = $Camera2D

var score : int = 0

enum State {INITIAL, BLOOD_FLOWING, SCORE_ADDING, VIRUSES_APPEARING, PLAYING}
var state : State = State.INITIAL:
	set(value):
		state = value
		on_transition()


func set_state(p_state : State) -> void:
	state = p_state

func on_transition() -> void:
	match state:
		State.BLOOD_FLOWING:
			system.begin_adding_blood(system.heart.coords)
			var tween := create_tween()
			tween.tween_interval(1)
			tween.tween_callback(set_state.bind(State.PLAYING))
		State.PLAYING:
			system.clear_blood()

func _process(_delta: float) -> void:
	score_label.text = "Health score: %d" % score
	next_button.disabled = state not in [State.PLAYING, State.INITIAL]

func _ready() -> void:
	camera.position = Vector2(system.WIDTH / 2.0, system.HEIGHT / 2.0) * system.TILE_SCALE
	system.add_viruses(3)
	next_button.pressed.connect(_on_next_button_pressed)

func _on_next_button_pressed() -> void:
	state = State.BLOOD_FLOWING
	
