extends Area2D

@onready var sprite = $AnimatedSprite2D
@onready var collision = $CollisionShape2D

var is_picked_up = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_picked_up:
		print("Key picked up!")
		is_picked_up = true
		# Tell the player they have the key
		body.has_key = true
		# Remove the key from the scene
		queue_free()
