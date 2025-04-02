extends Area2D
@onready var timer: Timer = $Timer


# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.



func _on_body_entered(body: Node2D) -> void:
	print("deez")
	timer.start()

func _on_timer_timeout() -> void:
	get_tree().reload_current_scene()
