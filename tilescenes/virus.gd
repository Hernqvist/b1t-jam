extends Node2D
class_name Virus

@onready var sprite := $Sprite2D

func _ready() -> void:
	var duration := 1.0
	var tween := create_tween()
	sprite.position = Vector2.from_angle(randf() * 100) * 100
	tween.tween_property(sprite, "position", Vector2.ZERO, duration)
