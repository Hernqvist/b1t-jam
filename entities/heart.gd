extends BoardEntity
class_name Heart

@onready var animated_sprite : AnimatedSprite2D = $AnimatedSprite2D

func start_beating() -> void:
		animated_sprite.play()
		
func stop_beating() -> void:
		animated_sprite.stop()
