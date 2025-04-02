extends Area2D
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_body_entered(_body: Node2D) -> void:
	if _body.is_in_group("player"):
		# Restart the scene
		get_tree().reload_current_scene()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
