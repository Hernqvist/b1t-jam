extends Node2D
class_name HoverMarker

@onready var cross : Node2D = $Cross
var light : bool = false
var active : bool = true


func _process(delta: float) -> void:
	cross.visible = active


func _on_timer_timeout() -> void:
	light = !light
	cross.modulate = Color.WHITE if light else Color.BLACK
