extends Node2D
class_name Game

@onready var score_label : Label = %ScoreLabel
@onready var next_button : Button = %NextButton
@onready var system : BloodSystem = $BloodSystem
@onready var camera : Camera2D = $Camera2D
@onready var ui : GameUI = %UI
@onready var virus_spawn_sound : AudioStreamPlayer = $VirusSpawnSound

signal complete(int)

static var game : Game
const MAX_LEVELS = 10

var score : int = 0
var current_level = 0

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
			Menu.menu.modulate = Color("red")
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
			Menu.menu.modulate = Color.GREEN
			current_level += 1
			if current_level > MAX_LEVELS:
				complete.emit(score)
				return
			system.clear_blood()
			var tween := create_tween()
			system.add_viruses(8)
			tween.tween_interval(1.2)
			tween.tween_callback(set_state.bind(State.PLAYING))
			virus_spawn_sound.play()
		State.PLAYING:
			Menu.menu.modulate = Color("white")
			system.clear_blood()
			system.actions_left = 3

func _process(_delta: float) -> void:
	%LevelLabel.text = "Level %d of %d" % [current_level, MAX_LEVELS] \
		if current_level > 0 else ""
	score_label.text = "Score: %d" % score
	next_button.disabled = state not in [State.PLAYING, State.INITIAL]
	%RemoveLabel.text = "Remove %d more obstacles" % system.actions_left \
		if state == State.PLAYING else ""
		

func _ready() -> void:
	game = self
	camera.position = Vector2(system.WIDTH / 2.0, system.HEIGHT / 2.0) * system.TILE_SCALE
	next_button.pressed.connect(_on_next_button_pressed)

func _on_next_button_pressed() -> void:
	state = State.BLOOD_FLOWING
	
