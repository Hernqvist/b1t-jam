extends Node2D
class_name Game

@onready var score_label : Label = %ScoreLabel
@onready var next_button : Button = %NextButton
@onready var system : BloodSystem = $BloodSystem

var score : int = 0

enum State {BLOOD_FLOWING, VIRUSES_APPEARING, PLAYING}
var state : State = State.PLAYING

func _process(_delta: float) -> void:
	score_label.text = "Health score: %d" % score
	next_button.disabled = state != State.PLAYING
