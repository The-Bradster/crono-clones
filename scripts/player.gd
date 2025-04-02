extends CharacterBody2D

@onready var sprite = $AnimatedSprite2D

const SPEED = 150.0
const JUMP_VELOCITY = -300.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		# Play jumping animation when moving upward, falling animation when moving downward
		if velocity.y < 0 and sprite.animation != "jump":
			sprite.play("jump")
		elif velocity.y > 0 and sprite.animation != "jump_fall":
			sprite.play("jump_fall")

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sprite.play("jump")

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * SPEED
		# Flip the sprite based on movement direction
		sprite.flip_h = direction < 0
		# Play running animation when moving on the ground
		if is_on_floor() and sprite.animation != "run":
			sprite.play("run")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		# Play idle animation when standing still on the ground
		if is_on_floor() and sprite.animation != "idle":
			sprite.play("idle")

	move_and_slide()
