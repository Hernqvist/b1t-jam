extends CanvasLayer
class_name Win

signal play_again

const PATH := "user://score.cfg"
const SECTION := "A"
const KEY := "highscore"

@onready var button : Button = %Button
var new_score : int = 0

func _ready() -> void:
	button.pressed.connect(play_again.emit)
	var highscore = 0
	
	var config := ConfigFile.new()
	var err = config.load(PATH)
	if err == OK:
		highscore = config.get_value(SECTION, KEY)
	
	highscore = max(highscore, new_score)
	
	%NewScore.text = "Score: %d" % new_score
	%HighScore.text = "Highscore: %d" % highscore
	
	config.set_value(SECTION, KEY, highscore)
	config.save(PATH)
	
func _process(_delta: float) -> void: 
	Menu.menu.modulate = Color.YELLOW
	$Control.modulate = Menu.menu.modulate
